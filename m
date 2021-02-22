Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A50C321F1C
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 19:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbhBVSZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 13:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbhBVSZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 13:25:42 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEB3C06174A;
        Mon, 22 Feb 2021 10:25:01 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d11so3310612plo.8;
        Mon, 22 Feb 2021 10:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CvSdoLrnq1mY4p0kCiD4et6I75dXHqRAmFnkSEEMGFo=;
        b=rk9mbvOFGbi1VRL0Xfee+Dm/5QGS91WtRKYusoJo2ulCN8hzdUVEmS1xltdmtmt5qs
         dEgPJR0dQzAONjFXhdKtHhdDz85ICUdHLqMobIX+d1+WhgmsgPLlDJdA3faHF7YXTNQJ
         wiFVP47g72uvZSXhvBou69FJmn0ffAO2dvjnYOXPqPDb7J2xTbiI4BwNnJd70IFKjhyS
         D8/EQKciL19yNhMuW+Xti9h9NTrv8lWGDCOTS6qE64eQyCbYQWqoftoQ7Oup7HW9M72y
         u/4HAXe2XZqx6qqis3BBYRBbnfvTwml0rF56zVgSdIxkkxPIt38SLqd57cbPlN1pLXdB
         iLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CvSdoLrnq1mY4p0kCiD4et6I75dXHqRAmFnkSEEMGFo=;
        b=GvS7O0SIZSkeOHevc5miSvCOOZrA/QzBx/YIfvQvG/0dNJoGymStTQ02HXMMv41zPT
         JotbfR/pVeiiwh+7dTrKBq+RO/qUewxhc7GFHkmbh5SjP3QkBXsGgzHxEJcsgArAU5RO
         aN7/n6lcuTxnfV2MmBdD7l90LQfezDXnR+RXg9KqwK2RAInEsuUib7HIr5+4ZRdOusbW
         sRfiNFmiI9llzAwguJpRsuYdIIyhUjSXPR96tbbMc/nEfGYF+8bmgXaAzBzKBf8GLCPL
         edDgAqrbHilTUdOTpbJ5Ly7Trexq0Y6AwQkTNu9w+MN7bryvrc8ONQ6aeRzw5TcK0GEr
         x2fg==
X-Gm-Message-State: AOAM530Tf1ndIFfQ4cDJbY6CE5L6c6X0YAHutGfJ9Gnyw9JifSOIKtbl
        87j2rPrDdkG4xwRtc4w+W2y8aVHD240=
X-Google-Smtp-Source: ABdhPJwvqFNXoe2syHpbfM8edrjeI76jsqEKr/MEDYMG7VQAXSPBVQqQU1lc9hqDcrCXN1cC/+ZFtw==
X-Received: by 2002:a17:90a:e547:: with SMTP id ei7mr10446283pjb.72.1614018300590;
        Mon, 22 Feb 2021 10:25:00 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 200sm22082895pfx.24.2021.02.22.10.24.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 10:24:59 -0800 (PST)
Subject: Re: [PATCH 4.9 00/49] 4.9.258-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210222121022.546148341@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c22c1cf0-3d2f-cdde-241d-16aa6026492a@gmail.com>
Date:   Mon, 22 Feb 2021 10:24:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/22/2021 4:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.258 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.258-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.

On ARCH_BRCMST, 32-bit and 64-bit ARM:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
