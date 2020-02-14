Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B394415F77D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 21:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388952AbgBNULt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 15:11:49 -0500
Received: from mail.skyhub.de ([5.9.137.197]:53778 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387674AbgBNULt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 15:11:49 -0500
Received: from zn.tnic (p200300EC2F0D5A00D5EC2BA3BD6A59D8.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:5a00:d5ec:2ba3:bd6a:59d8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8220F1EC0C49;
        Fri, 14 Feb 2020 21:11:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1581711107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=WtbrNzLdMFduip9mrfKODkLFFhWDVuVcXtAZTycd370=;
        b=CUWXwqS/1Z0ytRk82SPqQNC1oIuOSHEpxwsDmRqIFI/MG0uwkcH6MM09B6Teyc6U283sH8
        k9SX8PcZmDqVZZtjCVt7zjdl0YcL+LyKg4Mu8sVHg231s2tGIIvF1U1fanvXz2WAez79Vs
        AO9HTBpm4R5eKzhaivJz5OIAQDqACS4=
Date:   Fri, 14 Feb 2020 21:11:43 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, X86 ML <x86@kernel.org>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/mce/amd: Fix kobject lifetime
Message-ID: <20200214201143.GQ13395@zn.tnic>
References: <20200214082801.13836-1-bp@alien8.de>
 <20200214083230.GA13395@zn.tnic>
 <20200214151727.GA3959278@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200214151727.GA3959278@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 07:17:27AM -0800, Greg KH wrote:
> Does not bother me at all, it's fine to see stuff come by that will end
> up in future trees, it's not noise at all.  So no need to suppress
> stable@vger if you don't want to.

Ok, but what about your formletter which you send to people explaining
this is not how you should send a patch to stable?

Like this, for example:

https://lkml.kernel.org/r/20200116100925.GA157179@kroah.com

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
