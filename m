Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032372055E9
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 17:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732984AbgFWPaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 11:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732821AbgFWPaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 11:30:14 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659A2C061573
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 08:30:14 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id q19so23959012lji.2
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 08:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PqiVaw4jPZjubgC0DDl3A4Ud4fHqWecWUNTmHcI7wYY=;
        b=vwDdPU+4V/Jx8jj9smtJimFMCc+ZOTd7pnL8N1BZ9MnqEhrJ+Irm8zQNShJvIiiwAk
         +QkqKxAFa1Fvv5xfyEwYmh3RExQJs+utDDpimk8cEUmjz85gDab5zvnMBa6iaViYEaM7
         sUwGOJKbscWhH2OVdyHVgvclyNNAuknqNP9CF6xcEty3RtWUdTqijXt2OYhaetQfyIkl
         rI+XYhgMLyfFhro1zF5/ohzy+RyqoyTzf0YjB+/l0SDx+jb3SseTDTM+8SFV2P0qZ936
         Tu+73A6r8fC4hPBQ/syVbXjydP6M9anvWDb9mcXa+8JMQ0GaZ1uqWeVdEW5TqkzgkSn9
         mBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PqiVaw4jPZjubgC0DDl3A4Ud4fHqWecWUNTmHcI7wYY=;
        b=M0CCMFPXutSL2VfaKep/8p0OyoSMza/qElwtT69IUBqq2XYhY/tc1J25Sy4DIQbaZF
         pgPFHoNEMlT2OkYoxKvYKOr4JBaXFy1mIjf2Mpkphh41CZqAX4rpiugorPqN1j9ziczz
         7PdcLs0ctocE89WY0NhpurdIeq21CVSEMe4zPWUa4GxTz3smBi5DpJxIU/ytAcQsQ/TB
         NR3ZglwRzqVACU5+xhdw2IZ1f/81W/dAssycHUDXFV6DXchrEEBj5C/MgDSu0cIIeFAD
         jcXOLMWyrMzbXBtGQFVUaEQFb3UqgdcVslxym2x7UfI9/v0JtQvXMrluZ+Jw24N6n5QM
         ee2A==
X-Gm-Message-State: AOAM532wmZCFlzagMoj9/6VhNkjb4+7biOshwMBv7UOOpQk9Yc1xme+e
        nh7kcJvH/i89c1FAykYnCRlYSBmlwpwEOTKKVWAJXA==
X-Google-Smtp-Source: ABdhPJwHuGnHF3srvzs44T4PM1YgndBxneWCi01kR9Fc5pSBEwosEz8LXCzqUBO8iJnCeYTpPAkS8RGGDwm0EOODi6k=
X-Received: by 2002:a05:651c:318:: with SMTP id a24mr11022427ljp.55.1592926212549;
 Tue, 23 Jun 2020 08:30:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200618010805.600873-1-sashal@kernel.org> <20200618010805.600873-319-sashal@kernel.org>
In-Reply-To: <20200618010805.600873-319-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Jun 2020 21:00:01 +0530
Message-ID: <CA+G9fYski0D9pPXmWr6CorrKATZkQLz_k1w_5bVmO-dU+_ROTQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.7 319/388] ovl: verify permissions in ovl_path_open()
To:     Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Jun 2020 at 08:03, Sasha Levin <sashal@kernel.org> wrote:
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
> index 36b60788ee47..a0878039332a 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -459,7 +459,32 @@ bool ovl_is_whiteout(struct dentry *dentry)
>
>  struct file *ovl_path_open(struct path *path, int flags)
>  {
> -       return dentry_open(path, flags | O_NOATIME, current_cred());
> +       struct inode *inode = d_inode(path->dentry);
> +       int err, acc_mode;
> +
> +       if (flags & ~(O_ACCMODE | O_LARGEFILE))
> +               BUG();

This BUG: triggered on stable-rc 5.7, 5.4, 4.19 and 4.14 on arm64 architecture.

steps to reproduce:
          - cd /opt/ltp
          - ./runltp -s execveat03

[  564.915016] ------------[ cut here ]------------
[  564.919654] kernel BUG at fs/overlayfs/util.c:466!
[  564.924458] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[  564.929954] Modules linked in: overlay rfkill tda998x cec
drm_kms_helper drm crct10dif_ce fuse
[  564.938617] CPU: 1 PID: 15054 Comm: execveat03 Not tainted
5.7.6-rc1-00793-gccc085714c08 #1
[  564.946987] Hardware name: ARM Juno development board (r2) (DT)
[  564.952921] pstate: 60000005 (nZCv daif -PAN -UAO)
[  564.957786] pc : ovl_path_open+0xd0/0xd8 [overlay]
[  564.962642] lr : ovl_path_open+0x30/0xd8 [overlay]
[  564.967443] sp : ffff00090a65f740
[  564.970763] x29: ffff00090a65f740 x28: 0000000000000000
[  564.976091] x27: ffff00090a65f950 x26: ffffa000097506c0
[  564.981419] x25: ffff00090388f000 x24: ffff000912b39a28
[  564.986746] x23: ffff00090a65f950 x22: ffff00090b45e580
[  564.992072] x21: ffff00090a65f950 x20: ffff0008dddbcb10
[  564.997398] x19: 0000000000004000 x18: 0000000000000000
[  565.002723] x17: 0000000000000000 x16: 0000000000000000
[  565.008048] x15: 0000000000000000 x14: ffffa000103c0898
[  565.013374] x13: ffffa00010382fec x12: ffff80011bd530dc
[  565.018700] x11: 1fffe0011bd530db x10: ffff80011bd530db
[  565.024026] x9 : dfffa00000000000 x8 : ffff0008dea986d8
[  565.029351] x7 : 0000000000000001 x6 : 00000000f1f1f1f1
[  565.034677] x5 : 00000000f3000000 x4 : dfffa00000000000
[  565.040003] x3 : ffffa0000973f950 x2 : 0000000000000007
[  565.045328] x1 : 0000000000004000 x0 : ffff00090f79c930
[  565.050653] Call trace:
[  565.053162]  ovl_path_open+0xd0/0xd8 [overlay]
[  565.057670]  ovl_check_d_type_supported+0x9c/0x180 [overlay]
[  565.063396]  ovl_get_workdir.isra.0+0x238/0x5e0 [overlay]
[  565.068861]  ovl_fill_super+0x800/0x1a48 [overlay]
[  565.073673]  mount_nodev+0x50/0xc0
[  565.077135]  ovl_mount+0x1c/0x28 [overlay]
[  565.081245]  legacy_get_tree+0x74/0xc0
[  565.085005]  vfs_get_tree+0x4c/0x160
[  565.088589]  do_mount+0x700/0xb90
[  565.091913]  __arm64_sys_mount+0xc0/0x110
[  565.095938]  el0_svc_common.constprop.0+0xa4/0x1e0
[  565.100742]  do_el0_svc+0x38/0xa0
[  565.104068]  el0_sync_handler+0x11c/0x190
[  565.108087]  el0_sync+0x158/0x180
[  565.111419] Code: a8c37bfd d50323bf d65f03c0 d4210000 (d4210000)
[  565.117529] ---[ end trace 357a3872beec6c53 ]---
[  565.122157] note: execveat03[15054] exited with preempt_count 1
[  565.129476] ------------[ cut here ]------------
[  565.134122] WARNING: CPU: 1 PID: 0 at kernel/rcu/tree.c:569
rcu_idle_enter+0xd0/0xd8
[  565.141879] Modules linked in: overlay rfkill tda998x cec
drm_kms_helper drm crct10dif_ce fuse
[  565.150539] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D
  5.7.6-rc1-00793-gccc085714c08 #1
[  565.159866] Hardware name: ARM Juno development board (r2) (DT)
[  565.165799] pstate: 200003c5 (nzCv DAIF -PAN -UAO)
[  565.170603] pc : rcu_idle_enter+0xd0/0xd8
[  565.174623] lr : rcu_idle_enter+0x34/0xd8
[  565.178639] sp : ffff000935577ea0
[  565.181958] x29: ffff000935577ea0 x28: 0000000000000000
[  565.187285] x27: ffff000912d83000 x26: ffffa0001359e2c0
 [  565.192611] x25: ffff000935552b80 x24: 1fffe00126aaefe6
[  565.198098] x23: ffffa000125abff8 x22: ffffa0001359e298
[  565.203424] x21: ffff000936606fd0 x20: ffffa000125b5f00
[  565.208909] x19: ffff000936606f00 x18: 0000000000000000
Broadcast message from systemd-jo[  565.214234] x17: 0000000000000000
x16: 0000000000000000
urnald@juno (Mon 2020-06-22 19:5[  565.222417] x15: 0000000000000000
x14: ffffa000103c1370
9:27 UTC):
[  565.230517] x13: ffffa000103c0898 x12: ffff800126cc0d8c
[  565.236959] x11: 1fffe00126cc0d8b x10: ffff800126cc0d8b
[  565.242285] x9 : dfffa00000000000 x8 : ffff000936606c5b
[  565.247683] x7 : 0000000000000001 x6 : ffff000936606c58
[  565.253009] x5 : 00007ffed933f275 x4 : dfffa00000000000
[  565.258493] x3 : ffffa000101d48e4 x2 : 0000000000000007
kernel[300]: [  564.924458] Inter[  565.263819] x1 : 4000000000000002
x0 : 4000000000000000
nal error: Oops - BUG: 0 [#1] PR[  565.272001] Call trace:
EEMPT SMP
[  565.277235]  rcu_idle_enter+0xd0/0xd8
[  565.281938]  do_idle+0x288/0x328
[  565.285176]  cpu_startup_entry+0x28/0x48
[  565.289182]  secondary_start_kernel+0x248/0x2b0
[  565.293721] ---[ end trace 357a3872beec6c54 ]---

https://lkft.validation.linaro.org/scheduler/job/1515478#L3876

-- 
Linaro LKFT
https://lkft.linaro.org
