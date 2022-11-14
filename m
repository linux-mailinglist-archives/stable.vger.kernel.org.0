Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCCB6278B7
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 10:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbiKNJJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 04:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236760AbiKNJIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 04:08:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BCF1D65B
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 01:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668416784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MyDiWdKe1VYdsKgzDX1uadXsuftR4IzIbTjD84A1VBs=;
        b=dblZtqCZI/A9DnFghamLFJOYF1RO/sX6lVM1tzgSYxFIPTaCkXFOF5VjenheiJ2Q0zPq2o
        16KXRan1hxQLbVmk5EfnXQ+YnIgtsEe0+AlwKhi3Mxp7hyzh6Xdj/NneWM/EbJMLQGkzmt
        Ik4K6JoWjyn59rZVqaZyn/XOE/+NqYo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-505-KjDLDgBlOamkSYkmw4ignw-1; Mon, 14 Nov 2022 04:06:21 -0500
X-MC-Unique: KjDLDgBlOamkSYkmw4ignw-1
Received: by mail-wr1-f70.google.com with SMTP id r4-20020adfbb04000000b00236639438e9so1796943wrg.11
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 01:06:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MyDiWdKe1VYdsKgzDX1uadXsuftR4IzIbTjD84A1VBs=;
        b=dSEg/nxP0bKW0upzMpa19qYBKW5pzzZ36f76rOMLLugXipE4LeU1YRR1dpMVcBaTDP
         ZAguMBLxewgpdvqJ36Wm3z+qwHTK5dk9G3erJT8+Pvwl073ZKzxd9LsUr8pk5agYLSyf
         amBYOGzKPokLqHuOwU9duC2qSMNLDcwSgK2QGZzUHWTwIEVdLEXPUtahtllHj+1ee4b8
         G3+w+E3TpKSOT6699ici/kSYIwmiGd8QiWTHPqIv9RRyHZxZxEuhDxvcyXWcyzAqsUng
         lRpfWJnNep64FWr+8TagXXx5bFpFITl7QwTxuAbTVMySi3q/CthrCUYs5PgB+kTEsx3T
         IAlg==
X-Gm-Message-State: ANoB5pkYNi6UWe5Y+3ekCFgIPqJr72sGOL7ZjCYZy7q7+qtf0Rc7C3C+
        wqOVO5wdpZlvfoym38dr7wGphGp84Pxcha+Fc5igte3oAu/udeaYW8kJogycqrxsHRv4zoivKgy
        T0m+Kr291QYHysjMw
X-Received: by 2002:a05:6000:51:b0:241:553e:5040 with SMTP id k17-20020a056000005100b00241553e5040mr6948321wrx.578.1668416780299;
        Mon, 14 Nov 2022 01:06:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4l1B+wPdFoYaTSboiqdtBGcv+KQQAevPv9Adl6JHAVGpTZ8odXESHyxfOdy80t/1su8czTaA==
X-Received: by 2002:a05:6000:51:b0:241:553e:5040 with SMTP id k17-20020a056000005100b00241553e5040mr6948298wrx.578.1668416780032;
        Mon, 14 Nov 2022 01:06:20 -0800 (PST)
Received: from ?IPV6:2003:cb:c703:d300:8765:6ef2:3111:de53? (p200300cbc703d30087656ef23111de53.dip0.t-ipconnect.de. [2003:cb:c703:d300:8765:6ef2:3111:de53])
        by smtp.gmail.com with ESMTPSA id i22-20020a05600c355600b003cf894c05e4sm19299080wmq.22.2022.11.14.01.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 01:06:19 -0800 (PST)
Message-ID: <cfb2e9de-3bf8-6380-f336-dc3d7a5ecc29@redhat.com>
Date:   Mon, 14 Nov 2022 10:06:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v9 2/3] hugetlb: remove duplicate mmu notifications
Content-Language: en-US
To:     Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
References: <20221111232628.290160-1-mike.kravetz@oracle.com>
 <20221111232628.290160-3-mike.kravetz@oracle.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20221111232628.290160-3-mike.kravetz@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.11.22 00:26, Mike Kravetz wrote:
> The common hugetlb unmap routine __unmap_hugepage_range performs mmu
> notification calls.  However, in the case where __unmap_hugepage_range
> is called via __unmap_hugepage_range_final, mmu notification calls are
> performed earlier in other calling routines.
> 
> Remove mmu notification calls from __unmap_hugepage_range.  Add
> notification calls to the only other caller: unmap_hugepage_range.
> unmap_hugepage_range is called for truncation and hole punch, so
> change notification type from UNMAP to CLEAR as this is more appropriate.
> 
> Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> Reported-by: Wei Chen <harperchen1110@gmail.com>
> Cc: <stable@vger.kernel.org>

Why exactly do we care about stable backports here? What's the 
user-visible impact?

-- 
Thanks,

David / dhildenb

