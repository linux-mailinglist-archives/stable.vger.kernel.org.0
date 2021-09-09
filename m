Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD7240552E
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353646AbhIINIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357667AbhIINDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 121FD63295;
        Thu,  9 Sep 2021 11:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188788;
        bh=gErt1nfR3OMbvWG5FwqnTixBqSZzxb/W0omYUcl7ER4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8TY4nZDoIHUo+qpFo0i3BtHwJFG3pecIrJ0qhjhW5YYJLPNQI8GWN8JXNyBE9+lS
         8BTcaVLEEkcjVxlAZlrPagqktPeGl8qPC8iIxyClnQyZ5Je6bP0fiS8fWBrIWIm5qq
         16mzhY4aN4n5Kb0VR+kp7lwEY9+68n/AFxnII9S2z7fVhnE7lFb4/n6viw0WFR7AJs
         epvWdofNpV4l8/7RdU53JIi6bYFtVG0P73gSmIuxWvVD9ma/hCC2cexNvpGMubJqB8
         Uh6WAJ+z9FrS6TLdamMwfy23jJo60kNwNcVMQ3HIqlzNbbJNX7VVL9TrG/5IXmRRj5
         GR0F41q2Y9ilw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 4.14 38/59] ACPICA: iASL: Fix for WPBT table with no command-line arguments
Date:   Thu,  9 Sep 2021 07:58:39 -0400
Message-Id: <20210909115900.149795-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

[ Upstream commit 87b8ec5846cb81747088d1729acaf55a1155a267 ]

Handle the case where the Command-line Arguments table field
does not exist.

ACPICA commit d6487164497fda170a1b1453c5d58f2be7c873d6

Link: https://github.com/acpica/acpica/commit/d6487164
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/actbl3.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/acpi/actbl3.h b/include/acpi/actbl3.h
index 5bde2e700530..7525ab3fb7ec 100644
--- a/include/acpi/actbl3.h
+++ b/include/acpi/actbl3.h
@@ -836,6 +836,10 @@ struct acpi_table_wpbt {
 	u16 arguments_length;
 };
 
+struct acpi_wpbt_unicode {
+	u16 *unicode_string;
+};
+
 /*******************************************************************************
  *
  * XENV - Xen Environment Table (ACPI 6.0)
-- 
2.30.2

