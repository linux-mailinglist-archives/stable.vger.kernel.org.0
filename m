Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F127E14FF73
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 22:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgBBV4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 16:56:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbgBBV4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 Feb 2020 16:56:43 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03A242051A;
        Sun,  2 Feb 2020 21:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580680603;
        bh=h2AnbZ1zvtdRaW+7VGG5Kg0L6L5dvbqhPoz41PUcXgI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZARAdc5PDLtY/d96QpMLrHJEesapUwh7y5PLycAJoRcTHsr19LV6+0kreNhrSj6h3
         P4pbKyALeE508v09vQ7dHjHo6LoO5nNE9cs47QJLooSO4K42X3koSzI/KPI3r4URpA
         6BxH/qeVLAHTDUR+gciLM6X1HWf5256yxYz+IMaQ=
Date:   Sun, 2 Feb 2020 16:56:41 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Xiaochen Shen <xiaochen.shen@intel.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        tony.luck@intel.com, fenghua.yu@intel.com,
        reinette.chatre@intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, pei.p.jia@intel.com,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 4.19 1/3] x86/resctrl: Fix use-after-free when deleting
 resource groups
Message-ID: <20200202215641.GB1732@sasha-vm>
References: <1578500886-21771-1-git-send-email-xiaochen.shen@intel.com>
 <1580594537-2972-1-git-send-email-xiaochen.shen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1580594537-2972-1-git-send-email-xiaochen.shen@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 02, 2020 at 06:02:17AM +0800, Xiaochen Shen wrote:
>commit b8511ccc75c033f6d54188ea4df7bf1e85778740 upstream.
>
>A resource group (rdtgrp) contains a reference count (rdtgrp->waitcount)
>that indicates how many waiters expect this rdtgrp to exist. Waiters
>could be waiting on rdtgroup_mutex or some work sitting on a task's
>workqueue for when the task returns from kernel mode or exits.

I've queued up the 4.19 and 4.14 backports, thanks!

-- 
Thanks,
Sasha
