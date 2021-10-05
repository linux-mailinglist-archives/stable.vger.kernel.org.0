Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000B7422FED
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 20:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhJES0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 14:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhJES0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 14:26:16 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6C8C061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 11:24:25 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id p68so49670iof.6
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 11:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yvwYrUNiZmzPktECDvyllDmhFEqWCa15ZA1nSo55nds=;
        b=DdvzXWhbX662+v7+GDdf6jRWJfdzjnwI4uxbMM0JtMNiJvTMWyGYUGcr8trU8kSint
         +SHawZc5NWIazvJbUAUM8wQte+T2AEau56VToLHp7LAVGedU+cIgdh4B0rSkq91L7hw9
         kbrkS0sU05EH7w5VH01oKOY2yG/gST/1Oc9pQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yvwYrUNiZmzPktECDvyllDmhFEqWCa15ZA1nSo55nds=;
        b=yVkruKoI2GCcQh96HpcMz4HJLZftTKUzcpUfwQFUbJC/Hp/xIvbxpBEA/QJNhN+X4Y
         COyRGDpIuLnxMSyP9kf5YbzXVBvfVCnTkyqBKv/XQ4sJzSKe9qADmDKFVTTn1psfJ+Z2
         JnOFplak1IlNVvJp7i6bKhOYtW5Uf+pqo3kpved/otSQW6z6kSSTOr9ciQ/RLqNLGUnL
         qI7Cs+DdVxoSm9eJodGeag80FUxUYrDJ3sPpfFK2DxvwttTYm+NFOTvaZ0L6KTkju0u0
         hIG7Stws8ectl71r1gPTfp0dboiq9+Eavt0tK5NhqkU4bq3VMkEwghO6hyL7lo9UjOp/
         36Mg==
X-Gm-Message-State: AOAM530SMamqT+oTtrjzVLeozrE51U0jf32Xvcx+2tCP6YWegh5DkyXN
        O7w8yuhx6UZh3Qupd6Xcn0L+5Q==
X-Google-Smtp-Source: ABdhPJwfSddRXNSZw/7LClxEePTrb1tYTfcbcSj8ZOy1ezwWAL91V+hndcMrN2AUC65wWnTHEyDgVQ==
X-Received: by 2002:a6b:6b08:: with SMTP id g8mr3455097ioc.199.1633458265066;
        Tue, 05 Oct 2021 11:24:25 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f7sm11286621ilc.82.2021.10.05.11.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 11:24:24 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/41] 4.4.286-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211005083253.853051879@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5a83779b-134f-b22e-ba5f-4d202d40acf6@linuxfoundation.org>
Date:   Tue, 5 Oct 2021 12:24:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211005083253.853051879@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/21 2:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.286 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.286-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
