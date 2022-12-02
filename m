Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B81640660
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 13:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiLBMIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 07:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbiLBMIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 07:08:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375BFCEFAD
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 04:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669982827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o/hK9+cXmqXiMjdThM+s0BtmMRZhVBhPO7TEP7tZb+w=;
        b=QosN3iAfpGUnQIA3G92edi7ZwejVTi6QUf6y1jMdeP+V3dZixNuAMzckBUTfN38TmOOtL9
        A4GRGG+Zkt6Ms7vYo/5jlYM9yX3CqxuIeymh0AX14+1YxW6a24IjtJDUsL/43bFmZcjRQ9
        LCgmJgStDivLVXTO6DsIHwD7qdcjqtA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-B899T-mnNoSu5Bmr9SbTjA-1; Fri, 02 Dec 2022 07:07:05 -0500
X-MC-Unique: B899T-mnNoSu5Bmr9SbTjA-1
Received: by mail-wm1-f69.google.com with SMTP id 6-20020a1c0206000000b003d082ecf13cso1066633wmc.3
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 04:07:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:subject:organization:references:cc:to:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o/hK9+cXmqXiMjdThM+s0BtmMRZhVBhPO7TEP7tZb+w=;
        b=CjiqgzgH4qeWoERBJO1Op4WGuxkH33me9Ig/uGVWO4r2yR/VeC1AqdjkoYoqRNepsy
         IB2sltfn7fAFBMi1K9ppbJ2WcMazuXlTTGKUCZqWkhpg+4+l2ZFpMhZVCSl6Fth6ItVp
         sjCz/NEehtswyxXM66qQrXwTcZdy9570HiSwMn3uCixJOWD4VtfAr8B9DpYMXhTnfCj7
         I9XuCWrhsEN4b8bTksnC9af/xQ6qMvRxxwwn6/VnorFdAike5PR+6QGFaStHQZlRxmoQ
         mjdWUR5Ys5sWYpYSzSDxhDcOCOkvjN/6dwFNh4rchiwk0hXOFrVccAwXsCsTFbjAcRxk
         oGGQ==
X-Gm-Message-State: ANoB5pkFVUZ0lUq402RldjwMHEkJ4aB3+NX48Y+QADcns679e39MVd9H
        cgKcv4qqpJTfAR9plSN3IWVMAQ/w5zg8kIieHfs+wWMevQQ0vmICr8yJp1pLqEGBhqxMiFmO7ak
        yTTPnaJRNNGoc3NbO
X-Received: by 2002:a5d:4acf:0:b0:242:4c45:d32d with SMTP id y15-20020a5d4acf000000b002424c45d32dmr72973wrs.428.1669982824659;
        Fri, 02 Dec 2022 04:07:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6AZLFtnbPa4YXwrAOL6nOHxreMKDx8qvBgFT7OAWT/I/C1FArtJMzvJcvert8qKFNYkT9GSw==
X-Received: by 2002:a5d:4acf:0:b0:242:4c45:d32d with SMTP id y15-20020a5d4acf000000b002424c45d32dmr72947wrs.428.1669982824308;
        Fri, 02 Dec 2022 04:07:04 -0800 (PST)
Received: from ?IPV6:2003:cb:c703:7a00:852e:72cd:ed76:d72f? (p200300cbc7037a00852e72cded76d72f.dip0.t-ipconnect.de. [2003:cb:c703:7a00:852e:72cd:ed76:d72f])
        by smtp.gmail.com with ESMTPSA id 11-20020a05600c228b00b003d01b84e9b2sm8092605wmf.27.2022.12.02.04.07.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 04:07:03 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------ApHjnS14u0ZxFpWQKPOgTgNr"
Message-ID: <222fc0b2-6ec0-98e7-833f-ea868b248446@redhat.com>
Date:   Fri, 2 Dec 2022 13:07:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Alistair Popple <apopple@nvidia.com>, stable@vger.kernel.org
References: <20221114000447.1681003-1-peterx@redhat.com>
 <20221114000447.1681003-2-peterx@redhat.com>
 <5ddf1310-b49f-6e66-a22a-6de361602558@redhat.com>
 <20221130142425.6a7fdfa3e5954f3c305a77ee@linux-foundation.org>
 <Y4jIHureiOd8XjDX@x1n> <a215fe2f-ef9b-1a15-f1c2-2f0bb5d5f490@redhat.com>
 <20221201143058.80296541cc6802d1e5990033@linux-foundation.org>
 <fc3e3497-053d-8e50-a504-764317b6a49a@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
In-Reply-To: <fc3e3497-053d-8e50-a504-764317b6a49a@redhat.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------ApHjnS14u0ZxFpWQKPOgTgNr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02.12.22 12:03, David Hildenbrand wrote:
> On 01.12.22 23:30, Andrew Morton wrote:
>> On Thu, 1 Dec 2022 16:42:52 +0100 David Hildenbrand <david@redhat.com> wrote:
>>
>>> On 01.12.22 16:28, Peter Xu wrote:
>>>>
>>>> I didn't reply here because I have already replied with the question in
>>>> previous version with a few attempts.  Quotting myself:
>>>>
>>>> https://lore.kernel.org/all/Y3KgYeMTdTM0FN5W@x1n/
>>>>
>>>>            The thing is recovering the pte into its original form is the
>>>>            safest approach to me, so I think we need justification on why it's
>>>>            always safe to set the write bit.
>>>>
>>>> I've also got another longer email trying to explain why I think it's the
>>>> other way round to be justfied, rather than justifying removal of the write
>>>> bit for a read migration entry, here:
>>>>
>>>
>>> And I disagree for this patch that is supposed to fix this hunk:
>>>
>>>
>>> @@ -243,11 +243,15 @@ static bool remove_migration_pte(struct page *page, struct vm_area_struct *vma,
>>>                    entry = pte_to_swp_entry(*pvmw.pte);
>>>                    if (is_write_migration_entry(entry))
>>>                            pte = maybe_mkwrite(pte, vma);
>>> +               else if (pte_swp_uffd_wp(*pvmw.pte))
>>> +                       pte = pte_mkuffd_wp(pte);
>>>     
>>>                    if (unlikely(is_zone_device_page(new))) {
>>>                            if (is_device_private_page(new)) {
>>>                                    entry = make_device_private_entry(new, pte_write(pte));
>>>                                    pte = swp_entry_to_pte(entry);
>>> +                               if (pte_swp_uffd_wp(*pvmw.pte))
>>> +                                       pte = pte_mkuffd_wp(pte);
>>>                            }
>>>                    }
>>
>> David, I'm unclear on what you mean by the above.  Can you please
>> expand?
>>
>>>
>>> There is really nothing to justify the other way around here.
>>> If it's broken fix it independently and properly backport it independenty.
>>>
>>> But we don't know about any such broken case.
>>>
>>> I have no energy to spare to argue further ;)
>>
>> This is a silent data loss bug, which is about as bad as it gets.
>> Under obscure conditions, fortunately.  But please let's keep working
>> it.  Let's aim for something minimal for backporting purposes.  We can
>> revisit any cleanliness issues later.
> 
> Okay, you activated my energy reserves.
> 
>>
>> David, do you feel that the proposed fix will at least address the bug
>> without adverse side-effects?
> 
> Usually, when I suspect something is dodgy I unconsciously push back
> harder than I usually would.
> 
> I just looked into the issue once again and realized that this patch
> here (and also my alternative proposal) most likely tackles the
> more-generic issue from the wrong direction. I found yet another such
> bug (most probably two, just too lazy to write another reproducer).
> Migration code does the right thing here -- IMHO -- and the issue should
> be fixed differently.
> 
> I'm testing an alternative patch right now and will share it later
> today, along with a reproducer.
> 

mprotect() reproducer attached.

-- 
Thanks,

David / dhildenb

--------------ApHjnS14u0ZxFpWQKPOgTgNr
Content-Type: text/x-csrc; charset=UTF-8; name="uffd-wp-mprotect.c"
Content-Disposition: attachment; filename="uffd-wp-mprotect.c"
Content-Transfer-Encoding: base64

I2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxp
Yi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8
dW5pc3RkLmg+CiNpbmNsdWRlIDxlcnJuby5oPgojaW5jbHVkZSA8cG9sbC5oPgojaW5jbHVk
ZSA8cHRocmVhZC5oPgojaW5jbHVkZSA8c3lzL21tYW4uaD4KI2luY2x1ZGUgPHN5cy9zeXNj
YWxsLmg+CiNpbmNsdWRlIDxzeXMvaW9jdGwuaD4KI2luY2x1ZGUgPGxpbnV4L21lbWZkLmg+
CiNpbmNsdWRlIDxsaW51eC91c2VyZmF1bHRmZC5oPgoKc2l6ZV90IHBhZ2VzaXplOwppbnQg
dWZmZDsKCnN0YXRpYyB2b2lkICp1ZmZkX3RocmVhZF9mbih2b2lkICphcmcpCnsKCXN0YXRp
YyBzdHJ1Y3QgdWZmZF9tc2cgbXNnOwoJc3NpemVfdCBucmVhZDsKCgl3aGlsZSAoMSkgewoJ
CXN0cnVjdCBwb2xsZmQgcG9sbGZkOwoJCWludCBucmVhZHk7CgoJCXBvbGxmZC5mZCA9IHVm
ZmQ7CgkJcG9sbGZkLmV2ZW50cyA9IFBPTExJTjsKCQlucmVhZHkgPSBwb2xsKCZwb2xsZmQs
IDEsIC0xKTsKCQlpZiAobnJlYWR5ID09IC0xKSB7CgkJCWZwcmludGYoc3RkZXJyLCAicG9s
bCgpIGZhaWxlZDogJWRcbiIsIGVycm5vKTsKCQkJZXhpdCgxKTsKCQl9CgoJCW5yZWFkID0g
cmVhZCh1ZmZkLCAmbXNnLCBzaXplb2YobXNnKSk7CgkJaWYgKG5yZWFkIDw9IDApCgkJCWNv
bnRpbnVlOwoKCQlpZiAobXNnLmV2ZW50ICE9IFVGRkRfRVZFTlRfUEFHRUZBVUxUIHx8CgkJ
ICAgICEobXNnLmFyZy5wYWdlZmF1bHQuZmxhZ3MgJiBVRkZEX1BBR0VGQVVMVF9GTEFHX1dQ
KSkgewoJCQlwcmludGYoIkZBSUw6IHdyb25nIHVmZmQtd3AgZXZlbnQgZmlyZWRcbiIpOwoJ
CQlleGl0KDEpOwoJCX0KCgkJcHJpbnRmKCJQQVNTOiB1ZmZkLXdwIGZpcmVkXG4iKTsKCQll
eGl0KDApOwoJfQp9CgpzdGF0aWMgaW50IHNldHVwX3VmZmQoY2hhciAqbWFwKQp7CglzdHJ1
Y3QgdWZmZGlvX2FwaSB1ZmZkaW9fYXBpOwoJc3RydWN0IHVmZmRpb19yZWdpc3RlciB1ZmZk
aW9fcmVnaXN0ZXI7CglzdHJ1Y3QgdWZmZGlvX3JhbmdlIHVmZmRfcmFuZ2U7CglwdGhyZWFk
X3QgdGhyZWFkOwoKCXVmZmQgPSBzeXNjYWxsKF9fTlJfdXNlcmZhdWx0ZmQsCgkJICAgICAg
IE9fQ0xPRVhFQyB8IE9fTk9OQkxPQ0sgfCBVRkZEX1VTRVJfTU9ERV9PTkxZKTsKCWlmICh1
ZmZkIDwgMCkgewoJCWZwcmludGYoc3RkZXJyLCAic3lzY2FsbCgpIGZhaWxlZDogJWRcbiIs
IGVycm5vKTsKCQlyZXR1cm4gLWVycm5vOwoJfQoKCXVmZmRpb19hcGkuYXBpID0gVUZGRF9B
UEk7Cgl1ZmZkaW9fYXBpLmZlYXR1cmVzID0gVUZGRF9GRUFUVVJFX1BBR0VGQVVMVF9GTEFH
X1dQOwoJaWYgKGlvY3RsKHVmZmQsIFVGRkRJT19BUEksICZ1ZmZkaW9fYXBpKSA8IDApIHsK
CQlmcHJpbnRmKHN0ZGVyciwgIlVGRkRJT19BUEkgZmFpbGVkOiAlZFxuIiwgZXJybm8pOwoJ
CXJldHVybiAtZXJybm87Cgl9CgoJaWYgKCEodWZmZGlvX2FwaS5mZWF0dXJlcyAmIFVGRkRf
RkVBVFVSRV9QQUdFRkFVTFRfRkxBR19XUCkpIHsKCQlmcHJpbnRmKHN0ZGVyciwgIlVGRkRf
RkVBVFVSRV9XUklURVBST1RFQ1QgbWlzc2luZ1xuIik7CgkJcmV0dXJuIC1FTk9TWVM7Cgl9
CgoJdWZmZGlvX3JlZ2lzdGVyLnJhbmdlLnN0YXJ0ID0gKHVuc2lnbmVkIGxvbmcpIG1hcDsK
CXVmZmRpb19yZWdpc3Rlci5yYW5nZS5sZW4gPSBwYWdlc2l6ZTsKCXVmZmRpb19yZWdpc3Rl
ci5tb2RlID0gVUZGRElPX1JFR0lTVEVSX01PREVfV1A7CglpZiAoaW9jdGwodWZmZCwgVUZG
RElPX1JFR0lTVEVSLCAmdWZmZGlvX3JlZ2lzdGVyKSA8IDApIHsKCQlmcHJpbnRmKHN0ZGVy
ciwgIlVGRkRJT19SRUdJU1RFUiBmYWlsZWQ6ICVkXG4iLCBlcnJubyk7CgkJcmV0dXJuIC1l
cnJubzsKCX0KCglwdGhyZWFkX2NyZWF0ZSgmdGhyZWFkLCBOVUxMLCB1ZmZkX3RocmVhZF9m
biwgTlVMTCk7CgoJcmV0dXJuIDA7Cn0KCmludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJn
dikKewoJc3RydWN0IHVmZmRpb193cml0ZXByb3RlY3QgdWZmZF93cml0ZXByb3RlY3Q7Cglj
aGFyICptYXA7CglpbnQgZmQ7CgoJcGFnZXNpemUgPSBnZXRwYWdlc2l6ZSgpOwoJZmQgPSBt
ZW1mZF9jcmVhdGUoInRlc3QiLCAwKTsKCWlmIChmZCA8IDApIHsKCQlmcHJpbnRmKHN0ZGVy
ciwgIm1lbWZkX2NyZWF0ZSgpIGZhaWxlZFxuIik7CgkJcmV0dXJuIC1lcnJubzsKCX0KCWlm
IChmdHJ1bmNhdGUoZmQsIHBhZ2VzaXplKSkgewoJCWZwcmludGYoc3RkZXJyLCAiZnRydW5j
YXRlKCkgZmFpbGVkXG4iKTsKCQlyZXR1cm4gLWVycm5vOwoJfQoKCS8qIFN0YXJ0IG91dCB3
aXRob3V0IHdyaXRlIHByb3RlY3Rpb24uICovCgltYXAgPSBtbWFwKE5VTEwsIHBhZ2VzaXpl
LCBQUk9UX1JFQUR8UFJPVF9XUklURSwgTUFQX1NIQVJFRCwgZmQsIDApOwoJaWYgKG1hcCA9
PSBNQVBfRkFJTEVEKSB7CgkJZnByaW50ZihzdGRlcnIsICJtbWFwKCkgZmFpbGVkXG4iKTsK
CQlyZXR1cm4gLWVycm5vOwoJfQoKCWlmIChzZXR1cF91ZmZkKG1hcCkpCgkJcmV0dXJuIDE7
CgoJLyogUG9wdWxhdGUgYSBwYWdlIC4uLiAqLwoJbWVtc2V0KG1hcCwgMCwgcGFnZXNpemUp
OwoKCS8qIC4uLiBhbmQgd3JpdGUtcHJvdGVjdCBpdCB1c2luZyB1ZmZkLXdwLiAqLwoJdWZm
ZF93cml0ZXByb3RlY3QucmFuZ2Uuc3RhcnQgPSAodW5zaWduZWQgbG9uZykgbWFwOwoJdWZm
ZF93cml0ZXByb3RlY3QucmFuZ2UubGVuID0gcGFnZXNpemU7Cgl1ZmZkX3dyaXRlcHJvdGVj
dC5tb2RlID0gVUZGRElPX1dSSVRFUFJPVEVDVF9NT0RFX1dQOwoJaWYgKGlvY3RsKHVmZmQs
IFVGRkRJT19XUklURVBST1RFQ1QsICZ1ZmZkX3dyaXRlcHJvdGVjdCkpIHsKCQlmcHJpbnRm
KHN0ZGVyciwgIlVGRkRJT19XUklURVBST1RFQ1QgZmFpbGVkOiAlZFxuIiwgZXJybm8pOwoJ
CXJldHVybiAtZXJybm87Cgl9CgoJLyogV3JpdGUtcHJvdGVjdCB0aGUgd2hvbGUgbWFwcGlu
ZyB0ZW1wb3JhcmlseS4gKi8KCW1wcm90ZWN0KG1hcCwgcGFnZXNpemUsIFBST1RfUkVBRCk7
CgltcHJvdGVjdChtYXAsIHBhZ2VzaXplLCBQUk9UX1JFQUR8UFJPVF9XUklURSk7CgoJLyog
VGVzdCBpZiB1ZmZkLXdwIGZpcmVzLiAqLwoJbWVtc2V0KG1hcCwgMSwgcGFnZXNpemUpOwoK
CXByaW50ZigiRkFJTDogdWZmZC13cCBkaWQgbm90IGZpcmVcbiIpOwoJcmV0dXJuIDE7Cn0K


--------------ApHjnS14u0ZxFpWQKPOgTgNr--

