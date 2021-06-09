Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6823A0A4D
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 04:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236145AbhFIC4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 22:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbhFIC4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 22:56:06 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B17C061574
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 19:54:05 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id a26so3012608oie.11
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 19:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aTTLAw4NPS3JsmZfgJtfgUL+WouD7q1ngNw1o5rQTTY=;
        b=KLUDoHGLlsQCXe6JCZNeq+Od8Ro2aJ72JsjOiVVgN8M5ukJWkJ+Yc2wY75AHLOpMTr
         C68C1ZJ/2neS28j0qLNZR8OQWw3KBOe8QYY7bbNgB3hX/ttErAHeB0zRSUKYZV8pFBel
         /upvC4YllLL63E3x8dDxash8naY7dbayYFHac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aTTLAw4NPS3JsmZfgJtfgUL+WouD7q1ngNw1o5rQTTY=;
        b=Wda31Yo7cHbVZVAh4TDYNhbGZ27Bed86Ndr2b+bIa17LiABo17SZSFb9oFOWyDvN/H
         Pq2DuEgFnq4onRlTk4fKst4DutCW4n+3jYI/5TW+/PjhW/M/upR0FMKXHBhZ8VygSJlY
         MUW9l5f6eYPJUx4DGg5lAbJ2zrGmh3xnhEPlv9BFIEwibbU9L3L2q/e/BIxldRz39l+6
         ve8pMebd32JG2VMGTpIc7Ot37Ov5pua86cTfJRq9M6bLRskLQKJKogWdoreAS9oB7n7e
         CAI/iinQR8r9FymRoFq1w4gNErh3FANEi7OL6EIA1YUivJrXMyFeWaMMSsj1aeX0adcS
         YtwQ==
X-Gm-Message-State: AOAM533v/xqPdCKQQOtNK2WsKI4GFFzUI/6tbhe/Ipn8cTlyHAclvgjr
        BkA59JbvqzQYJ0EzOl4GySO98g==
X-Google-Smtp-Source: ABdhPJwluiCzN7chYdAlx7YzSqiocQEUW3hiYncQVvsIq47C8xSDCJ8oa8Xkum2RsvGLDC31EnKFTw==
X-Received: by 2002:aca:efc1:: with SMTP id n184mr4986195oih.23.1623207245155;
        Tue, 08 Jun 2021 19:54:05 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c13sm2468221otr.23.2021.06.08.19.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 19:54:04 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/161] 5.12.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2ebe5b47-42a3-39ee-e027-d29ebb2df3d0@linuxfoundation.org>
Date:   Tue, 8 Jun 2021 20:54:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/8/21 12:25 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.10 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
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
