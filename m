Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE85434B45
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 14:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhJTMi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 08:38:56 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48437 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhJTMi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 08:38:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A19F95C015B;
        Wed, 20 Oct 2021 08:36:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 20 Oct 2021 08:36:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=c
        KjoT5zXT9+Nw2WnoPvDx2Y6Q/ZbLHp3Hd1KL6Yy3wE=; b=lUMM6pDRpv1H43P5u
        BssZmC1CE+20L6/I+SkW/M5dqaefRb/rAVqcf3s3hLAJfynNp9L1ChzawsdL5VeI
        BYzFk2/29JzpfB5AXS4T2Lp+qUsixfr6uAjSs6HDnhDE2tNdBD1fWBmjFMOhKNr0
        5Mkl2DZocxccYYsF5u1mTYCY21S672XUdndliOcN/rxi57aKn8AMcXbD7DG7f/j3
        t1k9Z2MKM8/JlOddyrMuWnlMYrFV1dcsqoemJEq3dPFrkIiWvHK52439aFluUcuz
        vUM5XrrtjT+cuetP/55QAdYlXP07HPjHuiw/dhWaIySKB15R1cnHBn9P0tgyF0Xo
        fhcqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=cKjoT5zXT9+Nw2WnoPvDx2Y6Q/ZbLHp3Hd1KL6Yy3
        wE=; b=E9koGG40E+bV4PQTedxp0X87DpUJjF60I32TMfYvy+ycq1soCVWR8t2ET
        WZihxMT8M7lo49qwp5Tar/y0F2d0dGOON6JNxcXsttmNv+B8314ZTr3lYmlhilCz
        Ulfz0AMam5VZHkGHR3/wnf0RGjbtKJdDxQFAVQ3rHqt6NLCuUedePCaEQDcUMAoI
        CcXXntHEdkORggswF9h8bgXY7ygRkVZLtWVwPteQxCPreF+8mKIc/8V/FxfFfqoW
        UE56I6nZnVf0yQShcOf9nMhGAL61AiaDsts86/Y0bQhpT9MbRnFQo6agGQDcVr1I
        Db8gj4uxmpQOyqiZ2fCNzvIjGDD4Q==
X-ME-Sender: <xms:WA1wYQfF9jLZ6HnUDRGu9TqjYIwpZC91Ziq_f33mPCs0NcNcGr9Elw>
    <xme:WA1wYSNKgGRU2YYPrp_Id3pukM9S0bhLqeNZpRvLbUIMox2eZmoImy6sUGG5YIDE7
    FsHXvqGKfDGYg>
X-ME-Received: <xmr:WA1wYRhb37Y8fZmyVo35pWBIJshI6GIMepvWdFR6AYmxIGiPysHPoUrKsuFEXYabivT7UFPhLAaCmflTTieP76Xehf6wMFtn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvgedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepleekud
    elgeejieejtedtvdeltdefvdefgeeltdefhfetkefhueeuhfekteeuuefgnecuffhomhgr
    ihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:WA1wYV_F9JfRyOY7HruBrEDAuIeqPAYJJDBbYzezpBslWua1ndrkRg>
    <xmx:WA1wYcsnYy7W5DaV7AunApwR6XusK9Npya3po1nnQmjE_xRC09wdyQ>
    <xmx:WA1wYcHvAhCDuGJgy17FY0914FEVgDu2B5_uWZoRmowXWxfSUjKXdA>
    <xmx:WQ1wYQh6y3AlRPkOIMZwUQdZA_RpyTNTZgb_lTcAiVYiI79hB4IHuQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 20 Oct 2021 08:36:40 -0400 (EDT)
Date:   Wed, 20 Oct 2021 14:36:37 +0200
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     stable@vger.kernel.org, Jonathan Bell <jonathan@raspberrypi.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH backport for v5.10] xhci: add quirk for host controllers
 that don't update endpoint DCS
Message-ID: <YXANVUanKdpnH+Gh@kroah.com>
References: <20211018170634.5673-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211018170634.5673-1-bjorn@mork.no>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 07:06:34PM +0200, Bjørn Mork wrote:
> From: Jonathan Bell <jonathan@raspberrypi.org>
> 
> upstream commit 5255660b208a
> 
> Seen on a VLI VL805 PCIe to USB controller. For non-stream endpoints
> at least, if the xHC halts on a particular TRB due to an error then
> the DCS field in the Out Endpoint Context maintained by the hardware
> is not updated with the current cycle state.
> 
> Using the quirk XHCI_EP_CTX_BROKEN_DCS and instead fetch the DCS bit
> from the TRB that the xHC stopped on.
> 
> See: https://github.com/raspberrypi/linux/issues/3060
> 
> Signed-off-by: Jonathan Bell <jonathan@raspberrypi.org>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
> 
> This isn't really a backport.  It's the original patch for 5.10 from
> https://github.com/raspberrypi/linux.git , which was forward ported
> and ended up as upstream commit 5255660b208a
> 
> The XHCI_EP_CTX_BROKEN_DCS constant has been syncronozed with upstream
> to avoid collisions, though.

Now queued up, thanks.

greg k-h
