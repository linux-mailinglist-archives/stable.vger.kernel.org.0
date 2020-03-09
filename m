Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F293C17E029
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 13:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgCIMZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 08:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgCIMZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 08:25:05 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DA3A20848;
        Mon,  9 Mar 2020 12:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583756704;
        bh=O7WyWQn8Dx5JP+OIZhd25k8dqboeM8bqZ49j10OMvbk=;
        h=Date:From:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=ExDo5OsMnvluYuQ/LeOQpcdimFyUp98fKPCCqhajfWAxjsmxqJG93tZr9i1U84XK9
         NrhIn5epueF1GD+ngQkKMemsOXiLkWtGSkimQ1z8LSoTt+wVZ7/zp4QSong+SL4buN
         ObUfEzhLmmunEGilWdjiA58uJ17Hr5iw2MsXPZpg=
Date:   Mon, 09 Mar 2020 12:25:03 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     linux-tip-commits@vger.kernel.org
Cc:     Vladis Dronov <vdronov@redhat.com>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [tip: efi/urgent] efi: Add a sanity check to efivar_store_raw()
In-Reply-To: <158368551265.28353.5476421599260286182.tip-bot2@tip-bot2>
References: <158368551265.28353.5476421599260286182.tip-bot2@tip-bot2>
Message-Id: <20200309122504.3DA3A20848@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108, v4.14.172, v4.9.215, v4.4.215.

v5.5.8: Build OK!
v5.4.24: Build OK!
v4.19.108: Failed to apply! Possible dependencies:
    98f76206b335 ("compat: Cleanup in_compat_syscall() callers")

v4.14.172: Failed to apply! Possible dependencies:
    98f76206b335 ("compat: Cleanup in_compat_syscall() callers")
    ea2ce8f3514e ("time: Fix get_timespec64() for y2038 safe compat interfaces")

v4.9.215: Failed to apply! Possible dependencies:
    31ea70e0308b ("posix-timers: Move the do_schedule_next_timer declaration")
    96fe3b072f13 ("posix-timers: Rename do_schedule_next_timer")
    98f76206b335 ("compat: Cleanup in_compat_syscall() callers")
    d5b7ffbfbdac ("time: introduce {get,put}_itimerspec64")
    ea2ce8f3514e ("time: Fix get_timespec64() for y2038 safe compat interfaces")
    f59dd9c886ac ("time: add get_timespec64 and put_timespec64")

v4.4.215: Failed to apply! Possible dependencies:
    2bf8c4762659 ("net/xfrm_user: use in_compat_syscall to deny compat syscalls")
    31ea70e0308b ("posix-timers: Move the do_schedule_next_timer declaration")
    4f01ed221e2e ("drivers/firmware/efi/efivars.c: use in_compat_syscall() to check for compat callers")
    96fe3b072f13 ("posix-timers: Rename do_schedule_next_timer")
    98f76206b335 ("compat: Cleanup in_compat_syscall() callers")
    bc2c53e5f1a2 ("time: add missing implementation for timespec64_add_safe()")
    d5b7ffbfbdac ("time: introduce {get,put}_itimerspec64")
    ea2ce8f3514e ("time: Fix get_timespec64() for y2038 safe compat interfaces")
    f59dd9c886ac ("time: add get_timespec64 and put_timespec64")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
