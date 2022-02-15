Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E274B7707
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240580AbiBORVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 12:21:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242444AbiBORVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 12:21:18 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A4F1A3BF;
        Tue, 15 Feb 2022 09:21:08 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id qe15so17914383pjb.3;
        Tue, 15 Feb 2022 09:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OCLqAsQQSUQhD0m5JYw/9zd6UJoLhL6G2yE3q37RSqw=;
        b=YrcNdzwF726l2sTSsLu1/lKPLlaxn5IhP2/JGKx8Rbl7esZuxh8xQ5GVdHC6qS09LH
         ySlu8pivbV7JDAwwOLKXC3/rNH6haxRrOJCI20ZTrVqWnmchd1aXMctNnwwpQqWlAAhm
         JcXuEMRedNIVioLjUx/vRWfJqNYVPeVR7AHTop1xNbjP2Z+yRDPNqsR0447I2xt3YMx+
         yt/JWFVBHqrZ8Dzbkx91tdkvGrFBJCWBoFzuUz3rl/xWCyiTCsRQGJCqKKSM6S9KicAV
         00N6M1D66DXgfOkd4lXfzG0Vx9u3SNTafghgztHnEmymw/CkGV2IdUEONzwpFfVb4g/e
         Axxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OCLqAsQQSUQhD0m5JYw/9zd6UJoLhL6G2yE3q37RSqw=;
        b=DvTPLhRAxRF9C2Uej4MV2lIJVXTvPEBO+Jw2icaELOlfZbBTA1hWKndTLGqj0auG0Z
         a5NaPeEqtQgrBG4UBR0tPR2+yKz9XadhVOnn3sqUraUcHG0HSBlEkvAVcCSZCD99DU0U
         6Y8Nd3yrPxH4hHE2A9lQm+0xuRooXfHe879r4mpxi9Dq8oIofUckHYZTSf/u04JAt974
         r7BSxQHfc1UN0SYrgnv0BXIRafoi/0vN2WI0mdEpgu5yrYxOLj5wfCLCXlMN1zDwPQ28
         aNwUmnMzGfShiS7gtor8eGMgu5PehwGl2JzF0In4VbD2Fz356oJysKNWYOxzeYvP7TL8
         oeSg==
X-Gm-Message-State: AOAM532Ud9+iUqSX3GHIqZr6wlQtTyP7nt5xzMqYdWi/Eh41cF5+OfE2
        sSb0A0E76IE21GFpbks6WXc=
X-Google-Smtp-Source: ABdhPJydO6wRlpfxy88m6IuU0O5KOwZDdCkZT9fJ1rgZGvrx3d/1U7OGwID+nwXGTlxByal5ih1kSQ==
X-Received: by 2002:a17:90b:3908:: with SMTP id ob8mr5494916pjb.73.1644945667640;
        Tue, 15 Feb 2022 09:21:07 -0800 (PST)
Received: from ?IPV6:2601:206:8000:2834::19b? ([2601:206:8000:2834::19b])
        by smtp.gmail.com with ESMTPSA id f3sm42159084pfe.67.2022.02.15.09.21.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 09:21:06 -0800 (PST)
Message-ID: <1fa05364-0987-de8c-ade3-663fa206f655@gmail.com>
Date:   Tue, 15 Feb 2022 09:20:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220214092510.221474733@linuxfoundation.org>
From:   Scott Bruce <smbruce@gmail.com>
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
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

On 2/14/22 01:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.10 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Build, dmesg, desktop use and s0ix suspend all look good on x86_64/Cezanne.

Tested-by: Scott Bruce <smbruce@gmail.com>
