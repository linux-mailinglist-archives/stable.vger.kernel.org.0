Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E20827EF0A
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 18:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725372AbgI3QYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 12:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3QYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 12:24:07 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E2DC061755;
        Wed, 30 Sep 2020 09:24:07 -0700 (PDT)
Received: from zn.tnic (p200300ec2f092a00869c7b979af15d7f.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:2a00:869c:7b97:9af1:5d7f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A7F721EC0434;
        Wed, 30 Sep 2020 18:24:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1601483045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Gbs7UxauJjEkYrfMVnJyv7CastcVv+QAaiIafDQjXU8=;
        b=ZdEIW2U5/fuvtf/jx+1eahZcaViyZL5P2HJQoM/Rp1BamHLMcJ6lB/e/e+WwvDYEwIRfSw
        dNPNBV6pQyLtjwiEHsLZmm3Ba4oiinZ7VGz5qJqCdRwt+eizYSDD3LhOWi0SYxoVymYrwG
        +NWUCKz3ci1s4ayIt/9vT5+8MSOkq2s=
Date:   Wed, 30 Sep 2020 18:24:03 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        stable <stable@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        0day robot <lkp@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v9 0/2] Renovate memcpy_mcsafe with copy_mc_to_{user,
 kernel}
Message-ID: <20200930162403.GI6810@zn.tnic>
References: <160087928642.3520.17063139768910633998.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4iPuRWSv_do_h8stU0-SiWxtKkQWvzBEU+78fDE6VffmA@mail.gmail.com>
 <20200930050455.GA6810@zn.tnic>
 <CAPcyv4j=eyVMbcnrGDGaPe4AVXy5pJwa6EapH3ePh+JdF6zxnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4j=eyVMbcnrGDGaPe4AVXy5pJwa6EapH3ePh+JdF6zxnQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 30, 2020 at 08:49:42AM -0700, Dan Williams wrote:
> There's been a paucity of response on these after converging on the
> feedback from Linus. They missed v5.9, and I started casting about for
> what could be done to make sure they did not also miss v5.10 if the
> quiet continued. The preference is still "through tip".

Ok, I'll try to queue them but pls respin soonish. That is, if Linus
cuts -rc8 we have plenty of time but he didn't sound 100% on the -rc8
thing.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
