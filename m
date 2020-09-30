Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4856227EAFA
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 16:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbgI3OdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 10:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgI3OdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 10:33:16 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7879C061755
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 07:33:15 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id 26so1903904ois.5
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 07:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J+NgeaQTip+26WMZqySi5DsgTyTy59esSMvYinJ9dG0=;
        b=en74YN7f/+4j3DUi8d9OMw/JkSrb/Qm8bZPDssxnVXD3zg5PxQFKWbo8SnCiBFUCB+
         utvnUunUJycAkuffxvTDS47QrYo8ha24NPEdAkJPat7YYmEPhD7UD6kw92vl1ad0RU+e
         S2oZ2XA8lPgXkoIV4fmpcSLFQUAgL3ezybFIw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J+NgeaQTip+26WMZqySi5DsgTyTy59esSMvYinJ9dG0=;
        b=FkpZa0DPBoTi00wZKltSMNNzQQxO7s+mJk36bqhuNTzMmqLPNwjE70mSTL3AS39C2N
         Y/RrXeS5iq0EZ89/w8sFZQZgpFDM1JXAmARvrB0UMwY1f9uFTMPH8oq3tNG4RwfjrOyi
         frwse6BeUL4dulhHFjMWbiwdQrrSb3WtmTzBLLa/4GQXOLEddvpFL0UE1oOXl78UV7gg
         rz31bNqkclqfu8ShGJ0WLcoqUU5lBFHPo8Q8Og7g1+QDlnH5oxNAKdEMqjou/NmMEjrg
         +cOQZ9cdDsuuwbAVyP2z2/m0etn4V0cfa8iseYR12Bmpae07ISmVceLy0xTpH3z0iTKl
         B96g==
X-Gm-Message-State: AOAM532QN0R32p3PGrfPeChugUMieThrxJOulql4vWYcKhQlFCW6vQ6d
        GRnMIfcSt3+gtVNcgLwwF7LiDg==
X-Google-Smtp-Source: ABdhPJy27eTmr61mJtWFOz4jPcdyEe+rvJNZShjTEpm6pNWTAwFaJ+fHQJNYnOulyyUtdBynMVva9w==
X-Received: by 2002:a54:440f:: with SMTP id k15mr1579316oiw.131.1601476395202;
        Wed, 30 Sep 2020 07:33:15 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w64sm345936oig.31.2020.09.30.07.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 07:33:14 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/244] 4.19.149-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200929142826.951084251@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <594a794d-cfda-4c3e-eb79-196f4a80c71c@linuxfoundation.org>
Date:   Wed, 30 Sep 2020 08:33:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929142826.951084251@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/29/20 8:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.149 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 14:27:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.149-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
