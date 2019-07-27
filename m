Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922E677A81
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 18:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387673AbfG0QHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 12:07:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42373 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387419AbfG0QHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Jul 2019 12:07:02 -0400
Received: by mail-pg1-f194.google.com with SMTP id t132so26157274pgb.9;
        Sat, 27 Jul 2019 09:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LOnewBrzp5ahtUkNIX7+SrRMyqJOCHhoToqapU8rDFE=;
        b=UlOOlPvlou6SqaLRBCGkzboT/WFCmi766ZFa9AAAEFduvHTUHeYi0+pEwoMDzDSbnb
         N1+xGKFRLbEGOc9U/wiMzW8saqLWN0wJPApkJ+GpleTh8LyhPfO/rqeN01TuEsMnjake
         H0vj+oxH94yvI1jTe9yQLKqaVhcErwtcp/WnWqnC9IzZQjrz7Xw3vJJ6MfOmxmPto2ml
         dUwNczjiK5Y9hOcrU3Vx0GEubF5Bt9fwEove8XQYXc2jac7nltHa2vwIX078FaJngRnc
         quE1/dbYKN5FZfXvuhRDrHIOoADqZ1yyfxv1To+yeFlOiQLjWrXjX6foqBmvLxHYTyJM
         eTGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LOnewBrzp5ahtUkNIX7+SrRMyqJOCHhoToqapU8rDFE=;
        b=eJVj+uXnSdfU3cRYQWgQmotGr27kUlr+gotg1GFPZEQDjYXfcTSKB4uGv9/7/C72dQ
         4oAmCy3VihbhMVkf/Qr99TrovCcqZs/ljtNVPevTR3FAdUCgupnaGY8LGHcgUfhtb0fA
         opF+RueI8Q5ovA6q6vu05WuWitGNYCf56gxSDLML6FrmFPF029v6lnfZ0jaTxUPbpzlP
         0O32Ji1jjxNjcrIVGJ+2w4mKMY3shsuBz5N3J+tR0asQtEwMhkI3aMJzA5ZMHakobGj2
         Hq8QJ9ZDYS0CFDggomm5a8ToE9RxSFgg2vsGp8UTTiE3rV5eV8pfIpUaf7K4xWb8dh30
         GNXQ==
X-Gm-Message-State: APjAAAUkw7lF3+H7BeQ9aOddy7yFqGRIUftdOMBW56qopR4GAjGrm5wK
        9NLPlivesSpQ/EQHkB80UQippBBi
X-Google-Smtp-Source: APXvYqyc5pHvcIE6HIz7YXyHa4VdKLVhUs/QoV5ohQlRRGP9I+RUVyXNzI5wpdte6NGegWUQDqiQ2Q==
X-Received: by 2002:aa7:8e18:: with SMTP id c24mr28175557pfr.24.1564243621837;
        Sat, 27 Jul 2019 09:07:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v63sm58385430pfv.174.2019.07.27.09.07.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Jul 2019 09:07:00 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/50] 4.19.62-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190726152300.760439618@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <c2e14350-c5d5-b304-8652-7289b6c61714@roeck-us.net>
Date:   Sat, 27 Jul 2019 09:06:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/19 8:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.62 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 28 Jul 2019 03:21:13 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
