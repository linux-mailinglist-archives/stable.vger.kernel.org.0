Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DA73939E8
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 02:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbhE1ACp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 20:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235473AbhE1ACl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 20:02:41 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0576C061763
        for <stable@vger.kernel.org>; Thu, 27 May 2021 17:01:07 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id d25so2393323ioe.1
        for <stable@vger.kernel.org>; Thu, 27 May 2021 17:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=38NTEJh9+fCXP+9bh25zsxGAKEbZ31Cir6W3IKio9gg=;
        b=e9xlgzulxolHYJFGxpNGjPxdadbpIXPQlOy9NU5SUjOL9azKZQTlGUjAful9fwQ1mM
         euUS21YfhrrVjiNAxTAG+4c7KMQfFBukQwkcSAvSa/MN9WW61RhfosOaefsiasK8KMx2
         QzK27MGXe/Q6ch9jcRF6ocuOuPaOPOU7BOTR4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=38NTEJh9+fCXP+9bh25zsxGAKEbZ31Cir6W3IKio9gg=;
        b=T/VJHiXKRTegVWbUgYkb3/ipf+TT+Cac8bTkWBMpMIt2MNJ6LdIroVpJ0ZT9OqYnhi
         W9ouN9z9IsBQTFsaCAXJpdaLwFLnYNcZI8B7GW0sNZLC0IG9QXccyOHIjWZw2pjbElr0
         DkX5wbz6sHjREKnN2tgMElaFjIEt+bCeQZyuwPeWOsBKsUp6KmhV4qytIQg3xfpHk2v2
         zSE1j4oq3MvVUJBXi2SVcW/qwJcWdc3+9Hfcz6ua3AkOUd1IALUl+TTG0m4w+9FkhrL9
         YJsGGe6I92sxDHP+zJ6n+tWNI8NSqgf+RQsZe4Ue/sg6lXHhTWRsuUJLequNKWO3D0Ek
         H+ag==
X-Gm-Message-State: AOAM531UeY5LoOAP45aiZb17t4TWRPDHJXIlp+Wplq5R3O3a1HE+X461
        pKXRrhPmloxIhd/QMoyAVWmtIQ==
X-Google-Smtp-Source: ABdhPJzG+Iv9op27azP2OogjVNxj1MFsGWHCZnnj9ClTIQ02xQUsM5xmVOLGmgW3oMgeIooW2s3i1Q==
X-Received: by 2002:a05:6638:10f:: with SMTP id x15mr5886528jao.119.1622160067095;
        Thu, 27 May 2021 17:01:07 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i7sm1928553ilb.67.2021.05.27.17.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 17:01:06 -0700 (PDT)
Subject: Re: [PATCH 5.10 0/9] 5.10.41-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210527151139.242182390@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <781f950e-0c48-e846-6b0c-20210fbacc39@linuxfoundation.org>
Date:   Thu, 27 May 2021 18:01:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210527151139.242182390@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/27/21 9:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.41 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.41-rc1.gz
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
