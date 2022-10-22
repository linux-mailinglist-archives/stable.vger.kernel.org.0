Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DF0608B3B
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJVKF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiJVKFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:05:23 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B062F273D
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 02:21:17 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id l22so14165589edj.5
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 02:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cylK/OEMCifoEIA9sQqvZZkUFQ0EveEt5GLUa/e5etU=;
        b=gUeAqFOBTgqw6voPbDchqkb7Rb878AksHbOQn7HsZNCrYxwoZ5Z8hQwR+srj7DQ9Wp
         0cFodEfw/LuoXs/LM/LCfYAQdv5jvU+0HjH4xgcw18luQyA5QcEghwKQlq7nrrUXgvtd
         wmGuRjsEekzMeDcXAlZNoiu9OLlVKMMmjF8m1unUD3tsyvS2JWUmN9z48CPWnzPfKsnZ
         EpsKc4rpZpFgeCx/xgJcXVNyHHEfMOkcqexa5Kf/HSdBBiZpuqpsgsdHlSODU1G21WKc
         vGaA3BXisjdC7uab3VCKz7YauNoC7EZZ8xq1KDosHWOqH4H6FTJTOSjqpq3qoHWkk4af
         0o4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cylK/OEMCifoEIA9sQqvZZkUFQ0EveEt5GLUa/e5etU=;
        b=K62xk6SbaexXT+Bphj4mDY8meZ8QN6agf+ban7JEYI9pemRmlfr/zY3yH/uTgV212s
         RGQj4nxEhiY7ZgPARaJM0iGzlFPF+kAMMtcyaoOYBuLoSp2Xrin/rTaVltZs437c/J8C
         ing1vosjq/b5YqeUgQ6SrjAGVywoM0EDNn3n8BYHWDgqV8oSQhXGTdd2P3UbuBfPAYAK
         UDlKuQ7rmb0p0PLw3waZfvKQU/qUM484GhLGTrUnm7yXMiZbhMdAJA75lOpmZ1YtCiNu
         MSsCH0o7YImzqXKX/Huy1C1iB8OxnZcRHpecT/RCWdSgjchDa05ymgHwoRnO7uy6T2qG
         Tx6w==
X-Gm-Message-State: ACrzQf30B23nZ1Zzx2m6GwHjynxNfgZPJ1Lz9ozA24/eaXsg98dnQqaN
        /u8cnc4kXWMzSJUcKuFFG7E=
X-Google-Smtp-Source: AMsMyM7zkV4l3E3s2KOzpwXWEtZ2BFze1aqK6rImxn+nLgtTSaZfUb18BwAupLIc5qTQ/zCWSgtqJw==
X-Received: by 2002:a05:6402:4282:b0:459:befa:c79c with SMTP id g2-20020a056402428200b00459befac79cmr21778319edc.23.1666430400224;
        Sat, 22 Oct 2022 02:20:00 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id p7-20020a170906784700b0078d9e26db54sm12751699ejm.88.2022.10.22.02.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 02:19:59 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id B344BBE2DE0; Sat, 22 Oct 2022 11:19:58 +0200 (CEST)
Date:   Sat, 22 Oct 2022 11:19:58 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Diederik de Haas <didi.debian@cknow.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 1/2] Revert "drm/amdgpu: move nbio sdma_doorbell_range()
 into sdma code for vega"
Message-ID: <Y1O1vpMA1tnrqtnd@eldamar.lan>
References: <20221020153857.565160-1-alexander.deucher@amd.com>
 <2651645.mvXUDI8C0e@bagend>
 <Y1I4rC37gwl367rt@eldamar.lan>
 <Y1OeLv/OmfR431tL@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1OeLv/OmfR431tL@kroah.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Sat, Oct 22, 2022 at 09:39:26AM +0200, Greg KH wrote:
> On Fri, Oct 21, 2022 at 08:14:04AM +0200, Salvatore Bonaccorso wrote:
> > Hi,
> > 
> > On Fri, Oct 21, 2022 at 02:29:22AM +0200, Diederik de Haas wrote:
> > > On Thursday, 20 October 2022 17:38:56 CEST Alex Deucher wrote:
> > > > This reverts commit 9f55f36f749a7608eeef57d7d72991a9bd557341.
> > > > 
> > > > This patch was backported incorrectly when Sasha backported it and
> > > > the patch that caused the regression that this patch set fixed
> > > > was reverted in commit 412b844143e3 ("Revert "PCI/portdrv: Don't disable AER
> > > > reporting in get_port_device_capability()""). This isn't necessary and
> > > > causes a regression so drop it.
> > > > 
> > > > Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2216
> > > > Cc: Shuah Khan <skhan@linuxfoundation.org>
> > > > Cc: Sasha Levin <sashal@kernel.org>
> > > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > > Cc: <stable@vger.kernel.org>    # 5.10
> > > > ---
> > > 
> > > I build a kernel with these 2 patches reverted and can confirm that that fixes 
> > > the issue on my machine with a Radeon RX Vega 64 GPU. 
> > > # lspci -nn | grep VGA
> > > 0b:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/
> > > ATI] Vega 10 XL/XT [Radeon RX Vega 56/64] [1002:687f] (rev c1)
> > > 
> > > So feel free to add
> > > 
> > > Tested-By: Diederik de Haas <didi.debian@cknow.org>
> > 
> > Note additionally (probably only relevant for Greg while reviewing),
> > that the first of the commits which need to be reverted is already
> > queued as revert in queue-5.10.
> 
> Yeah, this series does not apply to the current 5.10 queue at all.
> 
> And I am totally confused as to what to do here.
> 
> Can someone please just send me a set of patches, on top of the current
> 5.10 stable queue that works?  Or just wait for after the next 5.10.y
> release next week and then send me a working set of patches if you don't
> like to mess with the queue format?

The problem is "only" that the first of the commits is already present
in the queue, as 1bd9462d17de ("Revert "drm/amdgpu: move nbio
sdma_doorbell_range() into sdma code for vega"") but with different
commit message (the one from Alex Deucher would have the advantage to
have as well reference to the upstream bug at
https://gitlab.freedesktop.org/drm/amd/-/issues/2216 .

The second commit applies then cleanly on top, so the following
inlined here in the message.

Regards,
Salvatore

From 6a0b925deb55c5a0b5a27cb4a05b73f4663451a8 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Thu, 20 Oct 2022 11:38:57 -0400
Subject: [PATCH] Revert "drm/amdgpu: make sure to init common IP before gmc"

This reverts commit 7b0db849ea030a70b8fb9c9afec67c81f955482e.

The patches that this patch depends on were not backported properly
and the patch that caused the regression that this patch set fixed
was reverted in commit 412b844143e3 ("Revert "PCI/portdrv: Don't disable AER reporting in get_port_device_capability()"").
This isn't necessary and causes a regression so drop it.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2216
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: <stable@vger.kernel.org>    # 5.10
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 881045e600af..bde0496d2f15 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2179,16 +2179,8 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 		}
 		adev->ip_blocks[i].status.sw = true;
 
-		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_COMMON) {
-			/* need to do common hw init early so everything is set up for gmc */
-			r = adev->ip_blocks[i].version->funcs->hw_init((void *)adev);
-			if (r) {
-				DRM_ERROR("hw_init %d failed %d\n", i, r);
-				goto init_failed;
-			}
-			adev->ip_blocks[i].status.hw = true;
-		} else if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC) {
-			/* need to do gmc hw init early so we can allocate gpu mem */
+		/* need to do gmc hw init early so we can allocate gpu mem */
+		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC) {
 			/* Try to reserve bad pages early */
 			if (amdgpu_sriov_vf(adev))
 				amdgpu_virt_exchange_data(adev);
@@ -2770,8 +2762,8 @@ static int amdgpu_device_ip_reinit_early_sriov(struct amdgpu_device *adev)
 	int i, r;
 
 	static enum amd_ip_block_type ip_order[] = {
-		AMD_IP_BLOCK_TYPE_COMMON,
 		AMD_IP_BLOCK_TYPE_GMC,
+		AMD_IP_BLOCK_TYPE_COMMON,
 		AMD_IP_BLOCK_TYPE_PSP,
 		AMD_IP_BLOCK_TYPE_IH,
 	};
-- 
2.37.2

