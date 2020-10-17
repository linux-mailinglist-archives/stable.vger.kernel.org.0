Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70D1291310
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 18:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438407AbgJQQTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 12:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438340AbgJQQTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 12:19:04 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A03C061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 09:19:03 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b8so7742150ioh.11
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 09:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9FAdmec8X3Z/zyS0441BsohTt/5lIOTFJXmL6v/ZaF4=;
        b=YgeZfRvQOBjnHabXTlhelcaZB3bXyJk25BY96Oo5tkpnlERJBpqZ0PaBZULn2SY+Td
         1J6CvbtPp/ITSdTUNnWRmdBOiG3VrvxGqyTk1ia4GkT5BC18vZfOuEFCwUFb6MphdedJ
         BLV9mXxe+dNH0+L+Kvj9bLFMU6Y0rc7Ch1l+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9FAdmec8X3Z/zyS0441BsohTt/5lIOTFJXmL6v/ZaF4=;
        b=r/1gWdw8CiKoAtPUSUU0Hb+TXTcpyK3GOpqzfQhQaQi+evzrcfyIRuvjdywWJzlFcT
         prhcDshaRH210F7F9tKSUVCdufScq83xOZxniroy+JWZPBpElARbVxIQqeynqsSvowP2
         ogWXHRYdcYOnmmLu2u4P14QKycyP/1v+pksnkl5sjrG4wubQ2/dZMQywX98avkriPlDe
         WqKtViTx+oCvmcqrT1Oz36XFTJwqFAOgCG0foJ6fxUjv2K0cJgMaQvAGMYjrg3MFctPp
         UIuwuCA8f7h0s/KilSRZabmn4ruJL4v2aOmjbWxiPcedFAVS5glsW7bVunbRDVhD5y8M
         kEAA==
X-Gm-Message-State: AOAM530bStHj6PcFm2kQ7QMbivEEsPEn9gkPSdFYAjRmaaRZvuS6FgGo
        G3r7SaBJW43GKloc7Is7H+hkEA==
X-Google-Smtp-Source: ABdhPJyp7TOPDFfKJ9lvvnlYa5ls4M5vjfAQpH7GG1gHcALkFXtLTtcWhgNrEf0lLNYipiFSjWTa5w==
X-Received: by 2002:a02:6c07:: with SMTP id w7mr846626jab.46.1602951542632;
        Sat, 17 Oct 2020 09:19:02 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u3sm5631086ili.57.2020.10.17.09.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 09:19:02 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/16] 4.4.240-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201016090435.423923738@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <68e8ec1a-51a1-4b69-e48f-8fa637ac8415@linuxfoundation.org>
Date:   Sat, 17 Oct 2020 10:19:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201016090435.423923738@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/20 3:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.240 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.240-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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

