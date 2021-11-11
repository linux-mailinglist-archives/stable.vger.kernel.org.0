Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7D544D5A0
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 12:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhKKLQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 06:16:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232964AbhKKLQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 06:16:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636629193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ddK+70QDiwNPVqUQi478CHOJroN8im0gkQitsQ5o/Ho=;
        b=ZxjVyJql9IypLfYUgtOAJICk3rQMWYMU99Df3mHR3+RZnfdnztLXuqt0g1Of8wM8vTGfJ3
        BwoEppJCX2DYNaGL1irzr2BzG4Dyg/zW2OnIwFcZvF0XX+LvqBz6i7EpUXsfIzGAFZbW2f
        UGtgzMsf0yY3Y3xXRz06qHPTyU8FfiI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-Jr6vKXU8O7C_BRCAq0JC9A-1; Thu, 11 Nov 2021 06:13:12 -0500
X-MC-Unique: Jr6vKXU8O7C_BRCAq0JC9A-1
Received: by mail-wm1-f70.google.com with SMTP id b145-20020a1c8097000000b003335872db8dso1953430wmd.2
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 03:13:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ddK+70QDiwNPVqUQi478CHOJroN8im0gkQitsQ5o/Ho=;
        b=LaBEO9f2xaKreHccfA4g095opIpV40VHr19qrbQQ0vD03fbeLo3I4FA519lsXWxnU6
         Pa96Dlbb9SE6xElLOe4GfetzavkfvGstXfGFkpBEI20YUjHyReVkh7wM6sb/aBLmMBaa
         F6eeF9eNPyLa1mObNDdQ/wfES92maJL4AzD8LmHYb67eEN0VbOt8P3KrpAe0hhM/zMRo
         YUK6ncoGS2BC9IWKeMbj7zEmBoCTbWUWqL10OBGkQSuj/dHgItlRtcZmRBwK+XiyS+cV
         xm6Gsz/hkZY2goDypY+lEi2foVMgRhS40IlJMhxbeOhktt/Pzwf4/lMgA4/bEoNE3tiE
         9Lfg==
X-Gm-Message-State: AOAM531NcppdFu3N3Xd1ZKoqgAQpw8B1ob3dbsMbFc89+RF1juZGr4ss
        KZpZRSv5zWxaYJPr9R3VgO6duuuUxKubLtEpOyBEbrSrHBWKDXIC/qS0bEsn65zT9N1wk2qK9Br
        znDCTxLs8OZR3wSte
X-Received: by 2002:a5d:5581:: with SMTP id i1mr7779707wrv.107.1636629191044;
        Thu, 11 Nov 2021 03:13:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyWXqQHtS7h8deuBVKj8mfFEGhzdn9o1xM6poKRsJPw8JHivw0tsu1S4SnD6oLmcppXJO704g==
X-Received: by 2002:a5d:5581:: with SMTP id i1mr7779676wrv.107.1636629190866;
        Thu, 11 Nov 2021 03:13:10 -0800 (PST)
Received: from [192.168.1.102] ([92.176.231.106])
        by smtp.gmail.com with ESMTPSA id d6sm2585948wrx.60.2021.11.11.03.13.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 03:13:10 -0800 (PST)
Message-ID: <1b6c6fbe-0b20-95e7-c1ed-bc2b2c13c044@redhat.com>
Date:   Thu, 11 Nov 2021 12:13:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [REGRESSION]: drivers/firmware: move x86 Generic System
 Framebuffers support
Content-Language: en-US
To:     Ilya Trukhanov <lahvuun@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        tzimmermann@suse.de, ardb@kernel.org, rafael@kernel.org,
        len.brown@intel.com, pavel@ucw.cz,
        dri-devel <dri-devel@lists.freedesktop.org>
References: <20211110200253.rfudkt3edbd3nsyj@lahvuun>
 <627b6cd1-3446-5e55-ea38-5283a186af39@redhat.com>
 <20211111004539.vd7nl3duciq72hkf@lahvuun>
 <af0552fb-5fb5-acae-2813-86c32e008e58@redhat.com>
 <1ddb9e88-1ef8-9888-113b-fd2a2759f019@redhat.com>
 <20211111105232.apk2msip4ng7hgsw@lahvuun>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <20211111105232.apk2msip4ng7hgsw@lahvuun>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Ilya,

On 11/11/21 11:52, Ilya Trukhanov wrote:
> On Thu, Nov 11, 2021 at 10:24:56AM +0100, Javier Martinez Canillas wrote:
>> On 11/11/21 08:31, Javier Martinez Canillas wrote:
>>
>> [snip]
>>
>>>>> And for each check /proc/fb, the kernel boot log, and if Suspend-to-RAM works.
>>>>>
>>>>> If the explanation above is correct, then I would expect (1) and (2) to work and
>>>>> (3) to also fail.
>>>>>
>>>
>>> Your testing confirms my assumptions. I'll check how this could be solved to
>>> prevent the efifb driver to be probed if there's already a framebuffer device.
>>>
>>
>> I've posted [0] which does this and also for the simplefb driver.
>>
>> [0]: https://lore.kernel.org/dri-devel/20211111092053.1328304-1-javierm@redhat.com/T/#u
> 
> I applied the patch and it fixes the issue for me.
> Thank you!
> 

Great! And thanks for tracking this down.

Feel free to add your Tested-by to v2.

Best regards,
-- 
Javier Martinez Canillas
Linux Engineering
Red Hat

