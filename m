Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D726CE26C
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 14:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbfJGM4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 08:56:08 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45094 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbfJGMx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 08:53:59 -0400
Received: by mail-pf1-f196.google.com with SMTP id y72so8574802pfb.12;
        Mon, 07 Oct 2019 05:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fouAObQxCvOJMoqSDdHQwZliyL0KnDXKIglF6Y32O0I=;
        b=FKtkWjX+LnmpMt84boARKT7jv5/0rRPmibx49uZ9K96nq20LROhb6CbRVqmiSyV1et
         cpXR68OqfcjOzn6+0H6PS8eWkGyhpRbjBOfYlXG8MXE6lqjI0Z22Hm3qj0OGA9jPXfP8
         kwi0dOO/t7UfrWlCoZ/FZ8V+AQRuvh+f9ACeCGkjtiBL1WsqBuikmTfyKO1pTBAANsbk
         D9+xlNE61itYdzHvGnrrJWUD322gVnWoKyjbR6Az/4a9MXMOlNYL0C7xe0Bnv7dim/X2
         So3RYNOHbyS8XqB1V2+SP28SaHekLTd9Mr3Phn+BOVtvlj3Pf+mgNMVqOnFaiS/GG74P
         +9Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fouAObQxCvOJMoqSDdHQwZliyL0KnDXKIglF6Y32O0I=;
        b=CdCbJzoH90eLP6B2Sqc4uS/WP2/SAKLBXC+i1aDseWqZRP7aqeieFkHGANRmq+91qK
         M64PP7T5/itksI7rvB5LVi5Lc0lBa5WnJhddtdbtN/6/xUmeMP2wUzpdMOAAT0z9o/+U
         H8d5TFzmr1eHb+4GPn8uMXzIwl36P4XH3zpSbsP8vcTgoVN53wDF2hgSRxgogXRKF9b/
         vZgLgvqhCGmz8WvJRjlPbGb3AzWkWGX8gMkCLSI7FjClQwEtelrcM4SckR4SbxFRqgC0
         Ei5cbXJ52ewp2Y+QI8rBlHXyYTsz1DXbbC7SKhh8v1uti/4Qs6qMyE0/6Sq8viVhSy69
         MrcA==
X-Gm-Message-State: APjAAAVe4VBCXedZs0smVEb7uqw6SXgG+3C2E+VhrNFPBLsOxl+MNUOU
        X0yiSt+QElKQip90/hSNQtW6DYWB
X-Google-Smtp-Source: APXvYqzg6m5901h3+ktXJ47rhgGx3ovB6IcsG0WX+yTofleHA6dk07dmAXfsftdZM1WOY9UkBwYSmQ==
X-Received: by 2002:a63:8743:: with SMTP id i64mr2141488pge.258.1570452837990;
        Mon, 07 Oct 2019 05:53:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p66sm16929493pfg.127.2019.10.07.05.53.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 05:53:56 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/36] 4.4.196-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191006171038.266461022@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <d3e1e6ae-8ca4-a43b-d30d-9a9a9a7e5752@roeck-us.net>
Date:   Mon, 7 Oct 2019 05:53:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006171038.266461022@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/6/19 10:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.196 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 

powerpc:defconfig fails to build.

arch/powerpc/kernel/eeh_driver.c: In function ‘eeh_handle_normal_event’:
arch/powerpc/kernel/eeh_driver.c:678:2: error: implicit declaration of function ‘eeh_for_each_pe’; did you mean ‘bus_for_each_dev’?

It has a point:

... HEAD is now at 13cac61d31df Linux 4.4.196-rc1
$ git grep eeh_for_each_pe
arch/powerpc/kernel/eeh_driver.c:       eeh_for_each_pe(pe, tmp_pe)
arch/powerpc/kernel/eeh_driver.c:                               eeh_for_each_pe(pe, tmp_pe)

Caused by commit 3fb431be8de3a ("powerpc/eeh: Clear stale EEH_DEV_NO_HANDLER flag").
Full report will follow later.

Guenter
