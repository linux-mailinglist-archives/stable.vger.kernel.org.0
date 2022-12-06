Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BD3643B50
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 03:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiLFCeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 21:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbiLFCeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 21:34:16 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B091DDF8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 18:34:15 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id m15so5965035ilq.2
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 18:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YQ+tWAhNbDC0gmqSfgmib95RFSeFm70jylleXDIP6pY=;
        b=O7dnDobbSZ5rZ/6HKQT4AQv4tfeKaCnjYVuqVWXewEiU9XUXptBxB9ZQNGTybQVALk
         M+OGuOcu9HjhXbeCltyAl5laJQs7eB0QJEYH7+S7ZPHdfqeiqcZ3hVj/IjHI3l+MfftW
         aiyA82sgTFnqHv+HuYCdBoCB5koUuX0cs+4ts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YQ+tWAhNbDC0gmqSfgmib95RFSeFm70jylleXDIP6pY=;
        b=MJg/47txZdHItPU7qKuRDNG51O1L/62C/m52e64Qx59jzkSgukFPIhzxhwU6tiJcnl
         tUy9cOt4Ut+Ey15YBPpFaeYUl4kQVIONJ59O0XzFkgNQeRPm6VhAqngk4QePh9Tz/cHK
         0q0QrEcjH04ztmc+VRuwLRi+RbahLtVjoUcuApIP1L7Kd0hNy4fQ3vYpV1K8Wv/cxzfZ
         FWOXpbgyNMPAwKMI6V9SjwdfRFI+vQ6ocbxv+YHOMNSiJoOiaF5xgsdagSAC6FpZFO7X
         aE2h/NntZ2RM6C8tjRBjUgm7gBf1HHGwHWR8rsaM4HrJREGVryKQv79z4R1pnYXa0KiM
         4BWQ==
X-Gm-Message-State: ANoB5plCbUFIBadmEVFwicFQtTxViV/AX58/mhAl+6wLF9ylFSTn3AbL
        zQ/UjPsWF4hxvlXcg5+2pB7Y2Q==
X-Google-Smtp-Source: AA0mqf6TZ39fhZkN+lz6iWVbqJnfP7DZb0dFPZCAl8c+38xAhdbnjUMZWZ6eQmFYCF179mKTIk9zfQ==
X-Received: by 2002:a92:2912:0:b0:303:c52:274a with SMTP id l18-20020a922912000000b003030c52274amr18202362ilg.171.1670294055082;
        Mon, 05 Dec 2022 18:34:15 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id w193-20020a022aca000000b003760a908bfasm6247677jaw.169.2022.12.05.18.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 18:34:14 -0800 (PST)
Message-ID: <0cc3b3ca-ff9a-538b-4e33-a0d805861ab5@linuxfoundation.org>
Date:   Mon, 5 Dec 2022 19:34:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/120] 5.15.82-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/22 12:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.82-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
