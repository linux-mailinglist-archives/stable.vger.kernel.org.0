Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D5512DF9B
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 18:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgAARCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 12:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgAARCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 12:02:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 929B22073D;
        Wed,  1 Jan 2020 17:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577898129;
        bh=Z72xXzYeU8UO0ouYCieTIKHb116ITy/6JH6vJ93XMxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SivCZ0gfnnZqSc4fevvGwb2QwqfAyRiHZAY0/TIPGqU1By+JvNLWFs8318c/Vy/0K
         m5Nz10llvAnSiVNAIi/LSyNVuH4cfuN2i9yS3E0v8zTSCeh/HvtUQeqa4eGYvKVCX1
         QzlfeUqTcdrr9q25NvINh/R/22aMEASFW2z9mIS8=
Date:   Wed, 1 Jan 2020 18:02:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5.4] Revert "iwlwifi: assign directly to iwl_trans->cfg
 in QuZ detection"
Message-ID: <20200101170206.GC2712976@kroah.com>
References: <20191223125612.1475700-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191223125612.1475700-1-luca@coelho.fi>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 23, 2019 at 02:56:12PM +0200, Luca Coelho wrote:
> From: Anders Kaseorg <andersk@mit.edu>
> 
> This reverts commit 968dcfb4905245dc64d65312c0d17692fa087b99.
> 
> Both that commit and commit 809805a820c6445f7a701ded24fdc6bbc841d1e4
> attempted to fix the same bug (dead assignments to the local variable
> cfg), but they did so in incompatible ways. When they were both merged,
> independently of each other, the combination actually caused the bug to
> reappear, leading to a firmware crash on boot for some cards.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=205719
> 
> Signed-off-by: Anders Kaseorg <andersk@mit.edu>
> Acked-by: Luca Coelho <luciano.coelho@intel.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> ---
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 24 +++++++++----------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 

Next time a hint as to what this git commit id is in Linus's tree would
be nice :)

thanks,

greg k-h
