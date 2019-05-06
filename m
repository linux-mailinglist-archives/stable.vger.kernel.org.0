Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05042145CC
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 10:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbfEFIL5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 6 May 2019 04:11:57 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37325 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfEFIL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 04:11:57 -0400
X-Originating-IP: 90.88.149.145
Received: from xps13 (aaubervilliers-681-1-29-145.w90-88.abo.wanadoo.fr [90.88.149.145])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 0E163E0023;
        Mon,  6 May 2019 08:11:50 +0000 (UTC)
Date:   Mon, 6 May 2019 10:11:49 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     xiaolei li <xiaolei.li@mediatek.com>
Cc:     Sasha Levin <sashal@kernel.org>, <richard@nod.at>,
        <linux-mtd@lists.infradead.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] mtd: rawnand: mtk: Correct low level time
 calculation of r/w cycle
Message-ID: <20190506101149.221361b0@xps13>
In-Reply-To: <1557040000.26455.59.camel@mhfsdcap03>
References: <20190430100250.28083-2-xiaolei.li@mediatek.com>
        <20190430103205.5175421744@mail.kernel.org>
        <1557040000.26455.59.camel@mhfsdcap03>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi xiaolei,

xiaolei li <xiaolei.li@mediatek.com> wrote on Sun, 5 May 2019 15:06:40
+0800:

> Hi Sasha,
> 
> I am not sure if it is caused by raw NAND code path change.
> 
> Raw NAND code was moved from mtd/nand to mtd/nand/raw subdirectory since
> kernel v4.17.
> 
> The fixing commit: edfee3619c49 mtd: nand: mtk:
> add->setup_data_interface() hook exists before kernel v4.17.
> 
> @Miquel, do you know if some other raw NAND driver ever encountered this
> case? Thanks.

Don't know. Just checkout a 4.14.114 and try to apply the patch :)

> 
> On Tue, 2019-04-30 at 10:32 +0000, Sasha Levin wrote:
> > Hi,
> > 
> > [This is an automated email]
> > 
> > This commit has been processed because it contains a "Fixes:" tag,
> > fixing commit: edfee3619c49 mtd: nand: mtk: add ->setup_data_interface() hook.


Thanks,
Miquèl
