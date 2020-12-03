Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256582CDF2B
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 20:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgLCTsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 14:48:37 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:38907 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgLCTsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 14:48:37 -0500
X-Originating-IP: 86.194.74.19
Received: from localhost (lfbn-lyo-1-997-19.w86-194.abo.wanadoo.fr [86.194.74.19])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 1AF5F240002;
        Thu,  3 Dec 2020 19:47:55 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dan Sneddon <dan.sneddon@microchip.com>,
        stable@vger.kernel.org,
        Cristian Birsan <cristian.birsan@microchip.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: at91: sama5d2: fix CAN message ram offset and size
Date:   Thu,  3 Dec 2020 20:47:53 +0100
Message-Id: <160702486441.80366.4433626293403799322.b4-ty@bootlin.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201203091949.9015-1-nicolas.ferre@microchip.com>
References: <20201203091949.9015-1-nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 3 Dec 2020 10:19:49 +0100, nicolas.ferre@microchip.com wrote:
> CAN0 and CAN1 instances share the same message ram configured
> at 0x210000 on sama5d2 Linux systems.
> According to current configuration of CAN0, we need 0x1c00 bytes
> so that the CAN1 don't overlap its message ram:
> 64 x RX FIFO0 elements => 64 x 72 bytes
> 32 x TXE (TX Event FIFO) elements => 32 x 8 bytes
> 32 x TXB (TX Buffer) elements => 32 x 72 bytes
> So a total of 7168 bytes (0x1C00).
> 
> [...]

Applied, thanks!

[1/1] ARM: dts: at91: sama5d2: fix CAN message ram offset and size
      commit: bee3d7266dc3658d40c3d36074873b1299591f11

Best regards,
-- 
Alexandre Belloni <alexandre.belloni@bootlin.com>
