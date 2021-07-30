Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46ED73DB820
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 13:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238687AbhG3L7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 07:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238617AbhG3L7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 07:59:40 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337A1C0613C1
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 04:59:35 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id x7so11982281ljn.10
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 04:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yz5kF6DMmS/F2Ek3OiwjPMR6AkCQ12zzDtN+t3btcmY=;
        b=nNzA7G+QrYsKDtYPp4WacLy0pohEOxM30ACTb4XbKW3I2FXUAj+/KdwmBEpqXmjgtX
         us0taLYD9bRwfc04SPEVa1FZmAHS3nK2tTlIEbcskWXKB2fNDETxxI17Fkh1bNiCy5NJ
         N5Nu2jjxXzXUc3B5JYuBvCwwA+bYaTcWp2fMtGzfVS93tTPtUilFf7GQG9EtvyImsUVE
         toTUBQeriz6HYnC7LtywE4XQcFkK92FXgIki5Lf1Gw1WqYGinguxOF/Ws1W+fFs2+46s
         ptfWooud7RXcYVe5oly8+zK2FlpbjY5Ghj+YUncF4XboU4DOGB4wPhlh/3o/M/xtavhQ
         TxKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yz5kF6DMmS/F2Ek3OiwjPMR6AkCQ12zzDtN+t3btcmY=;
        b=rDKjq1eTSqCYwMkliRuDdpghJCaGYWFsRUS6AAjoptFrNUkWbUipPGH7pGFBZW58s/
         jN67aytMF5bKr4rPvI/SxEVtUwpdun4qx2N8cBpoHdFV6BZjpgICgn2GYe+PPudKoemP
         HzhZKqkWiXywQJMsTv6maz8Nx69Rfa0bqrBtWrq20jlz//9qNJjDpTRwjFaE8nv935ZH
         NBJjtgEVrVXilx5ImyWlKNzs/m+xUuZxztV1+oogRVTZPTQP75qa/uOTveyLSseE4Qxs
         w+4aRGRk+5C/f9FvdTKyn0Gnzgxic+iheYBuMECinVBmzkhuL2HGCBX4AQsaKd0sR9fi
         XQCg==
X-Gm-Message-State: AOAM533YhUR0tM6Ohj0hYcDti8qXoV2rwUfLpINaboFTual7BlUp+Nyu
        Yvm/vlwYNAUC8h4zETIQcqZ48g==
X-Google-Smtp-Source: ABdhPJxdLp3s/e9v5mAJRhkjnsGH+Ro2Aomhtvu0FFU8OH3ojilQ7WiMkXMAIcyREE+yS4IO3qKGOg==
X-Received: by 2002:a2e:a817:: with SMTP id l23mr1441919ljq.86.1627646373566;
        Fri, 30 Jul 2021 04:59:33 -0700 (PDT)
Received: from lmajczak1-l.roam.corp.google.com ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id p16sm134034lfr.122.2021.07.30.04.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 04:59:32 -0700 (PDT)
From:   Lukasz Majczak <lma@semihalf.com>
To:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     upstream@semihalf.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Lukasz Majczak <lma@semihalf.com>,
        stable@vger.kernel.org
Subject: [PATCH v1] ASoC: Intel: kbl_da7219_max98357a: fix drv_name
Date:   Fri, 30 Jul 2021 13:59:06 +0200
Message-Id: <20210730115906.144300-1-lma@semihalf.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

platform_id for kbl_da7219_max98357a was shrunk for kbl_da7219_mx98357a,
but the drv_name was changed for kbl_da7219_max98373. Tested on a
Pixelbook (Atlas).

Fixes: 94efd726b947 ("ASoC: Intel: kbl_da7219_max98357a: shrink platform_id below 20 characters")
Cc: <stable@vger.kernel.org> # 5.4+
Reported-by: Cezary Rojewski <cezary.rojewski@intel.com>
Tested-by: Lukasz Majczak <lma@semihalf.com>
Signed-off-by: Lukasz Majczak <lma@semihalf.com>
---
 sound/soc/intel/common/soc-acpi-intel-kbl-match.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
index ba5ff468c265..8cab91a00b1a 100644
--- a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
@@ -87,7 +87,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_kbl_machines[] = {
 	},
 	{
 		.id = "DLGS7219",
-		.drv_name = "kbl_da7219_max98357a",
+		.drv_name = "kbl_da7219_mx98357a",
 		.fw_filename = "intel/dsp_fw_kbl.bin",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &kbl_7219_98357_codecs,
@@ -113,7 +113,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_kbl_machines[] = {
 	},
 	{
 		.id = "DLGS7219",
-		.drv_name = "kbl_da7219_mx98373",
+		.drv_name = "kbl_da7219_max98373",
 		.fw_filename = "intel/dsp_fw_kbl.bin",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &kbl_7219_98373_codecs,
-- 
2.32.0.554.ge1b32706d8-goog

