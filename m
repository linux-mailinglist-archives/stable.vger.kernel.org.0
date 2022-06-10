Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85A95468F7
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 17:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237609AbiFJPFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 11:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiFJPFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 11:05:08 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A4D4D61D
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 08:05:06 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r71so25062536pgr.0
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 08:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SFhtOc8ZxBnmhItZ1qxhq/xDg7PtgwmwmGr3UiZeUG8=;
        b=fFA+ww58MhKCD9YAx1sLvBw2pV9piyGS4hTmCmUPC4D8W60uKrEaI6t59A237UGnKv
         g5UH19J+BHFOoWxDySYRD6byuJE6mThR2BALhHLvwyX2avIpLhm5txk5lQeWg6vblrUo
         8s0wXumEE7jUenYsehmIvaACb+DXdVQUR2vGJEm0ky/fKf6QG48E+Gi3bLOVZVdxgMLk
         juoFob4Emhv8gpkVFfF0C9YNuT3h1E6O4DPv+691/9zabYRbm5pfAyuRmwXH1dgfMc8j
         8VJeMPuERnSRTWuM4r34/Xl6RcnMaDS88xBR74QcTgGgFh+2qkdVYodP/9aWw6wh2qUn
         0Jow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SFhtOc8ZxBnmhItZ1qxhq/xDg7PtgwmwmGr3UiZeUG8=;
        b=O6KFTkeBbhOqKlhrY/Zbgu10372XwHfP9tI7J3u23/tWM/WJMvh/9uJgG44Fs//B3K
         IKpru7MljC+OkcFDdBQl8NS4uJxtl/q9P45w98XRGswBKVPqg2NlzgNDmq+orIlVb149
         YEDkVRqGulP2oT49adDMWMhR7Fr7SKuvagnZTNNcGm8E5CFgr6DL1KnWv7tFD9VRCOZk
         OSxLThnFgFwcbKk81TgW+tllZ4SQadZNWf5mBa+Q3Pv/QCIeX00/0Jq95D+y+rtZQn54
         +pv3Ni+8VHwgItORqVBSBnuK3aYyVIwWY61+8lTSJGB/ndp8VA8KkDqd+OY/LPceCwtJ
         +OPw==
X-Gm-Message-State: AOAM533et581pEpVou4ZTr+kiWZ6JZaGBh941VgcsLCwIwoSoc/svEjT
        GE+Bwde/fg1AGZZoM2phckguzahsjosWBzV5vj/z1kbald3W8g==
X-Google-Smtp-Source: ABdhPJzNiq9RRGXeLKBn76dNzW0jS7Bk+wP7nhF8R6JsZvjmuftJwdEB86jmTUOtGWVSL7LC9Voji2BY3N2Knf5en9k=
X-Received: by 2002:a05:6a00:114c:b0:518:c064:d47 with SMTP id
 b12-20020a056a00114c00b00518c0640d47mr46182074pfm.27.1654873506087; Fri, 10
 Jun 2022 08:05:06 -0700 (PDT)
MIME-Version: 1.0
References: <CADs9LoMEF86Fp2-0ji7d9CNA5F=8ArwPWnj09h_Cwo6poNsWVA@mail.gmail.com>
 <YqMdS+3qpYHfWN9f@kroah.com>
In-Reply-To: <YqMdS+3qpYHfWN9f@kroah.com>
From:   Alex Natalsson <harmoniesworlds@gmail.com>
Date:   Fri, 10 Jun 2022 18:04:54 +0300
Message-ID: <CADs9LoNnzECvWik=d8mY+v3V3tveSdhy3iuPBX6oRPx9r-Oqnw@mail.gmail.com>
Subject: Re: echo mem > /sys/power/state write error "Device or resource busy"
 on Amlogic A311D device
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yes, I can finding broken commit, but it may requiring lot of time
with my system.

5.19-rc1 suspending successfully, but at resuming kernel freezing. Is
big core frequency not small?)
The log:
bl30 get wakeup sources!
process command 00000006
bl30 enter suspend!
Little core clk suspend rate 1000000000
Big core clk suspend rate 24000000
store restore gp0 pll
suspend_counter: 1
Enter ddr suspend
ddr suspend time: 15us
alarm=3D0S
process command 00000001
cec ver:2018/04/29
CEC cfg:0x0000
use vddee new table!
use vddee new table!
exit_reason:0x06
Enter ddr resume
ddr resume time: 123us
store restore gp0 pll
cfg15 3b00000
cfg15 63b00000
Little core clk resume rate 1000000000
Big core clk resume rate 50000000


=D0=BF=D1=82, 10 =D0=B8=D1=8E=D0=BD. 2022 =D0=B3. =D0=B2 13:30, Greg KH <gr=
egkh@linuxfoundation.org>:
>
> On Fri, Jun 10, 2022 at 01:18:56PM +0300, Alex Natalsson wrote:
> > Hello friends.
> > Suspend to RAM on Amlogic A311D chip (Khadas VIM3 SBC) was broken with
> > 5.17.13 and with 5.18.2 it also presents.
> >
> > When I trying do this I recieve error message:
> > VIM3 ~ # LANG=3DC echo mem > /sys/power/state
> > [  952.824117] PM: suspend entry (deep)
> > [  952.828333] Filesystems sync: 0.003 seconds
> > [  952.829473] Freezing user space processes ...
> > [  972.833509] Freezing of tasks failed after 20.003 seconds (1 tasks
> > refusing to freeze, wq_busy=3D0):
> > [  972.841178] task:mplayer         state:D stack:    0 pid:  779
> > ppid:   736 flags:0x00000205
> > [  972.849457] Call trace:
> > [  972.851868]  __switch_to+0xf8/0x150
> > [  972.855315]  __schedule+0x1f8/0x570
> > [  972.858758]  schedule+0x48/0xc0
> > [  972.861856]  schedule_preempt_disabled+0x10/0x20
> > [  972.866417]  __mutex_lock.constprop.0+0x158/0x590
> > [  972.871071]  __mutex_lock_slowpath+0x14/0x20
> > [  972.875296]  mutex_lock+0x5c/0x70
> > [  972.878573]  dpcm_fe_dai_open+0x44/0x194
> > [  972.882456]  snd_pcm_open_substream+0xa4/0x174
> > [  972.886857]  snd_pcm_open.part.0+0xd8/0x1dc
> > [  972.890994]  snd_pcm_playback_open+0x64/0x94
> > [  972.895223]  snd_open+0xac/0x1d0
> > [  972.898411]  chrdev_open+0xdc/0x2c4
> > [  972.901861]  do_dentry_open+0x12c/0x380
> > [  972.905652]  vfs_open+0x30/0x3c
> > [  972.908758]  do_open+0x1e4/0x3a0
> > [  972.911948]  path_openat+0x10c/0x280
> > [  972.915486]  do_filp_open+0x80/0x130
> > [  972.919019]  do_sys_openat2+0xb4/0x170
> > [  972.922731]  __arm64_sys_openat+0x64/0xb0
> > [  972.926700]  invoke_syscall+0x48/0x114
> > [  972.930421]  el0_svc_common.constprop.0+0xd4/0xfc
> > [  972.935070]  do_el0_svc+0x28/0x90
> > [  972.938347]  el0_svc+0x34/0xb0
> > [  972.941367]  el0t_64_sync_handler+0xa4/0x130
> > [  972.945595]  el0t_64_sync+0x18c/0x190
> >
> > [  972.950674] OOM killer enabled.
> > [  972.953781] Restarting tasks ... done.
> > -bash: echo: write error: Device or resource busy
> > VIM3 ~ :( #
> >
> > With 5.16.2 kernel version suspend to RAM is working, but system very
> > slow after resume.
> >
>
> Can you use 'git bisect' to track down the offending commit?
>
> And does 5.19-rc1 also have this issue?
>
> thanks,
>
> greg k-h
