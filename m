Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC9D67F3CD
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 02:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjA1BnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 20:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjA1BnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 20:43:12 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2960742DCA;
        Fri, 27 Jan 2023 17:43:11 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d3so6656108plr.10;
        Fri, 27 Jan 2023 17:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OEZ66ke5Y/kqeZOY+8Ui5b4LiVO+6SThH0LVslXaxIg=;
        b=MrWL1opquycf0O6BIr9HDQEEQpzsqamaVq9S3dAtgHR0XvqjYHoaOzrSMqhx2LRyyQ
         xDK5bHhpQaobTVJJR7iJxXOjcbYpSDNNSlx9YP3KDy7RG57dT4XqVj8R73SOEP15FgF6
         X3koV3uVrlvab1dWtEyNfsuh/wFYxmr8qMAnG+8vmEhr/AhuMY5/x98iecR//FMEQFUG
         M5FIFBjswFgQ5VwiDte5CNCF9tgNy1+YcvHMnPpr4++CLuL+otiuWN2OEjhQptzxTLE2
         hm9ifJbc7E88tem3DS7GtoLIkSbOpdn1wUP1Gjna/EvGpQ66ft6NydobI2SLtKVp1uqW
         Q5cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OEZ66ke5Y/kqeZOY+8Ui5b4LiVO+6SThH0LVslXaxIg=;
        b=oq36Ru6Q0OH8NWuqJSNM46XlI1plO+gLxKlEXHkzClUMjXNCis0UXHlQ9R0QxkRefj
         60VIPkOowSqtF1IsvjTNWzclurdFdqjaQ5D5XMm8Z40FTeaFSgOHA9uRc2RFIVwLb9Tq
         44AIA7WqIzQeuQm0x33T4qdyyN0J3A5bc9ePgI4zzj22rOFItsnlpaECbtQx7cwtL9kP
         0dlsZmx6JPyjTmz8NoYOe3HuG7XpjDlDxrc+9Uy2LupVNQVzbXU5JUk0gZHtfO2gVTZK
         zUwxxxc39ZM10hQ2pqktdtAP7WZSCbkKt+51kzZi5CqSx1l3Kws7Wnamc26eH2Rl6pJ4
         HJQw==
X-Gm-Message-State: AFqh2kplBb73aVjn97gQIBwnd920alTEFUY+WM97yN3TBHdG9VOFNBB7
        IXM+BrDVZYCJur8kBKG37J+YPP8MxvelwqjWY6s=
X-Google-Smtp-Source: AMrXdXvf1dCf/e9hEYxEwzOfaShFww7RsZzMhz/xlwV/Bzt1lBRHPfMD0WiexQYr7l8XkzJBfQLfa+BIx1Z5u6urE8U=
X-Received: by 2002:a17:90b:2541:b0:229:3af9:a0ac with SMTP id
 nw1-20020a17090b254100b002293af9a0acmr6526809pjb.47.1674870190705; Fri, 27
 Jan 2023 17:43:10 -0800 (PST)
MIME-Version: 1.0
References: <20230124173126.3492345-1-joel@joelfernandes.org>
 <20230124225628.GZ2948950@paulmck-ThinkPad-P17-Gen-1> <CAABZP2wa_ZTHUr9tH_6OSpr+TgNACo4kMu3eawsGV5qkCDoAKg@mail.gmail.com>
 <CAABZP2wk-RiAV4CzG+6cn7=twvgtw-YGt5bLB4qw8gOWU01kkw@mail.gmail.com>
 <CAABZP2xYL_9zXqw6pEutuNv_hzeezbxPEc8WPZLkPGMozP5C4w@mail.gmail.com>
 <CAEXW_YSCP+qpXDUvqd3qgftD_c2p-HRgK49eDypaFFUCD4YJdA@mail.gmail.com> <CAABZP2ztv8NkvGVQt8D+=6tNj4dg=6-Sp41+HGeNFxZ1oXsmNQ@mail.gmail.com>
In-Reply-To: <CAABZP2ztv8NkvGVQt8D+=6tNj4dg=6-Sp41+HGeNFxZ1oXsmNQ@mail.gmail.com>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Sat, 28 Jan 2023 09:42:59 +0800
Message-ID: <CAABZP2zr5oDgOOP0yE+TfwJz4hoAOG+4d5C8MJgs_LuSCS-kpw@mail.gmail.com>
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

On Thu, Jan 26, 2023 at 11:41 PM Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
>
> On Thu, Jan 26, 2023 at 11:14 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > On Thu, Jan 26, 2023 at 10:01 AM Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
> > >
> > > On Thu, Jan 26, 2023 at 12:16 PM Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
> > > >
> > > > On Wed, Jan 25, 2023 at 8:13 AM Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
> > > > >
> > > > > On Wed, Jan 25, 2023 at 6:56 AM Paul E. McKenney <paulmck@kernel.org> wrote:
> > > > > >
> > > > > > On Tue, Jan 24, 2023 at 05:31:26PM +0000, Joel Fernandes (Google) wrote:
> > > > > > > For CONFIG_NO_HZ_FULL systems, the tick_do_timer_cpu cannot be offlined.
> > > > > > > However, cpu_is_hotpluggable() still returns true for those CPUs. This causes
> > > > > > > torture tests that do offlining to end up trying to offline this CPU causing
> > > > > > > test failures. Such failure happens on all architectures.
> > > > > > >
> > > > > > > Fix it by asking the opinion of the nohz subsystem on whether the CPU can
> > > > > > > be hotplugged.
> > > > > > >
> > > > > > > [ Apply Frederic Weisbecker feedback on refactoring tick_nohz_cpu_down(). ]
> > > > > > >
> > > > > > > For drivers/base/ portion:
> > > > > > > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > > >
> > > > > > > Cc: Frederic Weisbecker <frederic@kernel.org>
> > > > > > > Cc: "Paul E. McKenney" <paulmck@kernel.org>
> > > > > > > Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > > > > > > Cc: Will Deacon <will@kernel.org>
> > > > > > > Cc: Marc Zyngier <maz@kernel.org>
> > > > > > > Cc: rcu <rcu@vger.kernel.org>
> > > > > > > Cc: stable@vger.kernel.org
> > > > > > > Fixes: 2987557f52b9 ("driver-core/cpu: Expose hotpluggability to the rest of the kernel")
> > > > > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > > > >
> > > > > > Queued for further review and testing, thank you both!
> > > > > >
> > > > > > It might be a few hours until it becomes publicly visible, but it will
> > > > > > get there.
> > > > > A new round of rcutorture test on fixed linux-5.15.y[3] has been
> > > > > performed in the PPC VM of Open Source Lab of Oregon State University
> > > > > [1], which will last about 29 hours. The test result on original
> > > > > linux-5.15.y is at [2].
> > > > From the result of [1], the HOTPLUG failure reports have been
> > > > eliminated, but a new kernel null point bug related to scsi module has
> > > > been reported [4] ;-(
> > > > [    5.178733][    C1] BUG: Kernel NULL pointer dereference on read at
> > > > 0x00000008
> > > > ...
> > > > [    5.231013][    C1] [c00000001ff9fca0] [c0000000009ffbc8]
> > > > scsi_end_request+0xd8/0x1f0 (unreliable)^M
> > > > [    5.234961][    C1] [c00000001ff9fcf0] [c000000000a00e68]
> > > > scsi_io_completion+0x88/0x700^M
> > > > [    5.237863][    C1] [c00000001ff9fda0] [c0000000009f5028]
> > > > scsi_finish_command+0xe8/0x150^M
> > > > [    5.240089][    C1] [c00000001ff9fdf0] [c000000000a00c70]
> > > > scsi_complete+0x90/0x140^M
> > > > [    5.242481][    C1] [c00000001ff9fe20] [c0000000007e5170]
> > > > blk_complete_reqs+0x80/0xa0^M
> > > > [    5.245187][    C1] [c00000001ff9fe50] [c000000000f0b5d0]
> > > > __do_softirq+0x1e0/0x4e0^M
> > > > [    5.248479][    C1] [c00000001ff9ff90] [c0000000000170e8]
> > > > do_softirq_own_stack+0x48/0x60^M
> > > > [    5.250919][    C1] [c00000000a5e7c40] [c00000000a5e7c80]
> > > > 0xc00000000a5e7c80^M
> > > > [    5.253792][    C1] [c00000000a5e7c70] [c0000000001534c0]
> > > > do_softirq+0xb0/0xc0^M
> > > > [    5.256824][    C1] [c00000000a5e7ca0] [c0000000001535ac]
> > > > __local_bh_enable_ip+0xdc/0x110^M
> > > > [    5.259414][    C1] [c00000000a5e7cc0] [c0000000001d75e8]
> > > > irq_forced_thread_fn+0xc8/0xf0^M
> > > > [    5.261921][    C1] [c00000000a5e7d00] [c0000000001d7ae4]
> > > > irq_thread+0x1b4/0x2a0^M
> > > > [    5.265298][    C1] [c00000000a5e7da0] [c00000000017d8c8]
> > > > kthread+0x1a8/0x1d0^M
> > > > [    5.269184][    C1] [c00000000a5e7e10] [c00000000000cee4]
> > > > ret_from_kernel_thread+0x5c/0x64^M
> > > >
> > > > But when I invoked [5]  by hand, the bug did not show again [6].
> > > >
> > > > [4] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutorture/res/2023.01.25-00.04.30-torture/results-clocksourcewd-2/TREE03/console.log
> > > > [5] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutorture/res/2023.01.25-00.04.30-torture/results-clocksourcewd-2/TREE03/qemu-cmd
> > > > [6] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutorture/res/2023.01.25-00.04.30-torture/results-clocksourcewd-2/TREE03/console.zzy.log
> > > >
> > > > I think the bug is not caused by Joel's patch, there must be some
> > > > other reason. I am starting the 29 hours' rcutorture test again. And I
> > > > can give ssh access to you if you are interested in it.
> > > >
> > > > Sorry for the inconvenience that I bring
> > > >
> > > > Thanks
> > > > Zhouyi
> > > Hi the above kernel null pointer dereference bug has nothing to do
> > > with Joel's fix because I can reproduce it on original 5.15.y [7]
> > > using as while loop [8] (after 36 iterations, the bug fires).
> > > So, Joel's patch is tested good!
> > > Tested-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
> >
> > Interesting. I have been running rcutorture's TREE03 on 5.15.y quite a
> > lot and I don't see such an issue.
> >
> >  However, your logs showed the crash is SCSI related. These were the
> > recent SCSI commits in 5.15.y but I am not sure if it causes the
> > issue:
> >
> > 13259b6 scsi: mpi3mr: Refer CONFIG_SCSI_MPI3MR in Makefile
> > 513fdf0 scsi: ufs: Stop using the clock scaling lock in the error handler
> > 7c26d21 scsi: ufs: core: WLUN suspend SSU/enter hibern
> >
> > Perhaps report it to the scsi and/or stable lists, or do some web
> > searches for if someone else sees it.
> Thank Joel for your guidance!
> I will continue the research following your instructions!
> I will report to you and the community once I have any process.
Hi
I think I have chased down the reason behind the bug reported by SCSI
subsystem following your guidance, and have reported to SCSI
mainteners [1]
This is a fruitful journey, thank you all ;-)

So once again, Joel's patch is tested good ;-)
Tested-by: Zhouyi Zhou <zhouzhouyi@gmail.com>

Thanks for your attention
Thanks
Zhouyi
[1] https://lore.kernel.org/lkml/CAABZP2ywCbu4Po63BDBE7U1WEqx4DF7F2CZjTqFp0dSDw-uziQ@mail.gmail.com/T/#u
>
> Thank you all!
>
> Best Regards
> Zhouyi
> >
> > - Joel
