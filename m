Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DAE3BB77E
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 09:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhGEHJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 03:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229823AbhGEHJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 03:09:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6ADF6120D;
        Mon,  5 Jul 2021 07:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625468804;
        bh=0mTBY+GxNPufILh55Iqid4OsMiQ+SkX0qtAvyziOChc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QSJNGJvivVsxUUHbUV3oJGEZPniKSEVQORqJYhUTmVL49VPMu+VZ+lzitEhVB8J7J
         y/LwmR1Rzap8M/98ugtTdO3g7imv1rnKv0xrVT4Vn5FVAETOsRuMfDh9e0C5+uSZYv
         qiHDX5XpWCxZOQj+LYJ0NdZvWeXBZVZRcqPU6cOk=
Date:   Mon, 5 Jul 2021 09:06:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Erdogan, Tahsin" <trdgn@amazon.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4.19] ext4: eliminate bogus error in
 ext4_data_block_valid_rcu()
Message-ID: <YOKvgbouUTXxmMIl@kroah.com>
References: <20210703230555.4093-1-trdgn@amazon.com>
 <YOEHmjjY9facxtIY@mit.edu>
 <1625362509314.54473@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1625362509314.54473@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 04, 2021 at 01:35:09AM +0000, Erdogan, Tahsin wrote:
> > If I understand the commit description, this patch is only intended
> > for the 4.19 stable kernel.  If this is the case, I'd suggest using
> > the Subject prefix [PATCH 4.19] for future patches.  This is more
> 
> Hi Ted, yes this is only intended for 4.19. Thanks for the tip on subject line,
> I will keep that in mind in the future.
> 
> > if you could indicate whether a similar fix is needed for 4.14, and
> > other older LTS kernels, or whether the only stable backport which had
> > this bug was 4.19.
> 
> I have checked 4.4, 4.9, 4.14, 5.8. They all look fine. I believe this problem
> only affects 4.19.

THanks, now queued up.

greg k-h
