Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F24B2B9045
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 11:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgKSKjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 05:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgKSKjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 05:39:15 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5E2C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 02:39:14 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id d142so6682936wmd.4
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 02:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=80+4Cu0/IYrSCbaXx85nNopsZZ5hIWqGfnllTSnDOJA=;
        b=egiZXz38SOmBtPcDNgOxtYwPwctwCXxVRzzgX/ZCwVbwoGS3cShTsEiO8kX0T4iQjL
         +PRA6C4ACXMPpML40s/ZjgLZja3MtxBZrd38PqpHgzoukb+JsXSIOLyRUd7AW+ZQTs36
         y4FgMWIEr8lWWt1RhM21K6XppZlVo9U4hiLsMzJEqhr0MSGDDYU2xZkIwWGb3VQoh2q9
         7atSV6CLRxmmFsIKunASV4ZLEJqEkFP6MPe9QMFNYf9UKGBvO58S/cior286p2yA+M0O
         KbYfmfmt4PfYRk6+p6Bot++Egqav1mOu3EIFZqE84JP1bODMtbn+sZPDCUN0nrD4oyo4
         374g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=80+4Cu0/IYrSCbaXx85nNopsZZ5hIWqGfnllTSnDOJA=;
        b=B5L3wuocTNemhogawABNb3+8d4J/5LFdBb76pS6Q0xm6wtmDAquhuw9ms3PRdncvvJ
         g4o7OCQ0Ckap5IbvrshTa1eXvj1tgV/4EIldvZKRuaWXue3ymCboYYtfhmUKAelV1aE9
         k6e0y4s2E05N2PC/RLRjoNwVhJ2XnqrrR+mIH9ekRQ9LCO1sMhrkxfCAMU5IKPfhM4Rc
         eT+LZiFPnYi2qpm/o8rm5/qod1+v5eSR7yn+22DH6+3pFxL5JXgKpn87kFhDXzZdHFtG
         zcoEt6zmCKDNCzgCLzB3b1VzDuYb/wlmx1ZkQ56eEibKG5x1dNBnQiHuZ3qX2GacAHS/
         En5g==
X-Gm-Message-State: AOAM531MMjZPdpBaHD+PYKzNnk6QYnGVy8/PTms98A7eKUiy9VAsEeTR
        jF7bvl0usFhOwXuJsJ77nBw=
X-Google-Smtp-Source: ABdhPJwiuaC2zjajI2mYcm1DZ6zEhpgRy08MTjbETQKynMREyoQmIukWhu/1wQPW3zzTRUhPcdNEyQ==
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr4022760wma.100.1605782353613;
        Thu, 19 Nov 2020 02:39:13 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id a15sm38300379wrn.75.2020.11.19.02.39.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Nov 2020 02:39:13 -0800 (PST)
Date:   Thu, 19 Nov 2020 10:39:11 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org
Subject: patch for mips build failure in 5.4-stable
Message-ID: <20201119103911.rbqxmssqe2pqnli2@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zcn6wdq62rpeg6uv"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zcn6wdq62rpeg6uv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

While backporting 37640adbefd6 ("MIPS: PCI: remember nasid changed by
set interrupt affinity") something went wrong and an extra 'n' was added.
So 'data->nasid' became 'data->nnasid' and the MIPS builds started failing.

Since v5.4.78 is already released I assumed you will need a patch to
fix it. Please consider applying the attached patch, this is only needed
for 5.4-stable tree.

--
Regards
Sudip

--zcn6wdq62rpeg6uv
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-MIPS-PCI-Fix-MIPS-build.patch"

From 2711bea84e15a5a16d5ac694c9025890158a36dd Mon Sep 17 00:00:00 2001
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Thu, 19 Nov 2020 10:26:33 +0000
Subject: [PATCH v5.4.y] MIPS: PCI: Fix MIPS build

While backporting 37640adbefd6 ("MIPS: PCI: remember nasid changed by
set interrupt affinity") something went wrong and an extra 'n' was added.
So 'data->nasid' became 'data->nnasid' and the MIPS builds started failing.

This is only needed for 5.4-stable tree.

Fixes: 957978aa56f1 ("MIPS: PCI: remember nasid changed by set interrupt affinity")
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/mips/pci/pci-xtalk-bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/pci/pci-xtalk-bridge.c b/arch/mips/pci/pci-xtalk-bridge.c
index c4b1c6cf2660..adc9f83b2c44 100644
--- a/arch/mips/pci/pci-xtalk-bridge.c
+++ b/arch/mips/pci/pci-xtalk-bridge.c
@@ -284,7 +284,7 @@ static int bridge_set_affinity(struct irq_data *d, const struct cpumask *mask,
 	ret = irq_chip_set_affinity_parent(d, mask, force);
 	if (ret >= 0) {
 		cpu = cpumask_first_and(mask, cpu_online_mask);
-		data->nnasid = COMPACT_TO_NASID_NODEID(cpu_to_node(cpu));
+		data->nasid = COMPACT_TO_NASID_NODEID(cpu_to_node(cpu));
 		bridge_write(data->bc, b_int_addr[pin].addr,
 			     (((data->bc->intr_addr >> 30) & 0x30000) |
 			      bit | (data->nasid << 8)));
-- 
2.11.0


--zcn6wdq62rpeg6uv--
