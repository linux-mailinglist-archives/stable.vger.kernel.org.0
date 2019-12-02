Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0676810E696
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 08:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfLBH6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 02:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfLBH6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 02:58:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24E5E2146E;
        Mon,  2 Dec 2019 07:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575273533;
        bh=0pfZAAucCN2NuKtA+cNAYy1pn45HA6m2U6O+WrruCsE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s9W4Sq+PH93iWeXdrh76b6uqZgKW9eon0vqS2w6LBgFZfb97GbzvmwBDQQOVsSeig
         z8OHKtLkdXeNMg5xYZxcU4i2gVVb3fCYqeVxug7dp9rDfj66rQSc7uQCjjeNF+xxfn
         5B+wdCMFDZ7BF0eiZ8vUDpbOp3LPp1kqcjO5OfQo=
Date:   Mon, 2 Dec 2019 08:58:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffrin Jose <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.4.1
Message-ID: <20191202075848.GA3892895@kroah.com>
References: <20191201094246.GA3799322@kroah.com>
 <20191201193649.GA9163@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191201193649.GA9163@debian>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 01:06:49AM +0530, Jeffrin Jose wrote:
> On Sun, Dec 01, 2019 at 10:42:46AM +0100, Greg KH wrote:
> > I'm announcing the release of the 5.4.1 kernel.
> > 
> > All users of the 5.4 kernel series must upgrade.
> > 
> > The updated 5.4.y git tree can be found at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
> > and can be browsed at the normal kernel.org git web browser:
> > 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> > 
> > thanks,
> > 
> > greg k-h
> 
> hello,
> 
> the following readings are from testing performance of 5.4.1 with  5.4.0
> the readings are from 5.4.0 to 5.4.1 in 1 is to 1 mapping.
> the test results may not be accurate.
> 
> 
> 5.4 0
> -----
> 
> real	149m25.803s
> user	57m32.082s
> sys	5m54.858s
> 
> real	141m55.929s
> user	52m0.091s
> sys	5m15.312s
> 
> real	144m18.779s
> user	53m1.508s
> sys	5m24.352s
> 
> 
> 
> 5.4.1
> -----
> 
> real	124m44.923s
> user	56m26.547s
> sys	5m35.978s
> 
> real	104m16.500s
> user	51m11.444s
> sys	5m1.046s
> 
> real	106m1.086s
> user	51m45.339s
> sys	5m4.815s


You tested the performance of what?

And 5.4.1 is faster?

thanks,

greg k-h
