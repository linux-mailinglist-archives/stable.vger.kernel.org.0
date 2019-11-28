Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D248210CEA5
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 19:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfK1Sr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 13:47:59 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41486 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfK1Sr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 13:47:58 -0500
Received: by mail-ot1-f67.google.com with SMTP id r27so8371306otc.8;
        Thu, 28 Nov 2019 10:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SbqDtyGUayCHn8YA1qIYy//Vs47v2ekEoPz9wEIqoIU=;
        b=QdExebKLEyBAlSiWEff8xM3wFGzM3WreNyZYUwaXBrCvISUmDDUFy5//HOgdCFYxz9
         RO/uG+Xp4XS9ViAn9lhEal6mun8qnCJDZ6Nw1yH7YG0TwIQ7JQJcUHzOcGbc1LvOTp+K
         7AJLsYvlu9WeuBcziISUTOi9LqHjGkaOofZ5yRnr+BW3U67O+jQmVDiGMpKRxU2nuLgr
         6DTbm61r9MMAcWQBiKdEnTpaLSBvcoeTrfFidxiBBVvgCyNlC36Bw45OCMu5QERvOMQU
         f1bZK5HimjqZWzkNirFNhjs/6wcAuA5SW5rcAa9y7lYBLq5K1FvcMSVmVpSbTi8rXoUf
         9zBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SbqDtyGUayCHn8YA1qIYy//Vs47v2ekEoPz9wEIqoIU=;
        b=LRg8cgiXDQmUb2x/T8U9lNSpLp+yfjACpkxScwy6MAGC75BdqDwkrvlUlTs25ygZmd
         3pOatNfpnGn+hLBafn0ESBQeMgKzMDERiDrPJJ9GNmOhCjquRC6Tr/DQ65GEF+WdTheA
         ko1fwsVvJrzrZSZryi6BB2Y9b9M1BjnCrTSxqlF1BZqP8yLWH0MyIl6PhcnbtVjvCnK2
         yaZhLgHfuFQ486J/j9QUNRNS+X6ws4/B8SyW5nU82YOmC5NncYMCgd6H/YwKTGVL723i
         zcoDj5TEbFvXhEITK7i2en0T2nYMD7R6a7aWm/XmHTdDa8i6RYjqqim/i07+X7eumpbt
         cHJg==
X-Gm-Message-State: APjAAAU3zRjqt2cTAQ/WNcC6ekJ/xYzdnHDSmOOmEWS05uuLKDYR0x0e
        N45Ty+WoSGf6kNr+jIcoT7Uh+14z
X-Google-Smtp-Source: APXvYqzs+J0u1bXIFWyjqtDhfL9jnr0r4g2IqYV06fMSJ7zuo89sifizcjxoMfbseB/qZlhA0+6zvw==
X-Received: by 2002:a05:6830:2109:: with SMTP id i9mr8695007otc.334.1574966877546;
        Thu, 28 Nov 2019 10:47:57 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d132sm6400804oif.2.2019.11.28.10.47.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Nov 2019 10:47:56 -0800 (PST)
Subject: Re: [PATCH 5.4 00/66] 5.4.1-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191127202632.536277063@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <ee4a83ba-e746-42f9-34c1-18caf2e369c8@roeck-us.net>
Date:   Thu, 28 Nov 2019 10:47:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/19 12:31 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.1 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 157 fail: 1
Failed builds:
	mips:allmodconfig
Qemu test results:
	total: 394 pass: 394 fail: 0

The mips build failure is well known and inherited from mainline.

Guenter
