Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A92234119
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfFDIEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbfFDIEJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 04:04:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53F9A24005;
        Tue,  4 Jun 2019 08:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559635448;
        bh=SeR+gV+e1exkJtvrSwhAozjx6rGURxLKZ6LXcyg4Y1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xhuYTeAzUOa9my6nuUo+n2yEcVIOzNwbVLnW4sbFnfs15mfTAbaMkCFq/G4+cpX+4
         4G9VbI861AeXj7TNQjAcOcf5SBEelsv/NOzkwYk+LFhKiWx4No5XmcA4TH0m6ysXNH
         Ut34IEJdk50dJhIbC+TvZGLp8I6NtmAqSFUnWNjw=
Date:   Tue, 4 Jun 2019 10:04:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org,
        blackgod016574@gmail.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: Re: 95baa60a0da8 ("ipv6_sockglue: Fix a missing-check bug in
 ip6_ra_control()")
Message-ID: <20190604080405.GA3779@kroah.com>
References: <20190603173114.GA126543@google.com>
 <20190604075235.GD6840@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604075235.GD6840@kroah.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 09:52:35AM +0200, Greg KH wrote:
> On Mon, Jun 03, 2019 at 10:31:15AM -0700, Zubin Mithra wrote:
> > Hello,
> > 
> > CVE-2019-12378 was fixed in the upstream linux kernel with the following commit.
> > * 95baa60a0da8 ("ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()")
> 
> A CVE was created for that tiny thing?
> 
> Hah, no, I think I'll refuse to apply it just for the very point of it.
> That's something that can not be triggered by normal operations, right?
> It's a bugfix-for-the-theoritical from what I can see...
> 
> > Could the patch be applied to v4.19.y, v4.14.y, v4.9.y and v4.4.y?
> 
> Why are you ignoring 5.1?

Also, stable networking patches need to come from the networking
maintainer, as the documentation states, so I shouldn't be applying this
directly anyway.  If Dave thinks it is worth to backport, I'll gladly
apply it from his submissions, so you need to convince him, not me.

thanks,

greg k-h
