Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EBB1F922E
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 10:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgFOItz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 15 Jun 2020 04:49:55 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:28561 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728526AbgFOItz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 04:49:55 -0400
X-Originating-IP: 91.224.148.103
Received: from xps13 (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id DAED9240013;
        Mon, 15 Jun 2020 08:49:45 +0000 (UTC)
Date:   Mon, 15 Jun 2020 10:49:43 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sivaprakash Murugesan <sivaprak@codeaurora.org>
Cc:     richard@nod.at, vigneshr@ti.com, peter.ujfalusi@ti.com,
        boris.brezillon@collabora.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V4 1/2] mtd: rawnand: qcom: avoid write to unavailable
 register
Message-ID: <20200615104943.16b1b8db@xps13>
In-Reply-To: <1591948696-16015-2-git-send-email-sivaprak@codeaurora.org>
References: <1591948696-16015-1-git-send-email-sivaprak@codeaurora.org>
        <1591948696-16015-2-git-send-email-sivaprak@codeaurora.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sivaprakash,

Sivaprakash Murugesan <sivaprak@codeaurora.org> wrote on Fri, 12 Jun
2020 13:28:15 +0530:

> SFLASHC_BURST_CFG is only available on older ipq nand platforms, this
> register has been removed when the NAND controller is moved as part of qpic
> controller.
> 
> Avoid writing this register on devices which are based on qpic NAND
> controller.
> 
> Fixes: dce84760 (mtd: nand: qcom: Support for IPQ8074 QPIC NAND controller)

The Fixes line is not properly formed: the number of digest digits must
be 12 and the title should be enclosed with "". I will fix when
applying.

Thanks,
Miquèl
