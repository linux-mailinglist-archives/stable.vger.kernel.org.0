Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE52122681A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388559AbgGTQQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388535AbgGTQQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:16:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F98E2064B;
        Mon, 20 Jul 2020 16:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261791;
        bh=1P/lOpBfA6OD5FzelCYjXb9v1tWEcxHKO/CA64aHoI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ktk3HLjHi5WciXVLuQAS0MTC+LrPCvey2E0EB0wdQBKBSgvvjNeaWH51zMOXOpbOm
         hZZ5Ag0zsmCNG7TuLK7ZzLyG38B5AxMmt9Uj6uSepmKaG/ndq18KLYp4JfEZEBrUF0
         aLmUiRLMW0tU/VzLtVA1Uq+oBgZe8va7tNbpHeDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.7 213/244] arm64: dts: agilex: add status to qspi dts node
Date:   Mon, 20 Jul 2020 17:38:04 +0200
Message-Id: <20200720152835.981202493@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit 60176e6be0bb6f629b15aea7dcab5a95ecb158e9 upstream.

Add status = "okay" to QSPI node.

Fixes: c4c8757b2d895 ("arm64: dts: agilex: add QSPI support for Intel Agilex")
Cc: linux-stable <stable@vger.kernel.org> # >= v5.5
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts
@@ -98,6 +98,7 @@
 };
 
 &qspi {
+	status = "okay";
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;


