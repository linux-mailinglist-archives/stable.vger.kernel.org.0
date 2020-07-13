Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3796B21D853
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 16:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgGMOXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 10:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbgGMOXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 10:23:46 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C4EC061755
        for <stable@vger.kernel.org>; Mon, 13 Jul 2020 07:23:46 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id k18so12305101qke.4
        for <stable@vger.kernel.org>; Mon, 13 Jul 2020 07:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2m/8HYiqY+j6n4bwAOuGgZqFgd6UjUhRDhQzACjX64M=;
        b=HieJ7uk+pUYuegPhwBg7z9n4yAE6iMjSzuY1YpJeYvHewZmOFJZSusvAfh84MqlyCh
         k6gLMU0ZY3EYT843hc0k3+IYGmKKghlf51FlwHD6ZcKgQmlMhS5S9uXmRscUP4qDEVGX
         WJNJ7Sz0+xExMCzUP1pbQX1qlOcRdZbEjRD9j75AMWXU2LCpGVQ6kgDn44KnQ4vNveX5
         +t8D4lzj+RIS6tkfWVXswJM2+hlqFJbtNqYqRM32eMwO79RPk2thNGlGZeM5vKhOBoEs
         um12pLqI6XyQpjYWxm4jtYWwzuktkg9mTHId+AIJALPFfw2CPUcWkBydbrsg39N3Yq+R
         4V7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2m/8HYiqY+j6n4bwAOuGgZqFgd6UjUhRDhQzACjX64M=;
        b=ovwPPBjUOhSBTnBT7y9yI/i4PcyPFrjBQd8pmhW5bgzVYKeIItXmq2ufQzKTpiD2ek
         aX8R4/QRFm8HbLgBYuE2OBpg05LBqeBXE51RToXAo7vqnqb4P08k+WX1QoKfjAVbvdQK
         ivbbD3svlA/GMVi8+dFjjYWxfX0MVd8IC1A0PolWsYYNbpHDq94ljXCNSELwy334Gjq5
         8+Q9vtnXoTxAcgBjbd3i1dIjX4Et3GvzR0aHqkMRf6+uxlKcBQOea/tgG7nVvkTKGfu6
         3pJa02Z3EHMMZGGj+TQKmCGYZBGIjMAq9fCVH5Tup87SdRu4NJwT/XgX1zjhKHdzmW5T
         q2jw==
X-Gm-Message-State: AOAM531kKoJO6zh4LyhSR0f3fY1oOM04c6fuMbptkcsCcwp1ItKO0Tyu
        pi69v+01HWGQRNqcW4Zcm0qknk0fn7g=
X-Google-Smtp-Source: ABdhPJzJyMauAt4a2r63S3nF1N8BuKwdpZp5S9GaI/Z5EpXkGjibu1twXKg6vX0nE4TsI3avc7pgig==
X-Received: by 2002:ae9:e8c5:: with SMTP id a188mr83342204qkg.222.1594650225595;
        Mon, 13 Jul 2020 07:23:45 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:482:92b:9d6d:2996:7c26:fb1d])
        by smtp.gmail.com with ESMTPSA id t48sm19896841qtb.50.2020.07.13.07.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 07:23:44 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     shawnguo@kernel.org
Cc:     linux-imx@nxp.com, linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] ARM: dts: imx6sx-sabreauto: Fix the phy-mode on fec2
Date:   Mon, 13 Jul 2020 11:23:25 -0300
Message-Id: <20200713142325.24601-2-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713142325.24601-1-festevam@gmail.com>
References: <20200713142325.24601-1-festevam@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 0672d22a1924 ("ARM: dts: imx: Fix the AR803X phy-mode") fixed the
phy-mode for fec1, but missed to fix it for the fec2 node.

Fix fec2 to also use "rgmii-id" as the phy-mode.

Cc: <stable@vger.kernel.org> 
Fixes: 0672d22a1924 ("ARM: dts: imx: Fix the AR803X phy-mode")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 arch/arm/boot/dts/imx6sx-sabreauto.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6sx-sabreauto.dts b/arch/arm/boot/dts/imx6sx-sabreauto.dts
index 825924448ab4..14fd1de52a68 100644
--- a/arch/arm/boot/dts/imx6sx-sabreauto.dts
+++ b/arch/arm/boot/dts/imx6sx-sabreauto.dts
@@ -99,7 +99,7 @@
 &fec2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet2>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&ethphy0>;
 	fsl,magic-packet;
 	status = "okay";
-- 
2.17.1

