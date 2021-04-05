Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938F3354046
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240353AbhDEJQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239960AbhDEJQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:16:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94C3860FE4;
        Mon,  5 Apr 2021 09:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614205;
        bh=WOFnRVbIdQDdvsjuUNmXBLwRkqJufNr/tLKtBWOjZL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHWPBnf8X9sC06ysJHRLOU8csJ0p03m6gKfWKCPQZdE6vOLAia+NInV925okizU/L
         8QPiPPmfCLPsykBKEqU+3L59VhkjVgabmLNjyZeluxEJsG8MUSGG0377Lk6ZRXW4xC
         wDr/hlH8EjMW+51ng0PLNbkyGJ5a1NVT9uQ/sAhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Gong <richard.gong@intel.com>,
        Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 123/152] firmware: stratix10-svc: reset COMMAND_RECONFIG_FLAG_PARTIAL to 0
Date:   Mon,  5 Apr 2021 10:54:32 +0200
Message-Id: <20210405085038.229235788@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Gong <richard.gong@intel.com>

[ Upstream commit 2e8496f31d0be8f43849b2980b069f3a9805d047 ]

Clean up COMMAND_RECONFIG_FLAG_PARTIAL flag by resetting it to 0, which
aligns with the firmware settings.

Fixes: 36847f9e3e56 ("firmware: stratix10-svc: correct reconfig flag and timeout values")
Signed-off-by: Richard Gong <richard.gong@intel.com>
Reviewed-by: Tom Rix <trix@redhat.com>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/firmware/intel/stratix10-svc-client.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/firmware/intel/stratix10-svc-client.h b/include/linux/firmware/intel/stratix10-svc-client.h
index a93d85932eb9..f843c6a10cf3 100644
--- a/include/linux/firmware/intel/stratix10-svc-client.h
+++ b/include/linux/firmware/intel/stratix10-svc-client.h
@@ -56,7 +56,7 @@
  * COMMAND_RECONFIG_FLAG_PARTIAL:
  * Set to FPGA configuration type (full or partial).
  */
-#define COMMAND_RECONFIG_FLAG_PARTIAL	1
+#define COMMAND_RECONFIG_FLAG_PARTIAL	0
 
 /**
  * Timeout settings for service clients:
-- 
2.30.2



