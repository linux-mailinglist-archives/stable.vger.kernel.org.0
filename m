Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B879C470
	for <lists+stable@lfdr.de>; Sun, 25 Aug 2019 16:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbfHYOl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Aug 2019 10:41:26 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:44547 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727050AbfHYOl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Aug 2019 10:41:26 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C11604B1;
        Sun, 25 Aug 2019 10:41:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 25 Aug 2019 10:41:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=euIdDFIUuhGWAc5JPfSe49SEVIC
        f92+xDLrzF0aCOYQ=; b=I1A44ypYhlrwTa684qKfHqIph3BsoUangSW8JbOu+Xx
        wZXAKwh9M7Bq6/afb0mHC0+qWr+xt7l4ayPJOSnMAUje2aA7urCiX36dMM5VcHSY
        p2HVYdpqym26GMX0hzmabHpzvkfHk8kHa7603GwuUFEqGUB77w4+mZxRKydmnjEH
        9VFPo3UApBqiA5wgI8zVMH+mdFIitM4T/cVI1H8Vkp4vk65hDa4uU41LjOlS7rfM
        g7XEw1b1dZLZo13psVpVxW6bpQF14+FZ1OyoImFjPHjVENqsBOI4+fbFILoY46tt
        z18MD0bqcR8whjvZzLRMQVz70iwsrhFKRwhv23KrukA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=euIdDF
        IUuhGWAc5JPfSe49SEVICf92+xDLrzF0aCOYQ=; b=eU/MQdEiCexUH4m5psbNmu
        /qoBtmFH8u7/OiRr8dgHqkYCelOKU2VMSGhcN/8P94NLdS2IC2PxWlJP9DzIp1fg
        5/30Hy6GOdIhB9XBnWbrlZhHgCJEcwtKVzUGtzzWMIFx7BxvUts0i568oQkfMWCG
        zCRD23Ab/fKvcn6g/QMz53KHOQexYys1h/A04KqM8AM2bgXRFoJ5XQi3V6FztzzW
        nsqZKinXymFibTxSAHifCUUXrh4BUVMCH4XT7kiKd+JWToKhtMBLvbunn03j9xBQ
        Y9/QQBR0CJ8btimvseiKSKDL0f9gu5kCcpGFsqqeWbVpPIhsQAuQz3hMb/fqRp7g
        ==
X-ME-Sender: <xms:FJ5iXda4UimKzxb4ZH3A1q270av_JtDSBk2kY2uYssc2nD2WFCOtmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehvddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpegtkhhiqdhprh
    hojhgvtghtrdhorhhgpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddu
    tdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenuc
    evlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:FJ5iXYrstYSS3aPs0Qe0m9w1kxMxcXSizlmj-FV-KfJfhSCTMyyVRA>
    <xmx:FJ5iXa-f3HA5JfUvJ1Rt3yIeOg7z6qf1cVnbYdf-l5OnfG4ApBpMlg>
    <xmx:FJ5iXf9AukvQ6EimCMQpK7sLUUqgPKCEw4cLgdLo3UEyBu1jxD61qg>
    <xmx:FJ5iXWnbCTc2ubxUP0Aq-yWy-seQJ4uIwR-TsSudMY7CJTT75oXfvg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ADC798005A;
        Sun, 25 Aug 2019 10:41:23 -0400 (EDT)
Date:   Sun, 25 Aug 2019 16:41:22 +0200
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.2
Message-ID: <20190825144122.GA27775@kroah.com>
References: <cki.FF1370FEA1.W4XGF3MDGN@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.FF1370FEA1.W4XGF3MDGN@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 25, 2019 at 10:37:26AM -0400, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: f7d5b3dc4792 - Linux 5.2.10
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: FAILED
> 
> All kernel binaries, config files, and logs are available for download here:
> 
>   https://artifacts.cki-project.org/pipelines/123306
> 
> 
> 
> 
> When we attempted to merge the patchset, we received an error:
> 
>   error: patch failed: security/keys/trusted.c:1228
>   error: security/keys/trusted.c: patch does not apply
>   hint: Use 'git am --show-current-patch' to see the failed patch
>   Applying: KEYS: trusted: allow module init if TPM is inactive or deactivated
>   Patch failed at 0001 KEYS: trusted: allow module init if TPM is inactive or deactivated
> 
> We hope that these logs can help you find the problem quickly. For the full
> detail on our testing procedures, please scroll to the bottom of this message.
> 
> Please reply to this email if you have any questions about the tests that we
> ran or if you have any suggestions on how to make future tests more effective.
> 
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> ______________________________________________________________________________
> 
> Merge testing
> -------------
> 
> We cloned this repository and checked out the following commit:
> 
>   Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>   Commit: f7d5b3dc4792 - Linux 5.2.10
> 
> 
> We grabbed the cc88f4442e50 commit of the stable queue repository.
> 
> We then merged the patchset with `git am`:
> 
>   keys-trusted-allow-module-init-if-tpm-is-inactive-or-deactivated.patch

That file is not in the repo, I think your system is messed up :(
