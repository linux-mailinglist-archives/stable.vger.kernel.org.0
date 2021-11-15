Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B36451F0C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352903AbhKPAiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344492AbhKOTYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1956A63493;
        Mon, 15 Nov 2021 18:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002717;
        bh=Kb315VE26z33mFaA9+Vy/v4kc7EakvMWO1nTpfHe6EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzkYNsSoevoI4gin66MOSJ5yF2OC2dDRjOnJAgEkxGPKGbAqqYxgTFW4JXul2I8Is
         DARi0SlI0f5x1LHrOC0RAxZZCz0PMqWYlzHsJq5uq3ZYQ/OPawVjIS9oQF+BXJHPkW
         iF3arfrjes5Zb/nk9dP8hhSgJO2V8owWapxB/bJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 664/917] ASoC: topology: Fix stub for snd_soc_tplg_component_remove()
Date:   Mon, 15 Nov 2021 18:02:39 +0100
Message-Id: <20211115165451.403245075@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 1198ff12cbdd5f42c032cba1d96ebc7af8024cf9 ]

When removing the index argument from snd_soc_topology_component_remove()
commit a5b8f71c5477f (ASoC: topology: Remove multistep topology loading)
forgot to update the stub for !SND_SOC_TOPOLOGY use, causing build failures
for anything that tries to make use of it.

Fixes: a5b8f71c5477f (ASoC: topology: Remove multistep topology loading)
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20211025154844.2342120-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-topology.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/sound/soc-topology.h b/include/sound/soc-topology.h
index 4afd667e124c2..3e8a85e1e8094 100644
--- a/include/sound/soc-topology.h
+++ b/include/sound/soc-topology.h
@@ -188,8 +188,7 @@ int snd_soc_tplg_widget_bind_event(struct snd_soc_dapm_widget *w,
 
 #else
 
-static inline int snd_soc_tplg_component_remove(struct snd_soc_component *comp,
-						u32 index)
+static inline int snd_soc_tplg_component_remove(struct snd_soc_component *comp)
 {
 	return 0;
 }
-- 
2.33.0



