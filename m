Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F4F64ABE9
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 01:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbiLMABV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 19:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbiLMABQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 19:01:16 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD08A1C12E
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 16:01:14 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id x11so4233288ilo.13
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 16:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KbJTu29H5LvMjbV+S5IPZzSW//JIIKSY3hH244NoMMQ=;
        b=KC/MBA066kXBOQ2o0ovBrA6dE7qLxhU/B8MxcfeuldOpCcNxBgNdcdA7B7pIwHjtWU
         xNfH54org6aMAvAEFciT4IPIk7z82tXPwMyq2EMa/eMIfxseVBd2csGbeAEEiUlHRfpf
         Jx4OcSDwiSB5ExI4q/EOcGTifjskPE7l46vxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KbJTu29H5LvMjbV+S5IPZzSW//JIIKSY3hH244NoMMQ=;
        b=UdX5zkcu/39cKkSdFakEXRDWymQpCkBWtVdxnaAeuCOZ7h9GpLjs7fMXkENKL4vcOF
         dp5Oxm2u2OeFogYmZYvUdEfI9qk+NNxVRxyjWAbXS5ACM30Kx5cmiDz6xJ3OtxXiHkfz
         9DVQ2l5TLjEBj3zqdQQLfipo4pgW4At8O5/AiIutyT5U0t41hBRHhyQsNiy7y2L/i9vo
         Tj5gxXipiQdKYaWKF/vq4VviZRKNmIvlQxxdQTGOjR9EszlTO467LIXqdwF8uoAPjjLf
         vM+pHZf8Wpf2+R4eeoStbz9bKG30vXEwjJPlYPDHvvOiR1q2ZRBeTzAcZRXs3iE31MmS
         WvGQ==
X-Gm-Message-State: ANoB5pncBxlrXn1aGfwel797tWPeKF/ORSFsprbYXXU2qGkgeED/mv0+
        zgwgpLQrq4w4dh0lXNb1xeaao9hH/sXshm+k
X-Google-Smtp-Source: AA0mqf5lqFQO25Cz//TqyNNlbuqhDhkvB6Ibz7RaIoHWjCtc2/7uzFtg1xTZHYww4qwkKBKg9uaW2A==
X-Received: by 2002:a05:6e02:1a27:b0:304:b2dc:4274 with SMTP id g7-20020a056e021a2700b00304b2dc4274mr1287317ile.3.1670889674015;
        Mon, 12 Dec 2022 16:01:14 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x8-20020a026f08000000b0038a56fc3ca9sm359246jab.124.2022.12.12.16.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 16:01:13 -0800 (PST)
Message-ID: <59eebbf4-a706-7867-4edb-33e83e92a5d0@linuxfoundation.org>
Date:   Mon, 12 Dec 2022 17:01:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/22 06:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.159-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
