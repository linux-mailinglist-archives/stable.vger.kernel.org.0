Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4759492EC7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 20:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244590AbiARTyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 14:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245187AbiARTyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 14:54:14 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1C5C06173E;
        Tue, 18 Jan 2022 11:54:14 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id c3so25439442pls.5;
        Tue, 18 Jan 2022 11:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eNrUscqw42vLCLOdKXjI6TJU5eZpO8qMPR9+8nKvO3Q=;
        b=kO/gnSMVnrPVYeFCn5YxhGGu9m4tsz2aQGARdUmcxVy/BZweaFos0DQUxJLsuaHfW5
         syVVuyzN8Au7CK/+nrMCDV3e2SMt26rDMJdibWWI/FdI5wvVwTGhRYGO9mj9uzWC2DRt
         3umPsyOBnglQ4XC/+IMdeL49245F1MnHwHKzWPTUSkaUCZf2nnwcgpL2oxuzf4VJhaZx
         3LKfS4E9r0i8SlyywxQLILxBgS3gM0u+v+wRu/xeSek3bN3raOuXVPdzaxDGWuNePbGc
         LXfaZafRKiyiGg37l/bNM+Ug9FK/EpikrEnl1jwwRy/tOtD/GrYNqn/pquHm4Olzri6w
         L82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eNrUscqw42vLCLOdKXjI6TJU5eZpO8qMPR9+8nKvO3Q=;
        b=4rkmOFf5mIDbSdhHeb8Xk3Ow1cz7fWwM/yekVwh92B/PViMAiW1PRv1RHDgcTH/8dL
         kX9IS/N3dCU1o8Brm5xtPxkdlRiKjObBcMOHvCdzcC0Ec3WOs7ns4hK36bpDxvhf8Wpk
         wWD0VPvbRssR9QjrXx+99NQ088dut9LNOvSfG38z/CIlu8cV1L3pqozNdpKR5mkRg9jf
         qwJ/TcMNRx7zYyWvGfHLg+OUyelRKEwyXRa0EqCpIY+wWohitHDkpEvNRkHMN1Lb9B65
         IfjjlLZPvLFHSIb9vmBfRREeO9whQNet7lavTjWhoOS/YWjyWbF44FQa51dq+07UEZgB
         ecLQ==
X-Gm-Message-State: AOAM531Q1VZsgH1b2hNwCv/ay1Mib1DcbYpvuDDscvdo++ZCTPaZ4Q+q
        vmHCxF+453NOjg21g2P9fm0rAlN2IeM=
X-Google-Smtp-Source: ABdhPJzNy8j7oUotixQfP2cRtqQ46pbEnG7KjFTrVX4VgsXlz7zwiyDUd2ndaGNRAbzuiI7yKnQeGg==
X-Received: by 2002:a17:902:aa84:b0:149:711b:258f with SMTP id d4-20020a170902aa8400b00149711b258fmr28872735plr.170.1642535653754;
        Tue, 18 Jan 2022 11:54:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g2sm19258083pfc.54.2022.01.18.11.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 11:54:13 -0800 (PST)
Subject: Re: [PATCH 5.16 00/28] 5.16.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220118160452.384322748@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <72179daf-7242-bff3-9a1c-ae3e11a95dcb@gmail.com>
Date:   Tue, 18 Jan 2022 11:54:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/18/22 8:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.2 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
