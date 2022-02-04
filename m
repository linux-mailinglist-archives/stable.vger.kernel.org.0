Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644884AA134
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 21:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238221AbiBDUdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 15:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238503AbiBDUdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 15:33:11 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE173C061401
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 12:33:10 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id i62so8871311ioa.1
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 12:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yC+jvfwVlwP869Sf5VAj3JxEYXRki/S+j7RsCMY3Luc=;
        b=hw8nrVpnzEkdr0OXDIad/ireNg0NAK/Xv7CtDLacAkx1cPrF3ZB2GNFNpFEmc0YfcX
         s0PFua40cSq28GFIa06w0+J9WtvYTs5y13wzFbEOO6en8gG9ySAxL8HnievQucay9A1v
         mX1aNadCpsN7W4hscbCOmr5QExwXOZYVgfr68=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yC+jvfwVlwP869Sf5VAj3JxEYXRki/S+j7RsCMY3Luc=;
        b=b40pcvqqtA+xTeAThCV4mYyAE/0HZYn9EVdA5Dpcba32ehn8/zQ/NWVdTW1Z81oAdy
         3uQSqvittbic68rGR16jRAnr0Gt9uHR7wCeX1H9BwW0twPtdfcb/SY6nUzJIwrtYIXmA
         2QYZpOeteF3N2EoJoXf3O9u4thZYR4iZbOsJWf3SMehCnoXvqjmRjJ4bwQ+u16jkAl/X
         eC7U/xJgkhMdxxMMSo4Jvf9uqFJcoyL1KCPV02SKlKEsD7AvgZQksyth3X2Q9m5dF09m
         HBwy/WyXvv3W2R7Vhucz+8zMQ6NG2j8+mLKjBVRskoS00CPNe0Bzf+2kM065x9NHTx0O
         LdSQ==
X-Gm-Message-State: AOAM533RAXiutoUmBALMq/gJTDHb1ynGJ1zK2PRl+LQ2wc0R4m/8PxVj
        J4Lza+i3Z9BTZ9unAv1HABxBzw==
X-Google-Smtp-Source: ABdhPJx51DRl4laNymhQtxHuk5vl3tJeD/NGPb0mxlDiukv3RiGPA0t5MAALJPu6EXeimY+N2tnlNw==
X-Received: by 2002:a5d:8419:: with SMTP id i25mr359840ion.163.1644006790204;
        Fri, 04 Feb 2022 12:33:10 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id g8sm1462727ilc.10.2022.02.04.12.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 12:33:09 -0800 (PST)
Subject: Re: [PATCH 5.4 00/10] 5.4.177-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220204091912.329106021@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ae60077f-6682-310e-b21a-792a68250530@linuxfoundation.org>
Date:   Fri, 4 Feb 2022 13:33:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220204091912.329106021@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/4/22 2:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.177 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.177-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

