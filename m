Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD393D260B
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 16:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhGVODx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 10:03:53 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:57281 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232328AbhGVODw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 10:03:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 3186B2B011E4;
        Thu, 22 Jul 2021 10:44:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 22 Jul 2021 10:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=XaGUctFlxUy09UfuXEu+dT14c1P
        y4V1rEznOR88gUlo=; b=As8mIWSAXd9hLeWuT7iNEu1HCN7W/0lGOfG4HyiPIf1
        S2gP8LWhXxP1nSZq5/xyyRK+b3H5630aqgAugOzUnOg+g4TQQda9yQfdOkn2IXuE
        lCX5y5UHlT6y9+kfHtQcpAk1QMsDS2YdjyuMggEIQHg2HN0VqQKuUDdOy+As3ws3
        5AR1vNZoa0OvrcyKOQy19K0eXEcaEqdinAM60BBya+bi7502B+5+XAipsDQ7mWi5
        oR1fMRjCItPYk5GQo3IHE1EQYSfHw9L4LMwRlyf/IGww+xywqoC2ix3n1ppmm2kq
        ebGwSH9gZEPc0NWN4NZgb56XGjx5cN8dFcaAmaW3Mig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=XaGUct
        FlxUy09UfuXEu+dT14c1Py4V1rEznOR88gUlo=; b=MlC9Tival2f5kaak3KUspk
        HIn7ICL8tSsLlVcYl56qG3+gbEazlQ6c8hTRK7gHh2kC4edcQJoj819pZ0Rv5Dmu
        +UzRO6HcRgGeW5eSrmUNZd8RrtkL/sPGE6D3HkLjjaBXGdOyhDMKclheqyzl2QK7
        oNHKGc0Dd6eUm8it6yTAimvDYZDID4iE9MmyS111FjJh9cw4YVXDSldpOjvC78kv
        IQrdfWgLPHTSDW2NK376Yl+5FoP2GdFun+w6ASildk8dpzHeuEgHRXs4BIHFOMxZ
        UR306HL5OMlJXjTSJtQsm0/Qp55m+4FMOUNshDgj44UZTQ8czYZWTi+i5Uda+8vw
        ==
X-ME-Sender: <xms:SIT5YBcDrwrGBeAvTa4QLdpRiCJSdnoCLjIDeYa4Ule0Dc05kUA0Tg>
    <xme:SIT5YPMWddxXf0Hrhf9dSDOuLUKuvqo9nxVzchZpV7KmCIy11UCMzFN6UsxeGeXy_
    Jh4hVMKZz8seg>
X-ME-Received: <xmr:SIT5YKhv3en7V8v64-c3n4h10cnLG5QhghhhcDfiysEyHXWIR2xDCtWADkjVftO3awO8p4AssK05RqeFJo_v60SQTBN8n-gP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfeeigdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:SIT5YK_mXGkDORYdqT6Y6sVSkYU2rD3gc2l0dKbq_v-hVx9oyYfAXA>
    <xmx:SIT5YNs2Z_v8rrnJvDex5rqAW18RRNQ0KUfP75p6iUK7ElVgSpz2PQ>
    <xmx:SIT5YJG5BcO7Gfm9baQrw8qp8d8Y7kH-1-x4AevUp-nVmb8ybOGQXw>
    <xmx:SYT5YImb2fYtT36zI9mZr5GVLL2RM9LB2o3YjeZc9g-7cYClsATugcTscZY>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Jul 2021 10:44:24 -0400 (EDT)
Date:   Thu, 22 Jul 2021 16:44:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Nanyong Sun <sunnanyong@huawei.com>
Cc:     songmuchun@bytedance.com, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4.19.y,v5.4.y] mm: slab: fix kmem_cache_create failed
 when sysfs node not destroyed
Message-ID: <YPmERkuzZ73qRKj0@kroah.com>
References: <20210720082048.2797315-1-sunnanyong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720082048.2797315-1-sunnanyong@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 20, 2021 at 04:20:48PM +0800, Nanyong Sun wrote:
> The commit d38a2b7a9c93 ("mm: memcg/slab: fix memory leak at non-root
> kmem_cache destroy") introduced a problem: If one thread destroy a
> kmem_cache A and another thread concurrently create a kmem_cache B,
> which is mergeable with A and has same size with A, the B may fail to
> create due to the duplicate sysfs node.
> The scenario in detail:
> 1) Thread 1 uses kmem_cache_destroy() to destroy kmem_cache A which is
> mergeable, it decreases A's refcount and if refcount is 0, then call
> memcg_set_kmem_cache_dying() which set A->memcg_params.dying = true,
> then unlock the slab_mutex and call flush_memcg_workqueue(), it may cost
> a while.
> Note: now the sysfs node(like '/kernel/slab/:0000248') of A is still
> present, it will be deleted in shutdown_cache() which will be called
> after flush_memcg_workqueue() is done and lock the slab_mutex again.
> 2) Now if thread 2 is coming, it use kmem_cache_create() to create B, which
> is mergeable with A(their size is same), it gain the lock of slab_mutex,
> then call __kmem_cache_alias() trying to find a mergeable node, because
> of the below added code in commit d38a2b7a9c93 ("mm: memcg/slab: fix
> memory leak at non-root kmem_cache destroy"), B is not mergeable with
> A whose memcg_params.dying is true.
> 
> int slab_unmergeable(struct kmem_cache *s)
>  	if (s->refcount < 0)
>  		return 1;
> 
> 	/*
> 	 * Skip the dying kmem_cache.
> 	 */
> 	if (s->memcg_params.dying)
> 		return 1;
> 
>  	return 0;
>  }
> 
> So B has to create its own sysfs node by calling:
>  create_cache->
> 	__kmem_cache_create->
> 		sysfs_slab_add->
> 			kobject_init_and_add
> Because B is mergeable itself, its filename of sysfs node is based on its size,
> like '/kernel/slab/:0000248', which is duplicate with A, and the sysfs
> node of A is still present now, so kobject_init_and_add() will return
> fail and result in kmem_cache_create() fail.
> 
> Concurrently modprobe and rmmod the two modules below can reproduce the issue
> quickly: nf_conntrack_expect, se_sess_cache. See call trace in the end.
> 
> LTS versions of v4.19.y and v5.4.y have this problem, whereas linux versions after
> v5.9 do not have this problem because the patchset: ("The new cgroup slab memory
> controller") almost refactored memcg slab.
> 
> A potential solution(this patch belongs): Just let the dying kmem_cache be mergeable,
> the slab_mutex lock can prevent the race between alias kmem_cache creating thread
> and root kmem_cache destroying thread. In the destroying thread, after
> flush_memcg_workqueue() is done, judge the refcount again, if someone
> reference it again during un-lock time, we don't need to destroy the kmem_cache
> completely, we can reuse it.
> 
> Another potential solution: revert the commit d38a2b7a9c93 ("mm: memcg/slab:
> fix memory leak at non-root kmem_cache destroy"), compare to the fail of
> kmem_cache_create, the memory leak in special scenario seems less harmful.
> 
> Call trace:
>  sysfs: cannot create duplicate filename '/kernel/slab/:0000248'
>  Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
>  Call trace:
>   dump_backtrace+0x0/0x198
>   show_stack+0x24/0x30
>   dump_stack+0xb0/0x100
>   sysfs_warn_dup+0x6c/0x88
>   sysfs_create_dir_ns+0x104/0x120
>   kobject_add_internal+0xd0/0x378
>   kobject_init_and_add+0x90/0xd8
>   sysfs_slab_add+0x16c/0x2d0
>   __kmem_cache_create+0x16c/0x1d8
>   create_cache+0xbc/0x1f8
>   kmem_cache_create_usercopy+0x1a0/0x230
>   kmem_cache_create+0x50/0x68
>   init_se_kmem_caches+0x38/0x258 [target_core_mod]
>   target_core_init_configfs+0x8c/0x390 [target_core_mod]
>   do_one_initcall+0x54/0x230
>   do_init_module+0x64/0x1ec
>   load_module+0x150c/0x16f0
>   __se_sys_finit_module+0xf0/0x108
>   __arm64_sys_finit_module+0x24/0x30
>   el0_svc_common+0x80/0x1c0
>   el0_svc_handler+0x78/0xe0
>   el0_svc+0x10/0x260
>  kobject_add_internal failed for :0000248 with -EEXIST, don't try to register things with the same name in the same directory.
>  kmem_cache_create(se_sess_cache) failed with error -17
>  Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
>  Call trace:
>   dump_backtrace+0x0/0x198
>   show_stack+0x24/0x30
>   dump_stack+0xb0/0x100
>   kmem_cache_create_usercopy+0xa8/0x230
>   kmem_cache_create+0x50/0x68
>   init_se_kmem_caches+0x38/0x258 [target_core_mod]
>   target_core_init_configfs+0x8c/0x390 [target_core_mod]
>   do_one_initcall+0x54/0x230
>   do_init_module+0x64/0x1ec
>   load_module+0x150c/0x16f0
>   __se_sys_finit_module+0xf0/0x108
>   __arm64_sys_finit_module+0x24/0x30
>   el0_svc_common+0x80/0x1c0
>   el0_svc_handler+0x78/0xe0
>   el0_svc+0x10/0x260
> 
> Fixes: d38a2b7a9c93 ("mm: memcg/slab: fix memory leak at non-root kmem_cache destroy")
> Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
> Cc: stable@vger.kernel.org
> ---
>  mm/slab_common.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index d208b47e01a8..acc743315bb5 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -326,14 +326,6 @@ int slab_unmergeable(struct kmem_cache *s)
>  	if (s->refcount < 0)
>  		return 1;
>  
> -#ifdef CONFIG_MEMCG_KMEM
> -	/*
> -	 * Skip the dying kmem_cache.
> -	 */
> -	if (s->memcg_params.dying)
> -		return 1;
> -#endif
> -
>  	return 0;
>  }
>  
> @@ -947,6 +939,16 @@ void kmem_cache_destroy(struct kmem_cache *s)
>  	get_online_mems();
>  
>  	mutex_lock(&slab_mutex);
> +
> +	/*
> +	 *Another thread referenced it again
> +	 */
> +	if (READ_ONCE(s->refcount)) {
> +		spin_lock_irq(&memcg_kmem_wq_lock);
> +		s->memcg_params.dying = false;
> +		spin_unlock_irq(&memcg_kmem_wq_lock);
> +		goto out_unlock;
> +	}
>  #endif
>  
>  	err = shutdown_memcg_caches(s);
> -- 
> 2.18.0.huawei.25
> 

Thanks, I've queued this up now.

greg k-h
