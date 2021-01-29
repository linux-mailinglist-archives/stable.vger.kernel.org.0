Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A008C308C6D
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 19:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhA2SZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 13:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbhA2SYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 13:24:00 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531F2C061794;
        Fri, 29 Jan 2021 10:22:56 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id v1so9494746ott.10;
        Fri, 29 Jan 2021 10:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xuDk04B+kNAT/hBLrWSP90xNMBNJ89Gog6ld6uLXF4M=;
        b=EBo/zQnGX/Rss6kl7fNfDsBVdNjIjmJvh6l9Ibr8TbgeDxNEJ+tPAztfzH8rytFkaJ
         SW5mTmtcPUlDHLUX2UzeSLc1B/KQ522++bVlXmLMNxrrDp/+QA3FyHyg1OffrQ0wtJZI
         1L8I3krDX8pfEeZCi00EkADvMcr8gYd6G8/ZQjLMtnwgBJyaBoE4F/saw+CGv+wtRJGM
         jw82xBO0lENpdQJQuWtl4RgPFqJqgsDAvGs9noTWzFdlFfXNo2AdPx+hTlZ5gnRBo2AF
         yi5gNvzCJTc0SM/QczfhUMTEzuURBagzBUU7Iaw4LxDtef2HczBLcJgolFDD4eY0TNQn
         VEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=xuDk04B+kNAT/hBLrWSP90xNMBNJ89Gog6ld6uLXF4M=;
        b=nkuTHBYTypXu5hk/MojcbmOGROmrAfE/LqEX8H3onEeEto0fiUecvsaqA514B+5lTY
         KlXHxGKFydyeG69RNky/QIwD50bpZ93wKoFwcmbMCLrA6lMUZ9qjCY/X8uWRm8G6nOje
         XCfa2cappumMScmE9lHn1UyqJhwsK09zMfEX74YylgxSM4DO5xWt4nnRdL21OyNDUqir
         B8X7IoUWnOpjAImCzMsYbXm0C+kL/+PTQoXgp7EakCXMeJKiA4BTfMHeIHUcXSEgiIEM
         zpXmh6BqSW0sIBLzoPXjsdXP4MTDy05ijx3olK99K1/6+lY7G+I0i9L3VfTMltN0bBV7
         NCtg==
X-Gm-Message-State: AOAM5301nQDun7HazbtdRcuW3zRWqbqi3TTkwuz8s4nxBvttbOo0/9Ji
        loUh8+KJXkFahDkjjsz8Ju4=
X-Google-Smtp-Source: ABdhPJxP4mJ/UjHx1qlfFohmZWhmc5+Vuwh0BP901pKVV2MUWeAJ++18lrPTSj9Ilw/sRcYKZOhyqg==
X-Received: by 2002:a05:6830:18a:: with SMTP id q10mr3607109ota.115.1611944575761;
        Fri, 29 Jan 2021 10:22:55 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n5sm2640246oif.27.2021.01.29.10.22.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Jan 2021 10:22:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 29 Jan 2021 10:22:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/18] 5.4.94-rc1 review
Message-ID: <20210129182253.GE146143@roeck-us.net>
References: <20210129105910.132680016@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129105910.132680016@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 12:07:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.94 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
