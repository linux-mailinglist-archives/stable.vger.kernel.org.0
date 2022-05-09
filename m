Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DFA51F9B0
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbiEIKXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbiEIKWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:22:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C8C418C06D
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652091541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A4c9N+E5E6J9tu3A/agG7/edCQpTWhKKSFxa5Pq6a6E=;
        b=bIQshKv3q1b7NIyg3MFyGXT5t5yMYwyfBX8brhjTiOkKng8kKiIKuSd//6x3fPsXoLhYtM
        8jmF+oU+u3fr+V2gDglVuGYtew1s5OagtRDcdmy0OM713MktTsl7q206rZNHffEpPtpeR7
        Hp2dcqHmEuob4EXYAJi27KVolkIVhcs=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-2g0FPmkiP9epDKpy82bf1g-1; Mon, 09 May 2022 06:07:03 -0400
X-MC-Unique: 2g0FPmkiP9epDKpy82bf1g-1
Received: by mail-pl1-f198.google.com with SMTP id x23-20020a170902b41700b0015ea144789fso8067031plr.13
        for <stable@vger.kernel.org>; Mon, 09 May 2022 03:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=A4c9N+E5E6J9tu3A/agG7/edCQpTWhKKSFxa5Pq6a6E=;
        b=It7MteJkAURHzsaycN3dwT0BxLQkdRHIsWWQg6XkMJMnTQgDay7A3CylzbZS4z7zCf
         XzDFvnA/koOTHKFEtVReLQj2AFGB1yeXeeG5y5tGdkkLqGqXLNRLTwDX5eyL8NJm4arg
         i/AGtKuCMyWDV9EjLM2utMil2h8y6phVF1HNz786eh8tFFwbFxU7WL6thEEATaeROdbr
         C/mm/AuGp0WNDn9Z0JuCJVg7kak1WRb+S72SeOP1AlXl8+kk7mDQ7WbULRBn8NCRhbjV
         AKO1Bgngh8QK78L1r7diSJQXYe7Lg3Fr7agVi12z6ZAt5tfrhZtA5pzaptkSjtdam403
         EIrg==
X-Gm-Message-State: AOAM532NNnpN0xdDsklWCbSsF+JUgDfpsPB2ZLJ+ENvqgQ0TlPfWY/O2
        x53/oq5//2fz1b7BpVts9jiia3HhLjLGgJEx3t9RNvhIm8o0BnK1Po+kr44FW4l8oCowaFeZpga
        TXDSmOLfDK8Fojwpdj0TDulfd26kFtFWcJ0vPfhGHJ/RCKnZPmPyqUEeyILSdI3A34Q==
X-Received: by 2002:a17:902:ec8c:b0:15e:a371:ad7d with SMTP id x12-20020a170902ec8c00b0015ea371ad7dmr15468698plg.12.1652090822312;
        Mon, 09 May 2022 03:07:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWEnAZkYpN9oP9N/Gj1qDNXSGghAzgvSKK7GNqZ1gy2yAq9uuPDfx2IpJjbypBAfa04WnlfA==
X-Received: by 2002:a17:902:ec8c:b0:15e:a371:ad7d with SMTP id x12-20020a170902ec8c00b0015ea371ad7dmr15468670plg.12.1652090821949;
        Mon, 09 May 2022 03:07:01 -0700 (PDT)
Received: from [10.72.12.57] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mu6-20020a17090b388600b001d960eaed66sm8396728pjb.42.2022.05.09.03.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 03:07:01 -0700 (PDT)
Subject: Re: [PATCH] ceph: check folio PG_private bit instead of
 folio->private
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, stable@vger.kernel.org
References: <20220508061543.318394-1-xiubli@redhat.com>
 <YnjbJ/2DbPkTAKnI@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <58f6af6a-06c3-bc03-db54-645d1a3c68ee@redhat.com>
Date:   Mon, 9 May 2022 18:06:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YnjbJ/2DbPkTAKnI@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 5/9/22 5:13 PM, Luís Henriques wrote:
> On Sun, May 08, 2022 at 02:15:43PM +0800, Xiubo Li wrote:
>> The pages in the file mapping maybe reclaimed and reused by other
>> subsystems and the page->private maybe used as flags field or
>> something else, if later that pages are used by page caches again
>> the page->private maybe not cleared as expected.
>>
>> Here will check the PG_private bit instead of the folio->private.
> I thought that a patch to set ->private to NULL in the folio code (maybe
> in folio_end_private_2()) would make sense.  But then... it probably
> wouldn't get accepted as we're probably not supposed to assume these
> fields are initialised.

Not very sure this or something like this is correct place to clear the 
->private.

Because the 'folio' and 'page' struct are like union and also in the 
'page' struct there also has a big union, such as any of the following 
field could affect the ->private:


unsigned long private;
unsigned long dma_addr_upper;
atomic_long_t pp_frag_count;
atomic_t compound_pincount;
spinlock_t ptl;


> Anyway, thanks Xiubo!
>
> Reviewed-by: Luís Henriques <lhenriques@suse.de>

Thanks Luis.

-- Xiubo


> Cheers,
> --
> Luís
>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/55421
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 63b7430e1ce6..1a108f24e7d9 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -85,7 +85,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>>   	if (folio_test_dirty(folio)) {
>>   		dout("%p dirty_folio %p idx %lu -- already dirty\n",
>>   		     mapping->host, folio, folio->index);
>> -		VM_BUG_ON_FOLIO(!folio_get_private(folio), folio);
>> +		VM_BUG_ON_FOLIO(!folio_test_private(folio), folio);
>>   		return false;
>>   	}
>>   
>> @@ -122,7 +122,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>>   	 * Reference snap context in folio->private.  Also set
>>   	 * PagePrivate so that we get invalidate_folio callback.
>>   	 */
>> -	VM_BUG_ON_FOLIO(folio_get_private(folio), folio);
>> +	VM_BUG_ON_FOLIO(folio_test_private(folio), folio);
>>   	folio_attach_private(folio, snapc);
>>   
>>   	return ceph_fscache_dirty_folio(mapping, folio);
>> @@ -150,7 +150,7 @@ static void ceph_invalidate_folio(struct folio *folio, size_t offset,
>>   	}
>>   
>>   	WARN_ON(!folio_test_locked(folio));
>> -	if (folio_get_private(folio)) {
>> +	if (folio_test_private(folio)) {
>>   		dout("%p invalidate_folio idx %lu full dirty page\n",
>>   		     inode, folio->index);
>>   
>> -- 
>> 2.36.0.rc1
>>

