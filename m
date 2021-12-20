Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB2747B373
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 20:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhLTTIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 14:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbhLTTIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 14:08:43 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD37C061574;
        Mon, 20 Dec 2021 11:08:42 -0800 (PST)
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 21DB61EC03E3;
        Mon, 20 Dec 2021 20:08:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1640027316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=6Kj6fV3H5G8bJXHXRh1uQP+tqsb/ecR+wZMVk72GGEE=;
        b=EYwPLfFpWSwzFjqAIXNVp0VMwqjZm5CCKfgtT6H/djUURQR98HE/Gs12Ba8rjDrU1qOe4T
        oOGU+apSSjjNiYSXOvgn2FaHBCsn20DnVSt6Wtd+nv8hc047DpyC5wdrb8A0ulGbMotL1+
        mzxDEf9CLRjb3CtHR6y6gdL7Bmn+Olg=
Date:   Mon, 20 Dec 2021 20:08:43 +0100
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
Message-ID: <YcDUu4+YhyKsvVBA@zn.tnic>
References: <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
 <YbIgsO/7oQW9h6wv@zn.tnic>
 <YbIu55LZKoK3IVaF@kernel.org>
 <YbIw1nUYJ3KlkjJQ@zn.tnic>
 <YbM5yR+Hy+kwmMFU@zn.tnic>
 <YbcCM81Fig3GC4Yi@kernel.org>
 <YbcTgQdTpJAHAZw4@zn.tnic>
 <CANGBn69pGb-nscv8tXN1UKDEQGEMWRKuPVPLgg+q2m7V_sBvHw@mail.gmail.com>
 <CANGBn6_cCd3ASh-9aec5qQkuK0s=mWbo90h0rMNwBiqsgb5AAA@mail.gmail.com>
 <YcDSpcO8giLoSMOn@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YcDSpcO8giLoSMOn@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 07:59:49PM +0100, Borislav Petkov wrote:
> Which reminds me - they need stable tags. Lemme add those.

Actually, it'll be a lot easier if I send backporting instructions to
the stable@ folks next week. Yap, I'll do that.

/me adds a TODO.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
