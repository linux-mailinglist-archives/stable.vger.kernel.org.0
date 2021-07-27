Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586573D6B16
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 02:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhGZXyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 19:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbhGZXya (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 19:54:30 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F6AC061760
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 17:34:58 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id s21-20020a4ae5550000b02902667598672bso2681553oot.12
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 17:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UxxDUt+QIQFJNEUI2UJRDvLuTFS12Dmny94pVpbFdTU=;
        b=eaDOiD8H+xrYAjUSN7INs5ALOgN3irxyrVExBNU6PqXiBUeAlClw8QeQRKlE+7t1Xu
         pO+6YyruHIuKrr9maRTiDdio9/vjOBIVznOrjecVCzoYn4MNsnKRizXEsk8fxTM0G0TG
         GlymM9RdDBdcQ5PSEo8zJRxztEinzjmR3QhSA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UxxDUt+QIQFJNEUI2UJRDvLuTFS12Dmny94pVpbFdTU=;
        b=DDk1d/sBIxbgWuZmEayAEdxfuVbqdBVNd/OTZx2Et7pY7ykfPr+tRJY/Z20zYb3HC/
         Q5d/xFiu9GvyH2KVZLtiM3clanehBhU7cCSUCF6mhN370BfARk4kaLlUB1LOP5qbTwY9
         R/ssu2AKRg6TDKiCkpyCthPQLjkrHhOIUIw7BlUAyj/pQQvIgBcJ0jkCuWcmTYQx7wlm
         lMyeakG2EE9HSAb3t8nJzP/ApWOP0x2t6gfgtUGaD3npj7bSaf2w42OwjI5PzTp0XU3U
         c6ArX9ZwNyqU9dMxynvQByHqkQSMVCu2XUpkCEqpX2k7w0A1riND7F+9Cr2vWNrlJSRr
         K8Mw==
X-Gm-Message-State: AOAM5326zNcbz0j+gvUDCRj+7MuNk/iNOCsP1/u//xv/FxCF9EZrxT8q
        WzjYf65W0zWxiuHpiuxppmBa9w==
X-Google-Smtp-Source: ABdhPJxDlVnVynUKT5s1Lq4Jk90PbTxLe/cZ6kmIISs1F6qWtLh64DIj2SdfYflbNnUaDVaHPTJ32w==
X-Received: by 2002:a4a:6042:: with SMTP id t2mr12094002oof.31.1627346097909;
        Mon, 26 Jul 2021 17:34:57 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j30sm272348otc.43.2021.07.26.17.34.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 17:34:57 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/223] 5.13.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <78b89130-5237-a5f6-e274-a3e82b402fe7@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 18:34:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 9:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.6 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
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
