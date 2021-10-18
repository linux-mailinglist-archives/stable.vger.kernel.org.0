Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79960431D67
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhJRNvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232617AbhJRNtM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:49:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 911C2613DB;
        Mon, 18 Oct 2021 13:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564236;
        bh=YrK6Z7UxsxCKjhdSKe/rz/pxD7DNaT2TFIjB7YkMI4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDeXlp/7lW2VbdGZjtH6j3Ys9Z1S/5verBopnCWCSzV5b3Sr3/8qm1P5oaZf7SKxK
         qxajRhuAWz2mCv8keE+f3j3M6zDn7D6Jht/LhSz3481zAhKM6blNYCp4jsNNtXtKvr
         2XLa9TzLBCpHh5YHqV8w6mSroJDa/PCoV7mVHYeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Zephaniah E. Loss-Cutler-Hull" <zephaniah@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.14 013/151] platform/x86: gigabyte-wmi: add support for B550 AORUS ELITE AX V2
Date:   Mon, 18 Oct 2021 15:23:12 +0200
Message-Id: <20211018132341.115829214@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zephaniah E. Loss-Cutler-Hull <zephaniah@gmail.com>

commit 0f607d6b227470456a69a37d7c7badea51d52844 upstream.

This works just fine on my system.

Signed-off-by: Zephaniah E. Loss-Cutler-Hull <zephaniah@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211005044855.1429724-1-zephaniah@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/gigabyte-wmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -141,6 +141,7 @@ static u8 gigabyte_wmi_detect_sensor_usa
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE AX V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 GAMING X V2"),


