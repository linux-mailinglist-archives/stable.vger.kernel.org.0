Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4599A480002
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239525AbhL0Pmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238522AbhL0Pkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:40:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289AAC06175A;
        Mon, 27 Dec 2021 07:39:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE598610A2;
        Mon, 27 Dec 2021 15:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C2CC36AEA;
        Mon, 27 Dec 2021 15:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619566;
        bh=NevZnyb3Kyik+cQknpTUHX++8xoetuHZuVFFkb38/XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JoWafdSYBMNWbWRzGxQqsJWvtsQGW3HfxtlzbfKjpdLQ5rO3C+2hxTwroX3i+N5mF
         UByFOrsPiS7jGV3SFR+GR0r5BqqcADtTzouS/ukry8QG4q3ildrwpKUjgUp+ufg+uh
         01DoPfH9iFMVB+t84xRIuYkQvm2P638aHM77Pm8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 67/76] Input: goodix - add id->model mapping for the "9111" model
Date:   Mon, 27 Dec 2021 16:31:22 +0100
Message-Id: <20211227151327.006241080@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
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
 


