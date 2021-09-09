Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E43405768
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376461AbhIINeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:34:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354413AbhIIM47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 220696325D;
        Thu,  9 Sep 2021 11:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188706;
        bh=yXefDAaERqdGHDScDcdX/tA9O3S1ih+57YCLMGrkGMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAYmGRnDdupj661GyXtYsMXFbujox1wi83uCPcIsxxi4HCExft1cc3AXOW2bP0VBk
         xl59kynq2nUMy/dx7rJkEAEZwHfAPDRzWyeJpT+eB9X1U28Misp9lTY/xcNrhFm0i0
         HBrPUTGdLsfK0kJVArXqki3VEinK57FNouixPsxwujo31WesuNm+BrEZkeAx3sveaR
         Srr60w8kJKcrGXJAiMFPD4taLtXBAx721zCNfZq9tFSIm2Toq4CJiboiqc0WyI6FZX
         TfefNpT/0vhy1rZCcFsddOVmV2kfM3QJ6bTAcCdaDDWnVbGnDolDA0G5DZnFST/ZZ3
         CczgmQIRa6qUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 4.19 48/74] ACPICA: iASL: Fix for WPBT table with no command-line arguments
Date:   Thu,  9 Sep 2021 07:57:00 -0400
Message-Id: <20210909115726.149004-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
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
index 501f341d1d92..d1fe16d67747 100644
--- a/include/acpi/actbl3.h
+++ b/include/acpi/actbl3.h
@@ -631,6 +631,10 @@ struct acpi_table_wpbt {
 	u16 arguments_length;
 };
 
+struct acpi_wpbt_unicode {
+	u16 *unicode_string;
+};
+
 /*******************************************************************************
  *
  * WSMT - Windows SMM Security Migrations Table
-- 
2.30.2

