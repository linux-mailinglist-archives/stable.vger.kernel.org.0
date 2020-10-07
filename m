Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4149028683E
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 21:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgJGTZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 15:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgJGTZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 15:25:49 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E25C061755;
        Wed,  7 Oct 2020 12:25:49 -0700 (PDT)
Received: from zn.tnic (p200300ec2f091000329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:1000:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 883371EC04C0;
        Wed,  7 Oct 2020 21:25:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1602098746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=opw1Qn/6cTt4NpJfsBA5sd2YWek1O4FfqlhC+eyT3aM=;
        b=cxY9OxZpm6DfnAkQUupidpmsqxSSqGyq0WMS8+fnY1iVoJmCLLGx7nWO8kNpfNFS9rHVjL
        ZwCvPE54E4nWfuzQoqqu1IzJXYiQvI+C0zn30UTd5jaar0q2QafzjPz7JgnYC6si9/q2OT
        aTf3xBzXCOOseh908jxiLYO5B8sILiI=
Date:   Wed, 7 Oct 2020 21:25:37 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-tip-commits@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        stable <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [tip: ras/core] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
Message-ID: <20201007192528.GL5607@zn.tnic>
References: <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <160197822988.7002.13716982099938468868.tip-bot2@tip-bot2>
 <20201007111447.GA23257@zn.tnic>
 <20201007164536.GJ5607@zn.tnic>
 <20201007170305.GK5607@zn.tnic>
 <CAPcyv4jgLRzDzXkbdHwA-XUwWuSoA1tZfVqgvFQ5jxq=m2P_Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4jgLRzDzXkbdHwA-XUwWuSoA1tZfVqgvFQ5jxq=m2P_Bg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 07, 2020 at 11:53:15AM -0700, Dan Williams wrote:
> Oh nice! I just sent a patch [1] to fix this up as well,

Yeah, for some reason it took you a while to see it - wondering if your
mail servers are slow again.

> but mine goes
> after minimizing when it is exported, I think perhaps both are needed.
> 
> http://lore.kernel.org/r/160209507277.2768223.9933672492157583642.stgit@dwillia2-desk3.amr.corp.intel.com

Looks like it. 

Why not rip out COPY_MC_TEST altogether though? Or you wanna do that
after the merge window?

It would be good to not have that export in 5.10 final if it is not
really needed.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
