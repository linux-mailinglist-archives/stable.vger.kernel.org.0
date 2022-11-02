Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2583615878
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiKBCw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiKBCw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:52:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9814E21E30
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:52:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49320B82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24504C433D6;
        Wed,  2 Nov 2022 02:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357542;
        bh=alPUrWCSwmW4u4Eqyv/HqxGTzhQjW/f1+OJpPPdcjMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4GlgceubnXthXwslE/d+TTPXzjMuAFgb6+5bi3V1zTYoVNfVjANcAaGXK0FRik9g
         ioIS2Lb9G6ZMJmoOphpRY9b/ePwIiUGw3vc2LrwtinwHqFP/Jz2I2tEzSkhDV6rBI3
         /c7sB7w8CVnKIbzXoyYCC1QaYEE/98zO9WLs/CPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Chao Song <chao.song@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 150/240] ASoC: SOF: Intel: pci-mtl: fix firmware name
Date:   Wed,  2 Nov 2022 03:32:05 +0100
Message-Id: <20221102022114.768562032@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 73189c064e11137c8b78a825800a374924ebb7b7 ]

Initial IPC4 tests used the same conventions as previous reference
closed-source firmware, but for MeteorLake the convention is the same
as previous SOF releases (sof-<platform>.ri). Only the prefix changes
to avoid confusions between IPC types.

This change has no impact on users since the firmware has not yet been
released.

Fixes: 064520e8aeaa2 ("ASoC: SOF: Intel: Add support for MeteorLake (MTL)")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Chao Song <chao.song@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20221017204004.207446-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-mtl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/pci-mtl.c b/sound/soc/sof/intel/pci-mtl.c
index 899b00d53d64..9f39da984e9f 100644
--- a/sound/soc/sof/intel/pci-mtl.c
+++ b/sound/soc/sof/intel/pci-mtl.c
@@ -38,7 +38,7 @@ static const struct sof_dev_desc mtl_desc = {
 		[SOF_INTEL_IPC4] = "intel/sof-ace-tplg",
 	},
 	.default_fw_filename = {
-		[SOF_INTEL_IPC4] = "dsp_basefw.bin",
+		[SOF_INTEL_IPC4] = "sof-mtl.ri",
 	},
 	.nocodec_tplg_filename = "sof-mtl-nocodec.tplg",
 	.ops = &sof_mtl_ops,
-- 
2.35.1



