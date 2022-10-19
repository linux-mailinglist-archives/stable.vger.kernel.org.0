Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C473603F83
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiJSJb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbiJSJ3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:29:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CFCC4C33;
        Wed, 19 Oct 2022 02:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6AC861777;
        Wed, 19 Oct 2022 09:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7F3C433D7;
        Wed, 19 Oct 2022 09:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170782;
        bh=rpwhqAxu7g2q3YqyG2REyODVriYQxeZ1tyF0riBzRNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x//n5qfILYRUokPXkE+XF3EpQtCLzTnjAaVW00UFqQh4oOD/1X0kglJJ+yJKbCoS0
         4S9ETAxsgQPmllSUF3Ag6qUFkomAaepxyiYMOpDwnmd1eQx4Byp6av7TofPEFRNqjX
         N94VVlEgaGOKRhe2P6yOioOeQqNV7sYOPBQYhOns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Muralidhar Reddy <muralidhar.reddy@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 750/862] ALSA: intel-dspconfig: add ES8336 support for AlderLake-PS
Date:   Wed, 19 Oct 2022 10:33:57 +0200
Message-Id: <20221019083323.060211380@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muralidhar Reddy <muralidhar.reddy@intel.com>

[ Upstream commit 9db1c9fa214ef41d098633ff40a87284ca6e1870 ]

added quirks for ESS8336 for AlderLake-PS

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Muralidhar Reddy <muralidhar.reddy@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220919114548.42769-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 5a478649f338..b9eb3208f288 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -427,6 +427,11 @@ static const struct config_entry config_table[] = {
 		.device = 0x51cd,
 	},
 	/* Alderlake-PS */
+	{
+		.flags = FLAG_SOF,
+		.device = 0x51c9,
+		.codec_hid =  &essx_83x6,
+	},
 	{
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = 0x51c9,
-- 
2.35.1



