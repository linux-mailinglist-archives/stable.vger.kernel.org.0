Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57153875E0
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 11:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348197AbhERKAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 06:00:18 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:50685 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243704AbhERKAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 06:00:17 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailnew.nyi.internal (Postfix) with ESMTP id B19E258068D;
        Tue, 18 May 2021 05:58:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Tue, 18 May 2021 05:58:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nakato.io; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding:content-type; s=fm1; bh=
        YjRFDfHDvjD/gWHqEwwW0JoTsp5k4MuBowDOGNA4CzI=; b=svJNOGdLhk6DW5Is
        X0/hi6ZFdKHNrcqEnUxnBDOS+fnwmDUyx9HRTohNpd7R2HNuenpEiln+E+5vB32C
        CrOEZjW0P5OALZeTCktgFWIkpfe0pOJBW1HfX3Gs8VLtWfpBHGskzhDFoWMMLXNx
        g9JPVg++WIUULLYkxXkcUlvvxpz3mjya0ebRtTcUocaiC9prja+wYt4WmFoEHBhr
        i2jC4WwSs45s6AVFvpkImAlSISeNfMCtuDxPKz6p/b4vvbm0n8wRdmwY+xppQZwk
        iHg8YAFSYzny86YwmlmIWIDLg2bVJOt8uq5p2rU7ZLuSO3yjXy8Y3jK+j3ryAXQr
        pgc2iQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=YjRFDfHDvjD/gWHqEwwW0JoTsp5k4MuBowDOGNA4C
        zI=; b=Nrsrirrqd+SDAUJDzrgzqed0W58P4Z3RRxJsP00RS4u7dyPa6aBEmEARL
        lObJJSiyXWIfQH09tcIo1TTEzydnZqzWmkeFYgZEtlx6Nw3all6dukYlUHWGXQ8N
        UTaJA3MZy/8bSNZxIVRrV8tDgs07jX69my+f8uvQuqvLnUdrfZH0NyPvwqjiJfwY
        joLnAwRsfF0+XSRzsmcIniBIvszMH++hauI11XwkD9qO759J6xPuaAEt4hh/HpAi
        vhwdz3LsxDmgJTqY4QwaG4ayZqSR+ZMTWTbtKDVZL4FfPW4z40aQmPL5Zj6iFmDK
        WsIsDsqb1wQv2N3tuXbts3ayn9tZg==
X-ME-Sender: <xms:4o-jYBusA05fVKYjhheBhGBqOGGJI_RhUDySMTkAQY7hOgUFyQ9hiw>
    <xme:4o-jYKelCt9dgNGJQ9qbZ1Vz0G3-QjbEZcpfqoJ8IHRslBA0KuOnTqmTigaIF-Ihw
    oIl0j5gV-njegD3mg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeijedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkfgjfhgggfgtsehtufertddttddvnecuhfhrohhmpefurggthhhi
    ucfmihhnghcuoehnrghkrghtohesnhgrkhgrthhordhioheqnecuggftrfgrthhtvghrnh
    epgeefkefgheevtddthfeihfevfffhhfejudelheelgfdvteekuefgkeffudeiudffnecu
    ffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepvddvtddrvdegtddrkedtrdeitd
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehnrghk
    rghtohesnhgrkhgrthhordhioh
X-ME-Proxy: <xmx:4o-jYEzqsAe2AT8Z5OpmSCsHKVOex8V30x1bmH2mbd39wyXsaZLjeQ>
    <xmx:4o-jYIN2x2PCQs1XNugsCKKA0Q4s_IATmLqGHWEXsiqNW37JNlIV_Q>
    <xmx:4o-jYB_sbsfjA-JCK2_ZDlHrN7fjK0kGJ6l8xI3-55rf1GgDNMjpQw>
    <xmx:44-jYAY-A9WYk4RXcQp4NgvogcfTjDIdIExVbuoHj-ZYc-cjBU9EcQ>
Received: from yuki.localnet (unknown [220.240.80.60])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 18 May 2021 05:58:53 -0400 (EDT)
From:   Sachi King <nakato@nakato.io>
To:     Maximilian Luz <luzmaximilian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        David Laight <David.Laight@aculab.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
Date:   Wed, 19 May 2021 05:58:53 +1000
Message-ID: <1952705.8WFvOeMrJb@yuki>
In-Reply-To: <87lf8ddjqx.ffs@nanos.tec.linutronix.de>
References: <87a6otfblh.ffs@nanos.tec.linutronix.de> <b509418f-9fff-ab27-b460-ecbe6fdea09a@gmail.com> <87lf8ddjqx.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, May 18, 2021 9:27:02 AM AEST Thomas Gleixner wrote:
> On Mon, May 17 2021 at 21:25, Maximilian Luz wrote:
> > On 5/17/21 8:40 PM, Thomas Gleixner wrote:
> >> Can you please add "apic=verbose" to the kernel command line and provide
> >> full dmesg output for a kernel w/o your patch and one with your patch
> >> applied?

I've linked to a dmesg with "apic=verbose" below with the irq 7 override hack 
applied.  Would you still like a copy without either of these patches applied?

What's the convention for including a dmesg on the mailing list?  I've 
included the copy via gist as pasting it into email seems incorrect, but 
that's also probably not the correct convention.

> Sachi, can you please try the hack below to confirm the above?
>
> It's not meant to be a solution, but it's the most trivial way to
> validate this.

I've applied that patch and the GPIO driver loads and functions.

The dmesg with the patch and "apic=verbose" I've placed at:
https://gist.github.com/nakato/08c6962a540d91b6f9597303d54bffe5

Thanks,
Sachi


