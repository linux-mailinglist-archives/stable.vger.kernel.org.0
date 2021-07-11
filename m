Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAC73C3A10
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 06:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhGKEKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 00:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhGKEKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 00:10:23 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0DBC0613DD;
        Sat, 10 Jul 2021 21:07:37 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id d12so14418759pgd.9;
        Sat, 10 Jul 2021 21:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dKsAYqxzYgd7z5GtPq+7QygjY/n937HhMVrbA1SRbwY=;
        b=b0KUIPzVWUGhcugYBElLH2qIZngK8VeLpDjs0zccWBCJ7qK/ahi4pyPXA8guTSnPTt
         r/XPBfjK1ogl58WgZYbzvXAV/bWDolLvK93TAFBG/HRci1Okai0GAjNM4u4GoACFYq+r
         1GGqtYqe7iWX5og/p0Ez0pj5FOdmoStRYG4NMm0SJmppeWQ+LTByW9ebE4xqALiRvGh2
         NvtO6gGGUhHcDdtbVs/qflVBVPG74oc20ENmZDNYzTghnQy9BFWMzCvUJp94+wayN6TK
         dj/9tVZCtL8CFro16sbslpzZcnObjwRiBqpItMKY+dUu0UIfWN/48YwJKOKIicuOLVoc
         W1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dKsAYqxzYgd7z5GtPq+7QygjY/n937HhMVrbA1SRbwY=;
        b=ZCBSGLTrMGEuNC3SDbTcplHflt0eqm1XDJFTeL0Cp5TnnTpeuOBb4Z4VlVoQdEGGle
         +/nSkmHhApEqEiwFOdu7N3zJy5Lxn9bINCbwG7xmwHR+zqhLxH3ww5JIZXV9zsyvXV76
         yuU7rk3rPORdePaH3ANpsSTbb8Daqtg010IF5xdCQuMRIhdA52p778zNf0aqzD3FUp0s
         2p7RgAqujE6MKLG20BHxgIBLUnogRdxpP+AOML/EQhJKK6rSQ/27Ybx3rt6oQfyshOtH
         GsDzPjSc+Sr9qlzTg2VQhhC+U9OKSxSzstIvJatOp5omdN7HINFd1Qyzfh0XE3oaAN0N
         rYVg==
X-Gm-Message-State: AOAM532pl69zgty6aczcR5cvxDm5GJqNEE6L/EGrHVZ85pN1MXSOeeOs
        4X1ouD2OO0BhvV0BFt5Ox5tMrGfyVzo=
X-Google-Smtp-Source: ABdhPJz5Un1Thv32tPo1p+lUMStY7vyIHw7hYRBxIVkNSG5Du0mH8Pt58GYw7Kw7azZtkTpHtyUVqw==
X-Received: by 2002:a62:d447:0:b029:291:19f7:ddcd with SMTP id u7-20020a62d4470000b029029119f7ddcdmr46508689pfl.54.1625976455968;
        Sat, 10 Jul 2021 21:07:35 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id t13sm9540885pjg.34.2021.07.10.21.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Jul 2021 21:07:35 -0700 (PDT)
Subject: Re: [PATCH 5.4 0/4] 5.4.131-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210709131531.277334979@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c898f2bc-dfc9-7812-5e0e-9d412d94f0ac@gmail.com>
Date:   Sat, 10 Jul 2021 21:07:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709131531.277334979@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/9/2021 6:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.131 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.131-rc1.gz
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
