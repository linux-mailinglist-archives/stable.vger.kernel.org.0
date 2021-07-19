Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520443CED5F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 22:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357474AbhGSSWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 14:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383812AbhGSSMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 14:12:07 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2782BC061762;
        Mon, 19 Jul 2021 11:41:03 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h6-20020a17090a6486b029017613554465so591482pjj.4;
        Mon, 19 Jul 2021 11:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fa7ui5xIXugNIy5/E/+uyFJAmU5MKzadS/w+W4BNxFU=;
        b=DBSOnEJmcBE7yW3PdUEZP05791r8MqgyaoOCWFSRmSpJb20s7zOVYMlxm14DPKAARF
         Hhj7jYPrPuR5vd9E5V/zTQVoVnI1FC6I6fffV35ZFwZup/ce5b64Ed6rQWcTncy8fhF9
         UHgf+EXUbRb7gtCe3zv8eRlIWdifRkGGx23aM0QSfRkNTOi4JBh6+LOnNweQnc8S8SRo
         7cvxd/RjXdyOEkMJgUmrBMUSGlj9XuSMr+rPMN9T0PLyLqnjUrr443zbT8nvQ3Z/0RPB
         gvcxjX2F+x18mTDAH4EtubRmXLaEzmTnNMf9g5wcyg2lWeVf5vGVHQgr+7sWPcGdjK7F
         TeKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fa7ui5xIXugNIy5/E/+uyFJAmU5MKzadS/w+W4BNxFU=;
        b=Sa0sHdPeRbIsvPTTLXQVpp7wifHJtlASGphCfLiJk2XEN4K4zgFugK88lE27zBAQoq
         WK6H9xi64IZAFE1MfqulF1+pj6Ueu8nOC0ymI8PbblnuCVkKEKd1It/4Fn1aOCfrVl6Q
         OKuaKbASSZXfwk5veRmizdM6vwaXLTXRUSri+UV5jB7mRZC7Yn++qWLFNRTi5HAuJM6K
         vIJvvSp96B5wm1mUAS/BA+luCNHueXcQRr2MIJokvhrRKFE66YaamzCKKP3bTzdWgPVZ
         KDlNpzWXsgy1J7iB3m5bDG258eUEpxz97UWQzr243WLaKt/Tk3dDTE9AZhG8Ph+QNcXA
         GfXA==
X-Gm-Message-State: AOAM533HsSfvXqQdG/SusuqzrdWDJgrCLjN0vEnCBe2AV6rPERtllXLl
        vJcT6/0FqeSFWRuvMpcGgwSDpXqOs6VoaQ==
X-Google-Smtp-Source: ABdhPJwlSV8mU9Z1AmzjRKRhkymLlbBCGMm6R+psrwe69Iv0sgF0XVm2XaeifT9Q4grg9qGg235Rkw==
X-Received: by 2002:a17:90a:5889:: with SMTP id j9mr26031672pji.234.1626720762857;
        Mon, 19 Jul 2021 11:52:42 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t2sm665515pjq.0.2021.07.19.11.52.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 11:52:42 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/243] 5.10.52-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210719144940.904087935@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5264d132-f951-bd9c-ce6e-1e54ea07aa69@gmail.com>
Date:   Mon, 19 Jul 2021 11:52:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/21 7:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.52 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.52-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
