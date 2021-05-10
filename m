Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70B2377B42
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 06:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhEJEfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 00:35:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbhEJEfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 00:35:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620621283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5uXhSn/w6CZf/GcmcktyqqIlCH6uf+CBfk9ICAipjiM=;
        b=IHcBFy2SbDAvl98zl7RTGCFOWV11fu7H2elgpvqrD+IIX1IhRjfVWIXNQ9v+ZBwnNPRna0
        +oJBKV/IYm+IrYPRjpejDufjDq6cr47QUUuk/xjtoVYcU2GsDtF/Kyg/7F3Wy3q3cuLmZD
        IS01ASJ8pqOwO9i1k8pWkP8Baeo+XfY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-ZqjRI7o2NpaobhRTmnllxw-1; Mon, 10 May 2021 00:34:41 -0400
X-MC-Unique: ZqjRI7o2NpaobhRTmnllxw-1
Received: by mail-pl1-f199.google.com with SMTP id l18-20020a170902e2d2b02900eefb0acd12so4975423plc.18
        for <stable@vger.kernel.org>; Sun, 09 May 2021 21:34:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5uXhSn/w6CZf/GcmcktyqqIlCH6uf+CBfk9ICAipjiM=;
        b=qECIILs0xgbSaH+pie0xmB6Nr0ddkbjXGFSulupp+DxnToUnp6oNx2KD0o8WdFs3NS
         NOByWi/DgqO/DoWfWo1Ape9IIaOmuFuo6TblDrWcwDJAWHNgsSLYGz3dbeU+ln8K7mRX
         8pclafuyew/5aA/4HOc1PIgxYqegfvl3PY1wPPnqjR2AthF41NVi5G+G/BuCjDEzz8DW
         85lhzo7J4UjT0seJut47+JXidJuUyeqVFEhdFpEIVzU5a0wLPf9tY4qrKX3p6/GqgqpO
         H0HEpClrjLflZd7h9g/3tmVOtscGsKNsBEOKmpS3MazTqNeYN47zG5r8nAr4roX93+3g
         JtUw==
X-Gm-Message-State: AOAM531d/osQuItE1z6FhxCEZQNpqg/8aFMIqVbfR38/k/3rHtt4oIhD
        tO0c4hyTsVgiBsVTpP3pTyXxnz8RJWZajnIpVwHLd5mhwdIU3omwV3FKQAkaJPrw+4g1RMJL73s
        yOs37vwO67DH0nmQ59VJ00L+f3QtHuHJPfBePBzLGSu46v3dg5aUIfAdZ9A9FLWkDgSzb
X-Received: by 2002:a63:4512:: with SMTP id s18mr23457208pga.275.1620621277380;
        Sun, 09 May 2021 21:34:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygmSy3Fdas8cpmiqmQfqfLtuCoMdKjuVFbGs0UxKU35ro+F/44i5Shmvs9MQ/0/XJwJ1PxMg==
X-Received: by 2002:a63:4512:: with SMTP id s18mr23457181pga.275.1620621277002;
        Sun, 09 May 2021 21:34:37 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h36sm10483782pgh.63.2021.05.09.21.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 21:34:35 -0700 (PDT)
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        maz@kernel.org, alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, cohuck@redhat.com,
        stable@vger.kernel.org
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
 <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e5d63867-7a4a-963f-9fbd-741ccd3ec360@redhat.com>
Date:   Mon, 10 May 2021 12:34:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2021/5/10 上午11:00, Zhu, Lingshan 写道:
>
>
> On 5/10/2021 10:43 AM, Jason Wang wrote:
>>
>> 在 2021/5/8 下午3:11, Zhu Lingshan 写道:
>>> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
>>>
>>> The reverted commit may cause VM freeze on arm64 platform.
>>> Because on arm64 platform, stop a consumer will suspend the VM,
>>> the VM will freeze without a start consumer
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>
>>
>> Acked-by: Jason Wang <jasowang@redhat.com>
>>
>> Please resubmit with the formal process of stable 
>> (stable-kernel-rules.rst).
> sure, I will re-submit it to stable kernel once it is merged into 
> Linus tree.
>
> Thanks


I think it's better to resubmit (option 1), see how 
stable-kernel-rules.rst said:

""

:ref:`option_1` is **strongly** preferred, is the easiest and most common.
:ref:`option_2` and :ref:`option_3` are more useful if the patch isn't 
deemed
worthy at the time it is applied to a public git tree (for instance, because
it deserves more regression testing first).

"""

Thanks


>>
>> Thanks
>>
>>
>>> ---
>>>   virt/lib/irqbypass.c | 16 ++++++----------
>>>   1 file changed, 6 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
>>> index c9bb3957f58a..28fda42e471b 100644
>>> --- a/virt/lib/irqbypass.c
>>> +++ b/virt/lib/irqbypass.c
>>> @@ -40,21 +40,17 @@ static int __connect(struct irq_bypass_producer 
>>> *prod,
>>>       if (prod->add_consumer)
>>>           ret = prod->add_consumer(prod, cons);
>>>   -    if (ret)
>>> -        goto err_add_consumer;
>>> -
>>> -    ret = cons->add_producer(cons, prod);
>>> -    if (ret)
>>> -        goto err_add_producer;
>>> +    if (!ret) {
>>> +        ret = cons->add_producer(cons, prod);
>>> +        if (ret && prod->del_consumer)
>>> +            prod->del_consumer(prod, cons);
>>> +    }
>>>         if (cons->start)
>>>           cons->start(cons);
>>>       if (prod->start)
>>>           prod->start(prod);
>>> -err_add_producer:
>>> -    if (prod->del_consumer)
>>> -        prod->del_consumer(prod, cons);
>>> -err_add_consumer:
>>> +
>>>       return ret;
>>>   }
>>
>

