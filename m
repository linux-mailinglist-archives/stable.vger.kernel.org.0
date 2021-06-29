Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFE23B73F2
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 16:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhF2OMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 10:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbhF2OMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 10:12:16 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C903C061760;
        Tue, 29 Jun 2021 07:09:48 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id h9so26414883oih.4;
        Tue, 29 Jun 2021 07:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/pfAfSG1WAT03M9in9IB99n5vlozDcqHU/A8hrRJslE=;
        b=Sks2icFMsPkjTv3NhFgOCzYfEmtriMo91Ye4Ja/mz4bmpaAwFyZ4iXJfIDNPDrc+FT
         wu8cOQO6MEeTtGQoiWv7d8Hph1xjhd4bruygzQ5dhKfwNQUrhWTcVM8aJbxOWgojLqkZ
         ycMSNXBAc86unVUAVAZXHGrZVcTpkvHfVkaJqAUH72fVjdnj72P/EIgAlgvvKQ2o1Q4d
         EcE+62R2aE5TrH9iX9A04vfYZAfolhb+XUr5KJKjw/MwKJE5HBZwRSJv/w2AOdAAUb2Y
         XmV1zdsCV+kIhHW6iLUp0KdSv2QzHNkKYLV8dDdGTko61yVcW8019E1GIIxpha4b4nO3
         yauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/pfAfSG1WAT03M9in9IB99n5vlozDcqHU/A8hrRJslE=;
        b=NSPrr0H82S9zYibTPrstGn4GAmsWBjf+OGSJXvv7KXIxP/Oo2l1teocpKMIMLVDg84
         hWpLEgRk6p3nqve5jqQHu+PLhAMpRR/bRDkd9ENoRe1OvYUr6/hfNxR0qDaJS8Obpoo2
         biTC0HCRvPN+8i2h7p/TJaCWB9GbdyjbDnO8cDctx9InpUgGa1114v1g2mc/x5S3T+N2
         35DerTJaBDJNdrBK+v5TBRPa9AvrmAskR4ayaD09iLRAfHhp1etaxastbOQGhSM9Ogth
         7S+7vPsLpLfto1MMKS/FAi3XdhgDvlM1OWjjH7fLUoD8Lt2hctyfii18i6vwEhSdfMiB
         3jBA==
X-Gm-Message-State: AOAM531HIIltysyMjvqHRrBICCsIJVfowaRAEA/MbVYic6vIgnkMPMM/
        orbdTcZyGRQh15Pl8btx2KE=
X-Google-Smtp-Source: ABdhPJyUORqMbHID+b4PNh9oIJP1FzeF0v52dkRjuEliNUFe/yxwnCdv8FjVG04ECwgcmz2ju+lN6A==
X-Received: by 2002:aca:afd2:: with SMTP id y201mr7655978oie.54.1624975787816;
        Tue, 29 Jun 2021 07:09:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x3sm497635oie.24.2021.06.29.07.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 07:09:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 4.4 00/57] 4.4.274-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
References: <20210628144256.34524-1-sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <f396d8d7-e78a-7a8a-f509-e546fe1d2bfd@roeck-us.net>
Date:   Tue, 29 Jun 2021 07:09:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/28/21 7:41 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.4.274 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:42:54 PM UTC.
> Anything received after that time might be too late.
> 

Build reference: v4.4.273-57-g5429409d4e80
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
    20 |  struct user_regs_arcv2 v2abi;

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

