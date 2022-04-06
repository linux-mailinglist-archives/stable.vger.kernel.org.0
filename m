Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B125B4F636C
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbiDFPYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236072AbiDFPWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:22:31 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC1B48781A;
        Wed,  6 Apr 2022 05:22:22 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id n6-20020a17090a670600b001caa71a9c4aso2533290pjj.1;
        Wed, 06 Apr 2022 05:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=krna3YAVNrpZpWpuZJsjRTH+EuKfbaLV1rzmX6Ujdq4=;
        b=STEsbIjJEFcX/7bWLDQkZi2BrDGrFurj0XEGMbEjky8CKQZmrPnvSgKiWi52Q6zHJv
         jZO6zA5rByKo2x99tfPvJpkseyfrZ0As6i9+qbzMuDkBKf4YLPZBacS1zL271obvSXP2
         nGDWEuPBFBOH9HaKoYqz2wDrPeGJVo+tea0Zf/MoHGR9O9QgH0c4oZwLI9/+1ylYjw33
         r3YJy57QEBSi53PQiApmVOFxiU1eBw/rp0gUpOmSNEpHk8G18IxblMZiLAeEy6I6fJvn
         OmkAvI/3eAarkw0pW4uaXKvtMmSN4i+1VPEdsslIIAWWkRtYvoZCaYCU88oPF2HoTRT8
         K71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=krna3YAVNrpZpWpuZJsjRTH+EuKfbaLV1rzmX6Ujdq4=;
        b=PIz/FyrJKNz9yANA8JJ3+J4VzBdf+C6QaGt0PwX/0BBh4Cq0lGnSbtXAoG7aTOXbdd
         4FFPwbLNIFb/ytb2jwF/N29bpRGUz5UM2mDTMfW2+ZGL3HnRc86MU31DGJfIowfUS7ZT
         0lYsYLUxmxZbDe/h2e1117I7gDTvQv5l7TO1OPA7YZvcHbcml0tOEO1QUwkJ5R/tlW+Z
         iNkmhthZwK3IZhDCJTwsKQ3nQRtcdGtzssgCz7Em1idL8NUjHg4e9cUM4T0K7Mf7nLwn
         XYsMnAobkSbW3jEF41sUKJdaefvPlZEE8lox85Qy8FtAYtIWL3EXDh+LWI8nTW/SGnAk
         RS8g==
X-Gm-Message-State: AOAM531v3469v4Eyq8CWXrf/5XPgdVNdnSm/Lvxz7r4M5jXZpJgonePR
        6gBdXLH9IeS7YkCVqnwO61U=
X-Google-Smtp-Source: ABdhPJwzcMhNaawQ45tBHODEC0g8/1bxtKTONZJ7Bhh8NGt4IvhN7CBYOsklzdZUSyHmNmwftULzjg==
X-Received: by 2002:a17:90b:60c:b0:1c6:a684:25b2 with SMTP id gb12-20020a17090b060c00b001c6a68425b2mr9380294pjb.14.1649247741299;
        Wed, 06 Apr 2022 05:22:21 -0700 (PDT)
Received: from [192.168.43.80] (subs28-116-206-12-40.three.co.id. [116.206.12.40])
        by smtp.gmail.com with ESMTPSA id s4-20020a056a00194400b004fb358ffe84sm19147264pfk.104.2022.04.06.05.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 05:22:20 -0700 (PDT)
Message-ID: <975665fd-e559-37bf-837e-3cc262760948@gmail.com>
Date:   Wed, 6 Apr 2022 19:22:13 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.17 0000/1126] 5.17.2-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220405070407.513532867@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/04/22 14.12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
