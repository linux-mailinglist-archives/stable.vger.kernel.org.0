Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0CCE13E0A
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 09:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfEEHGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 03:06:49 -0400
Received: from Mailgw01.mediatek.com ([1.203.163.78]:1465 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725792AbfEEHGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 03:06:49 -0400
X-UUID: 418a181d693649e8a51fa2de1cd7ab65-20190505
X-UUID: 418a181d693649e8a51fa2de1cd7ab65-20190505
Received: from mtkcas34.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <xiaolei.li@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 26004991; Sun, 05 May 2019 15:06:43 +0800
Received: from MTKCAS32.mediatek.inc (172.27.4.184) by MTKMBS32N1.mediatek.inc
 (172.27.4.71) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Sun, 5 May
 2019 15:06:41 +0800
Received: from [10.17.3.153] (172.27.4.253) by MTKCAS32.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sun, 5 May 2019 15:06:40 +0800
Message-ID: <1557040000.26455.59.camel@mhfsdcap03>
Subject: Re: [PATCH v2 1/5] mtd: rawnand: mtk: Correct low level time
 calculation of r/w cycle
From:   xiaolei li <xiaolei.li@mediatek.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     <miquel.raynal@bootlin.com>, <richard@nod.at>,
        <linux-mtd@lists.infradead.org>, <stable@vger.kernel.org>
Date:   Sun, 5 May 2019 15:06:40 +0800
In-Reply-To: <20190430103205.5175421744@mail.kernel.org>
References: <20190430100250.28083-2-xiaolei.li@mediatek.com>
         <20190430103205.5175421744@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: B9B3AC740D21CB2D906577B0BCF6E19197523C342EA54B9C5971A556DB209DBF2000:8
X-MTK:  N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

I am not sure if it is caused by raw NAND code path change.

Raw NAND code was moved from mtd/nand to mtd/nand/raw subdirectory since
kernel v4.17.

The fixing commit: edfee3619c49 mtd: nand: mtk:
add->setup_data_interface() hook exists before kernel v4.17.

@Miquel, do you know if some other raw NAND driver ever encountered this
case? Thanks.

On Tue, 2019-04-30 at 10:32 +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: edfee3619c49 mtd: nand: mtk: add ->setup_data_interface() hook.
> 
> The bot has tested the following trees: v5.0.10, v4.19.37, v4.14.114.
> 
> v5.0.10: Build OK!
> v4.19.37: Build OK!
> v4.14.114: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> 
> How should we proceed with this patch?
> 
> --
> Thanks,
> Sasha

Thanks,
Xiaolei

