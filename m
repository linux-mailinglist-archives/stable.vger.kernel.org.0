Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2E53545B0
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhDEQvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbhDEQvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 12:51:45 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21AEC061788;
        Mon,  5 Apr 2021 09:51:38 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id z12so1888699plb.9;
        Mon, 05 Apr 2021 09:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tWte+lU9r7NWCW+LuM/DBgUmvZUSMCM0Pl7d1JQmdLk=;
        b=amIPdh7k6l1X9V3i6cu24JlDoOli6aqW9VIicOAnSdx2VPrhM+aHtuieqy6NqwK/c0
         L4S3pSa/XbBwk6Qf5T2J14LsVZaYtnTM4M3Lkofyld1N84RBDZAm14h4eETnkOg2GCSB
         u2J7lBGK2QPuJf2nov63sUrhiJ7GTPNTOsuAgVHVpVy8nn0hYJ+9Zai8ssf0CLQW766C
         xtCIZgNSgPCgdnBgZv+aFxiWP0IRW+Kw0D157G9iv3/PG+UCqX5szahfuK3FZCD4pRxx
         tfYw6smiVVO8ducwVQUGwxmRJh7qx0TsfP4qiD7tFywBP2t1rVVW/1DwXBS55dArolDG
         tDbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tWte+lU9r7NWCW+LuM/DBgUmvZUSMCM0Pl7d1JQmdLk=;
        b=uRKa8FikcCxU8s1LKUOisSUkhxWmyVx5x1u7OhbA5ME7+eCDXNF99M2DhUDCTT1Rxg
         0qfDAKlnhXdUfITna03W+aSdrijcj+2itKhVSvvuYfojv8S96Eh3ayYQwForUT/chcEd
         jz6LyA/tqT4mtC496eB1vKDZhyLk7vZCVbPstJxAG+fBS2sjBv+D9PPONlErd6V2+P9w
         YBif7u9cTunMFcvy5GwvBD5R/R4KpzDkebMpdlphiN+NQm60e8mmdGrn60Y/Nx5OuMzA
         fN9MUdIydfls2zHi//huYjV65Todf6KchWFayLSUDO+nC0zwYBY0+RLAC2+1XQ9WW/F3
         xpcQ==
X-Gm-Message-State: AOAM531UG2qshsZFqx+cowNJ+yea7KgfmDxhOsVm+ANZxBe/ZWqMmOeh
        C3ppTdHT16YBlAcUXjUWhN8hMrbHXIg=
X-Google-Smtp-Source: ABdhPJxZBRunHZpKckMHnbxmTMB5jt+Wpw97CfemfkrGpKuaSwr6fT+W6I7YTvvGKH8se5tMlOnw4A==
X-Received: by 2002:a17:902:8604:b029:e6:60ad:6921 with SMTP id f4-20020a1709028604b02900e660ad6921mr24840859plo.15.1617641498070;
        Mon, 05 Apr 2021 09:51:38 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o23sm9850247pgm.74.2021.04.05.09.51.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 09:51:37 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/74] 5.4.110-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210405085024.703004126@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d74b1c2b-694d-38dc-534d-28f0ca2c45b6@gmail.com>
Date:   Mon, 5 Apr 2021 09:51:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/5/2021 1:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.110 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.110-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
