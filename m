Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0D0572A15
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 01:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiGLXwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 19:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiGLXwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 19:52:20 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A496C1FEE;
        Tue, 12 Jul 2022 16:52:20 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id o12so8791987pfp.5;
        Tue, 12 Jul 2022 16:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WcUK13ArPvOKPa7YPG08W3GgydZkwmrN2WpRmgaVZqg=;
        b=UdYjYnL5jl2vwQXQ6jhEHNQL6SEPmEpJ/8dvCT/RayBDlI5kF9cDAZMOdWzFqO2vZz
         R4Aa0pR1RoEXPh2YL0ywcWW0RkhimvC/Uh/81PrcCWbRd0FGGiteTxPUo2J4SGj74TmD
         IL+TtSIzDCfy4UeEF/bJDFOAWlhgmlSS9MpY6392vly/McZ0mCFUlHyuv1n+60DR+Usj
         +6AlbOBlmhBEuBKOkSQUkAv0zg2IJz16XKT1lVf7dX5PvWEgfXwratK8CFVcTfSkGA0j
         W96bmqvqI5afZNJmtekvCngXr6rHn3YllpSBtNNJSPrAzzBGLaQS9yPV4XUCjohNFebn
         b+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WcUK13ArPvOKPa7YPG08W3GgydZkwmrN2WpRmgaVZqg=;
        b=qyXpLbdmEcpp5ZhqtjW9KsXbblwpi2dAqCUNddKjg78YLzI4Wx8U44SrS+/WaahCZX
         intUvJ5iVgf7YCVeVDPpmMJEqlfm1Irzgfd+TkV476Fq11LBQUjxdrwt3Z2RJR6JIh1/
         9eVLqlkE6GoPankc8avuXaeVmBTy0TYRANnv0dYBPcm2KVk/Qr0d362y9kPaVTa0oGcp
         0v4fpcuMip05gPLAb6SEoMe6r6RmUUj4Xa3j2zK3fyzm4XQkRTrzUIX3n1kspUyip4pC
         4brvS3DlZaE+M49l9nD3++jzu8aEzCdtedEEvMhFUDL7vDrbo6juNcIW5bKG6pxq5/06
         Mk2A==
X-Gm-Message-State: AJIora+MMEB+2RRFA6KL+ONlkjTbOJbH8ib4mQTZO5XCOAbvDxF4o0sM
        xx6AP63vgumgrH3Yf73lnl4=
X-Google-Smtp-Source: AGRyM1uckNbQJLW35RcZ3BcyUMhJnBhxic9wep+cBSqeeT+0uPfGbLU5BdvV19H3LFiEr+dlvyX/1g==
X-Received: by 2002:a62:1508:0:b0:528:be70:2f69 with SMTP id 8-20020a621508000000b00528be702f69mr412868pfv.42.1657669939720;
        Tue, 12 Jul 2022 16:52:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d26-20020aa797ba000000b0052ab8525893sm7588470pfq.142.2022.07.12.16.52.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 16:52:19 -0700 (PDT)
Message-ID: <0426f5ff-d254-c009-3ae4-29efc362ad95@gmail.com>
Date:   Tue, 12 Jul 2022 16:52:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.18 00/61] 5.18.12-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220712183236.931648980@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
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

On 7/12/22 11:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.12 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.12-rc1.gz
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
