Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F37733153A
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 18:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhCHRu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 12:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhCHRuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 12:50:24 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B649C06174A;
        Mon,  8 Mar 2021 09:50:24 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id q2-20020a17090a2e02b02900bee668844dso3410447pjd.3;
        Mon, 08 Mar 2021 09:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WMI+KHTQp19/r//M2Ueg/Jb2+3OgCqb3zGUj3z9PlHQ=;
        b=C7RtR6GoK9SCsJc08yYZdf/JPieftDc3udKr4bZ3ETFzxsIOvPpoQcNOpqHxgshLwY
         Of0TnBssOGdQT1cQEUKQddw9RazzbA+gEv3Jvr0bX/QVQGp8Re5f7vUKuUK+VTicM5fB
         0g6WOt78njq0x3q7GvV0kS9o8GT1MoDIrW2JdgwingPdB6OxfkEMET+3TgUf2ZJ+bOta
         U5hYWe/CMzd78jmAzVU9SsEmz+AE4v5sdSwb7JRkwH7nzRg5QMBe82h74+9GCz1ksOlD
         iZhd+UpS7RQCmnRBuMgsHA9F6Z6Fqcr8WxuXl1e9uIIc6wrnH0OaGmKzWLZzOMRhtfi1
         dQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WMI+KHTQp19/r//M2Ueg/Jb2+3OgCqb3zGUj3z9PlHQ=;
        b=aAyws7tLtFF2zd5tKMrtE+CIl1Yxg+BwcFoAR7qW8gr4p0wM9vIT9wXcimh9zRXlBN
         37iIjmHdM/onGXIyolg4r54mRUSmikHuhgiM89xiUNwYTrtVkwWR359RPP0R+Lv5vIns
         7lYmFzKJnlPc9cTLEiOR12r46Yd9nXim53pD0a+YC6+Gor2/MDiO438Xb66ol5GfeEsf
         fpY7t7czvFtHAbQ2lyAfOCGV1rEC0TVXCetri2VnP/tfRuuin+wTkZvnT9M9KDbi9kh6
         xIdg8GKViK3LNoCcCxykKGNOmDBLg+RQXxKfeRNHaA8mpl/o/Q9Qad4qvsWW6Pr7tQ9K
         N2AQ==
X-Gm-Message-State: AOAM532bvXfUx+Ppg8NgVtw62/c/icH52Rhpfa8baGIgHuNZBJDvq0Xq
        rE1YDqPaPq09r8NJHAevPX1FTsgT1Z4=
X-Google-Smtp-Source: ABdhPJzxSJEFevsbFynH+jVrY0IF9RxAR1wZB+DcqEB71BspnEsF9tNKomy6QGHctQ8AAqiFJa9JUQ==
X-Received: by 2002:a17:90a:400f:: with SMTP id u15mr25609pjc.80.1615225823699;
        Mon, 08 Mar 2021 09:50:23 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u4sm10306702pgj.29.2021.03.08.09.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 09:50:23 -0800 (PST)
Subject: Re: [PATCH 5.10 00/42] 5.10.22-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210308122718.120213856@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <de221206-ab2d-5375-8d50-b6b9b4063287@gmail.com>
Date:   Mon, 8 Mar 2021 09:50:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/8/21 4:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.22 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
