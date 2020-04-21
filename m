Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86DE1B30D2
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgDUT43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgDUT4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 15:56:20 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C22DE20767;
        Tue, 21 Apr 2020 19:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587498980;
        bh=mASEkWPK7FWW9aU02J2lqLHb4G2iGN+jgHa8JpDIg7Y=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=LTC7OrWpQCddkDaOdRTFEouZI52fOz6gZs+DPSoEg+jMZ9c+wUyflBgiuPqFWrBFY
         PCefbeowKqiKUY4Pwvf4te2CPFktegGKG0HMHrH4SV4o0YUrwK1MIuOzJ5zR1Kwvfo
         FUojaiB4y9TTIJ6dSZ3XEiIbGREKPbrqdZKWbxoU=
Date:   Tue, 21 Apr 2020 19:56:19 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "tip-bot2 for James Morse" <tip-bot2@linutronix.de>
To:     linux-tip-commits@vger.kernel.org
Cc:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [tip: x86/urgent] x86/resctrl: Preserve CDP enable over CPU hotplug
In-Reply-To: <158714555114.28353.8305275418595687988.tip-bot2@tip-bot2>
References: <158714555114.28353.8305275418595687988.tip-bot2@tip-bot2>
Message-Id: <20200421195619.C22DE20767@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support").

The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33, v4.19.116, v4.14.176.

v5.6.5: Build OK!
v5.5.18: Build OK!
v5.4.33: Build OK!
v4.19.116: Failed to apply! Possible dependencies:
    0f00717ecce4 ("x86/resctrl: Re-arrange the RDT init code")
    1ad4fa41d99f ("x86/resctrl: Initialize the vendor-specific resource functions")
    4d05bf71f157 ("x86/resctrl: Introduce AMD QOS feature")
    a36c5ff560fb ("x86/resctrl: Bring cbm_validate() into the resource structure")
    aa50453a448a ("x86/resctrl: Move all the macros to resctrl/internal.h")

v4.14.176: Failed to apply! Possible dependencies:
    0af6a48da481 ("x86/intel_rdt: Ensure RDT cleanup on exit")
    0f00717ecce4 ("x86/resctrl: Re-arrange the RDT init code")
    19c635ab24a1 ("x86/intel_rdt/mba_sc: Enable/disable MBA software controller")
    1ad4fa41d99f ("x86/resctrl: Initialize the vendor-specific resource functions")
    1bd2a63b4f0d ("x86/intel_rdt/mba_sc: Add initialization support")
    2244645ab194 ("x86/intel_rdt: Fix a silent failure when writing zero value schemata")
    472ef09b40c5 ("x86/intel_rdt: Associate mode with each RDT resource group")
    49f7b4efa110 ("x86/intel_rdt: Enable setting of exclusive mode")
    4d05bf71f157 ("x86/resctrl: Introduce AMD QOS feature")
    753694a8df31 ("x86/intel_rdt: Fix data type in parsing callbacks")
    7604df6e16ae ("x86/intel_rdt: Support flexible data to parsing callbacks")
    8205a078ba78 ("x86/intel_rdt/mba_sc: Add schemata support")
    99adde9b370d ("x86/intel_rdt: Enable L2 CDP in MSR IA32_L2_QOS_CFG")
    9ab9aa15c309 ("x86/intel_rdt: Ensure requested schemata respects mode")
    9af4c0a6dc1a ("x86/intel_rdt: Making CBM name and type more explicit")
    aa50453a448a ("x86/resctrl: Move all the macros to resctrl/internal.h")
    c377dcfbee80 ("x86/intel_rdt: Add diagnostics when writing the schemata file")
    d48d7a57f718 ("x86/intel_rdt: Introduce resource group's mode resctrl file")
    de73f38f7680 ("x86/intel_rdt/mba_sc: Feedback loop to dynamically update mem bandwidth")
    def10853930a ("x86/intel_rdt: Add two new resources for L2 Code and Data Prioritization (CDP)")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
