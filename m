Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 243B8C30F1
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 12:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbfJAKKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 06:10:36 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:61186 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726138AbfJAKKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 06:10:36 -0400
X-IronPort-AV: E=Sophos;i="5.64,570,1559487600"; 
   d="scan'208";a="28007370"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 01 Oct 2019 19:10:34 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id D3A1541F2F61;
        Tue,  1 Oct 2019 19:10:33 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     balbi@kernel.org
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 0/2] usb: renesas_usbhs: gadget: fix for g_mass_storage
Date:   Tue,  1 Oct 2019 19:10:31 +0900
Message-Id: <1569924633-322-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series is based on the latest Greg's usb.git / usb-linus
branch.

Yoshihiro Shimoda (2):
  usb: renesas_usbhs: gadget: Do not discard queues in
    usb_ep_set_{halt,wedge}()
  usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior

 drivers/usb/renesas_usbhs/common.h     |  1 +
 drivers/usb/renesas_usbhs/fifo.c       |  2 +-
 drivers/usb/renesas_usbhs/fifo.h       |  1 +
 drivers/usb/renesas_usbhs/mod_gadget.c | 18 +++++++++++++++---
 drivers/usb/renesas_usbhs/pipe.c       | 15 +++++++++++++++
 drivers/usb/renesas_usbhs/pipe.h       |  1 +
 6 files changed, 34 insertions(+), 4 deletions(-)

-- 
2.7.4

