Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAD11AC434
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgDPNzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441747AbgDPNzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:55:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1264120732;
        Thu, 16 Apr 2020 13:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045344;
        bh=KU2FR0I+xliMtcNvmrcH8n2pqjet0iy99xhppOQoRJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRoPATc+/BXdpkEBSQj1lBuvbYeREKYtj6wIo0OoCVaxMFpGfYX1LO2tNCIWvHAMX
         ycxGJirUuhJpfJuk0gLgvgwhdeSub+ZHSJmLTvI3q1bmw7igeTg+fz34EIo5q90Auj
         3eBLJXIMjEuRd+1iZB66oukz/aaeSQPDYvs3AGuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.6 094/254] thermal: int340x_thermal: fix: Update Tiger Lake ACPI device IDs
Date:   Thu, 16 Apr 2020 15:23:03 +0200
Message-Id: <20200416131337.728284469@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gayatri Kammela <gayatri.kammela@intel.com>

commit 26d8bec1e97ba218b7d82afadca1c049eb75f773 upstream.

Tiger Lake's new unique ACPI device IDs for Intel thermal driver are not
valid because of missing 'C' in the IDs. Fix the IDs by updating them.

After the update, the new IDs should now look like
INT1040 --> INTC1040
INT1043 --> INTC1043

Fixes: 9b1b5535dfc9 ("thermal: int340x_thermal: Add Tiger Lake ACPI device IDs")
Cc: 5.6+ <stable@vger.kernel.org> # 5.6+
Suggested-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c |    2 +-
 drivers/thermal/intel/int340x_thermal/int3403_thermal.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -369,8 +369,8 @@ static int int3400_thermal_remove(struct
 }
 
 static const struct acpi_device_id int3400_thermal_match[] = {
-	{"INT1040", 0},
 	{"INT3400", 0},
+	{"INTC1040", 0},
 	{}
 };
 
--- a/drivers/thermal/intel/int340x_thermal/int3403_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3403_thermal.c
@@ -282,8 +282,8 @@ static int int3403_remove(struct platfor
 }
 
 static const struct acpi_device_id int3403_device_ids[] = {
-	{"INT1043", 0},
 	{"INT3403", 0},
+	{"INTC1043", 0},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, int3403_device_ids);


