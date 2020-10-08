Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA14287239
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 12:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgJHKGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 06:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729148AbgJHKGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 06:06:20 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83097C061755
        for <stable@vger.kernel.org>; Thu,  8 Oct 2020 03:06:20 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C6RgG0Wqkz9sSn;
        Thu,  8 Oct 2020 21:06:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1602151578;
        bh=uzcQtunbIyI7pt736Imzp1NEubPV5O7L5FOd/FEjg4Y=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=rk18GFBMMlbyxIn5M25XRkAkieZXp5TOWji69AxWF2fgqD3oGT/xY+yphxUUh+wQM
         YxMSEvGvt/risrJye6SYaAjfb3vThJ2mijNlov+8crsPWYPljC26bu6iYEKnpQWJo6
         TURmjds8zDr19SW6GAkU7F5NOH0lUsBMqmmTSaeXHnyV8TEQiOxvLt2wkuLze3Fphw
         u/paMF+UYGZ21mpd8lVcop6hME0C1eFkPo+/2MvwUlmsydSCgo7+AAMp79gGWaZcID
         hsda3L+6DJmjJ/j519F/dbdX+70B79kmWFisqRTpPJMEig7DiQ8Gou7BKoNi802/nt
         9RDs6/5786zsg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Andrew Donnellan <ajd@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Cc:     leobras.c@gmail.com, nathanl@linux.ibm.com, dja@axtens.net,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] powerpc/rtas: Restrict RTAS requests from userspace
In-Reply-To: <421cba41-20bf-f874-c81a-8b7f9944c845@linux.ibm.com>
References: <20200820044512.7543-1-ajd@linux.ibm.com> <20200826135348.AD06422B4B@mail.kernel.org> <421cba41-20bf-f874-c81a-8b7f9944c845@linux.ibm.com>
Date:   Thu, 08 Oct 2020 21:06:16 +1100
Message-ID: <87v9fl117r.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andrew Donnellan <ajd@linux.ibm.com> writes:
> On 26/8/20 11:53 pm, Sasha Levin wrote:
>> How should we proceed with this patch?
>
> mpe: I believe we came to the conclusion that we shouldn't put this in 
> stable just yet?

Yeah.

Let's give it a little time to get some wider testing before we backport
it.

cheers
