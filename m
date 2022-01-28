Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446204A00C4
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 20:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350841AbiA1TUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 14:20:23 -0500
Received: from mail.skyhub.de ([5.9.137.197]:52254 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbiA1TUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 14:20:22 -0500
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8157F1EC01A9;
        Fri, 28 Jan 2022 20:20:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1643397617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=vlzwt2PLRSPmoLbNVPUNnkeVkBKNImPqtNfQnN/CC2c=;
        b=B8qTFhvXRyJi4omb1U/oQ2XcUNioujOpveL0r1W9qb5/54iedVGFig+dYQgMedhVAg+CEs
        6b1/1zXIQM/mdIAYMxUkEAFKQTv2leXAtGeevljfsWzq2B+1a4g9adsJ8w8jwneflAt9pI
        E8VyliBJymoYIwgq+AWTWAqS+STL8wU=
Date:   Fri, 28 Jan 2022 20:20:17 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        stable <stable@vger.kernel.org>
Cc:     Dinh Nguyen <dinguyen@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/2] edac: altera: fix deferred probing
Message-ID: <YfRB8SSugBDHAcwH@zn.tnic>
References: <20220124185503.6720-1-s.shtylyov@omp.ru>
 <20220124185503.6720-2-s.shtylyov@omp.ru>
 <7b964ac0-6356-9330-a745-b43e620d051b@kernel.org>
 <YfQ3xUpLOPvDu5W+@zn.tnic>
 <ba83ca78-6a15-caf5-71ba-76d5b2b1b41d@omp.ru>
 <9f28d2de-5119-a7a6-9da7-08b2ce13f1a0@omp.ru>
 <YfRBCPRPkf+gD18/@zn.tnic>
 <5bd9cbc1-12d2-aedc-6d64-ac9eaa2460b1@omp.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5bd9cbc1-12d2-aedc-6d64-ac9eaa2460b1@omp.ru>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 28, 2022 at 10:17:55PM +0300, Sergey Shtylyov wrote:
>    My experience tells they do.

Let's ask them:

@stable folks, do you guys take patches based only on Fixes: tags
nowadays or you still require CC:stable to be present in the commit
message?

>    See my other mail...

Which other mail?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
