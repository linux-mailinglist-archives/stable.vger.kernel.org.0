Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B2E10BACC
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732470AbfK0VGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731881AbfK0VGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:06:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6FC62080F;
        Wed, 27 Nov 2019 21:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888799;
        bh=Obg1p7S3J0MkR3yuSxhUyoV5Ni3xlnofF+hMIyYxgDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nrdy3TXHcVFuPMYQypPvzJ9WmQAuE7LnGFglYSAyoKCrtHJ21Y3NV4azmqqA3VRdP
         FwQrBDja9h8Sfro7Bord9CgDkgqCRukw6BF/fZdh7PE6C1NZyjDSl6AKGAzVOQUpi6
         HIXgwhF3DEZvGVAnAVBjtKICkFYv9my4GMC51MdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Erik Schmauss <erik.schmauss@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 237/306] ACPICA: Use %d for signed int print formatting instead of %u
Date:   Wed, 27 Nov 2019 21:31:27 +0100
Message-Id: <20191127203132.312741545@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit f8ddf49b420112e28bdd23d7ad52d7991a0ccbe3 ]

Fix warnings found using static analysis with cppcheck, use %d printf
format specifier for signed ints rather than %u

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Erik Schmauss <erik.schmauss@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/acpi/tools/acpidump/apmain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/acpi/tools/acpidump/apmain.c b/tools/power/acpi/tools/acpidump/apmain.c
index db213171f8d99..2d9b94b631cb9 100644
--- a/tools/power/acpi/tools/acpidump/apmain.c
+++ b/tools/power/acpi/tools/acpidump/apmain.c
@@ -106,7 +106,7 @@ static int ap_insert_action(char *argument, u32 to_be_done)
 
 	current_action++;
 	if (current_action > AP_MAX_ACTIONS) {
-		fprintf(stderr, "Too many table options (max %u)\n",
+		fprintf(stderr, "Too many table options (max %d)\n",
 			AP_MAX_ACTIONS);
 		return (-1);
 	}
-- 
2.20.1



