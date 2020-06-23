Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5AE205633
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 17:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732981AbgFWPlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 11:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732953AbgFWPlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 11:41:32 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1FCC061573
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 08:41:31 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id d21so9841884lfb.6
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 08:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8EW9CUhccL2ErdRx17qCssxvDAc9oVS3YR0zNYwgmvM=;
        b=A5bGfukW4rEMApWGnfaVhV80isdADwT9ammeZZs1BkF0SjEY9oQg9qL7Aw87BfcNnM
         m5IY/M4fYvEklKrIo5RsfkgXf3PBLYu9AcgJMAjJOP+LE2fxWQJgqteNmwP4tem95zTU
         aWywfY17Q1iNKf3gPTDtpZaliftBv+tKV+J4SEFaApM3CafVBGCbdipijsHb3y2SeSFg
         67EAnFX1ZNcMbZHKOhifYRogGhVqcaZslqLWIr/JgFOcU/gYTi9StSNVbUKl6t23OQES
         jmcE1YaW5b1kmmIC3647hxG8RfLtaHIH3+9ce+75cz71Xw4mM2Gie7MyuE9mczZRGUAq
         awCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8EW9CUhccL2ErdRx17qCssxvDAc9oVS3YR0zNYwgmvM=;
        b=aA66psqbZJLslARPoRcitWJBrrPCmYicXM2NiwImOA9gvqEEwrpbWYHW4Oxw4bsple
         E/OZc+HNHOxt9GUH0iJVaRAIy92o4H3gT7fPXKbXe5Wd7ObKMlUIwOV6PUJl1WnMmGxl
         yMaRV/KYf9xOWMNQMS79KYp1joId2zzCxO0KDJ32EG8XS6e2zwmSZrvV2yds0OtWQKYJ
         d8BXdrWTgo9rVEhcKzNfWHWmJ+0KQZ0vPi+j2OK4L7EXO1mtYZFNBm7FjsShlIZuqw6D
         9vSwWPqyAb3IaW3s5qce9CjjArSlgSj7Py6Ora++5hpxMRBWom+yXFWFOyro/HtYYmMT
         1Uig==
X-Gm-Message-State: AOAM53394B5IAawtUFxU+QhMfcbDlHgrZiQSVHyqua7zBXnd5ELOGdzU
        dodzhTLMfcnHG/7VOR3JM+2kfId+AZHT2A9vubGXZT/FQz+/+w==
X-Google-Smtp-Source: ABdhPJwp6rdNidyFiB5JqWv4asQcgVnKzKjE4i/WkBWzySxCPSb1sK+tEffIUQpLss893LbfzHXAs9OQgaJOXLwFOKE=
X-Received: by 2002:a05:6512:31c5:: with SMTP id j5mr13146327lfe.26.1592926889545;
 Tue, 23 Jun 2020 08:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200618011631.604574-1-sashal@kernel.org> <20200618011631.604574-219-sashal@kernel.org>
In-Reply-To: <20200618011631.604574-219-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Jun 2020 21:11:18 +0530
Message-ID: <CA+G9fYsV1wWyKF3Gs9FwBRxCAgEGrmVjT0zmrrHj9x0WKLQPEw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 219/266] ovl: verify permissions in ovl_path_open()
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-unionfs@vger.kernel.org, lkft-triage@lists.linaro.org,
        LTP List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Jun 2020 at 06:51, Sasha Levin <sashal@kernel.org> wrote:
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
> index f5678a3f8350..eb325322a893 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -475,7 +475,32 @@ bool ovl_is_whiteout(struct dentry *dentry)
>
>  struct file *ovl_path_open(struct path *path, int flags)
>  {
> -       return dentsteps to reproduce:
          - cd /opt/ltp
          - ./runltp -s execveat03ry_open(path, flags | O_NOATIME,
current_cred());
> +       struct inode *inode = d_inode(path->dentry);
> +       int err, acc_mode;
> +
> +       if (flags & ~(O_ACCMODE | O_LARGEFILE))
> +               BUG();

This BUG: triggered on stable-rc 5.7, 5.4, 4.19 and 4.14 on arm64 architecture.

steps to reproduce:
          - cd /opt/ltp
          - ./runltp -s execveat03

[  461.024389] ------------[ cut here ]------------
[  461.029029] kernel BUG at fs/overlayfs/util.c:482!
[  461.033832] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[  461.039328] Modules linked in: overlay rfkill tda998x
drm_kms_helper drm crct10dif_ce fuse
[  461.047637] CPU: 2 PID: 15049 Comm: execveat03 Not tainted
5.4.49-rc1-00549-g1d94fa9fbd5f #1
[  461.056093] Hardware name: ARM Juno development board (r2) (DT)
[  461.062026] pstate: 60000005 (nZCv daif -PAN -UAO)
[  461.066879] pc : ovl_path_open+0xc4/0xc8 [overlay]
[  461.071723] lr : ovl_path_open+0x2c/0xc8 [overlay]
[  461.076521] sp : ffff0008d9d578d0
[  461.079841] x29: ffff0008d9d578d0 x28: ffff00090821186c
[  461.085167] x27: ffff000908211800 x26: ffff000902fc7000
[  461.090493] x25: ffffa0000956e800 x24: ffff000902fc7540
[  461.095818] x23: ffff0008d9d57b80 x22: ffff00091149c880
[  461.101143] x21: ffff0008d9d57b80 x20: ffff0008dd24cb10
[  461.106467] x19: 0000000000004000 x18: 0000000000000000
[  461.111791] x17: 0000000000000000 x16: 0000000000000000
[  461.117114] x15: 0000000000000000 x14: ffffa00010395a3c
[  461.122439] x13: ffffa00010394ff0 x12: ffff80011baea816
[  461.127763] x11: 1fffe0011baea815 x10: ffff80011baea815
[  461.133087] x9 : dfffa00000000000 x8 : 0000000000000001
[  461.138411] x7 : ffff0008dd7540a8 x6 : 00000000f1f1f1f1
[  461.143735] x5 : 00000000f3000000 x4 : 000000000000002d
[  461.149059] x3 : dfffa00000000000 x2 : 0000000000000007
[  461.154383] x1 : 0000000000004000 x0 : 0000000000000000
[  461.159706] Call trace:
[  461.162201]  ovl_path_open+0xc4/0xc8 [overlay]
[  461.166697]  ovl_check_d_type_supported+0x98/0x178 [overlay]
[  461.172410]  ovl_fill_super+0x8b4/0x1c78 [overlay]
[  461.177215]  mount_nodev+0x4c/0xb8
[  461.180665]  ovl_mount+0x18/0x20 [overlay]
[  461.184772]  legacy_get_tree+0x70/0xb8
[  461.188531]  vfs_get_tree+0x48/0x158
[  461.192116]  do_mount+0x6f8/0xb38
[  461.195438]  ksys_mount+0x8c/0xe8
[  461.198762]  __arm64_sys_mount+0x64/0x80
[  461.202697]  el0_svc_common.constprop.0+0xa0/0x1d0
[  461.207500]  el0_svc_handler+0x34/0x98
[  461.211256]  el0_svc+0x8/0xc
[  461.214150] Code: f94013f5 a8c37bfd d65f03c0 d4210000 (d4210000)
[  461.220258] ---[ end trace 13147ca9b270cd0f ]---
[  461.224884] note: execveat03[15049] exited with preempt_count 1
[  461.233327] ------------[ cut here ]------------
[  461.237984] WARNING: CPU: 2 PID: 0 at kernel/rcu/tree.c:569
rcu_idle_enter+0xc4/0xd0
[  461.245742] Modules linked in: overlay rfkill tda998x
drm_kms_helper drm crct10dif_ce fuse
[  461.254052] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D
  5.4.49-rc1-00549-g1d94fa9fbd5f #1
[  461.263465] Hardware name: ARM Juno development board (r2) (DT)
[  461.269397] pstate: 20000085 (nzCv daIf -PAN -UAO)
[  461.274200] pc : rcu_idle_enter+0xc4/0xd0
 [  461.278224] lr : rcu_idle_enter+0x30/0xd0
[  461.282397] sp : ffff000935577e90
[  461.285715] x29: ffff000935577e90 x28: 0000000000000000
[  461.291202] x27: ffff00091330b800 x26: ffffa0001309e220
Broadcast message from systemd-jo[  461.296528] x25: ffff00093554ba00
x24: 1fffe00126aaefe4
urnald@juno (Tue 2020-06-23 03:3[  461.304710] x23: ffffa00012227c38
x22: ffffa0001309e1f8
3:27 UTC):
[  461.312810] x21: ffff0009366edc98 x20: ffffa00012231bc0
[  461.319253] x19: ffff0009366edbc0 x18: 0000000000000000
[  461.324576] x17: 0000000000000000 x16: 0000000000000000
[  461.329973] x15: 0000000000000000 x14: ffffa0001009d8c0
[  461.335298] x13: ffffa00010395afc x12: ffff800126cddb24
[  461.340784] x11: 1fffe00126cddb23 x10: ffff800126cddb23
kernel[310]: [  461.033832] Inter[  461.346109] x9 : dfffa00000000000
x8 : 0000000000000001
nal error: Oops - BUG: 0 [#1] PR[  461.354293] x7 : ffff0009366ed91b
x6 : ffff0009366ed918
EEMPT SMP
[  461.362392] x5 : 00007ffed93224dd x4 : 000000000000002d
[  461.368747] x3 : dfffa00000000000 x2 : 0000000000000007
[  461.374071] x1 : 4000000000000002 x0 : 4000000000000000
[  461.379468] Call trace:
[  461.381922]  rcu_idle_enter+0xc4/0xd0
[  461.385755]  do_idle+0x27c/0x320
exit01      1  TPASS  :  exit() t[  461.388992]  cpu_startup_entry+0x20/0x40
est PASSED[  461.395788]  secondary_start_kernel+0x250/0x2b8
[  461.401184] ---[ end trace 13147ca9b270cd10 ]---

test link,
https://lkft.validation.linaro.org/scheduler/job/1516380#L3866

metadata:
  git branch: linux-5.4.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git commit: 1d94fa9fbd5f0a775217d4180270dae8cede3f92
  git describe: v5.4.47-549-g1d94fa9fbd5f
  make_kernelversion: 5.4.49-rc1
  kernel-config:
https://builds.tuxbuild.com/-hEoWZbVgbGrYjKHXXPiuQ/kernel.config
  build-url: https://gitlab.com/Linaro/lkft/kernel-runs/-/pipelines/158927561


-- 
Linaro LKFT
https://lkft.linaro.org
