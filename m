Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E0D68103E
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbjA3OB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbjA3OBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EE43A585
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:01:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CF6AACE16B0
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975D9C433D2;
        Mon, 30 Jan 2023 14:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087266;
        bh=NR0SqMXAp+nRAi1elvyNt/Kjvl4IAPXoPMWgVbahtFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oH1kPtTA84F8nXDxyfGGmR0uQ+S8Q93F1/JDLk90g3S9J3c04u3JL/rVBtee35CBl
         lwC5AqL1EYmJa1EFB73ZjAwX5qhoEHL1VQ1Ok69woqVLlCwS4hxQjvplN8yuso38+e
         NcwXEoxL9LZ2z7xHcnA1zUuShz2EFz8m6CynJCe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mars Chen <chenxiangrui@huaqin.corp-partner.google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/313] ASoC: support machine driver with max98360
Date:   Mon, 30 Jan 2023 14:49:47 +0100
Message-Id: <20230130134343.734362104@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mars Chen <chenxiangrui@huaqin.corp-partner.google.com>

[ Upstream commit 810948f45d99c46b60852ef2a5a2777c12d6bb3e ]

Signed-off-by: Mars Chen <chenxiangrui@huaqin.corp-partner.google.com>
Link: https://lore.kernel.org/r/20221228103812.450956-1-chenxiangrui@huaqin.corp-partner.google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/mediatek/Kconfig b/sound/soc/mediatek/Kconfig
index 7bdb0ded831c..b027fba8233d 100644
--- a/sound/soc/mediatek/Kconfig
+++ b/sound/soc/mediatek/Kconfig
@@ -187,6 +187,7 @@ config SND_SOC_MT8186_MT6366_RT1019_RT5682S
 	depends on SND_SOC_MT8186 && MTK_PMIC_WRAP
 	select SND_SOC_MAX98357A
 	select SND_SOC_MT6358
+	select SND_SOC_MAX98357A
 	select SND_SOC_RT1015P
 	select SND_SOC_RT5682S
 	select SND_SOC_BT_SCO
-- 
2.39.0



