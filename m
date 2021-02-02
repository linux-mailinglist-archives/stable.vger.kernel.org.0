Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FEF30BFE8
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhBBNox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232819AbhBBNmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:42:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5C9264F65;
        Tue,  2 Feb 2021 13:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273194;
        bh=EAE8H98pKJGvPE0adKM33xu/GqgjB9SmSjsr/RX/f34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6Hpr+irp2DIV4yk1c+TJJ5b0PZwKS4Z8I/UjaoTdGsUPEOxvXmN++EhO/GrK9KTV
         /BMMwjva9tugknad0HZPGCSc/+1AJq0Qn2AeSmzmNboFbBOaIL2bN4hoNIbgPXlIkT
         ksE0iVonoMeXj+KvF/5WFuYjWPAuBGVgWQDlXPCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Soeren Moch <smoch@web.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.10 016/142] ARM: dts: tbs2910: rename MMC node aliases
Date:   Tue,  2 Feb 2021 14:36:19 +0100
Message-Id: <20210202132958.377325980@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Soeren Moch <smoch@web.de>

commit fd25c883667b61f845a4188b6be110bb45de0bac upstream.

to be consistent with kernel versions up to v5.9 (mmc aliases not used here).
usdhc1 is not wired up on this board and therefore cannot be used.
Start mmc aliases with usdhc2.

Signed-off-by: Soeren Moch <smoch@web.de>
Cc: stable@vger.kernel.org                # 5.10.x
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6q-tbs2910.dts |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm/boot/dts/imx6q-tbs2910.dts
+++ b/arch/arm/boot/dts/imx6q-tbs2910.dts
@@ -16,6 +16,13 @@
 		stdout-path = &uart1;
 	};
 
+	aliases {
+		mmc0 = &usdhc2;
+		mmc1 = &usdhc3;
+		mmc2 = &usdhc4;
+		/delete-property/ mmc3;
+	};
+
 	memory@10000000 {
 		device_type = "memory";
 		reg = <0x10000000 0x80000000>;


