Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5534232B53
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 07:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgG3FVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 01:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728195AbgG3FVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 01:21:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BABF20842;
        Thu, 30 Jul 2020 05:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596086498;
        bh=pf25fmQ/TZV16YYmJ+84pEKXAho0XJaQPnceNoQ5PBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2qS+e8juE+hJmAnsxhBWQ3mFEv84S6snZ8Kp8oimbo74cX5rA5q8nVLlLj0W8CIPI
         Q53zZQO7jPpaCAHWAUnQAdvzt0Ypf/BZ0vlykXC7NDplKPcwTEBriz/ffHJG4U6h6m
         yXgB6s99/30eUWur+damaSIIjl6Gz4mHLKmnvf2I=
Date:   Thu, 30 Jul 2020 07:21:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Donnelly <John.P.donnelly@oracle.com>
Cc:     Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (resend) [PATCH [linux-4.14.y]] dm cache: submit writethrough
 writes in parallel to origin and cache
Message-ID: <20200730052127.GA3860556@kroah.com>
References: <37c5a615-655d-c106-afd0-54e03f3c0eef@oracle.com>
 <20200727150014.GA27472@redhat.com>
 <20200729115119.GB2674635@kroah.com>
 <20200729115557.GA2799681@kroah.com>
 <20200729141607.GA7215@redhat.com>
 <851f749a-5c92-dcb1-f8e4-95b4434a1ec4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <851f749a-5c92-dcb1-f8e4-95b4434a1ec4@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 29, 2020 at 06:45:46PM -0500, John Donnelly wrote:
> 
> 
> On 7/29/20 9:16 AM, Mike Snitzer wrote:
> > On Wed, Jul 29 2020 at  7:55am -0400,
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Wed, Jul 29, 2020 at 01:51:19PM +0200, Greg KH wrote:
> > > > On Mon, Jul 27, 2020 at 11:00:14AM -0400, Mike Snitzer wrote:
> > > > > This mail needs to be saent to stable@vger.kernel.org (now cc'd).
> > > > > 
> > > > > Greg et al: please backport 2df3bae9a6543e90042291707b8db0cbfbae9ee9
> > > > 
> > > > Now backported, thanks.
> > > 
> > > Nope, it broke the build, I need something that actually works :)
> > > 
> > 
> > OK, I'll defer to John Donnelly to get back with you (and rest of
> > stable@).  He is more invested due to SUSE also having this issue.  I
> > can put focus to it if John cannot sort this out.
> > 
> > Mike
> > 
> 
> 
> Hi.
> 
> 
> Thank you for reaching out.
> 
> What specifically is broken? . If it that applying
> 2df3bae9a6543e90042291707b8db0cbfbae9ee9 to 4.14.y is failing?

yes, try it yourself and see!
