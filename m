Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFC9F6014
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 16:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfKIPky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 10:40:54 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41503 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfKIPkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Nov 2019 10:40:53 -0500
Received: by mail-pf1-f193.google.com with SMTP id p26so7175139pfq.8;
        Sat, 09 Nov 2019 07:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IFhA1nu/vBbbto/vLXY1r0AxdcGo5JveHSI06hZV8Hw=;
        b=TZ4cyCac7Mm6cLtDGm/+syUH+1/XWAqHwLtowrs4w8Tm6m0I3Ii833B02aQPj5VNAN
         SOSxoNODIuxMsj5kblscGo/dltmtBp6IZNj+kHnEo4v78NlRVsZm+dtOecXXNOobwAy4
         qbP/EV8FzwrhamM7612bdqPdSLIdvfifqJMX4nUQ+6FrN8zBN83YE9fg7DJebTuth5DS
         uzWusYqzCfT3/qA+sZCNhk47kSCaeT8QIxWaHsvC5iR9DhACov1b0JiWpsNJLsBhBRhO
         LBI8gw+RSP2yrgiHWzJ5h9J3FW3x/lcUquqrQe8/JbuX7fhH57MZCNDGptDO9kZI5k3l
         AL2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IFhA1nu/vBbbto/vLXY1r0AxdcGo5JveHSI06hZV8Hw=;
        b=fIm/TWmj/2XwixjwoD3VCCXEg1PlI+EqwKGWe9ZsRb5AC47bdzSzI+UCyzBs13z9JE
         Dr70y2DzrVcnROkahVomsOQdIHRcc8GvWKgbrjarWV+1L1AHRQ66FwPpJX+bhb6R8pVv
         gcSH4t4OsVQrkWgjnUphunDra/PcBir8BjoHhKwZpMsB4KDOtHZIfLC1N57A4XWyHAs5
         ThdHpI0DCvDoBOLdIktyi89bTwZbnZD2LlndKnS+Dmj4U5knKAiYw2ZGThp3SI6RkONU
         +MOdbPazJsfnBQxw5f4BpwRZm0diKgSlmSyQydWOpLmuv/+Acx+98IhGHdoDfYovE6rf
         eSYg==
X-Gm-Message-State: APjAAAUUOOtImXV5UW0bch5puDqzX61QyXBmoWxq4k2Q6v+Ycbl6azBr
        thsn7thGqQ3lypgqUQets7S66MEd
X-Google-Smtp-Source: APXvYqyctAR2B69qt51lUY5qur+yRu3ssGajAkZxxHT7OYCpFYBTtThi1frvXynd8fQS7TDJklM6Zg==
X-Received: by 2002:aa7:9348:: with SMTP id 8mr19232466pfn.135.1573314053065;
        Sat, 09 Nov 2019 07:40:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c13sm9945222pfo.5.2019.11.09.07.40.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 07:40:52 -0800 (PST)
Subject: Re: [PATCH 4.19 00/79] 4.19.83-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191108174745.495640141@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <8df7d32b-4c03-f142-c270-5e52afd3d095@roeck-us.net>
Date:   Sat, 9 Nov 2019 07:40:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/8/19 10:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.83 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
