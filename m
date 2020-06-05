Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0031EFA53
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgFEOQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728272AbgFEOQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E83D20878;
        Fri,  5 Jun 2020 14:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366598;
        bh=7KCJ9RahVhpFyfg0qAqHj72ARODx0jCsdw3IRaggssE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuloDwI3WI141kbrwwBKAXEY0BxB82UoeImQYSqJ8gXG+QP6zrRrUgiTdmAFffJ9c
         EB1qxBCrrgl4nyudEZCpG++ycZtMPZ5NNQ9H8G7RSxEJy1SMtyKEal0Ni/yYg+qsuC
         Xg4fS0mWUPUdLMwWgD+mV0LnGhcawPJbo7BXhTGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Schmidt <jan@centricular.com>,
        Dave Airlie <airlied@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 18/43] drm/edid: Add Oculus Rift S to non-desktop list
Date:   Fri,  5 Jun 2020 16:14:48 +0200
Message-Id: <20200605140153.477728026@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Schmidt <jan@centricular.com>

[ Upstream commit 5a3f610877e9d08968ea7237551049581f02b163 ]

Add a quirk for the Oculus Rift S OVR0012 display so
it shows up as a non-desktop display.

Signed-off-by: Jan Schmidt <jan@centricular.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200507180628.740936-1-jan@centricular.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 079800a07d6e..5c611baba2fc 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -191,10 +191,11 @@ static const struct edid_quirk {
 	{ "HVR", 0xaa01, EDID_QUIRK_NON_DESKTOP },
 	{ "HVR", 0xaa02, EDID_QUIRK_NON_DESKTOP },
 
-	/* Oculus Rift DK1, DK2, and CV1 VR Headsets */
+	/* Oculus Rift DK1, DK2, CV1 and Rift S VR Headsets */
 	{ "OVR", 0x0001, EDID_QUIRK_NON_DESKTOP },
 	{ "OVR", 0x0003, EDID_QUIRK_NON_DESKTOP },
 	{ "OVR", 0x0004, EDID_QUIRK_NON_DESKTOP },
+	{ "OVR", 0x0012, EDID_QUIRK_NON_DESKTOP },
 
 	/* Windows Mixed Reality Headsets */
 	{ "ACR", 0x7fce, EDID_QUIRK_NON_DESKTOP },
-- 
2.25.1



