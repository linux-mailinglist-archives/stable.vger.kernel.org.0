Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB822055CC
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 17:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733035AbgFWPZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 11:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733031AbgFWPZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 11:25:53 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73356C061795
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 08:25:53 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id k15so4880304lfc.4
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 08:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wu5Jb22ItoXjx67uBh26qW7KZs2/G12nEiorIVjh8pI=;
        b=mgVgpJ6YC03VthawpjYHmfyp8oolEBSV1hoHPj8jhCmOLnVFxwKmbF+g1LystfT7Dr
         MEK1SnLgbEtVFsxFVG89/ABB6xzQoqY0arQIWsrIz97UJt2h5cZba0Ql+ICwN6N1CKx5
         dXoGx56T1M++ZEdNgMmT0sukslSIV2cjvHNibaI8+X73zoN5QUk7lLBN/4qs2DMPXzJ4
         x7w7U1h/eLRM7Fs91V/SdLsFZxIE6hc2uAKLJBgmPUbXzpyFXHoSOcCXwDWiiebsnWQy
         INCvf/G2wpTOU65Y8YnMVG3nJ2lq0zCpWLh1UZ1Ioo3B+3hrE/pvw6vuDtv3IXox/i/v
         q0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wu5Jb22ItoXjx67uBh26qW7KZs2/G12nEiorIVjh8pI=;
        b=TJZt+3rUYua6DD1WE7YmSxo6NqmWsR0mmGLrUU/3gSqyDbOEQgz7hpMNRgg+z65fP8
         rWRWyIQCW+tAeYtC0b28QX2Lvkl/2TgZjnYTzgnt6nfIvvR64NyH3p7u8ED7DozmXoD8
         1I2LdAASvl4mdzOVABQQuQ2eEdSBUYcJppRnA32+O+yl8ZCfcQd6Rl4bYi0X+BXc5zIy
         6Ce/rikjqcDlprGu19auiQiWuRpcqaWs+svgZaN/SjIUTa1Pr48FE5h7I6nNhaqmGOC4
         bIZtwmUBUY99pjRNKTxHFl0hE/5uBHGEkWpfv6Ak8cRlvV7WzXJuMRRyYUsjUgSDgg++
         TN3g==
X-Gm-Message-State: AOAM530baN76Ki3b6VVk/jdKeiPWYr6UcCy0y7mF0ic4bdtvuEfUu6ke
        hv8B7itgW6+3URhT8eVK7QLldqkwpkSanaOqddJWMw==
X-Google-Smtp-Source: ABdhPJz/l9dZNGfY+DnT424JHJKqrgndWlRTPhLAbD2ysBWneCN9oFPMXO8VVCGVpHKw+cmd0Z5uExPRjgFoCh0LOCc=
X-Received: by 2002:a19:2292:: with SMTP id i140mr12723588lfi.95.1592925951626;
 Tue, 23 Jun 2020 08:25:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200618012600.608744-1-sashal@kernel.org> <20200618012600.608744-90-sashal@kernel.org>
In-Reply-To: <20200618012600.608744-90-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Jun 2020 20:55:38 +0530
Message-ID: <CA+G9fYuBGRz9=Q5KyCat0qk_8aiGvNsreY05rcGSjMZpvM1FJg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 090/108] ovl: verify permissions in ovl_path_open()
To:     Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-unionfs@vger.kernel.org, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Jun 2020 at 07:18, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Miklos Szeredi <mszeredi@redhat.com>
>
> [ Upstream commit 56230d956739b9cb1cbde439d76227d77979a04d ]
>
> Check permission before opening a real file.
>
> ovl_path_open() is used by readdir and copy-up routines.
>
> ovl_permission() theoretically already checked copy up permissions, but it
> doesn't hurt to re-do these checks during the actual copy-up.
>
> For directory reading ovl_permission() only checks access to topmost
> underlying layer.  Readdir on a merged directory accesses layers below the
> topmost one as well.  Permission wasn't checked for these layers.
>
> Note: modifying ovl_permission() to perform this check would be far more
> complex and hence more bug prone.  The result is less precise permissions
> returned in access(2).  If this turns out to be an issue, we can revisit
> this bug.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/overlayfs/util.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index afdc2533ce74..76d6610767f6 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -307,7 +307,32 @@ bool ovl_is_whiteout(struct dentry *dentry)
>
>  struct file *ovl_path_open(struct path *path, int flags)
>  {
> -       return dentry_open(path, flags | O_NOATIME, current_cred());
> +       struct inode *inode = d_inode(path->dentry);
> +       int err, acc_mode;
> +
> +       if (flags & ~(O_ACCMODE | O_LARGEFILE))
> +               BUG();
> +
> +       switch (flags & O_ACCMODE) {
> +       case O_RDONLY:
> +               acc_mode = MAY_READ;
> +               break;
> +       case O_WRONLY:
> +               acc_mode = MAY_WRITE;
> +               break;
> +       default:
> +               BUG();

This BUG: triggered on stable-rc 5.7, 5.4, 4.19 and 4.14.

steps to reproduce:
          - cd /opt/ltp
          - ./runltp -s execveat03

Test output:
mke2fs 1.43.8 (1-Jan-2018)
[   47.739682] ------------[ cut here ]------------
[   47.744317] kernel BUG at fs/overlayfs/util.c:314!
[   47.749117] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[   47.754608] Modules linked in: overlay rfkill crc32_ce crct10dif_ce fuse
[   47.761335] Process execveat03 (pid: 2880, stack limit = 0xffff00000ec60000)
[   47.768397] CPU: 3 PID: 2880 Comm: execveat03 Not tainted
4.14.186-rc1-00111-gb518002db397 #1
[   47.776933] Hardware name: ARM Juno development board (r2) (DT)
[   47.782860] task: ffff8009546ade80 task.stack: ffff00000ec60000
[   47.788819] pc : ovl_path_open+0xa8/0xb0 [overlay]
[   47.793641] lr : ovl_check_d_type_supported+0x38/0xf0 [overlay]
[   47.799567] sp : ffff00000ec63ba0 pstate : 40000145
[   47.804449] x29: ffff00000ec63ba0 x28: 0000000000000000
[   47.809770] x27: ffff800955bfb710 x26: ffff800955bfb700
[   47.815091] x25: ffff00000ec63ce0 x24: 0000000000000000
[   47.820412] x23: ffff00000ec63cd0 x22: 0000000000000001
[   47.825733] x21: ffff8009509609b8 x20: ffff00000ec63ce0
[   47.831054] x19: 0000000000004000 x18: 0000000000000000
[   47.836375] x17: 0000000000000000 x16: ffff0000080d1800
[   47.841696] x15: 095a041701101c00 x14: ff00000000000000
[   47.847017] x13: 0000000000000000 x12: 000000000000000b
[   47.852338] x11: 0101010101010101 x10: ffff800950960b40
[   47.857659] x9 : 7f7f7f7f7f7f7f7f x8 : 6f2d6c6473727872
[   47.862980] x7 : 001c100117045a09 x6 : 095a041701101c00
[   47.868301] x5 : 0000000000000000 x4 : 0000000000000000
[   47.873622] x3 : 0000000000000000 x2 : ffff000000b7ec88
[   47.878943] x1 : ffff800953f78180 x0 : 0000000000004000
[   47.884264] Call trace:
[   47.886736]  ovl_path_open+0xa8/0xb0 [overlay]
[   47.891209]  ovl_check_d_type_supported+0x38/0xf0 [overlay]
[   47.896812]  ovl_fill_super+0x540/0xc98 [overlay]
[   47.901528]  mount_nodev+0x4c/0xa8
[   47.904954]  ovl_mount+0x14/0x28 [overlay]
[   47.909056]  mount_fs+0x54/0x188
[   47.912289]  vfs_kern_mount.part.0+0x4c/0x118
[   47.916651]  do_mount+0x1cc/0xbe0
[   47.919970]  compat_SyS_mount+0xb0/0x1b8
[   47.923899]  __sys_trace_return+0x0/0x4
[   47.927742] Code: f94013f5 a8c37bfd d65f03c0 d4210000 (d4210000)
[   47.933845] ---[ end trace 1b32b515dde8d9db ]---

Test link,
https://lkft.validation.linaro.org/scheduler/job/1517781#L1266

metadata:
  git branch: linux-4.14.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git commit: b518002db397b51173a3e17045bfb3ff0e1aa0ed
  kernel-config:
https://builds.tuxbuild.com/B_xCv6-0v8npcEVw6hA_ZQ/kernel.config


-- 
Linaro LKFT
https://lkft.linaro.org
