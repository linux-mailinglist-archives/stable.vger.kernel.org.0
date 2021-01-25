Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC323304B55
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbhAZErU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:47:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729159AbhAYSn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D33922D50;
        Mon, 25 Jan 2021 18:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600219;
        bh=PGuMs4WIllYlMcEsKh2EnKnF4jCyBPRhs34xat9Jk1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tw2/S0qJxDESqNTDHTeWqpU/EvtHmvF+Up7OjP99NFPjM02gqwDs8twrV2Nbkgymk
         nxpYqzOc6rIeoaXZnyCzaIelteCabIVFP2Ypk/5oZKmT92TdgVy1YPe6uTPK5RJmPs
         ej3hQb682Gxm5i+MC8+tXAgd0c3WOXTF9HjBe7mI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/86] ASoC: Intel: haswell: Add missing pm_ops
Date:   Mon, 25 Jan 2021 19:39:00 +0100
Message-Id: <20210125183201.820157667@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit bb224c3e3e41d940612d4cc9573289cdbd5cb8f5 ]

haswell machine board is missing pm_ops what prevents it from undergoing
suspend-resume procedure successfully. Assign default snd_soc_pm_ops so
this is no longer the case.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20201217105401.27865-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/haswell.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/haswell.c b/sound/soc/intel/boards/haswell.c
index 3dadf9bff796a..cf47fd9cd506b 100644
--- a/sound/soc/intel/boards/haswell.c
+++ b/sound/soc/intel/boards/haswell.c
@@ -206,6 +206,7 @@ static struct platform_driver haswell_audio = {
 	.probe = haswell_audio_probe,
 	.driver = {
 		.name = "haswell-audio",
+		.pm = &snd_soc_pm_ops,
 	},
 };
 
-- 
2.27.0



