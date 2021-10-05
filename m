Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219FB421D19
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 06:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhJEEG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 00:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhJEEGZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 00:06:25 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7DFC061749
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 21:04:35 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id x7so70863033edd.6
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 21:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e02BuBIFVDw19dOOLCBgX9KU+Ghl8CBHDYow7kOUtGQ=;
        b=UA3HUGyWRIiedHksu/BZyRbcbRrSzCxNwYVnssW9FMS8zv+VLwoU/ZiILp+h5I38Si
         9gb3h5T8eefCvAiqG9NsxX3mDR39tWrak2f0oFYa5hu9Mq9066kYDeE7NWNPUYpRYmik
         iOpIG49/OejjLwNB4QoG0towwxI92ZjXyqKt/Jo0JsUoCi7ue3sU2QcB9uQnKn/RR9dG
         QpoNues1Sc6w9stU8tm5wAgayND6uqETRc8KLgjXH+lM88dmndsEde7LlfmlXuop4aTk
         ALtMA9tTbz9I/nd7dMZWl0nlfCffK+p/Khl/BOuzWRil3PHovDv9UiBaCeW9Cv4Q81nI
         O2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e02BuBIFVDw19dOOLCBgX9KU+Ghl8CBHDYow7kOUtGQ=;
        b=S0tvHjeol4ZS6HpjpOMVFR7+iBLBOm1f/uw8Nepi6Ee37KZh+eMdNv4Ga5fvK+MRdC
         tmIk9HlNnemzoa719BdVyRDDBhv+Lfk4tw7jtdlOyJxBS5h4cbAwPWtxM9FOZlvLEpXk
         uDpSYPiAaAuuTtEL9SUJvaYYHAONbjYETR9dt/rN/Z2AQi9E1DyEhOBVBWb6+fbe60wH
         TkkotqY+h0OIvNxtbUs+X3y6Dp3UV8Uv6xS++4zlzLOSnAjTaoFA0tIGftb1rdEJRF4a
         L8nA9RdxuEMNoV5xidHmB0eewemfVbRTW9EyYq8laRmPpoAPe0olthZf+rQXeFXyfYUO
         SzSQ==
X-Gm-Message-State: AOAM5315gZXL31crk4Sfp58CMxPKbXyWeRPIruDu3Mhk9K1u/b4DosVg
        +4NtskXgUPCnGrMKymNcKahEIfwTqvlzo4wOPmS/aQ==
X-Google-Smtp-Source: ABdhPJywsNKen9TusQJoB6l4WOidTsnqOprB6GTt6AJc/UkznOIrAT0c1tyqGvr+F3+/f+4TiEcsIasuZfEdmW9mPsY=
X-Received: by 2002:a17:906:318b:: with SMTP id 11mr22758137ejy.493.1633406673796;
 Mon, 04 Oct 2021 21:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211004125044.945314266@linuxfoundation.org>
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 Oct 2021 09:34:22 +0530
Message-ID: <CA+G9fYuZf8qJJnUMfL8jXScgvX17MLTVDNNXAXYGMS_paBOfHg@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 Oct 2021 at 18:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regression found on i386 and x86.
following kernel warning reported on stable-rc linux-5.14.y while booting x86.

metadata:
  git branch: linux-5.14.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git commit: cda15f9c69e08480d4308d0e5c62bd44324a9ff0
  git describe: v5.14.9-173-gcda15f9c69e0
  make_kernelversion: 5.14.10-rc1
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-stable-rc-5.14/36/config

Kernel crash:
--------------
[   22.356755] =========================
[   22.360414] WARNING: held lock freed!
[   22.364071] 5.14.10-rc1 #1 Not tainted
[   22.367824] -------------------------
[   22.371489] systemd-network/341 is freeing memory
ffff9d21cbea0000-ffff9d21cbea06bf, with a lock still held there!
[   22.381828] ffff9d21cbea0120 (sk_lock-AF_INET){+.+.}-{0:0}, at:
sk_common_release+0x21/0x100
[   22.384624] igb 0000:02:00.0 eno2: renamed from eth1
[   22.390260] 2 locks held by systemd-network/341:
[   22.390261]  #0: ffff9d21c406eb10
(&sb->s_type->i_mutex_key#6){+.+.}-{3:3}, at: __sock_release+0x32/0xc0
[   22.390267]  #1: ffff9d21cbea0120 (sk_lock-AF_INET){+.+.}-{0:0},
at: sk_common_release+0x21/0x100
[   22.390272]
[   22.390272] stack backtrace:
[   22.390273] CPU: 2 PID: 341 Comm: systemd-network Not tainted 5.14.10-rc1 #1
[   22.390275] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[   22.390276] Call Trace:
[   22.390278]  dump_stack_lvl+0x49/0x5e
[   22.390281]  dump_stack+0x10/0x12
[   22.390283]  debug_check_no_locks_freed+0x111/0x120
[   22.390286]  slab_free_freelist_hook+0x119/0x1d0
[   22.390289]  kmem_cache_free+0x102/0x540
[   22.390291]  ? __sk_destruct+0x145/0x210
[   22.390294]  __sk_destruct+0x145/0x210
[   22.390296]  sk_destruct+0x48/0x50
[   22.409489] ata_id (348) used greatest stack depth: 11952 bytes left
[   22.418194]  __sk_free+0x2f/0xc0
[   22.418198]  sk_free+0x26/0x40
[   22.418200]  sk_common_release+0xa9/0x100
[   22.487567]  udp_lib_close+0x9/0x10
[   22.491057]  inet_release+0x44/0x80
[   22.494542]  __sock_release+0x42/0xc0
[   22.498209]  sock_close+0x18/0x20
[   22.501525]  __fput+0xb5/0x260
[   22.504578]  ____fput+0xe/0x10
[   22.507636]  task_work_run+0x6f/0xc0
[   22.511216]  exit_to_user_mode_prepare+0x1f6/0x200
[   22.515999]  syscall_exit_to_user_mode+0x1d/0x50
[   22.520610]  do_syscall_64+0x67/0x80
[   22.524190]  ? irqentry_exit+0x75/0x80
[   22.527940]  ? exc_page_fault+0x6c/0x200
[   22.531859]  ? asm_exc_page_fault+0x8/0x30
[   22.535950]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   22.541002] RIP: 0033:0x7f52fe67e641
[   22.544580] Code: f7 d8 64 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f
1f 84 00 00 00 00 00 66 90 8b 05 aa cd 20 00 85 c0 75 16 b8 03 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 3f c3 66 0f 1f 44 00 00 53 89 fb 48 83
ec 10
[   22.563318] RSP: 002b:00007ffe31761878 EFLAGS: 00000246 ORIG_RAX:
0000000000000003
[   22.570884] RAX: 0000000000000000 RBX: 0000000000000010 RCX: 00007f52fe67e641
[   22.578007] RDX: 00000000000073b0 RSI: 0000000000000000 RDI: 0000000000000010
[   22.585130] RBP: 00007f52feed8338 R08: 000055893cf103c3 R09: 0000000000000078
[   22.592253] R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
[   22.599379] R13: 00007ffe317618c0 R14: 0000000000000000 R15: 00007ffe31762a60


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

ref:
https://lkft.validation.linaro.org/scheduler/job/3658919#L1477

-- 
Linaro LKFT
https://lkft.linaro.org
