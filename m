Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D35065C6DD
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 20:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbjACTCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 14:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjACTCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 14:02:42 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CCA12AFA;
        Tue,  3 Jan 2023 11:02:40 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id jr11so25277268qtb.7;
        Tue, 03 Jan 2023 11:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jYj4/tXIF69QmtbzP1BhKc/PoGdv6mttUVghO9XmKxQ=;
        b=NbuvwgnhOsNh8UNKt3cOld5dXyeR7DZQaKzpwcqXmyfxhDapDGUWrz/khEqHRmu3R2
         HTOk1nyri59cXhqeN99/ZsXhuZTb9Oi8yinf9ES6AlFvrz385uBCOQ+ZIRLcZ4cxS6Hj
         nORyRUcPeSWD03jxYHeXx5Nbfd5aqpEE84OQJNwjGkc9ilr+JlZE3osSrcKvyM7vJLI0
         MmgZCkSYfs192Odxj4fS9LZXilqHd+QsRa88owC5HgCqFgUx4qjhZxxAf2a6/5h2sO4K
         LWiFzfG9Ps6HltEpEG93r6ogE9Zq00guB9sg6RVDMpHn+D6Z7xuIpiTtrjGJ613CLli0
         NswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jYj4/tXIF69QmtbzP1BhKc/PoGdv6mttUVghO9XmKxQ=;
        b=kKQy5+Z+PUY2IqUHvXwpp5nS2ZvQqvjAkt7uk0MZtiI382Sunr30OxBaCwNNOBS8WU
         cPXod3onq+ezc8+TqDkegwcQm3WWzdG4DVD48olgkZ4xz2qPOmQGV/5XiKbD8m2Z6JEb
         aqG684jRP8FRsh1WZmm9ukBRba2hEZx+kUZiLuPDjHmfCoMBY7y3X55Ig6hQHehlWPzI
         UuUzHEz58R5rRelue16cDT5WqL5l5jxXwNZuTSJ/B+1Skp8HsVQb9WMS2QrF5/Ojt2EX
         5kkT7AsUhtGaz91mxIM5IRaPadtG72imqTz1Dr0Vxw+z/SWpfJsDMEfkDDtHOZ6qPe4i
         pX4g==
X-Gm-Message-State: AFqh2kpuOfbc3dPUmoW+8R/VIB4HzVC/+oF4VZTtl14aCYFHLXW8TvaS
        YYeIKngIUYHJWljMOePIUiA=
X-Google-Smtp-Source: AMrXdXtAjY59Dp9u9hXRm6Xx81M9kMnNiElJEcoeoBh2hHj5KV6VYfwGYyXMbmto+glaJqc7ymtAKA==
X-Received: by 2002:ac8:5495:0:b0:3a8:3d8:4e68 with SMTP id h21-20020ac85495000000b003a803d84e68mr63525918qtq.55.1672772559947;
        Tue, 03 Jan 2023 11:02:39 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q12-20020ac8450c000000b00397b1c60780sm19246359qtn.61.2023.01.03.11.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 11:02:39 -0800 (PST)
Message-ID: <5d8a44f2-511a-c5df-0246-8b1ff953a0e9@gmail.com>
Date:   Tue, 3 Jan 2023 11:02:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230102110552.061937047@linuxfoundation.org>
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/23 03:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

