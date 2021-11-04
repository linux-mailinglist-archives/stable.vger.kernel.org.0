Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BF7445B99
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 22:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhKDVYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 17:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhKDVYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 17:24:25 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BBAC061714;
        Thu,  4 Nov 2021 14:21:47 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s136so6545206pgs.4;
        Thu, 04 Nov 2021 14:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7g8kAQN1VrVCmMU4e673cekVfYf70RsaUBmQfh+Hs0E=;
        b=gRfwycbFIvdS0XbU7E+cVUXTEMIQdWRU8a6gJeYB58TxyWesuUV5xUobQv+8KIavnT
         QAWtUH1CTzWDakIMqugoL31FXxl5zVT/wM2XEOPCYLxdP4a6HPuppoGOyOoonVJK4qF5
         IQCx6N5YflS7k4YJd9qJ8YLs5yyzO1/uh0WMhM3d5751XhHqBGWPAwlfjj3BEW8iEvVA
         Bxi0eHEyMW1eT6VNWCvwKppRBYkgbhbDYFNP7EYXBA+NsxuTcIqKNwUrULhbZlcACx46
         SjFYE7w5XPVeYaAxEEoPWn+VSFGgiCyPepeF0Lyqk7w+sag4yLS/gRlhbrypGmpkbzhm
         ZeIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7g8kAQN1VrVCmMU4e673cekVfYf70RsaUBmQfh+Hs0E=;
        b=wR9HakzUVS81eCPirYiFDGP8W0CaMqdKY1X98/H0VSpXRq0I/6h+zuCLsEmGPWaGO+
         UQvCqKLGkl9WEO2fWbISQ5DsMWMcTI4G3wd7uHZMvGSYCKjXq92xcTORLc0c3cps3oa5
         kSxBepKRZ8+LQnsfJVXJtrO9CUIoUIM2MWD3dIy5ipHSfD+yKQPPSSuu2GnJ0vz05CR7
         ldhnHOwLM7o2oFTXdmgzmjXGCOlpifsyuyiWIoTkkADqQCxQHRW3Ye0v2+d9M7DdeofU
         754zf/eQsCBPSjXVByCx1jPetGwaDrik1oujTKnDMjodGYj+fDJPfVmYiY3ejWpwh4P7
         slsg==
X-Gm-Message-State: AOAM533CAMGHJaYXrRdxgK/zgqnuYDIgqnT1O/NWf68a57RbcKuf+O/A
        fcqv9iECSgZxWUtiM7vjPTfn0TwBbZo=
X-Google-Smtp-Source: ABdhPJyk7e8mZiBFime9fyP5QAhVHJYRB7xH3Gl+LVz1lNXayOCRQgx2obsgIJ1zFWTPGU1K7BBkbg==
X-Received: by 2002:a62:760a:0:b0:494:6fa0:60a2 with SMTP id r10-20020a62760a000000b004946fa060a2mr4177586pfc.39.1636060905639;
        Thu, 04 Nov 2021 14:21:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w5sm4480698pgp.79.2021.11.04.14.21.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 14:21:44 -0700 (PDT)
Subject: Re: [PATCH 5.4 0/9] 5.4.158-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211104141158.384397574@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <04ceb6b8-dc91-192c-f866-5d561d014a95@gmail.com>
Date:   Thu, 4 Nov 2021 14:21:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211104141158.384397574@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/21 7:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.158 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.158-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
