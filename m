Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1634147B328
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240567AbhLTSsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240563AbhLTSsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 13:48:21 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937A9C061574;
        Mon, 20 Dec 2021 10:48:20 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y7so8834633plp.0;
        Mon, 20 Dec 2021 10:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EVW8mVwqCPiwvrDiSy4h1ZD0TQii03jML5sRqYqVYbc=;
        b=lilw0cwb0cU3TpM+ZgztYqXOesZ3t8O972b/ylehx5HS1e2MYgH9XlN9QJVidwmOgq
         AH07T8xDCXNhImF7f21MSY4xRWy/fU0Rxkeh5swNAyrZY0RruX5u6hTMTcYjI4QQi6Nb
         fxla9ZgT4LUZ8tQMwUXN+jabaQgSj9k8XUTDWuwNc5Khh9aNci9o6oNxitzDmpZ1uPme
         QXnNj34nfoL3q8Ww+MoTvcgD1h0NCxYMn1iDnSwxbTq+BqpNQFUmAf5vyKO7aaPowgD3
         ntEVvrNUvVFyOoLXaq+yMF1cyi2i/OppAq1kVC6vLmSI/2tDoZKXZ+vy6P1z637v6tOc
         XxVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EVW8mVwqCPiwvrDiSy4h1ZD0TQii03jML5sRqYqVYbc=;
        b=AFn6wnU5Pld4YvMmeFEFzcSCSotKlWxC5c5OGG2TFrINiVHQFHENhmOl60upvgqkGy
         ZXbx7PGfrYIkn8D7CqQphfC8d6zcz4/W/yyxprU6xPCfj7PLhDdqP4MZ36sDLx6QQH/1
         JBgh06X0pKrNFPGBkmqGAol/nrTzNYrPSG1L2FA1KKsSNtKEcORpP6oaQOQ1y0FQsXCk
         8YvzE7bSnc4LehiCjFgQSodVM0ydOu3shcKo2XBRA8C21yKVE/tpDeLXBDjCF9wwG9Tn
         e90mC1T6rTk7uRQ0zhWEFYVdXjIlDOB2hV26vZOmURYq/9+5tRJonS34HfcPn2ufuErW
         ZQzA==
X-Gm-Message-State: AOAM533zXmuOiuxk1oJvbs54RVCs11OAx3JZ8mvgtRIpw1hsgdU3K9HP
        TXgSAqtzSfO7O1UNrSphl5qipSGvxek=
X-Google-Smtp-Source: ABdhPJzzrXuP+iR6YjfgngNvrOc0tQZl+O7jxwrD8DuLWELi7xWzqFWol1rp3qrTG2zHujkAMYsMaQ==
X-Received: by 2002:a17:90a:ce04:: with SMTP id f4mr403245pju.10.1640026100051;
        Mon, 20 Dec 2021 10:48:20 -0800 (PST)
Received: from [10.1.10.177] (c-71-198-249-153.hsd1.ca.comcast.net. [71.198.249.153])
        by smtp.gmail.com with ESMTPSA id m15sm17898175pgd.44.2021.12.20.10.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 10:48:19 -0800 (PST)
Message-ID: <8c0051f5-9aae-f20d-d1dc-7ae28f15b354@gmail.com>
Date:   Mon, 20 Dec 2021 10:48:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 5.4 00/71] 5.4.168-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211220143025.683747691@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/20/2021 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.168 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.168-rc1.gz
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
