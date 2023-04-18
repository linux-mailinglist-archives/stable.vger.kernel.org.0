Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988086E649E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjDRMu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbjDRMu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:50:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9026916B2C
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:50:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06C9663424
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E4BC433EF;
        Tue, 18 Apr 2023 12:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822243;
        bh=z9o7Gy80xuXBJVjJC/gwCeXN5TON0qeLJDJlfxt07A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+t/nV11nf0Ez8pIjA1k1x1NeUB94fqRc2JzgE1BMPGsDOTUGZXqhyAfQUkh4Q2SW
         IDPw1dSys61q6yTj2QftUb0DY4bZlWVvb/ISNu3NLgnnkzpLLmia+VaTwzEvN+I0An
         Hawns9VkXBWQKXYIe+uitl9jXWYuVxKEeeTPbKO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Masney <bmasney@redhat.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 077/139] arm64: dts: qcom: sa8540p-ride: correct name of remoteproc_nsp0 firmware
Date:   Tue, 18 Apr 2023 14:22:22 +0200
Message-Id: <20230418120316.738352584@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit b891251b40d4dc4cfd28341f62f6784c02ad3a78 ]

The cdsp.mbn firmware that's referenced in sa8540p-ride.dts is actually
named cdsp0.mbn in the deliverables from Qualcomm. Let's go ahead and
correct the name to match what's in Qualcomm's deliverable.

Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230307232340.2370476-1-bmasney@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8540p-ride.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
index 6c547f1b13dc4..0f560a4661eba 100644
--- a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
+++ b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
@@ -177,7 +177,7 @@
 };
 
 &remoteproc_nsp0 {
-	firmware-name = "qcom/sa8540p/cdsp.mbn";
+	firmware-name = "qcom/sa8540p/cdsp0.mbn";
 	status = "okay";
 };
 
-- 
2.39.2



