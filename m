Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B21F3975A7
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 16:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhFAOlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 10:41:42 -0400
Received: from mail.skyhub.de ([5.9.137.197]:47108 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234160AbhFAOlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 10:41:42 -0400
Received: from zn.tnic (p200300ec2f111d00ecd9dee7e4b39a97.dip0.t-ipconnect.de [IPv6:2003:ec:2f11:1d00:ecd9:dee7:e4b3:9a97])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 50AC21EC04DA;
        Tue,  1 Jun 2021 16:39:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622558399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Ugfx5iGCMmRl+qWvsMyUybRKonTapw9bR3PV2BJ8Enw=;
        b=Fpd64TdHT5Cfzqvvwyydd5kR73WZG7Vejr6aTmkVtBCtCvkDOW9t/MAgRzzPv6iiCHh3p1
        zQobUBX/CbNkb3Gc728aROTsdgkDayjdXGvg1mncpPkbsZK6KZUOpazG2fwC33+B9EkABV
        yxmDP/B2t+L8kJDwc75/q16320N6Wck=
Date:   Tue, 1 Jun 2021 16:39:53 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Pu Wen <puwen@hygon.cn>
Cc:     Joerg Roedel <jroedel@suse.de>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        joro@8bytes.org, thomas.lendacky@amd.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        sashal@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/sev: Check whether SEV or SME is supported first
Message-ID: <YLZGuTYXDin2K9wx@zn.tnic>
References: <20210526072424.22453-1-puwen@hygon.cn>
 <YK6E5NnmRpYYDMTA@google.com>
 <905ecd90-54d2-35f1-c8ab-c123d8a3d9a0@hygon.cn>
 <YLSuRBzM6piigP8t@suse.de>
 <e1ad087e-a951-4128-923e-867a8b38ecec@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e1ad087e-a951-4128-923e-867a8b38ecec@hygon.cn>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 10:56:50PM +0800, Pu Wen wrote:
> Thanks for your suggestion, I'll try to set up early #GP handler to fix
> the problem.

Why? AFAICT, you only need to return early in sme_enable() if CPUID is
not "AuthenticAMD". Just do that please.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
