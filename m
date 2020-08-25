Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CED1250FCF
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 05:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgHYDEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 23:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbgHYDEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 23:04:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7FFC061574;
        Mon, 24 Aug 2020 20:04:22 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f193so6167797pfa.12;
        Mon, 24 Aug 2020 20:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BGmrF9cwRFx/ekg5o1tXG7IAo6MkGr2rLUfXCXbPNWg=;
        b=EikgWl43z2EuCVPR7/KZSG7p8FS4QT/l/Hkaj0YvcngHVVLlAagy+XBCKUyTYYeScV
         pvcGnfLwTS9ihiPbEZ9aUJC3VzdOMtSaKpgPfcDakGVT33RC/NctZotklUnHV65yFPRe
         /6SVTg5FecazqgSHVemCs8FqPevY1APZp+NYd9E3z01dLKUnKcCoe6nUtIE3pTOtS530
         mN7MTG8O/A1Hve0Xv6b6c17sRXC60f4S/3OS4l1upeRABSHk+IqWyBr+Z4nXF2T6Grvg
         Gv/S7SOYBlUGHzD8ryM+QxdIS7vMW+MTHZj9K3JY3L64WJWeoFc7gvs2Q241OcMPZiwd
         9CPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BGmrF9cwRFx/ekg5o1tXG7IAo6MkGr2rLUfXCXbPNWg=;
        b=blYUl6hOpT+mPwqTF3VW0rbFnSrARnq0jmhwKMNZUzhXEY7aMeL43p0FHitoG0aA8s
         ekEN6X+Ho9B3uVZb5rl8bIBYPgndH87tEC9jPbZtU/QeFcM3Co9qkI06kbxROSuX3BQ5
         UYKbZQlo730LXvQmO6eStF1YXIZZrqD9eyo4AQJCHnxuT85r8JS0c++A89KW2eZuA59K
         nJHRw3JofuL8UHWD/Ii6HJ7ndfxyUsY3EhQ71g5By+zyQeRud8nr+7u/XLsgT5OZ13Gt
         O7dniiANPTl3ndkvHFsqBqdW9FctRjzsIAcahpbCQXjonHcnvb9wAEHwtQLIIu2P7nN+
         pC/Q==
X-Gm-Message-State: AOAM5311tQzkyBIyKlMt/K5YOLrkgU3UMXct+f1fbGepeZ2Dc31n9/9A
        ha2GwjrWzCprBqirxyM1xcI=
X-Google-Smtp-Source: ABdhPJzAK53ztKymKoKiDhV5B+S78kl9c18zGIO6zB2DoaxXJvsIyUxMSWYDD7Md7Y69pmna/KDmMw==
X-Received: by 2002:a17:902:b205:: with SMTP id t5mr6146283plr.7.1598324661111;
        Mon, 24 Aug 2020 20:04:21 -0700 (PDT)
Received: from localhost.localdomain.com ([2605:e000:160b:911f:722f:a74:437d:fd3c])
        by smtp.gmail.com with ESMTPSA id q2sm11526062pgs.90.2020.08.24.20.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 20:04:20 -0700 (PDT)
From:   Chris Healy <cphealy@gmail.com>
X-Google-Original-From: Chris Healy <cphealy@gmail.com
To:     srinivas.kandagatla@linaro.org, robh+dt@kernel.org,
        gregkh@linuxfoundation.org, maitysanchayan@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, stefan@agner.ch, festevam@gmail.com,
        stable@vger.kernel.org, andrew.smirnov@gmail.com
Cc:     Chris Healy <cphealy@gmail.com>
Subject: [PATCH v4] dt-bindings: nvmem: Add syscon to Vybrid OCOTP driver
Date:   Mon, 24 Aug 2020 20:04:06 -0700
Message-Id: <20200825030406.373623-1-cphealy@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Healy <cphealy@gmail.com>

Add syscon compatibility with Vybrid OCOTP driver binding. This is
required to access the UID.

Fixes: 623069946952 ("nvmem: Add DT binding documentation for Vybrid
OCOTP driver")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Healy <cphealy@gmail.com>
---
Changes in v4:
 - Point to the appropriate commit for the Fixes: line
 - Update the Required Properties to add the "syscon" compatible
---
 Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt b/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt
index 56ed481c3e26..72ba628f6d0b 100644
--- a/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt
+++ b/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt
@@ -2,7 +2,7 @@ On-Chip OTP Memory for Freescale Vybrid
 
 Required Properties:
   compatible:
-  - "fsl,vf610-ocotp" for VF5xx/VF6xx
+  - "fsl,vf610-ocotp", "syscon" for VF5xx/VF6xx
   #address-cells : Should be 1
   #size-cells : Should be 1
   reg : Address and length of OTP controller and fuse map registers
@@ -11,7 +11,7 @@ Required Properties:
 Example for Vybrid VF5xx/VF6xx:
 
 	ocotp: ocotp@400a5000 {
-		compatible = "fsl,vf610-ocotp";
+		compatible = "fsl,vf610-ocotp", "syscon";
 		#address-cells = <1>;
 		#size-cells = <1>;
 		reg = <0x400a5000 0xCF0>;
-- 
2.26.2

