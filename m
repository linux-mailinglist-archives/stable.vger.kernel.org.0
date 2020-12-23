Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0B62E15FE
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgLWC4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:56:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:49690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbgLWCU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D01D2222D;
        Wed, 23 Dec 2020 02:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690016;
        bh=KuOG9RquJ7QFLzwKgzbgeMWHTrQstCtDKvaba1UF2F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r4zNmavUNxKGJ/637KEW/wFZB6L9C0QCFgJ5u76mLzg4XjrYxLLbOWSGe+P85U5gW
         dxG4biRO5nVJAfvsnHN0pJptD+OfungOfHiifVtXd9EXyTmnoEC8WZTEcIuiVX93V+
         6iXrAFyF/p5CD3TWW0DUFURt/q4HjMMEUgPW60Gt4rxBSMhbKbgv5one+pQy8DGmsc
         hnSdJto7inHS/5mwjAcurd1q2fxaHjqEki56z5Ua0xPXFggQqXQP4hoKmAui0NlVXl
         9UY2zceeEhUmLHmk69H9mLwPGcMrhEwJ7dQzyPutIiz8JTLrk4x4pSePzIryF+Avh1
         +67D/H8eHOM9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 095/130] ASoC: Intel: cht_bsw_nau8824: Change SSP2-Codec DAI id to 0
Date:   Tue, 22 Dec 2020 21:17:38 -0500
Message-Id: <20201223021813.2791612-95-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 748e72e869718db8d735d773040bce95158c98c6 ]

The snd-soc-sst-acpi driver does not care about the id specified for
the SSP2-Codec DAI, but it does matter for the snd-sof-acpi driver;
and when it is not 0 then the snd-sof-acpi driver does not work.

Set the SSP2-Codec DAI id to 0, fixing the snd-sof-acpi driver not
working on devices using the cht_bsw_nau8824 machine-driver.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20201206122436.13553-3-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/cht_bsw_nau8824.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/cht_bsw_nau8824.c b/sound/soc/intel/boards/cht_bsw_nau8824.c
index 501bad3976fbf..bea1372b416e2 100644
--- a/sound/soc/intel/boards/cht_bsw_nau8824.c
+++ b/sound/soc/intel/boards/cht_bsw_nau8824.c
@@ -218,7 +218,7 @@ static struct snd_soc_dai_link cht_dailink[] = {
 	{
 		/* SSP2 - Codec */
 		.name = "SSP2-Codec",
-		.id = 1,
+		.id = 0,
 		.no_pcm = 1,
 		.dai_fmt = SND_SOC_DAIFMT_DSP_B | SND_SOC_DAIFMT_IB_NF
 			| SND_SOC_DAIFMT_CBS_CFS,
-- 
2.27.0

