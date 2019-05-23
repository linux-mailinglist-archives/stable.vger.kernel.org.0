Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763FB2853C
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 19:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbfEWRp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 13:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730899AbfEWRp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 13:45:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35FE12184B;
        Thu, 23 May 2019 17:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558633555;
        bh=p8BXqhTRhWKnrX/cqRF/HYXbO/m4cyRS/nCIjDvwecg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KZLKsYIErhSc7E0yerFLhlNVm7LTgbWnv597YDn9NpmMsn+zPYMznSUo5+bGnDw32
         1he9hqNVKaVzanholbD9JJOPdGCFcsVHlUVEtt/8vzSew/MQjujU2NO25QmVKR4dvu
         H5PN9wWmQHCnsJ3nmr8o8UOlKvHWZ/Tal4dVze9c=
Date:   Thu, 23 May 2019 19:45:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Richard Leitner <richard.leitner@skidata.com>
Cc:     stable@vger.kernel.org, "Angus Ainslie (Purism)" <angus@akkea.ca>,
        Robin Gong <yibin.gong@nxp.com>, Vinod Koul <vkoul@kernel.org>
Subject: Re: dmaengine: imx-sdma: Only check ratio on parts that support 1:1
Message-ID: <20190523174553.GC29438@kroah.com>
References: <b96a7d7c-30b1-3153-29ed-1a3ece561b4e@skidata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b96a7d7c-30b1-3153-29ed-1a3ece561b4e@skidata.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 01:14:55PM +0200, Richard Leitner wrote:
> Please apply commit 941acd566b18 ("dmaengine: imx-sdma: Only check ratio on
> parts that support 1:1") to the 5.1 stable branch.
> 
> Without this patch following error message is issues when writing to UART 3
> or UART 4 on an i.MX6 solo lite with Linux v5.1.4 (which fails).
> 
> 	imx-sdma 20ec000.sdma: Timeout waiting for CH0 ready
> 
> The problem is fixed when applying this patch on v5.1.4 tag.

Now queued up, thanks.

greg k-h
