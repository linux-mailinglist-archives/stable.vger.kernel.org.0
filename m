Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2420D410C98
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 19:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhISRRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Sep 2021 13:17:08 -0400
Received: from mail.skyhub.de ([5.9.137.197]:47644 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229379AbhISRRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Sep 2021 13:17:07 -0400
Received: from zn.tnic (p200300ec2f302e00633d6655d51f854e.dip0.t-ipconnect.de [IPv6:2003:ec:2f30:2e00:633d:6655:d51f:854e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 63DA91EC0372;
        Sun, 19 Sep 2021 19:15:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632071736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ERCO7ZhOdk5WvcsvtzhSYbJkZ2shXUi9qth76Fv/TZI=;
        b=JXaySs6fDkKo9GsMW2Sg9DrWYV2Cce6r/zCAt79uh5x77ylhW+deqWt2O9LxvbYrvq47ka
        V9odKC5IrYYhP1sa6z33WUrp6tfUT8NG2ZZThjH2xLeklA6MhEfDPv3RQq7oTDbEwCb85B
        EMrDYtkFwV2kMEzM53bqpbjl6KwiKPI=
Date:   Sun, 19 Sep 2021 19:15:30 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        marmarek@invisiblethingslab.com, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, stable@vger.kernel.org,
        x86@kernel.org
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
Message-ID: <YUdwMm9ncgNuuN4f@zn.tnic>
References: <20210914094108.22482-1-jgross@suse.com>
 <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
 <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 19, 2021 at 06:55:16PM +0200, Mike Galbraith wrote:
> On Thu, 2021-09-16 at 10:50 +0000, tip-bot2 for Juergen Gross wrote:
> > The following commit has been merged into the x86/urgent branch of
> > tip:
> >
> > Commit-ID:     1c1046581f1a3809e075669a3df0191869d96dd1
> > Gitweb:       
> > https://git.kernel.org/tip/1c1046581f1a3809e075669a3df0191869d96dd1
> > Author:        Juergen Gross <jgross@suse.com>
> > AuthorDate:    Tue, 14 Sep 2021 11:41:08 +02:00
> > Committer:     Borislav Petkov <bp@suse.de>
> > CommitterDate: Thu, 16 Sep 2021 12:38:05 +02:00
> >
> > x86/setup: Call early_reserve_memory() earlier
> 
> This commit rendered tip toxic to my i4790 desktop box and i5-6200U
> lappy.  Boot for both is instantly over without so much as a twitch.
> 
> Post bisect revert made both all better.

I had a suspicion that moving stuff around like that would not just
simply work in all cases, as our boot order is very lovely and fragile.

And it booted just fine on my machines here.

;-\

Anyway, commit zapped from the x86/urgent lineup. We'll have to have a
third try later.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
