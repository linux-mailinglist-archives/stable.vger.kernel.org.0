Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C33B28B72A
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389084AbgJLNlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388544AbgJLNlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:41:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC7762074F;
        Mon, 12 Oct 2020 13:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510063;
        bh=jZxM22sAUaaeSSEHpTJko9EDYtz6MsQVHG14mpbVpgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnQP1Wg7WubZoY6vSsnYSKwR3VrR8XUJlL+DZ7KY2MSTFZsHCXWzJx6oiNAxwPRsq
         uMkEnMRDYxM46/N0/a7zLbNpZrk/NhU3pd9jlvbilcYwz9Fgl9gwimriDYQ2SLFYAf
         tAl6c1dmwgfkdXwdbg0jnL4q315wK5Sg8a167t2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 5.4 25/85] arm64: dts: stratix10: add status to qspi dts node
Date:   Mon, 12 Oct 2020 15:26:48 +0200
Message-Id: <20201012132634.065046905@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit 263a0269a59c0b4145829462a107fe7f7327105f upstream.

Add status = "okay" to QSPI node.

Fixes: 0cb140d07fc75 ("arm64: dts: stratix10: Add QSPI support for Stratix10")
Cc: linux-stable <stable@vger.kernel.org> # >= v5.6
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
[iwamatsu: Drop arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
@@ -155,6 +155,7 @@
 };
 
 &qspi {
+	status = "okay";
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;


