Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DC2616ACD
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 18:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiKBRc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 13:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKBRc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 13:32:56 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3775F50;
        Wed,  2 Nov 2022 10:32:56 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id i9so9444236qki.10;
        Wed, 02 Nov 2022 10:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FXMb+WcYYZ9NnCxtbHWk8b6TS9iaJh2KE60qKBsQx6w=;
        b=ct2U5Jbus+Ria5ps2zBqX9RWweblUVX37T/d0bhI7AYzL+TaTCTsEL+1fFNC2nKxxO
         t0olxK2/nMdFpqIFYT8odtNgLTZBJptdSpHWzYNT5AGnu2Xx0sTf30cxQ3jE9iNnNQuh
         0YVb2QzVDpbUucWVRK4X43l3HsnLqILfWJpJWx6LKTB+aWZkcMGBTIEa5ztQJx6VI/o+
         ynXG01nOtirFCjfDsrHkD+aJO4NXZ/AS4TYCugBGz0itc65RstUzliajt+yGS7IzI095
         2iwcwwy+r8anMveBmQGGezQfVWnfFUik3CX/ZYcsRGDDHQot4Oxg/gzpy7HtBbuuOPak
         MWSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FXMb+WcYYZ9NnCxtbHWk8b6TS9iaJh2KE60qKBsQx6w=;
        b=UTbutTVjpE9l7utVMdm7clvo7iJ8v32YTblrW5c4eMCizLr3jZ8E0XHJ0i3oguvV1z
         vn9Bqk7Nda1qGPjscalozm7yBZYgmZzogqL07y3lrPJsB5i9w6F4kAjdR92w3ppU/ldy
         VgB3rCDuWLqJxY/Sx+V5iO1DypU5EgmN8b6P3gBzUVM9YncLiJhewEMBELXDxIC/eDPF
         oCU1qj8SipMkIGGlId7BZitMt5rBSsfboO8B4N49h3JFwzu9RywmHNLmypHDXefufyTD
         ls0ecJ5li1qyjjRWvue+z8jjnnfbUD2neOCzl5hO0RE9MtvyEhtimfr6YhrnA++ZLbwT
         vmXQ==
X-Gm-Message-State: ACrzQf0AIIEhxBsstnWhuMqwIqgWZqQOuNGFPvPCpaCSk/UX5icoWxNB
        WJqnHXmJmnHB7fnXycJ6vMdhz0x8Q4pcPg==
X-Google-Smtp-Source: AMsMyM6Dbm3DV2KSjP3RBtJVa5jLgfcEfXKTCHifpX/HxQFHPy6DziE0ULHNXCCbblBsONga/twqwg==
X-Received: by 2002:a37:48c:0:b0:6f8:70d5:9a41 with SMTP id 134-20020a37048c000000b006f870d59a41mr18185879qke.676.1667410375061;
        Wed, 02 Nov 2022 10:32:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k17-20020a05620a415100b006ee7e223bb8sm9285918qko.39.2022.11.02.10.32.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 10:32:54 -0700 (PDT)
Message-ID: <ac1cacd7-d9a2-baed-5e4e-01abb70958bb@gmail.com>
Date:   Wed, 2 Nov 2022 10:32:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4.9 00/44] 4.9.332-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221102022049.017479464@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/22 19:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.332 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.332-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

