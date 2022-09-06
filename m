Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795945AF39A
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 20:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiIFSeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 14:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiIFSeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 14:34:03 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EFE81693;
        Tue,  6 Sep 2022 11:34:03 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id w18so8826243qki.8;
        Tue, 06 Sep 2022 11:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=HBmrNFoVT0my9dPEmViizbkvOCSV2Lwf9elHYX2Ncl8=;
        b=T6MRi7a9nXz8yBRoKj5E6fYDB3uix6uhAwydZ9jBL+ukueLnRS709NvrqjHWEFgILO
         p3lDy1xy5P8H08cnWOLz2KAxxW1QHbIP1LKEcIzKpGZIFkqq7Ww+zE50qvhXX8RhzQ4s
         Cmyhgf8on7TYUcw9AXY7hW0mKKuz/5KwgS6lptpR1bPWyFu/xABFBBCjkgH2wQTkZGUF
         ucHK3c2TXxm641mh8E6mVmXpB8CH6KnTU7PKOoj3F8xkIv8YjJ5l6zC5osm7uqgv7n7k
         R2GMcHYeY341SA53vuJBVawi9iE5GH3QL99r41U+fs9XrtpxJ1qg4ZtJzHvqu3MPJGv4
         qz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=HBmrNFoVT0my9dPEmViizbkvOCSV2Lwf9elHYX2Ncl8=;
        b=c6e+wH2j2qndrobb08akEfiUXYhsn/I9qCKecNEG/UiG7MqT9sCtNymylCY+9OeZju
         50RyVf3JCUb+wc5dmFfZ9ujixfWSJLUkea7hpgHigUW9UjuxMgiGS/gB496pPFirJK6f
         MwzaDU7FijAwF37egrTwJ2bd154cBUOYsAUmaUoOxwbD82V5iYhfVZrPin87EnQRyf9A
         CZF4gtrCq+kQPMd/yUejs8kdjHIKkhrge1dVdiwhAY+pxRGbzx1hQIlxP/E8xYuAyeYb
         zQRFjmu6LHYpSShixGJWL3WhaJ7D+cJQHgQL/FT5PM7ZFdMuL+gImaG5eYBsShtLD0aU
         BWDg==
X-Gm-Message-State: ACgBeo2+89OLY9PW0/VAE5yStk/RfN2bCsnqQU39/7z9jHnEWOq37+kV
        ZrXbygzAvtr8e9OF/cZdhAw=
X-Google-Smtp-Source: AA6agR7ivv9zN3MUmzWRfj49mSicIthk4PT18tYTLkeL+9wUK6t777qNKj7ml0p8TMs1419hjJjEKw==
X-Received: by 2002:a05:620a:2723:b0:6bc:5cdc:88f2 with SMTP id b35-20020a05620a272300b006bc5cdc88f2mr37470572qkp.607.1662489242338;
        Tue, 06 Sep 2022 11:34:02 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id m23-20020ac86897000000b0034355bb11f2sm9988911qtq.10.2022.09.06.11.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 11:34:00 -0700 (PDT)
Message-ID: <d3679191-f6e2-7195-fc9b-c210fb8fd18b@gmail.com>
Date:   Tue, 6 Sep 2022 11:33:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5.15 000/107] 5.15.66-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220906132821.713989422@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/6/2022 6:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.66 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.66-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
