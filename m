Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50521462BA5
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 05:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhK3EZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 23:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhK3EZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 23:25:37 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F173C061574;
        Mon, 29 Nov 2021 20:22:19 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 200so18378363pga.1;
        Mon, 29 Nov 2021 20:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ScDwun1MrWy25Wkpi1S5wmjeMsWgqTKemnA94CqnCC0=;
        b=GJk6qzBQtJbHdAqWlNGbMEaVRY9LEWl92CchJdQnCOuSueWvZHXD6AMueOui77AQrV
         hv1l6QB26NEm/RRFsWUFIA3dzicZoX0QzKHBAX0IIzS6dpx81hyz+ldsuHjS7pvZUvW6
         hIK7YEAIRcpEJJepZOaYPmgvEViK+xblmIUchfli563v+EjKxZHHJyKYXThrJ+Y3szID
         tyMwnkdzm/BkxJOIUVj5l4XLMpMIkRJVaXvDlYmub6ETU4ksEmMwiecApaKoRsV4TUXF
         07ML0nnEqEW2T+exaq10/9z7Sp/ESHDzWYysvUpuTe6X+JZtj+CCVrG9ciBwIKumF853
         2AjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ScDwun1MrWy25Wkpi1S5wmjeMsWgqTKemnA94CqnCC0=;
        b=m8W0u3ptFyFvBzVchpALJtdt5vS1SikbcHcP4C6D6QIJ8/te//49yFbMaaGGa8VrQQ
         hL5UOGtMHyRv69m8ki/lN9GDIzcwLV4+/V601YT/+AInpQ37g9qkxk5wc5tPXCeL6THH
         exqU9KlAFZ2cFoXR0jB24uKQz3amCGyJq9tbUl/DaFJwcpsdeqG1kE9F4GCplK5l4GzI
         tBoimM4D5xUFeVc0l6o9xlO6uMKu3wYgpx68ABODwgphVKSQlO7vRHFeMCXeuBk/vTuh
         lBmXBwRrLz0QIMpaIv3/A7TXQi8fdBnuW4hIhy7FQr24mpY04dVP/6HHkjAaFxd7dOr4
         nGBA==
X-Gm-Message-State: AOAM530OKD/NPla4Q/zbl546cn3baY42aUD2dyI0ZcCRfeqAzG74oEPN
        wXu0xWVKDRY02yzAGOaz3t0=
X-Google-Smtp-Source: ABdhPJw++JZt5RiApt6e/IvDUAsyYXdffjtOGiBZrFYoDbLPNtB46pMgWcX0rJxFBr6XgB9VcE7UFQ==
X-Received: by 2002:a63:4963:: with SMTP id y35mr9407652pgk.279.1638246138928;
        Mon, 29 Nov 2021 20:22:18 -0800 (PST)
Received: from [10.230.1.174] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id j7sm20046731pfc.74.2021.11.29.20.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 20:22:18 -0800 (PST)
Message-ID: <c1a556cb-be08-a48d-f6f6-6efc52d04b89@gmail.com>
Date:   Mon, 29 Nov 2021 20:22:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 5.15 000/179] 5.15.6-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211129181718.913038547@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/29/2021 10:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.6 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
