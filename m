Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E538646EB2F
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 16:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239593AbhLIPcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 10:32:22 -0500
Received: from mail.skyhub.de ([5.9.137.197]:51200 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239539AbhLIPcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 10:32:21 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4DC151EC0493;
        Thu,  9 Dec 2021 16:28:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1639063722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=I/CN4AvgWEIG3Q2qoQipTHj84Qrrl3byqwOm+sCJsN8=;
        b=DJy/5zDPcHUEGtMgBrA+f2jwnUHCW4ZjbDqfNQPOyA5bz96RSnV6INm0TwpVZG6LBEWhSg
        FutJTnWg161XD9EFFMdxu1vzuVfKRVSObzSTEMYPYsaBNp3Y0adXKRMWfnw4PLEv7IZvte
        YK0yIpTOch5oQPwUDfL/2gMgTkbkpbI=
Date:   Thu, 9 Dec 2021 16:28:48 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     John Dorminy <jdorminy@redhat.com>, tip-bot2@linutronix.de,
        anjaneya.chagam@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org,
        Hugh Dickins <hughd@google.com>,
        "Patrick J. Volkerding" <volkerdi@gmail.com>,
        Mike Rapoport <rppt@kernel.org>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and
 early param parsing
Message-ID: <YbIgsO/7oQW9h6wv@zn.tnic>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com>
 <YbIeYIM6JEBgO3tG@zn.tnic>
 <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 04:26:55PM +0100, Juergen Gross wrote:
> Sigh. This will break Xen PV. Again. The comment above the call of
> early_reserve_memory() tells you why.

I know. I was just looking at how to fix that particular thing and was
going to find you on IRC to talk to you about it...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
