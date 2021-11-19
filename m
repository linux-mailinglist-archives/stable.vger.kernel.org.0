Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E568456EE1
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 13:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhKSMhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 07:37:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhKSMhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 07:37:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39C3D61A38;
        Fri, 19 Nov 2021 12:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637325280;
        bh=h5JUw3+buI+NU71DyopKPqzP6y9RIWd4n2KECbxZUWU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lj2hrpSJcCIltMSt3v4OI4fupblqLA8d+PtSNqanaS5BQkngQMjWeZw4BY04ZcJUq
         9+N42mTTvVn6NnL9KESGaQuoQAU5j1LZD+Nl0lR5roTs4Z3wYqdV5wvPhV3QqakXrk
         KoHqLSyG9/+IHy6Ecao4SqeTsTpcdRW2MrvKoBLo=
Date:   Fri, 19 Nov 2021 13:34:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH for-5.15.x 0/6] btrfs: zoned: backport of 5.16 relocation
 fixes
Message-ID: <YZeZ3pdVqGeLHI8t@kroah.com>
References: <cover.1637225333.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1637225333.git.johannes.thumshirn@wdc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 05:58:12PM +0900, Johannes Thumshirn wrote:
> Hi Greg and stable team,
> 
> Here's a backport of relocation fixes that went into 5.16 aimed at the 5.15.x
> series of stable kernels. It's a problem people are currently running into
> when using btrfs on a zoned block device.
> 
> The following patches have been backported:
> 960a3166aed0 ("btrfs: zoned: allow preallocation for relocation inodes")
> 2adada886b26 ("btrfs: check for relocation inodes on zoned btrfs in should_nocow")
> e6d261e3b1f7 ("btrfs: zoned: use regular writes for relocation")
> 35156d852762 ("btrfs: zoned: only allow one process to add pages to a relocation inode")
> c2707a255623 ("btrfs: zoned: add a dedicated data relocation block group")
> 37f00a6d2e9c ("btrfs: introduce btrfs_is_data_reloc_root")
> 
> The backport has seen the usual regression testing with xfstests.

Now queued up, thanks.

greg k-h
