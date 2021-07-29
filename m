Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0442A3DAE39
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 23:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhG2VY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 17:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbhG2VY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 17:24:27 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2DAC0613D5;
        Thu, 29 Jul 2021 14:24:23 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so11592650pjd.0;
        Thu, 29 Jul 2021 14:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CRgHZ2BBSgqwW2a2rpM9WCsD0d71Vahfn60hOqytatA=;
        b=NJaQyjufKu5UPM6xUx+chw7zJ8jQ3QZybWr7GcSAeIRb3mh+3QZYhdzLiepTYYFNPE
         BHQRr+MoqpNHQCEntokn5RKOfMtpL6oweobwP4GwogPfRq72rnLTsFlazVUV0GnGNfA+
         uK2TOVl180ldeX51cqHRuXeaLOUceag++yYbIM9P+AtEBnrhc+H0lydYmTushKghciPC
         Imw0hHIMoT30WyBbo/U6zI3qqSR3HE02V/lEiqYEvOORkRo33Ei+qYrBtBtSC4GzY3jP
         dvqiXorKQZZZN7jqE1B9VDvH9Hqnl6hJM9y8gtCnaQoZktMCsAQSpHiHB/UdRd3TJAU5
         8rqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CRgHZ2BBSgqwW2a2rpM9WCsD0d71Vahfn60hOqytatA=;
        b=dz48uuF3f0Zq1FS3d6sW50WQMTAcIwId30lCkUP1yyNTOp0O1PTuXBXlC5+7xNillY
         SosRwZbz31viZvCl66d31gkaYZAvpWu62t4RCViqQzShJikwMpfK+y2FaIWcot1vbzfW
         0+MtHQ3XuiolKdotBM8evnugkQvshSYWG3rCtJp/j22+m0jhkg7cpxIgihjjVi4TIVsR
         oMv93AstL3WQ1IhK+YQNAeokEZ5x8QF5A5yiABRhyKMD9nvY4W7E4wSXvU+kqDGHag6e
         LuV+yhEQxzfBHaKAZoWZR1lM3h7qmjh5WS5wH5l5LzYjqhL3TUzXOJpULCBng2FLtqMO
         BTOg==
X-Gm-Message-State: AOAM5326zisS8P1/3UD4Ckc/LN2bBr0yTqaTE+SbffLgzpd/P932rjQU
        ePFHMFutD8hX6f1YPnySZ5U6+07mxYg=
X-Google-Smtp-Source: ABdhPJy45q4MV82IN2SwvkEJx1i+Sd6Vfggh5Kl6LB2ESsBdePfyvX7lw42Sx7py2t79dFwaA8+LPA==
X-Received: by 2002:a17:902:bd83:b029:12c:1fea:7dc with SMTP id q3-20020a170902bd83b029012c1fea07dcmr6371902pls.59.1627593862310;
        Thu, 29 Jul 2021 14:24:22 -0700 (PDT)
Received: from [10.67.49.140] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p11sm4346619pju.20.2021.07.29.14.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 14:24:21 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/21] 5.4.137-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210729135142.920143237@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6d7db723-f9d1-959d-ed6f-d6b9ecff0d07@gmail.com>
Date:   Thu, 29 Jul 2021 14:24:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210729135142.920143237@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/21 6:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.137 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.137-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
