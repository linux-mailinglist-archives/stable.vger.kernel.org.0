Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23310361937
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 07:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbhDPFVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 01:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhDPFVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 01:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A7866113B;
        Fri, 16 Apr 2021 05:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618550487;
        bh=TKTaONvt0rG8ySNMNT7l3R1Qfzr5fNWHbI5YL0Sg19g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mtvU6Hb/yBA1Si/CHaAepKIKfIRHtuqAUGS8RLcjGEJ34VInTCSMHg5yo+/T3SYeg
         3K4GtZ900DZHr8QQMw3Wpur8XBLdCXTTKleUQ4+X36pxwCn5LpTm9LIYpr+HQM7tk6
         dOmbQWCKbFq2sYOZA4jUnq8Js0IoaUdFXxCEP9CU=
Date:   Fri, 16 Apr 2021 07:21:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: netfilter/x_tables patches for v4.4.y..v4.14.y
Message-ID: <YHke1FAsyvhBoxKi@kroah.com>
References: <1780f159-140b-231f-8af5-ccec049dc8b0@roeck-us.net>
 <YHhr1WuX4/0l+9lP@kroah.com>
 <20210415174950.GB30478@roeck-us.net>
 <20210415175417.GA30883@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415175417.GA30883@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 10:54:17AM -0700, Guenter Roeck wrote:
> On Thu, Apr 15, 2021 at 10:49:50AM -0700, Guenter Roeck wrote:
> > On Thu, Apr 15, 2021 at 06:37:41PM +0200, Greg Kroah-Hartman wrote:
> > > On Thu, Apr 15, 2021 at 09:28:15AM -0700, Guenter Roeck wrote:
> > > > Hi Greg,
> > > > 
> > > > please consider applying the following two patches to v4.4.y, v4.9.y, and v4.14.y
> > > > 
> > > > 80055dab5de0 ("netfilter: x_tables: make xt_replace_table wait until old rules are not used anymore")
> > > > 175e476b8cdf ("netfilter: x_tables: Use correct memory barriers.")
> > > 
> > > The second patch here says that it's only needed to go back until:
> > > 	    Fixes: 7f5c6d4f665b ("netfilter: get rid of atomic ops in fast path")
> > > 
> > > Which is only backported to 4.19.  So why do older kernels need that, is
> > > the fixes tag wrong?
> > > 
> > 
> > Outch, it looks like 80055dab5de0 was fixed later with cc00bcaa5899, which in
> > turn was fixed with 443d6e86f821. Ok, back to the drawing board, but it may
> > just be easier to forget about this. I'll let you know.
> > 
> I tried to apply cc00bcaa5899 on top of the above, and got lots of conflicts.
> Please ignore this request; it adds more risk than gain. Sorry for the noise.

No worries, now ignored :)
