Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483B846FFC8
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 12:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240361AbhLJLbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 06:31:43 -0500
Received: from mail.skyhub.de ([5.9.137.197]:45570 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231759AbhLJLbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Dec 2021 06:31:43 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 213C01EC052C;
        Fri, 10 Dec 2021 12:28:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1639135683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZTPxc2UEeIcV5K/RSphIZCHZ0+2hghQppvwUwyj7b7M=;
        b=OXXnzYb0zK4HD7FGir5tB0/GaIQ0zz/eHeP4xrVfzwUftvg+gv0sEptdSFz3GhEEyZbPkT
        V756xQVUvI8mKfZACeLicj+TzS3F0VflyUMyiGXL1XNDtq89tZono44Yf/8jMKfLl4LNLK
        vcE1hKw/xalL6t7SFkJEyhp5jzaQhIk=
Date:   Fri, 10 Dec 2021 12:28:09 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Juergen Gross <jgross@suse.com>,
        John Dorminy <jdorminy@redhat.com>, tip-bot2@linutronix.de,
        anjaneya.chagam@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org,
        Hugh Dickins <hughd@google.com>,
        "Patrick J. Volkerding" <volkerdi@gmail.com>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and
 early param parsing
Message-ID: <YbM5yR+Hy+kwmMFU@zn.tnic>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com>
 <YbIeYIM6JEBgO3tG@zn.tnic>
 <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
 <YbIgsO/7oQW9h6wv@zn.tnic>
 <YbIu55LZKoK3IVaF@kernel.org>
 <YbIw1nUYJ3KlkjJQ@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YbIw1nUYJ3KlkjJQ@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 05:37:42PM +0100, Borislav Petkov wrote:
> Whatever we do, it needs to be tested by all folks on Cc who already
> reported regressions, i.e., Anjaneya, Hugh, John and Patrick.

Ok, Mike is busy so here are some patches for testing:

https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git/log/?h=rc4-boot

I'd appreciate it if folks who reported an issue, verify those.

The first two are reverts which should address the issues with mem=
folks have reported. And the last one should address Anjaneya's issue.

I guess doing it the way as Mike suggested is cleaner/better.

Thx!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
