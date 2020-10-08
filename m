Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC142287A9B
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 19:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731651AbgJHRIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 13:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731650AbgJHRIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 13:08:25 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A42C061755;
        Thu,  8 Oct 2020 10:08:25 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0a90005296687463b5d995.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:9000:5296:6874:63b5:d995])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 636841EC046E;
        Thu,  8 Oct 2020 19:08:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1602176901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fFlMiwAf1qEzpCJWFHmcAfA/G0zFYpmFDVQ+3qHs9Zc=;
        b=l9ljeQsWzUu+Ew8GyZBKsmN9E5pAKGvefTUZsjiHR+ubyuoI+RUIXQ5qv0u+icYB5eS/NV
        /bO29PFv4L8kbi0BvEbi/gPOeBVkEuNodUINTXqYe9YLnXl2/JA+GM/FJaIhlbp3/hvKDw
        HjKMt7sIRB1yfiizClBel2HrRiVz7h4=
Date:   Thu, 8 Oct 2020 19:08:13 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-tip-commits@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        stable <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [tip: ras/core] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
Message-ID: <20201008170813.GF5505@zn.tnic>
References: <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <160197822988.7002.13716982099938468868.tip-bot2@tip-bot2>
 <20201007111447.GA23257@zn.tnic>
 <20201007164536.GJ5607@zn.tnic>
 <20201007170305.GK5607@zn.tnic>
 <CAPcyv4jgLRzDzXkbdHwA-XUwWuSoA1tZfVqgvFQ5jxq=m2P_Bg@mail.gmail.com>
 <20201007192528.GL5607@zn.tnic>
 <CAPcyv4j=EfGKO6nNBggQunxmkOQqxAMX1M5kQDr68uU+ZQnRLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4j=EfGKO6nNBggQunxmkOQqxAMX1M5kQDr68uU+ZQnRLA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 08, 2020 at 09:59:26AM -0700, Dan Williams wrote:
> I'll draft a patch to rip it out. If you have a chance to grab it
> before the merge window, great, if not I can funnel it through
> nvdimm.git since the bulk of it will be touching
> tools/testing/nvdimm/.

Yeah, this is not urgent stuff to queue it now so I'd prefer it if
you funneled it after the merge window. It is enough that it lands in
5.10-final, I'd say, so that the export doesn't see an official release.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
