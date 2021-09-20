Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD294111BD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 11:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbhITJPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 05:15:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236382AbhITJN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 05:13:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632129119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GAWz0EAWe761Vp6QEPsP+9N2+xxnwu0OsIwKiqcezDA=;
        b=eUtgyVGg5EmPiIVzUueeOrcBttEIziFgSEfXqwxLws214so/0BobOGU+MjhgKgi32Jkth2
        ZCIbqRnsAGNmCmh9K/qqtTcfK1vb8uR1Kibiw8LBC22Z/QJOltsRKtLA3Vwqwm9weo1eU4
        rx0JFIF4+gxMKiWolgL/D2A0Fj+fHv0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-RMzZM7nUOiSQ10-MCUqv_A-1; Mon, 20 Sep 2021 05:11:54 -0400
X-MC-Unique: RMzZM7nUOiSQ10-MCUqv_A-1
Received: by mail-qv1-f70.google.com with SMTP id h9-20020a05621413a900b0037a2d3eaf8fso180906173qvz.8
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 02:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GAWz0EAWe761Vp6QEPsP+9N2+xxnwu0OsIwKiqcezDA=;
        b=OmLk22+wtQh7MSkaACQlhK4xFXpKudpTcdYgl3oYIw3CHvu+Oe/62wJ93BYpDiBQgu
         cBuSFJdHgF6K8+YiMSDZWZwiGu6YHGqYDnEp8Jm2nv3l+qC+5H28xLvla3gMjfjVnpvO
         B8CbA5ziAactStPsFNmNrYJ2itmU3dlag3gs188/9WmqwWW6+Z3nBb/ZNoml2kfAeyh1
         GLtCzC9O4w4Bm3jM0SsL6QP84/mpxxTqxmhNX5d+LrcMvPLJwfiwmez1b0GvWeTJ/V8o
         U8FsmYR7SnTLO1RlV+o/rKfi/2odJgAsboS8NvwzUVgl6Ci9CYT2KYyKPNvC7cs1VUiT
         be0g==
X-Gm-Message-State: AOAM532SWirTySuzJW3VJL3CfJ4bGwlKCJpU2EhUdS+6UqYQpfiz62kM
        DFPRh0UGT5YvCCAVC5uQ+fO/UYazyp7BFxB9iPtjCIfkDEY/Ox+TrX+RfRzr2CcXlNXtsVtlLGe
        QVwFC/qCxVUzQl3FC
X-Received: by 2002:a37:8044:: with SMTP id b65mr22874733qkd.295.1632129113560;
        Mon, 20 Sep 2021 02:11:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwD04iWrAoFp2Pl0iLGDN66qtwPkahvLgfKttIBZKwl9VUMvZWk5StGpHXdGh5QYS2ld33rKg==
X-Received: by 2002:a37:8044:: with SMTP id b65mr22874719qkd.295.1632129113370;
        Mon, 20 Sep 2021 02:11:53 -0700 (PDT)
Received: from ?IPV6:2a02:1205:5026:3180:7cea:b72b:7e73:8d8? ([2a02:1205:5026:3180:7cea:b72b:7e73:8d8])
        by smtp.gmail.com with ESMTPSA id u7sm8844233qtc.75.2021.09.20.02.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 02:11:53 -0700 (PDT)
Message-ID: <b925253e-5893-5e13-967b-1ab2121f9c15@redhat.com>
Date:   Mon, 20 Sep 2021 11:11:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: Drop inline from" failed to
 apply to 5.14-stable tree
Content-Language: en-CA
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     alexander.deucher@amd.com, lyude@redhat.com, stable@vger.kernel.org
References: <1632127974199169@kroah.com>
 <d35b1d9f-6cbf-d0d6-bb0e-0e15919eced5@redhat.com>
 <YUhOXI4VFfpvheQo@kroah.com>
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <mdaenzer@redhat.com>
In-Reply-To: <YUhOXI4VFfpvheQo@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-09-20 11:03, Greg KH wrote:
> On Mon, Sep 20, 2021 at 10:57:34AM +0200, Michel Dänzer wrote:
>> On 2021-09-20 10:52, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.14-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> I wrote a comment above the Fixes line:
>>
>> # The function is called amdgpu_ras_eeprom_get_record_max_length on
>> # stable branches
>>
>>
>> Looks like that got lost somewhere along the way.
> 
> Can you send a working patch for these older kernels that I can queue
> up?

Actually, it's not critical to have this on the stable branches, let's 
just drop it.


-- 
Earthling Michel Dänzer               |               https://redhat.com
Libre software enthusiast             |             Mesa and X developer

