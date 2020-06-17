Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786221FCA8F
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 12:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgFQKNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 06:13:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgFQKNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 06:13:42 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8B932082F;
        Wed, 17 Jun 2020 10:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592388821;
        bh=p1p1lrThYfCOemkuWNAPrSGsFSXxrA/pHOks15NZh64=;
        h=From:To:Cc:Subject:Date:From;
        b=V3ep8wDX8Fzm402JtqkeKS4v4iE//EcfZdZDtY6R4/kC+RaCXY9DBXlUMtCcG17/i
         Zr9G/8nm/GPXzxrj8h/hkaoGlkHT2UA1bcsy6UCn9kSwCqR23NM/m/Ddpx44ci/+hT
         5bG6J5WUtsvzr0x+yiJWFYvwkeznk19DV9PCynyU=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Rob Herring <robh+dt@kernel.org>, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] dt-bindings: iio: bmc150_magn: Document missing compatibles
Date:   Wed, 17 Jun 2020 12:12:59 +0200
Message-Id: <20200617101259.12525-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver supports also BMC156B and BMM150B so document the compatibles
for these devices.

Fixes: 9d75db36df14 ("iio: magn: Add support for BMM150 magnetometer")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

The fixes tag is not accurate but at least offer some backporting.
---
 .../devicetree/bindings/iio/magnetometer/bmc150_magn.txt     | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt b/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt
index fd5fca90fb39..7469073022db 100644
--- a/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt
+++ b/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt
@@ -4,7 +4,10 @@ http://ae-bst.resource.bosch.com/media/products/dokumente/bmc150/BST-BMC150-DS00
 
 Required properties:
 
-  - compatible : should be "bosch,bmc150_magn"
+  - compatible : should be one of:
+                 "bosch,bmc150_magn"
+                 "bosch,bmc156_magn"
+                 "bosch,bmm150_magn"
   - reg : the I2C address of the magnetometer
 
 Optional properties:
-- 
2.17.1

