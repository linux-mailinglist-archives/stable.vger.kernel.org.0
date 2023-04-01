Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3066D2C8B
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbjDABlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbjDABle (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:41:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B195F1D2CE;
        Fri, 31 Mar 2023 18:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F2B862CDB;
        Sat,  1 Apr 2023 01:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD509C433A1;
        Sat,  1 Apr 2023 01:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313292;
        bh=zmHMlZkDrPpx1Wfok0ivWN6Da1ds7nNySFg37LwKhB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=smg/Nw24xkWVqeXVv5m/DEqBRlUrEJ1yxpcT1yP+gH+5vzU/Emv225aSrWbyC6Q1o
         AwoyzaF/+YR/RLmMZyPQUFSj+vrw3dImnUYC4k7LIL3bntc0z7nXahoXW1yrbGv528
         gtjb3VoyfVJsAYSBUbO3gS7VzgujGmeD1WUlPkDMSajeH1xfg5gfYQdlC2oOwPs48Q
         hw6vHZtRnVNdw92GMUDRvX9YugfazLSo+QrxiAzmW8Th7CvUYfSQ2E7pFf2QbMphNx
         CoNXNBk94iHmeNulBo8NWrn3HTIG0sBicBiQesM7eJteKKy98tSFf/3Hy19Sx1sYJe
         2tTdK2wiwpXSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Masney <bmasney@redhat.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 03/25] arm64: dts: qcom: sa8540p-ride: correct name of remoteproc_nsp0 firmware
Date:   Fri, 31 Mar 2023 21:41:01 -0400
Message-Id: <20230401014126.3356410-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014126.3356410-1-sashal@kernel.org>
References: <20230401014126.3356410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
@@ -177,7 +177,7 @@ &qup2_uart17 {
 };
 
 &remoteproc_nsp0 {
-	firmware-name = "qcom/sa8540p/cdsp.mbn";
+	firmware-name = "qcom/sa8540p/cdsp0.mbn";
 	status = "okay";
 };
 
-- 
2.39.2

