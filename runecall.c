#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define RUNES_DIR "%s/.config/runes"

static const char *languages[] = {
    "c", "cpp", "javascript", "python", "rust", "go", "elixir", NULL
};

static const char *env_map[] = {
    "C", "C++", "JavaScript", "Python", "Rust", "Go", "Elixir", NULL
};

static const char *dir_map[] = {
    ".croc", ".hydra", ".bun", ".waves", ".ratatuya", ".goose", ".elix", NULL
};

static int copy_dir(const char *src, const char *dst) {
    char *cmd;
    if (asprintf(&cmd, "cp -r \"%s\" \"%s\"", src, dst) < 0)
        return 0;
    int ret = system(cmd);
    free(cmd);
    return ret == 0;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("❌ Unknown language\n\nAvailable runes:\n");
        for (int i = 0; languages[i]; i++)
            printf("  • %s\n", languages[i]);
        return 1;
    }

    const char *lang = argv[1];
    int idx = -1;
    for (int i = 0; languages[i]; i++) {
        if (strcmp(lang, languages[i]) == 0) {
            idx = i;
            break;
        }
    }

    if (idx == -1) {
        printf("❌ Unknown language: %s\n", lang);
        return 1;
    }

    const char *home = getenv("HOME");
    if (!home) {
        fprintf(stderr, "💥 HOME not set\n");
        return 1;
    }

    char *root;
    if (asprintf(&root, RUNES_DIR, home) < 0) {
        perror("asprintf");
        return 1;
    }

    char *src;
    if (asprintf(&src, "%s/%s/%s", root, env_map[idx], dir_map[idx]) < 0) {
        perror("asprintf");
        free(root);
        return 1;
    }
    free(root);

    char cwd[4096];
    if (!getcwd(cwd, sizeof(cwd))) {
        perror("getcwd");
        free(src);
        return 1;
    }

    if (copy_dir(src, cwd)) {
        printf("🪄 Summoned %s for %s\n", dir_map[idx], lang);
    } else {
        printf("💥 Failed to summon rune (source: %s)\n", src);
        free(src);
        return 1;
    }

    free(src);
    return 0;
}
