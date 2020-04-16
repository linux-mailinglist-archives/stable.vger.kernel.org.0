Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3514D1AB62D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 05:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390685AbgDPDXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 23:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388679AbgDPDXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 23:23:16 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A30E02072D;
        Thu, 16 Apr 2020 03:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587007395;
        bh=KB1UhByOL26eiIC0RjIYVbzKJ2ZvepK46QciNNi1w4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xu/QN7Lqsh0OdF4nrPQ2NITUvyAkWlBD3zo2nYjuEAehdIwb+gASkjJ0h5T/sJ8YH
         TjgPMKwAc15D/ZY4ENKOQcGl/JUvLr6MVc6gkMSHwFuN+ul/dEeS2nMzx2YYjg1VfC
         ImW3wna3Zv5X4cMHicwhPto4gjnq8vz48lopMYKU=
Date:   Wed, 15 Apr 2020 23:23:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     laurentiu.tudor@nxp.com, mpe@ellerman.id.au, oss@buserror.net,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc/fsl_booke: Avoid creating
 duplicate tlb1 entry" failed to apply to 4.19-stable tree
Message-ID: <20200416032314.GF1068@sasha-vm>
References: <158695658720061@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158695658720061@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 03:16:27PM +0200, gregkh@linuxfoundation.org wrote:
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
>From aa4113340ae6c2811e046f08c2bc21011d20a072 Mon Sep 17 00:00:00 2001
>From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
>Date: Thu, 23 Jan 2020 11:19:25 +0000
>Subject: [PATCH] powerpc/fsl_booke: Avoid creating duplicate tlb1 entry
>
>In the current implementation, the call to loadcam_multi() is wrapped
>between switch_to_as1() and restore_to_as0() calls so, when it tries
>to create its own temporary AS=1 TLB1 entry, it ends up duplicating
>the existing one created by switch_to_as1(). Add a check to skip
>creating the temporary entry if already running in AS=1.
>
>Fixes: d9e1831a4202 ("powerpc/85xx: Load all early TLB entries at once")
>Cc: stable@vger.kernel.org # v4.4+
>Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
>Acked-by: Scott Wood <oss@buserror.net>
>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>Link: https://lore.kernel.org/r/20200123111914.2565-1-laurentiu.tudor@nxp.com

Different filename in older trees.

-- 
Thanks,
Sasha
