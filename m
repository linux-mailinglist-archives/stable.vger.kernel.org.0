Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26C462488D
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 18:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiKJRqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 12:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiKJRqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 12:46:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B7B2D75A
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 09:46:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A205661D7F
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 17:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46D9C433D6;
        Thu, 10 Nov 2022 17:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668102381;
        bh=gI0TaG/b4gixt0LX4QQ2CsMqQG9aANlzXbHal7eckuo=;
        h=Subject:To:From:Date:From;
        b=D8xTGmu3MimMyuhxPZzAiYp03mOKbfJlErTEQVTUVCvXWhoLoy1OCjPDEnBz3mweL
         48OJYRUzQAhwOoblC1y4qyxx3q5qJBiT/MA72KLt0B0cDY98RLctxjR+Q9eSuTdBL7
         8kzvA2cpqxyei+Rt4x55XbrC11KnLDfpbUNr47sc=
Subject: patch "slimbus: stream: correct presence rate frequencies" added to char-misc-linus
To:     krzysztof.kozlowski@linaro.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Nov 2022 18:46:10 +0100
Message-ID: <16681023708642@kroah.com>
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

    slimbus: stream: correct presence rate frequencies

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b9c1939627f8185dec8ba6d741e9573a4c7a5834 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 29 Sep 2022 18:52:02 +0200
Subject: slimbus: stream: correct presence rate frequencies

Correct few frequencies in presence rate table - multiplied by 10
(110250 instead of 11025 Hz).

Fixes: abb9c9b8b51b ("slimbus: stream: add stream support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220929165202.410937-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/stream.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/slimbus/stream.c b/drivers/slimbus/stream.c
index 75f87b3d8b95..73a2aa362957 100644
--- a/drivers/slimbus/stream.c
+++ b/drivers/slimbus/stream.c
@@ -67,10 +67,10 @@ static const int slim_presence_rate_table[] = {
 	384000,
 	768000,
 	0, /* Reserved */
-	110250,
-	220500,
-	441000,
-	882000,
+	11025,
+	22050,
+	44100,
+	88200,
 	176400,
 	352800,
 	705600,
-- 
2.38.1


