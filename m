Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25D96BBFF4
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 23:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjCOWnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 18:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCOWnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 18:43:02 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4A63C0E;
        Wed, 15 Mar 2023 15:43:01 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id y2so20492348pjg.3;
        Wed, 15 Mar 2023 15:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678920180;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eEp3d+FJRKvRxifPcXNAFdp5+kmGjxvebEQxyNRqGVA=;
        b=M3yCC97Geq9KE07fU9rp4QJKMGfWQcU8AM6+2xT/72tlldyXs/r4blB8gVCxXP6kCQ
         rO227if2lgIbA495wol0zjzwcWJXdGDxHOHJv2jUBXJtFYJGuvWYmEhTnEIIsT6Ok6IO
         40gMJ+/JgGDZyfaaLF3xXQGQ0pl05oZuOktuWAB0Fw2jbW+Ueh/hHcTHG0gLKsP2fBZt
         +AfoE2uXoMP2b5wFFhNrnl4MQr8JVShfR/WzR2z/61cOH+yNuV7qm2LGAokhxATGPMp5
         uIPs0d4CUTbbZU89uvKD21uGa84EURPmrZumBiEgFkht8n6Nnmg0Su4+sjK2bZssHSO+
         0j2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678920180;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eEp3d+FJRKvRxifPcXNAFdp5+kmGjxvebEQxyNRqGVA=;
        b=nLL6lFdY97sHBeMC7bX1K9rDqLIb3LdCOv0lVvvc7ZXgnwUvXr/SIcZ4QF8pL5Q1pb
         hiHppEmvE7b7QUT25ayDb/F5Id8gsHMcUSi0yvHIi9KcBdwV+jx4IAvdtF1BOk3Nb1nL
         ac6TDGDnjyiz9aex5SbRMZpUxJgWTupHv05GWjOHKq8ILh61+mcp4MZLStP0avzsO1ek
         t1ve4kehC5mLvjfur3hkFfQCM62MAc2rsf7ErXpj9QVWbqEbPO+GoTGkQ4FxC3YNxIlq
         U9170FOT+mX8XbMpda0RPCXj3hi4ouQ89xAb29s0kL7aSkKF38k0ICObdt2OSev9vzSq
         tXZw==
X-Gm-Message-State: AO0yUKV5MA4CFavWT11I46WsRgTmo8QfVQvtqnev5PuVgf/pihPsVZ6Z
        1T0SEHLPx1UppKrvYm7EIu0=
X-Google-Smtp-Source: AK7set/gEmMAoI2d2RY7inGv65qx0qY2mC+u7Ow/Fl8KS4cd1P8vvS3G17KHSjRJaqONW96MuV5zrA==
X-Received: by 2002:a17:90b:1d87:b0:234:e5c2:b92c with SMTP id pf7-20020a17090b1d8700b00234e5c2b92cmr1518112pjb.15.1678920180153;
        Wed, 15 Mar 2023 15:43:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a13-20020a65640d000000b005026c125d47sm3864410pgv.21.2023.03.15.15.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 15:42:59 -0700 (PDT)
Message-ID: <13bc86c9-fffb-1d5d-9214-1b03de131bc4@gmail.com>
Date:   Wed, 15 Mar 2023 15:42:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 000/141] 6.2.7-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115739.932786806@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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

