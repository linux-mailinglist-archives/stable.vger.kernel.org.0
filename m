Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192634D423D
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 09:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240209AbiCJILZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 03:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238607AbiCJILZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 03:11:25 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3549B13396D;
        Thu, 10 Mar 2022 00:10:25 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v4so4565735pjh.2;
        Thu, 10 Mar 2022 00:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BFY42CQG26vjyN6mexpqebrYIei5CU1Lq7CQ0Qy4+68=;
        b=CnYuK+Y0Jpcy6hzc/S8ByqVjv+r+7NUt5Lsd0493yggkGS1DTyQyghUjt9zsevXQvj
         Pvmy5sLC/inWWHIUmi+9jcoWroh+w5jpZi7sJekiAyrb82TUkyn9YCIF6T2ujHmwv6cD
         ktgq4n1d2YlE3/yT7HNAWUPUxh5Wn1JNwqIbYAFMGHgtD+hUHrsT0Q55qM9ESw7z4Dbt
         OE9uPPZHY3J19jeL+cWNlTSLelXnIjYhM1ZCkgXIwREPXuCtiNktL/upZlT0EZkNjrFH
         wnOQR0g0y8XtDdtAbF/oD7YRGNvvkp4swqQK1jQ4DeIEznY5zD69KOmLm52RBAE8By19
         z/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BFY42CQG26vjyN6mexpqebrYIei5CU1Lq7CQ0Qy4+68=;
        b=LPisSF6iyoNfkLzuXaEj6mtQai2pOJKLGUOMWx+3wWJ9rM7bTV405tQ+jDde7KBJgN
         PXWg5iTzBwbPSwxS/zu7O/PXp6fFjg9TkTXi/jB3akpP+t9kRrcsvqxdhF1IFdw6nsBr
         266S496iJDL0ZCi43BSzQpcIW0OoJ2AziP70DN94+ntzjtLElrtAHhR43kWMzICKu7EK
         uQqljYuNmAOrD+3nknPdodIqSDPXf/1jnEMa5KvX/jc08/dc7Sv6GfwDZjmklygwSBFe
         J7jV+ss4PPd4uCIrJ8SrGTRqFj2GZaGXsMwp+P0FUjoIg/c07HzhvEbspJmyp5+7zMXp
         gZow==
X-Gm-Message-State: AOAM530rX+43ldnXzsFVu7kbd5G4hDVse2mSoeC9vGbz6R62iUdS52tQ
        qHbiHLVKdMffpx+ZB6L3xvSFTLCTgaj4TA==
X-Google-Smtp-Source: ABdhPJxSsmoh2rtNEssiwLmQ0wLdhncBh5+htwbaL0QqFEcF/Y8dp15rwXvOV7s46QIKyfebfNYtGQ==
X-Received: by 2002:a17:903:2350:b0:151:e633:7479 with SMTP id c16-20020a170903235000b00151e6337479mr3688823plh.74.1646899824785;
        Thu, 10 Mar 2022 00:10:24 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-89.three.co.id. [180.214.232.89])
        by smtp.gmail.com with ESMTPSA id d11-20020a056a00198b00b004dfc6b023b2sm5910537pfl.41.2022.03.10.00.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 00:10:24 -0800 (PST)
Message-ID: <3fc5abe3-2447-946e-758c-c5ba41bcb836@gmail.com>
Date:   Thu, 10 Mar 2022 15:10:19 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 5.15 00/43] 5.15.28-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220309155859.734715884@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220309155859.734715884@linuxfoundation.org>
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

On 09/03/22 22.59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.28 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
