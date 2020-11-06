Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5902A9410
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 11:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgKFKWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 05:22:03 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:53325 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726865AbgKFKWB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 05:22:01 -0500
X-UUID: 9b89258081404873932c7c17e901f2c8-20201106
X-UUID: 9b89258081404873932c7c17e901f2c8-20201106
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 837883830; Fri, 06 Nov 2020 18:21:51 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 6 Nov 2020 18:21:48 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 6 Nov 2020 18:21:48 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Chunfeng Yun <Chunfeng.Yun@mediatek.com>
CC:     Ainge Hsu <ainge.hsu@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v3 1/2] dt-bindings: usb: mediatek,mtk-xhci: add str-clock-on
Date:   Fri, 6 Nov 2020 18:21:36 +0800
Message-ID: <1604658097-5127-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1604301530-31546-1-git-send-email-macpaul.lin@mediatek.com>
References: <1604301530-31546-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Option "mediatek,str-clock-on" means to keep clock on during system
suspend and resume. Some platform will flush register settings if clock has
been disabled when system is suspended. Set this option to avoid clock off.

Fixes: 0cbd4b34cda9 ("xhci: mediatek: support MTK xHCI host controller")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Cc: stable@vger.kernel.org
---
Changes for v3:
  - Remove unnecessary Change-Id in commit message.
  - Add "Fixes" tag as a bug fix on phone system.
Changes for v2:
  - Rename "mediatek,keep-clock-on" to "mediatek,str-clock-on" which implies
    this option related to STR functions.
  - After discussion with Chunfeng, resend dt-bindings descritption based on
    mediatek,mtk-xhci.txt instead of yaml format.

 .../devicetree/bindings/usb/mediatek,mtk-xhci.txt  |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.txt b/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.txt
index 42d8814..fc93bcf 100644
--- a/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.txt
+++ b/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.txt
@@ -37,6 +37,9 @@ Required properties:
 
 Optional properties:
  - wakeup-source : enable USB remote wakeup;
+ - mediatek,str-clock-on: Keep clock on during system suspend and resume.
+	Some platform will flush register settings if clock has been disabled
+	when system is suspended.
  - mediatek,syscon-wakeup : phandle to syscon used to access the register
 	of the USB wakeup glue layer between xHCI and SPM; it depends on
 	"wakeup-source", and has two arguments:
-- 
1.7.9.5

