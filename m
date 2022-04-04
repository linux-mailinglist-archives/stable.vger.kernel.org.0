Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92DC4F1342
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 12:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358116AbiDDKn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 06:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357999AbiDDKn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 06:43:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BF433CA7F
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 03:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649068920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K7rIkWLmrLGTa+92JOT4Yi/iErXijZyARlybj4MoGJo=;
        b=XlTRzFlDjLHFlXEn2utWC6ETU1Q9j6Asj6HoSpo4U7M5wQc3/OMuV/U2poL2mJ0I0eJ7qR
        n5LZw5FjymxESyAjY7DOG/fzrypIZSvSoAyyeb4/HYF/hQiayLkuP53394B0K6cV6cMiUV
        ysH9SPxXEyM8y+yIxEdfsZS5bBS9WPA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-PvhB0muyOtKSYYtovzjESA-1; Mon, 04 Apr 2022 06:41:59 -0400
X-MC-Unique: PvhB0muyOtKSYYtovzjESA-1
Received: by mail-wr1-f71.google.com with SMTP id x17-20020adfbb51000000b002060ff71a3bso465225wrg.22
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 03:41:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=K7rIkWLmrLGTa+92JOT4Yi/iErXijZyARlybj4MoGJo=;
        b=pyH02tVNZ9jzeONLRlJb0Bo+1yA6B4xDg+MXYNhXEqLOScJmKFfYb6fbXBKLKZOqXD
         VIV9qN7d7huBiNbI+uf9cxpe7dmjbQyvXNFuvOwDZLUAwAv9Qlge68eVPvM7aqC8ZhMV
         7YPK3XGn6a2QzzCnt6FCcoSAVfu4QW53DmHWcM21X6dxbBZUBCON51r1CN+3GyyGrM6K
         AdY00P1G6kPo18PbHgAIKWE3g7PH0/Ai2oOycOFL9RFY3CTaxTiUyp0WM4jro19Ax1iX
         KaKS12L8x+ORp5lSJuapzaWBG13SudRGNj4LBDNOdJeYlkzh1wrGegsKJSyz4E695BvF
         fTDQ==
X-Gm-Message-State: AOAM532BjYV2zYFxkA2XrO6Nt2af9AH2cqlC79VkFKjx1FbQCzGcd69a
        Pw1Car9z/dQFnKQo7V9T4JIQGFSxZGaxO4SDcv2YckRofXLE+UnXf3Nxe6dbdef9ZnpSWHIm9Y1
        zh0EwfiyuewYkE0n7
X-Received: by 2002:a05:600c:3ca4:b0:38e:54d0:406d with SMTP id bg36-20020a05600c3ca400b0038e54d0406dmr13488805wmb.199.1649068918203;
        Mon, 04 Apr 2022 03:41:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6a6zfyr1sGtwloIiL5KkgvfWKLJ1JA6cVZ5DHKeAjtvZH2ze39DIK8JP7Ioh7t18Pin7Wjw==
X-Received: by 2002:a05:600c:3ca4:b0:38e:54d0:406d with SMTP id bg36-20020a05600c3ca400b0038e54d0406dmr13488786wmb.199.1649068917896;
        Mon, 04 Apr 2022 03:41:57 -0700 (PDT)
Received: from ?IPV6:2003:cb:c704:4100:c220:ede7:17d4:6ff4? (p200300cbc7044100c220ede717d46ff4.dip0.t-ipconnect.de. [2003:cb:c704:4100:c220:ede7:17d4:6ff4])
        by smtp.gmail.com with ESMTPSA id f11-20020a7bcc0b000000b0037e0c362b6dsm8996818wmh.31.2022.04.04.03.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 03:41:57 -0700 (PDT)
Message-ID: <e3889061-4681-0618-5291-05b9559e0e10@redhat.com>
Date:   Mon, 4 Apr 2022 12:41:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     Mike Kravetz <mike.kravetz@oracle.com>,
        Peng Liu <liupeng256@huawei.com>, akpm@linux-foundation.org,
        yaozhenguo1@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220401101232.2790280-1-liupeng256@huawei.com>
 <20220401101232.2790280-2-liupeng256@huawei.com>
 <0aefbc18-4232-0bae-b37a-d4c6995e3d00@redhat.com>
 <508fd247-b809-27d7-6bc8-a08c4c73cbb5@oracle.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v2 1/2] hugetlb: Fix hugepages_setup when deal with
 pernode
In-Reply-To: <508fd247-b809-27d7-6bc8-a08c4c73cbb5@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01.04.22 19:23, Mike Kravetz wrote:
> On 4/1/22 03:43, David Hildenbrand wrote:
>> On 01.04.22 12:12, Peng Liu wrote:
>>> Hugepages can be specified to pernode since "hugetlbfs: extend
>>> the definition of hugepages parameter to support node allocation",
>>> but the following problem is observed.
>>>
>>> Confusing behavior is observed when both 1G and 2M hugepage is set
>>> after "numa=off".
>>>  cmdline hugepage settings:
>>>   hugepagesz=1G hugepages=0:3,1:3
>>>   hugepagesz=2M hugepages=0:1024,1:1024
>>>  results:
>>>   HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
>>>   HugeTLB registered 2.00 MiB page size, pre-allocated 1024 pages
>>>
>>> Furthermore, confusing behavior can be also observed when invalid
>>> node behind valid node.
>>>
>>> To fix this, hugetlb_hstate_alloc_pages should be called even when
>>> hugepages_setup going to invalid.
>>
>> Shouldn't we bail out if someone requests node-specific allocations but
>> we are not running with NUMA?
> 
> I thought about this as well, and could not come up with a good answer.
> Certainly, nobody SHOULD specify both 'numa=off' and ask for node specific
> allocations on the same command line.  I would have no problem bailing out
> in such situations.  But, I think that would also require the hugetlb command
> line processing to look for such situations.

Yes. Right now I see

if (tmp >= nr_online_nodes)
	goto invalid;

Which seems a little strange, because IIUC, it's the number of online
nodes, which is completely wrong with a sparse online bitmap. Just
imagine node 0 and node 2 are online, and node 1 is offline. Assuming
that "node < 2" is valid is wrong.

Why don't we check for node_online() and bail out if that is not the
case? Is it too early for that check? But why does comparing against
nr_online_nodes() work, then?


Having that said, I'm not sure if all usage of nr_online_nodes in
mm/hugetlb.c is wrong, with a sparse online bitmap. Outside of that,
it's really just used for "nr_online_nodes > 1". I might be wrong, though.

> 
> One could also argue that if there is only a single node (not numa=off on
> command line) and someone specifies node local allocations we should bail.

I assume "numa=off" is always parsed before hugepages_setup() is called,
right? So we can just rely on the actual numa information.


> 
> I was 'thinking' about a situation where we had multiple nodes and node
> local allocations were 'hard coded' via grub or something.  Then, for some
> reason one node fails to come up on a reboot.  Should we bail on all the
> hugetlb allocations, or should we try to allocate on the still available
> nodes?

Depends on what "bail" means. Printing a warning and stopping to
allocate further is certainly good enough for my taste :)

> 
> When I went back and reread the reason for this change, I see that it is
> primarily for 'some debugging and test cases'.
> 
>>
>> What's the result after your change?
>>
>>>
>>> Cc: <stable@vger.kernel.org>
>>
>> I am not sure if this is really stable material.
> 
> Right now, we partially and inconsistently process node specific allocations
> if there are missing nodes.  We allocate 'regular' hugetlb pages on existing
> nodes.  But, we do not allocate gigantic hugetlb pages on existing nodes.
> 
> I believe this is worth fixing in stable.

I am skeptical.

https://www.kernel.org/doc/Documentation/process/stable-kernel-rules.rst

" - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing)."

While the current behavior is suboptimal, it's certainly not an urgent
bug (?) and the kernel will boot and work just fine. As you mentioned
"nobody SHOULD specify both 'numa=off' and ask for node specific
allocations on the same command line.", this is just a corner case.

Adjusting it upstream -- okay. Backporting to stable? I don't think so.

-- 
Thanks,

David / dhildenb

