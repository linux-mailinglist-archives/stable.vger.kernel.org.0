Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6F01486B8
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388767AbgAXORI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:17:08 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:45193 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388527AbgAXORH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 09:17:07 -0500
Received: by mail-yw1-f67.google.com with SMTP id d7so872608ywl.12;
        Fri, 24 Jan 2020 06:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xN3F7RkkR6N+RTehBM8b2GsSNsIHIPN4gxXKzCLb2to=;
        b=kneNmPnAb3wuph11CJQgOFZss6tyfw+xZQrR+daAjkHHxSEiz1R50kAOmCrfix+Utm
         vGWjaocEn4OOdhEZgCCgR1EvanCchWMes999aheJspMUD8I58KHuIEd1636Yai34Lk6U
         R4f9t0V8pqvmwJ+VHlXhN1hu6kVcJ53NkT1Z2jdr09ap+KHwUJkxTiCfWxpqA54qBNff
         mzuQWuPtEsfYgJlMEcD2bzX+qhIaR16vrFGAYph5sQL1Ni6sDF4m4/7QIpi6iem86uee
         DpawLZiaDLRbw3kZSLxWYBYOvaLk+l5EMqyL1l84zEzQSPc283nt7eaeZYO5jMeUL6c4
         WcfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xN3F7RkkR6N+RTehBM8b2GsSNsIHIPN4gxXKzCLb2to=;
        b=CGcF2KSVljasRaGOncA5Ie49qYEwpfR58p3GvQY8EXELHCMJicdSOTiSj0cIiBDMEY
         iOgS/2HUPBcAOn6HGLtWbW5XwRrTuOJqLVJAfej4HN2RLyBUsm2kPOXOqSr5K6msvf4y
         8SwBZGhnoJJ7CHrGl244jsV4MQ+xmeAzGLku9h2jotmmvHwzWdLN62df3iw9Gn89RpNE
         2tpZWF21wD/Qd2gSMg1hVe0IZ80uGPaknQaUQwWxA/Lvy4UH21GrvDlExVM2NWn2LVhm
         vwcX5P2z7amiiA8AdrXsUR/eR73trqScVw61Vf1gr+PX4EllIPnDU9i2fhfB4E1RB1A5
         b85w==
X-Gm-Message-State: APjAAAX91gnHU6ZxPoCFf9k4e/fc9bmzeBZ0G1ti705Of2mgehCvzVGa
        s8tBjqoFXTgXBbw42HJeHgj2Tf7B
X-Google-Smtp-Source: APXvYqwsU0Bt0jAPhciWU0JfPHE8uN0a7Es38QSletiuBgOwc913k3qUMR+/ioA92ngRVo6UtoGNNQ==
X-Received: by 2002:a81:47d5:: with SMTP id u204mr2063589ywa.365.1579875426613;
        Fri, 24 Jan 2020 06:17:06 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n1sm2322181ywe.78.2020.01.24.06.17.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 06:17:05 -0800 (PST)
Subject: Re: [PATCH 4.14 000/343] 4.14.168-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200124092919.490687572@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <6fce449c-e0d4-7660-bee6-578bd5cefeb2@roeck-us.net>
Date:   Fri, 24 Jan 2020 06:17:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/20 1:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.168 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Jan 2020 09:26:30 +0000.
> Anything received after that time might be too late.
> 

powerpc:allmodconfig:

arch/powerpc/kernel/kgdb.c: In function 'kgdb_arch_set_breakpoint':
arch/powerpc/kernel/kgdb.c:451:8: error: implicit declaration of function 'probe_kernel_address'

Guenter
