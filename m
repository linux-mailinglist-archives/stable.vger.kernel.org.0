Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E370E3C4AC8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240297AbhGLGxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238732AbhGLGw3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:52:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54FBD6102A;
        Mon, 12 Jul 2021 06:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072578;
        bh=R56nexJ50c1g/+/yiqHA9rIQh+nevdNhStN7n3KpBo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goDhAxDU9ANXeGGo3OCtkJsm2IBiCdDd84Z91sO7VOPmX0A1ymh/0qjawlDEeN4Me
         1d6cU2G+4adXXjlcyAPBVOPo+k75C8ecIenqNIIlgoNLtwQCId8/8ojDCKYTA1n0P+
         JDwqc+WyyuJhy1WQAN2sj9wdn/sExQmLYs3qdxBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bard Liao <bard.liao@intel.com>,
        Libin Yang <libin.yang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 544/593] ASoC: Intel: sof_sdw: add SOF_RT715_DAI_ID_FIX for AlderLake
Date:   Mon, 12 Jul 2021 08:11:44 +0200
Message-Id: <20210712060953.914998420@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Libin Yang <libin.yang@intel.com>

[ Upstream commit 81cd42e5174ba7918edd3d006406ce21ebaa8507 ]

AlderLake needs the flag SOF_RT715_DAI_ID_FIX if it is using the
rt715 DMIC.

Reviewed-by: Bard Liao <bard.liao@intel.com>
Signed-off-by: Libin Yang <libin.yang@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210505163705.305616-11-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 9dc982c2c776..75a0bfedb449 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -196,6 +196,7 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(SOF_RT711_JD_SRC_JD1 |
 					SOF_SDW_TGL_HDMI |
+					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_PCH_DMIC),
 	},
 	{}
-- 
2.30.2



