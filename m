Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67CF261BFD
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731659AbgIHTLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731221AbgIHQFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:05:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A5CF224D4;
        Tue,  8 Sep 2020 15:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579957;
        bh=wsxTGtB20xdsXfzfz5WUQgQxXBVoS2VI8LTkh0qe+kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJgjJK8VTsPx9C3/svF03jV5VcUTuyXTCebb0Wk73WPVoJaqo1dRW8qy8UK1PV2Zu
         AP361DSnRI15Rz9JjKRujLvJMCwEyqFPvlOVW2vqJgoqRU4hMQ6g4o3IQHhEVYlpJ3
         TP/yTWNfHUoLlrXYJ42T3XOYzBcJck6KpZ97/nVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenbin Mei <wenbin.mei@mediatek.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 101/129] mmc: dt-bindings: Add resets/reset-names for Mediatek MMC bindings
Date:   Tue,  8 Sep 2020 17:25:42 +0200
Message-Id: <20200908152234.883926834@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenbin Mei <wenbin.mei@mediatek.com>

commit 65557383191de46611dd3d6b639cbcfbade43c4a upstream.

Add description for resets/reset-names.

Cc: <stable@vger.kernel.org> # v5.4+
Fixes: 966580ad236e ("mmc: mediatek: add support for MT7622 SoC")
Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
Tested-by: Frank Wunderlich <frank-w@public-files.de>
Link: https://lore.kernel.org/r/20200814014346.6496-2-wenbin.mei@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/mmc/mtk-sd.txt |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/devicetree/bindings/mmc/mtk-sd.txt
+++ b/Documentation/devicetree/bindings/mmc/mtk-sd.txt
@@ -49,6 +49,8 @@ Optional properties:
 		     error caused by stop clock(fifo full)
 		     Valid range = [0:0x7]. if not present, default value is 0.
 		     applied to compatible "mediatek,mt2701-mmc".
+- resets: Phandle and reset specifier pair to softreset line of MSDC IP.
+- reset-names: Should be "hrst".
 
 Examples:
 mmc0: mmc@11230000 {


