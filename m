Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C919793B
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 14:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfHUMY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 08:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbfHUMY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 08:24:56 -0400
Received: from localhost (unknown [12.166.174.13])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9A7C206BA;
        Wed, 21 Aug 2019 12:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566390295;
        bh=TQkFD5AZyqEo8eWNljZOpRok1YeKJ0zbNwyNfThQbZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0C6DzKNV2Oji6v58ojle4ebV+gUHWhLD1H1Ews7b5nc6yY61tGo3ToYSid9RYfCZE
         RT4zX4QmM20ZH5hcKCcO2P+HMaomCoEF0JskjXPXvuoYu4hjEHSTaaFarbSnhdBEOK
         YeygnPLuVnsPc7/OMutuPTcz8fFZsNKfCYiWkRvc=
Date:   Wed, 21 Aug 2019 05:24:55 -0700
From:   gregkh <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "stable-4.19" <stable@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>,
        Felipe Balbi <balbi@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>
Subject: Re: stable backports, from contents found in xilinx-4.19
Message-ID: <20190821122455.GB19107@kroah.com>
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

This commit is in 4.10, why would you need to add it to 4.19?

Are you sure this isn't the 4.9 list?

confused,

greg k-h
