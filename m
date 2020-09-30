Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A5227DFDA
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 07:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725320AbgI3FFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 01:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgI3FFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 01:05:07 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54796C061755
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 22:05:07 -0700 (PDT)
Received: from zn.tnic (p200300ec2f092a003ee64aac7a8dc174.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:2a00:3ee6:4aac:7a8d:c174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 36A3D1EC03D5;
        Wed, 30 Sep 2020 07:05:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1601442304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=n2nkxu4xTZZhZzy2McG9Zfzz9yulljqwC+oUwVYbXuw=;
        b=bLBgSqlZAZjg/6IZuhzkE8BHpsAH5mJ25Fl0wXPymz3R8Iiowss8xSVi+BiZ9ck57j+EGU
        IFHvRlGQiaArpROj2Q5VR4U27AlusQLRhCDHJLtKYLefaO5/YSzLcB4Y7pJ6X5vUW/QYMl
        0+0rTy9poUtzo/YQjbVC4Aivf9qvARQ=
Date:   Wed, 30 Sep 2020 07:04:55 +0200
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
Message-ID: <20200930050455.GA6810@zn.tnic>
References: <160087928642.3520.17063139768910633998.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4iPuRWSv_do_h8stU0-SiWxtKkQWvzBEU+78fDE6VffmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4iPuRWSv_do_h8stU0-SiWxtKkQWvzBEU+78fDE6VffmA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 03:32:07PM -0700, Dan Williams wrote:
> Given that Linus was the primary source of review feedback on these
> patches and a version of them have been soaking in -next with only a
> minor conflict report with vfs.git for the entirety of the v5.9-rc
> cycle (left there inadvertently while I was on leave), any concerns
> with me sending this to Linus directly during the merge window?

What's wrong with them going through tip?

But before that pls have a look at this question I have here:

https://lkml.kernel.org/r/20200929102512.GB21110@zn.tnic

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
