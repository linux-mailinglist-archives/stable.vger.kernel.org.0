Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 231BF4C6D9
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 07:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbfFTFk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 01:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbfFTFk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 01:40:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9A01208CB;
        Thu, 20 Jun 2019 05:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561009258;
        bh=7a0/eouxP9Cv5kRVCnjDX/zKAGW3xlcBWJR4C8TVLRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m3x2Qmer9mt1a3JaeZMyPi/mYZ9qhz0WNgKZrX5wv49hYgO9s50uHVgM9ltoCJ/uk
         1t1jnobiEFCcMZ4Wi74NfMkG0zsQdyOVJs/6VHQfa0GSpW0in/Ede0cYa3Xn/tT8j5
         i9IQ7zZDOviJqS8B+z7oD4XYtaXCe+5ec0DhoNhM=
Date:   Thu, 20 Jun 2019 07:40:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-4.19
Message-ID: <20190620054055.GA24360@kroah.com>
References: <cki.7602EAEC92.HPY067VWRJ@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.7602EAEC92.HPY067VWRJ@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 19, 2019 at 08:12:58PM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 9f31eb60d7a2 - Linux 4.19.53
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

Should also now be fixed.

thanks,

greg k-h
