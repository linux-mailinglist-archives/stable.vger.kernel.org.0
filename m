Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16643103CE
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 04:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhBEDmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 22:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbhBEDmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 22:42:14 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF55C06178B
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 19:41:34 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id g15so3046298pjd.2
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 19:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=subject:date:message-id:mime-version:content-transfer-encoding:cc
         :from:to;
        bh=XPv9UeIW/g8j3YWUDvgidB0ONJf39fc9JGHRKHAQFsI=;
        b=iykkDVX0eGoZLo0iHPHBquvrEjcIwuw4z58EatThFQ/Wc2cbRMJ0aoVI7TjMLN+Z5b
         f+bcNS2iy+6udLYDGEC7QA9eGNBPINa03G4i+AYntOIqtCC0cQ8BlKswTp3xDbDzF4/4
         zHD2GTsNcLdXK7qtOf26oUdNKO+EVxKAk0emzwhYDxkPuKjvXWB0oNOam0r7bYSnhW9B
         rrZuc0hutI3ua7ebPaDKOcHuajsK6J4DkJI3xUtzYdmLu4U0XxcJgQ3+GE/nirApLs66
         YbW3qvxsENnQZI0KPouHX4zLqyypK7zfuueprKwMndBdvIbYBE/+R9d+ZQGL7awAB6MW
         vLVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=XPv9UeIW/g8j3YWUDvgidB0ONJf39fc9JGHRKHAQFsI=;
        b=kawUWI7OS0ehDc+QB153kTDJbM+kwBIq/9xWNHylDX2sFSq6Vs3zo0a2dJE+QMo5sN
         JaHb3+jjDbYSYfeFfyRu8E1O0jM9n9wj1W8v22uuUusK6p8SLtBSovsb0WtlONObShrc
         PNKidMoXd42F9frGpbC4ErSc6KPOCHfvHOFOkiaJYLh74oN8vM2zV/uZSH/ppFsAaRpu
         1vDd+WNlm5rlrYmN3d0/cr/U+jxAs6YSP4ZxeY2hfiA2zytcac0I6Q38bFzmIof6PuYZ
         b8p9o4c30DKf0b18evK2Bz1Ure4fuje6VqJmiKliO/+MDrIRSc9HbV3kRhM36uV6fZLV
         P/1A==
X-Gm-Message-State: AOAM530T899TzREfbwuF+aTeSi4H99aFhyvRoNNcECygEQi6RUMMs4Iu
        g8KS3Ix+Hykjq0sOYoI3aSNzBw==
X-Google-Smtp-Source: ABdhPJy+UOfuYzHdNONaTTFWTJ7JSrVIFoLGj2lZsAUeJZVG2hyvWNwFRlRea/rNcWgF5zE1BPX0SQ==
X-Received: by 2002:a17:90b:2312:: with SMTP id mt18mr2277495pjb.81.1612496494017;
        Thu, 04 Feb 2021 19:41:34 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id w4sm7235138pfi.191.2021.02.04.19.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 19:41:33 -0800 (PST)
Subject: [PATCH] Revert "dts: phy: add GPIO number and active state used for phy reset"
Date:   Thu,  4 Feb 2021 19:41:12 -0800
Message-Id: <20210205034112.2147142-1-palmer@dabbelt.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     robh+dt@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, sagar.kadam@sifive.com, anup@brainfault.org,
        yash.shah@sifive.com, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Palmer Dabbelt <palmerdabbelt@google.com>,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     schwab@linux-m68k.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmerdabbelt@google.com>

VSC8541 phys need a special reset sequence, which the driver doesn't
currentlny support.  As a result enabling the reset via GPIO essentially
guarnteees that the device won't work correctly.

This reverts commit a0fa9d727043da2238432471e85de0bdb8a8df65.

Fixes: a0fa9d727043 ("dts: phy: add GPIO number and active state used for phy reset")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
---
 arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
index 24d75a146e02..60846e88ae4b 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
@@ -90,7 +90,6 @@ &eth0 {
 	phy0: ethernet-phy@0 {
 		compatible = "ethernet-phy-id0007.0771";
 		reg = <0>;
-		reset-gpios = <&gpio 12 GPIO_ACTIVE_LOW>;
 	};
 };
 
-- 
2.30.0.478.g8a0d178c01-goog

