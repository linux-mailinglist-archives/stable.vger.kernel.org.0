Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155F1D25F5
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733259AbfJJJKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733254AbfJJJKn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 05:10:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A6932067B;
        Thu, 10 Oct 2019 09:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570698642;
        bh=V3zr+ZXU6ZhM0Uibhq8ct+Em8IKMgto52jOF6Bnvq5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T1bY6Te5yLOv7NsrTHNGNQMuLdhpDlrnYgXvn/MeUdUAP35iC2on6upmRxncfJwOu
         xXKjswiogbmIVTIlXqohS10argJY3P97Zzn/4JwzDmMKJIyGixleBApenhXUB2O0If
         41qntA+47iUQD5MT89jwNOGmWRkZjZKUI1D7qXJ8=
Date:   Thu, 10 Oct 2019 11:10:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 5.3 076/148] mmc: sdhci-of-esdhc: set DMA snooping based
 on DMA coherence
Message-ID: <20191010091039.GA467648@kroah.com>
References: <20191010083609.660878383@linuxfoundation.org>
 <20191010083615.965680999@linuxfoundation.org>
 <20191010084912.GI25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010084912.GI25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 09:49:12AM +0100, Russell King - ARM Linux admin wrote:
> Hi Greg,
> 
> On 5th October, Christian Zigotzky <chzigotzky@xenosoft.de> reported a
> problem with this on PowerPC (at a guess, it looks like there's a
> PowerPC user of this where the DT does not mark the device as
> dma-coherent, but the hardware requires it to be DMA coherent.)
> 
> However, despite sending a reply to him within minutes of his email
> arriving, I've heard nothing since, so there's been no progress on
> working out what is really going on.
> 
> Given that the reporter hasn't responded to my reply, I'm not sure
> what we should be doing with this... maybe the reporter has solved
> his problem, maybe he was using an incorrect DT, we just don't know.

Let's just leave this in, and if this did cause a problem, whatever fix
is made will be sent to Linus and we can then take that fix into stable
as well.

thanks,

greg k-h
