Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C08492F62
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 21:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349233AbiARUbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 15:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349064AbiARUbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 15:31:10 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B0EC061574;
        Tue, 18 Jan 2022 12:31:10 -0800 (PST)
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EC03D1EC03AD;
        Tue, 18 Jan 2022 21:31:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1642537865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=WkkVICFiz4o18mp7n72l4G2wCmyz+ouiA4fSJrfrX0g=;
        b=IK9PC+4vS4ysSujPDar8Jh/YwzQLyQb8E4ioCQAx/siarK0nrpRAVPNOpjFEbVsq/sZj74
        lQXYTXJ9cKWsw+X+9Lnmiiu0mBoHFfHp2Xknn9ph05MyJlTdmBzKw8lWQq6IrEp2incz5N
        VjJ5z9CkA2HMK14JCwlx5HpVUkm+S0Y=
Date:   Tue, 18 Jan 2022 21:31:07 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     x86@kernel.org, linux-pci@vger.kernel.org,
        intel-gfx@lists.freedesktop.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Intel-gfx] [PATCH v5 1/5] x86/quirks: Fix stolen detection with
 integrated + discrete GPU
Message-ID: <Yecji9MQQhQiCcel@zn.tnic>
References: <YecI6S9Cx5esqL+H@zn.tnic>
 <20220118200145.GA887728@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220118200145.GA887728@bhelgaas>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 02:01:45PM -0600, Bjorn Helgaas wrote:
> Haha :)  I was hoping not to touch it myself because I think this
> whole stolen memory thing is kind of nasty.  It's not clear to me why
> we need it at all, or why we have to keep all this device-specific
> logic in the kernel, or why it has to be an early quirk as opposed to
> a regular PCI quirk.  We had a thread [1] about it a while ago but I
> don't think anything got resolved.

/me goes and skims over it.

OMG, what a mess. And OEM BIOS is involved.

Makes me wanna run away screaming.

> But to try to make forward progress, I applied patch 1/5 (actually,
> the updated one from [2]) to my pci/misc branch with the updated
> commit log and code comments below.

Yap.

And if that stops the continuous stream of new-platform-addition
patches, even better.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
