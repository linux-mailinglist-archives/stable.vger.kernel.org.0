Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA80F499A97
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573563AbiAXVpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:45:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56880 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377960AbiAXVia (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:38:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A4DB61469;
        Mon, 24 Jan 2022 21:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1038EC340E4;
        Mon, 24 Jan 2022 21:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060306;
        bh=0T2Vc/UzvRRhHVYcsjvuz/eDIClZM/9HVuwwhz9uwY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBv0Tny9bJWfObtJDNF25CbtjUTU2nPVhwcyfztMFAjnhGz40/S5DW1OmoGa13+VL
         37KtRmaerMgsGpPjtL/8U+uw/pmXHVxGnUiguGiAlyn0JnMOpG0dgpbgzZAWbWyOrR
         LjSvdQ0DmYviP9TUxlPXc5yUxai0LbNUyIsb6/D8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Clint Taylor <clinton.a.taylor@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Clint Taylor <Clinton.A.Taylor@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.16 0871/1039] drm/i915/display/ehl: Update voltage swing table
Date:   Mon, 24 Jan 2022 19:44:20 +0100
Message-Id: <20220124184154.579506707@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

commit ef3ac01564067a4337bb798b8eddc6ea7b78fd10 upstream.

EHL table was recently updated with some minor fixes.

BSpec: 21257
Cc: stable@vger.kernel.org
Cc: Clint Taylor <clinton.a.taylor@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Clint Taylor <Clinton.A.Taylor@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220113160437.49059-1-jose.souza@intel.com
(cherry picked from commit 5ec7baef52c367cdbda964aa662f7135c25bab1f)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_ddi_buf_trans.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi_buf_trans.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi_buf_trans.c
@@ -477,14 +477,14 @@ static const struct intel_ddi_buf_trans
 static const union intel_ddi_buf_trans_entry _ehl_combo_phy_trans_dp[] = {
 							/* NT mV Trans mV db    */
 	{ .icl = { 0xA, 0x33, 0x3F, 0x00, 0x00 } },	/* 350   350      0.0   */
-	{ .icl = { 0xA, 0x47, 0x36, 0x00, 0x09 } },	/* 350   500      3.1   */
-	{ .icl = { 0xC, 0x64, 0x34, 0x00, 0x0B } },	/* 350   700      6.0   */
-	{ .icl = { 0x6, 0x7F, 0x30, 0x00, 0x0F } },	/* 350   900      8.2   */
+	{ .icl = { 0xA, 0x47, 0x38, 0x00, 0x07 } },	/* 350   500      3.1   */
+	{ .icl = { 0xC, 0x64, 0x33, 0x00, 0x0C } },	/* 350   700      6.0   */
+	{ .icl = { 0x6, 0x7F, 0x2F, 0x00, 0x10 } },	/* 350   900      8.2   */
 	{ .icl = { 0xA, 0x46, 0x3F, 0x00, 0x00 } },	/* 500   500      0.0   */
-	{ .icl = { 0xC, 0x64, 0x38, 0x00, 0x07 } },	/* 500   700      2.9   */
+	{ .icl = { 0xC, 0x64, 0x37, 0x00, 0x08 } },	/* 500   700      2.9   */
 	{ .icl = { 0x6, 0x7F, 0x32, 0x00, 0x0D } },	/* 500   900      5.1   */
 	{ .icl = { 0xC, 0x61, 0x3F, 0x00, 0x00 } },	/* 650   700      0.6   */
-	{ .icl = { 0x6, 0x7F, 0x38, 0x00, 0x07 } },	/* 600   900      3.5   */
+	{ .icl = { 0x6, 0x7F, 0x37, 0x00, 0x08 } },	/* 600   900      3.5   */
 	{ .icl = { 0x6, 0x7F, 0x3F, 0x00, 0x00 } },	/* 900   900      0.0   */
 };
 


