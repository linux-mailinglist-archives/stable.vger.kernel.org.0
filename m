Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74849382E77
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhEQOHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237936AbhEQOGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:06:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB04361209;
        Mon, 17 May 2021 14:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260324;
        bh=WgTBwrlkJRbeWVb7/SDGGBKcDxPi78oqpw8o2AatUP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q73yaAQ4JZC4nL7pPpUxw4WP/FIeDPLBe27k1lgakKo5QsyvQz9U/GMpPE3jcHhv4
         yAE9bfbmwIgzxast2b+piX1gCoFSn5X5jvfpqnSmWh3EKJLxmNt8Sr09AWbgnlfq0g
         O6zhSLI6CA9QvBg+fKFk2xXHcrOn8N7tHjJhuHd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.12 008/363] ACPI: PM: Add ACPI ID of Alder Lake Fan
Date:   Mon, 17 May 2021 15:57:54 +0200
Message-Id: <20210517140302.809804836@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>

commit 2404b8747019184002823dba7d2f0ecf89d802b7 upstream.

Add a new unique fan ACPI device ID for Alder Lake to
support it in acpi_dev_pm_attach() function.

Fixes: 38748bcb940e ("ACPI: DPTF: Support Alder Lake")
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/device_pm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -1310,6 +1310,7 @@ int acpi_dev_pm_attach(struct device *de
 		{"PNP0C0B", }, /* Generic ACPI fan */
 		{"INT3404", }, /* Fan */
 		{"INTC1044", }, /* Fan for Tiger Lake generation */
+		{"INTC1048", }, /* Fan for Alder Lake generation */
 		{}
 	};
 	struct acpi_device *adev = ACPI_COMPANION(dev);


