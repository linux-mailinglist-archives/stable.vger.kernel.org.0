Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCAD6AE83E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCGRO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjCGROE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:14:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E87199C5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:08:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A50D2B81995
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D010CC433EF;
        Tue,  7 Mar 2023 17:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208926;
        bh=NwQiBQacQW3S26AJF4rEXIwNfdC5kN+/EbGh9fijTA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJ5AOH8YkctNVbhsCbaiMTCdoej/p2XrPR/JP01dgxxwDpOLEHKO5HdRRUTQjXhRr
         hbFP2g2UpxG3vyTtQ8TMrPYCKu/19je/ZuNy5B9sQY1iEXkPZ8KWVyIHKxaxIWncXa
         3knrp345w40QBmJlYGTkERtle7Cat9uCkhpdv+h4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Petr Vorel <petr.vorel@gmail.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0053/1001] arm64: dts: qcom: msm8992-bullhead: Disable dfps_data_mem
Date:   Tue,  7 Mar 2023 17:47:05 +0100
Message-Id: <20230307170024.427114028@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Vorel <petr.vorel@gmail.com>

[ Upstream commit 4dee5aa44b924036511a744ceb3abb1ceeb96bb6 ]

It's disabled on downstream [1] thus not shown on downstream dmesg.

Removing it fixes warnings on v6.1:

[    0.000000] OF: reserved mem: OVERLAP DETECTED!
[    0.000000] dfps_data_mem@3400000 (0x0000000003400000--0x0000000003401000) overlaps with memory@3400000 (0x0000000003400000--0x0000000004600000)

[1] https://android.googlesource.com/kernel/msm.git/+/android-7.0.0_r0.17/arch/arm64/boot/dts/lge/msm8992-bullhead.dtsi#137

Fixes: 976d321f32dc ("arm64: dts: qcom: msm8992: Make the DT an overlay on top of 8994")

Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221226185440.440968-3-pevik@seznam.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
index 123ec67fb385a..4bceb362a5c02 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
@@ -15,6 +15,9 @@
 /* cont_splash_mem has different memory mapping */
 /delete-node/ &cont_splash_mem;
 
+/* disabled on downstream, conflicts with cont_splash_mem */
+/delete-node/ &dfps_data_mem;
+
 / {
 	model = "LG Nexus 5X";
 	compatible = "lg,bullhead", "qcom,msm8992";
-- 
2.39.2



