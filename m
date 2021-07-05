Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E583BBC8B
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 14:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhGEMDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 08:03:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39782 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230256AbhGEMDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 08:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625486438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Frdoj+ZjARxXF+aE+TMcxBtbn6BFh0i20yJs0cc9ZHs=;
        b=ZxdscZN6pgC21/KbzuDef+dFFGIlw9P4bTnV/lac1RoJDE4+w0P4gsWwBSokkwgj1WakO5
        V8YJ50TdBseHzuGUOtak7F8HvkuynuvbkZRaA9imh7YnFd2bN3xsdzndmRDVFzPR2iRUAQ
        mq78JG4zQrnHEXWvzFG5RvaFI7KyXOY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-8uY5ofqWOrGl1Egk5_9z5Q-1; Mon, 05 Jul 2021 08:00:37 -0400
X-MC-Unique: 8uY5ofqWOrGl1Egk5_9z5Q-1
Received: by mail-wm1-f69.google.com with SMTP id j18-20020a05600c1c12b029020a5514128fso641691wms.7
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 05:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Frdoj+ZjARxXF+aE+TMcxBtbn6BFh0i20yJs0cc9ZHs=;
        b=OBSLDptBprcksAoDC271wnusUs6GFe3mp7hxRzn64MsJwvQWgkJ9A+FO6nx8xsH2QS
         x1rLHeHXTABZXQjDSpqjnD6hZC0/1ClfjEj3XrOot5h013mZsCtm7DTp1KuRxobk2wLV
         rATf986I0JFBLdGj2Vek3yaxxs7SgqcE0RGh2mlckvrCL4tlL5JlkIV5811xnMd4z/a7
         X1r0YfPdAZBmIYg5XgJrlRafyAJ8QPjrQSujIe54MCT+1B94GUPFf8cjIJ+rECVNZJ0n
         bnBi9cSFpVKRgLzOX0xfrvXrT5nlkpTa7P/Uc9Adn6xXd0rob2ZJq8vhHnNB+fGIsh+b
         EDpQ==
X-Gm-Message-State: AOAM530CdLkdNfiKGs6OnMHytAXf8+mzbTF2oKndeOLr6b0piZR38cEs
        uf4Y89ZElRYTD4CqmQIE0VpPQ0zriWGGh1kBcg3NViEqnc58oIh3SB4JA11Ld7rODxxCfkS6fLk
        IfQkrmu/bQ2LZvzQozF46UhYG8TWDGAOvYKLn2TnpJNWyP0EPZr55OgHQgiPzhAfvDPWS
X-Received: by 2002:a05:600c:4e93:: with SMTP id f19mr14896069wmq.169.1625486436144;
        Mon, 05 Jul 2021 05:00:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEbdFb4IP520IT9EZ6hU4VMV/VOhP8VpVq70iX7ljzXN/0x5gxBj3yUJ6ZAFAQE99nDLTeZw==
X-Received: by 2002:a05:600c:4e93:: with SMTP id f19mr14896047wmq.169.1625486435917;
        Mon, 05 Jul 2021 05:00:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id a9sm13202160wrn.8.2021.07.05.05.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 05:00:35 -0700 (PDT)
Subject: Re: [PATCH 5.10 049/101] KVM: selftests: Fix kvm_check_cap()
 assertion
To:     Fuad Tabba <tabba@google.com>, Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210628142607.32218-1-sashal@kernel.org>
 <20210628142607.32218-50-sashal@kernel.org> <20210703152144.GB3004@amd>
 <CA+EHjTzO5Tsns4c6-7qXsyRtyGRwf4Yf_rBAPaVF303R1ih3EA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2dd3a5a3-8bcd-4139-a636-d6faf009d87a@redhat.com>
Date:   Mon, 5 Jul 2021 14:00:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+EHjTzO5Tsns4c6-7qXsyRtyGRwf4Yf_rBAPaVF303R1ih3EA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/07/21 09:10, Fuad Tabba wrote:
>>>
>>>        ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
>>> -     TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
>>> +     TEST_ASSERT(ret >= 0, "KVM_CHECK_EXTENSION IOCTL failed,\n"
>>>                "  rc: %i errno: %i", ret, errno);
> There's at least one case that I am aware of that potentially would
> return a value other than -1 on error, which is a check for
> KVM_CAP_MSI_DEVID (-EINVAL, -22):
> 
> https://elixir.bootlin.com/linux/latest/source/arch/arm64/kvm/arm.c#L229

In userspace that becomes -1, errno == EINVAL.  I probably just misread 
the "ret != -1" as "ret == 0" when applying this patch; it doesn't hurt 
but it is certainly not needed for stable.

Paolo

