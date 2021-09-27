Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93A341A375
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 00:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237988AbhI0XAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 19:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237976AbhI0XAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 19:00:21 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E02C061604
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 15:58:42 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id r75so24927518iod.7
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 15:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jq2+yCpnGzwdSX89Mgkqx5aZBqCjh1AA6CPLpL7ay38=;
        b=cXn4ng7zPdvpqO/hbVHoGZXM9incIgvVMlfO0iXW2I0z13IbFqszaIcMKn/2IfMDVV
         HGZxUfwVrAIJhNSwMvDYSdY73YshRIC3tcmgSlBx+VjWv4IT/fbxmVhP2/L4fDHvhBUc
         KVbqH39RzCxAmrsU3pEU7kuZDN1zu+5tt5Wn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jq2+yCpnGzwdSX89Mgkqx5aZBqCjh1AA6CPLpL7ay38=;
        b=v6rDow2AvoslXwylkvEU5i56OB9Xpnrc8bb+0iuJbX52Mes+yEntx/eRW4ay/MPxSl
         DMhQVdQpNE8dZS5aXx8uT9uWMSax0jTtHbZv/lhCdBq9eWdPKaEguaHsPaVsSYC5mjKn
         f+lInHs5DS5pOfcm2KKoBhQsfEPvsJs4aH/wwh9k3DWdcIk+w90ESd3AxjrJu+SMe7Wg
         4N/yhCXKhE9+w6AfDh56pF1N85C9glYZlhMTeMteq2U3o3ypS+PSyQTzHM/Cfj3NtT6a
         4olS2LIFAi2VePfntU0SYLQCWAzt6tewATkTPVmrmAqbINHlGUH8+gh0tQUR8iDeeMze
         gf0Q==
X-Gm-Message-State: AOAM5339JexmoBDaYSC5sWa+p6KRtdVyVl5OC+YIgmkVKOI9GS+tk72N
        Rqx3OOtdjDagK1I6jk/Nbz7txQ==
X-Google-Smtp-Source: ABdhPJw47ZeCxhLesN1CoL7ZPZqP/hOHQhIJgzA+akyIlmGDKiy1kkySCFD34X4RfhJEW1sXLdxyKA==
X-Received: by 2002:a05:6638:14cd:: with SMTP id l13mr1948774jak.90.1632783522357;
        Mon, 27 Sep 2021 15:58:42 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r3sm10124504ilc.56.2021.09.27.15.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 15:58:41 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/103] 5.10.70-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3c6b88af-8bfd-be86-7ed7-febf3aeed65e@linuxfoundation.org>
Date:   Mon, 27 Sep 2021 16:58:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/27/21 11:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.70 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.70-rc1.gz
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

