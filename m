Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22A33CF25C
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 05:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239984AbhGTC0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 22:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359677AbhGSVWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 17:22:11 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED08BC05BD13;
        Mon, 19 Jul 2021 14:53:51 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id h6-20020a17090a6486b029017613554465so1205905pjj.4;
        Mon, 19 Jul 2021 14:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2ArHNhEaAihBAE/6AhTLO2iS0mlPZBVBtvEpG6ldHiw=;
        b=jgfT7lcSDmPPJ3VUf1fDeEKuCvL1UtsGKEaIMolJR4+amNgf3ZZyPfp5vH2yWmoC2g
         RUPUNVn0I8h/n/MOw1udLA5I4O6hEof9aJ1Y+Dg1YJ9e9nJKeLBuMrJ/DeMloyAHm7o+
         +csPRmJf/g0vw9+ioKVC7muLeaaQOi7q5vQAmGsvUO9fHHwrAg9u/Kx9L34E3MUjYBV4
         T2ku+XqXiq1BJLGN8bayQFCYWvzrQJ/nBSzfF+0g/Xln3dMqRwGWo3etfel9B60+riPr
         XbhSKtBlQ3qnquE82q6v+xkVk2Kr99UBpi2RO1YCOI/jv/uOMe6ZCXb2UEmXjoszL2sZ
         4drg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2ArHNhEaAihBAE/6AhTLO2iS0mlPZBVBtvEpG6ldHiw=;
        b=omTTVM4YjeG3/BWtWGfqr3jru7RU/YqjCzRTf2t4kYyB+yXr8xqGiaNbyWzOgxhqy7
         EbH+mq+ndvBXpYC4dNv+C1iuMLDIQLoekYlKG222UbgdgZpPXs+G8dOexfVt/W3eFfWD
         nSX+1qx0Msjk6tBXQ38LjqX/e75QoX0CJyg2O9GZsGo/Rq/d1UILq7K32IC9WW883JD6
         nWS3iGqwNJO4OCfHcl+JsfDlhJYnKlrAZsTQgrGIBrUzFBWCFhqfgbaDWMk3O9K7Qviz
         5gFUUbGIkmt1sD2zQtIcO8I6OmOv8UX+M5Svp55BtRaKbBN05K8ZO/ndj4EDGljURr3/
         ALzg==
X-Gm-Message-State: AOAM532EiV/s7PCtSr7uqP1qPcJk+rXCZH+RLDVVRY6xjjAaBml3lET/
        HFu6Rw3C3J0oRQlsvv7IGkIbAuB9ytvP3w==
X-Google-Smtp-Source: ABdhPJwWaGI0CTyc/nBhCSgWwRjcYK09Ve/xT8Eh4i7B5lJucr3zAcWIoAzkuTjtDfDSc/yc6Xgj9Q==
X-Received: by 2002:a17:90a:17a1:: with SMTP id q30mr26302632pja.190.1626731631063;
        Mon, 19 Jul 2021 14:53:51 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m13sm20489138pfc.119.2021.07.19.14.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 14:53:50 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/289] 5.12.19-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210719183557.768945788@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3ebe56db-c21a-40bc-f2ee-a518c380ecfc@gmail.com>
Date:   Mon, 19 Jul 2021 14:53:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210719183557.768945788@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/21 11:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.19 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:35:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.19-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
