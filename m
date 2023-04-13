Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C846E1614
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 22:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjDMUsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 16:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjDMUsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 16:48:54 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E46193C9;
        Thu, 13 Apr 2023 13:48:52 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 12C3E32009A9;
        Thu, 13 Apr 2023 16:48:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 13 Apr 2023 16:48:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1681418930; x=1681505330; bh=XKbPIBcAeh
        D9dQDK3VzDyoTlY+7K8DvNqjYIwyhgnaw=; b=h4e8kUBnCtcl5EdT+h18RV/CvK
        KURTVEsFDfNAdWvSnSJcO3y003ajKtaObY4E6TbkTVPBtoB+PGd3OGQDj3SjzTT+
        KJmLqJiSyPgzNaU//ne5kugMwDv2x/o34UUG/FMXKh8sHL96Q/mtf8B29GpPbK+z
        OMDI4/r5o3Bg/fAL8q9EFB/2UmtmZ+OTT9+Kwtcqzko1Td2BYfsDFIDfun6YbwGe
        U7spXjdI1VbXSZE7jJxBTNSekpf+PdMQhDPRuqeyjtN0nw5v6qZYcYzXeCtgMX8U
        APuX2Aj2Hv+Gy+psjB0PPTDxMvj66s6GcTr41P2FoSnp5OG6ji+O+FSCK2iQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681418930; x=1681505330; bh=XKbPIBcAehD9d
        QDK3VzDyoTlY+7K8DvNqjYIwyhgnaw=; b=bYwWhgEaQsP/JLWWYbrcIorL9Vdcg
        CI5u2t8bR45ucBkJhpzwhQmpyJyMJFja0kryt1WFtYR4fCZec4Uqv9U9oTYRUguY
        kScvLaTyw0tvbrRIhoI+aHSuNJotQF/wY8nN0LJjkUjLPftV+dplMufuWuWpy0dq
        DwUDa7BCmYZ404i4DntbPfg8Gc2kroiyBIJgmAZEj7Mimd9atQe2B1iaIjr2zx/q
        kPuMb4zRgS+gEkhobDTCtF5p+GQiqgPTIyMA2z8+5XKcoMAAjdxAYRcaJunyh/s6
        0pKwYXZN/6hR15WKBGuULmBq21GI1+SxZGDAXKS7t3erHcZbb3Tm3Kr0Q==
X-ME-Sender: <xms:smo4ZGgjktrfFtGWnqyKzUupxur12RnYoqs438zMKFaKPKzRT5kFaQ>
    <xme:smo4ZHCf3nctc5Sq64vkk2lZcbOxL9HlHgWrNssozXmhrO4WAdzUgZfG2DbqHwp_P
    I3IY6jJNjs2wpkfTJw>
X-ME-Received: <xmr:smo4ZOHaqB-i4UGwvZ_0-pi0VdQGZaFhpLapyU1_erWPZuVABXHGhmbYR5szjbMwpwx3n7mzSNaxa5km4yDS00umUWuGFnPd3uULXwD6bqQwyRz6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdekkedgudehhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpedfvfihlhgv
    rhcujfhitghkshculdfoihgtrhhoshhofhhtmddfuceotghouggvsehthihhihgtkhhsrd
    gtohhmqeenucggtffrrghtthgvrhhnpeeitdfgudeikefgheegfffhvdfgfedvfeevgeeh
    keegfffgudekveffvdejtedvieenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheptghouggvseht
    hihhihgtkhhsrdgtohhm
X-ME-Proxy: <xmx:smo4ZPTD2lnhFsWhbc9SgS_WawDHz2an-YEGEB42tL4uODcCQkgPDg>
    <xmx:smo4ZDxrZkf94rTR11IWkejUnNZnCdThP1vv5QNtZ3u90g-2nQvr6Q>
    <xmx:smo4ZN4sKs92MizQjSJS2vhEvGRUY-PW3bmqW-YwQj_YMz-zknFgUg>
    <xmx:smo4ZFskYzK6pNxnb4QkXDmwXjV1PQXpZT3mxouMxuPVbcq_HDFZWg>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 13 Apr 2023 16:48:49 -0400 (EDT)
From:   "Tyler Hicks (Microsoft)" <code@tyhicks.com>
To:     stable@vger.kernel.org
Cc:     George Cherian <george.cherian@marvell.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-watchdog@vger.kernel.org
Subject: [PATCH 5.10 5.4 4.19 4.14] watchdog: sbsa_wdog: Make sure the timeout programming is within the limits
Date:   Thu, 13 Apr 2023 15:48:23 -0500
Message-Id: <20230413204823.724485-1-code@tyhicks.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Cherian <george.cherian@marvell.com>

[ Upstream commit 000987a38b53c172f435142a4026dd71378ca464 ]

Make sure to honour the max_hw_heartbeat_ms while programming the timeout
value to WOR. Clamp the timeout passed to sbsa_gwdt_set_timeout() to
make sure the programmed value is within the permissible range.

Fixes: abd3ac7902fb ("watchdog: sbsa: Support architecture version 1")

Signed-off-by: George Cherian <george.cherian@marvell.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230209021117.1512097-1-george.cherian@marvell.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
---

The Fixes line in the original commit is incorrect. This commit fixes a
bug that goes all the way back to v4.6 commit 57d2caaabfc7 ("Watchdog:
introduce ARM SBSA watchdog driver") when only 32-bit Watchdog Offset
Registers (WOR) were supported.

Without this fix, there's a truncation on the first argument, of u32
type, passed to writel() in the following situation situation:

Generic Watchdog architecture version is 1 (WOR is 32-bit)
action is 1
timeout is 240s
CNTFRQ_EL0 is 25000050 Hz
wdd.max_hw_heartbeat_ms is 171s

25000050 * 240 = 6000012000  <--- requires 33 bits to store
6000012000 & 0xFFFFFFFF = 1705044704  <--- truncated value written to WOR
1705044704 / 25000050 = 68.2s  <--- timeout incorrectly set to 68.2s

The timeout from userspace is greater than wdd.max_hw_heartbeat_ms so
the watchdog core pings at 69s (240 - 171) which results in
intermittent and unexpected panics (action=1).

With this patch applied, the timeout passed to writel() never exceeds
32-bits and the watchdog core + systemd keeps the watchdog happy.

I've validated this fix on real hardware running a linux-5.10.y stable
kernel. Please apply this patch to 5.10 through 4.14. Thanks!

Tyler

 drivers/watchdog/sbsa_gwdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/sbsa_gwdt.c b/drivers/watchdog/sbsa_gwdt.c
index f0f1e3b2e463..4cbe6ba52754 100644
--- a/drivers/watchdog/sbsa_gwdt.c
+++ b/drivers/watchdog/sbsa_gwdt.c
@@ -121,6 +121,7 @@ static int sbsa_gwdt_set_timeout(struct watchdog_device *wdd,
 	struct sbsa_gwdt *gwdt = watchdog_get_drvdata(wdd);
 
 	wdd->timeout = timeout;
+	timeout = clamp_t(unsigned int, timeout, 1, wdd->max_hw_heartbeat_ms / 1000);
 
 	if (action)
 		writel(gwdt->clk * timeout,
-- 
2.34.1

