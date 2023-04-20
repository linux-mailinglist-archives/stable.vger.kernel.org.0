Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FF86E8903
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 06:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjDTEN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 00:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjDTEN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 00:13:27 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979A11FD2;
        Wed, 19 Apr 2023 21:13:26 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a6762fd23cso6277295ad.3;
        Wed, 19 Apr 2023 21:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681964006; x=1684556006;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WS1tX2GtgR30s2YNhxiucDUymFQh0DR0oeaO8cMJe6E=;
        b=pDBHlwPE7WBTkOmZ8dzSi4C+vi62FmxO+bk+N1kGbUkuYhLjbPVcfrMF2WfEkOLKfM
         /e27fJYfVs62rbMcf/tcVFIaQTz4CvGmUXEA4th3nkteU/TE5fwwJ6I98PJh+5aPP1Sk
         b8yg4sk6aVwR8XkW55jNj2T5H48dgizrigKZYf73Bi3SeKA2Rdql6LGYNO6/hnY6tjUB
         zeIUssyXR1Aa6nke7I6TizZTlvjM2+ATRCXNFZnaw+U9o+ajZVqBY7/7Ti/belzGSUq4
         rAYx9LPLBMNpra8/kpUJIUlYLbhkkSbRtjMlAN9t0NPokOZsTEBINin64FP4W7jG4v40
         8K7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681964006; x=1684556006;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WS1tX2GtgR30s2YNhxiucDUymFQh0DR0oeaO8cMJe6E=;
        b=g+L7pntN1cY3vBDQhSNi/Znu6ZTk8rbueY+qTkt1KGhpjXfwZXXnauJYuEd6OfFwAF
         HMeSAAkrhIv+bfVRNI5Eb9x+/2w8ZisZKAy/tVjm63u/TYXknTnLTj2kQBU3hHfZj3bx
         Mdn+fs9In6F20YjSRju0SlT2w/Ia2FW7HHnw4GGi27+x5kETl2JRr13P6aBep6QHIjDK
         l9tWogBtBz5N/K7qbut0Xn6ZeO6DBowkx/IeD2R1RiwxmkOZL3VtFbCgO6aKNVU/EjT1
         T0xlRecykim3cG2Ur96eosVT9WZWio2L68enLhdeTjA2VXR37kWp1Hdej6tX+vrmBPXb
         6kDQ==
X-Gm-Message-State: AAQBX9c/m7URc1TRl3+1jdUmZRk+KdkLSNJdhwjjuADQPG6YlHrxQ8pP
        sL0T5Bi0lNv8Jblp7iQZE1E=
X-Google-Smtp-Source: AKy350aCflRiFld+QPVGCOxTTLMCiPwlXAz+YOkTmzZZgiGdrgmBgJdS83zteZXHXsmitGAStOO0kQ==
X-Received: by 2002:a17:90a:e556:b0:247:4ad1:f69b with SMTP id ei22-20020a17090ae55600b002474ad1f69bmr345348pjb.26.1681964005620;
        Wed, 19 Apr 2023 21:13:25 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-9.three.co.id. [180.214.233.9])
        by smtp.gmail.com with ESMTPSA id q8-20020a656848000000b005134fc049d7sm188029pgt.31.2023.04.19.21.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 21:13:25 -0700 (PDT)
Message-ID: <d97c87aa-d0aa-b2b8-cca6-5dba163785ec@gmail.com>
Date:   Thu, 20 Apr 2023 11:13:20 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.15 00/87] 5.15.108-rc3 review
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230419093700.102927265@linuxfoundation.org>
 <ZECdneXReDmEBNzI@debian.me>
Content-Language: en-US
In-Reply-To: <ZECdneXReDmEBNzI@debian.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/20/23 09:04, Bagas Sanjaya wrote:
> On Wed, Apr 19, 2023 at 11:40:40AM +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.108 release.
>> There are 87 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
> 
> Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
> powerpc (ps3_defconfig, GCC 12.2.0).
> 
> Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> 

Oops, wrong -rc version replied. Please ignore my Tested-by above.

-- 
An old man doll... just what I always wanted! - Clara

