Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F166E57D1
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 03:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfJZBfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 21:35:22 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34419 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfJZBfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 21:35:22 -0400
Received: by mail-pg1-f193.google.com with SMTP id k20so2763769pgi.1;
        Fri, 25 Oct 2019 18:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZtxFLMLP/C9P21LCd6VMII2uaPhDc4AhUSfusTIPiMM=;
        b=GdBVFIQHTbiGfRKvEXabluuqKIoZV9d/T9ngJfSsxJkYGfSD9GMytjmcgQUavBtNoD
         nbjvvHUuxUpHTIGaE/0dCSltiiYAlaVSSNMgxEzlzjY1N6leEYKJZ5sX0EuABog0B41Y
         m5uZkeBlshWUAWj0QXgwlII3G65un27P10xvdN21WnGMAz2iWX72B2HVVLu50Y0Kavl/
         2vXIBpY//gij1SySvrOUySiP9kSYtQ6u/Q7UjemgDnXXQoBBl6R0Ipsb9OwG9e74kNqS
         epaRZG9d/gEBoFHcurMyKBfffY8XsF4tuhDQu7xmGoUEzOhdwfBLy91pidxz7lrk77WM
         qHzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZtxFLMLP/C9P21LCd6VMII2uaPhDc4AhUSfusTIPiMM=;
        b=gzGe1/gnj7rY0JTTRISAXXBPfxMghkoWP7HqEy5zhdK6NIrl+TNWmIoyEf0SoLmeBO
         NLidWiNjy+8tAHdxWHhXUa96lBFY2pTb3qHdR5ARBqpWcoGZ6oFvhPJ6AT0x5iTaJnd/
         IPILp7xgOsLj9UaZLEj3LmsW7AqpamHOJJrrZMSFfwtTEj2/LVdbig0ccwBMtB2Gtj1I
         mCSl4gDd9l166EEa8kG3PkuQRW1H3Q8QHqJdSlBiaqnbq3wcm+qTtUQS11NWtVxWR6xo
         nWqjUaSmH51+2x7Lih7XLtsxnurUYrWIdu7wIbReP5l3VQ6K8Vgy7ayJCe5fJe3L8/Gp
         jPAg==
X-Gm-Message-State: APjAAAWoboemCxuwzt8X119bdkugR4zP39sj2cmaadxO/0OlrWCXOZIm
        04/+0ptFIyT9M+vIX//1xAI0QwUi
X-Google-Smtp-Source: APXvYqwk5CEukxoE1dKTusgW5Z77I/EeXJOoZiu9fgen9Cb2OIIkFG9/HSLZSrj1qjYUag8ukKydrw==
X-Received: by 2002:a63:9543:: with SMTP id t3mr7949919pgn.350.1572053721592;
        Fri, 25 Oct 2019 18:35:21 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c125sm3991092pfa.107.2019.10.25.18.35.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 18:35:20 -0700 (PDT)
Subject: Re: [PATCH 3.16 00/47] 3.16.76-rc1 review
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
References: <lsq.1572026581.992411028@decadent.org.uk>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <c66efe1b-6a90-aedb-f854-615ec16c85f7@roeck-us.net>
Date:   Fri, 25 Oct 2019 18:35:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/19 11:03 AM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.76 release.
> There are 47 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue Oct 29 18:00:00 UTC 2019.
> Anything received after that time might be too late.
> 

Build results:
	total: 136 pass: 136 fail: 0
Qemu test results:
	total: 229 pass: 229 fail: 0

Guenter
