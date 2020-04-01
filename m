Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A82819A9E2
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 13:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732006AbgDALBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 07:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731343AbgDALBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 07:01:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAEE82078B;
        Wed,  1 Apr 2020 11:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585738864;
        bh=WHQUuc/7PiXP6VBr7/bGGUFXN2v8mQX50Z6z+MGNQP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JcTsJEZ2kNCqzzHibWRq/JcX99rhynqcrDA/dhtI5qB6CAvJ50s0mDcg1aZGPg8qd
         LI8p7s7j9uJCJ94LLYHmeWG2t9xRAEI0CRPkp7gE9roiPh+f2cxYbial6c9ggX2StM
         nJBKyQAtYyiKV7WQKKVi/kQm+r+WPI51f/nNfnpA=
Date:   Wed, 1 Apr 2020 13:01:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH Backport to stable/linux-4.14.y] make
 'user_access_begin()' do 'access_ok()'
Message-ID: <20200401110100.GA2070530@kroah.com>
References: <8a297704c58b4b4e867efecb08214040@SVR-IES-MBX-03.mgc.mentorg.com>
 <1585733082992.99012@mentor.com>
 <20200401093235.GB2055942@kroah.com>
 <1585735684794.48644@mentor.com>
 <1585737161954.11435@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585737161954.11435@mentor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 10:32:42AM +0000, Schmid, Carsten wrote:
> >>
> >> Fixes CVE-2018-20669
> >> Backported from v5.0-rc1
> >> Patch 1/1
> >
> > Also, that cve was "supposed" to already be fixed in the 4.19.13 kernel
> > release for some reason, and it's a drm issue, not a core access_ok()
> > issue.
> >
> > So why is this needed for 4.14?
> >
> See https://access.redhat.com/security/cve/cve-2018-20669
> Looks like Linus' fix was attacking this at the root cause, not only for DRM.

And are you _sure_ this really is an issue in 4.14?  And in 4.19?  There
was some reason I didn't backport this to 4.19 at the time...

> Also, i use https://www.linuxkernelcves.com/ as a research source,
> and they claim that CVE not fixed in 4.19.

That disagrees with the "main" CVE database.  Not that I really trust
any of them further than I can throw their servers...

> (and i'll check for the other LTS kernels as well)

Please do.

> >> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> >
> > No s-o-by from you?
> Ops. Will add this in a resend.
> 
> >> Want to give this work back to the community, as 4.14 is a SLTS.
> >
> > What is "SLTS"?
> Super Long Term Supported kernel - thanks to guys like you :-)
> 4.14 really is that (Jan. 2024, as of https://www.kernel.org/category/releases.html)

I don't use that term, don't make new things up where they aren't :)

> >
> > thanks,
> >
> > greg k-h
> 
> Thanks, and i have some other patches backported to 4.14 as CVE fixes,
> which i'll propose in the next hours.

Make sure that they are really issues, and that they are fixed in all
current trees.  I can't take patches for an older stable tree without a
newer one also having it otherwise people would upgrade and suffer a
regression.

thanks,

greg k-h
