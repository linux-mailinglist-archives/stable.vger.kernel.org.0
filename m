Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D894627A1
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbhK2XId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbhK2XHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:07:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B619CC144FE6;
        Mon, 29 Nov 2021 10:33:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E8ACB815DD;
        Mon, 29 Nov 2021 18:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC50C53FC7;
        Mon, 29 Nov 2021 18:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210830;
        bh=BqlUchDsa7joZqIs5J3rBBl1h9rsga8AfJJ2imUAGIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i80LWIGuojXj3iJNMyjYHZCd2SxRK7k2nwA8cC3ilxJzqaX58OzBg/Wa/zHzobIYh
         R05J1cqbKaFbJGJwii3OHE9/SmndMWT6XjnH1ZlpM2krrIeOQ6ma4OSNiS3t/UzvrH
         boIDXDoRaLel+oBDzfgEBd7IE9zX5hye4pIvgDjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.15 010/179] usb: dwc3: core: Revise GHWPARAMS9 offset
Date:   Mon, 29 Nov 2021 19:16:44 +0100
Message-Id: <20211129181719.284274060@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 250fdabec6ffcaf895c5e0dedca62706ef10d8f6 upstream.

During our predesign phase for DWC_usb32, the GHWPARAMS9 register offset
was 0xc680. We revised our final design, and the GHWPARAMS9 offset is
now moved to 0xc6e8 on release.

Fixes: 16710380d3aa ("usb: dwc3: Capture new capability register GHWPARAMS9")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/1541737108266a97208ff827805be1f32852590c.1635202893.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -143,7 +143,7 @@
 #define DWC3_GHWPARAMS8		0xc600
 #define DWC3_GUCTL3		0xc60c
 #define DWC3_GFLADJ		0xc630
-#define DWC3_GHWPARAMS9		0xc680
+#define DWC3_GHWPARAMS9		0xc6e0
 
 /* Device Registers */
 #define DWC3_DCFG		0xc700


