Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8E2151C64
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 15:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgBDOhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 09:37:41 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46995 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbgBDOhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 09:37:41 -0500
Received: by mail-pf1-f195.google.com with SMTP id k29so9546457pfp.13;
        Tue, 04 Feb 2020 06:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TWWJwj+Dmrmt9v9lizLX3wiTASy/X2FqssJzcPgkTKI=;
        b=cRSUE6Qc/R8SAiwcZAPO92X5aiAJUr1mJu/McPrsP9EiazIW3asLZ4vC55l5pliSTI
         FTWbUVn5N9L8ZuogwWyLp6I8fDgdZUT/kJc4IKO7y3fnDHyc9cupUUvtPk7OIUdmlKnN
         SUk3f0k/l7xkPmSjAw5wO+lEk03NXn2Z6vTNif/CtjZLmTQo88rlyLVFfXmGySdtVLc/
         hsXKE4Tz5kauTy9RFbRYLjuvdI5EUFXcYHCoapQeDKUWqswMqPBbllgvHvBi4y2cKXT/
         EYfcUmYajyJOCdQxoReWOZzUsMG/2hQDRC76qg05cA5LmRzJRmkuQKSc/YQVwKiSyjEB
         820w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TWWJwj+Dmrmt9v9lizLX3wiTASy/X2FqssJzcPgkTKI=;
        b=gjjpNauRq0Z9KwzELD8Tv9wWmTfcuDlLvg2bD6psxHbVdZ/9PhGtloTFIvYvurWopB
         G6NkSanyRlnoNeOYB2VpVxmhjOAMnGHTt4OyNvZejBV73OV4FJj5v+Jbd+AuygX7YSUc
         1W4hsXV3x0w72uHDW/f+sQIxCYXHp4LbYvGNiYWKFe50DN5WtDzoesI/+n2zyeMFbU9E
         INXO0b0PPz8exp5dXdF/8RzaDz33FYHMp3CM8FgpvhtSket7uMv2MDQn61y7LerEtjbX
         8MH28W9Z0PQS7F8scKJDszg5NUhl9iwJ3TQgN2z7BhMkvD59DabYnvHDxTjgB/FQyQW3
         cDhg==
X-Gm-Message-State: APjAAAVakYaELoRzpDIqTQY2Bak+BSlrfNLY4AI5mUmfHz9DJyklrVkC
        S3TLhVW5DpgsBjw+IgMpgaqkogcR
X-Google-Smtp-Source: APXvYqyirmfrcttwWUyyphpTjPm58EaXFhDPbCE7pmdI/WyEK9gFvX3t24ZPhbtqtSGvVkOJQXludw==
X-Received: by 2002:aa7:968c:: with SMTP id f12mr31176499pfk.235.1580827060521;
        Tue, 04 Feb 2020 06:37:40 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f1sm3764705pjq.31.2020.02.04.06.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 06:37:39 -0800 (PST)
Subject: Re: [PATCH 5.4 00/90] 5.4.18-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200203161917.612554987@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <9a5a92f2-6e28-a9ab-a851-8d7e56482df6@roeck-us.net>
Date:   Tue, 4 Feb 2020 06:37:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/20 8:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.18 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
> 

Building i386:allyesconfig ... failed
Building i386:allmodconfig ... failed
--------------
Error log:
In file included from arch/x86/kernel/pci-dma.c:2:
include/linux/dma-direct.h:29:20: error: conflicting types for 'dma_capable'
    29 | static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size,
       |                    ^~~~~~~~~~~
In file included from include/linux/dma-direct.h:12,
                  from arch/x86/kernel/pci-dma.c:2:
arch/x86/include/asm/dma-direct.h:5:6: note: previous declaration of 'dma_capable' was here
     5 | bool dma_capable(struct device *dev, dma_addr_t addr, size_t size);

---
Building riscv:{defconfig, allnoconfig, tinyconfig} ... failed

Error log:
arch/riscv/lib/tishift.S: Assembler messages:
arch/riscv/lib/tishift.S:9: Error: unrecognized opcode `sym_func_start(__lshrti3)'
[ many of those ]
