Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE4224E29D
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 23:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgHUVVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 17:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgHUVVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 17:21:49 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ABAC061573;
        Fri, 21 Aug 2020 14:21:49 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t11so1447439plr.5;
        Fri, 21 Aug 2020 14:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pzPVCiNoxUXnWve1pQAQQPwMv0Z5oM4+Bqr3t8jovHY=;
        b=Ci/q1REoYfWyUw6ZpJqRjlMhi+lzKepr2JIbhqaL5o8UB2Mxj4bHRZ2G0sgu/fV7d6
         M0995EDpW5abeDx099ojQ3/p9y47tRYNtLF/tsne43fH8IqKPYeYkyzTES7Go0S+nTaZ
         anCrFNmNP8fF97M/fZkqfG6i/A7i6LT56LBphwzruIO1wHIMN541FmC6uHcigijtVimd
         uZYpbKHqFH4QNCZ8dommKNCwsI4L0Fdcb9VB6xyF3vHKHD24N+425maVkP6xYogoKs9O
         YKCsVPBg0YpN8/HPIF29dv2wfIoaGT6/VksZ32fLgdlpz0G7WjZhk1mihWr0PLDK7o4b
         fWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pzPVCiNoxUXnWve1pQAQQPwMv0Z5oM4+Bqr3t8jovHY=;
        b=CYpJsLR966xhbjFZ5lwXTw3ykW19UEoZBTxC/0FeTSBSVZjLvTNclcAVJm9cgcCcL0
         neTkEWwTODs3QEx2p6qSjV54skcpU65Azijnj9Frmsy+D5J0ISMB/vxgjmFniAoG9ibH
         o1umLgZVun/OaoFbcegACyIHrjUadar+6QqJ8BmWcmkWG6YWROVQvDPR238arWs3HYA9
         PtfBeq0GOcpvROS0oIGRSfmN3gwJ4VmXZrNM4QsjAppyRvoeC5fM/g84WZ1Ud7BQA7F0
         UoN723eKgtqkMH36cuzrf1ePFDMocv9IikpGWEdSwK+6QzabrOaneYmEEBW25u4SctLP
         o2sw==
X-Gm-Message-State: AOAM532ffco1DDzcfYBS5oNQecKLrCqn/eT9dUbYWCJGQNUSUrM+eFM7
        rPsqEzx/1++DgaSqMXftWAA=
X-Google-Smtp-Source: ABdhPJwfsavDvEQmi7fVsJZkBWfl2Pp41P3rQqu5ti0QXM3W2MUqKWAvU6kzN3gnvSdi2VOIBOfGcA==
X-Received: by 2002:a17:90a:6e0c:: with SMTP id b12mr3938034pjk.141.1598044908845;
        Fri, 21 Aug 2020 14:21:48 -0700 (PDT)
Received: from localhost.localdomain.com ([2605:e000:160b:911f:722f:a74:437d:fd3c])
        by smtp.gmail.com with ESMTPSA id d81sm3488611pfd.174.2020.08.21.14.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 14:21:47 -0700 (PDT)
From:   Chris Healy <cphealy@gmail.com>
X-Google-Original-From: Chris Healy <cphealy@gmail.com
To:     srinivas.kandagatla@linaro.org, robh+dt@kernel.org,
        shawnguo@kernel.org, andrew.smirnov@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, stefan@agner.ch,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        festevam@gmail.com
Cc:     Chris Healy <cphealy@gmail.com>
Subject: [PATCH v3 1/2] dt-bindings: nvmem: Add syscon to Vybrid OCOTP driver
Date:   Fri, 21 Aug 2020 14:21:01 -0700
Message-Id: <20200821212102.137991-1-cphealy@gmail.com>
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

Fixes: fa8d20c8dbb77 ("ARM: dts: vfxxx: Add node corresponding to OCOTP")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Healy <cphealy@gmail.com>
---
 Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt b/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt
index 56ed481c3e26..5db39f399568 100644
--- a/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt
+++ b/Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt
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

