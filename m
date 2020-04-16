Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E431AB604
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 04:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388316AbgDPCrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 22:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732153AbgDPCrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 22:47:05 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35AB620771;
        Thu, 16 Apr 2020 02:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587005225;
        bh=4rIGtmj1gKnc8/8rtXwi2OobHsa1XZd91NdJ9tq4Bbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=acySgP3k1FOb00dSEITL0O0E4K/5znuxHnokkzIEXdra374RaFXZdTZMasgSCo1Ru
         +ONf+46FKXIGj9UFs5dfOREPB2M017HY/inTSxuyz/6kD5IJa/LmJ6RmP9kKe3WHYH
         yYvp2Dp5/L9hK4asraL6HaM2SUEsJ9gWQiqV9Mo8=
Date:   Wed, 15 Apr 2020 22:47:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     chris@chris-wilson.co.uk, imre.deak@intel.com,
        matthew.auld@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/i915/gt: Fill all the unused space in
 the GGTT" failed to apply to 5.6-stable tree
Message-ID: <20200416024704.GB1068@sasha-vm>
References: <1586950539224114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1586950539224114@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:35:39PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.6-stable tree.
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
>From 0b72a251bf92ca2378530fa1f9b35a71830ab51c Mon Sep 17 00:00:00 2001
>From: Chris Wilson <chris@chris-wilson.co.uk>
>Date: Tue, 31 Mar 2020 16:23:48 +0100
>Subject: [PATCH] drm/i915/gt: Fill all the unused space in the GGTT
>
>When we allocate space in the GGTT we may have to allocate a larger
>region than will be populated by the object to accommodate fencing. Make
>sure that this space beyond the end of the buffer points safely into
>scratch space, in case the HW tries to access it anyway (e.g. fenced
>access to the last tile row).
>
>v2: Preemptively / conservatively guard gen6 ggtt as well.
>
>Reported-by: Imre Deak <imre.deak@intel.com>
>References: https://gitlab.freedesktop.org/drm/intel/-/issues/1554
>Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>Cc: Matthew Auld <matthew.auld@intel.com>
>Cc: Imre Deak <imre.deak@intel.com>
>Cc: stable@vger.kernel.org
>Reviewed-by: Matthew Auld <matthew.auld@intel.com>
>Reviewed-by: Imre Deak <imre.deak@intel.com>
>Link: https://patchwork.freedesktop.org/patch/msgid/20200331152348.26946-1-chris@chris-wilson.co.uk
>(cherry picked from commit 4d6c18590870fbac1e65dde5e01e621c8e0ca096)
>Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

I've also grabbed 69edc390a542 ("drm/i915/ggtt: do not set bits 1-11 in
gen12 ptes").

-- 
Thanks,
Sasha
