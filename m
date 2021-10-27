Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EB543CF20
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 18:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243079AbhJ0Q6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 12:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239228AbhJ0Q6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 12:58:49 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C09DC061570;
        Wed, 27 Oct 2021 09:56:24 -0700 (PDT)
Received: from zn.tnic (p200300ec2f16150008d5435da1919031.dip0.t-ipconnect.de [IPv6:2003:ec:2f16:1500:8d5:435d:a191:9031])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3FBF31EC05C4;
        Wed, 27 Oct 2021 18:56:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1635353782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=la50gWpwm/spyVGR3nIgOBU5rlB3/xO06l9prKlvRhE=;
        b=hj4ufz3cntOCC00MItHDJmZeZeb//jQDI3+6qLBUzctktgdHXSejwBYaDOc/Ok1SMiRRlI
        2HYZr7roeP2j8/X/XSggwFLOsCSKb6rVvbO0v+LZkRw+srQJZuMti8Eahl2jVKTxR8BDIM
        spSAskJwKVFsgU9GDd32tZNMTfc4DpM=
Date:   Wed, 27 Oct 2021 18:56:19 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [PATCH v2] x86/sme: Explicitly map new EFI memmap table as
 encrypted
Message-ID: <YXmEo8iMNIn1esYC@zn.tnic>
References: <8afff0c64feb6b96db36112cb865243f4ae280ca.1634922135.git.thomas.lendacky@amd.com>
 <c997e8a2-b364-2a8e-d247-438e9d937a1e@amd.com>
 <CAMj1kXGH7aGR==o1L2dnA9U9L==gM0__10UGznnyZwkHrT84sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMj1kXGH7aGR==o1L2dnA9U9L==gM0__10UGznnyZwkHrT84sw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 05:14:35PM +0200, Ard Biesheuvel wrote:
> I could take it, but since it will ultimately go through -tip anyway,
> perhaps better if they just take it directly? (This will change after
> the next -rc1 though)
> 
> Boris?

Yeah, I'm being told this is not urgent enough to rush in now so you
could queue it into your fixes branch for 5.16 once -rc1 is out and send
it to Linus then. The stable tag is just so it gets backported to the
respective trees.

But if you prefer I should take it, then I can queue it after -rc1.
It'll boil down to the same thing though.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
