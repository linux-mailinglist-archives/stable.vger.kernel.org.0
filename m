Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A39EA67C37
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 00:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbfGMWES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 18:04:18 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35056 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbfGMWES (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 18:04:18 -0400
Received: by mail-pl1-f195.google.com with SMTP id w24so6457362plp.2;
        Sat, 13 Jul 2019 15:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lsS5tiG93wGI+0e8VJOyMV/s9lHUWHjldGOdrNdobtQ=;
        b=Gig1V5Yj/VGdrUlvIZP5v7Kb8ncm7ATqrLFjGM3f2JlQfLCgmIf65l6CdjuARk3AGH
         4ORuZ/TgAOIZZ8RzaR4f+0XWnqesCwILQYQxzbzi0ElHVFZhfo6zCZsvGxJ6s+xqjZWE
         X8RYIQ4juOe43+7AqT7jLd33SuQruffxkJ9RNvB4gNEuPViEGZnn5in65wfHNX3CjotO
         T13/Yym0uJiaw3ITO8HL5pc1GTFcTvAbzPnYSKQyyAw+XzxnJ77dDvXai51cVNZnC+mG
         EK1DRh1MwgsZFjFXz1h3SiSM9OzMrni5Dxo5Iudh45To0FNRE4fdmj/luluWiYKwH8F+
         gWVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lsS5tiG93wGI+0e8VJOyMV/s9lHUWHjldGOdrNdobtQ=;
        b=lUs4onFHbH8iC5K8cgN+Axuo/Ys0Gx0O8uYEYY4TUXgMGvHw92uPwG6D0H6HRtDt1V
         zH4yzbxh44PRkf0LmZ619eqSS/AntdWVd7WcWSfxUu2ldN+ewRx0bHaRKQCfbRHVy42f
         za8yMSgxeju8WN/Rp1v+NFMEK1vINPjMSNDd/9E6HKB4CfRI/Kxm9fZmPRlcLY1Rcolm
         iGpAg2PTGRq8RN5TG6c988X9kBfro9Sc54wjfY31bRV5iW40Jl1Nw9mQZQEywwwqD71J
         v7bftkhG3ZqzCPCbXDjd5KAzQ6b+2yHoXjojbA6H3tCUpT9o8eCHmp3vRLwyffnMd9A3
         0UOQ==
X-Gm-Message-State: APjAAAW/Ch4VmT/T6pRzbZpup9JrVJyjsUahOgdQNU19SMRpgW78hHfL
        C0cnMGRkWGX8EBKaFq8QqP4uBbDh
X-Google-Smtp-Source: APXvYqxVLaUzF+Q5hlbmefjFfmjjSIh87tjNs85+IeSE8e5QUj1KLV8JGeKMTEeu45lalGg3uyNnqQ==
X-Received: by 2002:a17:902:e6:: with SMTP id a93mr19679988pla.175.1563055457531;
        Sat, 13 Jul 2019 15:04:17 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h1sm15618421pfg.55.2019.07.13.15.04.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 15:04:17 -0700 (PDT)
Subject: Re: [PATCH 5.2 00/61] 5.2.1-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190712121620.632595223@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <7355803d-19e2-c05c-3573-13a280a98f30@roeck-us.net>
Date:   Sat, 13 Jul 2019 15:04:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/19 5:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.1 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
> 

For v5.2-61-g0a498a7d2850:

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
