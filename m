Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8BE50964D
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 07:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384201AbiDUFLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 01:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384218AbiDUFK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 01:10:58 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEDDBC8B
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 22:08:10 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id y129so2847013qkb.2
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 22:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=BwurdqM9Z5tXNzsAhYUEG0DzBUJntj7ZcLP7S0znVjk=;
        b=xgku3ptbkvczLZ8bQJO4N65FL30XJecblXXGEVrbR5zj8n8uOrzZnaFBAeNu06jdoj
         NKBrloVOFmKr+IIGRK6DtJ/h81PEcUqQDZoeJoyouDM6UDG81wK9vQ1MrfNGQYB8VJdW
         T0aE7J32up9pD1+VqrC8BNE12EQG0bjj4kFosFOwfywLLAGrFzENftXPoNrCAAoY7FkB
         EuEwJFKLSvVDQ+3yC1Pxt8yNg8MmQ1qjB5ZN17JcoCWhyjvObv3WhIM6c00H2Ibb947b
         nlXcKCvFsqtZCZadjbmjMwgLvCxsnAlhkIdMEMSC5Wg5R466/BiMkUNVEMRvUnI2fI1e
         GQiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=BwurdqM9Z5tXNzsAhYUEG0DzBUJntj7ZcLP7S0znVjk=;
        b=tEEKbH3e2hRKLaCc2XeZZHIMu7Tynkq/1AHY8AaB/yhhSHYyoESaWoWjP61KJhu0E5
         iSVz1C8uWbkAzWARfvZhlNcnoN5bps69UxZ3TinTZdK+AnMdV/IjmY2zfHnPKBxzBhAT
         W+KX1vZ7UZelKJjKx2T50rqhJLNb22y/tUclJgCl1FTQV/9cwF3bV9DsRS/0BD0WmKxg
         4oyBx3icBBgCgRiALMLx6aP2bA9d286oyYQw2vcSvzRVYJhnyB2dX840yqjIpLX99B5j
         hktpjrMTgPpdn+SRPge6rRyHnyPS8stpSMH1XYS/y5FpWPLwX6EMMvydproigqdwF29c
         FJVQ==
X-Gm-Message-State: AOAM532KTVM0NmqdA88/dd7nZuCWHIPQa4eSVgrv4G7bElZMgU50tNme
        WkFY+V4yM7ewIUDZsTLxQisWFnoHYpxrX8SwOUYSJqyNae4CWQ==
X-Google-Smtp-Source: ABdhPJyrjarU56zOUEvZsiIm9neb6Hany7tW354ZNhxwR29RwQ4F3g1egEQTxXrFU7xyrNDCRxBMecl338qIGSmLPns=
X-Received: by 2002:a37:5f87:0:b0:69c:4dff:ba77 with SMTP id
 t129-20020a375f87000000b0069c4dffba77mr14644558qkb.80.1650517689516; Wed, 20
 Apr 2022 22:08:09 -0700 (PDT)
MIME-Version: 1.0
From:   Atul Khare <atulkhare@rivosinc.com>
Date:   Wed, 20 Apr 2022 22:07:59 -0700
Message-ID: <CABMhjYrvyrXNJrLaAS0RU7A-_LZhK50WvQsE2RdY=CQ0C_Xicw@mail.gmail.com>
Subject: [PATCH 4/4] dt-bindings: sifive: add gpio-line-names
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixes device tree schema validation messages like 'gpio-line-names'
does not match any of the regexes: 'pinctrl-[0-9]+' From schema: ...
sifive,gpio.yaml'.

The bindings were missing the gpio-line-names element, which was
causing the dt-schema checker to trip-up.

Fixes: a2770b57d083 ("dt-bindings: timer: Add CLINT bindings")
Cc: stable@vger.kernel.org
Signed-off-by: Atul Khare <atulkhare@rivosinc.com>
---
 Documentation/devicetree/bindings/gpio/sifive,gpio.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/gpio/sifive,gpio.yaml
b/Documentation/devicetree/bindings/gpio/sifive,gpio.yaml
index 427c5873f96a..0bdd39b7b3d5 100644
--- a/Documentation/devicetree/bindings/gpio/sifive,gpio.yaml
+++ b/Documentation/devicetree/bindings/gpio/sifive,gpio.yaml
@@ -47,6 +47,9 @@ properties:
     default: 16

   gpio-controller: true
+  gpio-line-names:
+    minItems: 1
+    maxItems: 32

 required:
   - compatible
--
2.35.1
