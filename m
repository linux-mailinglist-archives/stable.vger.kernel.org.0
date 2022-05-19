Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B8152DB70
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 19:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242656AbiESRiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 13:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiESRiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 13:38:07 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27E02BB02;
        Thu, 19 May 2022 10:38:06 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q4so5393301plr.11;
        Thu, 19 May 2022 10:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tHBBbvRaF6oFKmuZgff/GxeONvz+9wd3QLPeFFN9ygs=;
        b=gPUhIScuVgC4qBmdrBgidXotdk6hKmwevrJeYzJxNv63jRaz81rdU/Olqvah00HRjP
         QdQzq+9WbqrHW3Xx6ROJnoIYqVpz4NRwHYXhwJdFAv3qrAAYoMcgx6JKuqYTuGjhQsV7
         07065qR/fz8T1DsK8uO92bE61emc26XHZca8AElpg3/pMDJXvBY/BufmmrrjNvFduOvy
         Xzfw1Bhhfb7JjhulC0+uijjfRRy5Adu0EuOHZiwGUGL215fmF43qnQ+6lMDkWOaRIVPE
         7HLewh0+rKUOE3xmS5V784l2ZnkODE2NS2/0tXn4K1Jk5B94TFeSvMTlrb7Tv2EHSDmu
         dM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tHBBbvRaF6oFKmuZgff/GxeONvz+9wd3QLPeFFN9ygs=;
        b=xxj3POihrptOpQxERueMBSByHB7gz2IehGPQAyJrrQJSZ7824QPSdm/La2nznwII6e
         Cw7nk9UYOgQzpftZKaEJN1/SC/fZkocKsNLWSSRaBCpV7iY/+k+SCv+9XHozYt04QvtQ
         piYnfJDgd7VT7ywwP2us9Wdw29bzGWG8oZaDh9yYeU7zkllg5ShsRMztermqH1M314cS
         plF8wqwr6ZVW8eZWPOfKbJXeZhUA+SlgAITOMmt8cr2XnaOoiPvlnOhp7LatSV93afy/
         RYXmvEMjfJ2NbXNWUC50JhNGFvHGbLepinUFWl37HPnVe9P0clOe03gN2owVHddcGjgq
         /uAQ==
X-Gm-Message-State: AOAM532w1/M45EaWHA7xxIpg6uOIeeTu1A1s2q05pWmouBltZSWNMzvT
        rdtwykpj2TOQMnRr8xHlF8LmtBOD/3Y=
X-Google-Smtp-Source: ABdhPJztFnCPmZyv5jZdF6Kwpn+4ehzbqtUj7g4loL0rAyBjt/29zYWlBZhmMUDgRVQB58VH5DMDAQ==
X-Received: by 2002:a17:903:d1:b0:15f:3277:fae with SMTP id x17-20020a17090300d100b0015f32770faemr5910867plc.69.1652981886045;
        Thu, 19 May 2022 10:38:06 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id k3-20020a17090a404300b001df1d56071bsm73182pjg.29.2022.05.19.10.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 10:38:05 -0700 (PDT)
Message-ID: <1392eba8-d869-aa1a-b154-cec870017115@gmail.com>
Date:   Thu, 19 May 2022 10:38:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH stable 4.19 0/3] MMC timeout back ports
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        =?UTF-8?Q?Christian_L=c3=b6hle?= <CLoehle@hyperstone.com>,
        "open list:MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND..." 
        <linux-mmc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, alcooperx@gmail.com,
        kdasu.kdev@gmail.com
References: <20220517182211.249775-1-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220517182211.249775-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/17/2022 11:22 AM, Florian Fainelli wrote:
> These 3 commits from upstream allow us to have more fine grained control
> over the MMC command timeouts and this solves the following timeouts
> that we have seen on our systems across suspend/resume cycles:
> 
> [   14.907496] usb usb2: root hub lost power or was reset
> [   15.216232] usb 1-1: reset high-speed USB device number 2 using
> xhci-hcd
> [   15.485812] bcmgenet 8f00000.ethernet eth0: Link is Down
> [   15.525328] mmc1: error -110 doing runtime resume
> [   15.531864] OOM killer enabled.
> 
> Thanks!

Looks like I managed to introduce a build warning due to the unused 
timeout variable, let me submit a fresher version for 4.19, 4.14 and 4.9.
-- 
Florian
