Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E438189F66
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 16:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCRPOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 11:14:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbgCRPOa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 11:14:30 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E253A20770;
        Wed, 18 Mar 2020 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584544470;
        bh=EZUkoKU0rZzCl4pzeat8YdBrJ4bw+PahYglzmSel0uw=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=cFKhMCJiYK0q78PnulYDpAoMIrXlJ4t6EULPPqCulXLhXcVLzLZroAkNGrVHF6z6m
         FMw89VG4kyCpBTKN6gNCFkQsCELmwVeiw0LJNwvw7QprQDHpdsTceA0Z4LQI12M19a
         zVqFGGGJrF66hLDhjW0FutCJOwODTjOQdMMECEzk=
Date:   Wed, 18 Mar 2020 15:14:29 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
To:     tglx@linutronix.de, fenghua.yu@intel.com, bp@alien8.de
Cc:     mingo@redhat.com, hpa@zytor.com, kuo-lang.tseng@intel.com
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] x86/resctrl: Fix invalid attempt at removing default resource group
In-Reply-To: <884cbe1773496b5dbec1b6bd11bb50cffa83603d.1584461853.git.reinette.chatre@intel.com>
References: <884cbe1773496b5dbec1b6bd11bb50cffa83603d.1584461853.git.reinette.chatre@intel.com>
Message-Id: <20200318151429.E253A20770@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 334b0f4e9b1b ("x86/resctrl: Fix a deadlock due to inaccurate reference").

The bot has tested the following trees: v5.5.9, v5.4.25, v4.19.110, v4.14.173.

v5.5.9: Build OK!
v5.4.25: Build OK!
v4.19.110: Failed to apply! Possible dependencies:
    Unable to calculate

v4.14.173: Failed to apply! Possible dependencies:
    0b9aa6562650 ("x86/intel_rdt: Introduce test to determine if closid is in use")
    2244645ab194 ("x86/intel_rdt: Fix a silent failure when writing zero value schemata")
    472ef09b40c5 ("x86/intel_rdt: Associate mode with each RDT resource group")
    49f7b4efa110 ("x86/intel_rdt: Enable setting of exclusive mode")
    7604df6e16ae ("x86/intel_rdt: Support flexible data to parsing callbacks")
    95f0b77efa57 ("x86/intel_rdt: Initialize new resource group with sane defaults")
    9ab9aa15c309 ("x86/intel_rdt: Ensure requested schemata respects mode")
    9af4c0a6dc1a ("x86/intel_rdt: Making CBM name and type more explicit")
    cfd0f34e4cd5 ("x86/intel_rdt: Add diagnostics when making directories")
    d48d7a57f718 ("x86/intel_rdt: Introduce resource group's mode resctrl file")
    e0bdfe8e36f3 ("x86/intel_rdt: Support creation/removal of pseudo-locked region")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
