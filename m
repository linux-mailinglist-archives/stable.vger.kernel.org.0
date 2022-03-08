Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3554D1F2F
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 18:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348097AbiCHRhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 12:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235466AbiCHRhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 12:37:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50090554BB
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 09:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646760995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TWLYdwevdepBzx0X1glUvwId31sNoQVYJST0iSmDSu4=;
        b=eTCK28cnD/1qZMjI3+wPWzI2YYxf8qFTuhiZno+3kjto/VnAkXCa4GrOVMA/TC/PbMnize
        Daymjp9u/QGxCr9nMYJb6Te/YyoVacLs7t6aD5eIW1y/cZbL5nEqPFlS0I1zxJoMra4dK0
        PEH+g/O5CHQ5x+hsImqqKXLoaYQxXrE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-ouUwBnFYMmG2tJhZNRM92Q-1; Tue, 08 Mar 2022 12:36:34 -0500
X-MC-Unique: ouUwBnFYMmG2tJhZNRM92Q-1
Received: by mail-wm1-f70.google.com with SMTP id l2-20020a1ced02000000b0038482a47e7eso1445063wmh.5
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 09:36:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TWLYdwevdepBzx0X1glUvwId31sNoQVYJST0iSmDSu4=;
        b=BCmhhiKbEA4OULRba6qidWUxs6A9iZ1Ncf+/QRymiW+L5wi761d9Nl1urHTSEaJa53
         Ti0MOfdpd3JgErAgvxur/83HOYdkoSrf1Rp8j2pwJF98moaJcTKqSV5ddfx70yR6vEsr
         POEeDk7K2cISoBlqqa+3po8zGJAKkAZ+H8u/4RGzg+0tDgZiyrP/s5xh+X+flxvKB7Or
         FmIXr7RLChxoPy+9mLmD0p0nS+YrAuIrM5gE+0ZH7OqXKMsx5t83pUUdU06oa7FO2CWJ
         /vN2ITh/rO/zi6Xu1FrB2kYERe/ahlWPRYCSho0DsIa1bVp4EAHHxnaIffj7XgoIxvfK
         fKzw==
X-Gm-Message-State: AOAM530stmqqMgkY4PUe3iSrWT8UZ23GlFeonHDDdEX/kb/iumSN33AX
        NJGTJUWE8w8Yn3rPB6Dv2vIHgWN4fmFuWtHsEu/ILCKsQ1/25wg48ZCPzgaQj7ZEzzPyteydvvK
        694LjoMwulw5lDibA
X-Received: by 2002:adf:a341:0:b0:1f0:1a12:8920 with SMTP id d1-20020adfa341000000b001f01a128920mr13798452wrb.100.1646760992901;
        Tue, 08 Mar 2022 09:36:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxun/q4GEh8tpJ7AT1flRZIvX5efklF9A8vrPY/7OjKPozKYFDpKU61OhOKqIuRAHEieRC8Pw==
X-Received: by 2002:adf:a341:0:b0:1f0:1a12:8920 with SMTP id d1-20020adfa341000000b001f01a128920mr13798437wrb.100.1646760992722;
        Tue, 08 Mar 2022 09:36:32 -0800 (PST)
Received: from ?IPV6:2a01:e0a:c:37e0:f4b2:2105:b039:7367? ([2a01:e0a:c:37e0:f4b2:2105:b039:7367])
        by smtp.gmail.com with ESMTPSA id n5-20020a5d5985000000b001f0122f63e1sm9408127wri.85.2022.03.08.09.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 09:36:32 -0800 (PST)
Message-ID: <45beb705-57f2-8574-32b2-7ffe8300d990@redhat.com>
Date:   Tue, 8 Mar 2022 18:36:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] drm/mgag200: Fix PLL setup for g200wb and g200ew
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, michel@daenzer.net, tzimmermann@suse.de,
        dri-devel@lists.freedesktop.org
References: <20220308171111.220557-1-jfalempe@redhat.com>
 <YieS530V0nGYydGa@kroah.com>
From:   Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <YieS530V0nGYydGa@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/03/2022 18:31, Greg KH wrote:
> On Tue, Mar 08, 2022 at 06:11:11PM +0100, Jocelyn Falempe wrote:
>> commit f86c3ed55920ca1d874758cc290890902a6cffc4 ("drm/mgag200: Split PLL
>> setup into compute and update functions") introduced a regression for
>> g200wb and g200ew.
> 
> No need for all those digits in the sha1, see below:
> 
>> The PLLs are not set up properly, and VGA screen stays
>> black, or displays "out of range" message.
>>
>> MGA1064_WB_PIX_PLLC_N/M/P was mistakenly replaced with
>> MGA1064_PIX_PLLC_N/M/P which have different addresses.
>>
>> Patch tested on a Dell T310 with g200wb
>>
>> Fixes: f86c3ed55920ca1d874758cc290890902a6cffc4
> 
> As per the documentation that line should read:
> 
> Fixes: f86c3ed55920 ("drm/mgag200: Split PLL setup into compute and update functions")

Sorry, I will send a v2 shortly.
> 
> thanks,
> 
> greg k-h
> 

