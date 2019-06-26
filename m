Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B20AD55D76
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 03:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfFZB2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 21:28:54 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:31822 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726037AbfFZB2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 21:28:53 -0400
X-UUID: de3f41ae6cfc40ff8934e19b86aaf6f9-20190626
X-UUID: de3f41ae6cfc40ff8934e19b86aaf6f9-20190626
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <weiyi.lu@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1273559969; Wed, 26 Jun 2019 09:28:48 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 26 Jun 2019 09:28:47 +0800
Received: from [172.21.77.4] (172.21.77.4) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 26 Jun 2019 09:28:47 +0800
Message-ID: <1561512527.24282.13.camel@mtksdaap41>
Subject: Re: [PATCH v2] clk: mediatek: mt8183: Register 13MHz clock earlier
 for clocksource
From:   Weiyi Lu <weiyi.lu@mediatek.com>
To:     Stephen Boyd <sboyd@kernel.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Rob Herring <robh@kernel.org>,
        James Liao <jamesjj.liao@mediatek.com>,
        Fan Chen <fan.chen@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-clk@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <stable@vger.kernel.org>,
        Dehui Sun <dehui.sun@mediatek.com>
Date:   Wed, 26 Jun 2019 09:28:47 +0800
In-Reply-To: <20190625221512.B691620883@mail.kernel.org>
References: <1560132969-1960-1-git-send-email-weiyi.lu@mediatek.com>
         <20190625221512.B691620883@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-06-25 at 15:15 -0700, Stephen Boyd wrote:
> Quoting Weiyi Lu (2019-06-09 19:16:09)
> > The 13MHz clock should be registered before clocksource driver is
> > initialized. Use CLK_OF_DECLARE_DRIVER() to guarantee.
> > 
> > Signed-off-by: Weiyi Lu <weiyi.lu@mediatek.com>
> 
> Do you have a Fixes: tag in mind? Otherwise, the patch looks OK to me.

Yes, Fixes: acddfc2c261b ("clk: mediatek: Add MT8183 clock support")
but I forgot to have it in the commit message. Thanks for reminding.
I'll update a V3 patch with Fixes tag. Many thanks. 

> 


