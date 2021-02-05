Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E7C3114AD
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhBEWL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:11:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:43238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232224AbhBEOlc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:41:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F7FD64FD1;
        Fri,  5 Feb 2021 14:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534163;
        bh=mYeIUU5hW+PP81IzM61r41l1t3USDJGaYIPTzFzxvjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fe2JQevmcw///nXlqgDKWN8sXVDrRofWTCIIJ+ED6oImkB6DZgVFuxBfgXJwewndO
         Di3TOs/WDENScPB8pAxnOMKbEXYu3vEuBS9bTqrD4eMn6xwajyqfYIz6Z7a5KLzaCJ
         xOIJXc0z0tnqGE5t2Gqtk7ST1uZ2IrWWgeUqiINk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH 5.10 12/57] arm64: dts: meson: Describe G12b GPU as coherent
Date:   Fri,  5 Feb 2021 15:06:38 +0100
Message-Id: <20210205140656.505146441@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit 03544505cb10ddc73df3b6176e71cdb366834134 upstream.

According to a downstream commit I found in the Khadas vendor kernel,
the GPU on G12b is wired up for ACE-lite, so (now that Panfrost knows
how to handle this properly) we should describe it as such. Otherwise
the mismatch leads to all manner of fun with mismatched attributes and
inadvertently snooping stale data from caches, which would account for
at least some of the brokenness observed on this platform.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/765446e529e50b304af63432da7836c4d31eb8d4.1600780574.git.robin.murphy@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12b.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/boot/dts/amlogic/meson-g12b.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b.dtsi
@@ -135,3 +135,7 @@
 		};
 	};
 };
+
+&mali {
+	dma-coherent;
+};


