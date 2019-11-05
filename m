Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD9EFEFF9E
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 15:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389514AbfKEOXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 09:23:45 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35474 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389083AbfKEOXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 09:23:44 -0500
Received: by mail-pf1-f194.google.com with SMTP id d13so15554881pfq.2;
        Tue, 05 Nov 2019 06:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PnsfwHVKboT1onOi2MNNIGhlzf5mUggqcgt3KQ0SEBc=;
        b=jKrnyDMH49Lx6G4ChXLbeRQWHEsYnLVAV4pIr2ZWlFKdkRXOrGTs+Ct2KhE1XifC5S
         7wAmAxAa0LcObun2U1fb2KCI3/sg7EQGcdKk3xRabpy9DT8G7sVQIUdRp/TO/LQqzMek
         FxQRFI2XUxNvPoIWrbqSIKQlzY6pFPpKa5zoOqQTlJXRFz/MrKuLmfXVQxduImj9H/Za
         xV0uUUnJep0DMKwZpPML9d2Lgbf9BUTa+0IFahJsoWLhO4I5IzIg9yTwf64NXdjVIO5z
         kCxLCfS2P+MBVKxyAEbwFTDku7433+Pw46Nfdw5mBuP2EHj0cHaKXa7D8qRrvRdXC9t8
         5oxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PnsfwHVKboT1onOi2MNNIGhlzf5mUggqcgt3KQ0SEBc=;
        b=OkswZvdIyf/FolJI8YEtMQkdQKd/2nNwBAvI4+J/TaJ9wK7Neq91IG/4ds2fzePhgj
         HMGDRMAQPrHzKmcC2TS14ktOGF5By4a1V7A99NxeIoyE+QKLKOBI3WtaOYKN+flRduWj
         cHcn1r+6bCOcBmqPGspU3qAUegLFFoeCczS6gPL7JZSC9hCPGi55BVtCpy9Xx/YzkFmU
         Dj2D3yMCEsfmSUOMoNm1jZTezSnHucDN27Uwvh+pvoLLYXVrzEGK7x7nraAAr1e+l1q2
         28ISEihciDPMrOF6gTa8JvaLJEe+DKQhAd2Mk5j4RXLic8Sxif5q4g7MLBjp9iyo/cmk
         eQZQ==
X-Gm-Message-State: APjAAAUOfF/1Ik2Ox9tSWgB5cayNvvfHolTqO8JRBDyh0ftw2oFDFSTH
        5I+0+xm04/P0ckWrsasypLg9RtNS
X-Google-Smtp-Source: APXvYqwaiI2bbOrAmUESpUejMx1Rk5plpb7AwsbkotwARw0wB9fZy78gK07Yli9LLUnh77c/gTQyzQ==
X-Received: by 2002:a62:90:: with SMTP id 138mr38788686pfa.209.1572963823840;
        Tue, 05 Nov 2019 06:23:43 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x186sm9964687pfx.105.2019.11.05.06.23.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 06:23:43 -0800 (PST)
Subject: Re: [PATCH 4.4 00/46] 4.4.199-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191104211830.912265604@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <3340ee78-df51-bc98-fcfc-e2ce62880106@roeck-us.net>
Date:   Tue, 5 Nov 2019 06:23:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104211830.912265604@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/19 1:44 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.199 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 324 pass: 324 fail: 0

Guenter
