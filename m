Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C64049EAB1
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 20:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbiA0TAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 14:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237859AbiA0TAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 14:00:30 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7980FC061714;
        Thu, 27 Jan 2022 11:00:29 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id l24-20020a17090aec1800b001b55738f633so5670951pjy.1;
        Thu, 27 Jan 2022 11:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uRLexRpb9NelNiVGqfMgolCZ78f60NSyet3pFs6d3Pg=;
        b=FkAzntIgwhm8m4oWmGZjsaLNwFb7UtxG+srvFSw7AEBfqxpVZJV+vYZuK+dfG9vCnf
         zo5HEXZ91jQxTqVHROXJMHpr3Frdp+kNJt2d7Ti8hhhygANsEBC04A2rlekgtp6vITyh
         IaHPqG8rJGdRib201Ns4S3D4mM6TAhT67XD2GF7L7AUxxRk/sV4K2UmmuWq3xdRWzr5H
         w3pxdDl+0tmbg7Pa9Ppqet+o8nVAgzQXmuIYPWtKRSaDJF43lcdd1e5nmtaEDkp72Eoy
         jg5jeIqOARVOeVtILPI4CFYHayWGRaVooF2BnO9SsZs5emlWy8zP2Tia80qmkSrPQ1q2
         spoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uRLexRpb9NelNiVGqfMgolCZ78f60NSyet3pFs6d3Pg=;
        b=UPNYTGe1DRDL9P80OsM5T7/+o6+ts3UwUTgFQAC8WFpykEoqbP6BvkKx5RLMtAdRmt
         QLSwW1BNERvVCduGyl11t/A1yI7XUpYnL4dziZKZyK178cCD+vsuQbbw4ycoziYa14qI
         2G7BJrvHQ54irUrTh1lXX4tKsoK+THxWeEEg6EJCjrCc4felu1FpH3xHvg/z0TAhEi5r
         JDKsEBn3uHAi//2BQNkt67c5Fgje7RE9u4qk0Upf265OZm94E8idkAJMiDP0Em/gdK9C
         k/PSPO5tkfma4r88vXTMHd6uqzE8qoq53J8xSdjG8KzLRvzu0IQ4whZOlBDPxEq1ivD1
         C40A==
X-Gm-Message-State: AOAM5318ZdddDl+IWHGxgaunu1bRcvhG2SoYSpvgIyXJe+UHZsFNQtQe
        0WfFROjtek+ba8U32gck1zQ=
X-Google-Smtp-Source: ABdhPJytgVqvLKRtS7rHVTqKKlzR8yr3ODjHvqRl94ovs8n7iRPAsLNH9nO6I+AcMxAEBEAllHTd6w==
X-Received: by 2002:a17:902:f54b:: with SMTP id h11mr4631851plf.91.1643310028976;
        Thu, 27 Jan 2022 11:00:28 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g5sm76578pjj.36.2022.01.27.11.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 11:00:28 -0800 (PST)
Message-ID: <788eebf8-cec8-e3a1-cbe5-fa494a32dfa8@gmail.com>
Date:   Thu, 27 Jan 2022 11:00:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.4 00/11] 5.4.175-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com
References: <20220127180258.362000607@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220127180258.362000607@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/27/2022 10:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.175 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.175-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
