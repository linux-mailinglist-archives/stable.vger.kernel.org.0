Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E9844C60F
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 18:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhKJRl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 12:41:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230474AbhKJRl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 12:41:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7493761246;
        Wed, 10 Nov 2021 17:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636565920;
        bh=6G1IgHFg5QdJERQZMbsEQvzO9rPuJ1HBs90x9flrvVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xUNZ52Q+5LwUFpNRyKzef3bePEUClWXsxzT1+52Kope87bognQ8sjTsMnCmYV1REr
         /ENcsk4gfnCJp8bWAycg84YPRBvBzodQaucDhU2HbY+5UnWwghTV9rKYHMMveR8plC
         GQjW8O7Hte8aW8kmVc+cTHxIq07SAOI0ytK7MArU=
Date:   Wed, 10 Nov 2021 18:38:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Boddington <lkml@badpenguin.co.uk>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: kernel 5.15.1: AMD RX 6700 XT - Fails to resume after screen
 blank
Message-ID: <YYwDnbpES0rrnWBw@kroah.com>
References: <dbadfe41-24bf-5811-cf38-74973df45214@badpenguin.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbadfe41-24bf-5811-cf38-74973df45214@badpenguin.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 04:27:39PM +0000, Mark Boddington wrote:
> Hi all,
> 
> I run the mainline Linux kernel on Ubuntu 20.04, built from
> https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.1/
> 
> There appears to be a regression in 5.15.1 which causes the GPU to fail to
> resume after power saving.
> 
> Could it be this change??:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c?h=v5.15.1&id=8af3a335b5531ca3df0920b1cca43e456cd110ad

If you revert it, does it solve the problem for you?

If not, what kernel version did work for you with this hardware?

thanks,

greg k-h
