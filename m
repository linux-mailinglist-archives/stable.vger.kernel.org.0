Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9FD15C5BA
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgBMPYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:24:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728169AbgBMPYS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:18 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 887BE24689;
        Thu, 13 Feb 2020 15:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607457;
        bh=5KjvOeU3AJ371qRJ3YPmkoYGnPuk16Ox6a8TyrjY40I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXmVZe9Ndhvl0Hnuhf0gvDWQP7AQshEFVQjxvDXZJJYuqtolnsAxrno55/zLINQqg
         xARDDjO3WbfmhAMVvFWZSXHav4KpG5bGMMaCQr3XZ57eEVHSGgviFw4sEZVz6RsiTK
         6qo2fNjoY4OZvlg6s3j9GPySzASU7EU9OHBPEK5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Brodkin <abrodkin@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 4.9 105/116] ARC: [plat-axs10x]: Add missing multicast filter number to GMAC node
Date:   Thu, 13 Feb 2020 07:20:49 -0800
Message-Id: <20200213151923.113905013@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

commit 7980dff398f86a618f502378fa27cf7e77449afa upstream.

Add a missing property to GMAC node so that multicast filtering works
correctly.

Fixes: 556cc1c5f528 ("ARC: [axs101] Add support for AXS101 SDP (software development platform)")
Acked-by: Alexey Brodkin <abrodkin@synopsys.com>
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/boot/dts/axs10x_mb.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arc/boot/dts/axs10x_mb.dtsi
+++ b/arch/arc/boot/dts/axs10x_mb.dtsi
@@ -63,6 +63,7 @@
 			interrupt-names = "macirq";
 			phy-mode = "rgmii";
 			snps,pbl = < 32 >;
+			snps,multicast-filter-bins = <256>;
 			clocks = <&apbclk>;
 			clock-names = "stmmaceth";
 			max-speed = <100>;


