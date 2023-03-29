Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFD26CF13C
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 19:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjC2Rj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 13:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2Rj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 13:39:28 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDFC46AD;
        Wed, 29 Mar 2023 10:39:27 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a16so14736464pjs.4;
        Wed, 29 Mar 2023 10:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680111567; x=1682703567;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GJULAV3PbN4FnqmxwFMDn3XyWjJWjBIFfbT8YfLubVo=;
        b=ANDEjhsxkLHdkNemQmaTdmQL914V/yC70ynHk/xDVUo5X569qD3wj7KEJk34SYkmvJ
         DlrZfkQL4tCfxYAvs3B8hNqbZvpJ3PxiByqoDedp+0UsXFdkMeY0vS3pXpOTNRDYoab8
         3YoAcSCVqmG4Y9/ikxLD6QUUrN3r7gUntz5sg3g3Qq3+4eHgDsqxuHSHLF32QNCo1RLf
         qMCeCdRK1XMk6QGqgKQlAZl+CY3Ycjlm9MVmyXZBUJGppWa2ge9RgARo1ylLNAWRpzUb
         +dUcXGmfDjs0HznWjPdx8JKT+LuSr8V+FR1mEWvZ1s+BINR7u+cCh5w3HtYkxC/wQjRz
         L7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680111567; x=1682703567;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GJULAV3PbN4FnqmxwFMDn3XyWjJWjBIFfbT8YfLubVo=;
        b=JwxuVB3JjV4JxJVgO1gkHSSeLRX6Y2ThrMiPSVQz3yAqmL8wiDrexFCtSOom5miBMj
         DIzEQyhdgzCXfQ/rzUw8d3TQNBhYZDpBG4trI7y5Qw+WghVfW3HNfNUb0n+43j65HqaN
         yUdk0c+sMuiTlFfaA1OSxu/5m8W+48Y4qWtakqIHGqtV0nQijqu2P+uQYrEIBXDwL8Fh
         1rRiAbx1G0lWKST2Lhtoowr7rTapDZMjpnCkqMtgOeH0QvjyOLNxHFJxDNTSHfk4ky84
         7TB/nG/s+2Vndaj7zNC68/vWaU1wUC0RDm496y6VGmILUogfVCqpek1blFlrFoy+HZpr
         B0kQ==
X-Gm-Message-State: AO0yUKUFcOVVgosLR5kcDgAySib54HQ3SpZjjtCea38yGpsLhzEJBS/+
        qA5lHlIUcNlvQo4I9km7t+tVtlc0ulM=
X-Google-Smtp-Source: AK7set+mv58GLURbqqEBEOlP8HNi/SCv9weIowBe7YGjNAJOhVQrfRkGiIblzjHUdEScToXe0Ylibg==
X-Received: by 2002:a05:6a20:b191:b0:c2:b6cf:96db with SMTP id ee17-20020a056a20b19100b000c2b6cf96dbmr15411398pzb.39.1680111566969;
        Wed, 29 Mar 2023 10:39:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b11-20020aa7870b000000b005ac419804d5sm14718708pfo.98.2023.03.29.10.39.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 10:39:26 -0700 (PDT)
Message-ID: <c2a6c37c-fbfd-ac2e-9754-bc388fa00878@gmail.com>
Date:   Wed, 29 Mar 2023 10:39:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230328142617.205414124@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/28/23 07:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

