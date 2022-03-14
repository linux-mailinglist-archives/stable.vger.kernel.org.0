Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D624C4D8B89
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 19:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242948AbiCNSTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 14:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239832AbiCNSTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 14:19:46 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657AF19C21
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 11:18:36 -0700 (PDT)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E192040026
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 18:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647281914;
        bh=pln0ZykfdR6U20gd/nBd69M2uvOZDkJH678+bzhKZSQ=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=LHqsTrfnbHcraMbo3p7D5l3xj9wqDlFhLa0E+IH4BGLMN/NwgL4Mxwj6FHoDxO18M
         g/LO4m4LkF6C33Vq0E4qmmnviZEUnGrfJ7XuTHvpQwalK+/50HOinyXggfn8wQ9NmK
         fWXHxH9kYnAlyUd3/OlBmgqnoVgpzXRZa2I+TLE08EdK01j4LqTHrFeqH1xdEGGsmo
         96veFPZ0zl5MedZLIXLptZkfsDvZ6JzCgRRo9DkhLOXW4rMaiRW2/Ra7htns5g55+7
         aaal9mhbfks+HWe/9ppkPj6HCtdK9b/l5rJ6Bpv5/Br4qYahGz+LS+zw7cUCJZO/UF
         VZXcYn4MAf12A==
Received: by mail-ej1-f72.google.com with SMTP id el10-20020a170907284a00b006db9df1f3bbso4953779ejc.5
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 11:18:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pln0ZykfdR6U20gd/nBd69M2uvOZDkJH678+bzhKZSQ=;
        b=uKrSiTWyb+9gBobDjbMKYlsw0rBeV1kzCI7+mgonDWh4PxqveT1/Nv9GFZ2VH6ZvjC
         qGfGZjXpcY06pKfkYjoQoGyNg8CH9qWYspz10JtsuM5v446WIs037MeqpTBHpCGKIB2F
         LiEPBdJ9HBYdB+GMKs1P9M/56YCc109Dbk6FOZLVGSriSIAW27JrahjsB/9KWTlAEsl1
         kvFrz7AAXqD8iK2SVyZRQSeWuQBY6yu1lxUMhzDhTBPusTjWXZFGiIsJYjM8HmPo3pCv
         RWR5vpIRheYIrOS688Iy9wL69n1KWDeTxi10HgWTnHJ1L1dcS6xx4heNqrqgKYYdK1qU
         iqmQ==
X-Gm-Message-State: AOAM532N2jVFTtaXy1jxOAjNtgVstiJmoQR/jL1zf4yEBkhS/x9ZAs0R
        jIG9JLXyCp4vuIDXfHvDu3gNVmOLrA/YQXOu8wbEP+OivS/9Mew29+sg0gHjS3HVeCurriYk2k+
        NSQNfKwnfxMW6w7wG0FEqMX66uiD12/uKsw==
X-Received: by 2002:a17:907:9506:b0:6da:b4cd:515b with SMTP id ew6-20020a170907950600b006dab4cd515bmr19824109ejc.602.1647281914410;
        Mon, 14 Mar 2022 11:18:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGvZoe/6RDLg0+bwDl2IFe7QyqDAYzB9mn431xaRY3QoSX8/h1yyzN7TmRS6lE3IF/EQzEBA==
X-Received: by 2002:a17:907:9506:b0:6da:b4cd:515b with SMTP id ew6-20020a170907950600b006dab4cd515bmr19824090ejc.602.1647281914186;
        Mon, 14 Mar 2022 11:18:34 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.gmail.com with ESMTPSA id b9-20020a1709063ca900b006cea15612cbsm7310401ejh.176.2022.03.14.11.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 11:18:33 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Rob Herring <robh@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] dt-bindings: usb: hcd: correct usb-device path
Date:   Mon, 14 Mar 2022 19:18:30 +0100
Message-Id: <20220314181830.245853-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The usb-device.yaml reference is absolute so it should use /schemas part
in path.

Reported-by: Rob Herring <robh@kernel.org>
Fixes: 23bf6fc7046c ("dt-bindings: usb: convert usb-device.txt to YAML schema")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 Documentation/devicetree/bindings/usb/usb-hcd.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/usb-hcd.yaml b/Documentation/devicetree/bindings/usb/usb-hcd.yaml
index 56853c17af66..1dc3d5d7b44f 100644
--- a/Documentation/devicetree/bindings/usb/usb-hcd.yaml
+++ b/Documentation/devicetree/bindings/usb/usb-hcd.yaml
@@ -33,7 +33,7 @@ patternProperties:
   "^.*@[0-9a-f]{1,2}$":
     description: The hard wired USB devices
     type: object
-    $ref: /usb/usb-device.yaml
+    $ref: /schemas/usb/usb-device.yaml
 
 additionalProperties: true
 
-- 
2.32.0

