Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAED2206B2
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 10:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgGOIEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 04:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729001AbgGOIEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 04:04:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B5BE2064C;
        Wed, 15 Jul 2020 08:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594800242;
        bh=HIG91/ioMlIScqdxhHK1XI6hYx30577FlENF9j/AlEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bfepzjD7u8Mx9WRTyJYUr0DmmMF7Fe3KKrMrTFDZnsH4TrYXAvF1hg/OpTq0XbmWP
         Cr6KfiadSdvxq7c0jZlsW/nZKBVwjtIlUggx4lQcpnclJrcTreRe80E9c1NLx3J9Kf
         wTrqHuXAdpBeVGbS7Q924vpShEv7DcwHRUrlcPLM=
Date:   Wed, 15 Jul 2020 10:03:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>,
        v9fs-developer@lists.sourceforge.net,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] fs/9p: Fix TCREATE's fid in protocol
Message-ID: <20200715080358.GA2521386@kroah.com>
References: <20200713215759.3701482-1-victorhsieh@google.com>
 <20200714121249.GA21928@nautica>
 <20200714205401.GE1064009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714205401.GE1064009@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 14, 2020 at 01:54:01PM -0700, Eric Biggers wrote:
> On Tue, Jul 14, 2020 at 02:12:49PM +0200, Dominique Martinet wrote:
> > 
> > > Fixes: 5643135a2846 ("fs/9p: This patch implements TLCREATE for 9p2000.L protocol.")
> > > Signed-off-by: Victor Hsieh <victorhsieh@google.com>
> > > Cc: stable@vger.kernel.org
> > 
> > (afaiu it is normally frowned upon for developers to add this cc (I can
> > understand stable@ not wanting spam discussing issues left and right
> > before maintainers agreed on them!) ; I can add it to the commit itself
> > if requested but they normally pick most such fixes pretty nicely for
> > backport anyway; I see most 9p patches backported as long as the patch
> > applies cleanly which is pretty much all the time.
> > Please let me know if I understood that incorrectly)

As Eric says, this is fine to cc: stable with this kind of thing.  It's
good to get a "heads up" on patches that are coming, and Sasha runs some
tests on them as well to make sure that they really are going to apply
to what trees you think they should apply to.

thanks,

greg k-h
