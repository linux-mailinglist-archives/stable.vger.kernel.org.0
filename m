Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FED480098
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240252AbhL0Pr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:47:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45730 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240560AbhL0PpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:45:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1D01B80E5A;
        Mon, 27 Dec 2021 15:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F2BC36AE7;
        Mon, 27 Dec 2021 15:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619921;
        bh=NevZnyb3Kyik+cQknpTUHX++8xoetuHZuVFFkb38/XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuMC36ls86Uhy9FDf2t6uJ5aWt2DJZOzKfqS25QwvXlt9pac+Z/f8wDZh17ttDJqO
         Y2HKqn3vrKR0sQa80z34WFasO+86UzAGPt7HIfkVRjxRmGwm3xUUjNWcMlOKqiQtLo
         oEcZ1UyiAUOCKBCKOjwG8YKLO10Msd1i7HvJ2D0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 115/128] Input: goodix - add id->model mapping for the "9111" model
Date:   Mon, 27 Dec 2021 16:31:30 +0100
Message-Id: <20211227151335.355744646@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 81e818869be522bc8fa6f7df1b92d7e76537926c upstream.

Add d->model mapping for the "9111" model, this fixes uses using
a wrong config_len of 240 bytes while the "9111" model uses
only 186 bytes of config.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20211206164747.197309-2-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/goodix.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -162,6 +162,7 @@ static const struct goodix_chip_id goodi
 	{ .id = "911", .data = &gt911_chip_data },
 	{ .id = "9271", .data = &gt911_chip_data },
 	{ .id = "9110", .data = &gt911_chip_data },
+	{ .id = "9111", .data = &gt911_chip_data },
 	{ .id = "927", .data = &gt911_chip_data },
 	{ .id = "928", .data = &gt911_chip_data },
 


