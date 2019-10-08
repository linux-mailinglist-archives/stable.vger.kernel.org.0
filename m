Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D43BD00E4
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 20:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfJHS5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 14:57:53 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55975 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbfJHS5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 14:57:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 12B44216C5;
        Tue,  8 Oct 2019 14:57:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 14:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=N/GJHW/jVwZLDPbUsyjXJDc5wg+
        9rdi3j4sU/Vmwt/U=; b=YVZJs7m8+nT10upVwRHRrvN/s20nM7R2dPSyxemvK6c
        AoM/JCNtjR1M+1HTwuyLbhFzBjCejEcQhb4fxW6rGDgpXm2MwU2X/yhiHecVb1gH
        NZT4qLY1B5E0wJGBEz/LAneQXcoeks/s4GLtUpGbry3Jlad8ynqZRaPCTmD2kV3/
        cdN2gfSo2u00pB8zHw1etVdTwlzvH7zLDIDkH8RFrR4bHRaFpacIPimFiuBt06tG
        ZG8zGTGjb1fsrEXgZQchHsI/EXMSFuajbPUdPs/y6hUtioDINfvnF4fILw6goJeK
        f4erzXgKyA+1mzFPn3X8PSN4VqANdbMW3ObV8XArmBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=N/GJHW
        /jVwZLDPbUsyjXJDc5wg+9rdi3j4sU/Vmwt/U=; b=FszMLj1Dy+oVhHdQKLbb1Q
        N56SosYDf1qEiTuO5Metlz3oFgu4TdXGsGCUvE6K0qBU5K5CX2wPJEEHbgW3cSDN
        IGK2h+NeLN//P1n4XKT7dZhT8GOuXQP0NFC0GkxAzZ2I5yHBPleGZ9HV3Y93w73N
        sI/Oo2HGyzQWA6H0bS3hlVyBcMhL6bCU6WBL6Gv++aNP6dCLqh3WeCBlkNIIkL+9
        bUqVjG5QwmLR6axqxxg3M667KTzWRiS0B4RMuLe/tOlXCCT3J2OcyNzk7qWnrGqA
        bX0O2FxuW9dxgGR+1d2PxK19kZRZxI904a9Hoylke9yRDqq3vB3E3nYWq0ghWgYg
        ==
X-ME-Sender: <xms:L9ycXTMAkkdY9PJxOhtZeE7XNEBAg7ubFb9aEYvTDNeyfOLe3hA14A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgddufeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:L9ycXSG7H56lgfgudTQiQmEj2XL3wIWkPGVLJx5Y5M7aea95rX6juA>
    <xmx:L9ycXd0SPzksOJNQB0ZeIjOO21rqqy2IiOrrM8yXOr8I8nsvw0JVLw>
    <xmx:L9ycXZ8ZkJbpAX9vx9uGY2p9JsCMYaHop22K_ikxBdsgh-WDprI7hg>
    <xmx:MNycXfnhH2LbmoNEASWKCwIkHkpkjsJW7vyN6aYCofeKyYEJfn5Wyw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 583DED60068;
        Tue,  8 Oct 2019 14:57:51 -0400 (EDT)
Date:   Tue, 8 Oct 2019 20:57:49 +0200
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.3
Message-ID: <20191008185749.GA3061104@kroah.com>
References: <cki.D359265187.BIMX0KAWTD@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.D359265187.BIMX0KAWTD@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 02:03:35PM -0400, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 52020d3f6633 - Linux 5.3.5
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: FAILED

My fault, again, your builders are faster than mine :)

Fixing this now...
