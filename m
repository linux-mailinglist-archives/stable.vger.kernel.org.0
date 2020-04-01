Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDEA019ACFF
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 15:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732504AbgDANlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 09:41:23 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48521 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732396AbgDANlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 09:41:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 91C775C0144;
        Wed,  1 Apr 2020 09:41:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 01 Apr 2020 09:41:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=+
        BuUULcnxUlCQFPLf87vowvwLxnHlbdiC0PSt6LrNno=; b=HHY6ZsoBXXnvRUFJP
        X44vr8yJAinlT80YE5KPrVj3FTPK+3HmOwiY4musdQkpQrDa1b07+i4RMF2M5HJ+
        4PtjCahYt7eg8MI/p/H8Zs+/wiUo4a4SyAhoU6VAFsuzryTlA+0KBmFYypo3U7oK
        G4OoDfGiejJ2zZrcOjh18x2GlD+2yrS/q/BSdawFQGxemHDu8fM/YIj100u3ofoW
        mGMEG3ZMKUGXJTQxHolT6qtTR2BJpOzcAYwBuJ0fZHOABQSXJDQcxMBGy96uEqlG
        Mmuw6i3L0C4FfZYAbPJdyXBnHzxTy1IPxUlu/cLqfEtwOkroytX95QHGGhEsykXO
        Z6pcQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=+BuUULcnxUlCQFPLf87vowvwLxnHlbdiC0PSt6LrN
        no=; b=mJ7EuDJmRbkxhTsMp7kmRb5IcRxnP6nRxitWgUQVdWu1PFMgKJn7CAD4O
        aZzm1XRldKUMz7xLx5g3qy5VRFaLbsCIZIxrM2CD/X16pt8E2e42UhQtqSE1bdvK
        m/6el0MiFXlDPydRmfGSoth/VBsn5jMW/jZ2kCb7ZFcqdMYA8pupYzLpx4vQ6cwe
        chIwihRU16pK84IbytFQ5lMOjRiXNuZsjhjy4eHYV1/D77+w53v5y08mm7WVvn/6
        CAvnyv0nS8DBhd8FBCOORxkiqDREGae18XE32XDGLFEZSfC3lV2gYfdimnz20WGa
        NFw878Qhx4rqTsrMVfq3z+qaR4kSg==
X-ME-Sender: <xms:AJqEXr8IE1xK8Jyoz4XAvImAyisTZUtOqm5w342Q7XFr1k5WomCMDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtddvgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:AZqEXr9IL6FsNOBpQmMxG4FJh-fobjv40dggGKNadcJMv4XYsOEh3A>
    <xmx:AZqEXkCAPJCwA527JO_KbGgge-LYC4D9ehM2xiVKS7Ukky01Jz4ZPw>
    <xmx:AZqEXrwk-45hcqlupyP0D6RoAbaFta63RjYOoYHuKKXeeFcbVpHKUg>
    <xmx:AZqEXvt5XPx1t9ACCI_SUPOJiaoQMe69Aus69NhAT52htLpWYaZZRA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AD052306CCA8;
        Wed,  1 Apr 2020 09:41:20 -0400 (EDT)
Date:   Wed, 1 Apr 2020 15:41:17 +0200
From:   Greg KH <greg@kroah.com>
To:     Georg =?iso-8859-1?Q?M=FCller?= <georgmueller@gmx.net>
Cc:     stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: Stable request: platform/x86: pmc_atom: Add Lex 2I385SW to
 critclk_systems DMI table
Message-ID: <20200401134117.GA2330532@kroah.com>
References: <8bdec034-3be9-1b5f-ab09-dfdbe153acba@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bdec034-3be9-1b5f-ab09-dfdbe153acba@gmx.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 10:28:49AM +0200, Georg Müller wrote:
> commit 95b31e35239e5e1689e3d965d692a313c71bd8ab upstream
> 
> This is a regression since linux v4.19, introduced with commit 648e921888ad96ea3dc922739e96716ad3225d7f.
> 
> Without this patch, one ethernet port of this board is not usable.
> 
> >From the currently maintained stable kernels, the patch 648e921888ad96ea3dc922739e96716ad3225d7f was also
> backported to linux-4.14.y, so I suggest to backport the patch to v4.14 and v4.19+.

All now queued up, thanks.

greg k-h
