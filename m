Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99884D5F82
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 11:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731239AbfJNJ7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 05:59:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3747 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731175AbfJNJ7y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 05:59:54 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0192D268441561013F85;
        Mon, 14 Oct 2019 17:59:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 14 Oct 2019 17:59:42 +0800
From:   John Garry <john.garry@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <catalin.marinas@arm.com>, <will@kernel.org>, <rjw@rjwysocki.net>,
        <lenb@kernel.org>, <robert.moore@intel.com>,
        <erik.schmauss@intel.com>, <sudeep.holla@arm.com>,
        <rrichter@marvell.com>, <jeremy.linton@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linuxarm@huawei.com>, <gregkh@linuxfoundation.org>,
        <guohanjun@huawei.com>, <wanghuiqiang@huawei.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH for-stable-4.19 1/3] ACPICA: ACPI 6.3: PPTT add additional fields in Processor Structure Flags
Date:   Mon, 14 Oct 2019 17:56:24 +0800
Message-ID: <1571046986-231263-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571046986-231263-1-git-send-email-john.garry@huawei.com>
References: <1571046986-231263-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Schmauss <erik.schmauss@intel.com>

Commit b5eab512e7cffb2bb37c4b342b5594e9e75fd486 upstream.

ACPICA commit c736ea34add19a3a07e0e398711847cd6b95affd

Link: https://github.com/acpica/acpica/commit/c736ea34
Signed-off-by: Erik Schmauss <erik.schmauss@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 include/acpi/actbl2.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index c50ef7e6b942..1d4ef0621174 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -1472,8 +1472,11 @@ struct acpi_pptt_processor {
 
 /* Flags */
 
-#define ACPI_PPTT_PHYSICAL_PACKAGE          (1)	/* Physical package */
-#define ACPI_PPTT_ACPI_PROCESSOR_ID_VALID   (2)	/* ACPI Processor ID valid */
+#define ACPI_PPTT_PHYSICAL_PACKAGE          (1)
+#define ACPI_PPTT_ACPI_PROCESSOR_ID_VALID   (1<<1)
+#define ACPI_PPTT_ACPI_PROCESSOR_IS_THREAD  (1<<2)	/* ACPI 6.3 */
+#define ACPI_PPTT_ACPI_LEAF_NODE            (1<<3)	/* ACPI 6.3 */
+#define ACPI_PPTT_ACPI_IDENTICAL            (1<<4)	/* ACPI 6.3 */
 
 /* 1: Cache Type Structure */
 
-- 
2.17.1

