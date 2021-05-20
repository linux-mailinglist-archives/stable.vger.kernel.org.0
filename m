Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2650A38A423
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhETKBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:01:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234898AbhETJ7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 05:59:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621504673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XN0KVjrZHQNAp4floqlRnA9InqWCr8Nn/WaTDhZGHb8=;
        b=aM9FqjhBRwGCI0HalTnCtbcMl5eq4QzjiChEw7WkLqKHQw8+K7Um6mIbPU/sjbhphhd1mE
        9dy9A8L/qlzC9apA97Oc44oyNYVnBIVY0L+hA01/XLdDv3MvZbtBY8LVY2K0gJDnDr7j9j
        7ZLqYDIDwPdW3wHQ7lQMjIV9CHtsK9k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-hU0Kejz6PkuWj_4FhG_8EQ-1; Thu, 20 May 2021 05:57:51 -0400
X-MC-Unique: hU0Kejz6PkuWj_4FhG_8EQ-1
Received: by mail-wm1-f71.google.com with SMTP id j128-20020a1c55860000b02901384b712094so2121689wmb.2
        for <stable@vger.kernel.org>; Thu, 20 May 2021 02:57:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XN0KVjrZHQNAp4floqlRnA9InqWCr8Nn/WaTDhZGHb8=;
        b=DBee6X3dcgUD3aKXXWNF9tsnzVQTWY3X2hJFtHeoDtaz6saUEISR3mGRTTX9udeFlS
         PbhwyI1spDiZy/4HrKjYiqJ8omxLSLSKqBYRgd8azouubGfQM5+1f4yO3IQ3die2N+wl
         /1LrJr8IzvgHEW6Nkvorjr+2fwylNBe8daeAOSgSPsi0Z8wStA1Ac6kW+hG/KLtvftyF
         fUeEID/ytpyArZH7PQK5UV19yEL5mzunM9vIUojJOeKY4Xg7DWPQ1Pq/xRtjgfmWsH5i
         pkyxaMIVaCoiumGZPLnxKnnDEWVJmT9wLW2b2//G7d3l6vER5EHHX2o8NBh12Hduu3jO
         ivwA==
X-Gm-Message-State: AOAM533BzatXmc4ATyLdiibFKq2e3nKKp+xWwSEnYxzCTEue1PWqQxA1
        xKZLVD232GYtqSUohh26x8k1Ta0ct71KB14u8mKdCpQqosTZnFAdJJEeefKpUUBxWM34Cm8N41R
        dkbvEw2fFn0InUenO
X-Received: by 2002:a7b:ce84:: with SMTP id q4mr2803862wmj.149.1621504670705;
        Thu, 20 May 2021 02:57:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7c9CdXIXMXQXdc4v65xfwHEhSGYdwW2G3Q4+Bj/Rdj0IdckMPGiWGqXAAGwE1/8tAHAaxQg==
X-Received: by 2002:a7b:ce84:: with SMTP id q4mr2803849wmj.149.1621504670510;
        Thu, 20 May 2021 02:57:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a11sm2607506wrr.48.2021.05.20.02.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 02:57:49 -0700 (PDT)
Subject: Re: [PATCH 5.10 005/289] KVM: x86/mmu: Remove the defunct
 update_pte() paging hook
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yu Zhang <yu.c.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210517140305.140529752@linuxfoundation.org>
 <20210517140305.340027792@linuxfoundation.org> <20210519195651.GA14212@amd>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <02d72616-2e95-f6cd-403c-60d5f2dfb3f1@redhat.com>
Date:   Thu, 20 May 2021 11:57:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210519195651.GA14212@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/05/21 21:56, Pavel Machek wrote:
> Hi!
> 
>> From: Sean Christopherson <seanjc@google.com>
>>
>> commit c5e2184d1544f9e56140791eff1a351bea2e63b9 upstream.
>>
>> Remove the update_pte() shadow paging logic, which was obsoleted by
>> commit 4731d4c7a077 ("KVM: MMU: out of sync shadow core"), but never
>> removed.  As pointed out by Yu, KVM never write protects leaf page
> 
> First, this is cleanup, not a bugfix.

It was reported to also fix a bug.  Commit 4731d4c7a077 is 2008 vintage, 
so it is certainly in 5.10.

Paolo

> Second, AFAICT 4731d4c7a077 ("KVM: MMU: out of sync shadow core") is
> not in 5.10, so this will break stuff according to the changelog.



