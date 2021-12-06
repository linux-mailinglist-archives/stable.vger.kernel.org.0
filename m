Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90D146A47F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 19:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347214AbhLFSb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 13:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347281AbhLFSaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 13:30:06 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F5DC0698C1;
        Mon,  6 Dec 2021 10:26:32 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso591397pjb.0;
        Mon, 06 Dec 2021 10:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wG67+hFh20sbl+mlhnTB45+U1jMg4dosq4/UigtZYhY=;
        b=A8GnMIVxy409bxG2VeHVjfuRC73aXubasXA/8R+JHq0vMJEZtUokDToyTM/0I+wkl2
         H2R2Zun7uvYgAGod/h/UBW2TYVBAvnIAeDJXCbNB6qXMYz+51Al5YQ11jkbrWW/OIkuQ
         67YRHF58Dv8bk5WlTW/g+ZZlUo0V7B5NwBiJbEYBDPoFt+qz+EvXewvYyO+fPLltFn90
         H1fHpl1I7wszAcQnhMQiKKcp8cBmfizY2x1EjGGGxOAn8a3pmONPeQPiGanPgBqBNadv
         xx/YeHtStPivpeVOGdRaDr2c+9umsh6PAId8KgxvGQcMxFGoihqIoWS74nxAHegBk/TH
         /OSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wG67+hFh20sbl+mlhnTB45+U1jMg4dosq4/UigtZYhY=;
        b=52ujOPnGZyR++2lciV6jm+o1memdRKUasODd8VCvF47sPV/aEhBD97YjR4ZCetQMZ5
         334N0beAtjCxZ0DwL1gyqlm72W/JTHiAIWGZFPkVvMATCDTEXQsHWkwATlVnY/3Ugtb0
         OhC/+DxWmPdWXxlS0YWaQhlOZ1d2aansHoN0oCdQ6Tq7QvX8qr528Uo1VeVWnkTboMKQ
         VOpPEa3XHBPNx1Th7DtCBDelknTyaP4uDn/5Wu19yQSsoknQwAfvZ+uNftZ+w7N/teaS
         r/Z3DhL7y2oWiAJw85PmzEvNnsyCkiQb53JBlvXeYWrJwm3gWIOhyaYomoNziCPyO6Et
         WOoQ==
X-Gm-Message-State: AOAM531AQyWQqz0ntTtByWP0hiZfIDK8v97gp2JqMnIqp6fsNND8CNYM
        toJUAhvddKG5hJgzmFK5gLLz2DAqZ7w=
X-Google-Smtp-Source: ABdhPJyjDa8airUMVl44B0gLmDlMUSEdK1rzqwwKqSNFclM59WCFv5B+jY72zTG1cylKAgyNxNhrYw==
X-Received: by 2002:a17:902:c745:b0:143:d220:9196 with SMTP id q5-20020a170902c74500b00143d2209196mr45597750plq.74.1638815191641;
        Mon, 06 Dec 2021 10:26:31 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g5sm72727pjt.15.2021.12.06.10.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 10:26:30 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 4.9 00/62] 4.9.292-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211206145549.155163074@linuxfoundation.org>
Message-ID: <5abf8356-030e-b22b-8564-79e5ac2d47f5@gmail.com>
Date:   Mon, 6 Dec 2021 10:26:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/21 6:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.292 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.292-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
