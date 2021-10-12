Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCEF42AF92
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 00:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhJLWRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 18:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhJLWRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 18:17:44 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ED2C061570;
        Tue, 12 Oct 2021 15:15:41 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so718759pjb.4;
        Tue, 12 Oct 2021 15:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kv/NWuxxzWppNE1SIvn3Q06v7ck6fvbIRjMBxoGczlI=;
        b=mYyf965bzNNnPngaPld4vqm3Z0tv8l52PQDrQaOx9ELlNOia0nRwo/VUdbgaIzRxkp
         WR5ayUK6/HN6moSqexY5jN+a3osQ+Tx/BV6Zgm/NMLU8YOfB1v2f+go2YQpqXnosIvA3
         VHBZ0eLBvlobXHJ+ZM5XJrwddgPF2OVCqc6tJLOHyA5p1tFVTQlRpfydxjHM+BoKjDZ3
         whmY+W/JviciRsasTo9GUx4PJKGwSp5Ou1XwHs8UsOwuxYg3J/Z+K4i91JRENCGX7Zds
         8sbxWG/UqEPqkPuUl+ZgwcMUVCvchRHxqW8z+E4SuiaD5nhOPYl/WKo4DzOQo+sYKimX
         T09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kv/NWuxxzWppNE1SIvn3Q06v7ck6fvbIRjMBxoGczlI=;
        b=oLCF8rjHPpNyUChcG8MBc3mpXc8++uvFzF8qiZ93pz+qY6ieOGJiScEwgFLvGDa+5d
         WUQxiRYsY6VD6cVDcl9ooY+cylK2QB9dVEsE/I7WrylKThhQ6kd36C55OJxvvrLpODuE
         QHmXWNIN8g4rbIftUKkQMuSWkUy88y0arDodlyh74/jnp+/iVz3EWwPveGqqBPQDxGZo
         wqV+6Cm5PCQT9CJYgvoDt3pZGHXMzMxoEOAIvnQIBa2OyG0MzF5YejWTYAi5y+SuiS7p
         Q9IgLZoUPD/dfWs26M/95vjMZcj7Ge2oWVOMz0XgGBz7aav8TmCeRqiyQlPTpvPG0Uzo
         ROvA==
X-Gm-Message-State: AOAM531OsX9OEZ7Za1CiugGL5bCJSUD/JDlBiPSwDnrHZaCxkvOLxYX6
        BJjATq4c2sbijfI6L5Q5XHLSi4cxcg4=
X-Google-Smtp-Source: ABdhPJytc4AdZe49r9RXVRDjl5Q6Ss2cTa/OcqJdXfKmC35nb/JU3zLzoy6G2Qlrp7lLwFynGni2zA==
X-Received: by 2002:a17:902:fe83:b0:13f:5415:2710 with SMTP id x3-20020a170902fe8300b0013f54152710mr5367848plm.16.1634076940863;
        Tue, 12 Oct 2021 15:15:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id mp16sm3887969pjb.1.2021.10.12.15.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 15:15:40 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/51] 5.4.153-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211012093344.002301190@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <43dc9488-ef13-af5a-eee0-b1f4f0225db4@gmail.com>
Date:   Tue, 12 Oct 2021 15:15:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211012093344.002301190@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/12/21 2:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.153 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.153-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
