Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286A447134D
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 11:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhLKK3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Dec 2021 05:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhLKK3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Dec 2021 05:29:35 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71764C061714;
        Sat, 11 Dec 2021 02:29:35 -0800 (PST)
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DD8671EC04E4;
        Sat, 11 Dec 2021 11:29:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1639218570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+0iQyOwcChbdqr2GEZMxmGLl5l4fOyNu1q9n0CdvLVs=;
        b=WWs0V+qkt+YynuVXNwBzD6yEAL3ipQUcP9MvPA1A3iESb7Sz6YLErJmyMKEZeO9NIOLyBv
        wTomezFh0jholVoPBDgzJlzj0PQORhl33fVkuQLDnaZlZEnEz9VXW5+BC16czUH9PBtTvN
        OSgejtRbi0m3qLR2dXqgX7XDq3rvFN8=
Date:   Sat, 11 Dec 2021 11:29:31 +0100
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
Message-ID: <YbR9i4sH/5aUn+FA@zn.tnic>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com>
 <YbIeYIM6JEBgO3tG@zn.tnic>
 <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
 <YbIgsO/7oQW9h6wv@zn.tnic>
 <YbIu55LZKoK3IVaF@kernel.org>
 <YbIw1nUYJ3KlkjJQ@zn.tnic>
 <YbM5yR+Hy+kwmMFU@zn.tnic>
 <CANGBn6-sWv81czvi+_pTMm4J4X=TGUR1Jg50k6BOqcCczDwONQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANGBn6-sWv81czvi+_pTMm4J4X=TGUR1Jg50k6BOqcCczDwONQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 10, 2021 at 02:32:38PM -0600, Patrick J. Volkerding wrote:
> I applied the two revert patches to 5.15.7 (the last one won't apply
> so I skipped it)

Looks like it is only a contextual conflict.

> and the resulting x86 32-bit kernel boots fine here on the Thinkpad
> X1E that was having issues previously.

Good.

> Then I tested an unpatched 5.16-rc4, which (as expected) got the boot
> hang on the affected machine. Applied the three patches, and the
> resulting kernel boots fine.

Thanks for testing!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
