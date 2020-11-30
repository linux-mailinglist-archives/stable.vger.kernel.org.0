Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDCB2C8BCC
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 18:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgK3Rye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 12:54:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726505AbgK3Ryd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 12:54:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606758787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XZHdMrptq2/rYXjufX3+GIBx1xnGVoh3uBEQ7r4wKDM=;
        b=bQnUFR1ur6N1sP66V9HArMJTwi8a5WK7HYD8KgTIp/AmoHPySNSboefcj+ICHEdtyodky+
        TBC+JrRGxMEOebA1QuQ+xboWLj0Uf2Knf/WQhrLTf4Vae+UtSvdATaZT+eOsuss0VHE/YE
        Ce6szbdPmFbSTIADNazk/PSqI+ILm+c=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-_rQ1CKyoNNaO4aQKRR02kg-1; Mon, 30 Nov 2020 12:53:02 -0500
X-MC-Unique: _rQ1CKyoNNaO4aQKRR02kg-1
Received: by mail-ed1-f69.google.com with SMTP id f20so7163168edx.23
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 09:53:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XZHdMrptq2/rYXjufX3+GIBx1xnGVoh3uBEQ7r4wKDM=;
        b=pfWW/bh3d3k+udQ0m8M34phyDD6vrkW4kZ/Jm6RGB8MN13d/IqeOT7B0as4nDxv731
         tm+PifQ2jUAdsjn1TT2rsAx4jBY6jyEgQS2jg2BctPBiidX3szDSw3sYwtR/7YMddeUW
         4d35KzWu200Jf023fJxC9eFKO3mwoAtpHXwqHexRJT5a5yvIPYFXveRSf1MHrMpj/hp1
         6MEfWHXomv3unMg9qDhgK+JbGPnD3S1Q5sAIA8ZA2dkEKR5px+RM44BVPMdNbr+g9gO4
         B4+64MiFGpOfQ9mTscaMj4t8dn0FD6YyHwF/vGaLlHSFpS1wQqyR34HcGuRjxFMgJ1ln
         4U5Q==
X-Gm-Message-State: AOAM530Xtt/jeUuqE486lusxpA/jRtOIHoqETVLVC6WvobXkGjiVin16
        bSwYlJjmXfNLLvbKQkj7qXLMw9Ti6B9cUvefYQBBkrkO/ABkO+dRPWrNCNVQPKMykFWrdCCVroV
        iFMHTzk5SdqeEtUus
X-Received: by 2002:aa7:d2c9:: with SMTP id k9mr18165154edr.74.1606758781769;
        Mon, 30 Nov 2020 09:53:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzr0C3ztJydvyz+oFfxr6BS9zKoQLZ9ul0+KLwEWxb/tzWQGQh/4ALcMPa0sNYIu2m1iyoA+g==
X-Received: by 2002:aa7:d2c9:: with SMTP id k9mr18165131edr.74.1606758781630;
        Mon, 30 Nov 2020 09:53:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k17sm8657435ejh.103.2020.11.30.09.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 09:53:00 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <20201130173832.GR643756@sasha-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <238cbdd1-dabc-d1c1-cff8-c9604a0c9b95@redhat.com>
Date:   Mon, 30 Nov 2020 18:52:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201130173832.GR643756@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/11/20 18:38, Sasha Levin wrote:
>> I am not aware of any public CI being done _at all_ done on 
>> vhost-scsi, by CKI or everyone else.  So autoselection should be done 
>> only on subsystems that have very high coverage in CI.
> 
> Where can I find a testsuite for virtio/vhost? I see one for KVM, but
> where is the one that the maintainers of virtio/vhost run on patches
> that come in?

I don't know of any, especially for vhost-scsi.  MikeC?

Paolo

