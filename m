Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A13D50964B
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 07:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384217AbiDUFK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 01:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384210AbiDUFKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 01:10:52 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CD4BC8B
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 22:08:04 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id a186so2829671qkc.10
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 22:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Tz+QILDZYX5xPOpf0UZ+QF5BOvu20tKZBZrrIDRuFjQ=;
        b=BXHNhFkmLAsEC4PlNUsI2bSJhxgA+A3L20xuAz6QVqAH6qko40vLEiJywSzyAO6SfS
         ePlXZ/9eLPE24OTnWr8f/8GjA4WRxpeSPIwrUaZ5GVuI3uTHXm7uHRFouS9rUyFOdxtv
         isJiNbl/Hi9NaWRNtJT8RpmjaEub1KPRFa3yzdGiTi/yLvd5ZQOqK/cbRxJW1lB0oUt4
         3HL4p/PPEDK1j0LoszIsrlSwwF6stKf0oDnC4h85Pf5EpXNs99CCIj9sT4fknfecMvGG
         q9S/mnZ9TaGBoVZdfpWksTSuRZsTjxEPoUWbPXJh3KOKIFVFGP9xpK7oERD9A9pT8J2r
         wNeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Tz+QILDZYX5xPOpf0UZ+QF5BOvu20tKZBZrrIDRuFjQ=;
        b=izkDnMOHfj+93WwSY4gEu1MZa1JI+PMZt1DE5DLQiJ/Q/X2Ck5t/xKqU/2bBsxctJ/
         IBxJCiFo3IK4LKFLoHXZDg1NC58GJrTE3WBFjNR4jxJl+6TDxwQrGb0IvhFBXv77+9yG
         /ATMvHJL7qp7SP/vo1Y1ewqKavawGnqFOkCMkLpmOxBmXpfn/cne3qYcTuZDxMOcVQqZ
         GhivORkZSVtsI0sNXeSYvyJUXAHt/tdKKsv11z5y927qHpa/EGyZq/eBxnBvJfP66tMu
         U6jabtmE/krpyuoRC8y4NAN3nMJKFJQ91Q+96X3MMdavsMw2hvW13L1wpH3Zc2spL0kM
         JPlw==
X-Gm-Message-State: AOAM530pall69iunIt2q1D56c9q0rGy4qM2HeOcDx21evX4tc2VUF0Bn
        wPOLYEBVCNFZaLclhJB8JEvBok7cR67CPI9Sbnnj2w==
X-Google-Smtp-Source: ABdhPJwrOBUMNWzGCUHo5zvvofgEJMJFBr7xOBEiAvFW882MkFZkYus8R+byyLm1FUOrZg1yDnxnRePX8DRvP75h8OU=
X-Received: by 2002:a05:620a:4489:b0:69e:e4ce:5916 with SMTP id
 x9-20020a05620a448900b0069ee4ce5916mr2915302qkp.627.1650517683462; Wed, 20
 Apr 2022 22:08:03 -0700 (PDT)
MIME-Version: 1.0
From:   Atul Khare <atulkhare@rivosinc.com>
Date:   Wed, 20 Apr 2022 22:07:52 -0700
Message-ID: <CABMhjYrDuk9EKYxREqrhReYb8oNz0X3hkF4ReDB_jmpkn3AwAA@mail.gmail.com>
Subject: [PATCH 3/4] dt-bindings: sifive: delete 'clock' / 'status'
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

Fixes device tree schema validation error messages like 'clocks
does not match any of the regexes: 'pinctrl-[0-9]+''.

The bindings for the memory element don't define the 'clock' and
'status' fields, and the presence of these elements was causing the
dt-schema checker to trip-up. Our operating assumption is that the
platform doesn't rely on the presence of these elements, and that
they were introduced by a typographical oversight.

Fixes: a2770b57d083 ("dt-bindings: timer: Add CLINT bindings")
Cc: stable@vger.kernel.org
Signed-off-by: Atul Khare <atulkhare@rivosinc.com>
---
 arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
b/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
index cd2fe80fa81a..0a498a0f7eeb 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
@@ -32,15 +32,11 @@ cpus {
        ddrc_cache_lo: memory@80000000 {
                device_type = "memory";
                reg = <0x0 0x80000000 0x0 0x2e000000>;
-               clocks = <&clkcfg CLK_DDRC>;
-               status = "okay";
        };

        ddrc_cache_hi: memory@1000000000 {
                device_type = "memory";
                reg = <0x10 0x0 0x0 0x40000000>;
-               clocks = <&clkcfg CLK_DDRC>;
-               status = "okay";
        };
 };

--
2.35.1
