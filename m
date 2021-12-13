Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4744726D8
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbhLMJzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:55:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39132 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238579AbhLMJxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:53:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 546E2B80E0B;
        Mon, 13 Dec 2021 09:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE11C00446;
        Mon, 13 Dec 2021 09:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389193;
        bh=PKKCk6PGFBAMzOgVN68UPFzUfh4BZxTAlIsgNuAur7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g73w6T19mH0CCr8MNm8u54c+J+1GFfNWbnW2jq42anZTZXchho+WpTCBSG4OWifUU
         bBXnA1Vv8PxI1fiqjT4Q5D0/XQAXJAhVtQxlBQGovZoKvDXalyomMQdBtz8A+DF8VL
         U0RvLKYWcwZy5BLOfcGRAHj+kS3bVjX2A4O59Hng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Hung <alex.hung@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 016/171] platform/x86/intel: hid: add quirk to support Surface Go 3
Date:   Mon, 13 Dec 2021 10:28:51 +0100
Message-Id: <20211213092945.626746743@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Hung <alex.hung@canonical.com>

commit 7d0c009043f6a970f62dbf5aecda9f8c3ccafcff upstream.

Similar to other systems Surface Go 3 requires a DMI quirk to enable
5 button array for power and volume buttons.

Buglink: https://github.com/linux-surface/linux-surface/issues/595

Cc: stable@vger.kernel.org
Signed-off-by: Alex Hung <alex.hung@canonical.com>
Link: https://lore.kernel.org/r/20211203212810.2666508-1-alex.hung@canonical.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/hid.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -99,6 +99,13 @@ static const struct dmi_system_id button
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Tablet Gen 2"),
 		},
 	},
+	{
+		.ident = "Microsoft Surface Go 3",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
+		},
+	},
 	{ }
 };
 


