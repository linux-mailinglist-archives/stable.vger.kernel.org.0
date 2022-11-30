Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C95263DBB2
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 18:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiK3ROc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 12:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiK3ROJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 12:14:09 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25F7F73
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 09:11:50 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 1D3DD5C0091;
        Wed, 30 Nov 2022 12:11:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 30 Nov 2022 12:11:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1669828310; x=1669914710; bh=4mElADI/IX
        XJnXmWA7X8asfqgdwufhn4qjssxbo3aj0=; b=vcRhJjeNJb74qKiqzFcf+o5lYj
        czFoBLaZY1iJEOF/9ENpxZsfchNzW1Z4dtJ15633yZQ8CVa34bXqaGQcqwKm3Y4V
        jNP5Ez5ZoOp9nZXcnBcfnytdKY6YqrmvTurabYBFdOY321m4PzWNz/eyzEg/FY3f
        j0lXXL9Im6D92+cb1HlLNdYXJHWlpmSzGDnISoA9pgpXfqx9SbDOT0e5/J6hU/z5
        8E8rN3l5ZyCyLlnaduaU4LEDuRonA1qngaWR2Mhe+IT7gMDxycPawBF1GsxsGrO8
        yAOL9KqMzM/nrtdfLEZ3T1qMlD5RTqqdwMkY6FZkgxednzSoQLm0c0FvA3Xw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669828310; x=1669914710; bh=4mElADI/IXXJnXmWA7X8asfqgdwu
        fhn4qjssxbo3aj0=; b=k5EhGleu2rh8KQAV/Blx8eHGKGXL4HCiKjRQCawfC1Jm
        8whVXV5C42ajp3bfSAjCQMMN4v/QoC0TZI/xD3+Pfn24wjbvsWVFTN0vwgeBR6EG
        kHJBiYmUOmchSJMOlqkJLPH/j4gICeDAmEQe3WErD458ECP4Y28dKwFaebDvWhdL
        6cqVSx3CdlDg4epqU4I2DzxVfviXdQTgYEUYBnasaw6bOEKePVX24J50fW6eWUQT
        nFahTmXr9D2ujaGUGkawLBiOYoohprtD0bts2lSRwErJ6RRkbO0O3LAlklusWVV4
        isFkXxk/oogR0GrM1EcgYVScQfnrWKIzn/KH6qATQw==
X-ME-Sender: <xms:1Y6HY2HTrUXGS9ee5NU1GSl95RvKAM7BUZgomxJiioUnObgL-ZvO6A>
    <xme:1Y6HY3VCThp5WGVYt6ejfpnT6nHNw1xDiaBEyLcDQ5IvHY4WxBOGgikpvtEExT85C
    YLkr7t0iQNVng>
X-ME-Received: <xmr:1Y6HYwLCQzTLHlnmyX3A3M16X7JqiX8LNTVEQdIdM6mfVGqZDTgEf6aSSpiYtO4seviZ5J7Z2Aalvn3puD-i8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrtdefgdelhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:1o6HYwHT4vvYvpjaNW9jxoYNHAypzjiiMn7F8ha-tasBAvmdVdFO8Q>
    <xmx:1o6HY8WBVqi9XQIB--WYNJt2TVJmcg9ku6AczoSsn1NH8XvK0YGB9w>
    <xmx:1o6HYzPb7l3UDRBXPJ3t8ktHRc-qILoMrIGI0qc5sWpNim2kuocy5Q>
    <xmx:1o6HYwovT62-8xXmcvHqXLGvN92yV3tX3i0mk_7Mfdp_-gndamxqxg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Nov 2022 12:11:49 -0500 (EST)
Date:   Wed, 30 Nov 2022 18:11:47 +0100
From:   Greg KH <greg@kroah.com>
To:     Luiz Capitulino <luizcap@amazon.com>
Cc:     stable@vger.kernel.org, maz@kernel.org, tglx@linutronix.de,
        lcapitulino@gmail.com
Subject: Re: [PATH stable 5.15,5.10 0/4] Fix EBS volume attach on AWS ARM
 instances
Message-ID: <Y4eO07FChCui7Y6J@kroah.com>
References: <cover.1669655291.git.luizcap@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1669655291.git.luizcap@amazon.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 28, 2022 at 05:08:31PM +0000, Luiz Capitulino wrote:
> Hi,
> 
> [ Marc, can you help reviewing? Esp. the first patch? ]
> 
> This series of backports from upstream to stable 5.15 and 5.10 fixes an issue
> we're seeing on AWS ARM instances where attaching an EBS volume (which is a
> nvme device) to the instance after offlining CPUs causes the device to take
> several minutes to show up and eventually nvme kworkers and other threads start
> getting stuck.
> 
> This series fixes the issue for 5.15.79 and 5.10.155. I can't reproduce it
> on 5.4. Also, I couldn't reproduce this on x86 even w/ affected kernels.
> 
> An easy reproducer is:
> 
> 1. Start an ARM instance with 32 CPUs
> 2. Once the instance is booted, offline all CPUs but CPU 0. Eg:
>    # for i in $(seq 1 32); do chcpu -d $i; done
> 3. Once the CPUs are offline, attach an EBS volume
> 4. Watch lsblk and dmesg in the instance
> 
> Eventually, you get this stack trace:
> 
> [   71.842974] pci 0000:00:1f.0: [1d0f:8061] type 00 class 0x010802
> [   71.843966] pci 0000:00:1f.0: reg 0x10: [mem 0x00000000-0x00003fff]
> [   71.845149] pci 0000:00:1f.0: PME# supported from D0 D1 D2 D3hot D3cold
> [   71.846694] pci 0000:00:1f.0: BAR 0: assigned [mem 0x8011c000-0x8011ffff]
> [   71.848458] ACPI: \_SB_.PCI0.GSI3: Enabled at IRQ 38
> [   71.850852] nvme nvme1: pci function 0000:00:1f.0
> [   71.851611] nvme 0000:00:1f.0: enabling device (0000 -> 0002)
> [  135.887787] nvme nvme1: I/O 22 QID 0 timeout, completion polled
> [  197.328276] nvme nvme1: I/O 23 QID 0 timeout, completion polled
> [  197.329221] nvme nvme1: 1/0/0 default/read/poll queues
> [  243.408619] INFO: task kworker/u64:2:275 blocked for more than 122 seconds.
> [  243.409674]       Not tainted 5.15.79 #1
> [  243.410270] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  243.411389] task:kworker/u64:2   state:D stack:    0 pid:  275 ppid:     2 flags:0x00000008
> [  243.412602] Workqueue: events_unbound async_run_entry_fn
> [  243.413417] Call trace:
> [  243.413797]  __switch_to+0x15c/0x1a4
> [  243.414335]  __schedule+0x2bc/0x990
> [  243.414849]  schedule+0x68/0xf8
> [  243.415334]  schedule_timeout+0x184/0x340
> [  243.415946]  wait_for_completion+0xc8/0x220
> [  243.416543]  __flush_work.isra.43+0x240/0x2f0
> [  243.417179]  flush_work+0x20/0x2c
> [  243.417666]  nvme_async_probe+0x20/0x3c
> [  243.418228]  async_run_entry_fn+0x3c/0x1e0
> [  243.418858]  process_one_work+0x1bc/0x460
> [  243.419437]  worker_thread+0x164/0x528
> [  243.420030]  kthread+0x118/0x124
> [  243.420517]  ret_from_fork+0x10/0x20
> [  258.768771] nvme nvme1: I/O 20 QID 0 timeout, completion polled
> [  320.209266] nvme nvme1: I/O 21 QID 0 timeout, completion polled
> 
> For completion, I tested the same test-case on x86 with this series applied
> on 5.15.79 and 5.10.155 as well. It works as expected.

All now queued up, thanks.

greg k-h
