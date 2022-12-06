Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1346F643B8F
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 03:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbiLFCwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 21:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbiLFCv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 21:51:58 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90D5DF05
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 18:51:57 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id s16so5977069iln.4
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 18:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V3MdnT2Q8jLXM5s//gvYhHT+ZNu/mw7aKngm+TpuXkY=;
        b=hljquEFxWH9gVm57LzSmKa5Boz6niaLrsVzNGCkHuXXgG5fmUXJSOBgnQgNm+WEyJh
         QwdafYwlneQ2GWZ4PuokY3E6jUevpx9z5rKxnDS4j/d7P1znBQ82Vw5FGDtrktYlbusb
         v8vk/BkqaPmWIl0uM5gfzRIGko6MGtsZPdAlM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V3MdnT2Q8jLXM5s//gvYhHT+ZNu/mw7aKngm+TpuXkY=;
        b=NCku58yksXj61pad39IS7GE6dHvjL8hKrS/5scoGzqLpC68CZ/Gy5AxHF93AyDKdje
         J8Op459cbLtA8z6uUEhwPw3XplFCOxmvYHgOp4eGNBP+0qulk3nAJGK8LatJTaCde/dj
         R5E+SIoHg4Gn34dLBIYz6etzQG+DTvMIZ4si/XLdZkwSEgXDEYbiK7TwCwKIOtzvR/TK
         xXHe2lMBAuRve39i9DA+G2qK3Qjlm0vF5uxXFADMe8fRkA7ealgjh3NYFIKOtja7kIHB
         GDoYgYZ5lUGD+GzIR+yOq0eN3WUt0tqzE1PR25Mos/oJ4RjFddikgDeIhYWJihwkTR5H
         jypA==
X-Gm-Message-State: ANoB5pmZZRjr0O/YxSMHe4qnB142sPT9Qy6RVLCzzLvZI5B/Bv3gA0PE
        wQ5183irOPrMqzBuRh2Qw2hkmA==
X-Google-Smtp-Source: AA0mqf4vnfK6800d5tmO8ssv2j07jmhTqhELwF6Y2JSA95pjebZYddw96ZCfwuZg/w58xuaEIu4Lwg==
X-Received: by 2002:a92:db42:0:b0:303:26c0:e1fe with SMTP id w2-20020a92db42000000b0030326c0e1femr13434267ilq.102.1670295117272;
        Mon, 05 Dec 2022 18:51:57 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n12-20020a92d9cc000000b002f966e3900bsm5672414ilq.80.2022.12.05.18.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 18:51:57 -0800 (PST)
Message-ID: <33b0b34b-8d51-a0f8-e559-5d5bea4e2008@linuxfoundation.org>
Date:   Mon, 5 Dec 2022 19:51:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 00/62] 4.9.335-rc1 review
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
References: <20221205190758.073114639@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/22 12:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.335 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.335-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
