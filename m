Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE5B36FBA0
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 15:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhD3NlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 09:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhD3NlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 09:41:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60D5F61474;
        Fri, 30 Apr 2021 13:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619790017;
        bh=hGaqcaVx+ANBBi4MkUPG//G6/XtKnmYWIcZYmMynBCo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p2hgEU2v4lQs6oqV6v7vGzj9wu9GRELjFk+07jSU+506TZZOYSbv5O0btJFZPHHY9
         sYnSdjgcbUWFnzDPYLcelVbEyxK4MAwscfSJRYGxiG2SZETcX9KZ29okQCasab3hzt
         YwaG94NNqgszcKXrEBefMZrR9n/+vJHJ2jXCpUbg=
Date:   Fri, 30 Apr 2021 15:40:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     Dhaval Giani <dhaval.giani@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        stable@vger.kernel.org
Subject: Re: Needed in 5.4.y: [PATCH 5.10 055/126] ACPI: tables: x86: Reserve
 memory occupied by ACPI tables
Message-ID: <YIwIvx+uBBb/nz+S@kroah.com>
References: <13f5c864-9b15-b2dd-53e1-d71b27a94a74@oracle.com>
 <69f6104e-ca54-5686-4cbf-dc14cb1697f3@oracle.com>
 <YIjrQdJtpJ0br5m9@kroah.com>
 <db5625eb-f304-2f47-49f3-5fb7b3d019e9@oracle.com>
 <36779f96-2314-fd35-7c02-accd6da0be56@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36779f96-2314-fd35-7c02-accd6da0be56@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 29, 2021 at 01:24:06PM -0400, George Kennedy wrote:
> 
> 
> On 4/28/2021 8:52 AM, George Kennedy wrote:
> > 
> > 
> > On 4/28/2021 12:57 AM, Greg Kroah-Hartman wrote:
> > > On Tue, Apr 27, 2021 at 06:18:05PM -0400, George Kennedy wrote:
> > > > CC+ stable@vger.kernel.org
> > > > 
> > > > On 4/27/2021 6:17 PM, George Kennedy wrote:
> > > > > Hello Greg,
> > > > > 
> > > > > We need the following 2 upstream commits applied to 5.4.y to
> > > > > fix an iBFT
> > > > > boot failure:
> > > > > 
> > > > > 2021-03-29 rafael.j.wysocki@intel.com - 1a1c130a 2021-03-23 Rafael J.
> > > > > Wysocki ACPI: tables: x86: Reserve memory occupied by ACPI tables
> > > > > 2021-04-13 rafael.j.wysocki@intel.com - 6998a88 2021-04-13 Rafael J.
> > > > > Wysocki ACPI: x86: Call acpi_boot_table_init() after
> > > > > acpi_table_upgrade()
> > > > > 
> > > > > Currently, only the first commit (1a1c130a) is destined for
> > > > > 5.10 & 5.11.
> > > > > 
> > > > > The 2nd commit (6998a88) is needed as well and both commits are needed
> > > > > in 5.4.y.
> > > Is this a regression (i.e. did this hardware work on older kernels?),
> > > and if so, what commit caused the problem?
> > > 
> > > These commits are already in 5.10.y, what changed in older kernels to
> > > require this to be backported?
> 
> Hello Greg,
> 
> Can the same 2 patches also be applied to 4.14.y, which one of distros is
> based on?
> 
> 4.14.y crashes during ibft boot with KASAN enabled without the 2 patches.

What about 4.19.y?  You do not want to skip anything in the middle,
right?

And I need an ack from the authors and maintainers of these changes
before I can take them into the stable trees.  Any reason you didn't cc:
them all?

thanks,

greg k-h
