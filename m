Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F19577BE03
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 12:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfGaKJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 06:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbfGaKJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 06:09:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CBDA20657;
        Wed, 31 Jul 2019 10:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564567739;
        bh=ghka3Z1t4IuJd91myIBQLEIBRFRlNe78sHsesNMoheY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1uCtd56u1bjHrbfq7eVMmHZL9X6sSRLUNlY034/qyoLgcRGxDaGwqfXsNKzPeAE3A
         IbE+h1yzpB0lu18Hy7zQwMDjHMPahkygrKLDcgrQFbGMszS+j+xnshnfseZ32SOfdB
         IqJnpeyaa+6qnU5FAXpTc0YxOPdBqYpEWNyc2yb0=
Date:   Wed, 31 Jul 2019 12:08:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     stable@vger.kernel.org, sreekanth.reddy@broadcom.com,
        Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com
Subject: Re: [PATCH] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Message-ID: <20190731100857.GA12900@kroah.com>
References: <1564567129-9503-1-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564567129-9503-1-git-send-email-suganath-prabu.subramani@broadcom.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 05:58:48AM -0400, Suganath Prabu wrote:
> From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> 
> Although SAS3 & SAS3.5 IT HBA controllers support
> 64-bit DMA addressing, as per hardware design,
> if DMA able range contains all 64-bits set (0xFFFFFFFF-FFFFFFFF) then
> it results in a firmware fault.
> 
> e.g. SGE's start address is 0xFFFFFFFF-FFFF000 and
> data length is 0x1000 bytes. when HBA tries to DMA the data
> at 0xFFFFFFFF-FFFFFFFF location then HBA will
> fault the firmware.
> 
> Fix:
> Driver will set 63-bit DMA mask to ensure the above address
> will not be used.
> 
> Cc: <stable@vger.kernel.org> # 4.4.186, # 4.9.186
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
> Note:
> This Patch is for stable kernel 4.4.186 and 4.9.186.
> Original patch is applied to 5.3/scsi-fixes.
> commit ID:  df9a606184bfdb5ae3ca9d226184e9489f5c24f7
> 

We can't do anything with this for a stable release until it hits
Linus's kernel tree.  Please wait until then to send backports.

thanks,

greg k-h
