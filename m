Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D723FD9419
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 16:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405540AbfJPOkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 10:40:14 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:44617 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405214AbfJPOkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 10:40:13 -0400
Received: by mail-il1-f194.google.com with SMTP id f13so2847133ils.11;
        Wed, 16 Oct 2019 07:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=F4KpRCphtdIQOih7zA7wyNTEii8fpVd38VbpBCCqits=;
        b=KNl4Wp0os/zfSE3mGGHwH9H7k7l1az689glcED+KLLYDXtO/JI84rorQIkEFCNvBM1
         BZn2wtF3XK/9iypI7FJfCUBSop+/2Fe6+lclKR6EQsOKUscTMEjxo61WmTLOuOgAI2s1
         vNs+hfaV+fe2b0ZmHMSkUu3dfEnv/cctrdyAqBuAZvh6k7YLCaX36KvmgL1oM7IMgOWv
         8Wi9QrnN3/FX8+rEcbBvg9rWyQZfZ6/yZNGWU8VTE88r2V3Wg8qPtqvT6/Z1jp5R8OOe
         Uj1NIR3YG1fNvMmMw8ZjMWJjKN73M4mNuqW51ejK83aBHFPfH64Jpz11y/+/ho6rSvxH
         3qzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=F4KpRCphtdIQOih7zA7wyNTEii8fpVd38VbpBCCqits=;
        b=WJBzX2kJhopeqDj7uJuIUNZnLxlecLbnISdK3EmaqRZtDncHfGE7Aej901ZqROipLX
         g7lQom0u5XiFE8qdrd+1CCPOmAQhJR7Xoe5uKuUVTvgqL6JmVIldDL+AtK0d1U6lXBu7
         aOw15PCuIZFm7UhtU/ZCARycEW+mAIcI8bXilldW0tLuFub2Z3uK7cd0NcND1U4B41tk
         my9lx5z6ymikjvLxwmltmS+EjK+t61q0AcBXo/H1cWgweml3OjpFXVqE6fFmR50LxyIF
         jvA8VeC5nJ/Y10keWToUYtqW9r8Q7QsnZaOqXjlEU8f3Vap6G0qPAqgl93tVY4HpPqM/
         Vz8A==
X-Gm-Message-State: APjAAAUOn2L8sUJOCqnRBpfWYHGFNHhECT2Q9Q/5ANgy33FrmzBQG3+C
        yTGs4LUGT4y+nl2vqRIGduI=
X-Google-Smtp-Source: APXvYqzVFOp47e5GYuEKGNzZtGyGxBnqHwcB6U9SdRarISkIvacLzPBtNUL4zKSI4DDp1UtHN9TuEg==
X-Received: by 2002:a92:b314:: with SMTP id p20mr12316552ilh.80.1571236812822;
        Wed, 16 Oct 2019 07:40:12 -0700 (PDT)
Received: from localhost.localdomain (c-73-37-219-234.hsd1.mn.comcast.net. [73.37.219.234])
        by smtp.gmail.com with ESMTPSA id d197sm19160630iog.15.2019.10.16.07.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 07:40:12 -0700 (PDT)
From:   Adam Ford <aford173@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     adam.ford@logicpd.com, Adam Ford <aford173@gmail.com>,
        stable <stable@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Anson Huang <Anson.Huang@nxp.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: imx6-logicpd: Re-enable SNVS power key
Date:   Wed, 16 Oct 2019 09:40:05 -0500
Message-Id: <20191016144005.9863-1-aford173@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The baseboard of the Logic PD i.MX6 development kit has a power
button routed which can both power down and power up the board.
It can also wake the board from sleep.  This functionality was
marked as disabled by default in imx6qdl.dtsi, so it needs to
be explicitly enabled for each board.

This patch enables the snvs power key again.
Fixes: 770856f0da5d ("ARM: dts: imx6qdl: Enable SNVS power key according to board design")

Cc: stable <stable@vger.kernel.org> #5.3+
Signed-off-by: Adam Ford <aford173@gmail.com>

diff --git a/arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi b/arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi
index 2a6ce87071f9..9e027b9a5f91 100644
--- a/arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi
+++ b/arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi
@@ -328,6 +328,10 @@
 	pinctrl-0 = <&pinctrl_pwm3>;
 };
 
+&snvs_pwrkey {
+	status = "okay";
+};
+
 &ssi2 {
 	status = "okay";
 };
-- 
2.17.1

