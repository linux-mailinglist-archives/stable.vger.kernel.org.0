Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2ADB3A5F8E
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 11:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhFNJ6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 05:58:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232733AbhFNJ6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 05:58:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623664568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WIaSk05dc2X+GU8YSEPQ5ZPX9PqOYAawKRFQecWsg2E=;
        b=YXUKk5f+k5qab2sGKIRoHdpbSOFyD29YCZzMUy/D69JhkVEo0XA0PHkEYgiwp1xJidzWe0
        6k/ItUmf0is0Go5s2uGIceqs20CCceZviK6yF8qI/AAO3VjPxVw4o5opphkidPMVDfhaW9
        sENj1GmfCR5WSTfNbL7sj/DXqTXeKm4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-RzXMwpK7PO2TMtUmyxqA0w-1; Mon, 14 Jun 2021 05:56:07 -0400
X-MC-Unique: RzXMwpK7PO2TMtUmyxqA0w-1
Received: by mail-ej1-f72.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso2833772ejc.7
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 02:56:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WIaSk05dc2X+GU8YSEPQ5ZPX9PqOYAawKRFQecWsg2E=;
        b=RXat2+4ozYJR6mHEUu7a7pKJ7xlLSe9Z+moo4OTkb3GM76slPCq9aFJJWOxtQCrz99
         D3ATh+pUuWuDMKWFnbB6tF7Scm8yiZbmUzMucj90LjgJ+52k2UCKT/u+NaFwbFhf1b3g
         kcEePthf1gUI+Apn6R9XDYBHuTlXMVtrsMlmFxjGobiJ6VBp2ME3zG3oKbRODVeJNHwv
         agllvS3sj1NxAr/8uFYXkpr7a8PfVs0d9Nxan7inJb+O/n83fL40WuhttM60fzl359sl
         6pCWhr6B/KFujkJBzB9b9DaXi7yjuf9OdN0mapylPrgA1UGj1ckJRYJpg6ULV7Fh0dX8
         08lg==
X-Gm-Message-State: AOAM531CtU3Ykqd1K3qP5VJB1NdGIcJ/HgPjOkcbtfYh8mKHZY5F6eBo
        zT8SkiVAK0sCceWHSO4Q/5BYgKtqJVXqOlH7VMx7dNi3DKOrN7+phnEzh1cTefpvjgDpsP1Atoh
        BicYVAZJ5oxVkqUID
X-Received: by 2002:a17:907:988a:: with SMTP id ja10mr14207270ejc.527.1623664566186;
        Mon, 14 Jun 2021 02:56:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyba8ROZp6r7bMKAu5bg2acvAeWoU9GMvEDiIzzJC7nxALtPtXHEpbnEqcigWvgyzIwb78h+g==
X-Received: by 2002:a17:907:988a:: with SMTP id ja10mr14207259ejc.527.1623664566037;
        Mon, 14 Jun 2021 02:56:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h19sm6827422ejy.82.2021.06.14.02.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 02:56:05 -0700 (PDT)
Subject: Re: compiler.h:417:38: error: call to '__compiletime_assert_59'
 declared with attribute error: BUILD_BUG_ON failed: sizeof(_i) > sizeof(long)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
References: <CA+G9fYuBo_WgjtW1BugKLPeYnmLEe65zU7Ttt=FB2uqMzZy1eQ@mail.gmail.com>
 <YMYepbrAxKbgaXi8@kroah.com>
 <CA+G9fYsEwbLh2Tisdmsmb=yThZCmhWi4ZzqearrN_nQXStoJVA@mail.gmail.com>
 <YMbmsV7JYb7e1CVO@kroah.com>
 <CA+G9fYtBWywZDePUiwVDAAqhAdDKNtUtyZScJy01eO61o=5ppw@mail.gmail.com>
 <YMcU/ra96gxzlBhm@kroah.com> <YMcV4PfzrZWhmLOO@kroah.com>
 <CA+G9fYsqbiWe=ducTfwX_fyi+WvsBn2Eibi0BuuTA_m3iGn-bg@mail.gmail.com>
 <YMclihTkCclmLpYP@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <79fa0e44-b90a-c3d7-2d27-d46115e93bd4@redhat.com>
Date:   Mon, 14 Jun 2021 11:56:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMclihTkCclmLpYP@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/06/21 11:46, Greg Kroah-Hartman wrote:
>>> Doh, I need 4422829e8053 ("kvm: fix previous commit for 32-bit builds")
>>> as well...
>>>
>>> Nevermind, will go queue that up right now...
>>
>> The reported build issue is fixed now.
> Wonderful, thanks for checking and letting me know.

Sorry for forgetting the Cc: stable and Fixes: tag.  This one is 101% on 
me...

Paolo

