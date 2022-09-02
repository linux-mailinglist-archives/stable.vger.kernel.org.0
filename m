Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF61D5ABAB9
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 00:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiIBWQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 18:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiIBWQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 18:16:37 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF253A3D11
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 15:16:36 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id 62so2782879iov.5
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 15:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=mf4MOeB8IFzC9a/pzJ/crsUERCbati8LGfbITRzYVtA=;
        b=Exki7VHZvsSm9/awlVADGcZr2fj240NKkGb664RWXsY/jUpjXBcrv28YCutLWR0nxU
         WaTE9pOqiXwD0ybqXaCtGEf1w37/kV7L00vmAfJavn85jeHYILgPdwPvnftN2vq+XoMj
         n5tKPMooa/1x4VNy9tCYsQ80KwqlU9TiAvyS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=mf4MOeB8IFzC9a/pzJ/crsUERCbati8LGfbITRzYVtA=;
        b=o8whyXZWur+b7N9poZ+kL4tRFdNsNrQEQ+4/M1X82k3KDm9TsWk/UJ10GwgAeledwd
         dvWtyeEC37nhgFp8PPuCUXlGCurxc4in3ZabbATwebg9JQavEdgOFhY+SIeJlgqH4dW3
         MMYhycczKhj2lvrjoS5XcypoDfm9uPAkFXrXX2aoi48OzLUok9C4oOvivFkp7TZC6kyN
         YbmJP5rY5CLKR1HTnBS2T/L8t0sI0TG50i6d/nMHzXgcpkgImxCnoPD/05ZlAnHvhOHZ
         PA77ERNmD1YzlufYESCegXwQu5v1m3TKXLttc2ARnPRMbAwx79mw3DgFFAzKX90MRmRX
         8ZsQ==
X-Gm-Message-State: ACgBeo11GAO3bl8K+hThM8xmW/Tx52xhRuuuwFxLtDLU5EgdA9jFiQby
        pQe0QVnhg+s8C+xOJBnmShEYpA==
X-Google-Smtp-Source: AA6agR7oQr13xU7E4ned6YCqgxBGIzc9I2SideK9L+o2tWKomBO5FZxPSSkGC1pPKNZQXtJhOFuqUQ==
X-Received: by 2002:a05:6638:2105:b0:34a:694:4fa4 with SMTP id n5-20020a056638210500b0034a06944fa4mr22339670jaj.116.1662156996362;
        Fri, 02 Sep 2022 15:16:36 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id t3-20020a92dc03000000b002eac43d2013sm1222994iln.43.2022.09.02.15.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 15:16:35 -0700 (PDT)
Message-ID: <2a29f109-c529-0eb6-96a8-40088c25702d@linuxfoundation.org>
Date:   Fri, 2 Sep 2022 16:16:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 00/37] 5.10.141-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220902121359.177846782@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/22 06:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.141 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.141-rc1.gz
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
