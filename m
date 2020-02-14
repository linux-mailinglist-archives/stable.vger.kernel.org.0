Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1868415F7CB
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 21:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387472AbgBNUgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 15:36:37 -0500
Received: from mail.skyhub.de ([5.9.137.197]:56988 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387432AbgBNUgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 15:36:36 -0500
Received: from zn.tnic (p200300EC2F0D5A00D5EC2BA3BD6A59D8.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:5a00:d5ec:2ba3:bd6a:59d8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7C4911EC0CF7;
        Fri, 14 Feb 2020 21:36:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1581712595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=83Vxjz/IRtC6k8sZzXSo5bZQ7tVlSei7QAqOPLK9/a4=;
        b=AxHIiGFRakSY7liIFsmmSrbOlRKriN/65/vtCgMLZfkCefUIR6GKf2IOa45spj4JtIcgKh
        WmHCf+uPBWy5I0M/MQhREcRsSXKcYa1ExM9+9crYKI32TTvYGQbaRnqYuGF9Id2sYmH7Y6
        +EShM7zMX7XAvlJ3EI12O5VmfNHW1Ww=
Date:   Fri, 14 Feb 2020 21:36:25 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        X86 ML <x86@kernel.org>, Yazen Ghannam <Yazen.Ghannam@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/mce/amd: Fix kobject lifetime
Message-ID: <20200214203625.GS13395@zn.tnic>
References: <20200214082801.13836-1-bp@alien8.de>
 <20200214083230.GA13395@zn.tnic>
 <20200214151727.GA3959278@kroah.com>
 <20200214201143.GQ13395@zn.tnic>
 <87a75kud8o.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87a75kud8o.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 09:26:31PM +0100, Thomas Gleixner wrote:
> This once Cc'ed stable but lacked a Cc: stable tag in the changelog.

So that's the difference. Ok, I'm fine with that.

/me removes "suppresscc = bodycc" from his .gitconfig again.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
