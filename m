Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768A04C6D0
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 07:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbfFTFeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 01:34:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbfFTFeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 01:34:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34DC02147A;
        Thu, 20 Jun 2019 05:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561008883;
        bh=Q/Jpd2woJI5pruhlr4iqntHwcbkY6lxp/XKYK9RGTXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SMfNN/x6NJkQmnlFz2dDS/ktHI7PpolVE/oYjiJf+RJFVOsbtl66Dbc+KaMZGMCib
         9kPEbgXQIKIqXau77WNIhup7yZ5QSVOvyM27GLMZjHNQzW64/voswb1xWnw70dcWH5
         6j3DOfSYJlcUgakRp/YCauwO+Yk8NmRASx+jm37Q=
Date:   Thu, 20 Jun 2019 07:34:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.1
Message-ID: <20190620053441.GA4154@kroah.com>
References: <cki.FCB5477057.6ESDYD89JG@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.FCB5477057.6ESDYD89JG@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 19, 2019 at 08:13:10PM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 5752b50477da - Linux 5.1.12
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: FAILED
> 
> 
> 
> 
> When we attempted to merge the patchset, we received an error:
> 
>   error: patch failed: net/ipv6/ip6_flowlabel.c:254
>   error: net/ipv6/ip6_flowlabel.c: patch does not apply
>   hint: Use 'git am --show-current-patch' to see the failed patch
>   Applying: ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
>   Patch failed at 0001 ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero

Looks like Sasha's last push had a bunch of duplicates in it.  I've
fixed this up for the 5.1 queue now and will go work on the others...

thanks,

greg k-h
