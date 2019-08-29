Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 425DFA2892
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 23:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfH2VCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 17:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfH2VCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 17:02:09 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08C7722CEA;
        Thu, 29 Aug 2019 21:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567112528;
        bh=ftJZBzA6hYRVIkis6C2CaXGLjNl+htDkPqdlkxxwW04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QKWteuAUv7UjTp3m1u0QHzl6mjKI0adY6Y1bBi2Anv2A9q4GPyv/fhPi1jE42rpdl
         0yTVQXMB34/is1oq83yqDG3/e9kwpJ//F6TKMlb8iG+EedNdXCTqgheg1+t/nbTvwe
         LByASt7PukW2C4v15TLMjiahDlejK78UTisqWU6M=
Date:   Thu, 29 Aug 2019 17:02:07 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dmitry.v.rogozhkin@intel.com,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: Re: [PATCH] drm/i915: fix broadwell EU computation
Message-ID: <20190829210207.GM5281@sasha-vm>
References: <20190828210209.10541-1-rodrigo.vivi@intel.com>
 <d7faaa1c-362f-ce9e-bbc9-adb5a7400b1f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d7faaa1c-362f-ce9e-bbc9-adb5a7400b1f@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 12:22:27AM +0300, Lionel Landwerlin wrote:
>On 29/08/2019 00:02, Rodrigo Vivi wrote:
>>From: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
>>
>>commit 6a67a20366f894c172734f28c5646bdbe48a46e3 upstream.
>>
>>subslice_mask is an array indexed by slice, not subslice.
>>
>>Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
>>Fixes: 8cc7669355136f ("drm/i915: store all subslice masks")
>>Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=108712
>>Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
>>Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>>Link: https://patchwork.freedesktop.org/patch/msgid/20181112123931.2815-1-lionel.g.landwerlin@intel.com
>>(cherry picked from commit 63ac3328f0d1d37f286e397b14d9596ed09d7ca5)
>>Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>>Cc: <stable@vger.kernel.org> # 4.17
>
>
>Rodrigo pointed out I forgot the Cc: tag which is why this didn't make 
>it to stable.
>
>The same bug showed up on a CentOS kernel : 
>https://github.com/intel/compute-runtime/issues/200

I just queued the upstream patch for 4.19, thanks!

--
Thanks,
Sasha
