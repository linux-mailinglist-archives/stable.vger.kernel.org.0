Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACDD40DBDB
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbhIPN4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:56:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40925 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237400AbhIPN4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 09:56:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631800480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ikJ3si1kDclS3fcOTgbT9nf0CRiQnFWds5xl3DPf3mI=;
        b=GRS/nS8ReENH7yrv3KXGwlduxV5aTO2OKL9vaOTyyowqpgZBv7QCAiBEzrLOvwSyH0DR4J
        DPkIvy8NsQKNz/YhTjkIq1GBMhGhJ0kN1Zmu9t4AjgNCUByFJ2mKYCPMuTeWjAkefqtf06
        LPFAFePj1CH7XvZiEJiNpEWL0u52n3E=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-FiezGnKfMa6KIilDSKd2hw-1; Thu, 16 Sep 2021 09:54:39 -0400
X-MC-Unique: FiezGnKfMa6KIilDSKd2hw-1
Received: by mail-ed1-f72.google.com with SMTP id w24-20020a056402071800b003cfc05329f8so5512362edx.19
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 06:54:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ikJ3si1kDclS3fcOTgbT9nf0CRiQnFWds5xl3DPf3mI=;
        b=LSB8EunOxJ28ZTuSAtMQZKr5ixjkNNOJfj89uF01p0sosBTIVN7U9eBPh695Hl/4nU
         6d4nim/GoTBpVsCX3dUPq/1PcdB/nuZeuj9APKxc3o59JaE8UXIQWcyEoihFUXVyfOkU
         Gqah0JhPH6/wgFvEt8C/IDST9xFRJVT/syfRaD81M8y2tTbb2Mnn8vOsTh7ACdSJo4lJ
         reHkkk6gXLBBCyaMUeR+y+ReAAvnT2iPwz8HAOz8osY/ozb9EmPzlciVML84LODTGcFT
         tNAL6Sbboel0oevXVuKRha+7sQZgYVBPjNu/1SnQpOodujTvK7r7cD3Gk6IioX9IKvUQ
         j2Jw==
X-Gm-Message-State: AOAM533p+Dp1B6lZ3TX+jG/ZjIoYJUF8994GHfoZKgzojUQX/JK3TTjC
        dh73GCaJb/O8c9p0a+AHvqkuEDOz7MJnY8WcQwzDPPb5gxYVF8VzrjFLbanjGr7AeiaanCvNB3q
        rEgfOhJBL2UDvefQy
X-Received: by 2002:a50:bb09:: with SMTP id y9mr6519960ede.89.1631800477828;
        Thu, 16 Sep 2021 06:54:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBAgty7iDUXTe1UxqpNl2Z9dGbRY7r8zg2vpKQxNAYJhCtuzmlhrUAjoKproXd/Q2Qc6u1Qw==
X-Received: by 2002:a50:bb09:: with SMTP id y9mr6519951ede.89.1631800477701;
        Thu, 16 Sep 2021 06:54:37 -0700 (PDT)
Received: from ?IPV6:2a02:1205:5026:3180:7cea:b72b:7e73:8d8? ([2a02:1205:5026:3180:7cea:b72b:7e73:8d8])
        by smtp.gmail.com with ESMTPSA id c21sm1188237ejz.69.2021.09.16.06.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 06:54:37 -0700 (PDT)
Message-ID: <e5b4ad1d-4a4f-ae47-5c85-22842c1b44cc@redhat.com>
Date:   Thu, 16 Sep 2021 15:54:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work when
 GFXOFF is disabled" failed to apply to 5.14-stable tree
Content-Language: en-CA
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     alexander.deucher@amd.com, christian.koenig@amd.com,
        evan.quan@amd.com, lijo.lazar@amd.com, stable@vger.kernel.org
References: <163179752354221@kroah.com>
 <7fe8e175-efdc-b7d9-ab86-44aeec60c2e9@redhat.com>
 <YUNLMkxQPw/empni@kroah.com>
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <mdaenzer@redhat.com>
In-Reply-To: <YUNLMkxQPw/empni@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-09-16 15:48, Greg KH wrote:
> On Thu, Sep 16, 2021 at 03:39:16PM +0200, Michel Dänzer wrote:
>> On 2021-09-16 15:05, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.14-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> It's already in 5.14, commit 32bc8f8373d2d6a681c96e4b25dca60d4d1c6016.
> 
> Odd, how were we supposed to know that?

Looks like the fix was merged separately for 5.14 and 5.15. I don't know 
how/why that happened. Alex / Christian?


-- 
Earthling Michel Dänzer               |               https://redhat.com
Libre software enthusiast             |             Mesa and X developer

