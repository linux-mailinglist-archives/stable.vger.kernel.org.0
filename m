Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5EAD15F095
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388328AbgBNP5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:57:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387899AbgBNP5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1060A2082F;
        Fri, 14 Feb 2020 15:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695858;
        bh=Vu0ngAKoMRzMfbfs/lL5eeluUpFL9hTnSNWHivquHeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6xLzULiRYUthKnPuK7ZlpYC0yqa1HfegvviMtmQ0VvhnuvOd5x0KQTeDqpVhgD5F
         AFv18IuSWvlZSeCNW9mZc07U9prFNSt036z5vdVcjSY8mQd+pWXw041NzKZRIoOqMn
         PBifk2229IOccr7BywUAFAhWqbQrhbXDUyrPfSSE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.5 406/542] ASoC: SOF: Intel: hda: Fix SKL dai count
Date:   Fri, 14 Feb 2020 10:46:38 -0500
Message-Id: <20200214154854.6746-406-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit a6947c9d86bcfd61b758b5693eba58defe7fd2ae ]

With fourth pin added for iDisp for skl_dai, update SOF_SKL_DAI_NUM to
account for the change. Without this, dais from the bottom of the list
are skipped. In current state that's the case for 'Alt Analog CPU DAI'.

Fixes: ac42b142cd76 ("ASoC: SOF: Intel: hda: Add iDisp4 DAI")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200113114054.9716-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda.h b/sound/soc/sof/intel/hda.h
index 63df888dddb6c..de0115294c74e 100644
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -348,7 +348,7 @@
 
 /* Number of DAIs */
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
-#define SOF_SKL_NUM_DAIS		14
+#define SOF_SKL_NUM_DAIS		15
 #else
 #define SOF_SKL_NUM_DAIS		8
 #endif
-- 
2.20.1

