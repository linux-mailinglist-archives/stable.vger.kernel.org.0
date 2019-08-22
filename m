Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F69299395
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 14:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732949AbfHVMaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 08:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbfHVMaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 08:30:55 -0400
Received: from localhost (unknown [12.166.174.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50FB8206BB;
        Thu, 22 Aug 2019 12:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566477054;
        bh=nnLd0ca321zcCp1UOcKyv0fRgu4H2HqkuFST/nYvp0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JSLemMNcBM/FceM+Q02WJF8r7HVkdw9hmqciBJlavQfSOF0YbbNPPO+0UPOvT3Nxm
         UkwuBAaGyYD5Ul+sVqN3Ir1g0eQRR5n5gW8Ydod106dl183i4w1UR+q+Cm+/YQ+B5K
         i8+EyqwRusAf48a9DKJrIMnSJvkQCYGXdZKHpwIY=
Date:   Thu, 22 Aug 2019 05:30:53 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Neil MacLeod <neil@nmacleod.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/boot: Fix boot failure regression
Message-ID: <20190822123053.GC12941@kroah.com>
References: <CAFbqK8=RUaCnk_WkioodkdwLsDina=yW+eLvzckSbVx_3Py_-A@mail.gmail.com>
 <20190821192513.20126-1-jhubbard@nvidia.com>
 <CAFbqK8=BodLiMr4pdHjdqsZtk8iHUC_9oyRRALJt0xLz4y_4sQ@mail.gmail.com>
 <alpine.DEB.2.21.1908212323290.1983@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908212323290.1983@nanos.tec.linutronix.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 21, 2019 at 11:24:28PM +0200, Thomas Gleixner wrote:
> On Wed, 21 Aug 2019, Neil MacLeod wrote:
> 
> > I can confirm 5.3-rc5 is booting again from internal M2 drive on
> > Skylake i5 NUC with this commit - many thanks!
> 
> I've queued that in x86/urgent and it's en route for rc6 and stable.

I've dropped the original patch from the stable trees now to wait for
this fix to hit Linus's tree.

Also the original doesn't seem to have fixed the build warning I'm
seeing on my Fedora test build systems, which is odd, I need to dig into
that...

thanks,

greg k-h
