Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC74221FD
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 09:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfERHJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 May 2019 03:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbfERHJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 May 2019 03:09:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AD3520848;
        Sat, 18 May 2019 07:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558163353;
        bh=EkEp7Ipzb+p06gBSvXqNgO5oDUlhDA65A9epgLlaxOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AFfX5nEO1b3eAyzDEMG5a+Up+vZK4f07T5vuGVj4skaBSZQuKIO1BeqxCQyNbRljA
         qLC3fSGFQD198Uh7IEX4eAM42HMeQudC+vsSGLiZC3yODLWjR1bZgL8fY9kBeikttG
         kuphfbtDsvmFZ4Ea/qFKek3BDK//L1j+Q+9qpqAk=
Date:   Sat, 18 May 2019 09:09:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@google.com>
Cc:     herbert@gondor.apana.org.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: ccm - fix incompatibility between
 "ccm" and" failed to apply to 4.14-stable tree
Message-ID: <20190518070911.GA19572@kroah.com>
References: <1558096328102192@kroah.com>
 <20190517172012.GA223128@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517172012.GA223128@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 10:20:12AM -0700, Eric Biggers wrote:
> On Fri, May 17, 2019 at 02:32:08PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From 6a1faa4a43f5fabf9cbeaa742d916e7b5e73120f Mon Sep 17 00:00:00 2001
> > From: Eric Biggers <ebiggers@google.com>
> > Date: Thu, 18 Apr 2019 14:44:27 -0700
> > Subject: [PATCH] crypto: ccm - fix incompatibility between "ccm" and
> >  "ccm_base"
> > 
> 
> Why did this fail to apply?  For me it cleanly cherry picks to 4.14 and later.

git cherry-pick fixed up some issues that quilt had, so I've added it
now to 4.14, 4.19, and 5.0.

But I now need a 4.4 and 4.9 backport of this, can you provide that?

thanks,

greg k-h
