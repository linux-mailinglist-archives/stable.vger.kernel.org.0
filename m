Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65DF431D74
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhJRNva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233373AbhJRNtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:49:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3035C60EFE;
        Mon, 18 Oct 2021 13:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564238;
        bh=E8neFMQxf1o/6hUR9Xy8xjTJANOM1AjMQHoam/otEwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIpBekhTuvzjcUxwQa6A1a2G+4Fix+bMcxdl9y7v/0EA/F4z04wrboEffnXaqo2Il
         ZOsyvL8raPN+H3jJeP+X7JXbTsh9KXW5NYNvfyiPAyJhyTRWogTT9wkomwb/7vMWcE
         TG2Pbk/6HbUKqQqFMS/FVdvyVK/Lnc1SPjH++fUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachi King <nakato@nakato.io>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.14 014/151] platform/x86: amd-pmc: Add alternative acpi id for PMC controller
Date:   Mon, 18 Oct 2021 15:23:13 +0200
Message-Id: <20211018132341.149538591@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sachi King <nakato@nakato.io>

commit c0d84d2c7c23e9cf23a5abdda40eeaa79eabfe69 upstream.

The Surface Laptop 4 AMD has used the AMD0005 to identify this
controller instead of using the appropriate ACPI ID AMDI0005.  Include
AMD0005 in the acpi id list.

Link: https://github.com/linux-surface/acpidumps/tree/master/surface_laptop_4_amd
Link: https://gist.github.com/nakato/2a1a7df1a45fe680d7a08c583e1bf863
Cc: <stable@vger.kernel.org> # 5.14+
Signed-off-by: Sachi King <nakato@nakato.io>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20211002041840.2058647-1-nakato@nakato.io
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd-pmc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -476,6 +476,7 @@ static const struct acpi_device_id amd_p
 	{"AMDI0006", 0},
 	{"AMDI0007", 0},
 	{"AMD0004", 0},
+	{"AMD0005", 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, amd_pmc_acpi_ids);


