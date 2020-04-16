Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8BB1AC411
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896697AbgDPNxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896687AbgDPNxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:53:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B8F20732;
        Thu, 16 Apr 2020 13:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045229;
        bh=u8YqO5KRkDMJkvpaDUQlB5lQevXHKx6UCjjbjXQemGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qv35FRkxxGn1z72R1zSfwsElNmUakQnv3M3tWHyINqYND/XsVJkfSVoMrMKWh1Zwa
         jRgJQ18LipOwyH575+H2jVeRGlWy6vJwEZdHTbstPQl7uVdkWi8PMS1//EYJ5/mdLm
         hzZoOgXfMBG6iL6Xz2v3WmYzHN0IDAMf8rkRHBio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mohammad Rasim <mohammad.rasim96@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 012/254] media: arm64: dts: amlogic: add rc-videostrong-kii-pro keymap
Date:   Thu, 16 Apr 2020 15:21:41 +0200
Message-Id: <20200416131327.336439075@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohammad Rasim <mohammad.rasim96@gmail.com>

[ Upstream commit 806d06161af045dba29f3c7747550c93b2ea3ca9 ]

videostrong kii pro comes with a nec rc, add the keymap to the dts

Signed-off-by: Mohammad Rasim <mohammad.rasim96@gmail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
index 2f1f829450a29..6c9cc45fb417e 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
@@ -76,3 +76,7 @@
 		};
 	};
 };
+
+&ir {
+	linux,rc-map-name = "rc-videostrong-kii-pro";
+};
-- 
2.20.1



