Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62ACD428FC7
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237401AbhJKOBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237429AbhJKN7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:59:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55A5960F35;
        Mon, 11 Oct 2021 13:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960567;
        bh=3MikjSeW0yglykcsi8ycgsxvG8OdGs/Z2X/Zz/GLL+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdWCQAedQ9zXFNs194UvullxyMjn9lS/ChdAjtiPAqEqbLK8mNABgBLhSmaargg5B
         /EDwZzKpi3wTeBgNwLeRkdAOKhjQEgbXUK4ej4h3g53fwFAOTsz6svCSMBYgx4pbn7
         a67YYYXdjIV48fX2/rlrDbEyzJ9zwSg5jSHFFw9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>, Jude Shih <shenshih@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 011/151] drm/amd/display: USB4 bring up set correct address
Date:   Mon, 11 Oct 2021 15:44:43 +0200
Message-Id: <20211011134518.220895630@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jude Shih <shenshih@amd.com>

commit 7ab0965079bbc0e39fe0e1df4dcdf931c9d25372 upstream.

[Why]
YELLOW_CARP_B0 address was not correct

[How]
Set YELLOW_CARP_B0 to 0x1A.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Jude Shih <shenshih@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/include/dal_asic_id.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/include/dal_asic_id.h
+++ b/drivers/gpu/drm/amd/display/include/dal_asic_id.h
@@ -227,7 +227,7 @@ enum {
 #define FAMILY_YELLOW_CARP                     146
 
 #define YELLOW_CARP_A0 0x01
-#define YELLOW_CARP_B0 0x02		// TODO: DCN31 - update with correct B0 ID
+#define YELLOW_CARP_B0 0x1A
 #define YELLOW_CARP_UNKNOWN 0xFF
 
 #ifndef ASICREV_IS_YELLOW_CARP


