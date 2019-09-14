Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A199B2B8B
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 16:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389213AbfINOIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 10:08:32 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37995 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388939AbfINOIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Sep 2019 10:08:31 -0400
Received: by mail-pl1-f193.google.com with SMTP id w10so3446608plq.5;
        Sat, 14 Sep 2019 07:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QBU5Nl5WFiKhJofStmO86HCK2Zq0bIm/R/ZHUK5ridE=;
        b=UC8suHhAXSzGVuGFujdNHEBQwnt1vtf5vabNpGHQw5Ric+ekFiszGEHFIszjMOjWqG
         CuBkxA8SvB8msJQ1kFTYhbjTJcPWu6i7qpQFaHwOGHe7UmobroQ9/1zwypsBCbg9w4+Q
         20KL9rDeyFHbJB/fBbbyOfnR4WT4wjH6qvRH9Gm8+IPjxM/7kKI6XfDvpDcP7EpG/0IK
         cGZ2gre3tqHTi3e8rEynkZocmUxclxzoGmnrb8r+ujUAxhz8Bmkrdm9hPVnWfJD2ibk4
         8Thj24tDUtePyWy3CEDRAPRd66SElYn20X1Cv3hIdeVSnmMmRNt6e6fSQxLd32W7Q8oi
         ffhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QBU5Nl5WFiKhJofStmO86HCK2Zq0bIm/R/ZHUK5ridE=;
        b=oJ4qtpJxmDbOE0vpUb5RZ2W1IenZngQBKYMTvzD685stOXCGEGfrvBu/I0WA1FCEVU
         qxrK2KGqIXH24q87o0UzHozT5P3yEM9m7/u4G1eoJch2UG8lXQ6xhNv4koOVVNHl9pF3
         YejsJLPxYnGSHTXyUc7LNJHiOk7ub4EOXXEEb85oOWvA5GjHhRu3S85gKamMzoSpVyHJ
         3C1szWqxXvxIhTmISHcAwldb2wFmBZu260kVoLOy1I/Diq5DG4SX4IHJ1iC4HS8lgEfq
         31fPY/JfEJeG6+bCHxvRk3ksNLejBDDd/xNGq65FtLjpayWqf49fgd6RMiTRK6uvXOm5
         mcpQ==
X-Gm-Message-State: APjAAAVqnegDuJsP5fF2avz4OSZnnY8lfGPUQ/YmgDrESyavBHiG0XLc
        5h7C0z4t1UiVqgg/Hbrl5Ca1EEL+
X-Google-Smtp-Source: APXvYqwKN94kLBT02tWFBuHKVhpuxy9MsmBk+fTStiW2itgR5jjb3iUXg2nZIdnJuQ8lkdQzMAdtlQ==
X-Received: by 2002:a17:902:a710:: with SMTP id w16mr44455130plq.327.1568470109465;
        Sat, 14 Sep 2019 07:08:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z29sm49833559pff.23.2019.09.14.07.08.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Sep 2019 07:08:28 -0700 (PDT)
Subject: Re: [PATCH 5.2 00/37] 5.2.15-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190913130510.727515099@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <137b38c7-3792-6601-c6f5-f85a2ade1bd7@roeck-us.net>
Date:   Sat, 14 Sep 2019 07:08:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/13/19 6:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.15 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 155 fail: 4
Failed builds:
	arm:allmodconfig
	i386:allyesconfig
	i386:allmodconfig
	mips:allmodconfig
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
