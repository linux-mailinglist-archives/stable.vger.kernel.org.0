Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617DF38F555
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 00:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbhEXWHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 18:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbhEXWHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 18:07:21 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD68FC061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 15:05:52 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id r26-20020a056830121ab02902a5ff1c9b81so26675437otp.11
        for <stable@vger.kernel.org>; Mon, 24 May 2021 15:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KcqVM3Z4xibqYKupYIQXxeW+HcldZY5vq9eb1PY4Kac=;
        b=MnZNOO8yPKJj9nw6RU5WAHEbbPEEu4k/8oJOPamkJ5UxLY9/nTvMp5PlOmPOEG7sND
         wWfCdPLAj5ShyQ+vATpnqbycqYS2czHBAR9LbC3RthBuYI/JQmnBLihPU/045L/71J4D
         5zju4iW0gO45ihLnoR0S2r9YPTzwAunQu6q1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KcqVM3Z4xibqYKupYIQXxeW+HcldZY5vq9eb1PY4Kac=;
        b=lsJ3NaKlR16b6+pzPbtN2hr1U1wwZk5ZnfWAogzm++oJ1SbUYXuaZ2S/at/im0fYmP
         n1sxip5jnapBYcRI6BlppCLggDrZBxLMVc025xXH8OxekUQecPX865OdjI6ZnZN03JrT
         PO9CpS7njw39Ni8RjsiFetJkMgjcuVLcbEkvwrHOeVYOBBgUwCvagWNIFDUur2XUoWbq
         SdMrRLONk+XJyDXBVePqtdP1r6pNTZXV0MedSarc1tqPeSy/Hs5t+xc2ktFikH7Cn872
         EJa6zvo3e6n03i91WApMNxcNIxDzVd8TWrNB2mY8jn2peX4cN6gML+Mp+t7MuPreZfeX
         vBeg==
X-Gm-Message-State: AOAM532fk76Ga2ElSq0iuy6/0b8qoyRfRM8eb0yFmqY+Zr+7Lg06ipkR
        IbUxW698C4LDVnUtcaiqd9y7/w==
X-Google-Smtp-Source: ABdhPJxdDgwjmNhu8FXRoZ2YmByQ64Mvji0u+Ohm39Zqx6Kgt3ytokjDnn91todvxKuKyk3S5U6Ccw==
X-Received: by 2002:a9d:12d6:: with SMTP id g80mr13392212otg.107.1621893952327;
        Mon, 24 May 2021 15:05:52 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j33sm3125760otj.72.2021.05.24.15.05.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 15:05:52 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/71] 5.4.122-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <17a9b16e-bb18-3e62-a931-8618309fa10a@linuxfoundation.org>
Date:   Mon, 24 May 2021 16:05:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/24/21 9:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.122 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.122-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
