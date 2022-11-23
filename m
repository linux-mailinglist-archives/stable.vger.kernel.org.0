Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFA66358C6
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbiKWKDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237248AbiKWKCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:02:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115DE77202
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:54:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C06BFB81EF1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277D2C433C1;
        Wed, 23 Nov 2022 09:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197246;
        bh=HcPyuCp0n5QyO39P5sBaG+3b0bMiT9tVBLZuD1KrLw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=000GfdSMgXNxU7i6trtLpiX2X1tEw6MFkzSTBlYLsnG9F9DpqXoDo1SXY8DpXV0ZS
         GS+p40lGXW1xI8WclUMIkYzqrP3Sz4JuwUVTgggTc/pe8UjDZKcCitN4zMZdcIcNHi
         kzw+0hrnOpXdqZ05DMzAq5l9hH5dbwO3Qx6dGdAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.0 209/314] platform/x86/amd: pmc: Add new ACPI ID AMDI0009
Date:   Wed, 23 Nov 2022 09:50:54 +0100
Message-Id: <20221123084635.003119513@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

commit 6412518f5cb953cbd84b6746db9741bfc92be40a upstream.

Add new a new ACPI ID AMDI0009 used by upcoming AMD platform to the pmc
supported list of devices.

Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20221109083346.361603-1-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -918,6 +918,7 @@ static const struct acpi_device_id amd_p
 	{"AMDI0006", 0},
 	{"AMDI0007", 0},
 	{"AMDI0008", 0},
+	{"AMDI0009", 0},
 	{"AMD0004", 0},
 	{"AMD0005", 0},
 	{ }


