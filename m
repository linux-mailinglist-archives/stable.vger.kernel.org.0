Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D930E68F7
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbfJ0VMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729052AbfJ0VMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:12:41 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F75B2064A;
        Sun, 27 Oct 2019 21:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210760;
        bh=0d5MsTI66IF7v3sAx2BAR91jhVTzfEEYisC3gIb81Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTYVDAEYpw0gy6QQ+hGUzN+AM5srqnakgKjIUyHaUuv14UtKj3Ay5vCTszlAxCcbR
         EuHznTTBYvU2M5OSGpwbbAFMZao9EVHSWE3/vxMOnw/VWDQTG1fGR58pP+L+9HENXy
         E33JPpTU32VkV+Llt3FzuGCMlB+5RrbpvASSMXG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 4.14 096/119] drm/edid: Add 6 bpc quirk for SDC panel in Lenovo G50
Date:   Sun, 27 Oct 2019 22:01:13 +0100
Message-Id: <20191027203348.712894177@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 11bcf5f78905b90baae8fb01e16650664ed0cb00 upstream.

Another panel that needs 6BPC quirk.

BugLink: https://bugs.launchpad.net/bugs/1819968
Cc: <stable@vger.kernel.org> # v4.8+
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190402033037.21877-1-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_edid.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -164,6 +164,9 @@ static const struct edid_quirk {
 	/* Medion MD 30217 PG */
 	{ "MED", 0x7b8, EDID_QUIRK_PREFER_LARGE_75 },
 
+	/* Lenovo G50 */
+	{ "SDC", 18514, EDID_QUIRK_FORCE_6BPC },
+
 	/* Panel in Samsung NP700G7A-S01PL notebook reports 6bpc */
 	{ "SEC", 0xd033, EDID_QUIRK_FORCE_8BPC },
 


