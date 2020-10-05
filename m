Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952F1283AA7
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgJEPfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbgJEPdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:33:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B178206DD;
        Mon,  5 Oct 2020 15:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912020;
        bh=loSTzaIyy/eWX7bIjRiRN78CodfkLCAmYrOJDPV4Vro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9MbDHyHcg1laRcz+5aqbLDfFv9M2qNapyWePlQj80VMKjNM6sLgD9d26fJF8riGT
         Ir1UEhaKHBg2r6NaFAe2u0omVJM6gI1OwCAB2+MgpPbt6eqbvhEFHsefKIZst4deuQ
         OrL1OBLHDPNGDCakICJqsR9En40G8DayuvFbsZuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Harry Cutts <hcutts@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 68/85] Input: trackpoint - enable Synaptics trackpoints
Date:   Mon,  5 Oct 2020 17:27:04 +0200
Message-Id: <20201005142118.003428623@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Huang <vincent.huang@tw.synaptics.com>

[ Upstream commit 996d585b079ad494a30cac10e08585bcd5345125 ]

Add Synaptics IDs in trackpoint_start_protocol() to mark them as valid.

Signed-off-by: Vincent Huang <vincent.huang@tw.synaptics.com>
Fixes: 6c77545af100 ("Input: trackpoint - add new trackpoint variant IDs")
Reviewed-by: Harry Cutts <hcutts@chromium.org>
Tested-by: Harry Cutts <hcutts@chromium.org>
Link: https://lore.kernel.org/r/20200924053013.1056953-1-vincent.huang@tw.synaptics.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/trackpoint.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
index 854d5e7587241..ef2fa0905208d 100644
--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -282,6 +282,8 @@ static int trackpoint_start_protocol(struct psmouse *psmouse,
 	case TP_VARIANT_ALPS:
 	case TP_VARIANT_ELAN:
 	case TP_VARIANT_NXP:
+	case TP_VARIANT_JYT_SYNAPTICS:
+	case TP_VARIANT_SYNAPTICS:
 		if (variant_id)
 			*variant_id = param[0];
 		if (firmware_id)
-- 
2.25.1



