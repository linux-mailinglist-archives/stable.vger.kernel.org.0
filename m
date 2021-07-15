Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5D83CA798
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241229AbhGOSzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240521AbhGOSxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:53:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41C13613E9;
        Thu, 15 Jul 2021 18:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375050;
        bh=GxypP4UT325zqr4kTvvAIepMI0OmMlma2dxIYZxwOw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nq/5np+ojXDRvpq5AAxpwNXkFHIkOfSyyH3FzRtA/AjOMdEapkxWLfO4RpLO7vi6d
         3CYM8guwaF0ypXyE0VwfWehggjAolG8XEM0DJNYh4iiii+X+Jy2RQCmTSNXJnjE/I/
         uEej0MxTZrslG/cqwsT2tYYXfQf+TIKsWUcclApo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cameron Nemo <cnemo@tutanota.com>,
        Chen-Yu Tsai <wens@csie.org>, Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.10 137/215] arm64: dts: rockchip: Enable USB3 for rk3328 Rock64
Date:   Thu, 15 Jul 2021 20:38:29 +0200
Message-Id: <20210715182623.781542019@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cameron Nemo <cnemo@tutanota.com>

commit bbac8bd65f5402281cb7b0452c1c5f367387b459 upstream.

Enable USB3 nodes for the rk3328-based PINE Rock64 board.

The separate power regulator is not added as it is controlled by the
same GPIO line as the existing VBUS regulators, so it is already
enabled. Also there is no port representation to tie the regulator to.

[wens@csie.org: Rebased onto v5.12]

Signed-off-by: Cameron Nemo <cnemo@tutanota.com>
[wens@csie.org: Rewrote commit message]
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20210504083616.9654-2-wens@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts
@@ -384,6 +384,11 @@
 	status = "okay";
 };
 
+&usbdrd3 {
+	dr_mode = "host";
+	status = "okay";
+};
+
 &usb_host0_ehci {
 	status = "okay";
 };


