Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426FE2B63F8
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732643AbgKQNnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:43:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387455AbgKQNmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:42:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31156216C4;
        Tue, 17 Nov 2020 13:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620560;
        bh=07HrhYS8pNujc6fOy3FoHs3StiHhIlXZgNSILI2WYeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OA04LgIorfI7N6qRM0sQAXpxmaN8IjxbGG4oqAoGQuyJ/xXifOQkZ7f0Kv6PxJ21j
         d1XwgxjC29RIQcoTxVltRN9zaA+fm4pqPQ/Oy63n2bbFfCw3Azq+JKTU6LOGbegM6U
         VRy/Ivuy9BICfqipqb6UFwt0nYk9o9esydfCHS0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linu Cherian <lcherian@marvell.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.9 253/255] coresight: etm: perf: Sink selection using sysfs is deprecated
Date:   Tue, 17 Nov 2020 14:06:33 +0100
Message-Id: <20201117122151.246421753@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linu Cherian <lcherian@marvell.com>

commit bb1860efc817c18fce4112f25f51043e44346d1b upstream.

When using the perf interface, sink selection using sysfs is
deprecated.

Signed-off-by: Linu Cherian <lcherian@marvell.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200916191737.4001561-14-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-etm-perf.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -222,8 +222,6 @@ static void *etm_setup_aux(struct perf_e
 	if (event->attr.config2) {
 		id = (u32)event->attr.config2;
 		sink = coresight_get_sink_by_id(id);
-	} else {
-		sink = coresight_get_enabled_sink(true);
 	}
 
 	mask = &event_data->mask;


