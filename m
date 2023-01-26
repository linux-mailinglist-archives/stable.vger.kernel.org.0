Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB4267D071
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 16:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjAZPl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 10:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjAZPl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 10:41:26 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD5330FB;
        Thu, 26 Jan 2023 07:41:24 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id 88so1864292pjo.3;
        Thu, 26 Jan 2023 07:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2dXZyyTM+czgDh+hHOm7VFzjBVzYxI9jqOEVTEw8sgU=;
        b=qq4pXErZQABzgGXP+TbBvEfsJoHiT6icA1SbVh6y2Pc9e9sNxH4nwxpXIdeUwtQrMU
         PMJGfwHNryVLo3iwJypjavhhjcndEzh2khqv06idO4ZowSfuxdEe+iZAI5zHrYjMPjPF
         p0pQYRpfgmUsWf2K5JvaYGZ6oFS1N0ZWE3mDEESTK0fQCzObU7QSg8UPvGFti8g2nRpO
         iSPqQFcVKiHZH+5cawZbTXoH/FFm0fmxlXI68nGR1URY3d2bXSe29/u2/cmry7/ZqVy3
         WaNm/uo4/FibYnff3iiXb91xpdao8ceYyL6oXKWCzIHD6Gp2i3ivyaOSC0ZyoWKB9a+I
         NsYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2dXZyyTM+czgDh+hHOm7VFzjBVzYxI9jqOEVTEw8sgU=;
        b=0ddPR2wVDMzLe4dGW9kXYqU+5u5gE01IL187KhMljWmSvJRCvwM+0acyAndmwFK44e
         v5KUIwxxxVhruEY2dGb2aYrlLj0k3nBdNC8mHASQ9ff3HCxPynv77eQkcpDnqSYG2NEx
         KRQumZMDgjzXgwWJl5HAxf9bgKSmbwPpKjhX2UjiUz/HsIr6SjqIeYA221LSesaUiLfj
         /X4nOqxNcaHvS2l62G7osdIFqLnSPP/nIfQip1JeZlNQnoAzKZSxlu5bhaBSP2afelPM
         n/fbIPgqKbatHeUWCon4g6bgbuJ/2e4hORsoAojEAGAIYHZV/3QooCRF7/UuDMyBq4D4
         qWwQ==
X-Gm-Message-State: AO0yUKXjEykMC/cFnA7VLI7tXq0EDGIU91ugzBNNE6Fhzu/Nt74d7EzN
        nCGwFOmBAKyDNAqwGKAvJ2laRecwIzWUGvD5I/M=
X-Google-Smtp-Source: AK7set9OGRyAsaXf80BWzA2nrJFbMhn0OnlTR5s2bstXBCrM/Ui9bAmsBNTpW59PNIHkWnt2UTuaKDMyYJs/q1CRy6g=
X-Received: by 2002:a17:90a:557:b0:22b:eb97:ed60 with SMTP id
 h23-20020a17090a055700b0022beb97ed60mr2008465pjf.39.1674747684477; Thu, 26
 Jan 2023 07:41:24 -0800 (PST)
MIME-Version: 1.0
References: <20230124173126.3492345-1-joel@joelfernandes.org>
 <20230124225628.GZ2948950@paulmck-ThinkPad-P17-Gen-1> <CAABZP2wa_ZTHUr9tH_6OSpr+TgNACo4kMu3eawsGV5qkCDoAKg@mail.gmail.com>
 <CAABZP2wk-RiAV4CzG+6cn7=twvgtw-YGt5bLB4qw8gOWU01kkw@mail.gmail.com>
 <CAABZP2xYL_9zXqw6pEutuNv_hzeezbxPEc8WPZLkPGMozP5C4w@mail.gmail.com> <CAEXW_YSCP+qpXDUvqd3qgftD_c2p-HRgK49eDypaFFUCD4YJdA@mail.gmail.com>
In-Reply-To: <CAEXW_YSCP+qpXDUvqd3qgftD_c2p-HRgK49eDypaFFUCD4YJdA@mail.gmail.com>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Thu, 26 Jan 2023 23:41:13 +0800
Message-ID: <CAABZP2ztv8NkvGVQt8D+=6tNj4dg=6-Sp41+HGeNFxZ1oXsmNQ@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND] tick/nohz: Fix cpu_is_hotpluggable() by
 checking with nohz subsystem
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     paulmck@kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        rcu <rcu@vger.kernel.org>, stable@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NORMAL_HTTP_TO_IP,
        NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 26, 2023 at 11:14 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Thu, Jan 26, 2023 at 10:01 AM Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
> >
> > On Thu, Jan 26, 2023 at 12:16 PM Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
> > >
> > > On Wed, Jan 25, 2023 at 8:13 AM Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
> > > >
> > > > On Wed, Jan 25, 2023 at 6:56 AM Paul E. McKenney <paulmck@kernel.org> wrote:
> > > > >
> > > > > On Tue, Jan 24, 2023 at 05:31:26PM +0000, Joel Fernandes (Google) wrote:
> > > > > > For CONFIG_NO_HZ_FULL systems, the tick_do_timer_cpu cannot be offlined.
> > > > > > However, cpu_is_hotpluggable() still returns true for those CPUs. This causes
> > > > > > torture tests that do offlining to end up trying to offline this CPU causing
> > > > > > test failures. Such failure happens on all architectures.
> > > > > >
> > > > > > Fix it by asking the opinion of the nohz subsystem on whether the CPU can
> > > > > > be hotplugged.
> > > > > >
> > > > > > [ Apply Frederic Weisbecker feedback on refactoring tick_nohz_cpu_down(). ]
> > > > > >
> > > > > > For drivers/base/ portion:
> > > > > > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > >
> > > > > > Cc: Frederic Weisbecker <frederic@kernel.org>
> > > > > > Cc: "Paul E. McKenney" <paulmck@kernel.org>
> > > > > > Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > > > > > Cc: Will Deacon <will@kernel.org>
> > > > > > Cc: Marc Zyngier <maz@kernel.org>
> > > > > > Cc: rcu <rcu@vger.kernel.org>
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Fixes: 2987557f52b9 ("driver-core/cpu: Expose hotpluggability to the rest of the kernel")
> > > > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > > >
> > > > > Queued for further review and testing, thank you both!
> > > > >
> > > > > It might be a few hours until it becomes publicly visible, but it will
> > > > > get there.
> > > > A new round of rcutorture test on fixed linux-5.15.y[3] has been
> > > > performed in the PPC VM of Open Source Lab of Oregon State University
> > > > [1], which will last about 29 hours. The test result on original
> > > > linux-5.15.y is at [2].
> > > From the result of [1], the HOTPLUG failure reports have been
> > > eliminated, but a new kernel null point bug related to scsi module has
> > > been reported [4] ;-(
> > > [    5.178733][    C1] BUG: Kernel NULL pointer dereference on read at
> > > 0x00000008
> > > ...
> > > [    5.231013][    C1] [c00000001ff9fca0] [c0000000009ffbc8]
> > > scsi_end_request+0xd8/0x1f0 (unreliable)^M
> > > [    5.234961][    C1] [c00000001ff9fcf0] [c000000000a00e68]
> > > scsi_io_completion+0x88/0x700^M
> > > [    5.237863][    C1] [c00000001ff9fda0] [c0000000009f5028]
> > > scsi_finish_command+0xe8/0x150^M
> > > [    5.240089][    C1] [c00000001ff9fdf0] [c000000000a00c70]
> > > scsi_complete+0x90/0x140^M
> > > [    5.242481][    C1] [c00000001ff9fe20] [c0000000007e5170]
> > > blk_complete_reqs+0x80/0xa0^M
> > > [    5.245187][    C1] [c00000001ff9fe50] [c000000000f0b5d0]
> > > __do_softirq+0x1e0/0x4e0^M
> > > [    5.248479][    C1] [c00000001ff9ff90] [c0000000000170e8]
> > > do_softirq_own_stack+0x48/0x60^M
> > > [    5.250919][    C1] [c00000000a5e7c40] [c00000000a5e7c80]
> > > 0xc00000000a5e7c80^M
> > > [    5.253792][    C1] [c00000000a5e7c70] [c0000000001534c0]
> > > do_softirq+0xb0/0xc0^M
> > > [    5.256824][    C1] [c00000000a5e7ca0] [c0000000001535ac]
> > > __local_bh_enable_ip+0xdc/0x110^M
> > > [    5.259414][    C1] [c00000000a5e7cc0] [c0000000001d75e8]
> > > irq_forced_thread_fn+0xc8/0xf0^M
> > > [    5.261921][    C1] [c00000000a5e7d00] [c0000000001d7ae4]
> > > irq_thread+0x1b4/0x2a0^M
> > > [    5.265298][    C1] [c00000000a5e7da0] [c00000000017d8c8]
> > > kthread+0x1a8/0x1d0^M
> > > [    5.269184][    C1] [c00000000a5e7e10] [c00000000000cee4]
> > > ret_from_kernel_thread+0x5c/0x64^M
> > >
> > > But when I invoked [5]  by hand, the bug did not show again [6].
> > >
> > > [4] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutorture/res/2023.01.25-00.04.30-torture/results-clocksourcewd-2/TREE03/console.log
> > > [5] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutorture/res/2023.01.25-00.04.30-torture/results-clocksourcewd-2/TREE03/qemu-cmd
> > > [6] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutorture/res/2023.01.25-00.04.30-torture/results-clocksourcewd-2/TREE03/console.zzy.log
> > >
> > > I think the bug is not caused by Joel's patch, there must be some
> > > other reason. I am starting the 29 hours' rcutorture test again. And I
> > > can give ssh access to you if you are interested in it.
> > >
> > > Sorry for the inconvenience that I bring
> > >
> > > Thanks
> > > Zhouyi
> > Hi the above kernel null pointer dereference bug has nothing to do
> > with Joel's fix because I can reproduce it on original 5.15.y [7]
> > using as while loop [8] (after 36 iterations, the bug fires).
> > So, Joel's patch is tested good!
> > Tested-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
>
> Interesting. I have been running rcutorture's TREE03 on 5.15.y quite a
> lot and I don't see such an issue.
>
>  However, your logs showed the crash is SCSI related. These were the
> recent SCSI commits in 5.15.y but I am not sure if it causes the
> issue:
>
> 13259b6 scsi: mpi3mr: Refer CONFIG_SCSI_MPI3MR in Makefile
> 513fdf0 scsi: ufs: Stop using the clock scaling lock in the error handler
> 7c26d21 scsi: ufs: core: WLUN suspend SSU/enter hibern
>
> Perhaps report it to the scsi and/or stable lists, or do some web
> searches for if someone else sees it.
Thank Joel for your guidance!
I will continue the research following your instructions!
I will report to you and the community once I have any process.

Thank you all!

Best Regards
Zhouyi
>
> - Joel
