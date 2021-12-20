Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352D347B34F
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240620AbhLTS7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:59:48 -0500
Received: from mail.skyhub.de ([5.9.137.197]:55208 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235112AbhLTS7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 13:59:48 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 83E5A1EC03E3;
        Mon, 20 Dec 2021 19:59:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1640026782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fHiGX6yDgTud+wFWGgTd535xV9pRxQfKjBv0lrEdXcE=;
        b=I5VNZB9WgwOMBwnubGIeQ5xqcnHsyR3yVUUhsHhyVqQWsMRum5bdMfgkRSBTi2qophZSVl
        ub0fjIE3xohKYDw4ImclTVSX0Cxq+O4/rVL0fIH8MmU/WLziUwuSO4Dd0P90yCQuGigfwV
        q/bxBz/++syOJ+v+CbDvNOeHtVDe5h0=
Date:   Mon, 20 Dec 2021 19:59:49 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Patrick J. Volkerding" <volkerdi@gmail.com>
Cc:     Mike Rapoport <rppt@kernel.org>, Juergen Gross <jgross@suse.com>,
        John Dorminy <jdorminy@redhat.com>, tip-bot2@linutronix.de,
        anjaneya.chagam@intel.com, dan.j.williams@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        linux-tip-commits@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and
 early param parsing
Message-ID: <YcDSpcO8giLoSMOn@zn.tnic>
References: <YbIeYIM6JEBgO3tG@zn.tnic>
 <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
 <YbIgsO/7oQW9h6wv@zn.tnic>
 <YbIu55LZKoK3IVaF@kernel.org>
 <YbIw1nUYJ3KlkjJQ@zn.tnic>
 <YbM5yR+Hy+kwmMFU@zn.tnic>
 <YbcCM81Fig3GC4Yi@kernel.org>
 <YbcTgQdTpJAHAZw4@zn.tnic>
 <CANGBn69pGb-nscv8tXN1UKDEQGEMWRKuPVPLgg+q2m7V_sBvHw@mail.gmail.com>
 <CANGBn6_cCd3ASh-9aec5qQkuK0s=mWbo90h0rMNwBiqsgb5AAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANGBn6_cCd3ASh-9aec5qQkuK0s=mWbo90h0rMNwBiqsgb5AAA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 12:49:52PM -0600, Patrick J. Volkerding wrote:
> Trying again since gmail didn't use plain text and the message got rejected.
> 
> We're waiting for these patches to appear in a 5.15 kernel so that we
> can ship with an unpatched kernel. Will they be queued for the stable
> kernels sometime soon?

Yes, they're currently queued here:

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=x86/urgent

and will go to Linus on the weekend.

Which reminds me - they need stable tags. Lemme add those.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
