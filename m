Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405A768B8FD
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 10:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjBFJvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 04:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjBFJvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 04:51:16 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764A21D90E
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 01:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675677075; x=1707213075;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ckeg6Faup2JNbftnJawOm9JyTMthGurgdsMcSMe7AAA=;
  b=kHR84gvb8vxkU4MmNKJVAKFT39iBZK/s9RwDFcUy+Xo+fgnr8ApyH/Rh
   pIlOBjwnMiXZGwZiHUYY7ekHKAabnNkdJSOoBwSHDof1ftKRWGnGsa92R
   kt8cJLrZD5mY7riRsPwvWcLU0BKz538YjlzLGJS5oIfqICoVIaT9y5zDL
   ptoNJqDPEvvA7Xlt56uZ79LMd9xKcBsIw75tlMVffrVjVOcvuyQQBdOuF
   mXeh47xUrIDWSic6A/914Q+H52YKRxUw7oQw/0k82bv+oFRei/sdDldkn
   lqHBQP2ph+KPifXQ9UMbp4qyjcqCwIXT1rA4jSqKu1eBKawSI5RTOGKvm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="312822564"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="312822564"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 01:51:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="790386854"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="790386854"
Received: from kgurski-mobl3.ger.corp.intel.com (HELO [10.213.203.226]) ([10.213.203.226])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 01:51:13 -0800
Message-ID: <f761df58-fd0d-4f08-649f-365e55b41f7b@linux.intel.com>
Date:   Mon, 6 Feb 2023 09:51:10 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: Initialize the obj flags for
 shmem objects
Content-Language: en-US
To:     Aravind Iddamsetty <aravind.iddamsetty@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Matthew Auld <matthew.auld@intel.com>
References: <20230203135205.4051149-1-aravind.iddamsetty@intel.com>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <20230203135205.4051149-1-aravind.iddamsetty@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 03/02/2023 13:52, Aravind Iddamsetty wrote:
> Obj flags for shmem objects is not being set correctly. Fixes in setting
> BO_ALLOC_USER flag which applies to shmem objs as well.
> 
> Fixes: 13d29c823738 ("drm/i915/ehl: unconditionally flush the pages on acquire")
> Cc: <stable@vger.kernel.org> # v5.15+

These tags should have been grouped with the ones below in one block.

I have tidied this while pushing, thanks for the fix and review!

Regards,

Tvrtko

> v2: Add fixes tag (Tvrtko, Matt A)
> 
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Reviewed-by: Matthew Auld <matthew.auld@intel.com>
> Signed-off-by: Aravind Iddamsetty <aravind.iddamsetty@intel.com>
> ---
>   drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> index 114443096841..37d1efcd3ca6 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> @@ -596,7 +596,7 @@ static int shmem_object_init(struct intel_memory_region *mem,
>   	mapping_set_gfp_mask(mapping, mask);
>   	GEM_BUG_ON(!(mapping_gfp_mask(mapping) & __GFP_RECLAIM));
>   
> -	i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, 0);
> +	i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, flags);
>   	obj->mem_flags |= I915_BO_FLAG_STRUCT_PAGE;
>   	obj->write_domain = I915_GEM_DOMAIN_CPU;
>   	obj->read_domains = I915_GEM_DOMAIN_CPU;
