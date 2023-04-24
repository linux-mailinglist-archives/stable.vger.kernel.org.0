Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB1A6ECE94
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbjDXNdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjDXNdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:33:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01DA7AB0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:33:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81CE762363
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90953C433EF;
        Mon, 24 Apr 2023 13:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343182;
        bh=mQF/e1PYqVooFHxlUefpRDrqwcJsaAT6/dZxM10n0a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcgowC8a6kg5ncWjXOvlkcim7+K6GAITnYSRzAlrqixUuZ2r9wZL/xku8BmD7D3Gu
         0Pf5f6lChnC28yUi+dUsgp8kX8FATV8qKFbUcxodn98zfurNBh2mwvQrKpiSAlGN5Q
         bNT6OWMYoH/8lddhv9hoRgFLQbz9qlIYLpB5WsvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chancel Liu <chancel.liu@nxp.com>,
        Shengjiu Wang <shengjiu.wang@gmail.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.2 109/110] ASoC: fsl_sai: Fix pins setting for i.MX8QM platform
Date:   Mon, 24 Apr 2023 15:18:11 +0200
Message-Id: <20230424131140.716213399@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chancel Liu <chancel.liu@nxp.com>

commit 238787157d83969e5149c8e99787d5d90e85fbe5 upstream.

SAI on i.MX8QM platform supports the data lines up to 4. So the pins
setting should be corrected to 4.

Fixes: eba0f0077519 ("ASoC: fsl_sai: Enable combine mode soft")
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Link: https://lore.kernel.org/r/20230418094259.4150771-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_sai.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1543,7 +1543,7 @@ static const struct fsl_sai_soc_data fsl
 	.use_imx_pcm = true,
 	.use_edma = true,
 	.fifo_depth = 64,
-	.pins = 1,
+	.pins = 4,
 	.reg_offset = 0,
 	.mclk0_is_mclk1 = false,
 	.flags = 0,


