Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E47492E6E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 20:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238580AbiARTY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 14:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234118AbiARTY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 14:24:59 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E73C061574;
        Tue, 18 Jan 2022 11:24:58 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id c3so25362278pls.5;
        Tue, 18 Jan 2022 11:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+UWSZE7rTfbiV0DoMJdgvDC5mDXIvxVEfgFK5lQbkO4=;
        b=Ffl8ORb8OOits0DKRjbwI3mBGdz2vL3uh9dC6nyiii4dmQJyI70gukxam4Kn0PmAga
         BJ4N0fKGVm1UQQ2xd8glQiE97+ODD9dzHndRn52gAn2nq2kANoi4AJGvea6ccNELkO6t
         HsNT7YhGht/xd1kJZxZgLEuEfLKPhP+ILFP30Ty+KBIlGwU2+h5d65G9Z/HEdGqu47yU
         7ayxeQIRxXsvrSjvQGmz9MqJjeABc7EsokwKhBsoB2fM+tOKiOA9i9InqICRoSkcpIXS
         uHONEd6ARoYA6ylFqlJfSJKaz/erAaRypDvSOk8Xsx2TQLK8O/GGQNPHllvQ2iSyB5SH
         ki0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+UWSZE7rTfbiV0DoMJdgvDC5mDXIvxVEfgFK5lQbkO4=;
        b=hwZ0R3vLwcyEGN4XnslptaZvJqNChwmulF9FLVQmAi9QWzusVi9S0Yh0d6yXoQPWW9
         nfo9iQoLtYgDoQWBV+efPWoRyg/8aP6o8YSGIZ6akV2tnNxd7lSuatEM6veP7DALtwxp
         DsrZ0Nag6egavixCT1C7xd2Gs7wuo2+i89fCIYTAzYnzMc5QS0exv1O58Oq00xjV6ueC
         dyoozn8Fk4dM0HAq6C+F+VS/CvsNTW3ytOR+aRefrfpxzDaH5cnVi2Zcy/uSdnuCZxFX
         iThZ3zQmkU4b76ofSdEl9LhTjpfOP15SgnZmJ7GsrMTh5axwO2zUokwyy8alBo5ZB47i
         nKdQ==
X-Gm-Message-State: AOAM530p+SPlYgjzSW33bsiNSizM/gVWFOuegP7egIDcRoKkUfRk0iAj
        NXNGwo4gXSyUNS/P5oqoe1d/JgCyERc=
X-Google-Smtp-Source: ABdhPJzjFonkKDklgo3i0Ugm8T6HEU42tu4Vor586qtQPqhD7qQJ677yDutKGCuC+egJOhjVJV+B0w==
X-Received: by 2002:a17:902:b113:b0:14a:cbf9:bcc6 with SMTP id q19-20020a170902b11300b0014acbf9bcc6mr6571700plr.150.1642533898162;
        Tue, 18 Jan 2022 11:24:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q17sm19008262pfj.119.2022.01.18.11.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 11:24:57 -0800 (PST)
Subject: Re: [PATCH 5.10 00/23] 5.10.93-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220118160451.233828401@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <62354af6-7a68-008a-2ed7-ac1d2a348e44@gmail.com>
Date:   Tue, 18 Jan 2022 11:24:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220118160451.233828401@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/18/22 8:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.93 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
