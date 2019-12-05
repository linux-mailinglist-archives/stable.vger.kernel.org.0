Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15108114261
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 15:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfLEOOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 09:14:11 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45246 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729109AbfLEOOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 09:14:11 -0500
Received: by mail-pl1-f193.google.com with SMTP id w7so1297100plz.12;
        Thu, 05 Dec 2019 06:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Wpk5gI6ipD97HICwqhI+xDCBoOnAJXFP/kI7MVo59ZI=;
        b=gKHYs8VJKxPZoWeogG6/ziD2BRqr8NI+/SzMB3HTwQFcBgK0giTm8IpfYNQgfsNbqI
         vnR8DzIdIQUhZodrBHVi8PGVhwKutgwdVBXuuY5E6gX9q1F0CtGer1cZEyCdgnauVVAp
         53UV0bMOJ7F1c2axwFqOeC+3QJROWVFvrlHLeYgu51crMCc/6IsFnksNq3WsdgA2Io9F
         ODCiFKQU7iO7gsQt603Mz3+spRRlJGJGXwJGWbfuHuXDTq2sVU+usWsT2jdaa5hJ4AVC
         hLNCu8VSW0ALbYc+Lj9MioTt3lYDbRnV0H5jkj7mDXFS8ZfZ8nsu9dTG030jE3FTBgSl
         a6EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wpk5gI6ipD97HICwqhI+xDCBoOnAJXFP/kI7MVo59ZI=;
        b=e82lWSlu8rmizv6s5dclqSQUkdrgkEJGoMwxVhniMQuU3oP33rbe3LraqOu7IOFZc9
         e6Zit3OA1e51Ed3oYzslqTR1yPN+RVDYa+6ulROWav+Wib2Ao8bm7uAiEwlHiTa/Jkj0
         bt/UnZ00mtJ/FZ/jp9oCNTC4HWXKOOI4k/SF6pZDNk5urJsw2xBF2CmgXswjhYh05aFa
         l7ksSUb0iGTvEUYkJTnCw9CSyFk2XSjwKrzpoKh0mGN+UIMzPBqV/8FEXkS5NmdNugSl
         rlmjvOS/y0gGGSGlb8b/ByDvBSC60710B1GFWerLtBd8O1SUIAReAP7sbYfoVXwYSnAY
         CDeQ==
X-Gm-Message-State: APjAAAW3hqQ1rBLBFDoAOSVgJONh0CDJuGnaEQNXrt/USXpOAKsPprzO
        Jc21o+G11N7HmIygSMzj8X+QCSLQ
X-Google-Smtp-Source: APXvYqwizVZCHHNL/UAWbSXvsc7DJEy7DAaLjZnOD3BhxGRWCgoUxet41g7TJHh6nefsVGmgdTq6+A==
X-Received: by 2002:a17:90a:8545:: with SMTP id a5mr9586023pjw.43.1575555250161;
        Thu, 05 Dec 2019 06:14:10 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d7sm13479247pfc.180.2019.12.05.06.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 06:14:09 -0800 (PST)
Subject: Re: [PATCH 4.14 000/209] 4.14.158-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191204175321.609072813@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <01657715-38a1-2f19-9f98-22b2fb4dafc8@roeck-us.net>
Date:   Thu, 5 Dec 2019 06:14:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/4/19 9:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.158 release.
> There are 209 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Dec 2019 17:50:10 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
