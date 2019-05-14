Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626451CE9B
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 20:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfENSHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 14:07:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbfENSHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 14:07:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BD9520850;
        Tue, 14 May 2019 18:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557857265;
        bh=cBl17dKDCE701qysIFd3wYbG70L5NBjvORUz4ES3AvM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zviqZzZr09Hqnm0oihz7ygQcRmmYTsoHGshtyK5HJU75dQep6h17j3cRthqVuj17q
         j0Z4sDzB7fqDUvaoOUlQ+oh8jGcV+GucioCgpRggngsywf9xyYTSP5UHy8sqCE68wA
         GnY99dIJcczj34s3cdP5aXi9tPGj/ueRWfHlAT6M=
Date:   Tue, 14 May 2019 20:07:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.2
Message-ID: <20190514180743.GA13519@kroah.com>
References: <20190514180424.GA11131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514180424.GA11131@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 08:04:24PM +0200, Greg KH wrote:
> I'm announcing the release of the 5.1.2 kernel.
> 
> All users of the 5.1 kernel series must upgrade.  Well, kind of, let me rephrase that...
> 
> All users of Intel processors made since 2011 must upgrade.
> 
> Note, this release, and the other stable releases that are all being
> released right now at the same time, just went out all contain patches
> that have only seen the "public eye" for about 5 minutes.  So be
> forwarned, they might break things, they might not build, but hopefully
> they fix things.  Odds are we will be fixing a number of small things in
> this area for the next few weeks as things shake out on real hardware
> and workloads.  So don't think you are done updating your kernel, you
> never are done with that :)
> 
> As for what specifically these changes fix, I'll let the tech news sites
> fill you in on the details.  Or go read the excellently written Xen
> Security Advisory 297:
> 	https://xenbits.xen.org/xsa/advisory-297.html
> That should give you a good idea of what a number of people have been
> dealing with for many many many months now.

Also see the new in-kernel documentation for how to handle all of this:
	https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html

