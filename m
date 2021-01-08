Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A062EEACC
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 02:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbhAHBMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 20:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729637AbhAHBMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 20:12:40 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8984C0612F6
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 17:11:59 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id d20so8247239otl.3
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 17:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ICugFRHzEHJ9uIu5D1dZQTPOrQoRJ5P3SAhHdvifoL4=;
        b=aPIBhjnGupNnSJ8IKlZxSzHZvGWVi+/DPaqJdqePft8VE+1XedE7ltggxfkMiwPV5W
         +jl8jKEbpMblp0/YajtXLGVePBmwyWCgeORTVZZTXyVpFjBRqGNexZmb66YP5nagtjMM
         llAniDF68I9gFKQQjoxMUt7rJdSEX8OFM0K/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ICugFRHzEHJ9uIu5D1dZQTPOrQoRJ5P3SAhHdvifoL4=;
        b=Hs3CVzUYTjK3ZedN4RNCap7pi5jAz9Ppso/sMGHR00kFWCFEZ5b1vpBuuyp8whHtta
         oA9Jh6rCAhxF8v0YpyvSC9BEQ6wgk9gdAtGqqVKKXU4emATll9/bd1swCdtRnQZaRBLh
         mM2/JaBgGSd3chdcWo3PTgHH8Pcvla0mOjrF+VPbrjLP4RvnvQd78+8oU9qWhNu9TMHT
         WVQvFjPNxf0DPbtwag6iattUEZC0cvfHT25N5bbK/vL0dr1iuoofZlnMVxsahZxOw4J3
         ng/EsMy8YTCDaau3eQAjcj7DFmyxeRgSzf5Lz2R3ac3WdjB88s6DKwpUGU2pWX9QNC2p
         Rykw==
X-Gm-Message-State: AOAM530lKcnfaou8B84ATUFW8a6wEcihaNdrjTA1eSCLygF1qjBO2tWs
        e3xjB2/I/kUM5ycBfAA8OcdA6g==
X-Google-Smtp-Source: ABdhPJy1BuTyZqDpMGFiYy50teJTyR5RIkrlUTxQD4QH1huvYxC73++ZGQ8jG9fKfSF1tfKJJNtS2A==
X-Received: by 2002:a9d:602:: with SMTP id 2mr873989otn.153.1610068319190;
        Thu, 07 Jan 2021 17:11:59 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u85sm1669272oif.57.2021.01.07.17.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 17:11:58 -0800 (PST)
Subject: Re: [PATCH 4.9 00/33] 4.9.250-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210107143053.692614974@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0814982d-3e77-d1f6-be34-cdaa0985fa01@linuxfoundation.org>
Date:   Thu, 7 Jan 2021 18:11:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210107143053.692614974@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/7/21 7:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.250 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.250-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
