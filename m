Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D63241EEF0
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 15:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhJAN4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 09:56:06 -0400
Received: from mail.skyhub.de ([5.9.137.197]:46984 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231513AbhJAN4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 09:56:04 -0400
Received: from zn.tnic (p200300ec2f0e8e001f2e791e6d4c2984.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:8e00:1f2e:791e:6d4c:2984])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 92BB51EC0354;
        Fri,  1 Oct 2021 15:54:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1633096459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=n7NZ6CsYUzYt+ZZw63cyXvWPornkqmhriu39m35lizc=;
        b=C/V1PuCf9XH8ATkHIA+8XQH7Wku6FrY/WkwouGqGE6V6kzIMOtgEKa0w7H2bHSSDj7uce3
        sNczxucT7QjshyISnj20VYy8qFB3dmuzt5/2fh4Kv1M8DWJuljHgU+VRIPbQPG9D3fWR2M
        ZXsTY9uC27A0f5tOe0Hx+CL/zRmEoPo=
Date:   Fri, 1 Oct 2021 15:54:20 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/sev: Return an error on a returned non-zero
 SW_EXITINFO1[31:0]
Message-ID: <YVcTDM9hshdlUqbN@zn.tnic>
References: <efc772af831e9e7f517f0439b13b41f56bad8784.1633063321.git.thomas.lendacky@amd.com>
 <YVbYWz+8J7iMTJjc@zn.tnic>
 <00d48af4-1683-350c-c334-08968d455e4c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <00d48af4-1683-350c-c334-08968d455e4c@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 01, 2021 at 08:45:17AM -0500, Tom Lendacky wrote:
> I'm assuming you don't want this last sentence...

Bah, that's me fat-fingering it. It was supposed to say "No functional
changes."

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
