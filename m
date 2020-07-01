Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0908621138E
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 21:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgGATda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 15:33:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbgGATd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 15:33:27 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12D69214DB;
        Wed,  1 Jul 2020 19:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593632006;
        bh=r8R75b+xkhLmr1tY3cOQk+t7NaFIqQrJERgYOINJ8u8=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=YaEi8nELGrDUxED1fQmTzZdU1uYD6OedAGffToORdNFydZkHl1GAkFj2HpOLNtSY+
         ujTi4+dmHDUYujvki5qSUOfxtUJVEcg5bbLdyTK9sLI1EFngikV0nmxef8QSH3WZX9
         F0ngVV3sXkNR2LqyLow2nQ5UoWMrT+Dn9n17qcs0=
Date:   Wed, 01 Jul 2020 19:33:25 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Joseph Salisbury <joseph.salisbury@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH][v2] Drivers: hv: Change flag to write log level in panic msg to false
In-Reply-To: <1593210497-114310-1-git-send-email-joseph.salisbury@microsoft.com>
References: <1593210497-114310-1-git-send-email-joseph.salisbury@microsoft.com>
Message-Id: <20200701193326.12D69214DB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.

v5.7.6: Build OK!
v5.4.49: Failed to apply! Possible dependencies:
    53edce00ceb74 ("Drivers: hv: vmbus: Remove dependencies on guest page size")

v4.19.130: Failed to apply! Possible dependencies:
    53edce00ceb74 ("Drivers: hv: vmbus: Remove dependencies on guest page size")

v4.14.186: Failed to apply! Possible dependencies:
    4a5f3cde4d51c ("Drivers: hv: vmbus: Remove x86-isms from arch independent drivers")
    53edce00ceb74 ("Drivers: hv: vmbus: Remove dependencies on guest page size")
    7ed4325a44ea5 ("Drivers: hv: vmbus: Make panic reporting to be more useful")
    81b18bce48af3 ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
    8afc06dd75c06 ("Drivers: hv: vmbus: Fix the issue with freeing up hv_ctl_table_hdr")
    ddcaf3ca4c3c8 ("Drivers: hv: vmus: Fix the check for return value from kmsg get dump buffer")

v4.9.228: Failed to apply! Possible dependencies:
    4a5f3cde4d51c ("Drivers: hv: vmbus: Remove x86-isms from arch independent drivers")
    6ab42a66d2cc1 ("Drivers: hv: vmbus: Move Hypercall invocation code out of common code")
    73638cddaad86 ("Drivers: hv: vmbus: Move the check for hypercall page setup")
    76d36ab798204 ("hv: switch to cpuhp state machine for synic init/cleanup")
    81b18bce48af3 ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
    8730046c1498e ("Drivers: hv vmbus: Move Hypercall page setup out of common code")
    d058fa7e98ff0 ("Drivers: hv: vmbus: Move the crash notification function")

v4.4.228: Failed to apply! Possible dependencies:
    4a5f3cde4d51c ("Drivers: hv: vmbus: Remove x86-isms from arch independent drivers")
    619848bd07434 ("drivers:hv: Export a function that maps Linux CPU num onto Hyper-V proc num")
    6ab42a66d2cc1 ("Drivers: hv: vmbus: Move Hypercall invocation code out of common code")
    73638cddaad86 ("Drivers: hv: vmbus: Move the check for hypercall page setup")
    75ff3a8a9168d ("Drivers: hv: vmbus: avoid wait_for_completion() on crash")
    76d36ab798204 ("hv: switch to cpuhp state machine for synic init/cleanup")
    81b18bce48af3 ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
    8730046c1498e ("Drivers: hv vmbus: Move Hypercall page setup out of common code")
    a108393dbf764 ("drivers:hv: Export the API to invoke a hypercall on Hyper-V")
    d058fa7e98ff0 ("Drivers: hv: vmbus: Move the crash notification function")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
