Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95373333C3A
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 13:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhCJMJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 07:09:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232715AbhCJMJB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 07:09:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0108F64FD7;
        Wed, 10 Mar 2021 12:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615378141;
        bh=gWhzXRenyfo+lRZps500y/5eTTZglUkZIvLQuhYSENQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NzLaYi058TwlmALdRryIOQKZ8t1ShAQ4b9px/uTaXuFQYDV3Udr6fs4gxFvs8MX1I
         ANbcn72P79CzJsxN/QbrSQgaVzdCplQF1c8m2gHeY4TO1NoQKxKw3okXkUBoI3Ol+k
         8Jbonl5/XO9KBPa/tWWkyes8gbpZyfnUS93wN6JA=
Date:   Wed, 10 Mar 2021 13:08:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: few missing commits for 5.10-stable
Message-ID: <YEi22s/nGmii/Pv2@kroah.com>
References: <YEfopAGxgmMJJhzY@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEfopAGxgmMJJhzY@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 09, 2021 at 09:29:08PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> These were missing in 5.10-stable and 5.11-stable.
> 
> dc22c1c058b5 ("nvme-pci: mark Kingston SKC2000 as not supporting the deepest power state")
> - Not marked for stable but looks like it should be there.
> 
> 778e45d7720d ("parisc: Enable -mlong-calls gcc option with CONFIG_COMPILE_TEST")
> 
> e9c6deee00e9 ("arm64: Make CPU_BIG_ENDIAN depend on ld.bfd or ld.lld 13.0.0+")
> - Not marked for stable, but 5.10-stable and 5.11-stable should have the same problem.
> 
> 80e9baed722c ("btrfs: export and rename qgroup_reserve_meta")
> - only needed for the next patch.
> 
> 4d14c5cde5c2 ("btrfs: don't flush from btrfs_delayed_inode_reserve_metadata")

All now queued up, thanks.

greg k-h
