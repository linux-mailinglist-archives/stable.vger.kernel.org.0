Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC374A2DAF
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 11:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiA2Kdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 05:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiA2Kdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 05:33:41 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116C8C061714;
        Sat, 29 Jan 2022 02:33:41 -0800 (PST)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 940E61EC0501;
        Sat, 29 Jan 2022 11:33:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1643452415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=nWuW5Rrkh3ELO0P84pcGinhQ5TcZuFPxDKPwk5ziKUw=;
        b=qu5+zGxcAw0G6JWIUaU8wpDJ4dpnPD2qasN7Hl1fERehyXFjBI3f/n8v/rMfpGecgjZHp9
        Pn2clm4UmnJbLBHKhldyHTFQrp7+zmgBxw8KMHtMkMvpyoq+F2GdHRU4hd7jx5lmS7N4Zx
        MuqRIJO+1Mr97XuKXSsIbIq8K082Bms=
Date:   Sat, 29 Jan 2022 11:33:35 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Greg KH <greg@kroah.com>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        stable <stable@vger.kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/2] edac: altera: fix deferred probing
Message-ID: <YfUX/98NiydSGn9S@zn.tnic>
References: <20220124185503.6720-1-s.shtylyov@omp.ru>
 <20220124185503.6720-2-s.shtylyov@omp.ru>
 <7b964ac0-6356-9330-a745-b43e620d051b@kernel.org>
 <YfQ3xUpLOPvDu5W+@zn.tnic>
 <ba83ca78-6a15-caf5-71ba-76d5b2b1b41d@omp.ru>
 <9f28d2de-5119-a7a6-9da7-08b2ce13f1a0@omp.ru>
 <YfRBCPRPkf+gD18/@zn.tnic>
 <5bd9cbc1-12d2-aedc-6d64-ac9eaa2460b1@omp.ru>
 <YfRB8SSugBDHAcwH@zn.tnic>
 <YfTjQukS1ad9ZBmK@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfTjQukS1ad9ZBmK@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 07:48:34AM +0100, Greg KH wrote:
> If you know you want a patch in the stable tree, add cc: stable.
> 
> Because not all maintainers remember to do so, we do dig through all
> patches with just the fixes: tag, and try to backport them if needed,
> but it does not always happen, and there can be long lags as well.
> 
> So again, if you know you want it in a stable kernel, add the cc:
> stable.

Thanks for clarifying. I already did so - I figured having cc:stable
won't hurt anyway. Besides, it is an explicit statement that "that patch
is stable material" because Fixes: doesn't always necessarily mean,
stable material.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
