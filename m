Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857333CBB75
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 19:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhGPSAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 14:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhGPSAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 14:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E10B613E3;
        Fri, 16 Jul 2021 17:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626458242;
        bh=LWyG8MpHh8BFo0s7Ah/H6RgQJyhhlYoOTByzoF32aYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0XXT3d6slwl1d45kjk41yiutQIG2klAHxDijOl21jKKckOBf7ReItRB8rI9C1ozmW
         OgmC8cMVrgGucYsTfRqW9rEp7aG5F1buq5RmWwN8ZwPoqnvdSHnI2kU1pytFEtx1EC
         TxCGDZ1qCwS0u1bXElTFniICKL/O8n5nXo6WmJjg=
Date:   Fri, 16 Jul 2021 19:57:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 031/122] net: moxa: Use
 devm_platform_get_and_ioremap_resource()
Message-ID: <YPHIgCnX52+Dwap8@kroah.com>
References: <20210715182448.393443551@linuxfoundation.org>
 <20210715182456.876823976@linuxfoundation.org>
 <CADVatmNj+HSarEpuYdKsZaNyrOgyXfJw7u9LJxa2RSBf8iXnHQ@mail.gmail.com>
 <f1410523-2498-9a71-4918-d14bfde40792@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1410523-2498-9a71-4918-d14bfde40792@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 09:37:10AM +0800, Yang Yingliang wrote:
> Hi,
> 
> On 2021/7/16 5:26, Sudip Mukherjee wrote:
> > Hi Greg,
> > 
> > On Thu, Jul 15, 2021 at 7:44 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > From: Yang Yingliang <yangyingliang@huawei.com>
> > > 
> > > [ Upstream commit 35cba15a504bf4f585bb9d78f47b22b28a1a06b2 ]
> > arm moxart_defconfig build fails with the error:
> > drivers/net/ethernet/moxa/moxart_ether.c:483:22: error: implicit
> > declaration of function 'devm_platform_get_and_ioremap_resource'; did
> > you mean 'devm_platform_ioremap_resource'?
> > [-Werror=implicit-function-declaration]
> 
> devm_platform_get_and_ioremap_resource() is introduced in v5.7-rc1, I can
> send a patch for stable-5.4.

If you want to, not a big deal.  I've dropped this patch now, thanks.

greg k-h
