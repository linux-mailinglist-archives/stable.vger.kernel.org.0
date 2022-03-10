Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C0B4D4019
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 05:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiCJECU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 23:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbiCJECS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 23:02:18 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB7C12CC0B;
        Wed,  9 Mar 2022 20:01:18 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id n2so3765235plf.4;
        Wed, 09 Mar 2022 20:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sg9mu89WZTqf3UxmwnTGpyzXwzlg9RN0/5cLjOty3YU=;
        b=hL72NwWgQNlL+sTrx9XQqInDIDuL0Slkc9hd1WAGt2Y2kOtRNgi7R1eH7HjjgNOxxJ
         d8FMld1Tjv3lOKQL66Oi9LXv7cdLKXsRXNMmewlKPp72hg67IrCmg5SV7k+qYxTkFdz6
         uOBiFg+qJHQRBjDiC8RyNHU7xdHhqrL8vfzGsssebWiBKBxGqq/+yOba/K2Mzn+ZIEeP
         T/kJTYlFqoRtDbZaZBBkHX2JVGRYJQgZbL3HsyHXPYA6m9O8UhXmHvXg5FTbKLclPrXX
         FcwktLc/BuI/c6REycnHrw412MgId2bOuqQ+3awYGK6mHIn8bsQLqJtNigtJcbnCU6lb
         cW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sg9mu89WZTqf3UxmwnTGpyzXwzlg9RN0/5cLjOty3YU=;
        b=LkcpMmsXFa7g7GaaHDKSgSgs7rBXldlxmQce1qc7xG4Xhy7tEBzqHRCyq/bpGhfQNE
         TS9IKnZu5xMwg3mYmzME0iMsoF+qB5qi31WeCA6YKxxx+h0Gf/nlezvtNuXmWxob6nEl
         cYBpiWq2NZRCxWF3Hz0i9+vv2YxV34EgCX9ToWL1aUoX8be5cLiTKBBjrQ3FcbTDvPrz
         i7I1KeFbz/ipU4TpRXBZozzuB592EC9aUNBn7hAhx1eDWM01nJ4UbihQ1BaARHnEWJgr
         ffhki2hT8/hpBaBN/DZbDn2Ogyz/qbyxQfZFnLcgkEHJ/HrpM9/wZAz9fCa9oO+ot0nq
         3T4A==
X-Gm-Message-State: AOAM530dmWp1x+qu8xYoF+5/5J3R8QcVo6NVH9DjPz0Yd/BoZJV3jRkK
        vRNa71+pzDBcaCnNFBvC+0s=
X-Google-Smtp-Source: ABdhPJyFGbrmH5qdgQ+m0XCX0qe+YR9dhHBcICNQsojggI6id0Wdqpb2eQavE/2RtV9pqupn3a/T/g==
X-Received: by 2002:a17:90a:d3d3:b0:1bf:2e8d:3175 with SMTP id d19-20020a17090ad3d300b001bf2e8d3175mr3014763pjw.2.1646884877844;
        Wed, 09 Mar 2022 20:01:17 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q15-20020a63504f000000b0037425262293sm3715872pgl.43.2022.03.09.20.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 20:01:17 -0800 (PST)
Message-ID: <11137fe1-d8df-5ca6-8306-f3237d88a07b@gmail.com>
Date:   Wed, 9 Mar 2022 20:01:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 5.4 00/18] 5.4.184-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220309155856.552503355@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220309155856.552503355@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/9/2022 7:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.184 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.184-rc1.gz
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
