Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2D4220CD3
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 14:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgGOMVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 08:21:30 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:58345 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725924AbgGOMVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 08:21:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 25CB13AA;
        Wed, 15 Jul 2020 08:21:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Jul 2020 08:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Os8yojc9rU9w/PvEC4M3X48kuQc
        3QUyrahdQ83qmgYw=; b=GVfKKPDhlqF2OPOgqpbwvg8nMyaL6rwUpRNsxGq1LZv
        4cQdkf2AbOWqoKfURl1ZGsAVHZ/VnDG1cuZQZTWwb2xQ3VMXhIJt6hSAoCicM1v0
        0vcD85H03HVFHNqKJl1ne51SfCcyFUcGgHEL0h1biUftXb2/4A+fqxNv6Tyy0Dj1
        uEc+GcDgK2G4IeezM4cyAF82OWU/QXndNKI8JYMNbYAbOCt+DBo7pxl/gcbCw0/x
        HsTjh+6Rn3QuKWTYBgBZXlzd7C7Bbts2NKuG/b7jtZBhMmRG6dHQSAAnzifwI64O
        CjSCl1r2QCPt8vkszGRC1yANUsU5CNQf5mhrUSCExrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Os8yoj
        c9rU9w/PvEC4M3X48kuQc3QUyrahdQ83qmgYw=; b=PeCl3c8eTVmWOzC3j6JeTG
        TQjux/QpsbR35D1R86W31gSAIwIIA6V0jicPWCI/TBF0fQf90816TSMD5Oc54bE1
        2kV0IpojbQjj5vvOn04QsfhrfWVc63Ix+0VZhkL/G/Hdn3ZxvANEwBv/WjG+SqYL
        VnVwTV7rl6i966TIc9BeiutUAIAFx33c5QlL7hhn+n5FKdlBYvGaTXB0mkGpBLqh
        GQPTt/K1ntOO/XSUTstA1HD44wCF1kv9s9cAdhv1I+goHY1+qE7bPNhr9OxpMnun
        VB4FXVR9hHwNay67cT8gbP8UirHH1mYlSc2DcOetMII5erl1fGPe5KSrisdDbiDQ
        ==
X-ME-Sender: <xms:yPQOX37HhjykSF0AH-EXR6xmRr69MNOHzAXetOBMis5wMCMK-T3wdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:yPQOX85AvFDDAxIHR3TxeqevH0a3xGyXXGFVPuIOfTRx6W24hZYuWg>
    <xmx:yPQOX-cDqdvW8j0suSjjXbhuXl15RVOG3ac_tFTCl2bvS795AD9Wzw>
    <xmx:yPQOX4KfT5DfiG0fRItVnIFpGliLJ0Hl-gPcWta6VNg53LQ_PJZ4qA>
    <xmx:yPQOX2l_DhQhWEQ7sDHD5gHQtoO1OQ1P5CY2yCp8-fJHEZb2Nothww>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 397B430600A6;
        Wed, 15 Jul 2020 08:21:28 -0400 (EDT)
Date:   Wed, 15 Jul 2020 14:21:24 +0200
From:   Greg KH <greg@kroah.com>
To:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc:     "# v5 . 3+" <stable@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: Re: [PATCH] megaraid_sas: remove undefined ENABLE_IRQ_POLL macro
Message-ID: <20200715122124.GA2937397@kroah.com>
References: <20200715115630.19457-1-chandrakanth.patil@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715115630.19457-1-chandrakanth.patil@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 05:26:30PM +0530, Chandrakanth Patil wrote:
> Issue:
> As ENABLE_IRQ_POLL macro is undefined, the check for ENABLE_IRQ_POLL
> macro in ISR will always be false leads to irq polling non-functional.
> 
> Fix:
> Remove ENABLE_IRQ_POLL check from isr
> 
> Fixes: a6ffd5bf6819 ("scsi: megaraid_sas: Call disable_irq from process IRQ")
> Cc: <stable@vger.kernel.org> # v5.3+
> Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 --
>  1 file changed, 2 deletions(-)

Why are you not sending this to the scsi developers / maintainers?

thanks,

greg k-h
