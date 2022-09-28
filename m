Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1955ED425
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 07:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiI1FOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 01:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiI1FOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 01:14:10 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D6A11E0D1;
        Tue, 27 Sep 2022 22:14:09 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id e18so7794339wmq.3;
        Tue, 27 Sep 2022 22:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=OB38kRi227skB/6g1/JGH5vPB3HcOBtn9y8MKLJUtto=;
        b=ce/1DvN4M81ygbm1WC5rYz+47y1vA2gqTg64Dx1LlEhLPP5DA1FpG/NRBOJTv7NoXi
         TLjc0rSqWNEnL4Jez8yAetw2F0ak6YseUWxwiUGDc5XLpvJvGopKYBLZvz8gDu+iXJAl
         BLewyuyVAUbfOWZbpY3leQFQ1oSQI6HDqCo2cGK0ahGMUXPq/5vo1OkcPys7c2ieCDdJ
         /fXlrdJV8FhUqVJZl8SqRxhjLMpUmTYBjz+mFFLb+7ZC2a5y82KSPVRLTpcEJnOXNeCu
         VpfqsALT1qxvJ7XZby4p/n8nzb0w7p20wlpHnCE8SbYraE+sCBw+8fF39oFLTFkOn14C
         gw+w==
X-Gm-Message-State: ACrzQf0kTlaMsVIAAs7dtw7rzvFh1L6WXEOnN+GGEbjabMU7LNX+76xQ
        K/InssNyKJ7ERnzpLEwqYwWRKjLZ5DM=
X-Google-Smtp-Source: AMsMyM60RriHaQCzJJtBlHBY2m8du/ksKmv2Hv/4I8TeCsLiIosweyMkso0U0f0by+2iBhaQRNRRSg==
X-Received: by 2002:a05:600c:4f44:b0:3b4:c554:a5f4 with SMTP id m4-20020a05600c4f4400b003b4c554a5f4mr5073655wmq.107.1664342047837;
        Tue, 27 Sep 2022 22:14:07 -0700 (PDT)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id h9-20020a1c2109000000b003b4fac020c8sm661741wmh.16.2022.09.27.22.14.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 22:14:06 -0700 (PDT)
Message-ID: <a223a99b-cbbe-aedb-cb08-7c79b9bcf7d0@kernel.org>
Date:   Wed, 28 Sep 2022 07:14:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 5.19 000/207] 5.19.12-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220926100806.522017616@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26. 09. 22, 12:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.12 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green. x86_64 runs fine.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs

