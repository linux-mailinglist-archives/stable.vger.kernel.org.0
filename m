Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA764FFA53
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 17:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbiDMPf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 11:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236577AbiDMPf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 11:35:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60C9A65489
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 08:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649864014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=inuim2PAAn4iZTfHZ5LXZCSvmmA/bZRB86kqPrODYcE=;
        b=bVitSpH3UShF50DNBMj2g1COzplSKEduD2vIBgg25zoujqnK23o97mAcHsNTG6CpERbQiY
        nfOKDgzfXjUCWiSL7iD1JjKL/ZQhU62cYuMaNCZfht/R5aN9XW8694q8f3UyiEjg0cmyNX
        ujcBteiCacmJgKeJz9bboMnN5T+j3ko=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-dlXzQdXOMkC6eWd1qMMDkQ-1; Wed, 13 Apr 2022 11:33:33 -0400
X-MC-Unique: dlXzQdXOMkC6eWd1qMMDkQ-1
Received: by mail-lj1-f199.google.com with SMTP id 20-20020a05651c009400b002462f08f8d2so490581ljq.2
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 08:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=inuim2PAAn4iZTfHZ5LXZCSvmmA/bZRB86kqPrODYcE=;
        b=Lmsfv7KjLmT8jmVqvR6wyVrUkK7FTMsuTRQfZzl6TShNG0ZJK8AT0Htkvs8+P+1SLd
         5IH+sVY9zEjbGJH+UersAN6opiwbM/MoMJ+gqPNETLTVrTt9aKsREQK2Ydi77VeODbAG
         9GPbUQZtw5uBB4WvFKzaxrcil0zpwWYc4sNI7FvNUMMWSHfs7AEzsWb/VZHfWpHSU+Hr
         9gZPEYnJn8sWDUSjf7A38bdIj7Pn8gX00gji8F/8udwOY5OyqFhPr3pNxb8cLvM5WqCU
         Q6i3Kb980yEennqyCcrqq22Ttf46aTxvpf/dh7BVLzLBLAcydG2uCXrgW9VzVdPH9AEY
         aHog==
X-Gm-Message-State: AOAM5338BdtDPBQe9mIltOnZYUOfJr/5iGX73RicXcGODgq3lkbniEHR
        QItwRgc5MBFYFpPGFdopTNITTe2+74WnEzIMxVquC1itypfRk28GuHko4c+lidxEhGw6JlgqbVh
        3gSugFIMn4RG29t38M/jihnmU+9pjvTUk
X-Received: by 2002:a2e:a26f:0:b0:24b:5f6c:7899 with SMTP id k15-20020a2ea26f000000b0024b5f6c7899mr10925665ljm.4.1649864010441;
        Wed, 13 Apr 2022 08:33:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCNIGHZcvMlWmtduOZjwqDUqtycuwiM+WaxdyRz3mBhgPO1zp9SbQspYubVuWgbZ1/+3p6ZUWAMbNNMbu1XqM=
X-Received: by 2002:a2e:a26f:0:b0:24b:5f6c:7899 with SMTP id
 k15-20020a2ea26f000000b0024b5f6c7899mr10925656ljm.4.1649864010205; Wed, 13
 Apr 2022 08:33:30 -0700 (PDT)
MIME-Version: 1.0
References: <cki.LEF6Q6V9CU1O7JTZ58AW@redhat.com> <YlZse4JgKRqMBdJ1@kroah.com> <CA+tGwnmKj22790PG3hVYbx_80cpSD_KfKc_qG-YpzQHYZWiYFA@mail.gmail.com>
In-Reply-To: <CA+tGwnmKj22790PG3hVYbx_80cpSD_KfKc_qG-YpzQHYZWiYFA@mail.gmail.com>
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Wed, 13 Apr 2022 17:33:19 +0200
Message-ID: <CA+QYu4q1EmP-_0My40Gz4e44XR8PzSPvR-1WLOFRmNaFDjzgYQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E17=2E2_=28stable=2D?=
        =?UTF-8?Q?queue=2C_eabfed45=29?=
To:     Veronika Kabatova <vkabatov@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     CKI Project <cki-project@redhat.com>,
        skt-results-master@redhat.com,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Li Wang <liwang@redhat.com>, Jan Stancek <jstancek@redhat.com>,
        Guangwu Zhang <guazhang@redhat.com>,
        Filip Suba <fsuba@redhat.com>,
        Fendy Tjahjadi <ftjahjad@redhat.com>,
        Yi Zhang <yizhan@redhat.com>,
        Changhui Zhong <czhong@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 13, 2022 at 2:51 PM Veronika Kabatova <vkabatov@redhat.com> wrote:
>
> On Wed, Apr 13, 2022 at 8:24 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Apr 13, 2022 at 06:03:14AM -0000, CKI Project wrote:
> > >
> > >
> > > Check out this report and any autotriaged failures in our web dashboard:
> > >     https://datawarehouse.cki-project.org/kcidb/checkouts/38921
> > >
> > > Hello,
> > >
> > > We ran automated tests on a recent commit from this kernel tree:
> > >
> > >        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > >             Commit: eabfed45bc7c - io_uring: drop the old style inflight file tracking
> >
> > It's alive!
> >
> > > The results of these automated tests are provided below.
> > >
> > >     Overall result: FAILED (see details below)
> > >              Merge: OK
> > >            Compile: OK
> > >              Tests: FAILED
> > >     Targeted tests: NO
> >
> > But things are failing.
> >
> > Is this the CKI tool's issue, or is it the patches in the stable queue's
> > issue?
> >
> > Given that CKI has been dead for so long, I'll guess it's a CKI issue
> > unless you all say otherwise.
> >
>
> Hi,
>
> yes, we finally got the builds fixed and are able to run the testing,
> and immediately hit the following Fedora bug:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=2074083
>
> We're looking into what exactly went wrong, the initial suspect is
> that the bug caused aborted test runs which confused the
> reporting system. Sorry about that, and thank you for reaching
> out about the problem!
>
> The listed failures are actual failures (both test and kernel bugs),
> but not specific to the stable tree. They were already reported to
> the relevant places. If you wish, you can look into the details in the
> provided DataWarehouse link.

Actually, we hit a panic that we don't know if it has been reported
yet. More logs at [1].

[  346.728135] CPU: 12 PID: 158 Comm: kworker/12:1H Tainted: G
 I       5.17.2 #1
[  346.770889] Hardware name: HP ProLiant SL390s G7/, BIOS P69 07/02/2013
[  346.805535] Workqueue: kblockd blk_mq_run_work_fn
[  346.827834] RIP: 0010:__bfq_deactivate_entity+0x168/0x240
[  346.855601] Code: 48 2b 41 28 48 85 c0 7e 05 49 89 5c 24 18 49 8b
44 24 08 4d 8d 74 24 08 48 85 c0 0f 84 d3 00 00 00 48 8b 7b 28 eb 03
48 89 c8 <48> 8b 48 28 48 8d 70 10 48 8d 50 08 48 29 f9 48 85 c9 48 0f
4f d6
[  346.947892] RSP: 0018:ffffac0943f6bbe0 EFLAGS: 00010086
[  346.973661] RAX: 9fa41f2000000000 RBX: ffff9ae8c9164748 RCX: 9fa41f2000000000
[  347.009384] RDX: ffff9aeaed07c0a8 RSI: ffff9aeaed07c0a8 RDI: 0000000ae2080ce1
[  347.044680] RBP: ffff9ae8c91646c0 R08: ffff9aeadd031960 R09: 0000004f9bf8c41b
[  347.080125] R10: 0000000000000001 R11: 0000000000000000 R12: ffff9aeadd031960
[  347.116032] R13: 0000000000000001 R14: ffff9aeadd031968 R15: ffff9ae8cb750748
[  347.150977] FS:  0000000000000000(0000) GS:ffff9aeacbb80000(0000)
knlGS:0000000000000000
[  347.198911] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  347.228754] CR2: 00007fb1e2c6ae14 CR3: 0000000340810005 CR4: 00000000000206e0
[  347.268138] Call Trace:
[  347.281292]  <TASK>
[  347.292058]  bfq_deactivate_entity+0x50/0xc0
[  347.313894]  bfq_del_bfqq_busy+0x91/0x190
[  347.335376]  bfq_remove_request+0x124/0x340
[  347.357453]  ? bfq_may_expire_for_budg_timeout+0xa5/0x1c0
[  347.385031]  ? _raw_spin_unlock_irqrestore+0x25/0x40
[  347.411908]  ? bfq_bfqq_served+0x132/0x1a0
[  347.433312]  bfq_dispatch_request+0x44d/0x12e0
[  347.454390]  ? sbitmap_get+0x90/0x1a0
[  347.472494]  blk_mq_do_dispatch_sched+0x109/0x370
[  347.496896]  ? finish_task_switch.isra.0+0xc1/0x2f0
[  347.520044]  ? __switch_to+0x77/0x430
[  347.537777]  __blk_mq_sched_dispatch_requests+0xd8/0x120
[  347.567004]  blk_mq_sched_dispatch_requests+0x30/0x60
[  347.592476]  __blk_mq_run_hw_queue+0x34/0x90
[  347.614232]  process_one_work+0x1c7/0x380
[  347.635369]  worker_thread+0x4d/0x380
[  347.652939]  ? _raw_spin_lock_irqsave+0x25/0x50
[  347.674477]  ? process_one_work+0x380/0x380
[  347.697082]  kthread+0xe9/0x110
[  347.712042]  ? kthread_complete_and_exit+0x20/0x20
[  347.735250]  ret_from_fork+0x22/0x30
[  347.753503]  </TASK>


[1] https://datawarehouse.cki-project.org/kcidb/tests/3193432

Thanks,
Bruno

> We're working on transforming the email reports to include the
> known issue detection that is currently provided in the dashboard,
> it should be in place in the (hopefully) near future. That should
> also stabilize the emails.
>
> Veronika
>
> > thanks,
> >
> > greg k-h
> >
>

