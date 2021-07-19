Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E493CDDF4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344245AbhGSPB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344364AbhGSO7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFEB660E0C;
        Mon, 19 Jul 2021 15:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709195;
        bh=LZyh9I0Qu9dVIqRZDoG3gVDmqLslmLTEzdZe/3HGFWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LkGUzTWavvDI54EVbGfQJSmXbyVpbvP+g7K7rplqPIlbBr1NdDrKLGQWwgkw60Di0
         Az7Q57zi50Qgm/eHX3c381WvncLo8nxu+colvkRcMNVjuwq37kEZeVyGbr2rpxXrkq
         PJS26okAhk2RpInMuL2Z1ux3lslimAXz/c8uarzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>
Subject: [PATCH 4.19 287/421] drm/amd/display: fix incorrrect valid irq check
Date:   Mon, 19 Jul 2021 16:51:38 +0200
Message-Id: <20210719144956.286999635@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

commit e38ca7e422791a4d1c01e56dbf7f9982db0ed365 upstream.

valid DAL irq should be < DAL_IRQ_SOURCES_NUMBER.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-and-tested-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/irq_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/irq_types.h
+++ b/drivers/gpu/drm/amd/display/dc/irq_types.h
@@ -155,7 +155,7 @@ enum irq_type
 };
 
 #define DAL_VALID_IRQ_SRC_NUM(src) \
-	((src) <= DAL_IRQ_SOURCES_NUMBER && (src) > DC_IRQ_SOURCE_INVALID)
+	((src) < DAL_IRQ_SOURCES_NUMBER && (src) > DC_IRQ_SOURCE_INVALID)
 
 /* Number of Page Flip IRQ Sources. */
 #define DAL_PFLIP_IRQ_SRC_NUM \


