Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C4E39F6D6
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbhFHMgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:36:20 -0400
Received: from mail-il1-f175.google.com ([209.85.166.175]:44794 "EHLO
        mail-il1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbhFHMgU (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 8 Jun 2021 08:36:20 -0400
Received: by mail-il1-f175.google.com with SMTP id i17so19313582ilj.11
        for <Stable@vger.kernel.org>; Tue, 08 Jun 2021 05:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RFjaSjMQkwJHmF1f66mLNTaQ78R9sIE9PBhzCroLQMY=;
        b=o8/P5qBAwUYoUd4z6K+jAndy3R6WGes0iunS2TpqMLJXgkkdvOeBoD5oPzVNmGUJRe
         K163FAKL44Wxi6InbLRhSaAWFocm2stX6ROQwKFCVqWbQUSwGwXRVm5r71VidRZ2Qre7
         5g8S1/+M2P4zz8KAtbksDmgtMjmGaOKJVmMtDML3L5+5qvDXF7q9GOBekEwCzcYzZPFK
         BMid53OotedNPznxo4WgaIxMZbvOJcv8Z0aHYqiex/fc0rQjTUQl3WKD3Cte2N4I5mnP
         4IPRrGUHG7J4d4v94cvNsiggn9qT0iknTUryD+s5oxPGlHqJeLMQbu0nX/V8qOv7fZJY
         Qt/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RFjaSjMQkwJHmF1f66mLNTaQ78R9sIE9PBhzCroLQMY=;
        b=Bs1FpTsudtiOwjvSkeHIBlEyH0yWjNq2t1+KOhN7FZ+Xht9eSnf5uZj5FHiqiLDErK
         vQM3OsVHyYvEMIlEC1BieGea1N1TYHwID/K31wfixCEd8PuUnLjGmYnzUKkCpHCJm3vE
         Cezb1ecdIQv9SYdH7ybvD/vGm98k6dCW6C9HLOAa4yVVJpllUUlUbNRNHMA/ASlDv7n3
         UWH9pu/TJhIN1PEFXGVh+Ni1NsRA9RJ1VzLRPcjo+7D7wpp/nBS0cOcev7djItgam0CP
         PS/pmsE+QdDzY00nmqnRZ34Vj0wt/Q5YifZAP/SqG6B+h1EhCt5kOcU14CCoM3SHMVp/
         lY3w==
X-Gm-Message-State: AOAM531cmedXWxSHJOFafVfeRuAXpPIsb7Vhd6VsubILXghO4UbXBDAq
        RPN/Bv+CXqksR0oaqMObC3TJEqNxk88j8IvBtJY=
X-Google-Smtp-Source: ABdhPJyG0OKM4slE3EaJRjzmz3IxGPzXO2EFmYIzsZf9WEBqHgwUst+iBeZz1i7s/tdPbGWm5+ZNJiqIW2JKnuW2EdE=
X-Received: by 2002:a05:6e02:14a:: with SMTP id j10mr20334078ilr.250.1623155607279;
 Tue, 08 Jun 2021 05:33:27 -0700 (PDT)
MIME-Version: 1.0
References: <162315490411353@kroah.com>
In-Reply-To: <162315490411353@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 8 Jun 2021 15:33:16 +0300
Message-ID: <CAOQ4uxgeovPSfguuSWaUJT27nyMU9d3DUx9SOQ+kpC36_nj90Q@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] fanotify: fix permission model of
 unprivileged group" failed to apply to 5.12-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <Stable@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jan Kara <jack@suse.cz>, Matthew Bobrowski <repnop@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 8, 2021 at 3:21 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.12-stable tree.

I wrongly tagged this # v5.12+
It fixed a commit merge in this cycle.

Sorry for the noise.

Thanks,
Amir.

> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From a8b98c808eab3ec8f1b5a64be967b0f4af4cae43 Mon Sep 17 00:00:00 2001
> From: Amir Goldstein <amir73il@gmail.com>
> Date: Mon, 24 May 2021 16:53:21 +0300
> Subject: [PATCH] fanotify: fix permission model of unprivileged group
>
> Reporting event->pid should depend on the privileges of the user that
> initialized the group, not the privileges of the user reading the
> events.
>
> Use an internal group flag FANOTIFY_UNPRIV to record the fact that the
> group was initialized by an unprivileged user.
>
> To be on the safe side, the premissions to setup filesystem and mount
> marks now require that both the user that initialized the group and
> the user setting up the mark have CAP_SYS_ADMIN.
>
> Link: https://lore.kernel.org/linux-fsdevel/CAOQ4uxiA77_P5vtv7e83g0+9d7B5W9ZTE4GfQEYbWmfT1rA=VA@mail.gmail.com/
> Fixes: 7cea2a3c505e ("fanotify: support limited functionality for unprivileged users")
> Cc: <Stable@vger.kernel.org> # v5.12+
> Link: https://lore.kernel.org/r/20210524135321.2190062-1-amir73il@gmail.com
> Reviewed-by: Matthew Bobrowski <repnop@google.com>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
>
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 71fefb30e015..be5b6d2c01e7 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -424,11 +424,18 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
>          * events generated by the listener process itself, without disclosing
>          * the pids of other processes.
>          */
> -       if (!capable(CAP_SYS_ADMIN) &&
> +       if (FAN_GROUP_FLAG(group, FANOTIFY_UNPRIV) &&
>             task_tgid(current) != event->pid)
>                 metadata.pid = 0;
>
> -       if (path && path->mnt && path->dentry) {
> +       /*
> +        * For now, fid mode is required for an unprivileged listener and
> +        * fid mode does not report fd in events.  Keep this check anyway
> +        * for safety in case fid mode requirement is relaxed in the future
> +        * to allow unprivileged listener to get events with no fd and no fid.
> +        */
> +       if (!FAN_GROUP_FLAG(group, FANOTIFY_UNPRIV) &&
> +           path && path->mnt && path->dentry) {
>                 fd = create_fd(group, path, &f);
>                 if (fd < 0)
>                         return fd;
> @@ -1040,6 +1047,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
>         int f_flags, fd;
>         unsigned int fid_mode = flags & FANOTIFY_FID_BITS;
>         unsigned int class = flags & FANOTIFY_CLASS_BITS;
> +       unsigned int internal_flags = 0;
>
>         pr_debug("%s: flags=%x event_f_flags=%x\n",
>                  __func__, flags, event_f_flags);
> @@ -1053,6 +1061,13 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
>                  */
>                 if ((flags & FANOTIFY_ADMIN_INIT_FLAGS) || !fid_mode)
>                         return -EPERM;
> +
> +               /*
> +                * Setting the internal flag FANOTIFY_UNPRIV on the group
> +                * prevents setting mount/filesystem marks on this group and
> +                * prevents reporting pid and open fd in events.
> +                */
> +               internal_flags |= FANOTIFY_UNPRIV;
>         }
>
>  #ifdef CONFIG_AUDITSYSCALL
> @@ -1105,7 +1120,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
>                 goto out_destroy_group;
>         }
>
> -       group->fanotify_data.flags = flags;
> +       group->fanotify_data.flags = flags | internal_flags;
>         group->memcg = get_mem_cgroup_from_mm(current->mm);
>
>         group->fanotify_data.merge_hash = fanotify_alloc_merge_hash();
> @@ -1305,11 +1320,13 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
>         group = f.file->private_data;
>
>         /*
> -        * An unprivileged user is not allowed to watch a mount point nor
> -        * a filesystem.
> +        * An unprivileged user is not allowed to setup mount nor filesystem
> +        * marks.  This also includes setting up such marks by a group that
> +        * was initialized by an unprivileged user.
>          */
>         ret = -EPERM;
> -       if (!capable(CAP_SYS_ADMIN) &&
> +       if ((!capable(CAP_SYS_ADMIN) ||
> +            FAN_GROUP_FLAG(group, FANOTIFY_UNPRIV)) &&
>             mark_type != FAN_MARK_INODE)
>                 goto fput_and_out;
>
> @@ -1460,6 +1477,7 @@ static int __init fanotify_user_setup(void)
>         max_marks = clamp(max_marks, FANOTIFY_OLD_DEFAULT_MAX_MARKS,
>                                      FANOTIFY_DEFAULT_MAX_USER_MARKS);
>
> +       BUILD_BUG_ON(FANOTIFY_INIT_FLAGS & FANOTIFY_INTERNAL_GROUP_FLAGS);
>         BUILD_BUG_ON(HWEIGHT32(FANOTIFY_INIT_FLAGS) != 10);
>         BUILD_BUG_ON(HWEIGHT32(FANOTIFY_MARK_FLAGS) != 9);
>
> diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
> index a712b2aaa9ac..57f0d5d9f934 100644
> --- a/fs/notify/fdinfo.c
> +++ b/fs/notify/fdinfo.c
> @@ -144,7 +144,7 @@ void fanotify_show_fdinfo(struct seq_file *m, struct file *f)
>         struct fsnotify_group *group = f->private_data;
>
>         seq_printf(m, "fanotify flags:%x event-flags:%x\n",
> -                  group->fanotify_data.flags,
> +                  group->fanotify_data.flags & FANOTIFY_INIT_FLAGS,
>                    group->fanotify_data.f_flags);
>
>         show_fdinfo(m, f, fanotify_fdinfo);
> diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
> index bad41bcb25df..a16dbeced152 100644
> --- a/include/linux/fanotify.h
> +++ b/include/linux/fanotify.h
> @@ -51,6 +51,10 @@ extern struct ctl_table fanotify_table[]; /* for sysctl */
>  #define FANOTIFY_INIT_FLAGS    (FANOTIFY_ADMIN_INIT_FLAGS | \
>                                  FANOTIFY_USER_INIT_FLAGS)
>
> +/* Internal group flags */
> +#define FANOTIFY_UNPRIV                0x80000000
> +#define FANOTIFY_INTERNAL_GROUP_FLAGS  (FANOTIFY_UNPRIV)
> +
>  #define FANOTIFY_MARK_TYPE_BITS        (FAN_MARK_INODE | FAN_MARK_MOUNT | \
>                                  FAN_MARK_FILESYSTEM)
>
>
