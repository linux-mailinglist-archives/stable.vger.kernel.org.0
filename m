Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64493D253C
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 16:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhGVN3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 09:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232105AbhGVN3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 09:29:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 041DB6100C;
        Thu, 22 Jul 2021 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626963017;
        bh=+4IS+LeqMBgAX5MpkMmGipXc+DhLhTwdc+5swEDFnik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r57Jwox2T9tgbYJaRisdfMxj6SyfbSMtlgKvA/Z7BIiKtL5pWZYz/s39Wvrpcw1vc
         P9D+A6QiWsEeB2OWvEzbm8YYNlQcFbWkj8ExIjyoAsCTM1QoL9tl0xTdMtByfueDBv
         nF6gsji/kNZdhvOWbY3hNZPDKlHgSk33FYYmHixw=
Date:   Thu, 22 Jul 2021 16:10:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Deren Wu <Deren.Wu@mediatek.com>
Cc:     stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Jimmy Hu <Jimmy.Hu@mediatek.com>
Subject: Re: [PATCH] mt76: mt7921: fix the insmod hangs
Message-ID: <YPl8Rijw12mQERlT@kroah.com>
References: <20210721130918.4491-1-Deren.Wu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721130918.4491-1-Deren.Wu@mediatek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 21, 2021 at 09:09:18PM +0800, Deren Wu wrote:
> From: Sean Wang <sean.wang@mediatek.com>
> 
> [ Upstream commit 49897c529f85504139a6e54417a65f26a07492d2 ]
> 
> Fix the second insert module causing the device hangs after remove module.
> 
> Fixes: 1c099ab44727 ("mt76: mt7921: add MCU support")
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=49897c529f85504139a6e54417a65f26a07492d2
> Signed-off-by: Deren Wu <deren.wu@mediatek.com>
> Cc: <stable@vger.kernel.org> # 5.12
> ---
>  drivers/net/wireless/mediatek/mt76/mt7921/init.c   |  2 --
>  drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  3 +--
>  drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    | 13 +------------
>  drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |  1 +
>  4 files changed, 3 insertions(+), 16 deletions(-)

5.12.y is now end-of-life, sorry.

greg k-h
