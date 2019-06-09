Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA6563A49A
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 12:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfFIKFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 06:05:09 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:38743 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727982AbfFIKFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 06:05:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3F3BE147B;
        Sun,  9 Jun 2019 06:05:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 06:05:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=v
        9RhOt5K8pig8IUB1/c4MefxJ4ff0hGkI5SiQ0YKmhM=; b=M9W2m1k52OBZ3yUsV
        wIDSvz0s6E468Nrsf8KFCXOlUcyB8WV2jvk8mznQbj4VbkU5RK0ltqNMqwjkqYIE
        R7XRUcJ2y6Fht+yKJ0n6TNAjS+RRMjfezFO3d8jdcmxYl5CUHERySLymG8iQaQya
        SLddgGT3jGl+m2okYkM4cCQws7ET52ONlBvFs07pKc4SZKrTY88dikWKAjidadzW
        Rq4PhYO0YvMYQ8ds7SdJtQS/d6fSbW8x+a5OxN2p6I0X/aW+1rV3FF531pNoiK8w
        ZBYzq8ZI1xhwZzpcevEijrzhM6hIEJg+ZY4opNZsge6CBbEkDCdnuux4mAaym14+
        +242Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=v9RhOt5K8pig8IUB1/c4MefxJ4ff0hGkI5SiQ0YKm
        hM=; b=oGqYk5Vj68WQDNX6tOArOgDYyQRCWJdESwE+aU6MCQqE6mS9x6s81vDVo
        pyojeElc67bHcMZkmdepsM5xLcgCXzxfuRVu4fILb0apFf/+iAMEJfxrfaDOkWSV
        +Ew8YwXaQYxAg3hVw09+hQT51BdzuOQc/Jv8NSRyI8jdZjM99CoM0ZBw0Jfj4Y7v
        qsXr0TqHqPZ5XRLLqTRWUAk+j3Or2AgYAvWZ0nOV9Pa4H1viz+Pw++fBa/l0InGd
        XkXXCtkolvOkXX8O4W8L4+qrY81e4Kff2rt+aus4p1s2vaxyBYcgdHzdNWrCODu9
        qZKTZMfUe6jD0w77663Lq637m7EYw==
X-ME-Sender: <xms:0dn8XMmRyjYSd4l7UCh5FY1FhPC5Pw-IPB92lyFwl9rMmSaxNPalng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtreejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:0dn8XOfITqJzI0KlFSHrByJX3ET22JL0zca2jcchTyoGEPSm02sHzw>
    <xmx:0dn8XPnZU6TCzcx2HoEZWn_Dss8CpXFm-xyVcTN7hXxVHlVgfgVF2A>
    <xmx:0dn8XLjShJ8GglpgN52ln6LvVPlGOReh0jQVl5m8ZdR7fbM45meJ-w>
    <xmx:09n8XJLcc5FubM7dPLls317JW-YkCgDPYOpxJmNZTH4FONKEpl-qpw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 96AD680059;
        Sun,  9 Jun 2019 06:05:04 -0400 (EDT)
Date:   Sun, 9 Jun 2019 12:05:02 +0200
From:   Greg KH <greg@kroah.com>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     sashal@kernel.org, jason@lakedaemon.net, jhogan@kernel.org,
        john@phrozen.org, ldir@darbyshire-bryant.me.uk,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        marc.zyngier@arm.com, paul.burton@mips.com, ralf@linux-mips.org,
        stable@vger.kernel.org, tglx@linutronix.de,
        Karl =?iso-8859-1?Q?P=E1lsson?= <karlp@etactica.com>
Subject: Re: [PATCH AUTOSEL 4.9 18/25] MIPS: perf: ath79: Fix perfcount IRQ
 assignment
Message-ID: <20190609100502.GB20602@kroah.com>
References: <20190507054123.32514-18-sashal@kernel.org>
 <1559856484-8579-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1559856484-8579-1-git-send-email-ynezz@true.cz>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 11:28:04PM +0200, Petr Štetiar wrote:
> Hi,
> 
> Karl has reported to me today, that he's experiencing weird reboot hang on his
> devices with 4.9.180 kernel and that he has bisected it down to my backported
> patch.
> 
> I would like to kindly ask you for removal of this patch.  This patch should
> be reverted from all stable kernels up to 5.1, because perf counters were not
> broken on those kernels, and this patch won't work on the ath79 legacy IRQ
> code anyway, it needs new irqchip driver which was enabled on ath79 with
> commit 51fa4f8912c0 ("MIPS: ath79: drop legacy IRQ code").

Thanks for the report, I'll go revert this from everywhere.

greg k-h
