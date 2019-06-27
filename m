Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7136587F1
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 19:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfF0RGz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 27 Jun 2019 13:06:55 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:48951 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfF0RGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 13:06:55 -0400
Received: from xps13 (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 8FDC2240003;
        Thu, 27 Jun 2019 17:06:46 +0000 (UTC)
Date:   Thu, 27 Jun 2019 19:06:44 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     liaoweixiong <liaoweixiong@allwinnertech.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        "Richard Weinberger" <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuanhong Guo <gch981213@gmail.com>,
        "Marek Vasut" <marek.vasut@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RESEND PATCH v2] mtd: spinand: read return badly if the last
 page has bitflips
Message-ID: <20190627190644.25aaaf31@xps13>
In-Reply-To: <97adf58f-4771-90f1-bdaf-5a9d00eef768@kontron.de>
References: <1561424549-784-1-git-send-email-liaoweixiong@allwinnertech.com>
        <20190625030807.GA11074@kroah.com>
        <97adf58f-4771-90f1-bdaf-5a9d00eef768@kontron.de>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Schrempf Frieder <frieder.schrempf@kontron.de> wrote on Tue, 25 Jun
2019 07:04:06 +0000:

> Hi liaoweixiong,
> 
> On 25.06.19 05:08, Greg KH wrote:
> > On Tue, Jun 25, 2019 at 09:02:29AM +0800, liaoweixiong wrote:  
> >> In case of the last page containing bitflips (ret > 0),
> >> spinand_mtd_read() will return that number of bitflips for the last
> >> page. But to me it looks like it should instead return max_bitflips like
> >> it does when the last page read returns with 0.
> >>
> >> Signed-off-by: liaoweixiong <liaoweixiong@allwinnertech.com>

Please write your entire official first/last name(s)

> >> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> >> Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>

I am waiting your next version with Acked-by instead of Rewieved-by
tags and Greg's comment addressed.
> >> Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")

Finally, when we ask you to resend a patch, it means sending a new
version of the patch. So in the subject, you should not use the
[RESEND] keyword (which means you are sending something again exactly
as it was before, you just got ignored, for example) but instead you
should increment the version number (v3) and also write a nice
changelog after the three dashes '---' (will be ignored by Git when
applying).

I would like to queue this for the next release so if you can do it
ASAP, that would be great.

Thank you,
Miquèl
