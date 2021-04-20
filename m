Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CAE365324
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 09:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhDTHWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 03:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229893AbhDTHWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 03:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF76C613B8;
        Tue, 20 Apr 2021 07:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618903299;
        bh=HgiZFCdzKF6IiyU4Kp6UvES9KDEbhI3jeiuc8ALbx64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X/D6S8tyQEHjH/Y6UzKkNRmT3eRWUO4tkAmwPb9Ra1xSpFZo6p3WKj8FfDkUlpawI
         11UCK4Jyz2qXPnX1xKAla84nByzYyAacvj+aXM7n5Ymv1VPHCasWeBiK7KVIwLBld3
         33Y/49B+c/hXyeEWursBgfm6TSEEMZzMvajdzBjQ=
Date:   Tue, 20 Apr 2021 09:21:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 042/103] net/rds: Avoid potential use after free in
 rds_send_remove_from_sock
Message-ID: <YH6BAD4rgBjDANgO@kroah.com>
References: <20210419130527.791982064@linuxfoundation.org>
 <20210419130529.251281725@linuxfoundation.org>
 <20210419212930.GA6626@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419212930.GA6626@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 11:29:30PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 0c85a7e87465f2d4cbc768e245f4f45b2f299b05 ]
> > 
> > In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
> > is freed and later under spinlock, causing potential use-after-free.
> > Set the free pointer to NULL to avoid undefined behavior.
> 
> This patch is crazy. Take a look at Message-ID:
> <20210419084953.GA28564@amd>. Or just look at the patch :-).

You are correct, everything submitted from this author and domain
recently was done as a "research project" to see if they could mess with
kernel maintainers and slip in pointless changes to the kernel.

Not acceptable at all...

greg k-h
