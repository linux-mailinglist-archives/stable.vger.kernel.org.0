Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58094735D5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 21:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239901AbhLMUZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 15:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239891AbhLMUZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 15:25:15 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52CBC061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 12:25:14 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id 47-20020a9d0332000000b005798ac20d72so18676409otv.9
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 12:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vamzT5fQdqt7FXkOPVNfycHCO0oUwMx3NFBhiXymTbo=;
        b=Yy8z48ZUQDadYiOtc+DH/ezqZ4HSC6GhjeoaShEsy7O6N79ttnu9zwag86rvco1+h9
         8FKY2x+rX3Yf71W8j1qhzAyxWoDvDSb/iiTE1F3E2zdKW5sz3L+flK+FOHDvtJpbtkPm
         AiNXcqxMSxQdzXqVROuKqg7ozcD1NMq1EDx30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vamzT5fQdqt7FXkOPVNfycHCO0oUwMx3NFBhiXymTbo=;
        b=bF5cBOli6B0PaeTOW0i8Xz52+wk+dndwqUgnBKdMcBK79EJGlrrJwXTiDByOeizVAH
         PYhoVstvVjHJj0m0dDuHcnrr4lP9NdbXpfC0QCT/uORYWMiCmIinfRTMT1/mD7xtPYSc
         jDtFDGWdyILK/SNrSCF+yhn28EtnsclpP1sUoleUdFPnf9GQITuUACndoQfCmeUThQoV
         NKVowzBLXauQRlWfia8foTU9VE1fqM4taG8MAPG+Fxk1RdgQiom67Hh6x3Fcp7QuureX
         CC/yJclPS03lWqh1BUr0/HsmZEa6S3jwWZuLFD1kRb0ptisTidAerDzvzalrTXQuUc+H
         SmiQ==
X-Gm-Message-State: AOAM530en2nFipnlTL42/W3+NO7AYn4jfAcQ/RlEFvWC/Lhb7dY7G7rv
        ts93BoU9nk3QDJMvfu4d+yuadw==
X-Google-Smtp-Source: ABdhPJz6CrRRDQ4mMYL9Knmcd5JPan3qm0CwshYpHvKjWL3QrV78VwVQ4DHo7vTGaI9s16Gam3VW7w==
X-Received: by 2002:a05:6830:2707:: with SMTP id j7mr658092otu.354.1639427114188;
        Mon, 13 Dec 2021 12:25:14 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m12sm3048709oiw.23.2021.12.13.12.25.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 12:25:13 -0800 (PST)
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4d974e1d-17b6-abba-9cfe-9e0496ccdf2d@linuxfoundation.org>
Date:   Mon, 13 Dec 2021 13:25:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 2:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.85 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.85-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
