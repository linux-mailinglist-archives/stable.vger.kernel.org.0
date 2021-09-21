Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2254133AE
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 15:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhIUNGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 09:06:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230098AbhIUNGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 09:06:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632229476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DEFJseg8rq7SE74sOaoFIgE1jPfm5DbO1epvMS8BpNI=;
        b=OyfnwmV4UDsNDYE1ekaal0phNcYdQNqJx1o+5dd7sQxilIWQ5IxK8LZI2SeCAL2GP37Sku
        HarARw5br5dzhdtq2gE59JAgX/dcR1IaUO//f6jiPgSogU93/JJ9lur9wrwR2I1NarWAXZ
        xObAg9pV+jtdN70MQjzLuhYShwtkyko=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-xHTX6NKYNLKr3RHQF4XGPg-1; Tue, 21 Sep 2021 09:04:35 -0400
X-MC-Unique: xHTX6NKYNLKr3RHQF4XGPg-1
Received: by mail-ed1-f72.google.com with SMTP id q17-20020a50c351000000b003d81427d25cso12480503edb.15
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 06:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DEFJseg8rq7SE74sOaoFIgE1jPfm5DbO1epvMS8BpNI=;
        b=K2dgWuX/6NSdCZh3mQvhWwMLofm6jjM9aIaLq25pCQSsvmnml5ThIqTt/XVFWvqSaZ
         w8mmqh6yfTd6mFUlr5l50UnxK9SzPYbsIn5YuKfrHDjiy0paR7aKQvT2cm9rTH7slYRt
         9Dd72DNxFZQKPDE4rguRVHotWmp5youyu963avA6ZJA7UK+vDJM5LyXjCPsD8CVnZ1Sr
         Z+jTOaiCsNiQo0EdKRm6uURPhCm8clZgLsJeT0wVSuXY3rycLYFl6trQw4Cwc/Z0g/BZ
         c2NlL8jY9jhmiN3FlYZQMr5+ffsZFTsH754zNSDq+f+fp3mqoE/ywBSaskI4iiGQYU0g
         VlNw==
X-Gm-Message-State: AOAM531mdj9WlWbw8MPnyM3rq3ZPfsdwGvq0ndFLIcvV4ElrM8VjxZtt
        jlY8kxsGuRnOmXVCQlAVPVTR8+IJyV7TlXhcInl89wi4Uswc5ljeBWJ6KYgtDyySRAqcASLo+BJ
        6lEyqV7Z56lpMeVGt
X-Received: by 2002:a05:6402:2cd:: with SMTP id b13mr35310670edx.267.1632229473814;
        Tue, 21 Sep 2021 06:04:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDA29e1Aksu1e28kf6zXlPoA7bgowJwNPG2Y3YjfjcqiNKuIQK2uhaN2r0tICRjjw+CMDp6A==
X-Received: by 2002:a05:6402:2cd:: with SMTP id b13mr35310646edx.267.1632229473573;
        Tue, 21 Sep 2021 06:04:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y5sm8429318edt.21.2021.09.21.06.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 06:04:32 -0700 (PDT)
Subject: Re: [PATCH 0/1] KVM: s390: backport for stable of "KVM: s390: index
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, KVM <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
References: <20210920150616.15668-1-borntraeger@de.ibm.com>
 <b9b9e014-d8d9-1a76-679b-cd7af54ad3f9@redhat.com>
 <e8881cf8-987c-e2b2-5cda-8e3c5a19cc99@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cc34be64-cfd5-798a-9192-be0c6b839224@redhat.com>
Date:   Tue, 21 Sep 2021 15:04:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e8881cf8-987c-e2b2-5cda-8e3c5a19cc99@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/09/21 10:46, Christian Borntraeger wrote:
>>> 
>> 
>> Sure, I suppose you're going to send a separate backport that I can
>> ack.
> 
> It does seem to apply when cherry-picked, but I can send it as a
> patch if you and Greg prefer it that way.

Yes, please do!  Thanks,

Paolo

