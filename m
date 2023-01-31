Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2261B68299E
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjAaJxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbjAaJxj (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:53:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA9A5B9D
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:53:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40D6EB81AF7
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997F1C4339B;
        Tue, 31 Jan 2023 09:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158812;
        bh=r1CDmd+K7Wu5pix62k+aApdSsMUWu+GxBjQKilsIIlM=;
        h=Subject:To:From:Date:From;
        b=CqJooM/fTqMeUqDCKbT7gl5aHPVS2/yJ8Yxm2czQixO0vt9u757VtoQ765rErIDRs
         UoI8vaLge8Ggji/D7xg89J88jstSFwxTdFfcAlavcHtksOKcpxZbnZIG1DlyB/7xQD
         CZcoB5lGUv3qVouuSq0BYNYJKbnHRpVkHOIfvqLY=
Subject: patch "iio: imu: fxos8700: remove definition FXOS8700_CTRL_ODR_MIN" added to char-misc-linus
To:     carlos.song@nxp.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:45 +0100
Message-ID: <167515876560111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: fxos8700: remove definition FXOS8700_CTRL_ODR_MIN

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ff5e2cd92ffda9a25ffa2cbdb3a0cf17650172a6 Mon Sep 17 00:00:00 2001
From: Carlos Song <carlos.song@nxp.com>
Date: Wed, 18 Jan 2023 15:42:26 +0800
Subject: iio: imu: fxos8700: remove definition FXOS8700_CTRL_ODR_MIN

FXOS8700_CTRL_ODR_MIN is not used but value is probably wrong.

Remove it for a good readability.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20230118074227.1665098-4-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/fxos8700_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/imu/fxos8700_core.c b/drivers/iio/imu/fxos8700_core.c
index 514411d5ddff..880b9bcb80ff 100644
--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -146,7 +146,6 @@
 
 /* Bit definitions for FXOS8700_CTRL_REG1 */
 #define FXOS8700_CTRL_ODR_MAX       0x00
-#define FXOS8700_CTRL_ODR_MIN       GENMASK(4, 3)
 #define FXOS8700_CTRL_ODR_MSK       GENMASK(5, 3)
 
 /* Bit definitions for FXOS8700_M_CTRL_REG1 */
-- 
2.39.1


