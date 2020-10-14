Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F98F28DCC2
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 11:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbgJNJUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 05:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730431AbgJNJTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 05:19:40 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865D3C00868C
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 18:21:52 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id o9so3375998ilo.0
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 18:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZAQeGgpeqN79999lxdxGr8+/QYmcQXgu9OaQTkWNF5k=;
        b=bQy+C2w7IW95f5PX6o0ydd2dtTnxZO3KvVJcfpadd9LaTY4WT+mEW7/SptgJl/U2t2
         ODnHRK9RDeuEaziItvvlOPyAwIpgT5eaKiHhw6N8otgXHJHfHvwRpN15+Sn5dCptlXST
         2oSRYNvFAhGaFrcJinK2wlC4vyNuS7RuNYkYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZAQeGgpeqN79999lxdxGr8+/QYmcQXgu9OaQTkWNF5k=;
        b=DtxJ49O7hqjETdPmnTvsiWElusJYfp1mxal4+cGg52zt1jaJFt3oziqshrrcjGcnco
         NnaGCWap4InR56L8lb2lrsK6HxTmh0rM8vD2aXZmfF4rA2pBA1n3srb6Yy5C+Q6AmXMh
         qpCg8T203xLfBK+HPeshiJixhuPob5vwKLob4V3YV3Jidne50BcnL9chn4BQfaNjNOl8
         6Yq9CptEF/7sYT9W2dBfpLlE2qZ2/ng9V2CGUCWA8hP8s/eZ8yq2bKCcqkPsl0tMAeSR
         kuPBaxuYDcdi1gcElBDzeO6YC+jZd6lCielQO2cefBiqvBcYXGEtMq9GrWByUjtM2HGo
         MTcA==
X-Gm-Message-State: AOAM533EDCjdgpOmcz/xvWM/DPF7ZyFz9nsJHyIXbUVWd0zM/IfBTnfp
        TIhXUclh6HXftIy+lRiBuZWjmg==
X-Google-Smtp-Source: ABdhPJzhjIZdpZB0ZizzMuxxQ1oxWpKlyuq15zeGBM6WMJvcvmBqcwtT9ZsyU029OMMj+MmzhY/Mfw==
X-Received: by 2002:a92:d211:: with SMTP id y17mr1844782ily.215.1602638511881;
        Tue, 13 Oct 2020 18:21:51 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b14sm1786955ilg.63.2020.10.13.18.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 18:21:51 -0700 (PDT)
Subject: Re: [PATCH 5.8 000/124] 5.8.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <75488e9d-392a-0a15-cfb2-5ba00e04f9f5@linuxfoundation.org>
Date:   Tue, 13 Oct 2020 19:21:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/12/20 7:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.15 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:31:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
>
Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah


