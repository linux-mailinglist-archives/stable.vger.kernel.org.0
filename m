Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433A12DA468
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 00:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbgLNXyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 18:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730563AbgLNXyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 18:54:02 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C648EC06179C
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 15:53:22 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id q1so17560059ilt.6
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 15:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3eJutbNKeShulJMJ6BHByIr5qoNsP+5XgU9y+aAUMPo=;
        b=I3ShiVPtYxdHY8ya3r1QHU7Hh4bqnVfTNWKSfhfu/e/UcrRHUSAdg3N1tDPJ/gO/u2
         ZM8z/9OcYT+v8u+GG0Qb5Rs1DPbXrIXwfnpEfW6u4ZVwR7pdfLnoOmCfm2dNUR+0Lomz
         O/qNOLwvKb77JU1fhoQCNqPsXtcdGzHgM/JhY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3eJutbNKeShulJMJ6BHByIr5qoNsP+5XgU9y+aAUMPo=;
        b=kEugK+uTg9xTjr710o87IWo3fzSIE/38XwUtrANa+ByGicEtWOgrLDcqPiEOfK6IJL
         cn4BFE18tFHn7eFEDWMSn8TM661ui10Nw6kC7WJsMG1FzhpZJcYeAJnx0vfqABtiXlq2
         j9pzUbgXP9XjSsTCTBPJNjY5MDMa5Ro6Ab0G1R0m8huZ0gICFXizwNM88bJHkDg/SLTk
         bR7SFyRE4SI8o8svbhRiZrkqt4m7CyJaObtVhVXSiPkypvdydGFYzUCp2fwrUeWMBPnK
         9KALvtuAASxtUUZURJWutY10HbYpIG+Kk6t/pUD+kS0yYBr3jMAGeekUomG9shnQ5PDp
         OIVA==
X-Gm-Message-State: AOAM5305D8R0km32VcU7HcUOlBmdnQDWWQCxuK+LbI8RomqIkVJK3fZ6
        HXGcf0qPfA/iM7e2gDRvIORzXyoRS6iWFQ==
X-Google-Smtp-Source: ABdhPJyR3a1QyV6byeRDm1xRWVRVRHEtpxprlB7qeCm5Wz9m5XJUFZBpVWLIOAT0XBUAfkIANhNyyQ==
X-Received: by 2002:a92:c26c:: with SMTP id h12mr32106916ild.165.1607990002063;
        Mon, 14 Dec 2020 15:53:22 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l13sm12209983ilf.79.2020.12.14.15.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 15:53:21 -0800 (PST)
Subject: Re: [PATCH 5.9 000/105] 5.9.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f70996b9-9c9d-6a6d-2468-b00443d83905@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 16:53:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/14/20 10:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.15 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
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

