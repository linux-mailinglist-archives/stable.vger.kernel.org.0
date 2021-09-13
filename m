Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28180409BF7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 20:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240302AbhIMSPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 14:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240519AbhIMSPK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 14:15:10 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC071C061760;
        Mon, 13 Sep 2021 11:13:54 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id v19so4277501pjh.2;
        Mon, 13 Sep 2021 11:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=/4uPDarz24UXr+YAssPYAyN6mqLcg35XkTUPvLLsvp0=;
        b=XMNZQEWHrFBKVsHmCmGO/UxEfbCSmwWA9iUwJhtYL1pTOc/zzjAo6PQxhv4LSwRZkU
         UwNLtLWPwFNT5VfcHlrLcFwKTg0AhLmiS7QKO3qu5KFECDujR7yK8ZkAVLvELx95tMBC
         ZXOhJGvtKVUTWJwotNsGLlQgKZKNub6Djkz0aIWImAQN9dxpqtLY4/fdOA/VwLNWhb6Q
         wc7UX+1pkpGhZBALZ8rpRPzx9GS30fwZXFJVvp5Y2xD4VFvFhoKT/NN/fmHlEyuc0zBp
         rtWdUIeWmMX70dkh3izYt8PAbO0sAPMPvTiIyVS9u70n8mttu9/Y8KhmgRN+Nh+dImPh
         MHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=/4uPDarz24UXr+YAssPYAyN6mqLcg35XkTUPvLLsvp0=;
        b=Tr6XN4uWJEPAordcUDgow/qqV221S5KPOLfXLXcjpnsq4gX4V+WQqeyvCX8YzayA1W
         n7mu1Jh9/ynSgd/g9ez5I5MZE15xk0OrfvQyNOmShGdwG6+x/AXBHiH/gql/9NJBkdVo
         kvUlQmA5WQyq71ajqWX+oX+zjYpVHbcerGDWLuU2paVu/9IkI26K+vOb02MnSjoLUh41
         xw1uXn6uRqosHLO/tf7oWextEkg3hTVH2rtwvzbp0JEcmRWxEttkkwaxRAsU/utkqObZ
         hzzAQQRt0OwzJ8Bec5zN3BvnS1Bg64oU/120O+TBaqZ194wFReR8UxplCD93zkI5wi9l
         iSjw==
X-Gm-Message-State: AOAM530/McoT11o/gd92B2X8WH8lOo1pKRSCRbb3s/NcrwiALo4don0u
        OSi3t+45HkNtVRWelsOlMzo=
X-Google-Smtp-Source: ABdhPJxkGd/xHVVkFK3JF6IYWybKCcwx2lG1h5ABdghsXUE6MZsE73b43XMe50eIPlqr/RNFx/TjWA==
X-Received: by 2002:a17:90b:e0d:: with SMTP id ge13mr815719pjb.53.1631556834257;
        Mon, 13 Sep 2021 11:13:54 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id p5sm7896845pfp.218.2021.09.13.11.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 11:13:53 -0700 (PDT)
Message-ID: <1f1f5f42-a066-e9d9-d76c-df2e5891c6a9@gmail.com>
Date:   Mon, 13 Sep 2021 11:13:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.14 000/334] 5.14.4-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210913131113.390368911@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/13/2021 6:10 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.4 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

