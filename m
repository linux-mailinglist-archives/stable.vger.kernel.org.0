Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0635B120A3
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 18:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfEBQz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 12:55:28 -0400
Received: from mail.skyhub.de ([5.9.137.197]:36810 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbfEBQz1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 12:55:27 -0400
Received: from zn.tnic (p200300EC2F0E5C0069C19C6EF142D33D.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:5c00:69c1:9c6e:f142:d33d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BCC4F1EC0B6E;
        Thu,  2 May 2019 18:55:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1556816125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=PIj7f6Vl60nev2X9MXU4zduEfn5AFhZWx8S2Y6kNuFY=;
        b=VBKWWoTIRwRO+so2mNIFiuv8DEQ6x8Qop4ZdrGzhLGe8Vdx05fFvBonbB421hMEH5dJazr
        S1PF1s6nvBExTETc0yN0/MFoCLJ5k6yb64/Y1aKrNFbRQNl7GWui1P/bUmi5oXr7be2fnT
        UBPZT7LFq3M9ZunTN78JNPDNKgl22nU=
Date:   Thu, 2 May 2019 18:55:20 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@surriel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/fpu: Remove the _GPL from the kernel_fpu_begin/end()
 export
Message-ID: <20190502165520.GC6565@zn.tnic>
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>
 <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
 <CALCETrWTCB9xLVdKCODghpeQpJ_3Rz3OwE8FB+5hjYXMYwYPLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrWTCB9xLVdKCODghpeQpJ_3Rz3OwE8FB+5hjYXMYwYPLg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 09:29:01AM -0700, Andy Lutomirski wrote:
> I'm not saying that we should export things for ZFS's benefit.  But,
> as far as I know, _GPL means "this interface is sufficiently specific
> to Linux details that we think that any user must be a derived work".
> I don't think that kernel_fpu_begin() is an example of that.

But it is sufficiently specific. It is present on x86 and s390 only -
other arches don't have it.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
