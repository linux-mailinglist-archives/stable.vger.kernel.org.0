Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445C6220E7C
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 15:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbgGONwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 09:52:53 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:48583 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729086AbgGONww (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 09:52:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D42BB8F5;
        Wed, 15 Jul 2020 09:52:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Jul 2020 09:52:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=n
        q4iZhdIJBB0pMs/jBc2gVB57W1xPaK7wixzTDqlSQM=; b=IWmAconde8sCNFasT
        z3tZPkbLa70v1IgZmvLRKH9T8fPBetXB1q5q84uaXe2yYe+TuwzrNKJhGQLcQmld
        Cem3wEOi1ZVvFJDTAhnInHv/ci7NcKBiGbXvX53NOnwKY1bCfMFji1nZc1ZWQ1Sa
        husOuRtO78PBqK+kPQBc0TlCUxWze5CNUgetyvc9sAs68fUUkAV7B3/WeKQEiu34
        TXCc2oL4HZYGST+cdHQ6SR1Rae9nkDxBkLf3J7mLbQSHrtWO5tHfvv8fh+xaVYqV
        5DjZ2xtZ4IPCksA3VPUQixjuB/APjrexOYMalg87n3ySLuV5v2+a1rNQlawuXxTj
        KilIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=nq4iZhdIJBB0pMs/jBc2gVB57W1xPaK7wixzTDqlS
        QM=; b=pE2QWba8wOetO5Ze6xKMDRgpej0UhnseFZJgRB95CA+XxFGy9cf1vUeby
        V0kpq8Ge9RbexNik3O/GTYg72Qi4HJTWQunqu+elwd8ISYdFPM5zPDsxx9wXamzK
        yDfvuHLKNPHYIlyDXC6mibOxzePKgt3iwG0UB/+ylvfphU2TMy8zByoV7tsCxejT
        omuTlbYaY1t5eN6pDs5dltScpwY2qQ0OmG19R+Z0uXqLlaroryUgAcQ6rSLEXO6r
        9GZcLeQZSYB6r7fIx3pToh4SKqWNuQoQcgnDD3IqDD6BoF4A7MHflDvtzInEQhA6
        w0lPfRZnyedU4i91Lg4fpURRMPlTw==
X-ME-Sender: <xms:MwoPX_19TJCnT7GCg-I2F2dim140LThFewO6BdP9aqhZzkecK3rxrA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueeuvd
    fhteevfefgfefgjeffueetvdetudfhffekjedvueffheegjeevgfelveenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgpdgrmhgriihonhgrfihsrdgtohhmnecukfhppeekfedrke
    eirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:MwoPX-EO9fymYjttv8lJJNwjU-27_pdkiRrBzr-5wyT583ZHrWaBSA>
    <xmx:MwoPX_7Tgax2dD8iHawvr2AGDnLpR55J49APtmDBVxj67gfWmkcbJQ>
    <xmx:MwoPX03jyA7E1HOmW2l5AXJJ9fw3VCG31Sc1h2JPKuWeZn45fYCY7Q>
    <xmx:MwoPX9zcHSWbMtrlfJJhzS8MEYHbPI49KhPUQxwO35zBTYn3XvHFeQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02792328005A;
        Wed, 15 Jul 2020 09:52:50 -0400 (EDT)
Date:   Wed, 15 Jul 2020 15:52:47 +0200
From:   Greg KH <greg@kroah.com>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Xiong Zhou <xzhou@redhat.com>
Subject: Re: =?utf-8?B?8J+SpSBQQU5JQ0tFRA==?= =?utf-8?Q?=3A?= Test report for
 kernel 5.7.9-rc1-c2fb28a.cki (stable)
Message-ID: <20200715135247.GB3342767@kroah.com>
References: <cki.9BE0703C38.BLD1GT3V8U@redhat.com>
 <2125467353.2778784.1594820204666.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2125467353.2778784.1594820204666.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 09:36:44AM -0400, Veronika Kabatova wrote:
> 
> 
> ----- Original Message -----
> > From: "CKI Project" <cki-project@redhat.com>
> > To: "Linux Stable maillist" <stable@vger.kernel.org>
> > Cc: "Xiong Zhou" <xzhou@redhat.com>
> > Sent: Wednesday, July 15, 2020 3:33:45 PM
> > Subject: 💥 PANICKED: Test report for kernel 5.7.9-rc1-c2fb28a.cki (stable)
> > 
> > 
> > Hello,
> > 
> > We ran automated tests on a recent commit from this kernel tree:
> > 
> >        Kernel repo:
> >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >             Commit: c2fb28a4b6e4 - Linux 5.7.9-rc1
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: PANICKED
> > 
> > All kernel binaries, config files, and logs are available for download here:
> > 
> >   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/07/14/610210
> > 
> > One or more kernel tests failed:
> > 
> >     s390x:
> >      ❌ Boot test
> >      ❌ Boot test
> >      💥 Boot test
> > 
> 
> Hi,
> 
> we started observing boot panics with 5.7 on s390x yesterday:
> 
> [    0.388965] Kernel panic - not syncing: Corrupted kernel text
> [    0.388970] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.7.8-0930ce5.cki #1
> [    0.388971] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)
> [    0.388975] Workqueue: events timer_update_keys
> [    0.388977] Call Trace:
> [    0.388980]  [<00000001378c868a>] show_stack+0x8a/0xd0
> [    0.388983]  [<0000000137e0c9c2>] dump_stack+0x8a/0xb8
> [    0.388985]  [<00000001378fa372>] panic+0x112/0x308
> [    0.388989]  [<00000001378d20b6>] jump_label_bug+0x7e/0x80
> [    0.388990]  [<00000001378d1fb8>] __jump_label_transform+0xa8/0xd8
> [    0.388992]  [<00000001378d200e>] arch_jump_label_transform+0x26/0x40
> [    0.388995]  [<0000000137a8d448>] __jump_label_update+0xb8/0x128
> [    0.388996]  [<0000000137a8dca6>] static_key_enable_cpuslocked+0x8e/0xd0
> [    0.388998]  [<0000000137a8dd18>] static_key_enable+0x30/0x40
> [    0.389000]  [<000000013798a0d2>] timer_update_keys+0x3a/0x50
> [    0.389003]  [<000000013791cdde>] process_one_work+0x206/0x458
> [    0.389005]  [<000000013791d078>] worker_thread+0x48/0x460
> [    0.389007]  [<0000000137924912>] kthread+0x12a/0x160
> [    0.389013]  [<00000001381b9a70>] ret_from_fork+0x2c/0x30
> 
> I only released one of the reports to not spam too much but the panics are
> still happening with the most recent code.
> 
> These panics are NOT present on the current mainline. All other arches are OK.
> 
> Given the call trace, I'm guessing it is something related to
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.7.y&id=477d4930b0c7e70c1ac3e3c35e5ad15c5ebde8be

Can you bisect to see if that really is the issue or not?

thanks,

greg k-h
