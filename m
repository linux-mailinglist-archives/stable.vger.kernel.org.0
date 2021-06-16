Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150183A917D
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 07:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhFPF7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 01:59:09 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:40961 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229483AbhFPF7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 01:59:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 875CF580540;
        Wed, 16 Jun 2021 01:57:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 16 Jun 2021 01:57:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=6o2++wp3mzDB60pqIbQAizqx98C
        rlRSOwBDWbj2M7lc=; b=jBYt0LGpFJAtwLVmkqHh+GIs0Es+j2fONLOGzANuUL8
        0aTSr75ozKKLq3WTb/DAg9JdfcMyy3PLqza4Zl7OuplyN9KJ38JXkSqTKB4vdpym
        5G9lVVJK6Ve4x9/98UE1ctPhdAgPrCJTj5oHGoINMxLrHPPJM6Md553eDB1mSBzY
        Y4d2MrT8zj0O8EavljCAsub08xqUsCG8/rMnKsY7pGF3WhUTlcnOHFvaZJLhNKvA
        IaiMJBNeAhHRzBhU1aXYdZF9VQuMv1UfEX4U6s2hysVtAP7OpTdp35vWowpf65Gf
        /mbOPxFx+EYwYuUyhLUcDKRR3WItDsiF29dBacMMT1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6o2++w
        p3mzDB60pqIbQAizqx98CrlRSOwBDWbj2M7lc=; b=udIsree2BW1sB+/LAyCoHG
        MMqXLv5fYUKMxtBV8t5Zld4pUgPS+Zh1gfM4L9KgwCHqbUZ2ZzP70bhrG4exUmSX
        FnV+RCUERLLqe3RwgXNMf5w234SPYhN/2070ocg2cVJtBe+vzwQdY6MKdGSMI5g7
        U2Gj+O3jfnuz4FlbpR2sltf9uwpvDJgvz4Qe6V3LmTNoI41FcuojfGNv+5dj5kbE
        6FN15yXZvKwYTb0SNz/ifCCYL5Km+KlRMXE0KF6g8TqBhuVyO6BQxUeSI42/mLIM
        FwoB/9xHrmSbqNIRI7ff9w/1MGrQY2/lUuPSxOyJ5cCWEh7DeVN71JP85I0uJ0+A
        ==
X-ME-Sender: <xms:rZLJYNSD8EREOKAsrBpY3htjzO7Y1aQfMn7GGaw7-gQqo8wc1ugJUA>
    <xme:rZLJYGy1Phje62YO6evIx_ldlJcAATSU0RtNxDtRV0R8iJXyymnTgizZs1cv_A-5c
    LaW8ChAMaNyyQ>
X-ME-Received: <xmr:rZLJYC2foojFWULEKMiZ8iaGObNN_TGUWhxvuR1vMfKJpak_9VkjQwVlbzjdXTTLVDJAoqt1eGNDFZ7BwElOX1bb9As9SOFD>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvkedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:rZLJYFCgn1DOz1-Z8pv9qEd3ymDPpW5H1wd1sJNrwblyC7Wag53zPA>
    <xmx:rZLJYGjmAiT2Yn172VuhcS4JxIgKubtsGSvKb8k1Mgw-Sh-g8RpPsA>
    <xmx:rZLJYJomBAlllMseZ6rchNae2MdkNifVMef3wCWPf0rhBWAbyfPv1g>
    <xmx:rpLJYNTgjD7ie0xQh9cuYrlMEiKiCX4iEH5wlBovpNg3_s1ZtdgAyg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Jun 2021 01:57:00 -0400 (EDT)
Date:   Wed, 16 Jun 2021 07:56:58 +0200
From:   Greg KH <greg@kroah.com>
To:     Siddharth Gupta <sidgup@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 4/4] remoteproc: core: Cleanup device in case of
 failure
Message-ID: <YMmSqtZ9OGIWs+dW@kroah.com>
References: <1623783824-13395-1-git-send-email-sidgup@codeaurora.org>
 <1623783824-13395-5-git-send-email-sidgup@codeaurora.org>
 <YMj6N46ElCq/ndJJ@kroah.com>
 <75ce2563-3d34-a578-200d-8ec5f259d405@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75ce2563-3d34-a578-200d-8ec5f259d405@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 01:21:11PM -0700, Siddharth Gupta wrote:
> 
> On 6/15/2021 12:06 PM, Greg KH wrote:
> > On Tue, Jun 15, 2021 at 12:03:44PM -0700, Siddharth Gupta wrote:
> > > When a failure occurs in rproc_add() it returns an error, but does
> > > not cleanup after itself. This change adds the failure path in such
> > > cases.
> > > 
> > > Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >   drivers/remoteproc/remoteproc_core.c | 15 ++++++++++++---
> > >   1 file changed, 12 insertions(+), 3 deletions(-)
> > Why is this needed for stable kernels?  And again, a Fixes: tag?
> Patch 2 and patch 3 are leading up to fix rproc_add()
> in case of a failure. This means we'll have errors with
> use after free unless we call device_del() or cdev_del(),
> also the sysfs and devtempfs nodes will also not be
> removed.

Then please explain that better in the changelogs.  At it is, no one
knows this.

greg k-h
