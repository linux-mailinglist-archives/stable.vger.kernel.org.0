Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F23457AA43
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 15:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfG3N4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 09:56:14 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40318 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfG3N4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 09:56:13 -0400
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 3260928A109;
        Tue, 30 Jul 2019 14:56:12 +0100 (BST)
Date:   Tue, 30 Jul 2019 15:56:09 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     richard.weinberger@gmail.com, miquel.raynal@bootlin.com,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] mtd: rawnand: micron: handle on-die "ECC-off"
 devices correctly
Message-ID: <20190730155609.09331b24@collabora.com>
In-Reply-To: <20190730133748.dzzst6p6u77tvke7@pengutronix.de>
References: <20190729070652.12629-1-m.felsch@pengutronix.de>
        <20190729095715.2de79aea@collabora.com>
        <20190730133748.dzzst6p6u77tvke7@pengutronix.de>
Organization: Collabora
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 30 Jul 2019 15:37:48 +0200
Marco Felsch <m.felsch@pengutronix.de> wrote:

> Hi Boris,
> 
> On 19-07-29 09:57, Boris Brezillon wrote:
> > On Mon, 29 Jul 2019 09:06:52 +0200
> > Marco Felsch <m.felsch@pengutronix.de> wrote:
> >   
> > > Some devices are supposed to do not support on-die ECC but experience  
> > 
> > 		^ are not supposed to support  
> 
> Fixed both, thanks. I will keep you rb-tag okay?

Sure.

