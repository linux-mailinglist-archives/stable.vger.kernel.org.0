Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C133B696C24
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 18:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbjBNR7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 12:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjBNR7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 12:59:53 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D0B298F7;
        Tue, 14 Feb 2023 09:59:51 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id v15so13630490oie.9;
        Tue, 14 Feb 2023 09:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=s8UzaNfEND0jC/yceoLp3a3whXWdJFqcFdLGizTIhz8=;
        b=qshxiKxdLxeJ4PeuqXQwrO4EnYS1plQsrkAk8SmkJWBw7LoV3iEQ5oOGGppWMzhD4+
         hUw4KAMZuo+I8oBH46g31MescWFDI5Q3PEhN8FZoLEEptiQLlXCEe4AD3uyVBt1aMmTo
         W6iOboHuKRxGbL6OV1nwRA1eNbiFmyj1rLPiLzBWLJSYDpxmzrCaDts0NC45VhIbTmlC
         etGgvIFTc2Wjg2J2Pym04AGJTTNJFDHi1ZFK2zeb1l9kP4XZ/clUV1ppiw3NnnFDnuGR
         ee+Ef2o9NaHsZRDy6CAwzQaewZKvBmTIc8yQtXsntl/sOX77KkQ5+byBb7btA4v88LAB
         GNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s8UzaNfEND0jC/yceoLp3a3whXWdJFqcFdLGizTIhz8=;
        b=mczWPzdeHrQIbK5dpPKmsYv2onnw0dKznO2d08atDw9f71mYRGhIWFjF6wFITF/0VO
         nthLcJELqu8H9b2ZtyFrYA9LsHjFZqeMuFTax8eyeukCt9ysr/zMkhIUOPmYZ7YlzqiS
         4vkKFqFKHW34ZbxnG+XccEid0S88PMJzM6Lfz5MajdFlddx2aUDvOLGKMbTI0gkBV6ZO
         5qEx6u+xzX7q8kDPTNld8SYr6YciXeh4AG8FrmZHoG9MeQDiqbNXP5Dni6ZohJ9eMoZ5
         Np1fMnd84d2dl7F9byQJtfzoHzz0ir8w7AOolHKMrYyveC8NinvPJKr2YQsI33pXBris
         f+tA==
X-Gm-Message-State: AO0yUKXjuojOpJkcsFBgPlf6X9Q7jE4sjff6O9TS0DNoBV+U7nDaMUAs
        9ZZgm2hm/I8crOp669B0fFw=
X-Google-Smtp-Source: AK7set+LDbBvPDey+JSMgLvJmB8fr2skkFW5Kqo8WzDl5uM3H7YthXP1/bXbT2bsHmtgU+Mba/Egrg==
X-Received: by 2002:a05:6808:5c8:b0:360:d307:c23c with SMTP id d8-20020a05680805c800b00360d307c23cmr199708oij.25.1676397591064;
        Tue, 14 Feb 2023 09:59:51 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g1-20020a0568080dc100b0037d8bffbe76sm3032484oic.57.2023.02.14.09.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 09:59:50 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <710c0c7b-0920-8ea5-98e9-d3f07ab82f56@roeck-us.net>
Date:   Tue, 14 Feb 2023 09:59:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Content-Language: en-US
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230213144745.696901179@linuxfoundation.org>
 <7106f107-061d-231d-fb09-bf4832e2a5a0@roeck-us.net>
In-Reply-To: <7106f107-061d-231d-fb09-bf4832e2a5a0@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/23 09:04, Guenter Roeck wrote:
> On 2/13/23 06:49, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.168 release.
>> There are 139 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
>> Anything received after that time might be too late.
>>
> 
> We don't know the reason/cause yet, but Chromebooks with arm64 CPU
> no longer boot with this merge applied to chromeos-5.10. We'll revert
> the nvmem patches and try again. If that doesn't help we'll need
> to bisect which will take some time.
> 

This is also caused by the nvmem problem.

Guenter

