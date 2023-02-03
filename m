Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCB468A225
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 19:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbjBCSmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 13:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbjBCSmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 13:42:14 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80817A58E2;
        Fri,  3 Feb 2023 10:41:59 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id h24so6589287qtr.0;
        Fri, 03 Feb 2023 10:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cug0hlfDT36Dqw7jW/V5xSD4WJgWtg61okF6HbuI67I=;
        b=QVlAEAfi41Sh2E24X+wje0kCV9S5nVzwiYF1UyN0oKYqyI6kYUqZNp7PCls/pjdSpz
         IRbBLpHRcYcsk9yfCVwxUPBv1wgLjtQC/vivo7i2gwVFfx30NGR+QsyLdjft7yN7jDKi
         1iaOyC5ncB/B628hz5iW5J0EZiAHtaKxtC32NOEFoUduGVk5byBUDsXIguB9cnXoXIQr
         2QJKVgxu8Svx4yLSyHLos5Q+10klGsUhQsmOK+CBBvhg5ohhVPL9OwU7gUwg4CENI5Nm
         5Cny0E1BoXgl5BVxESR3az6Zdh2H4Zl/qXWOh8bOz5UJHqX+pYQJ/F7xWEkURKUT7lWa
         8d6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cug0hlfDT36Dqw7jW/V5xSD4WJgWtg61okF6HbuI67I=;
        b=f9X4IyNKQfX0wS1QVoyghIH2hd8MxKdVu+OBG9j4ggmiWGA1GMQBSOGnKyC3h9boII
         JGnT0qfHlFPsOprKaJ1iqerK0jGp34jubZhwfbTSFMIlimaEwHZTCos0EB0dQF7bGczC
         kBrpQo8p65m7nIfHE6WBWp4xflFcJGCNQ5HEiz4fq2RW5rJ6KiI5u6cfSKb+SonG64Pv
         9UMpv8e/P1+jpPcM2ON8EIG6TDubrfocMdaW+xXQycZRyuIwi1kj9qmTbl0efMqw/hEL
         GNZLnU7RaiEeQfeu5YtKJV2mcU8x7G3WFzjAKwZ032PZM548n/NQpJK9iiTsljnIp8CS
         x1aQ==
X-Gm-Message-State: AO0yUKWBk3Jgh6dhDIRpc/Jf+6k7Xm/L7eVXoNmtrDRPTmhb/qVfQZ9N
        TYqZcSx8yDUtYVzVVZGfpnslt1RN9qhHnw==
X-Google-Smtp-Source: AK7set+yKBp9Lzl4KayhlSB33ocRyQjHvACLYd6X6UX7mV/n2SUrn2vJNFEpDouXWZPthOGFenA/cA==
X-Received: by 2002:ac8:5c48:0:b0:3b9:a965:7af2 with SMTP id j8-20020ac85c48000000b003b9a9657af2mr21237410qtj.45.1675449718550;
        Fri, 03 Feb 2023 10:41:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bk19-20020a05620a1a1300b006f9f3c0c63csm2352729qkb.32.2023.02.03.10.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 10:41:57 -0800 (PST)
Message-ID: <ca5b519c-c349-297c-1780-53275e0c8579@gmail.com>
Date:   Fri, 3 Feb 2023 10:41:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230203101023.832083974@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/23 02:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.231-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

