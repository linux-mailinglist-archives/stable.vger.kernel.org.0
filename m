Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142C82C1A12
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 01:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbgKXAbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 19:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729756AbgKXAbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 19:31:13 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FEBC061A4D
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 16:31:12 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id r1so20081235iob.13
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 16:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h0KfbLuED4egfQJyR/pzdDn56fVTv57ll5OodBOSvb8=;
        b=CMJe82TU05qWWhMOfFI0V8H0klPOl4iszbVozqBu7PpSwcCqFn0Hg1t048nraWBRBn
         nMy77ykEtEeMwNHIWL9iirzI+bCYOA/0DoHIyuvvpXIT6jZk2svjsLj6U605W1xW1GZy
         JUVpc5UikBtzo8y/+8UplL/VsaZZVswX5kdnc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h0KfbLuED4egfQJyR/pzdDn56fVTv57ll5OodBOSvb8=;
        b=jr+FIp0jUjYGGbsH9l6qCtjw56nzcLhpjpDsKC53etfkt/EIsFynVg84Qmi7x3k7oi
         cf4VLO/C0Bwq/UADSeiWuzDGMmH/fVM+xAY5pnTWas3Dhz+J1sAA9V+YOpFbhcIfhLWe
         2fPQXyffYpXap2ZSvl6zrNvpLia3+0gTUMcgdhMXyV5064eIP4LmI5lAOYYt61IfRLDj
         k/TLNx2a2z9yWFTE8bOMAQ7NL/3HhNmh0o4zktmJ507X8xEIvRPCBC2AS1nsgLuYf8VN
         rKgtffx6+5KCIkGvvOy6ITnlUCfR0cKV19pVDoxVQnQJhXFwmNG1GdJ7QE9+UIkcZg6k
         PkPQ==
X-Gm-Message-State: AOAM533fR2g2iLJU/cd6uIu69MnQt0QLELDxnjy/g2Us0vyS75tUDH4Z
        CfGdxPOW4ZtznMEt0AiyhxoowEKaLilGNA==
X-Google-Smtp-Source: ABdhPJxn7JSGmMUGEeuqjp/sMgUstTRVVU+L4RHHFTdI4oVDicAYFWdgKMa6jKYvlfUP0Ojattf3MA==
X-Received: by 2002:a5e:9706:: with SMTP id w6mr1939535ioj.132.1606177871478;
        Mon, 23 Nov 2020 16:31:11 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k26sm6798668iom.32.2020.11.23.16.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 16:31:10 -0800 (PST)
Subject: Re: [PATCH 5.9 000/252] 5.9.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20201123121835.580259631@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <673cbcf4-2f4d-cea9-2b81-967c9d41ed3e@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 17:31:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/23/20 5:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.11 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
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
