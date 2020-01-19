Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4FB141FAF
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 20:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgASTEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 14:04:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgASTEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Jan 2020 14:04:11 -0500
Received: from localhost (96-81-74-198-static.hfc.comcastbusiness.net [96.81.74.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 115FE20679;
        Sun, 19 Jan 2020 19:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579460651;
        bh=islLH35amupHJHsnXth33IK4rMTd+p6XSgsJbA8Rw1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NOjyLRorIQFau2v6cuOYfUuIlxSOKn0h4QP/GP7JD3oqTerYkK82c95D5X+kxj3r7
         wtJ2+TclpGBRp+qe5epEuyWFdGojesa0bAC845leAm3nzl+VkRC7z0uxDHg0PdV3rN
         AaqYZqhNU+poKH9AkPPcPlmltkJ3kBA4dBEEcq+U=
Date:   Sun, 19 Jan 2020 14:04:09 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     dinguyen@kernel.org, Meng.Li@windriver.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: dts: agilex/stratix10: fix pmu
 interrupt numbers" failed to apply to 4.19-stable tree
Message-ID: <20200119190409.GY1706@sasha-vm>
References: <1579359826132170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1579359826132170@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 18, 2020 at 04:03:46PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 210de0e996aee8e360ccc9e173fe7f0a7ed2f695 Mon Sep 17 00:00:00 2001
>From: Dinh Nguyen <dinguyen@kernel.org>
>Date: Wed, 20 Nov 2019 09:15:17 -0600
>Subject: [PATCH] arm64: dts: agilex/stratix10: fix pmu interrupt numbers
>
>Fix up the correct interrupt numbers for the PMU unit on Agilex
>and Stratix10.
>
>Fixes: 78cd6a9d8e15 ("arm64: dts: Add base stratix 10 dtsi")
>Cc: linux-stable <stable@vger.kernel.org>
>Reported-by: Meng Li <Meng.Li@windriver.com>
>Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>

I've dropped the agilex part because 4b36daf9ada3 ("arm64: dts: agilex:
Add initial support for Intel's Agilex SoCFPGA") doesn't exist in
kernels older than 5.4. Queued for all trees.

-- 
Thanks,
Sasha
