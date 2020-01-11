Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF1A1381A8
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 15:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgAKOvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 09:51:16 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34691 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbgAKOvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 09:51:16 -0500
Received: by mail-pg1-f196.google.com with SMTP id r11so2459442pgf.1;
        Sat, 11 Jan 2020 06:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LnQUEfa2jGbx8TF5+eOJ4Mm/zjQrHPxQjeN7eUWOwj8=;
        b=rzRtBMQATOCSs4OuZpO7U2XB2HOmjHdyIqtr4WGn0Hf6yH7M80IcDt8GbuWaJS6+fx
         O75YHN5pgX/DFztCk3nC7kqFHnTA8XsOlE8ehW24cI6sHIeGq6cq1X6B6Le5vezQ6tQ4
         h80AuKq7X82FatJiAsCBOavdv7bwO6GgGSSQhhMJbeI1KBxKu3TSs34Pdsmcj+buJwTO
         tu7REh+35YLD7m16GJucM5AqLEdAK3tCU2utz5ENJz85ePcEuMyU0sTiPZtFgIagmvb7
         gOUaFaoiQ1HWzIeeY/eFn5KBx6MEyVH8b8wGj/SlVcOw+YedCgbySv5g7dszievVgGoZ
         geEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LnQUEfa2jGbx8TF5+eOJ4Mm/zjQrHPxQjeN7eUWOwj8=;
        b=jQmwFDIqfW+3znT3WZVKwuyXf62EfERMUV1slGl5sCQIwdpkIbVkcb2/69yfJ2YNyb
         yNeIO7/i7DQfIFzejK/gAhHIi+rFv4+7YDEdjFohBJrqQXiSiBgio/lLX10q82PjZcH2
         3pf/oZtI4M2eQsWiAClaNZyTVwmE20DUAyafcvG1moQqdiFCb/0V/dm98F/eLuA346CH
         y/idvREUaWCl26ZfNk0Wtz+9RvVB8B7mOJ06gjU3zkACHK3IoGofy8K/Lbwk8M4CPJON
         6FwFNMaTb6iVsbHxhgbx5P+5CKYIp2JHjR/sxKMaPUj3h+6SxdLeKIGoZ09+JCcAozZV
         PYnQ==
X-Gm-Message-State: APjAAAU9KX5FeYDtDkibQurDhvg6Ocs2q88PUzyJkEIuuAmqq352X7oz
        anDgk6JVLZh2nSV4spgDzlO+OYA7
X-Google-Smtp-Source: APXvYqwxq/d2th87/HYHPTMmxilIwCoGn4H5j6RBUMp5yOhPr2zPs9g0X2qsoIGyXqSgXUgU3LOHfw==
X-Received: by 2002:aa7:9e82:: with SMTP id p2mr10800744pfq.54.1578754275181;
        Sat, 11 Jan 2020 06:51:15 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r6sm7173659pfh.91.2020.01.11.06.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 06:51:14 -0800 (PST)
Subject: Re: [PATCH 4.4 00/59] 4.4.209-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200111094835.417654274@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <b89603df-13c9-2825-bcca-3a82b3256525@roeck-us.net>
Date:   Sat, 11 Jan 2020 06:51:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/20 1:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.209 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 326 pass: 326 fail: 0

Guenter
