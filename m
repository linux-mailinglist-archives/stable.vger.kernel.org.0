Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E624440716D
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 20:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhIJSqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 14:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbhIJSqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 14:46:55 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E96C061574;
        Fri, 10 Sep 2021 11:45:44 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id dw14so1067280pjb.1;
        Fri, 10 Sep 2021 11:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ihW9KDPndspt5qyNgxniOeuPju9h1xWPYJ0Z1tD1580=;
        b=Who8hrR5IA2WjiAVPOoV4Acmb006sdOjcXFxANx1ntVdZKyjFwm1lU40Bqmakh3kvY
         mqSwfJPiTivVjwHO/ivFcWP18Ha0T9eQS1+CEnCW1KZKRbXSWDcFoJFm0p6lS6fOMNEU
         dTxeP0F8wyGF3OD6w5ThcjsdC+7g8FXt5alb5is+sisAwxIZHhuIOobAucjCEn96pkjs
         KbsdxFRXus1BPwiJB3JucI/Hgk5VSp1GdSAN3PDBYww/fhQLqJGci+QwUGxZm8T2NdsL
         lil4GmCW0O1Z2Qd6Y2jpxn3aHLXS4WldrxDlg6di6oeNcEPuXXLCnqF2gm2y/ibUTiLn
         n3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ihW9KDPndspt5qyNgxniOeuPju9h1xWPYJ0Z1tD1580=;
        b=meUlLTjY+ERdtEac4ZHa5QKwHsVDwhoacsLBtEy13C/iC+saVW3imjRSYXW2tnm6Ml
         DMoISiWtGPl+i1hbe9s3K0Dmt1jD6iM4ldZ02nEKxBA/oLnRCeGOm2TSPR5v+vr4dxdM
         CjJqeaLLKyLoXC80abg5hcWh7/zA9SuPMR97JrheUnfD6rATImkLn+RJ7qRTh3sxS0Yq
         j9DGJLKF0lAr4qt8YgxnmOuUennI+2Lnk+LbqkkAw2auTvHRXgSCwSlwabzk3TEtZsF8
         rB1OY5awI+NHYLXyqB9z0d7d1ZRKHKOwl4QURvQC8m4cR5BSSc3k2V5OtrBrM2QtKNco
         GeSg==
X-Gm-Message-State: AOAM531u0dtx5PNKppyCI+x+QwZ3QpC5GuuMeY/CFhr4UK1wY0U7XR7W
        JjAQczn+XJ083u+vBXraZ7M=
X-Google-Smtp-Source: ABdhPJzb39KzBYhV8pFaG1xVNgnzDoPs+DQfr0du2JtOpJHqT7+txRFSWf4W2D3khbmnksM+BFqNkQ==
X-Received: by 2002:a17:902:784f:b0:13a:3f0e:bb3f with SMTP id e15-20020a170902784f00b0013a3f0ebb3fmr8893507pln.61.1631299543631;
        Fri, 10 Sep 2021 11:45:43 -0700 (PDT)
Received: from [10.230.24.142] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id p12sm5494025pff.106.2021.09.10.11.45.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 11:45:42 -0700 (PDT)
Message-ID: <2045f6d5-2580-9275-e71c-537a8fc6237b@gmail.com>
Date:   Fri, 10 Sep 2021 11:45:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 5.4 00/37] 5.4.145-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210910122917.149278545@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/10/2021 5:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.145 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.145-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
