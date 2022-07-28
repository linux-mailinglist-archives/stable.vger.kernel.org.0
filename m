Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481215840F9
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiG1OWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiG1OWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:22:16 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A8146D81;
        Thu, 28 Jul 2022 07:22:16 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-10e3852b463so2516835fac.3;
        Thu, 28 Jul 2022 07:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=YW9CMROp9b5VA/mD9ygjEepLNv+SvNjwMrATVFxRWg4=;
        b=Ju5kFk5kngepX05TDpu4XvKwZT3iAqeaK/oKrFoaHQBhTj2VLI5Of+AvXEqbk4Nshm
         ekY7R+/3yWAJBfUtGR3RcanAwac7S2QsjoHdB9rmooTZ9xTNY8Z+EA4Pe7cT2hr+lbP0
         Pw7Rz462k44yQPcmhO4hZ7XgLXr1ygjF4H+dE+K8TRC20gzf6GExkJU/XB0OFvK0CsM8
         vYeZwjxsz0O9EViQ1BEmnSgdtuG+qt1fodL9M/O06zZQlqM9EUpbeW1qTbM5hkooHtLp
         WomZLT0GVhremUQpJR57VB2fetUfwBRRVTKpj7RAzRMis2ASOzNSYPbcBumGU4X0J2Hr
         JDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=YW9CMROp9b5VA/mD9ygjEepLNv+SvNjwMrATVFxRWg4=;
        b=HkrIRJksjTUUdKF6ykFn6VOWY/79PtIEFm0H7ESotSh2Bp3X3YlrCExqfbPsR9e8rr
         IIdJ9FTmDv4ZIKw0rQq8jL38khb0qUjfpswZEWZDZ1F5hgbdaN15dazAwDVCySj4Axcb
         Mx+sMpoZ5FquyvYh/6PBVh9daZiG8mOV+1xe9hthRB2mLqp6253rLgiKLfc8X3zkn+Ht
         gnLix+FrXFEa5keqv+qdSXDYi/Co9EZjkc2UQX4EXbZDg4XXs43eKsgCraF5RfELvont
         yKM4ZHa5HraBY1kA1n9/1+ddegUJQCAMraWU1yUmxO09Rp72NohJrMl9ROFoIBbjjZAM
         LqKQ==
X-Gm-Message-State: AJIora+d7h9j2wRXQ8msN6go7/XhBjj7ZLVe9Ht5TtinY9mQpMbgAfg0
        IZLra2H41uKlAF0XAxliOV/FLnPn1Owsdw==
X-Google-Smtp-Source: AGRyM1s73EOOw84bFdX1E5lhbigy6wwKUUrO70hWzvrG4nddPVe8RpXu/bGCNyJzUA23E+/q8rFKgg==
X-Received: by 2002:a05:6870:4686:b0:10d:aecf:9caf with SMTP id a6-20020a056870468600b0010daecf9cafmr4634757oap.61.1659018135640;
        Thu, 28 Jul 2022 07:22:15 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a8-20020a056870618800b0010c727a3c79sm399739oah.26.2022.07.28.07.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 07:22:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <219030d8-3408-cc9d-7aec-1fb14ab891ce@roeck-us.net>
Date:   Thu, 28 Jul 2022 07:22:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 000/105] 5.10.134-rc1 review
Content-Language: en-US
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220727161012.056867467@linuxfoundation.org>
 <570b5e5a-c25d-ccd4-42ce-f2d73d4e3511@roeck-us.net>
In-Reply-To: <570b5e5a-c25d-ccd4-42ce-f2d73d4e3511@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/28/22 06:20, Guenter Roeck wrote:
> On 7/27/22 09:09, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.134 release.
>> There are 105 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
>> Anything received after that time might be too late.
>>
> 
> Crashes when trying to boot from btrfs file system. Crash log below.
> I'll bisect.
> 

bisect log:

# bad: [d2801d3917f2749cb2ec1788ee94021acbb8c2ad] Linux 5.10.134-rc1
# good: [5034934536433b2831c80134f1531bbdbc2de160] Linux 5.10.133
git bisect start 'HEAD' 'v5.10.133'
# bad: [c03ac6b78c06b8f9f500ba859f13b5b7c9557520] tcp: Fix a data-race around sysctl_tcp_tw_reuse.
git bisect bad c03ac6b78c06b8f9f500ba859f13b5b7c9557520
# bad: [36d59bca14ae38aa24ba8b12d0d3bd1d5d58f4c8] drm/amdgpu/display: add quirk handling for stutter mode
git bisect bad 36d59bca14ae38aa24ba8b12d0d3bd1d5d58f4c8
# bad: [271e142fbfd4da6b80a179c5b1a1599e77bcb9e7] net: inline rollback_registered()
git bisect bad 271e142fbfd4da6b80a179c5b1a1599e77bcb9e7
# good: [e9d008ed8b527bded5ffff5f0e46756b01d2fb8a] xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE
git bisect good e9d008ed8b527bded5ffff5f0e46756b01d2fb8a
# bad: [fc360adfd749d004819019e9ac6eb261e1bc434c] docs: net: explain struct net_device lifetime
git bisect bad fc360adfd749d004819019e9ac6eb261e1bc434c
# bad: [6b4d59cc6a3ff5c9836cd2b617e19354fb1bdf78] block: fix bounce_clone_bio for passthrough bios
git bisect bad 6b4d59cc6a3ff5c9836cd2b617e19354fb1bdf78
# bad: [7c4bd973d072c7f3bd7b63cedeb81ed4e06e6c4a] block: split bio_kmalloc from bio_alloc_bioset
git bisect bad 7c4bd973d072c7f3bd7b63cedeb81ed4e06e6c4a
# first bad commit: [7c4bd973d072c7f3bd7b63cedeb81ed4e06e6c4a] block: split bio_kmalloc from bio_alloc_bioset

Guenter
