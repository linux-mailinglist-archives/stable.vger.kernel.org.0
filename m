Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B2D1024C8
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 13:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725280AbfKSMod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 07:44:33 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42095 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727351AbfKSMod (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 07:44:33 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 38B7221F48;
        Tue, 19 Nov 2019 07:44:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 19 Nov 2019 07:44:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=A
        gKsUYC5wShRE3TR3Lvnxx0Ev85NdtUK9me8zfIo5gY=; b=qnh5u3OlkiASOESd0
        pwpvRU1cXK0sJDndIcKcZjUrJMzh9vzLCd5vvXYn8EFG+kbRM5kh/j7SrvXtDArW
        liAbA7/zIvMt7wT2R72AXY0L8gjnCKSKAHUypfwIfKa0ZnW54g2+D162+Z+hOPmm
        kgJFDptmLi1vNj5+b4xSOmWstddnauciiHZv6ftpxAIsbHVJHP578//PK/Fq/Kh9
        j8K6rtOlrjriqhFHmPRVWWPU/RmL3243ryuRdXDZf011FM2aZH3OQ5hvMSA9Z+wq
        DL2tYXh9s8OtJiHd/cssESrDTL8Mj3V9weIF1y7A7dHOEZNvfalCvZEsxjgZJUWp
        S2kGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=AgKsUYC5wShRE3TR3Lvnxx0Ev85NdtUK9me8zfIo5
        gY=; b=Qc0QZE+mW1iSblromfrHE5pBTPlfXswqPSPE374xtglBi7UyUlHnOqtU8
        jvgyOxALFHY4i+1Vef3YwX+5CP4zC/O64+1BsesmgWQFjFGHxMkN1XqyscOVkESM
        JniaQs75/RHIFQy/kz8kQPOCYRIwF05mHUmyFMcFXqBwOVPWK/hOerk2HFx4xE9W
        i3iD/qfF59XlOVROjcjC91S8S/cVOnJI6BJKLs6gHgrGBAC+l6CqfbL47cW2zj+X
        JimSwmcsrHWJ5bVAsTXiiWXmP5fliINQeoRK1VveJfKl1/xsDjwu9hKPkqpqWWGw
        QfRfsBUQR1lYiV8deMCMjyPmzMFKg==
X-ME-Sender: <xms:r-PTXYMTQjP53wJvS3EHE4OBhur6Jg_5LdWCZi7fFqm91LwWy2-Vng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudegkedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtreejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinheptghkihdqph
    hrohhjvggtthdrohhrghdprhgvughhrghtrdgtohhmpdhkvghrnhgvlhdrohhrghenucfk
    phepkeelrddvtdehrddufedtrdelfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvg
    hgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:r-PTXTP2kmhFaL5EwjMm7N0fU9Cmgo4kwlxJZjFnQ02_Kz-Oes4TAA>
    <xmx:r-PTXaSSc4IOlOuqTnqFbPqaUlSDR8yrUVPxBRwzB6LCO-tDzmPGCQ>
    <xmx:r-PTXVDRI9cd0B0wN1-il-r4IAVRsCdLpxPTQgANX-uesG48wVlRew>
    <xmx:sOPTXdHDjBorpmNIsqi-fo5uK37Yg73TknxwdVYumPH4YjvV1p1eKg>
Received: from localhost (unknown [89.205.130.93])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4AFF28005A;
        Tue, 19 Nov 2019 07:44:31 -0500 (EST)
Date:   Tue, 19 Nov 2019 13:44:28 +0100
From:   Greg KH <greg@kroah.com>
To:     Laura Abbott <labbott@redhat.com>
Cc:     Rachel Sibley <rasibley@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.3
Message-ID: <20191119124428.GC1975017@kroah.com>
References: <cki.042792963E.5VOWULC1Q9@redhat.com>
 <8e0fa6de-b6b1-23ac-9e77-d425c8d1ba22@redhat.com>
 <c326c35e-453e-2dae-391c-5324803e6112@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c326c35e-453e-2dae-391c-5324803e6112@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 07:37:09AM -0500, Laura Abbott wrote:
> On 11/18/19 7:07 PM, Rachel Sibley wrote:
> > 
> > On 11/18/19 10:00 AM, CKI Project wrote:
> > > Hello,
> > > 
> > > We ran automated tests on a patchset that was proposed for merging into this
> > > kernel tree. The patches were applied to:
> > > 
> > >         Kernel repo:https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> > >              Commit: 116a395b7061 - Linux 5.3.11
> > > 
> > > The results of these automated tests are provided below.
> > > 
> > >      Overall result: FAILED (see details below)
> > >               Merge: OK
> > >             Compile: OK
> > >               Tests: FAILED
> > > 
> > > All kernel binaries, config files, and logs are available for download here:
> > > 
> > >    https://artifacts.cki-project.org/pipelines/293063
> > > 
> > > One or more kernel tests failed:
> > > 
> > >      aarch64:
> > >       ❌ LTP lite
> > 
> > I see a panic when installing the LTP dependencies
> > 
> > [  690.625060] Call trace:
> > [  690.627495]  bfq_find_set_group+0x8c/0xf0
> > [  690.631491]  bfq_bic_update_cgroup+0xbc/0x218
> > [  690.635834]  bfq_init_rq+0xac/0x808
> > [  690.639309]  bfq_insert_request.isra.0+0xe0/0x200
> > [  690.643999]  bfq_insert_requests+0x68/0x88
> > [  690.648085]  blk_mq_sched_insert_requests+0x84/0x140
> > [  690.653036]  blk_mq_flush_plug_list+0x170/0x2b0
> > [  690.657555]  blk_flush_plug_list+0xec/0x100
> > [  690.661725]  blk_mq_make_request+0x200/0x5e8
> > [  690.665982]  generic_make_request+0x94/0x270
> > [  690.670239]  submit_bio+0x34/0x168
> > [  690.673712]  xfs_submit_ioend.isra.0+0x9c/0x180 [xfs]
> > [  690.678798]  xfs_do_writepage+0x234/0x458 [xfs]
> > [  690.683318]  write_cache_pages+0x1a4/0x3f8
> > [  690.687442]  xfs_vm_writepages+0x84/0xb8 [xfs]
> > [  690.691874]  do_writepages+0x3c/0xe0
> > [  690.695438]  __writeback_single_inode+0x48/0x440
> > [  690.700042]  writeback_sb_inodes+0x1ec/0x4b0
> > [  690.704298]  __writeback_inodes_wb+0x50/0xe8
> > [  690.708555]  wb_writeback+0x264/0x388
> > [  690.712204]  wb_do_writeback+0x300/0x358
> > [  690.716113]  wb_workfn+0x80/0x1e0
> > [  690.719418]  process_one_work+0x1bc/0x3e8
> > [  690.723414]  worker_thread+0x54/0x440
> > [  690.727064]  kthread+0x104/0x130
> > [  690.730281]  ret_from_fork+0x10/0x18
> > [  690.733847] Code: eb00007f 54000220 b4000040 f8568022 (f9401c42)
> > [  690.739928] ---[ end trace d3fd392f569e86d3 ]---
> > 
> > https://artifacts.cki-project.org/pipelines/293063/logs/aarch64_host_2_console.log
> > 
> 
> This looks like that same issue
> https://bugzilla.redhat.com/show_bug.cgi?id=1767539
> 
> I don't think the BFQ fix has been sent to stable yet, or at least
> it was not in 5.3.11

Any specific git commit id I should be picking up for this?

thanks,

greg k-h
