Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1E86C19DC
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbjCTPi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbjCTPie (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:38:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9B432CFE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F3E3615B5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E133C433EF;
        Mon, 20 Mar 2023 15:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326208;
        bh=62G/6AdynoJAd7w+6OeKg/KOrFMUmBDePttx/yDqOL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKN/zR+brQ5bTvnNIiS6mFCsJ+8Sse2cVex2Q3pHJaxZd11RMrlKk1ngv56iwsbUq
         L5Nc2P6U8aGPxTJCpI0yIpI/mIU0iVwpJNQwNMkARb3EXwSHYAYnKdzAL7atOWiNWR
         uB1sL/+XryLI6i0alvBLYOfj3+nxx5fZinAGPXFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.2 199/211] ASoC: Intel: soc-acpi: fix copy-paste issue in topology names
Date:   Mon, 20 Mar 2023 15:55:34 +0100
Message-Id: <20230320145521.877033758@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 858a438a6cf919e5727d2a0f5f3f0e68b2d5354e upstream.

For some reason the convention for topology names was not followed and
the name inspired by another unrelated hardware configuration. As a
result, the kernel will request a non-existent topology file.

Link: https://github.com/thesofproject/sof/pull/6878
Fixes: 2ec8b081d59f ("ASoC: Intel: soc-acpi: Add entry for sof_es8336 in ADL match table")
Cc: stable@vger.kernel.org
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307100733.15025-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/common/soc-acpi-intel-adl-match.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/common/soc-acpi-intel-adl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
@@ -559,7 +559,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_in
 	{
 		.comp_ids = &essx_83x6,
 		.drv_name = "sof-essx8336",
-		.sof_tplg_filename = "sof-adl-es83x6", /* the tplg suffix is added at run time */
+		.sof_tplg_filename = "sof-adl-es8336", /* the tplg suffix is added at run time */
 		.tplg_quirk_mask = SND_SOC_ACPI_TPLG_INTEL_SSP_NUMBER |
 					SND_SOC_ACPI_TPLG_INTEL_SSP_MSB |
 					SND_SOC_ACPI_TPLG_INTEL_DMIC_NUMBER,


