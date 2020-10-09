Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB93F288A31
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 16:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388075AbgJIOAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 10:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732456AbgJIOAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Oct 2020 10:00:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3BF2222C3;
        Fri,  9 Oct 2020 14:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602252049;
        bh=jEAWcikAcJp6lmGEFkptG0Is9hi96rOEB5zgcAjrjeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eVgp2j5eNQlWTN8QihsanCIQaJNzB5yTnrSVyyyeuyhrJZRBKSMiNMBVfPJOdXHj0
         pzq6ojCsCr9dndUQQMitd/J8CoYCbOCuPunRLrr+8UHnsbOjHkC+/Bs3CZfhd589Cv
         uFaKPJ2nuIZNd0a/5zCsP0qKJbnfoUNr270Lz/e4=
Date:   Fri, 9 Oct 2020 16:01:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: Re: [PATCH for 4.19, 5.4] arm64: dts: stratix10: add status to qspi
 dts node
Message-ID: <20201009140135.GA573779@kroah.com>
References: <20201009070506.549956-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009070506.549956-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 09, 2020 at 04:05:06PM +0900, Nobuhiro Iwamatsu wrote:
> From: Dinh Nguyen <dinguyen@kernel.org>
> 
> commit 263a0269a59c0b4145829462a107fe7f7327105f upstream.
> 
> Add status = "okay" to QSPI node.
> 
> Fixes: 0cb140d07fc75 ("arm64: dts: stratix10: Add QSPI support for Stratix10")
> Cc: linux-stable <stable@vger.kernel.org> # >= v5.6
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> [iwamatsu: Drop arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts]
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts | 1 +
>  1 file changed, 1 insertion(+)

Thanks for all of the backports, now queued up.

greg k-h
