Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF7C20DFD0
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388077AbgF2UkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732181AbgF2UkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 16:40:00 -0400
Received: from localhost.localdomain (cpe-70-114-128-244.austin.res.rr.com [70.114.128.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07D2520672;
        Mon, 29 Jun 2020 20:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593463200;
        bh=Lr3CMgYgCXLYecKvct+/e3fDTyPBFo0Z6hWoiAqABpA=;
        h=From:To:Cc:Subject:Date:From;
        b=VGF3FL2C5fFMkpWpUvlLxMtnbfuOeK808qCNy7NpAs7kePs0qJZM0bF0wR8rCsOlU
         8xo8V9C6JOT/F/YSTq4vDqsuxi0hzqxOAl9LVN+sCN9u/syCSXwwmSYcAPm2ekVNT/
         AKDLiVUyBgJfqgKjXZZVyG61eI1zwIGQ7ZD9aLRU=
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     dinguyen@kernel.org, devicetree@vger.kernel.org,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH 1/3] arm64: dts: agilex: add status to qspi dts node
Date:   Mon, 29 Jun 2020 15:39:47 -0500
Message-Id: <20200629203949.6601-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add status = "okay" to QSPI node.

Fixes: c4c8757b2d895 ("arm64: dts: agilex: add QSPI support for Intel
Agilex")
Cc: linux-stable <stable@vger.kernel.org> # >= v5.5
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts b/arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts
index 51d948323bfd..92f478def723 100644
--- a/arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts
@@ -98,6 +98,7 @@
 };
 
 &qspi {
+	status = "okay";
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
2.17.1

