Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F16DFF9D5
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfD3NXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 09:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfD3NXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 09:23:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB2B82075E;
        Tue, 30 Apr 2019 13:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556630634;
        bh=FX21K3x2eSTyPIYWY0QOv+WYz0qilVJ+BIvLkM+EmQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GvD0xlHfZRVr6nFo7UE4aA8wDccgdkeRLC1tuVrB/I2RK73LORqUskopsimBTOzO3
         tT7P3vQnpdLOpHHAjM6wFNMkMcCz78e25Hjd0FcoERQ/erq4kp8Zxb1nnV4HJuRn+v
         C/EWw2JztFfd1+PbWabxPZbUXaydYpAVWYLK1bKQ=
Date:   Tue, 30 Apr 2019 15:23:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Diana Craciun <diana.craciun@nxp.com>
Cc:     stable@vger.kernel.org, linuxppc-dev@ozlabs.org, mpe@ellerman.id.au
Subject: Re: [PATCH v2 stable v4.4 2/2] Documentation: Add nospectre_v1
 parameter
Message-ID: <20190430132352.GA5327@kroah.com>
References: <1556628147-15687-1-git-send-email-diana.craciun@nxp.com>
 <1556628147-15687-2-git-send-email-diana.craciun@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556628147-15687-2-git-send-email-diana.craciun@nxp.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 03:42:27PM +0300, Diana Craciun wrote:
> commit 26cb1f36c43ee6e89d2a9f48a5a7500d5248f836 upstream.
> 
> Currently only supported on powerpc.
> 
> Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  Documentation/kernel-parameters.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index f0bdf78420a0..3ff87d5d6fea 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2449,6 +2449,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			legacy floating-point registers on task switch.
>  
>  	nohugeiomap	[KNL,x86] Disable kernel huge I/O mappings.
> +	

Trailing whitespace :(

Fix up your editor to flag this as RED or something.  I'll go fix it
up...

