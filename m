Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F1EF4D59
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 14:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfKHNjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 08:39:39 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35529 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726445AbfKHNjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 08:39:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 50BCA21E95;
        Fri,  8 Nov 2019 08:39:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 08 Nov 2019 08:39:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=hXxWAprkwCVsslL8WokWliiwkaz
        Jd6QVnhi/kzNX7Z8=; b=QoXQy0p0HK5hcTolrFp4TzDVOFtuIn4AH6QFG1vBKHs
        FY03UKjr20wcZGgAdfL+1igODV7arPMl/R89YpW6N3XX/3y+n/oAw2BnewSuIOVX
        ATBrVSgmPB0KEn0svVD0hFdTTUb+yPyYFQNA6eplx3j/wTjk0NjRHndaR0a0QDSJ
        ULU/vuz1ZJn8MDsdV3ddtT8xgP7Ngei1aFd6ZnExWXSABTua2cLYLFr0lrjKJgXb
        RIzjZM+TdXc/TfRpNtG3k567mwiHMQ491p1zhYkOBnGzPpAiOtfE15rgxCVOPlHu
        sYfNkjm/2F47l1kI0/xNbqUE32MpLCwzQayP+mlwx6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hXxWAp
        rkwCVsslL8WokWliiwkazJd6QVnhi/kzNX7Z8=; b=q7PBnlb9phnNk9cPwie04/
        V7tcGTzwUSDjtYlSzskgwaTzgVz90ZoYCaJDMeCm26/dmkjMtMKL3DKem2SSZ76h
        7UhcDjkTtyKGbSKa6bTMR3oyRz27ZvxKYPybHv5Hw4hIPZyoOWE/lac9S2jqPc2c
        I0Icj9tdmWpikqFcmtUegvVEuFP2iac+71nvkr4w3bYHULPlWRG6aWQL2e/bjncE
        VB6JeZiQskwKLrXNeNUbp3l4nsWSB+qCKVQ2cjRjl4775b0tuys+z2GcqacO+c7o
        IOkLaLn3mnBqK2heHiAXAW+yahkFSWtSE6owC6poUmKMTojSm3s4iLQXv0JHSCmA
        ==
X-ME-Sender: <xms:GXDFXSG7suPZRVi6xdlCbntec3MiLnIxQkwP9o8hhD28uhCvfhh6QA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvuddgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:GXDFXfB80IVS7qNgdqZAhhP3YeWrj2rsGYC1cLFCKYQIdfVHn_Y-1g>
    <xmx:GXDFXb5oZ1Xkasd5Esv6SQfslhnOaryH_CCVNfWVSrr7kJs_N8_D8g>
    <xmx:GXDFXfRM8OCz_oXGDr4nvBKZL7UNFJppEElWH9N256asiY1JkkepFQ>
    <xmx:GnDFXRG8XbSeFlaFqEduFMbjKtQs1ecuMSM-LPIMPjEaau9eK2xxlg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7EDFC80064;
        Fri,  8 Nov 2019 08:39:37 -0500 (EST)
Date:   Fri, 8 Nov 2019 14:39:35 +0100
From:   Greg KH <greg@kroah.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, stable <stable@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH for-stable-4.4 08/50] arm/arm64: KVM: Advertise SMCCC v1.1
Message-ID: <20191108133935.GA853985@kroah.com>
References: <20191108123554.29004-1-ardb@kernel.org>
 <20191108123554.29004-9-ardb@kernel.org>
 <20191108131105.GA759061@kroah.com>
 <CAKv+Gu819gSLLtOOMDVwoO6UmGgy=ng8SLMzOY_UJeZMM9=sOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu819gSLLtOOMDVwoO6UmGgy=ng8SLMzOY_UJeZMM9=sOw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 02:29:21PM +0100, Ard Biesheuvel wrote:
> On Fri, 8 Nov 2019 at 14:11, Greg KH <greg@kroah.com> wrote:
> >
> > On Fri, Nov 08, 2019 at 01:35:12PM +0100, Ard Biesheuvel wrote:
> > > From: Mark Rutland <mark.rutland@arm.com>
> > >
> > > From: Marc Zyngier <marc.zyngier@arm.com>
> >
> > Lots of Mar[c/k]'s :)
> >
> > I'll fix this up...
> >
> 
> This is eactly how it appears in v4.9, so I just left it. Same for the
> double 'upstream commit' that you responded to.

Ick, I must have missed those there, sorry.

greg k-h
