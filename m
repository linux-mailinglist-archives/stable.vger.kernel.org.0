Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058DE9793E
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 14:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfHUM0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 08:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbfHUM0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 08:26:19 -0400
Received: from localhost (unknown [12.166.174.13])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84A66206BA;
        Wed, 21 Aug 2019 12:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566390378;
        bh=DlgkEEY14FShlTpTlQErxvHTcraTuzIA0E6kOYSpvkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SZ/1O76uGyClSKVZZN82/RKjzMGnpsmxbCCz+sUVp95YP0VpkUtleApdf2fZv3KNi
         vtjcymbSroDXSJ3/EQLP7UDWa0h/nybFY4jOAzr10fjzSpl73UzrqIb24QMBCBXfuQ
         3Y69cHsfoOoNGxTCv4/YWblGjWBpbKVx/tnBeuXQ=
Date:   Wed, 21 Aug 2019 05:26:17 -0700
From:   gregkh <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "stable-4.19" <stable@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>,
        Felipe Balbi <balbi@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>
Subject: Re: stable backports, from contents found in xilinx-4.19
Message-ID: <20190821122617.GC19107@kroah.com>
References: <CAK8P3a2Ew0oOQS781Q=FGvEywDspBhsZXaP1w+Ca=8HRhvf4cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2Ew0oOQS781Q=FGvEywDspBhsZXaP1w+Ca=8HRhvf4cA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 11:43:13PM +0200, Arnd Bergmann wrote:
> Similar to the 4.9 series, I looked at xilinx-4.19 from
> https://github.com/Xilinx/linux-xlnx/tree/xlnx_rebase_v4.19
> for possible backports to LTS kernels
> 
> These are the ones that look like they should be in the 4.19 lts
> tree:
> 
> d86c5a676e5b ("usb: dwc3: gadget: always try to prepare on started_list first")
> 60208a267208 ("mmc: sdhci-of-arasan: Do now show error message in case
> of deffered probe")

I queued this one up (also for 4.14)

> 899ecaedd155 ("net: ethernet: cadence: fix socket buffer corruption problem")

This too is in 4.10.  I'll stop here, can you redo this list and verify
you are not applying patches multiple times?

thanks,

greg k-h
