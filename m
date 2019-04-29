Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A9DEBBC
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 22:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfD2Ujr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Apr 2019 16:39:47 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:54192 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbfD2Ujr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 16:39:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id AE2B56088978;
        Mon, 29 Apr 2019 22:39:44 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id U6N1K8smHgCb; Mon, 29 Apr 2019 22:39:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 750156083269;
        Mon, 29 Apr 2019 22:39:42 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wsjl_ljeozo8; Mon, 29 Apr 2019 22:39:42 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 321646083252;
        Mon, 29 Apr 2019 22:39:42 +0200 (CEST)
Date:   Mon, 29 Apr 2019 22:39:42 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Daniel Mack <daniel@zonque.org>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd <linux-mtd@lists.infradead.org>, stable@vger.kernel.org
Message-ID: <804905808.38480.1556570382142.JavaMail.zimbra@nod.at>
In-Reply-To: <20190429110013.68984b7f@xps13>
References: <20190408083145.13178-1-miquel.raynal@bootlin.com> <20190414105019.5bac65d3@collabora.com> <9a8a3963-1b8a-9f9b-8e54-200945518f99@zonque.org> <2565820.SR17ECleB1@blindfold> <20190429110013.68984b7f@xps13>
Subject: Re: [PATCH v2] mtd: rawnand: marvell: Clean the controller state
 before each operation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.8_GA_3025 (ZimbraWebClient - FF60 (Linux)/8.8.8_GA_1703)
Thread-Topic: rawnand: marvell: Clean the controller state before each operation
Thread-Index: udClQw7/IBrlpHvoiC4cEsfjESLwkA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Miquel Raynal" <miquel.raynal@bootlin.com>
> An: "richard" <richard@nod.at>
> CC: "Daniel Mack" <daniel@zonque.org>, "Boris Brezillon" <boris.brezillon@collabora.com>, "David Woodhouse"
> <dwmw2@infradead.org>, "Brian Norris" <computersforpeace@gmail.com>, "Marek Vasut" <marek.vasut@gmail.com>, "Tudor
> Ambarus" <Tudor.Ambarus@microchip.com>, "Vignesh Raghavendra" <vigneshr@ti.com>, "linux-mtd"
> <linux-
>> Isn't it visible in linux-next?
>> I was about to send a final PR to Linus later today.
>> 
> 
> Indeed the patch is missing in 20190426 -next.

Bad timing on my side I fear, now it is in -next. :-)

Thanks,
//richard

P.s: Yay, mail works again! My laptop had "issues".
