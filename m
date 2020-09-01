Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EE325A160
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 00:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgIAWWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 18:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIAWWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 18:22:39 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32959C061245
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 15:22:39 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id u25so2584630otq.6
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 15:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3ER0ltEsDy6u1Dz73olx5pTxbVk1kq7hDykAcPOe3uo=;
        b=d/Uoy50Kuzv54wghayiKGcy824eN1I/m4AutGRLLdU7lpdYzD9U9JcfM6tgXDTrC72
         L6VABgZR17HHPE+XDURYMjkoKFyuVqyAh7XsESyGB6hf5UU/gVm7eSDCFnE4GkgnodNN
         j2xl4bkzGqAVMrpAm+pPTmO0y0WBIkthWWUfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ER0ltEsDy6u1Dz73olx5pTxbVk1kq7hDykAcPOe3uo=;
        b=MUYU/uqTmyAZ7HoBnZBbZfdsNtngku5XYYLe3M8D0hOLGRsWsIQnn5g6Ge1xPsSZKD
         zLwQTXBYsnPwvi7qsyXwV0GNLvC5NMSwcoo1koKZ3vKxdT65FkUjA4LUvR666wMAzq/6
         eW9yJaNYAvDoMFJObAjheBrCz42TrV2Gk2/4fftsL6b7sSz0rM5Fwat/alQ52h3Jov3O
         U9ZgZgqHjBL8KPNZ9/tXM+KnI5V5SPJB6nVTaxMdGttGNfkCv+yDxyP9ax4w72nIUQ/i
         bTqenqbaG445+EOI/BKhxsLbcndMtwvqXjYH2CI5vBidQSDCDijaEPWyfIbqq2VPibDz
         aP7g==
X-Gm-Message-State: AOAM531DhxGdJjmejYkctDZDuuw9Io9Su/aqL3QPEc7aV6wHzSjpA5EH
        k/tjP7BF2CnyolsX8Rn5F+VkDg==
X-Google-Smtp-Source: ABdhPJzoQAftt1vQrLXjLw9PMDCUtYjUe3gNIkgrmpErP3pF8iGpyMTNXFBjRWwrxiQJVBmqx54jGA==
X-Received: by 2002:a9d:3d4a:: with SMTP id a68mr3107674otc.216.1598998958607;
        Tue, 01 Sep 2020 15:22:38 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 91sm434946otn.18.2020.09.01.15.22.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 15:22:38 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/91] 4.14.196-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <1856b9cb-a750-c10a-e88b-c7860509424b@linuxfoundation.org>
Date:   Tue, 1 Sep 2020 16:22:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/1/20 9:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.196 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.196-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
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
