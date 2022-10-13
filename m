Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9F95FE372
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 22:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiJMUmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 16:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiJMUmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 16:42:00 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49C3169CCE;
        Thu, 13 Oct 2022 13:41:58 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id mx8so2047296qvb.8;
        Thu, 13 Oct 2022 13:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P67Ig1KIT1H4GelkmwJKtb5a2GWrJPPzXSHYlZCBmBE=;
        b=k9sIruKW8xYAFjOHFF4lDHTipryzUk/dQ477SVbZrQzzhpHuMR5DDXPWCvYIApYLZn
         PVWAFJZKfu0LTqbdK4UdROM0O7yEIIypgTkqBXdxlr3fdnavyFTcj0Af1aKnzuw9bTE7
         x27JU63qtmIkrI76r2bqiifzwaxAN+bkoZLh/7hD196abTBZ/9+rRACR4ktibXLbNsXK
         JbOuPExorLWJdOa37D3j0+17CIAlxbrZrAipTz9G1As8p5L4si1VXphko5ZIfNkgKNeK
         6QX12BHYdsySLAHSJ+avjlhznRzeXtNfImVHLALFMnagH9IQTqZhfVZILYGydZX6MDO8
         juXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P67Ig1KIT1H4GelkmwJKtb5a2GWrJPPzXSHYlZCBmBE=;
        b=F4ETTG5shqJIRPO9WrTn2rsSTKwRxSBMdu/AAwx9+sm+KXqDZA++Tzq9w5LWOnL0Hv
         TZvHvcpgyoY56PdM7Hh/rDXmlHOGxXRgkXvPUlXtVEu4gdgXu6l8bC2z9nE/rVx7yNOh
         VboK0GJ41n1nJRWT+XUZQseMr1b0xXxVoXMyPLNy5acVBew0D9Nid5GgfNJqduJDFNgb
         Ce3dXm5HQCczOplT6O+yUNO9XdAtl8W3mWJECQh3y4zTMUBox9Nv4zRUKvnIgFHFgbCE
         iHVUFpg/gA7ZtNvL2ml62wU4Bomsh1mXyLEucFJ/ok6nn8xkislqpluYGCh4Ce7B6urf
         MMUA==
X-Gm-Message-State: ACrzQf2CMeZwHi+EN6RqQpcxtHBvuZLxoRVPkdlTirOAoxcfpSYCewPB
        eR7otYdy98IBZp8eHNRmWIo=
X-Google-Smtp-Source: AMsMyM691GeLJ7MqYB2Tb6d1dpeY9hriG3NhoYkaRSUCBv3tAfQGsW/i/X9IGk1jy3dbAJ9ltibFdg==
X-Received: by 2002:a05:6214:c6d:b0:4b1:c751:ac7 with SMTP id t13-20020a0562140c6d00b004b1c7510ac7mr1679670qvj.96.1665693717952;
        Thu, 13 Oct 2022 13:41:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k19-20020a05620a07f300b006eec09eed39sm559063qkk.40.2022.10.13.13.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 13:41:57 -0700 (PDT)
Message-ID: <80068dbb-4dcc-7ae3-d33e-a2a68034287a@gmail.com>
Date:   Thu, 13 Oct 2022 13:41:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 00/54] 5.10.148-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221013175147.337501757@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/13/22 10:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.148 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.148-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
