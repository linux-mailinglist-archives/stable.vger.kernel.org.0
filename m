Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1276E36B80D
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 19:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbhDZR1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 13:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235241AbhDZR1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 13:27:19 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8EAC061574;
        Mon, 26 Apr 2021 10:26:36 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v20so2040924plo.10;
        Mon, 26 Apr 2021 10:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cLCIZh+uto70g/NGlh3JaxgO0+JUYsKVcdMpfP2tX1Y=;
        b=bm26pDCR6Vqr1uEpGAWtGBxWON02GY6aLnHsiiwzctRfHXLhOm/E79PV0HBK+RWmlZ
         n3fIHi+4vNr779nEdSSEM5+pFprfWWtzuwODZ3rv8Ba74A7r0WDsTzbYlsfVKd6WBe7L
         Y5oP6xWB94rzCBo1/Gl3bOJUCoapszjHbu1arFMgtoGBTvCmBujz2h8iWjJi4Gsq2Ayl
         p9SfESj8lpLbXi29dZTuT4wPj1p/BSeBqkSFKFFXLvCeyazceDKcgcDnTiUep0eQ1uPi
         01GD2M3L8LNDNoUCwA0k5YH3cuXHFM2Jb3+6mp/l95x/wMsUxPDG5RlLSGkYZemCxqq3
         7vDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cLCIZh+uto70g/NGlh3JaxgO0+JUYsKVcdMpfP2tX1Y=;
        b=Nyy21XrAzwGh3z8X1L42v4xPx79FwZgZ9dZ4prOZxpmZAHPhPgOyizq9yLtbAuUrfD
         S+R+HSqXOKBPYJp6uKYOm8cSBuG0INXsWuAXLrPrRLV/6VKei1M0dd+dHv6sDpFdmY7I
         yUrL8KfayfSvXvEEPn/EzbUTUCnAYm82PyRQJhrQHbtEtD3Y8QnJpsFbtXQ3yakMHdPX
         aSouc27HeSu+JuwlbRJBiYMexz/Dj1ZiVDVnDo/MyHYTkQLNmHyKKVcKv5CDCioZx21d
         i0D0Bj/SXJQg7HhfuvORHz6orcbZpEeSkcuMPfzMeMB2T9ufPRFargPsnoYeJToVMZAt
         wyxg==
X-Gm-Message-State: AOAM533OVw2KUFl1jnp3MDLwW+h7iGYTFRkdC/+ynof9qlP11EU80nOg
        s30OUzI1CL8DbKbFdKfNVxvv0376+k8=
X-Google-Smtp-Source: ABdhPJwJK9jk8v4MENSbXY+EcbigbNrZrf36mSDMYE9ZZrqxR1zBQlc+qYbO0Trd0YFcSP0XPXOb8g==
X-Received: by 2002:a17:90a:ea11:: with SMTP id w17mr186661pjy.6.1619457995937;
        Mon, 26 Apr 2021 10:26:35 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t19sm343056pjs.1.2021.04.26.10.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 10:26:35 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/37] 4.9.268-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210426072817.245304364@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4eebc3d4-23f6-f8ce-470c-14996525c2aa@gmail.com>
Date:   Mon, 26 Apr 2021 10:26:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/21 12:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.268 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.268-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
