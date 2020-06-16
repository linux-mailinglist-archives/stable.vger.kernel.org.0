Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEBC1FA6F2
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 05:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgFPD1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 23:27:11 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:60933 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbgFPD1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 23:27:11 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id DADD930001EA8;
        Tue, 16 Jun 2020 05:27:04 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 9AA4450E334; Tue, 16 Jun 2020 05:27:04 +0200 (CEST)
Date:   Tue, 16 Jun 2020 05:27:04 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm2835: Fix controller unregister
 order" failed to apply to 4.19-stable tree
Message-ID: <20200616032704.rgqg23se36djchn5@wunner.de>
References: <1592234520147134@kroah.com>
 <20200616000549.GI1931@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616000549.GI1931@sasha-vm>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 08:05:49PM -0400, Sasha Levin wrote:
> On Mon, Jun 15, 2020 at 05:22:00PM +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
[...]
> > From 9dd277ff92d06f6aa95b39936ad83981d781f49b Mon Sep 17 00:00:00 2001
> > From: Lukas Wunner <lukas@wunner.de>
> > Date: Fri, 15 May 2020 17:58:02 +0200
> > Subject: [PATCH] spi: bcm2835: Fix controller unregister order
> 
> more work around master -> controller rename. Queued for 4.19, 4.14,
> 4.9, and 4.4.

Thanks a lot Sasha, that has saved me a ton of work.

FWIW, you may also want to consider queueing bd59b343a9c9
("irqchip/bcm2835: Quiesce IRQs left enabled by bootloader")
which went into v5.7-rc1 and fixes random lockups and jittery
interrupt handling if the FIQ is used on the Raspberry Pi.

(It is used by the Raspberry Pi Foundation's kernel, which is
based on 4.19-stable and will be based on 5.4-stable in the
future.)

Thanks again,

Lukas
