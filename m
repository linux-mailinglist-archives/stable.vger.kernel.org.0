Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53219447BD9
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 09:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238020AbhKHIe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 03:34:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236074AbhKHIey (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 03:34:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636360330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hEd9v1Vyqj6kQtsKvZbGkqhWuIPMwqRf/FozMjwWxPc=;
        b=bXprP78iAoRI1xCKhUzXNk2HOgkM8iSlEMg6mYCFGrmUpr6UlVKyx1eF6/O88Mrt2Uwgsp
        TlK8Qi3q83kW038UyVm5cpyjAHd46TlhVfgJ9KVNTuIx4e6bgI1Pt+8Ui84Cq2sGTmsCtn
        MDOJl/3B48ZKfmVFOaawfV8ibBt1uwQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-Zu6rkZTKO8eZHZFA8-yeLQ-1; Mon, 08 Nov 2021 03:32:06 -0500
X-MC-Unique: Zu6rkZTKO8eZHZFA8-yeLQ-1
Received: by mail-wm1-f69.google.com with SMTP id m18-20020a05600c3b1200b0033283ea5facso3410648wms.1
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 00:32:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=hEd9v1Vyqj6kQtsKvZbGkqhWuIPMwqRf/FozMjwWxPc=;
        b=IjkGe3je3dy+gxKtiQfWAVJd9OkSB/eETGP/nowcMFOCWXN7i586GEVLneq4iblaWL
         0laAXtbkh9nx5XBDBT7Yx6Qgb5d8vV7P9gNMFZDNWqG47kgzA574d+rxb8N4fRXXI6us
         HVgojAfNucSDICY2VOrwzyynbihth+xSMuXf8tyEh+XoWxmAIJ+Bt7f57nHIfQT6fYTQ
         e4D4IK3EB19CHKveEAZo6qPFe/JhQkUgQV1+hmZYbLPDrWqcnqu+wqi6x8/f58Mrj2XK
         nL6/YuHFIO8ePg1Iw0ljfjRr6DIENdCgP7Wut9fV1DawGcfQGeLX5NhzLzIMEIXXhoST
         zPkw==
X-Gm-Message-State: AOAM533IdGG+LQmPUI5inck2RgqXobnsKIKheAV7rMn7lX2w8sRs/kEJ
        ++n8KU2yZ3KDsl9b+FlUMkNUtcaFwfPVvBHdmqX7FJA3hz3P3WUVoeNUQ9YpI9A5Hce+IaNmWRR
        dDub1Vno4if8s798f
X-Received: by 2002:a05:6000:1688:: with SMTP id y8mr28137422wrd.420.1636360325551;
        Mon, 08 Nov 2021 00:32:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy67NpbO8B09kKqxsdGlvUBDsod6wvpsdGpRPSqMxb638wrxS4aj1mPkUmImJVAMkYO4SPznw==
X-Received: by 2002:a05:6000:1688:: with SMTP id y8mr28137392wrd.420.1636360325383;
        Mon, 08 Nov 2021 00:32:05 -0800 (PST)
Received: from [192.168.3.132] (p5b0c6108.dip0.t-ipconnect.de. [91.12.97.8])
        by smtp.gmail.com with ESMTPSA id g5sm15880108wri.45.2021.11.08.00.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 00:32:04 -0800 (PST)
Message-ID: <908909e0-4815-b580-7ff5-d824d36a141c@redhat.com>
Date:   Mon, 8 Nov 2021 09:32:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Alexey Makhalov <amakhalov@vmware.com>, linux-mm@kvack.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <86BDA7AC-3E7A-4779-9388-9DF7BA7230AA@vmware.com>
 <20211108063650.19435-1-amakhalov@vmware.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v2] mm: fix panic in __alloc_pages
In-Reply-To: <20211108063650.19435-1-amakhalov@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.11.21 07:36, Alexey Makhalov wrote:
> There is a kernel panic caused by pcpu_alloc_pages() passing
> offlined and uninitialized node to alloc_pages_node() leading
> to panic by NULL dereferencing uninitialized NODE_DATA(nid).
> 
>  CPU2 has been hot-added
>  BUG: unable to handle page fault for address: 0000000000001608
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 0 P4D 0
>  Oops: 0000 [#1] SMP PTI
>  CPU: 0 PID: 1 Comm: systemd Tainted: G            E     5.15.0-rc7+ #11
>  Hardware name: VMware, Inc. VMware7,1/440BX Desktop Reference Platform, BIOS VMW
> 
>  RIP: 0010:__alloc_pages+0x127/0x290
>  Code: 4c 89 f0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 44 89 e0 48 8b 55 b8 c1 e8 0c 83 e0 01 88 45 d0 4c 89 c8 48 85 d2 0f 85 1a 01 00 00 <45> 3b 41 08 0f 82 10 01 00 00 48 89 45 c0 48 8b 00 44 89 e2 81 e2
>  RSP: 0018:ffffc900006f3bc8 EFLAGS: 00010246
>  RAX: 0000000000001600 RBX: 0000000000000000 RCX: 0000000000000000
>  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000cc2
>  RBP: ffffc900006f3c18 R08: 0000000000000001 R09: 0000000000001600
>  R10: ffffc900006f3a40 R11: ffff88813c9fffe8 R12: 0000000000000cc2
>  R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000cc2
>  FS:  00007f27ead70500(0000) GS:ffff88807ce00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000001608 CR3: 000000000582c003 CR4: 00000000001706b0
>  Call Trace:
>   pcpu_alloc_pages.constprop.0+0xe4/0x1c0
>   pcpu_populate_chunk+0x33/0xb0
>   pcpu_alloc+0x4d3/0x6f0
>   __alloc_percpu_gfp+0xd/0x10
>   alloc_mem_cgroup_per_node_info+0x54/0xb0
>   mem_cgroup_alloc+0xed/0x2f0
>   mem_cgroup_css_alloc+0x33/0x2f0
>   css_create+0x3a/0x1f0
>   cgroup_apply_control_enable+0x12b/0x150
>   cgroup_mkdir+0xdd/0x110
>   kernfs_iop_mkdir+0x4f/0x80
>   vfs_mkdir+0x178/0x230
>   do_mkdirat+0xfd/0x120
>   __x64_sys_mkdir+0x47/0x70
>   ? syscall_exit_to_user_mode+0x21/0x50
>   do_syscall_64+0x43/0x90
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Panic can be easily reproduced by disabling udev rule for
> automatic onlining hot added CPU followed by CPU with
> memoryless node (NUMA node with CPU only) hot add.
> 
> Hot adding CPU and memoryless node does not bring the node
> to online state. Memoryless node will be onlined only during
> the onlining its CPU.
> 
> Node can be in one of the following states:
> 1. not present.(nid == NUMA_NO_NODE)
> 2. present, but offline (nid > NUMA_NO_NODE, node_online(nid) == 0,
> 				NODE_DATA(nid) == NULL)
> 3. present and online (nid > NUMA_NO_NODE, node_online(nid) > 0,
> 				NODE_DATA(nid) != NULL)
> 
> Percpu code is doing allocations for all possible CPUs. The
> issue happens when it serves hot added but not yet onlined
> CPU when its node is in 2nd state. This node is not ready
> to use, fallback to node_mem_id().
> 
> Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  mm/percpu-vm.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> index 2054c9213..f58d73c92 100644
> --- a/mm/percpu-vm.c
> +++ b/mm/percpu-vm.c
> @@ -84,15 +84,19 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
>  			    gfp_t gfp)
>  {
>  	unsigned int cpu, tcpu;
> -	int i;
> +	int i, nid;
>  
>  	gfp |= __GFP_HIGHMEM;
>  
>  	for_each_possible_cpu(cpu) {
> +		nid = cpu_to_node(cpu);

As raised by Michal, we could use cpu_to_mem() here instead of
cpu_to_node(). However, AFAIU, it's a pure optimization to avoid the
fallback path:

Documentation/vm/numa.rst:

"If the architecture supports--does not hide--memoryless nodes, then
CPUs attached to memoryless nodes would always incur the fallback path
overhead  or some subsystems would fail to initialize if they attempted
to allocated memory exclusively from a node without memory.  To support
such architectures transparently, kernel subsystems can use the
numa_mem_id() or cpu_to_mem() function to locate the "local memory node"
for the calling or specified CPU.  Again, this is the same node from
which default, local page allocations will be attempted."


The root issue here is that we're iterating possible CPUs (not online or
present CPUs), belonging to nodes that might not be online yet. I agree
that this fix, although sub-optimal, might be the right thing to do for
now. It would be different if we'd be iterating online CPUs.


Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

