Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A4324AD91
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 06:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgHTELQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 00:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgHTELP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 00:11:15 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667A6C061757;
        Wed, 19 Aug 2020 21:11:15 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id r11so396541pfl.11;
        Wed, 19 Aug 2020 21:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDJDuKtqbHnC796AeNDtkydt/+nMCLENJLcgWPgKcQA=;
        b=FiPpQdouEXK6VeEe9kXvQd6AlUhoKIUnly9H8vEzYRX6dpw/kifEXBclWcuhASodGk
         5pBBDbsDsUJUdyysZgSEfsEayRBghrrTSoQYGTCL2jmt3Kbx22oErUozmlqRTgQ9LMyQ
         UJwtlr0U9aa9iLYV6Lzpz6LXVdomWWE3i0eK5oEeTefzDVbp2MvqUV/6fMvwOA1YRz1p
         KhtacN0Sq+j1vuOYydpn6dkczCjENlCgZtHnrHHJ/973hRw92EcUTFZUpBHKWAw/JTBy
         O7hszoyEG9Qc9mQtO/qjK/B4uP8xc6XHcueCNF4jitZ+a+eNYpay8Sa+JfOvEh6jDNEe
         c8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDJDuKtqbHnC796AeNDtkydt/+nMCLENJLcgWPgKcQA=;
        b=Akb5mvOblD/aAQp5LgY6cq1BMG4bLR2wTHRxvMgW8bxC3gXZpIroBsLHnfek2pMXVb
         9z9N5wp4ITT6/PcSMO9v4U2pz5tLH9bmzl/LCDEVQCxrV1wNkWGVLZFFUcgGMKWc3LI3
         gxR+4VXf88WZu1rX01z5S+ts3ixaW4gOlxOYt5QJ2s6y9EKYEQPFqNUd6BrnsDCfLDwh
         GITa7K+A6auG74hSZu4O8A+/UnzDZ74DsFDYOKLD896JNDcLJeT3M5zax2I3lhsY8TT/
         FAhN6uhdoCvH9q/qbMxYFd+x2EoWS8ot3LPRporAcd/6YvLkUToY6eWY/N5JqXUUJ/TT
         Uzig==
X-Gm-Message-State: AOAM533vC5tzwe4xadXkEySQWhtZUzwKvVt4F5puaaJv4iiFaYs6AZIO
        mNPSQngE1dWdbeNMVpRLqBg=
X-Google-Smtp-Source: ABdhPJyEObQUFNlfFMiPl9DoKI9qG80cCF2W6A1Y0MZ7u6rMFknZKroy8E3vCjH3dZFgCJS8rRKIGA==
X-Received: by 2002:a62:ea01:: with SMTP id t1mr868193pfh.125.1597896674617;
        Wed, 19 Aug 2020 21:11:14 -0700 (PDT)
Received: from localhost.localdomain.com ([2605:e000:160b:911f:722f:a74:437d:fd3c])
        by smtp.gmail.com with ESMTPSA id b20sm847811pfp.140.2020.08.19.21.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 21:11:13 -0700 (PDT)
From:   Chris Healy <cphealy@gmail.com>
X-Google-Original-From: Chris Healy <cphealy@gmail.com
To:     shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        stefan@agner.ch, robh+dt@kernel.org, andrew.smirnov@gmail.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, festevam@gmail.com,
        stable@vger.kernel.org
Cc:     Chris Healy <cphealy@gmail.com>
Subject: [PATCH v2] ARM: dts: vfxxx: Add syscon compatible with ocotp
Date:   Wed, 19 Aug 2020 21:10:55 -0700
Message-Id: <20200820041055.75848-1-cphealy@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Healy <cphealy@gmail.com>

Add syscon compatibility with Vybrid ocotp node. This is required to
access the UID.

Fixes: fa8d20c8dbb77 ("ARM: dts: vfxxx: Add node corresponding to OCOTP")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Healy <cphealy@gmail.com>
---
Changes in v2:
 - Add Fixes line to commit message

 arch/arm/boot/dts/vfxxx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index 0fe03aa0367f..2259d11af721 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -495,7 +495,7 @@ edma1: dma-controller@40098000 {
 			};
 
 			ocotp: ocotp@400a5000 {
-				compatible = "fsl,vf610-ocotp";
+				compatible = "fsl,vf610-ocotp", "syscon";
 				reg = <0x400a5000 0x1000>;
 				clocks = <&clks VF610_CLK_OCOTP>;
 			};
-- 
2.26.2

