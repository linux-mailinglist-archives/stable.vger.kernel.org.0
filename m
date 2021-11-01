Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF715441DBD
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 17:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhKAQNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 12:13:07 -0400
Received: from mail.skyhub.de ([5.9.137.197]:37270 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230517AbhKAQNG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 12:13:06 -0400
Received: from zn.tnic (p200300ec2f0cfa005d2c15110524cf3f.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:fa00:5d2c:1511:524:cf3f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E3EEA1EC0399;
        Mon,  1 Nov 2021 17:10:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1635783032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=cNsdwN4kKqk3161ajpvhRVfJcWO0W7ga/sbEAeYvU0A=;
        b=gM5qhsjPBTvrmKdXG/5HtueWzax3vGYxTRXR2FVKwwYSC4zZS6r3n2C2iGcZoX8XODyiPL
        UDWJGYDmI+8ncxmpPCjc9XdxdOETd6fEDqfkkkm/7QTOA5nK6A0sOPB0QozLxu0T4iS7VJ
        XR0HA2rgVU8uUt/+0SAC+yykmI6XvT8=
Date:   Mon, 1 Nov 2021 17:10:25 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Eric Biederman <ebiederm@xmission.com>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kexec@lists.infradead.org, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 01/12] kexec: Allow architecture code to opt-out at
 runtime
Message-ID: <YYARccITlowHABg1@zn.tnic>
References: <20210913155603.28383-1-joro@8bytes.org>
 <20210913155603.28383-2-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210913155603.28383-2-joro@8bytes.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 05:55:52PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Allow a runtime opt-out of kexec support for architecture code in case
> the kernel is running in an environment where kexec is not properly
> supported yet.
> 
> This will be used on x86 when the kernel is running as an SEV-ES
> guest. SEV-ES guests need special handling for kexec to hand over all
> CPUs to the new kernel. This requires special hypervisor support and
> handling code in the guest which is not yet implemented.
> 
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  include/linux/kexec.h |  1 +
>  kernel/kexec.c        | 14 ++++++++++++++
>  kernel/kexec_file.c   |  9 +++++++++
>  3 files changed, 24 insertions(+)

I guess I can take this through the tip tree along with the next one.

Eric?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
