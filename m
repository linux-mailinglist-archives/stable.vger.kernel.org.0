Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA0A1FE34
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 05:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfEPDhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 23:37:14 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46159 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfEPDhO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 23:37:14 -0400
Received: by mail-pl1-f194.google.com with SMTP id r18so858565pls.13;
        Wed, 15 May 2019 20:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sbBGJM/mMzQiPe2i0MPHK6fhhA2lc0ghjHI0rHDhcpY=;
        b=rlZR2CrJ3TvV97Zb0Q4BH06w6GWJ7hHjv8miEDiy9H7cTH9DTeXNUi4S0CgKGNC5dx
         nqx62qEc2GZAL/7RjZo4hBT3w8SVV8pXejvwEg+jzSKuInLSZu/r8oiM44sgKC8YCQKU
         ADJeo2RIIx31/hdUiQytBCF+nU5abixdluNjHd8tGazW8Nt3omX9q0//XpWtvw7xCwl2
         +aoIQZPdBAXQIF8I9yDBFHSd6oLavevw9n9eY4plRMCCBbOAFkvluby//eiJ2jAjcJtw
         RbuMjXzWG75mx9dz7MR5zLsYgpD6vrA+QL4uiKlRrcwjOAYRnS/Nbk79wlD2w/qJuUDm
         4Fkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sbBGJM/mMzQiPe2i0MPHK6fhhA2lc0ghjHI0rHDhcpY=;
        b=P1nl6vYaMRM02UeiLNs5Zwv1nwmwXgK/P/044B7KniIB9PEGdhvTg5M821It8/s2h1
         l8fWCSkMlX3L2VYMlfJxxmvJuzAUhGThxDOmC1TGu83Ceboi5QrWufLSNf0ZymKgp+uc
         rWpTPn/UX8p/szDNhRvxRJMYb53nN2zLzXAModduD1XTrhFiDZJ7RfKGjkfSbJtC2fXs
         9kQHTkmcl2xKpzr1l7IB/w2kYWvovYqGJ4fa7gmMm78tEcIuGuWjoSID1bOal2i8Hy74
         U9FBP0WWbMk5zuR+Ricd4RHg4ltfgVr1BL3u7ZJGXGgFsASGy49h0Ia6kGEoxRilH7O/
         jtAA==
X-Gm-Message-State: APjAAAWTIpDVsXZMycJSJQi5FblCrEUO8FaDKIxgWUlhXOR9rrKx1p/e
        2da0iBRxPhMMbPxaAtlBhXf1q24Z
X-Google-Smtp-Source: APXvYqzzgLgP5i7aBCiqt4NXIlCSi3JZVH92Zh7Ylc1VNIGVVXe5y7bNd1sXE2++jaeP1/jWR/namw==
X-Received: by 2002:a17:902:b184:: with SMTP id s4mr9684754plr.46.1557977833472;
        Wed, 15 May 2019 20:37:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s134sm6242947pfc.110.2019.05.15.20.37.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 20:37:13 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/113] 4.19.44-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190515090652.640988966@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <508a5042-5f22-39f1-0dc6-03defcf5388a@roeck-us.net>
Date:   Wed, 15 May 2019 20:37:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/19 3:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.44 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:35 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
