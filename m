Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEDB55CFEE
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239231AbiF0RtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 13:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237960AbiF0RtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 13:49:18 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C11F95A7;
        Mon, 27 Jun 2022 10:49:17 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q18so8800374pld.13;
        Mon, 27 Jun 2022 10:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Q/XtlNuHXhafjy3rxC1P4ckBLS+ZGb1ojWGQwnT715k=;
        b=DMJ6zGSh3YK1ZkElm2Zi3EXx1p6etIdPsq5cq61RjwJvHblj0Uulq05L7ggfOKPyOm
         bAb2N8CuU2UL9miA2w/KfcaMt4BTnCeWAk9dWkrWkuCfd8SClbEnoIF4+j3aij30KMpI
         WgrX83gVKe2sYMTdCxNtC1g0p1ZIbX8k2odYYv5BVNvggiQi0ag5rzNqf2jfgY0JaZ3l
         2Sq1NKMfXyRwNeRNMvJABfpWVP2a8+8W7DVzLRPYMtj4VXES+FuqYomiNLfoP5RIcwW0
         kS+jp6Qfn5VMb4kZQd3zrHLgLdZB0DS6Gu6nT5wVnQ1f3O0hSPlnDlE3zxkwGlDCTFbO
         qh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q/XtlNuHXhafjy3rxC1P4ckBLS+ZGb1ojWGQwnT715k=;
        b=N25Ln+5MrvKycWnxDlO5WZembequUyhgYKJ0voTbjVpyLwqHGn+6r+0aDA5LVvXJDX
         zpP/LVzI0aI+FA/Csh7jrvWS2baDmo2u/LpdSQf79UJKReLJBnW+dmJN7WJa1V0Sx3e/
         Wkkt30X1IQYtmXHg1+lt8MTWHsZcXIPNU1wMlv9Bdruczsr7YSKzjEuMoscEfIFuDgYk
         1Extr188SlBSK7wCkryk2zle5kDl643KXByQrDDkCY5WsxGpUjb88Tx1O0DXobHs7Crt
         6WOOZC6bEvMH9c/UQygm8LLrE7bku7AATEfn/pRtUHiqDa7hQeTM4o9OjflyEfaTgHB8
         SMKQ==
X-Gm-Message-State: AJIora9CdsmUBPDMw0uE+VdCPUMR9SFuv76wenFxjJbjaRVahQQG5dh+
        dXxV4pO8zDjP9xKSIqDK+KU=
X-Google-Smtp-Source: AGRyM1uN8L/N5Ha+/fwCqCw4RCUrJB8FnuLEIj/Dp+IBksweEovux+P4oGZQir6vqjaLTlpKlh7RJg==
X-Received: by 2002:a17:903:291:b0:168:c6b3:1976 with SMTP id j17-20020a170903029100b00168c6b31976mr16193993plr.9.1656352156725;
        Mon, 27 Jun 2022 10:49:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q14-20020a63d60e000000b0040cf5cd74cdsm7255032pgg.19.2022.06.27.10.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 10:49:16 -0700 (PDT)
Message-ID: <55211a69-df6d-4b69-a596-06372b69ca31@gmail.com>
Date:   Mon, 27 Jun 2022 10:49:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220627111944.553492442@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
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

On 6/27/22 04:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.8 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
