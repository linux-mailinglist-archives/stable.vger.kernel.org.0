Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B88A1A241
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 19:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfEJRXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 13:23:43 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41898 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfEJRXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 13:23:43 -0400
Received: by mail-pl1-f193.google.com with SMTP id f12so1110854plt.8;
        Fri, 10 May 2019 10:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=r2qYqMWhJNEgscWQZ+ZT3SiWAu7rASUf9bzScRY/XLI=;
        b=le54B0iustfb6VbkOBLy4evBUrDnke/px5zo1SwVa1y091/mn1idWWuXGbvrtQl5UA
         Sg38cbzucJo5fVDiyFuX6ZQOLOZYYbOs2Xw04nqZf6WGOYzs6c2/n0NjGrI63On4xxf8
         s5TfNrW2YdsuzDyN74TmZelp4lzVuy4VyJOmrT5Y8CC3Fn93V29ApawUGoG2u7q/+rlM
         przMd8g6wPTtU+1VyHVRr0INwxxudIzLmHA/193ZMn+tvXY0W/erDpLiYP0dtB/PrQOC
         HqNA1HXqCz/tZmZIX/ph4aAbTdoTfZ3nAK13wBcDkUCYymy0GEEAibPCzAxOCzAIEPLe
         3JDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=r2qYqMWhJNEgscWQZ+ZT3SiWAu7rASUf9bzScRY/XLI=;
        b=i9mUV7xwl9KpO1CyB5216PtCuk9Psn0dmxuWvDylrDn5XIfChwWwgoSwcHpcyeXAMj
         hXEQwEVy2AUM9jBs17ce19fH35x92yEbL2rOYxWN40CLwy/p/RPmEyWQnjV+LOMUSKyA
         SY+F8NgEtH2RlWNOqSQ45yo7V1HU1F9ANEEzzZlU7bifM4c9rEyFzwj5I+EKkDT8QigF
         1zm88Tqn87Zj1zk4UZsu6zmxbQGYnW109uEsuy9JaRKD9E7zvCYb9a3+ULSQ7twMk586
         v4ckXjZI1tj8DMBF1nacNJzeMm66Dm4muFMETDxI7qA/kVFM74ZTDRNi/xf1WExdteZY
         kDyA==
X-Gm-Message-State: APjAAAVoEbZFK9/ah62xex6uh5Ws7hg1bSL8Bs7mRLpgJDxIOeiF7vqH
        Da9jWC1uDK/MtqW5aBXSjyeyAPj56Dg=
X-Google-Smtp-Source: APXvYqy8zqWRIdv00NPHtPelyq6cYIQi5Pq0I/swLvi7NnowRY6ehnDU7HWzDvuxJ3zSf29AYxsGtg==
X-Received: by 2002:a17:902:324:: with SMTP id 33mr14823495pld.284.1557509021629;
        Fri, 10 May 2019 10:23:41 -0700 (PDT)
Received: from [192.168.1.7] ([117.248.70.207])
        by smtp.gmail.com with ESMTPSA id d5sm6105029pgb.33.2019.05.10.10.23.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 10:23:40 -0700 (PDT)
Subject: Re: [PATCH 5.1 00/30] 5.1.1-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190509181250.417203112@linuxfoundation.org>
From:   Vandana BN <bnvandana@gmail.com>
Message-ID: <23f8e6bb-f8b6-335c-0148-2c4903159eb4@gmail.com>
Date:   Fri, 10 May 2019 22:53:34 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/05/19 12:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.1 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 11 May 2019 06:11:35 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled , booted and no regressions on my system.

Thanks,

Vandana.

