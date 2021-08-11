Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1839E3E994A
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 21:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhHKT7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 15:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhHKT7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 15:59:07 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849FEC061765;
        Wed, 11 Aug 2021 12:58:43 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id kl2so1790353qvb.11;
        Wed, 11 Aug 2021 12:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L2WxdQ8VewyRg1okrEww3x0oNOVTdbRMN0u6B0FgKJ4=;
        b=JNV+zCRdxcpphjenev7v2I3fTLx8Yyn3FZQ1VPbPnkV0HEf+dlcgXJGFQgj3hsPVQj
         wguqau/czYtevsY7O2tfkRTaJ9IF682IxxtNrG6nI9m4nHiIIoTedP94moNaW19hId7l
         Qqw6YhNq7LxV8Xb3quM65xaIF76TCMwvqH6Dibv32MKmb5qxkqsQWQ1Nr/ii4Yulpn3T
         ACgFXeJnZlSPf61mFyURNU5KKpKxwfeYZGNA61ad0+v7JeS0NmliiHrY/euFh6tOGGgt
         ohcElSpE1XSSMwTPzD6UuofRi2CDyf7Gb1YaKfBzG+1dW8QimdytpRZGJ6JX0ory2bRC
         e8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L2WxdQ8VewyRg1okrEww3x0oNOVTdbRMN0u6B0FgKJ4=;
        b=M3ngJ8rVRHCdQN8llPeyRhbJ0ZowgkytgwU6uTtTdcojAfwTydJswMHKvxhjDXwUXU
         qk2FSbbMIDS91+RPDEkUmT+IxlXLmHpi4f2ZQ8FMrgBN2OvKjc/7Ux520ZR04o8KaXPF
         NWhb3lYJdTH7kjVAykug3QRuH8yNyiFB+ai0yzGFnULJpU0N1wyy7m0WdksVcHqk13oP
         6kXe0ZjSMUTY3vVPx+VqOuFb2Pd6HCEJTk9ImS0PlVctSdDmMOAiyA0xa18dRqIwMCaf
         Z6bw8pzru8tgh/TLCpQ1CeW1b3clZYJyOPUj3d4S4KJd9tb1CwbIV3CeN+xAp1iwk97B
         m4Zw==
X-Gm-Message-State: AOAM533ri+qtbo1X/Lr9ez19181NB68navCkxAShLEwBc5rZ54xAz6k8
        +PvWVUXegYP+vODu+IkzA0lA0GREb7E=
X-Google-Smtp-Source: ABdhPJzLvYj1Bjli62XFIlEPLD/2qRNIA19UghObpoyPFUxucoUVvZJLuuWxN/TGMmaL3kuCgyF6/A==
X-Received: by 2002:a05:6214:20ea:: with SMTP id 10mr314657qvk.13.1628711922525;
        Wed, 11 Aug 2021 12:58:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 79sm96607qkd.94.2021.08.11.12.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 12:58:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 4.19 00/54] 4.19.203-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210810172944.179901509@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <681f21a1-ea1b-aea5-e86b-a2d030ce6665@roeck-us.net>
Date:   Wed, 11 Aug 2021 12:58:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/21 10:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.203 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 439 pass: 439 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
