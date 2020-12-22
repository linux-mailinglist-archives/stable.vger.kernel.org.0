Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6C42E0CFD
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 17:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgLVQB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 11:01:26 -0500
Received: from mout.web.de ([212.227.17.12]:46535 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbgLVQB0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 11:01:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1608652762;
        bh=QrbUl+8o1v4JAKjJmCXghHju1SqM8R1qqFdskEoSBIQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=ZSuypYwZBEMe4zlm6yLjSAJXCEoAwcNlLLMbv2/E7oH5Fi6NAU2WMBgs+EG+OqYs/
         jXS56btpScWjE42rV7vcV4tpzunucLbcJZRwjGs9CrUq0DVCxlvkzDNNdYK8yB1e8B
         oKMwT8xt66C+QpuJZS+79Nx5wiXC5L2ZPJRbGmaQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from platinum.fritz.box ([77.11.15.76]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MgwZQ-1keate1uIS-00M2Ar; Tue, 22
 Dec 2020 16:59:22 +0100
From:   Soeren Moch <smoch@web.de>
To:     Shawn Guo <shawnguo@kernel.org>
Cc:     Soeren Moch <smoch@web.de>, stable@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: dts: tbs2910: rename MMC node aliases
Date:   Tue, 22 Dec 2020 16:59:08 +0100
Message-Id: <20201222155908.48600-1-smoch@web.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FVblaNpwjDCfwkVmf2G/7IebB7EwmFPZNLpGiBThuFqqhQmAXCD
 sPsPl8li7thEf57P6Q03bOUEceh/qfxVIZsaFMSA97vNJhqhGF5L4vApsG6Fyq+TEFIH295
 nef/pDO8w/pI4cB9N3LlfEWLZkNeTJD1i5KKh8thmdS1qJzQgDniqmrCC5FyCLmh5zIWiT1
 29a/IGEX3NNxrWbKKvJuA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xVc9fShvYqc=:UA8GVkEb5rDfCRxmoL6uzm
 3NJNdSlGx/3KrxkhDDkuM/8qz10QW54ax+OvBXL4Zho1V9/J0dD6KfoD29Bxd0c2MTMOo1nqk
 h5hHdJvmROznKVhzM6b4LUOvAlg2zfZ+dAv9xOr4Cl2a8L+8LBPpzVowSWvDTlOtyj6RWkLzH
 k4DjXM5+cbPUJrzIi8OwgvbJA7bJhl7IEZso7x0KhTxK77Xadw+dlV9al0Dn9H6m5MTNickdg
 wjf0WQLVyTZnNc2TijeEtd3xNyXlu2/nTE9QJAdy2saLQ7oAud0yqfYalLwmR0nBqBr5o7DV7
 wyUQcTWMeIdavSUOfebJoFcjA3NwbmfsexGm6tHyjujjz0h8Nf9O3hHRYkmgDQ2wxLx/8tqdg
 4Evok7958RcINvUC+GKTJvpMNha/WnVMS2X3aKwwLYA/PGoQ258koWK1+RbiNZKhv8Kx1rb7f
 X0gfk2Vvy75IAMUvduXsox/hs7VZb7Qbm4z+6UvluwRI+gew66/7evXx7vRpf7HLvtFm/fA4A
 3MH+DRw+ahS33KJncZgkmmstXXXFo1IvBZEJtDPNlevrwOum4BNEbUrod0YqtloHA54i6Qx45
 jEtE6Mchi1LnHRKaabPdh2gG6Wj5gS5qVd5aqw+0n1Z+I9N8Sqrwa5Ppw7bzqIw3TIpURGfgF
 F8a11jAwa9cgnx3b1ufe+Gtk5OQK/UONpQ2JUXsqroQyvD8Xn6/gc49yxfT9AM6arvbeS5gF5
 uflCqpF2lXwiN6eyZIQSQCUPTrh5JEPqypiuvyflmxx6/FU/PwgdqKseMg1DsvOoHMbpdNiz3
 He/vsD8oGEpZ0wQCJkSut+ITgWn8FUcGImCU4xY0isCX1XZu1XeBu575NUF0kOa9kfsNANDak
 kJazq6tV25auvr7qIwSw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

to be consistent with kernel versions up to v5.9 (mmc aliases not used her=
e).
usdhc1 is not wired up on this board and therefore cannot be used.
Start mmc aliases with usdhc2.

Signed-off-by: Soeren Moch <smoch@web.de>
Cc: stable@vger.kernel.org                # 5.10.x
=2D--
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
=2D--
 arch/arm/boot/dts/imx6q-tbs2910.dts | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q-tbs2910.dts b/arch/arm/boot/dts/imx6q=
-tbs2910.dts
index cb591233035b..6a6e27b35e34 100644
=2D-- a/arch/arm/boot/dts/imx6q-tbs2910.dts
+++ b/arch/arm/boot/dts/imx6q-tbs2910.dts
@@ -16,6 +16,13 @@ chosen {
 		stdout-path =3D &uart1;
 	};

+	aliases {
+		mmc0 =3D &usdhc2;
+		mmc1 =3D &usdhc3;
+		mmc2 =3D &usdhc4;
+		/delete-property/ mmc3;
+	};
+
 	memory@10000000 {
 		device_type =3D "memory";
 		reg =3D <0x10000000 0x80000000>;
=2D-
2.25.1

