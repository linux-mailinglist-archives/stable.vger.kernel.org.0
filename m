Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55528593F9C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345354AbiHOUqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345977AbiHOUpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:45:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCD4B69F0;
        Mon, 15 Aug 2022 12:08:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12179B810A3;
        Mon, 15 Aug 2022 19:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59607C433C1;
        Mon, 15 Aug 2022 19:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590506;
        bh=7+4TTr1XgtVkKwsjolZt4mKrV4XkFbm+qewfYpPUtQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOyojdbeTtl0ETxdJHm7z0pIxdZAGaQHaxA+kB9Uo2u9BvDTYnmaNp2Mt4QzPJmMQ
         Q73H/JevF5WyzJALoeD2XjQzFUXPjVJvOSN+1VSPLxaTa6000G9CrFXzAkj8bXLE+p
         MFVEquh3Mj3d/eBxdt6Fs9jYQkjCbvO4vc6yCZkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Parikshit Pareek <quic_ppareek@quicinc.com>,
        Eric Chanudet <echanude@redhat.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0281/1095] soc: qcom: socinfo: Fix the id of SA8540P SoC
Date:   Mon, 15 Aug 2022 19:54:40 +0200
Message-Id: <20220815180441.409785368@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parikshit Pareek <quic_ppareek@quicinc.com>

[ Upstream commit 5bed21af0005cc7d8bb05d2c4a63afbcede23382 ]

Change the id of SA8540P to its correct value, i.e., 461.
Also, map the id 460 to its correct values, i.e. SA8295P.

Fixes: 76ee15ae1b13 ("soc: qcom: socinfo: Add some more PMICs and SoCs")
Signed-off-by: Parikshit Pareek <quic_ppareek@quicinc.com>
Reviewed-by: Eric Chanudet <echanude@redhat.com>
Tested-by: Eric Chanudet <echanude@redhat.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220711083957.12091-1-quic_ppareek@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/socinfo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index 8b38d134720a..f6879983da69 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -328,7 +328,8 @@ static const struct soc_id soc_id[] = {
 	{ 455, "QRB5165" },
 	{ 457, "SM8450" },
 	{ 459, "SM7225" },
-	{ 460, "SA8540P" },
+	{ 460, "SA8295P" },
+	{ 461, "SA8540P" },
 	{ 480, "SM8450" },
 };
 
-- 
2.35.1



