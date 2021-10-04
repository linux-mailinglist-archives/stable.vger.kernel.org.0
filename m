Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3C1421013
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238447AbhJDNk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238565AbhJDNiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:38:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F19F63245;
        Mon,  4 Oct 2021 13:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353471;
        bh=dHnNYp5A+OqL1gE6Z3IskOI2r698DKp6V3t6uhpPoC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgzvO46EKTRZjv10O/seRuc09nT4NUmWFNJYZxUsCjLwytlM14J8cXheYaygSCS4l
         R0Nw+Mz3CppC0kiqs7nF7sRUEFaf+/JLH1+2Ol01ofX+4h24NBJnqm5txMm/KazvHA
         O/bt3esAJUKZuNxiMPScxSerNXqJnxxtHAZLPuvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 142/172] hwmon: (pmbus/mp2975) Add missed POUT attribute for page 1 mp2975 controller
Date:   Mon,  4 Oct 2021 14:53:12 +0200
Message-Id: <20211004125049.552469029@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit 2292e2f685cd5c65e3f47bbcf9f469513acc3195 ]

Add missed attribute for reading POUT from page 1.
It is supported by device, but has been missed in initial commit.

Fixes: 2c6fcbb21149 ("hwmon: (pmbus) Add support for MPS Multi-phase mp2975 controller")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20210927070740.2149290-1-vadimp@nvidia.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/mp2975.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/mp2975.c b/drivers/hwmon/pmbus/mp2975.c
index eb94bd5f4e2a..51986adfbf47 100644
--- a/drivers/hwmon/pmbus/mp2975.c
+++ b/drivers/hwmon/pmbus/mp2975.c
@@ -54,7 +54,7 @@
 
 #define MP2975_RAIL2_FUNC	(PMBUS_HAVE_VOUT | PMBUS_HAVE_STATUS_VOUT | \
 				 PMBUS_HAVE_IOUT | PMBUS_HAVE_STATUS_IOUT | \
-				 PMBUS_PHASE_VIRTUAL)
+				 PMBUS_HAVE_POUT | PMBUS_PHASE_VIRTUAL)
 
 struct mp2975_data {
 	struct pmbus_driver_info info;
-- 
2.33.0



