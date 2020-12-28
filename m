Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C573B2E6685
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732954AbgL1NTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:19:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732945AbgL1NTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:19:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 371F720719;
        Mon, 28 Dec 2020 13:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161572;
        bh=01CuJutkxOy3ZqWuAqW3OSdWhKEKPW/78boO5v1tpcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICV9fS3ljnc6iHwpqk6sIwv/WmvQru7pIuG7e9407wIO4JdacMNktNtSx+al9qmuO
         RIsiRYqKqsMG71cP5kEHC9Wjk9DuqqzHO44EUiW8qFREN6YWxY51MTC2B3BUiQo0Kv
         hgfHcuypcX1024dgHYg4cUV3lquS99EUg8K6bFkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Verevkin <me@maxverevkin.tk>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 016/346] platform/x86: intel-vbtn: Support for tablet mode on HP Pavilion 13 x360 PC
Date:   Mon, 28 Dec 2020 13:45:35 +0100
Message-Id: <20201228124920.554741187@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Verevkin <me@maxverevkin.tk>

[ Upstream commit 8b205d3e1bf52ab31cdd5c55f87c87a227793d84 ]

The Pavilion 13 x360 PC has a chassis-type which does not indicate it is
a convertible, while it is actually a convertible. Add it to the
dmi_switches_allow_list.

Signed-off-by: Max Verevkin <me@maxverevkin.tk>
Link: https://lore.kernel.org/r/20201124131652.11165-1-me@maxverevkin.tk
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index 1e6b4661c7645..3aba207ee1745 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -197,6 +197,12 @@ static const struct dmi_system_id dmi_switches_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Stream x360 Convertible PC 11"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion 13 x360 PC"),
+		},
+	},
 	{} /* Array terminator */
 };
 
-- 
2.27.0



