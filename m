Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1783C3B73F9
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 16:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhF2ONn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 10:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbhF2ONm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 10:13:42 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E42C061760;
        Tue, 29 Jun 2021 07:11:14 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so22780353otl.3;
        Tue, 29 Jun 2021 07:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SDRI5SAWEYbyZFbcLOlnGR/Otk9unY8wQ0WSUowIuSE=;
        b=liLtCV0Twjw/EqTjPwmXLyLVnyvZpA8iNoMkqf94/+lUTxSTXH9Hto7oMaR9xj+HJ3
         LmuMr+AgdSoedIcZbPTT4OiJubHAaihS74dOF3H9HWjl0KMIu+ICnmsyxnZKZNkpVJGb
         WMmjV8UE9B+++6T9jbQem4bN5nze/+3oaG1xppa2neMcvV7dLTFIts9Rmb2NMWvmosT5
         TlvhmZZZG1b2HKlT6hiqTDy7B2DcK/sO2rDH9cNgCaUwp5IHERA3DOiGFa4KCbGlHIfb
         nSOcEkcxl6Hp0EJMcKv7m+SZ4IrqDlq0Nki9kT2a8KBBpaij2rDeDqEPyRrM66Hkr6Y8
         jj7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SDRI5SAWEYbyZFbcLOlnGR/Otk9unY8wQ0WSUowIuSE=;
        b=fibkpBQsSJRMj5OpIt7taOBcb7pXkRJYxW150iG6syJpK7RArqcXW8mLrTYljvblfD
         BgTgeO8238qtftPsrZX264VfgTitB42HoDfEOXDlje//zxxVFTXUzsqyrWp2w50NV5E6
         H5IpH4ySp0AA+m9Buj9pnGxsIaPUdXAXhNb0slvHtesSGT5rVuNGGAnWR94fxWdiu036
         Sdzfp8MRkdc1Fe2WgsldGz9koehp55LoorIF2NcaVLiPalcPFzhZ/6bx6xAZODTwakzF
         iHdd+I5yFsd5xGZP4l4V43mgxTiLPBpJZMxWqh6EP0yV0x5oty34GGjEd4KBVEJ+Qu10
         3R7Q==
X-Gm-Message-State: AOAM533eXdaZBML5qBDl9r9JiDVCjr27MfKLBq0ndn3gKc+nfvCO+8L4
        2gWPhYDwl0gYaaYPaLFkPlg=
X-Google-Smtp-Source: ABdhPJxta3WThBijkDaUvKfG6kmxy821BFidaj8ylOKOB3fyyCoSLvdixoM1dt+WQV4JlKHsDsdv7A==
X-Received: by 2002:a9d:80a:: with SMTP id 10mr4640988oty.192.1624975873315;
        Tue, 29 Jun 2021 07:11:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y20sm2365720ots.23.2021.06.29.07.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 07:11:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 4.9 00/71] 4.9.274-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
References: <20210628144003.34260-1-sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <ecff1d13-9535-f12b-4efc-e214d7bd51e7@roeck-us.net>
Date:   Tue, 29 Jun 2021 07:11:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/28/21 7:38 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.9.274 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:39:51 PM UTC.
> Anything received after that time might be too late.
> 

Build reference: v4.9.273-71-ga12e33370009
gcc version: arc-elf-gcc (GCC) 10.3.0


Building arc:tb10x_defconfig ... failed
--------------
Error log:
In file included from include/asm-generic/signal.h:10,
                  from arch/arc/include/uapi/asm/signal.h:25,
                  from include/uapi/linux/signal.h:4,
                  from include/linux/signal.h:6,
                  from include/linux/sched.h:37,
                  from arch/arc/kernel/asm-offsets.c:9:
arch/arc/include/uapi/asm/sigcontext.h:20:25: error: field 'v2abi' has incomplete type

---

Building arcv2:defconfig ... failed
--------------
Error log:
In file included from include/asm-generic/signal.h:10,
                  from arch/arc/include/uapi/asm/signal.h:25,
                  from include/uapi/linux/signal.h:4,
                  from include/linux/signal.h:6,
                  from include/linux/sched.h:37,
                  from arch/arc/kernel/asm-offsets.c:9:
arch/arc/include/uapi/asm/sigcontext.h:20:25: error: field 'v2abi' has incomplete type

Guenter
