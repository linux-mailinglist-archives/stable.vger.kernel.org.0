Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0351611725F
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 18:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfLIRET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 12:04:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbfLIRET (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 12:04:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D5282077B;
        Mon,  9 Dec 2019 17:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575911058;
        bh=cmqg/ClU2V9cvIhXtiXl2toIjlvllGb8hnMFAl/WhiI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0PkQVP/hvcKYL47Ja2XGwEqNLfrVwaePOmoCWTCn4/5ENsIrW72xNu5n7f/xz1mZq
         LsIHKFCPLBrttqRaqN//gOgNRMQKksL2EEBEdhQpezxLKOQuzqJH0Y+qEgImrIeGNC
         FLDmdEMnVxuu1ouQxsSlwd4bewrbTbywLdcF+P4w=
Date:   Mon, 9 Dec 2019 18:04:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Linux 4.19.89-rc1 5944fcdd errors
Message-ID: <20191209170415.GE1290729@kroah.com>
References: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 09, 2019 at 04:29:22PM +0000, Chris Paterson wrote:
> Hello Greg, all,
> 
> I've seen a few errors with 4.19.89-rc1 (5944fcdd).
> 
> 2)
> Config: arm multi_v7_defconfig
> Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/373484091#L2147
> Probable culprit: 192929fd944d ("dmaengine: xilinx_dma: Fix 64-bit simple CDMA transfer")
> Issue log:
> 2147 drivers/dma/xilinx/xilinx_dma.c: In function 'xilinx_cdma_start_transfer':
> 2148 drivers/dma/xilinx/xilinx_dma.c:1252:9: error: implicit declaration of function 'xilinx_prep_dma_addr_t'; did you mean 'xilinx_dma_start'? [-Werror=implicit-function-declaration]
> 2149          xilinx_prep_dma_addr_t(hw->src_addr));
> 2150          ^~~~~~~~~~~~~~~~~~~~~~
> 2151          xilinx_dma_start

Now dropped from 4.9, 4.14, and 4.19 queues, thanks.

greg k-h
