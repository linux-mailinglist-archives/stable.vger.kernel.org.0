Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA811FA3A2
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 00:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgFOWkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 18:40:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56560 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgFOWkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 18:40:06 -0400
Received: from 2.general.alexhung.us.vpn ([10.172.65.255] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <alex.hung@canonical.com>)
        id 1jkxlo-0005Af-J9; Mon, 15 Jun 2020 22:40:01 +0000
From:   Alex Hung <alex.hung@canonical.com>
To:     rui.zhang@intel.com, daniel.lezcano@linaro.org,
        amit.kucheria@verdurent.com, rafael.j.wysocki@intel.com,
        gayatri.kammela@intel.com, srinivas.pandruvada@intel.com,
        gupt21@gmail.com, linux-pm@vger.kernel.org, alex.hung@canonical.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] thermal: int3403_thermal: Downgrade error message
Date:   Mon, 15 Jun 2020 16:39:57 -0600
Message-Id: <20200615223957.183153-1-alex.hung@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Downgrade "Unsupported event" message from dev_err to dev_dbg to avoid
flooding with this message one some platforms.

Cc: stable@vger.kernel.org # v5.4+
Suggested-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Alex Hung <alex.hung@canonical.com>
---
 drivers/thermal/intel/int340x_thermal/int3403_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3403_thermal.c b/drivers/thermal/intel/int340x_thermal/int3403_thermal.c
index f86cbb1..ec1d58c 100644
--- a/drivers/thermal/intel/int340x_thermal/int3403_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3403_thermal.c
@@ -74,7 +74,7 @@ static void int3403_notify(acpi_handle handle,
 						   THERMAL_TRIP_CHANGED);
 		break;
 	default:
-		dev_err(&priv->pdev->dev, "Unsupported event [0x%x]\n", event);
+		dev_dbg(&priv->pdev->dev, "Unsupported event [0x%x]\n", event);
 		break;
 	}
 }
-- 
2.7.4

