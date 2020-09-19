Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577A4270FED
	for <lists+stable@lfdr.de>; Sat, 19 Sep 2020 20:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgISSKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Sep 2020 14:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgISSKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Sep 2020 14:10:31 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DC222075E;
        Sat, 19 Sep 2020 18:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600539030;
        bh=ng7qoQuro8I40AS+rk/GWBwGyH15HMQ2lDGOq46y4z4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cpvwH2KrCL/Wnp9RLnIilCAmFNGJnA/Xz3AeEVRdVfqGVPzVfVP0VofE667VVToHs
         jwuf3LzAoLV6m+kZlGbQJM0pqhCaQGX9sb9Q+5Pml3db5kddP3elGivYKzJVOST361
         sxBp9dKbdTYoXsXbuK/Lzs7A2Rtdn2z8KHlU/og8=
Date:   Sat, 19 Sep 2020 14:10:29 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Frederic Barrat <fbarrat@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH AUTOSEL 5.4 101/330] powerpc/powernv/ioda: Fix ref count
 for devices with their own PE
Message-ID: <20200919181029.GI2431@sasha-vm>
References: <20200918020110.2063155-1-sashal@kernel.org>
 <20200918020110.2063155-101-sashal@kernel.org>
 <52532d8a-8e90-8a68-07bd-5a3e08c58475@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52532d8a-8e90-8a68-07bd-5a3e08c58475@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 08:35:06AM +0200, Frederic Barrat wrote:
>
>
>Le 18/09/2020 à 03:57, Sasha Levin a écrit :
>>From: Frederic Barrat <fbarrat@linux.ibm.com>
>>
>>[ Upstream commit 05dd7da76986937fb288b4213b1fa10dbe0d1b33 ]
>>
>
>This patch is not desirable for stable, for 5.4 and 4.19 (it was 
>already flagged by autosel back in April. Not sure why it's showing 
>again now)

Hey Fred,

This was a bit of a "lie", it wasn't a run of AUTOSEL, but rather an
audit of patches that went into distro/vendor trees but not into the
upstream stable trees.

I can see that this patch was pulled into Ubuntu's 5.4 tree, is it not
needed in the upstream stable tree?

-- 
Thanks,
Sasha
