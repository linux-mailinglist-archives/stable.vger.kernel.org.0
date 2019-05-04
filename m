Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC4213C43
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 01:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfEDXcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 19:32:18 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35845 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbfEDXcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 19:32:17 -0400
Received: by mail-pg1-f193.google.com with SMTP id 85so4555998pgc.3;
        Sat, 04 May 2019 16:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rpRxZnP7D53Sg3cFIP0Iwdz+AT9YuGEbWk21Bu3Dtgs=;
        b=gtf0KGf0kuIyGfpmMDfNMlzSfz/sDV+iPiAyfa9bAMBlI5Ji4atFbQL7tjNdcBhhRh
         4QEFmkQqcC9KJpP7L+7JNyDfLo2C8O6wZXeWZoqgTDuMMakfACOGG9g5HJvCssc16SVd
         YVTLN1bi5dkcEia/TS1lI9eSVWM/08OcIETSw53wynjnT8BFwJXLzFku031pEovFU6uu
         xBCMRBjjjHo4xUPAxD1wsK5IRqx+24sxKZbp1ZXmSb6gCqLCP2SpiXM5Sqh/rjrThLxM
         znXYrhBM3/qN4r4C8SbIW+Nq8SPtkCU/f1Bdf02vAZXQxUNN4wAt9S84V96Tf1z9/PL0
         k9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rpRxZnP7D53Sg3cFIP0Iwdz+AT9YuGEbWk21Bu3Dtgs=;
        b=s00RFlvA++MvpFp7D9unXSqXpSQgWbuPIqzNdzQUKawOJUtpoIvx9yYDXrmANtYbyG
         WgbOWb/q07F83892sUhjz5U3HtH3PobrPCnXilVjeBzfWc6pA2/+6LXBj/+YiWy0+um3
         ltvIBCaYHHj4d1fn33AUWE/lNDXcWWtrvO3GBWIfK9KBq1FEn0qgcbG76pzR2ObqkdKl
         AgSh3L/Qkdn0Iahgg9yn1hiVFkRU2ai1ztSxriKjev8XltHqx86qAOkSGNwFEvugBPp6
         J1S+XC7Qq96M8uMXfTgPz6mA+UnD2u1SGRQeIxzlzGZ50wY7OaNf7UwaFYSF5HvjYABv
         L4kQ==
X-Gm-Message-State: APjAAAVKA6C6qY0omoUkT6YJqkPKngru2BqC2A989oK4Px4o0CNQy3vC
        SbKpJK12ETXQ/dIQlY0ev/dJSW/u
X-Google-Smtp-Source: APXvYqwwyMGuORbSnImgt+DPJJPYr1lnn/jD+rTHwteTNrWu+Lnb9dAWIfGIp+Kde/6vzI1juoEfyQ==
X-Received: by 2002:aa7:82cb:: with SMTP id f11mr23230899pfn.0.1557012736228;
        Sat, 04 May 2019 16:32:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f7sm16218700pga.56.2019.05.04.16.32.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 16:32:15 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/23] 4.19.40-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190504102451.512405835@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <5e7429dc-a294-40b5-0100-846d7d5dba71@roeck-us.net>
Date:   Sat, 4 May 2019 16:32:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504102451.512405835@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/4/19 3:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.40 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon 06 May 2019 10:24:19 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
