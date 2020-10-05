Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE41283670
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 15:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgJENXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 09:23:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50123 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbgJENXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 09:23:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 48CCA5C014E;
        Mon,  5 Oct 2020 09:22:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 05 Oct 2020 09:22:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=Ypdawpj8XKnmlUnVD55o9HLE4JA
        XYVm93miPDZ+nBjw=; b=G8DXbfg+p79uHUAsm1v+Tu96DRCpvZUV16/0yP67yeO
        90mt9r+q4VX9qWPU6tNuZRXci9Mk6Dsd8XCNViainQmMoxqYzvPW4rorckzZu42U
        nmx4dh9QXRidBSQRt6VENUaej8f01Qqqu29SNzCv+s7HMEyE6itozqbZaznBBquQ
        DZwalQY/eLf2dj+0ioJAic7TN7JUMFcL27nqnXxVExZrjNTLfGz1aeE0sxYDYr3x
        0LKV0gickyLe1DTgxW5cxjr+QdetKFEo+subJN5Qo+eWk5RVvY1C1Kwo56a6V+as
        tvwlCgSQ38wClWYPG7OpsbgPIcd3vGvXlNUQ7G1znpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ypdawp
        j8XKnmlUnVD55o9HLE4JAXYVm93miPDZ+nBjw=; b=QoUyM4Y23BUDv2QS7baJ2T
        VIUydbJYhdwaz1J5NXVq/GuaZl5L5vzBA8Plum9D8JOgsDnvtBxPWWgDQLZr9inH
        qGDtoJpvl7uwWUtpk9jMeG7uOmjfd5ThN8jRGoNruAYdIZVznFamg13CVLzNXMJN
        4x1AS05qOAioegWWR6fK+1hblUxiwEcl47j4x6UZvoCLCXEEDhuC/3ByenFDVhJl
        DLkYOK9Fg+ROs7bgDiJvm1jw9l+z4624RQequHfo7ZnpPIETgVGlt8kQgzgnJF+t
        HYWjgQxVitRm7mEXNeVfvi9VNUED/aAmMYUHzNIoKdMnaNKQySchh9NDmJEimO0g
        ==
X-ME-Sender: <xms:Mh57XzXdLmYa0Sl7gnxBJPOP7vwUawCPZInXw_gmSq4xK46tmB7UzA>
    <xme:Mh57X7npg8d3JVEwKuNBdUHIF2aJv4AlVlNxYoFI-LeGYz0_ai9hoNHypHxU2zwyI
    xArueAYfsiT1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgedvgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:Mh57X_YRE1PWL0knZ9CHl39TS63KBPgpNRxzmGRX7-zJI1UTnz4EYA>
    <xmx:Mh57X-UV7aiVoLkXr65pNfPVKtEC0w5eTn9wq4_rr3obol3xe6Jhqg>
    <xmx:Mh57X9nU_e-6eXlPAZgnM0c6miG_8BpndbXhpfSTnF3kewt1q-JO4w>
    <xmx:Mx57XyxEE97RuOIUnZmY8YOqXfml-WQaQbpVFxLvTI9hJ1wFR8BeTw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C4603328006C;
        Mon,  5 Oct 2020 09:22:57 -0400 (EDT)
Date:   Mon, 5 Oct 2020 15:23:44 +0200
From:   Greg KH <greg@kroah.com>
To:     Revanth Rajashekar <revanth.rajashekar@intel.com>
Cc:     stable@vger.kernel.org, hch@lst.de, kbusch@kernel.org,
        damien.lemoal@wdc.com
Subject: Re: [PATCH 0/3] [backport] nvme: Consolidate chunk_sectors settings
Message-ID: <20201005132344.GB1506031@kroah.com>
References: <20200923025808.14698-1-revanth.rajashekar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923025808.14698-1-revanth.rajashekar@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 08:58:05PM -0600, Revanth Rajashekar wrote:
> Backport commit 38adf94e166e3cb4eb89683458ca578051e8218d and it's
> dependencies to linux-stable 5.4.y.
> 
> Dependent commits:
> 314d48dd224897e35ddcaf5a1d7d133b5adddeb7
> e08f2ae850929d40e66268ee47e443e7ea56eeb7
> 
> When running test cases to stress NVMe device, a race condition / deadlocks is
> seen every couple of days or so where multiple threads are trying to acquire
> ctrl->subsystem->lock or ctrl->scan_lock.
> 
> The test cases send a lot nvme-cli requests to do Sanitize, Format, FW Download,
> FW Activate, Flush, Get Log, Identify, and reset requests to two controllers
> that share a namespace. Some of those commands target a namespace, some target
> a controller.  The commands are sent in random order and random mix to the two
> controllers.
> 
> The test cases does not wait for nvme-cli requests to finish before sending more.
> So for example, there could be multiple reset requests, multiple format requests,
> outstanding at the same time as a sanitize, on both paths at the same time, etc.
> Many of these test cases include combos that don't really make sense in the
> context of NVMe, however it is used to create as much stress as possible.
> 
> This patchset fixes this issue.
> 
> Similar issue with a detailed call trace/log was discussed in the LKML
> Link: https://lore.kernel.org/linux-nvme/04580CD6-7652-459D-ABDD-732947B4A6DF@javigon.com/
> 
> Revanth Rajashekar (3):
>   nvme: Cleanup and rename nvme_block_nr()
>   nvme: Introduce nvme_lba_to_sect()
>   nvme: consolidate chunk_sectors settings
> 
>  drivers/nvme/host/core.c | 40 +++++++++++++++++++---------------------
>  drivers/nvme/host/nvme.h | 16 +++++++++++++---
>  2 files changed, 32 insertions(+), 24 deletions(-)

For some reason you forgot to credit, and cc: all of the people on the
original patches, which isn't very nice, don't you think?

Next time please be more careful.

greg k-h
