Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A5DE66C9
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbfJ0VPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730609AbfJ0VPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:15:12 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4036208C0;
        Sun, 27 Oct 2019 21:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210912;
        bh=a6NWeb/cvRKPTVMgErLPrNuC4T2h0kGuFR/Mxng+wDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2WFYLTrOUaC5BJh4QDHT4yz3TbOtPBTdnLr5NOh1EHxGTno7Sw6p37T4HtaCchMAK
         mRbR974n/Vr9pc9G2Ep/PbbsBUDuuQIUZ/PnoNpXrSoCkC13Gqx07IY10pZEcIqXPj
         EpFiMHdjqE+TvCx8gL81L0wpDz9/cFrX48SuT8uY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 4.19 59/93] drm/edid: Add 6 bpc quirk for SDC panel in Lenovo G50
Date:   Sun, 27 Oct 2019 22:01:11 +0100
Message-Id: <20191027203303.729200921@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
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
@@ -166,6 +166,9 @@ static const struct edid_quirk {
 	/* Medion MD 30217 PG */
 	{ "MED", 0x7b8, EDID_QUIRK_PREFER_LARGE_75 },
 
+	/* Lenovo G50 */
+	{ "SDC", 18514, EDID_QUIRK_FORCE_6BPC },
+
 	/* Panel in Samsung NP700G7A-S01PL notebook reports 6bpc */
 	{ "SEC", 0xd033, EDID_QUIRK_FORCE_8BPC },
 


