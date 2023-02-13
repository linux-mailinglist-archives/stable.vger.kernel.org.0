Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8380F6954CD
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 00:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBMXbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 18:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBMXbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 18:31:32 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A0B2114
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:31:31 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id z5so2427694iow.1
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jGmzuGPn9I/FZ09CbZiNPtzTdFC7E/SYikD0S6LcbdQ=;
        b=gdA8Fg229Zr8Gi+sF6aRnk6TS9c9zyZ2tFpA5dJJE9mNcXQSIIY2WM6BD3q+hP0RTD
         nqHJBgPhJnT5m0iujz1Xuv0TQGvJQRx4qFw0ynhNOHBaEg2bWOJdJwQBZVk4cPvqa6yU
         KXa/Th/HaLkMwrtTxERCLzRwQO9dFzWKbwiRk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jGmzuGPn9I/FZ09CbZiNPtzTdFC7E/SYikD0S6LcbdQ=;
        b=cy1DvE6vjQN7WodKdCm+wKD+tQtcxihl/467WICFRIihgYYsTufdWW9YNY8as+qvgg
         Q9yXsBU2bTcz3yLaa7lck8fHsZhpoWJGRZJZv+nTBHdhNokI8mNFJSKXOezla94ofHjs
         7ZPWxWzB1u16Dn5M6HlDle1gQvtxX03yfy1XLEH+5K2ql0h2QgCRbglF1u1t2OJzBrCH
         LRzkk/gpkiUST5XpDaIpN+iEakoXhZfL+K57FWDUIXyTiwgaWlLd+w9NKDCE09t03JDO
         W7BWoXh+mJkGtunkfAvhLEbhFOYrcHxPOYw0Y20rKLi2NknQkaXuq3Hqv+PeKa1VUYQ/
         Rwuw==
X-Gm-Message-State: AO0yUKUeAzEMl6nv5CvS3JkdWS+alSgvP5rr1Eu2YiJz7H1w9PcvinnB
        URWilbIRv2y40xUnxcRXfjnZuw==
X-Google-Smtp-Source: AK7set/7TKUE2Tnu+YddFY7KD5UJ0yXLaaGtJxJEJm2w3ZTnV133eeBo/RnZmbbyfXBVLvpsfZB+RQ==
X-Received: by 2002:a6b:7f03:0:b0:716:8f6a:f480 with SMTP id l3-20020a6b7f03000000b007168f6af480mr222872ioq.0.1676331090473;
        Mon, 13 Feb 2023 15:31:30 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id z4-20020a6b5c04000000b0073f2c68483esm1306208ioh.32.2023.02.13.15.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 15:31:29 -0800 (PST)
Message-ID: <c08a57c1-49cc-e5e9-3b98-30c7f697818e@linuxfoundation.org>
Date:   Mon, 13 Feb 2023 16:31:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/67] 5.15.94-rc1 review
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
References: <20230213144732.336342050@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
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

On 2/13/23 07:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.94 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.94-rc1.gz
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
