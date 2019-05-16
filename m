Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA1171FF44
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 07:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfEPF5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 01:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbfEPF5L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 01:57:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3648820818;
        Thu, 16 May 2019 05:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557986230;
        bh=Q7qR++elTHU3WNUzfNbH2FnOmoOxrV/+vBSVYyJs4AM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0+tMQ/JldqKcHcdise1vEQoNGFJcfcl79bo7I6kb2Kk9w1zf6i1ZnnxcH2kEj2Elz
         cmiFROdWtefVTlOvsR6VG6jl1aAESMQesco1WiPPfZd+HjWHYxtDe9xDhgmJZwySjJ
         NPXmqT04jOup4n5wM8t6ibfr5J1a2bE1/EpzRovE=
Date:   Thu, 16 May 2019 07:57:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Tobin C. Harding" <me@tobin.cc>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Tobin C. Harding" <tobin@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.18 78/86] bridge: Fix error path for
 kobject_init_and_add()
Message-ID: <20190516055708.GA12518@kroah.com>
References: <20190515090642.339346723@linuxfoundation.org>
 <20190515090655.622147146@linuxfoundation.org>
 <20190515204840.GE11749@eros.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515204840.GE11749@eros.localdomain>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 06:48:40AM +1000, Tobin C. Harding wrote:
> On Wed, May 15, 2019 at 12:55:55PM +0200, Greg Kroah-Hartman wrote:
> > From: "Tobin C. Harding" <tobin@kernel.org>
> > 
> > [ Upstream commit bdfad5aec1392b93495b77b864d58d7f101dc1c1 ]
> 
> Greg you are not going to back port all of these kobject fixes are you?
> There is going to be a _lot_ of them.  I'm not super comfortable
> generating all this work for you.  And besides that, I keep making
> mistakes (reference to last nights find of double free in powerpc that
> you reviewed already), then we have to back port those too.
> 
> For the record I've been going through all uses of kobject and splitting
> them into categories
> 
>  1. Broken
>  2. Too complex to immediately tell
>  3. Done correctly
> 
> I'm not getting many in category #3, let's hope that some in #1 and #2 are
> my misunderstanding and that many in #2 should be in #3.  I'm having fun
> fixing them but I shudder at making life hard for other people.

I took this one as it was forwarded on to me by David Miller as a fix to
be queued up for networking issues.

If a maintainer wants to mark the patch for stable, I'll be glad to take
it, but I'm not going to be going and digging all of these out by hand
an backporting them :)

thanks,

greg k-h
