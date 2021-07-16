Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B853CB8ED
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 16:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240509AbhGPOoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 10:44:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21024 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240194AbhGPOoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 10:44:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626446469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z8XgazHaSaFYbppKUAFPtdkOLmoZld8wNP3xTo/qIeI=;
        b=e0RIf6o3oAZkyRtGj7VlWpxPlWqVOBDN/yzSfVUHeLMOMpeHlFQET7KrSMuggPa2BVWeGb
        vCxKymEDUv8N051cSmojyc0Oqzh/4VUCEKTKWj2Gycn28fI8PpS3F1DGHWeJNiGBXGBpYW
        vixFUCleOEG4uSFeOain0FqUQTswXgM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-Cwl_L26gM2GZdm6qa-P-cQ-1; Fri, 16 Jul 2021 10:41:08 -0400
X-MC-Unique: Cwl_L26gM2GZdm6qa-P-cQ-1
Received: by mail-wm1-f72.google.com with SMTP id v25-20020a1cf7190000b0290197a4be97b7so3246050wmh.9
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 07:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z8XgazHaSaFYbppKUAFPtdkOLmoZld8wNP3xTo/qIeI=;
        b=pb9l7c+68mtLGf8D7PWhddfMZNq7rviKvpyp+POseb4Z0OSDZdx9iWEH28J1ytE0fu
         mjChwETgHhQ7/6rC8bd40xwrTdWw1mfWiBfA6xfcPkYXnQjGJGib0BeuR0bFcqPERyk6
         FpvvdFYsGIcc4HJPyXEy0/ezDKR8+HkgjFbo+baWSHKUzB9za0cc9QaQpknOPMz+CYAa
         86iO6hGjsjsMquGY7DQO5rXfsh+eL+cEONSF9t1w30CsKWGjKVCnfr7yaMktlt1fo25I
         cis77Cs/jCfU1EfbrullvxX/V/I8U14Ox52YX8bSFna02fEDcvoa5u9092W0uxXjiFpl
         tZMA==
X-Gm-Message-State: AOAM532kkbYd6nDNJMsYCnEskzL1bs2WJl/aigvnfCyeTORcD43EVlNr
        IPLXUFnuvj/E9cwxzZ6MQjvkfTiWMsFQ0KoBSpXLt+UixXTags4pyYHBcbktoGO5yGbOwAwlUCp
        lNDyhrGirG/evGodYvsPYps0mysxvlJJZ9PE1v6y+CmkScx8hFOTF8RKO5U8xpnpvUEMO
X-Received: by 2002:a05:600c:1c08:: with SMTP id j8mr11154060wms.50.1626446466486;
        Fri, 16 Jul 2021 07:41:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWdoky2KjCr2ox5O8bhUTxWJ8ULL5wgA4y7xfyrLqCZMspJJ4SpfnI+K8oRPVEc6zZVQhJwA==
X-Received: by 2002:a05:600c:1c08:: with SMTP id j8mr11154030wms.50.1626446466168;
        Fri, 16 Jul 2021 07:41:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 140sm8282837wmb.43.2021.07.16.07.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 07:41:05 -0700 (PDT)
To:     stsp <stsp2@yandex.ru>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210714213846.854837-1-pbonzini@redhat.com>
 <6f2305c0-77a8-42af-f5e9-2664119b6b2e@yandex.ru>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: accept userspace interrupt only if no event is
 injected
Message-ID: <f6bd5b5b-2a4a-64e2-0a7b-a2bcdd3f541d@redhat.com>
Date:   Fri, 16 Jul 2021 16:41:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6f2305c0-77a8-42af-f5e9-2664119b6b2e@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16/07/21 09:27, stsp wrote:
>> +    if (kvm_event_needs_reinjection(vcpu))
>> +        return false;
>> +
> 
> kvm_event_needs_reinjection() seems
> to miss exception.pending check.
> Don't we need it too?

Yes, good point.

Paolo

