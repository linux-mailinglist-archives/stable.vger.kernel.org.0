Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC8A570994
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 19:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiGKRz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 13:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiGKRz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 13:55:26 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9537A535;
        Mon, 11 Jul 2022 10:55:25 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id bf13so5331496pgb.11;
        Mon, 11 Jul 2022 10:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yh0QK7GRgvylwDLA2ulRuXMWICfx2WUE0Ey0ukvvCpA=;
        b=ezw6o+CRb7VXzc2vc950Oc4is1AgcsoEGmyzXfBeItYav/8aipf1hZpy088e8v/KNd
         HsT6eCatv/bgnoIBMOepHFlaTezb5+Sv2ZTsJ5S4UvBkTezE6GW2WvJFCGLp8mmo91Xc
         yau36mWNEb0bVKfr6v51VzY/u4AA0+GXpLVbyZnROjPYr9odxD46FsL0AazLOKrhOaxt
         9OD2CplUmuIySq3WiEPpWIcFfycJ57y4Y97Vx4IE4H0Zd6mkEVkn1c+if80yFmsU0w/d
         UZ5b6rEl4kBnsBE40LkaW+7Nlg+W8ktW1B6qYuJi2AJBKHF0C0+H+kHZHl+ilVmDIXid
         n+3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yh0QK7GRgvylwDLA2ulRuXMWICfx2WUE0Ey0ukvvCpA=;
        b=gfi+CeKqCGNPM3JdH4hDdu5PpvbD/DGOFegXkEc092O9P3pnFjiIM9AKF0cqoDtnIU
         zEjCBxONQ/H1AheJBtb8o390Vd7d7tSAreEJbFohDr5QKFq3jPtB8gwNOOAgTkGjGo93
         lebvjjfOYGZWn5VQ55NSrUl58JzZQ9pZeyetbY859w51y34bRz10nTVDpUdpDr1zlZ8i
         zGOQnAOSn0j8ItmrF55xRpV5WSM1wA70azK3SLRDD9Euu3xA+v1xXUi7SReKcRjb10Z9
         g+cjePaLS+xoPcxxllxkMj9hDn462KqAdx0VcZvRwDwnngqL5R6TztIR8l/9xjjkaB7F
         mU9g==
X-Gm-Message-State: AJIora9UL0S9MOk2SDTMEmb/x6Wx+9GoCoCL/c1BMgt65BNkbgKbpNo3
        boKy0mADn1Y2ooJrcYogPh8=
X-Google-Smtp-Source: AGRyM1sG6upU91wJduYtGIn8QiTWd+0TUehznyUUqX4hqimg/C0XRzN3lKmuOOYqDKtEoBw0REdZzg==
X-Received: by 2002:a63:454a:0:b0:411:bbff:b079 with SMTP id u10-20020a63454a000000b00411bbffb079mr16476157pgk.507.1657562125332;
        Mon, 11 Jul 2022 10:55:25 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f5-20020aa79d85000000b0052514384f02sm3608203pfq.54.2022.07.11.10.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 10:55:24 -0700 (PDT)
Message-ID: <1c0496f1-7069-22ac-4eac-b8826177d8b5@gmail.com>
Date:   Mon, 11 Jul 2022 10:55:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.9 00/14] 4.9.323-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220711090535.517697227@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220711090535.517697227@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/22 02:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.323 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.323-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
