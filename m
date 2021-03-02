Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D737732B014
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344562AbhCCAyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837966AbhCBWNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 17:13:25 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C67C061793;
        Tue,  2 Mar 2021 14:13:02 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id l18so2982646pji.3;
        Tue, 02 Mar 2021 14:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ecJdeElUJJMHQInqnrUdxKE6tvq3liGqZTibkwGHoVs=;
        b=Bv7oItXOzwQ5jTvhfpQBY23MXVSkBq20atwzF0Fqb3BMnilW5VGKvbJuSNvBL/cekv
         WPVEQRrN1XTdNZhilwQ5f7IPe4JRG7vdtOIZuPph5Zkh+lYI5kAMYtb0Rd4pl+OjdW6L
         eNqgTa4t6FMjbuAhZBBkzl5W653fD4zuWS+F9VeODl8y5Mz3UhlHNfdwI3D6pIaMA9wa
         dg28DA7SY+yFj+6dg/J5J2UtuBVbajokO2pqze4Ef9JTHUtm2FReM1J2wdlMC21fhBB8
         3W9mmUG1iYEfdb5EqPSu2v00Q96neJba8TR1YMwp3PABZqqVCwCTszhjpoYm6JaSZYxw
         YAsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ecJdeElUJJMHQInqnrUdxKE6tvq3liGqZTibkwGHoVs=;
        b=lOtJHUUeEK+aMFI6TKgMC4UU2L6o5k7WkCYGI36xOiHuluh2Ub0YMZ9KV8jvSfVYVf
         Juiy7kpDKkRMkgBkQ9nG+nKQYBUPqrNKL39+A3Rk8qUfNYBmYk7Jq7AlCQVwvVQxf6PQ
         qNDqDzr+sOskqo/itadb0Cm2H1jsFQnAW71Lmt0PDUWcbTn4MS14Y67/9HxKr4/aEVv9
         4avgfnGwHpQenvHFtKxVffnywC3+YHjwPBwzZSAjruGu59XKD8zuSrdZj6a/tWBqF5GD
         GQLgdu0/Ry2UeXyjTRuFG4+nfxX/Wp+kMymBi8USVRoGEsTX4limuJcJDEQgumaS2Bs+
         LsFg==
X-Gm-Message-State: AOAM533txlqFDaUTxQ4MYOK1Vm+38LmSoMFc6f7hyKcyzAEVbXujK5Kj
        4LuSNofkXcL2kSCNCt3ZSsf0cEnVvk8=
X-Google-Smtp-Source: ABdhPJzHZVRRlzh5pPqCJL/XMPk4KLXZ9ENteJe7elO2v1SWB+RimM1rFWjfYePeaSYthxrzHj+4mA==
X-Received: by 2002:a17:90b:3890:: with SMTP id mu16mr6450923pjb.9.1614723181599;
        Tue, 02 Mar 2021 14:13:01 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b22sm22220334pfo.23.2021.03.02.14.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 14:13:00 -0800 (PST)
Subject: Re: [PATCH 5.10 000/657] 5.10.20-rc4 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210302192700.399054668@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b5362ba2-e0df-382c-65af-ea880296ff9b@gmail.com>
Date:   Tue, 2 Mar 2021 14:12:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210302192700.399054668@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/2/21 11:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.20 release.
> There are 657 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernel:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
