Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F424F2DB
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 02:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFVApb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 20:45:31 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33597 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfFVApb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 20:45:31 -0400
Received: by mail-pf1-f194.google.com with SMTP id x15so4415295pfq.0;
        Fri, 21 Jun 2019 17:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=46ep0RjgJEXDMDhYTSxS5y3Y1/zh4lWWOVQt5e4Qcyw=;
        b=m0P0C0cEYDvDA5qSEyRoLXfwZXSBpT39iSvNyAf23+NcZwB5vHb9ky9AExyuCInjKU
         q/cXGp5bG4D4PUUrLwAm5jXxWqdnKkoMI/PLXvW/8JVRyaK209RU8AON9yUeavApj1zx
         QORzCZW1SJeDF3U3SpPCXK+tKLJpDFQUDb2C7vN3cqjoVgWhGH5VZtUevtVWDNb60qeb
         lQLqU7F2kC5wKgkk7EMlXZbBqMuVM5h1Mr0ctpfiMDUWq4EbBI+AGt5PR0NIxrLS4weA
         URtevZ6QT+UpmmaNNnRooxxEKvzjOeJ2RPQc1QvUpIayBjhKueaKNyENz33DXN9Eynp4
         u4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=46ep0RjgJEXDMDhYTSxS5y3Y1/zh4lWWOVQt5e4Qcyw=;
        b=Q/k8Dk+1FjWJPGxFCu+gzw3lyL06ofMqbZ2DvXCTLiR7JMJCn6884UajPnrVINYR9Z
         KnXB04fKylCcWAvZCOEiNJB/gToKCUEVXdsfKHBs8xxJTDD0G7q6EIaqOfO9da7MRbzO
         RaB2WCV1n5Pgdb1HPjHuZxmJW/CSMIdZbbsgpXibPnUgZj81e89GZaN/Uc8EIEPv4KSH
         wHkjdAuirmc4Y54gpP2bW2AliMlScw3qV1UJVoh4/j5809CxZOfGS4VvwDltc6wzy/rB
         qqHCQ2omk47Xq3pjyZ9VrxNsk7hRsEMxLvtvS39K8C1bT1s09qeWISfDX3kP5BJKngKN
         9KfA==
X-Gm-Message-State: APjAAAWgp4vaeBWrYhsqjKRT+54orHzQutu4aL94TJ54UphhXcLc3DNt
        davz9WoxKCY5OFzmgV5nVHH9/BOn
X-Google-Smtp-Source: APXvYqxgnxs98N/9NkLFXlYU/6Gna4vPa2PFckXgvYMKpwhetNs6Ogk+4yiZsvkLKnWaSZL0T0pRgg==
X-Received: by 2002:a63:b1b:: with SMTP id 27mr20734515pgl.244.1561164330218;
        Fri, 21 Jun 2019 17:45:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w4sm3950971pfw.97.2019.06.21.17.45.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:45:29 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/61] 4.19.54-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190620174336.357373754@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <79140422-31ae-739d-91c0-b8fd0e6f9534@roeck-us.net>
Date:   Fri, 21 Jun 2019 17:45:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/20/19 10:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.54 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
