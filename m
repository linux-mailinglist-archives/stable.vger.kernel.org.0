Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD9C4D99C5
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 11:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347677AbiCOK7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 06:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347711AbiCOK7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 06:59:53 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCF93B540;
        Tue, 15 Mar 2022 03:58:41 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id v4so17479502pjh.2;
        Tue, 15 Mar 2022 03:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/dt0ki5c6TsVjagp5Hw0a3dDEKUn0j8kFSzZZMT3VYc=;
        b=CUDzMgF/OnISw5WwvUlQdrwi1EXa0YCf1QhjvMTcHVlUXcy6VD8ZMlvFF7tJPBlWeN
         eXhBpHgzxx1VwCLELmr8U06RnfrwTSbfaob1hWjaAu2YCWq2fs+OcavFOehs+UZJy+C7
         w01sbeAnRq/XESe7cVEIXbUHrpQYDM64/taogeCxQkjSii1x1lDoKskiorsjXyjCT+M/
         xxU7kLu3uinGfMGrXub9XdJquPoDC8YwgKVDAHlVm4hfHWveEWWMKssQH0bcGT5Clm0G
         77FK5UGD3uDYI/0MQvAH3AtOKQhR63sBI0RA68+DxXfJv680L1LEsc0KgkgcyZ3d31oj
         4o4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/dt0ki5c6TsVjagp5Hw0a3dDEKUn0j8kFSzZZMT3VYc=;
        b=20HIGvyHTJRtYtMTmeSledLGK5sDgvvyXDY59D7P8WoK5vuf7QkdgEMX/FRok7kVWJ
         YBmMDShvsLVDbMDQh4wsanjqCuhk4VvH2BEopgVs52XvzVqvAbNfiH0mhWwrAiiWax6P
         OFRVKNvDUnebYxTRLn4Hgfl9dFyg7axLjeApNq7KjJa1dvKcXDpeg+0pIZk6zDUnO+Hh
         3OhmFXoIyp8SiGBh4yKuXBaBM9Utt1wlF3UZVy8BM99J7fwuuxUuOmS7BuUx1Otfaikx
         gw9pnhPvkGs6IR2oftuQnpXlHSWXay8626JOIt2YbIIDDoL2qZ9MKt/O5Edr1Q5s4Hew
         a0tA==
X-Gm-Message-State: AOAM530PEDvLUeL77vmv/PgTRoqbX0P2UhBz3+UJJ7wWsxU4PP7TIz73
        JW41NShO+BADIWrUjz9ShAo=
X-Google-Smtp-Source: ABdhPJzxzlIcZjlz6fGRY/LxU0q1FUkEgjIQpU6PvljMdgXtNt10RS8iX1wrCcKfc74jdMCdCJSyHw==
X-Received: by 2002:a17:902:ead2:b0:153:85ac:abc9 with SMTP id p18-20020a170902ead200b0015385acabc9mr6305446pld.173.1647341921264;
        Tue, 15 Mar 2022 03:58:41 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-1.three.co.id. [180.214.233.1])
        by smtp.gmail.com with ESMTPSA id s15-20020a63af4f000000b0037c8875108dsm20078684pgo.45.2022.03.15.03.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 03:58:40 -0700 (PDT)
Message-ID: <c2692f8d-20f5-e310-e26e-087a9f82aa0d@gmail.com>
Date:   Tue, 15 Mar 2022 17:58:34 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.15 000/110] 5.15.29-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220314112743.029192918@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/03/22 18.53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.29 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
