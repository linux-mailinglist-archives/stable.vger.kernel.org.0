Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B10D35BD80
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbhDLIv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238478AbhDLIt4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB1B66109E;
        Mon, 12 Apr 2021 08:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217352;
        bh=+spV6gVCOM3871GDKFM07AW5rRDU50KMJoiElwIWpiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9qfyhb6VEMxv/z6FdFhn6//yUbJULUbHFqsStarBfBEhv2/+CvKGD5Qz0G4kgN4K
         qxBavGPy2MQhrDRArl+WL3shO3Fp7gFM9GS0l0igGz0yNJPH6peLXIArpaGtQmVSmS
         HAwr6V1LjbpR+zHDPu27DgQPZfe71QNH3WbBZ2gA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Payal Kshirsagar <payalskshirsagar1234@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/111] ASoC: SOF: Intel: hda: remove unnecessary parentheses
Date:   Mon, 12 Apr 2021 10:40:27 +0200
Message-Id: <20210412084005.892418133@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Payal Kshirsagar <payalskshirsagar1234@gmail.com>

[ Upstream commit 805a23de2657c10c2ca96588a309a42df947bb36 ]

Remove unnecessary parentheses around the right hand side of an assignment
and align the code.

Signed-off-by: Payal Kshirsagar <payalskshirsagar1234@gmail.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200409184853.15896-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dsp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sof/intel/hda-dsp.c b/sound/soc/sof/intel/hda-dsp.c
index 94b093b370e2..d4c7160717c7 100644
--- a/sound/soc/sof/intel/hda-dsp.c
+++ b/sound/soc/sof/intel/hda-dsp.c
@@ -192,10 +192,10 @@ bool hda_dsp_core_is_enabled(struct snd_sof_dev *sdev,
 
 	val = snd_sof_dsp_read(sdev, HDA_DSP_BAR, HDA_DSP_REG_ADSPCS);
 
-	is_enable = ((val & HDA_DSP_ADSPCS_CPA_MASK(core_mask)) &&
-			(val & HDA_DSP_ADSPCS_SPA_MASK(core_mask)) &&
-			!(val & HDA_DSP_ADSPCS_CRST_MASK(core_mask)) &&
-			!(val & HDA_DSP_ADSPCS_CSTALL_MASK(core_mask)));
+	is_enable = (val & HDA_DSP_ADSPCS_CPA_MASK(core_mask)) &&
+		    (val & HDA_DSP_ADSPCS_SPA_MASK(core_mask)) &&
+		    !(val & HDA_DSP_ADSPCS_CRST_MASK(core_mask)) &&
+		    !(val & HDA_DSP_ADSPCS_CSTALL_MASK(core_mask));
 
 	dev_dbg(sdev->dev, "DSP core(s) enabled? %d : core_mask %x\n",
 		is_enable, core_mask);
-- 
2.30.2



