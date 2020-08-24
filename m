Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE4624FABF
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgHXJ7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727011AbgHXIdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:33:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BB8A2074D;
        Mon, 24 Aug 2020 08:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258001;
        bh=LEHr3HsevyMnaJkhSBY7315fU7qnMjb9UHxHuYi1qX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3UmNdJMsBk6i8I5qSSPSi9ool5tjoWgJprAfthEVYUEJD8BkZJfZ9UiG8DDQJH7V
         WUWkXZxDac+LyU1yjmNsvEpBWp9Bd2ExfudI4DM70NlXivo4rKOqlUzw8+nivjmG4q
         go4BwovlnJ9t5PS1ZkOX8o00qzgTTE8hGI9H/UQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <aric.cyr@amd.com>,
        Ashley Thomas <Ashley.Thomas2@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.8 038/148] drm/amd/display: Fix incorrect backlight register offset for DCN
Date:   Mon, 24 Aug 2020 10:28:56 +0200
Message-Id: <20200824082415.864565560@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

commit a49f6727e14caff32419cc3002b9ae9cafb750d7 upstream.

[Why]
Typo in backlight refactor inctroduced wrong register offset.

[How]
Change DCE to DCN register map for PWRSEQ_REF_DIV

Cc: stable@vger.kernel.org
Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Reviewed-by: Ashley Thomas <Ashley.Thomas2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h
@@ -49,7 +49,7 @@
 #define DCN_PANEL_CNTL_REG_LIST()\
 	DCN_PANEL_CNTL_SR(PWRSEQ_CNTL, LVTMA), \
 	DCN_PANEL_CNTL_SR(PWRSEQ_STATE, LVTMA), \
-	DCE_PANEL_CNTL_SR(PWRSEQ_REF_DIV, LVTMA), \
+	DCN_PANEL_CNTL_SR(PWRSEQ_REF_DIV, LVTMA), \
 	SR(BL_PWM_CNTL), \
 	SR(BL_PWM_CNTL2), \
 	SR(BL_PWM_PERIOD_CNTL), \


