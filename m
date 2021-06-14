Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6210C3A6E9B
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 21:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbhFNTOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 15:14:19 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:50767 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhFNTOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 15:14:18 -0400
Received: by mail-pj1-f47.google.com with SMTP id g4so10332516pjk.0;
        Mon, 14 Jun 2021 12:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XPsSUjzJXtsHgenYYwSTN6yvsrboaFmgosrUO0P4ZHo=;
        b=PJHFx1V6wbi8lO0zo6mNrDW/FMFy97BZlv0+bC82Tj5B9I1feJR0HyTbJMm55baQ0y
         nkRljIrYcjyJLpL6UwiocTmDcvLuCFeODCKFji89FgeXHGE2kJDZFvYeiTOSCV+wLOUT
         TKtu/fycqfhyz/xLo09pKxnx0qJnipxgMpH9O2wttMv6zV7fKKV1ROlTRC6bwD8BwlaZ
         ZDgUVDO9jxV9gEWPZfgmEhJiWm65R8vnc4qvSIRpB3OIzYdkLCf1umZTnOpt+5cp8kWO
         +mVes8DD35CyXzjPGrniT+h7WVvu61RF8mxg/HIErI5BlV+KKkUuviVtQCDPpD0ZjgMv
         HUXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XPsSUjzJXtsHgenYYwSTN6yvsrboaFmgosrUO0P4ZHo=;
        b=bhrxOn5nMVk2JYXI6v27hBZQitE8iuDb5fzwCsJWeeab0rCyLsoU9glV5KvJDwjwbT
         uCbGZ55Y5WPJEc1nF4plTBu8UcXaJ8j9YkhXRVGgckOM/LO5ICFrn8fVW9canXyNucat
         R3ueDvx0E9PV8x3mlU9zR6hhX6CiWKP57F2WWDjn5oSOu2JKnCpoi2Hq8Die5bZBxwhY
         gJFWP2XgWOZ8Rl95AZBDHhPMpa6G1OjtfEWDgTEHI3hDv6LtK0OHRj6U6355K1DtOlCI
         YLW6G7WyeHql0E3dg0F/GjM0Q6DkHiu03Kp1C5BrNe/qKk+cuB1pqdoOrGvye0ovg4Um
         7Zdw==
X-Gm-Message-State: AOAM533noEx8punAC0A4uRlihrzmaSfMhCVPADYwOdLPLXts0zaUCP4u
        bJoM+mpNk5y3pqwd7jtrrFHgPQyGuic=
X-Google-Smtp-Source: ABdhPJw42FOL3ROhL9/hY1zg9LZkua3syrlFOlETh3ZBkvQOe4BtPBentF/Ho61RD8kQhDlKUsLCdA==
X-Received: by 2002:a17:90a:7e0c:: with SMTP id i12mr671121pjl.172.1623697863086;
        Mon, 14 Jun 2021 12:11:03 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id o7sm14331703pgs.45.2021.06.14.12.11.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 12:11:02 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/42] 4.9.273-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210614102642.700712386@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fda07a93-e036-822e-e4b3-80c5117c4a25@gmail.com>
Date:   Mon, 14 Jun 2021 12:11:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/14/2021 3:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.273 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.273-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
