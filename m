Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39EEFD33D1
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 00:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfJJWS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 18:18:56 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34757 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfJJWS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 18:18:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id b128so4814358pfa.1;
        Thu, 10 Oct 2019 15:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SC7P8Kd2E0T0kGY1Rk10AZCGVOZcO6CptV8A77XWNrw=;
        b=h2AeW59m0gISGQDA5lynrIwBUOjJEDhgaDBZKeJd5uX/bqPq12EIxW10MOnGyL/Hd7
         iB3ZJGKxQs8d/aZY+3mv+fzCszvq2YriQAGA629aA0IkUEkwxp2T+ydvTIygdP08pKqO
         JyNLSFRiOsF6Krr1m3Kx9MSRrDJy1bLpbW+Y1+8OPCheyiYbaw+7iwbvSkmAnK9x5cbc
         iuHNxGVCjDgTYbK1YgnT4Y5+pauvJaii18DWV3FxSkdLfAnRFuaBW+V8TAf1qR0Z43Nq
         GWepZ3B1IqKUKlBaFFvd+929uXUB+kF6CeFh8VNU5P+yY0A0Kli3jjCae0hkRptVID7r
         Etug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SC7P8Kd2E0T0kGY1Rk10AZCGVOZcO6CptV8A77XWNrw=;
        b=YWgdsIpFnq80IvNpt16HqXTY0iGDvSE7ohngxLpwWfiFPXNvBDdOSHiuA+C3egAEWg
         etEfL0tjVSicBNqgkfErkQlLh5Xu6csfhLbYdGm8OvAde+s7ZJDraiX1UocMJB44jaYW
         Z/WISB+LXSyHGc4aV7F8F7Hl7OBtN6gvYGQt5MKyS4yLVOyZbgNzGEN+lsUu73hrlb4D
         9K6k5zB8P3esPpM4/UkvQJvD9RI1y58XU50ignYqaJkxaTJ0MszjAoGkzIhzg33Bcrx5
         Cj05tTLUqfhibJWCot1BMtwt+bwvzMSzrsNs008UafH2MhNBi9P0VrxX6o/ku0VZZkV3
         0Afg==
X-Gm-Message-State: APjAAAVingdAwczSJ6XjJHUzSTSKWu4JH24QRNqKDFGekLVap/6SLgnT
        tgiqw0HLRfV9f+TIYTqRWKncI/An
X-Google-Smtp-Source: APXvYqwLhHEghrkpxMQd5SU4O37IRYrnJByYV5TlT1TyWIOg1cGXCoRVj70z5ChVC0BWNpm9+0FjkA==
X-Received: by 2002:a63:5946:: with SMTP id j6mr13362560pgm.214.1570745934555;
        Thu, 10 Oct 2019 15:18:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q20sm8482531pfl.79.2019.10.10.15.18.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 15:18:53 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/61] 4.14.149-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191010083449.500442342@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <a48ae8a0-6193-3f92-cbbe-f667532d2e86@roeck-us.net>
Date:   Thu, 10 Oct 2019 15:18:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/19 1:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.149 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> Anything received after that time might be too late.
> 

Internet is back, so here we are:

Build results:
	total: 172 pass: 161 fail: 11
Failed builds:
	mips:defconfig
	mips:allmodconfig
	mips:bcm47xx_defconfig
	mips:bcm63xx_defconfig
	mips:nlm_xlp_defconfig
	mips:ath79_defconfig
	mips:ar7_defconfig
	mips:e55_defconfig
	mips:cavium_octeon_defconfig
	mips:malta_defconfig
	mips:rt305x_defconfig
Qemu test results:
	total: 372 pass: 312 fail: 60
Failed tests:
	<all mips/mipsel/mips64/mipsel64>

Guenter
