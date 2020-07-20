Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666EF2268DD
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387757AbgGTQWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732828AbgGTQHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:07:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E33220734;
        Mon, 20 Jul 2020 16:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261227;
        bh=oQm2Jqtg4xH78lirey/DSRUlvvhxX/QamPy7sFyu/tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcCBZU49qmZ6Yg7u+bPusiZcq76Ab3DibDOiamu5ypeQG9kQo82NxNtVYEUU+TiRA
         tuJ1hu64g31qvVjAdh212lpQg7OdWUT0akDWOAmxwjuxd5G6kAgqxxJPj81al/6jpk
         AcYPSEOShJnA/x8srWu/bHPmpD/lNIm2V6t11qdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 038/244] ACPI: DPTF: Add battery participant for TigerLake
Date:   Mon, 20 Jul 2020 17:35:09 +0200
Message-Id: <20200720152827.670051297@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 1e05daca83bb42cde569f75f3bd7c8828b1ef30f ]

Add DPTF battery participant ACPI ID for platforms based on the Intel
TigerLake SoC.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
[ rjw: Changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/dptf/dptf_power.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/dptf/dptf_power.c b/drivers/acpi/dptf/dptf_power.c
index e4e8b75d39f09..8b42f529047e9 100644
--- a/drivers/acpi/dptf/dptf_power.c
+++ b/drivers/acpi/dptf/dptf_power.c
@@ -99,6 +99,7 @@ static int dptf_power_remove(struct platform_device *pdev)
 static const struct acpi_device_id int3407_device_ids[] = {
 	{"INT3407", 0},
 	{"INTC1047", 0},
+	{"INTC1050", 0},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, int3407_device_ids);
-- 
2.25.1



