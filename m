Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59EC3C6726
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 01:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbhGLXwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 19:52:37 -0400
Received: from spindle.queued.net ([45.33.49.30]:54846 "EHLO
        spindle.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbhGLXwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 19:52:37 -0400
Received: from e7470.queued.net (cpe-104-162-173-121.nyc.res.rr.com [104.162.173.121])
        by spindle.queued.net (Postfix) with ESMTPSA id A8AB9FA588;
        Mon, 12 Jul 2021 16:42:56 -0700 (PDT)
Date:   Mon, 12 Jul 2021 19:42:51 -0400
From:   Andres Salomon <dilinger@queued.net>
To:     stable@vger.kernel.org
Cc:     dilinger@queued.net, Cameron Nemo <cnemo@tutanota.com>
Subject: [PATCH stable 5.10 0/2] arm64: dts: Fix USB 3 for rk3328 Rock64
 boards
Message-ID: <20210712194251.7af563ed@e7470.queued.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

At some point the USB 3 port broke on Rock64 boards; users report it
working back on 4.4 kernels, but by 5.3 it wasn't any more (eg,
https://forum.armbian.com/topic/12439-rock64-usb-3-broken/).

These two patches add a USB3 node to the device-tree, which allows it
to work again. I've tested a gigabit nic and was able to get
close to 1000mbit speeds over the USB 3 ports. I'd love to see
these two unintrusive patches added to 5.10.

Thanks,
Andres

Cameron Nemo (2):
      arm64: dts: rockchip: add rk3328 dwc3 usb controller node
      arm64: dts: rockchip: Enable USB3 for rk3328 Rock64

 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts |  5 +++++
 arch/arm64/boot/dts/rockchip/rk3328.dtsi       | 19 +++++++++++++++++++
 2 files changed, 24 insertions(+)
