Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F2C15D3E
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfEGGPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:15:15 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:58495 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726253AbfEGGPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 02:15:15 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 341441601A;
        Tue,  7 May 2019 02:15:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 07 May 2019 02:15:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=rUkopSZotbELjC7owtPyRjHNKJ3
        xdDhDqSCz9ET9utg=; b=AS1BO+QbYPt06V80kSVUyssGF4Ba2f9z0Yh9quhHxX7
        zrTPAu78fNvUrbRquynL/OWR/4IEEMzcBsbZpmAu/T4N0OQWXP2TbpaZL/67OAhQ
        AMamKUBgCjwff5oVKKTOEy6EwglIpjt3hdXh9xMBRCkVveX7JxHP6YYZsqz+B7yJ
        /AulUBJNufJAwBfc1oRE1bbq/iVhrAXm2F2mxOyJ86zthq+zNVT6L7PBGqcM3XDA
        yLpCCiHazFsBS6/rBZ9253l7AbuuRSLqZUDSY38j0Cm7YKPDX8d7WnnOEwd3Zsp4
        H0iMIUQe9hopOSO2NoJT8PcIXgNSVkduzqx39088lJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rUkopS
        ZotbELjC7owtPyRjHNKJ3xdDhDqSCz9ET9utg=; b=i7ncgJF/yfrNdTLwnNSNGZ
        uPVA6ji2AnBVDI9n0r1y8pCK2yJNpSm7dQviwp0p4pawb8AQa9Vbho1pjtq0d9w6
        SthRziw6x+GHcMq7GS4kSzIn2isTqgz2I+FZYAL17RIsTws3jDF0qX4BU8Vw2DuY
        vrtCY+9WMmoOVmqv0UNVszGHh3+7HZxrUemQS8arYvwnDGndOxPKYPyxdBAX0NA2
        dVQzxz6Kebs3eu/f1S4gDNexxDJNCUv0wNXPIxfSqq1NkF/SBe99LBCL2fPaM/jE
        qMqjvpS1OMdgFqqsG41aexJD8oPWgSd8N1d+1k/8U7Y6puDsF2Nol6M61BfKJMGg
        ==
X-ME-Sender: <xms:byLRXO9BhqWoYOI1nD7awYSzoJh7Ykz-O04r0agOBB0_KZ-4c4GSZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrjeelgddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:byLRXC_C38TiyAvlCphEyaoBx2a4x19dVVLKoPi8hI9gDTgiZuWEJQ>
    <xmx:byLRXPDUumKl0Lwt1Ff01r_ny4oSa8EB8q_pjjZs5b1ZPEYEG9Tv4w>
    <xmx:byLRXKxTG2F7U2_wTmi4XGEK9Ymk8EJh6XiN7LmdDQAI7h7c_5Z2kQ>
    <xmx:cCLRXDVh-v28OmP-Eopnv_AALi3F7RfEzPEvMJkEHBXZMavn-R0Dwg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 813DDE4693;
        Tue,  7 May 2019 02:15:10 -0400 (EDT)
Date:   Tue, 7 May 2019 08:15:03 +0200
From:   Greg KH <greg@kroah.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: Re: [PATCH AUTOSEL 4.14 79/95] x86/asm: Remove dead __GNUC__
 conditionals
Message-ID: <20190507061503.GA20385@kroah.com>
References: <20190507053826.31622-1-sashal@kernel.org>
 <20190507053826.31622-79-sashal@kernel.org>
 <d18bba8c-0d2c-03bd-0098-5f39ad726b01@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d18bba8c-0d2c-03bd-0098-5f39ad726b01@rasmusvillemoes.dk>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 07:57:01AM +0200, Rasmus Villemoes wrote:
> On 07/05/2019 07.38, Sasha Levin wrote:
> > From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > 
> > [ Upstream commit 88ca66d8540ca26119b1428cddb96b37925bdf01 ]
> > 
> > The minimum supported gcc version is >= 4.6, so these can be removed.
> 
> Eh, that bump happened for the 4.19 kernel, so this is not true for the
> 4.14 branch. Has cafa0010cd51fb711fdcb50fc55f394c5f167a0a been applied
> to 4.14.y? Otherwise I don't think this is appropriate.

No, that commit is not in 4.14, so we still have to "support" older
versions of gcc there :(

Sasha, can you drop this?

thanks,

greg k-h
