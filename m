Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CAB2171FF
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbgGGP1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730352AbgGGP1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:27:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EA34206F6;
        Tue,  7 Jul 2020 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135637;
        bh=HX7ny7ufwMRSPxNDOmu1Yy1YvE1i9WOgK7Q+5Mtpev0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvcHwkg9qUI0t0/NWetIlYcUPe1jU6fk8UWCt7+xetQ88GMMw0hBZ6EO9gnlVzEV6
         lBEQPnnhY7wGTf4PoyUIZ7qlkmxjBqhLcW00XBgIHyPJmpew5m22jazUwL0LbDHLNt
         33Rr8mbaASxOVni06K0sKG49k5f/Kd9F3DZRCnXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.7 097/112] ACPI: fan: Fix Tiger Lake ACPI device ID
Date:   Tue,  7 Jul 2020 17:17:42 +0200
Message-Id: <20200707145805.590910622@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>

commit 0318e8374e87b32def1d5c279013ca7730a74982 upstream.

Tiger Lake's new unique ACPI device ID for Fan is not valid
because of missing 'C' in the ID.  Use correct fan device ID.

Fixes: c248dfe7e0ca ("ACPI: fan: Add Tiger Lake ACPI device ID")
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Cc: 5.6+ <stable@vger.kernel.org> # 5.6+
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/fan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -25,8 +25,8 @@ static int acpi_fan_remove(struct platfo
 
 static const struct acpi_device_id fan_device_ids[] = {
 	{"PNP0C0B", 0},
-	{"INT1044", 0},
 	{"INT3404", 0},
+	{"INTC1044", 0},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, fan_device_ids);


