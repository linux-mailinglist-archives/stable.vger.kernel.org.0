Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCF27C9D0
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 19:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbfGaREO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 13:04:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbfGaREO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 13:04:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5725621851;
        Wed, 31 Jul 2019 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564592653;
        bh=O/L66YOpveRaMjcwp2okF3z3CHdF06cZ159RNrM2C9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v8G0nAd31lLHw6Wy3IfF7gFHk1lAce/LToB/5AMWC+HGWAgVp8ytZ3kAUYd0w9bCg
         rJ9ls3njxN+23fWtcWWv/8PTcWA9r3K4ATtP3cc8DIHzvg6/OgV4QfPvmaRoipjGF0
         ZF20Esu+L6lF8aI4zQEj+M5l2zmQHoWapjomoquM=
Date:   Wed, 31 Jul 2019 19:04:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     stable@vger.kernel.org, 0x7f454c46@gmail.com,
        Joerg Roedel <jroedel@suse.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH-4.19-stable 2/2] iommu/iova: Fix compilation error with
 !CONFIG_IOMMU_IOVA
Message-ID: <20190731170411.GA22660@kroah.com>
References: <20190731162220.24364-1-dima@arista.com>
 <20190731162220.24364-3-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731162220.24364-3-dima@arista.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 05:22:20PM +0100, Dmitry Safonov wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> [ Upstream commit 201c1db90cd643282185a00770f12f95da330eca ]
> 
> The stub function for !CONFIG_IOMMU_IOVA needs to be
> 'static inline'.
> 
> Fixes: effa467870c76 ('iommu/vt-d: Don't queue_iova() if there is no flush queue')
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> [v4.14 backport]

4.19?  :)
