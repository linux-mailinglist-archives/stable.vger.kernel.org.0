Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8BB3AFB1
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 09:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388000AbfFJHbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 03:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387967AbfFJHbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 03:31:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA89B207E0;
        Mon, 10 Jun 2019 07:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560151882;
        bh=nqWIi+4q4b0dSjwSaMFL/ua66mlPJbZirFJw8b7II74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZqNRTkWOWEEuSHV3bsD/n4MzFJ8vh3sTepa5EC4IqvxAoYBkXMCK3BXUuRihUhIYP
         zWkzQt/PWHXK1t3oHdUew/oL/bXwotNBKDR9kxD6xJZLIN29PXvgxFZj8QvNuRy62P
         y1BbQkAKhbAKbMk9jt2rVew7gCsrUOJ3Uswl3Pp8=
Date:   Mon, 10 Jun 2019 09:31:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 5.1 56/85] doc: Cope with the deprecation of AutoReporter
Message-ID: <20190610073119.GB20470@kroah.com>
References: <20190607153849.101321647@linuxfoundation.org>
 <20190607153855.717899507@linuxfoundation.org>
 <1fbb40df-d420-9f10-34a9-340b3156eb7c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fbb40df-d420-9f10-34a9-340b3156eb7c@suse.cz>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 08:27:30AM +0200, Jiri Slaby wrote:
> On 07. 06. 19, 17:39, Greg Kroah-Hartman wrote:
> > From: Jonathan Corbet <corbet@lwn.net>
> > 
> > commit 2404dad1f67f8917e30fc22a85e0dbcc85b99955 upstream.
> > 
> > AutoReporter is going away; recent versions of sphinx emit a warning like:
> > 
> >   Documentation/sphinx/kerneldoc.py:125:
> >       RemovedInSphinx20Warning: AutodocReporter is now deprecated.
> >       Use sphinx.util.docutils.switch_source_input() instead.
> > 
> > Make the switch.  But switch_source_input() only showed up in 1.7, so we
> > have to do ugly version checks to keep things working in older versions.
> 
> Hi,
> 
> this patch breaks our build of kernel-docs on 5.1.*:
> https://build.opensuse.org/package/live_build_log/Kernel:stable/kernel-docs/standard/x86_64
> 
> The error is:
> [  250s] reST markup error:
> [  250s]
> /home/abuild/rpmbuild/BUILD/kernel-docs-5.1.8/linux-5.1/Documentation/gpu/i915.rst:403:
> (SEVERE/4) Title level inconsistent:
> [  250s]
> [  250s] Global GTT Fence Handling
> [  250s] ~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Reverting the patch from 5.1.* makes it work again.
> 
> 5.2-rc3 (includes the patch) is OK:
> https://build.opensuse.org/package/live_build_log/Kernel:HEAD/kernel-docs/standard/x86_64
> 
> So 5.1.* must be missing something now.

Odd.  running 'make htmldocs' on 5.1 with these patches applied works
for me here.

What version of sphinx are you using to build the package with?

thanks,

greg k-h
