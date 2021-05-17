Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10A3383082
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbhEQO2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239072AbhEQO0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:26:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8C4961581;
        Mon, 17 May 2021 14:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260804;
        bh=Rp0WGtjE8YLATb1oHryYn35xWKSNYZxDW96VYtCljtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ls4i5rQDl95oE9xsQKJ95oBbfZs0hYismPeQWvDS0NpM7UMRAx5ebsRV0oCi0L+T9
         kQX87xAOrqp3NDht8mXVlJOJo0uMa/we6eieJoM2lpLkwSAMrznRMzt0yDWfVsLBvd
         py39ajg/yF0SseXFQF/CBFi82QgSZBR7ZLinUMPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.11 008/329] ACPI: PM: Add ACPI ID of Alder Lake Fan
Date:   Mon, 17 May 2021 15:58:39 +0200
Message-Id: <20210517140302.318253101@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
@@ -1314,6 +1314,7 @@ int acpi_dev_pm_attach(struct device *de
 		{"PNP0C0B", }, /* Generic ACPI fan */
 		{"INT3404", }, /* Fan */
 		{"INTC1044", }, /* Fan for Tiger Lake generation */
+		{"INTC1048", }, /* Fan for Alder Lake generation */
 		{}
 	};
 	struct acpi_device *adev = ACPI_COMPANION(dev);


