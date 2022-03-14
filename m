Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01694D8E81
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 21:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245182AbiCNVAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 17:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234775AbiCNVAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 17:00:14 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDFD3D1F7;
        Mon, 14 Mar 2022 13:59:03 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id v4so15939102pjh.2;
        Mon, 14 Mar 2022 13:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uebP63qBgE1HsqzZ2Nav+rFX6ZrnHIUSLjQUsRg8b7U=;
        b=m4Ocdk70R5oSOBxjmi1r5qZ08bYFlC55b1+wjlQ94Rg3kWbhFYrSDv7syS1BpnmGiE
         dMGJc0UAAm0G2GXEwlXI5iWOmZTsx2l8zhSDr9PlEsA3hWdgWFu+VIuOfVNUxZtOGZfC
         tlHN+xjG0SiPu6GVHyjXBfpMOrY8kY1FanRlLI7X/8VEfY2nT5tBEOT7Iqqkx5XRA8s3
         8bPkdk9BLdR3hKjFHlNSESKknCjZcCDyfYQiU2yuMp/ynUsoSgD0l5GS8bk5kpFIuuKm
         ypmc9fl7LGL0W3JudLmVD4NXacKaAxnMi1s+4M4ThXL5nXpJu1rpNKz6kXPIYxNKob/Z
         PDkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uebP63qBgE1HsqzZ2Nav+rFX6ZrnHIUSLjQUsRg8b7U=;
        b=70I40IvMtAUQ4JyidK0zmudowtgIxjAtU9kgh1MnOiwU4Vp2+p1L25a3yhEB31s9td
         d5nmJgetvVBGVgvf1MzrRadMUEkJIrachzitbsNPouOwxgLvsbAseXNfNNzdHO4qOiTb
         sF7cmpy/3Jy8e58qGf01Y7Ff2CiDhDhc5AV1uhEmK/d6k7Ympc+TBW2LSxnv9imFij3Y
         7+7nkXhr5DC3l65w53l7SPa1fcO1POkWRCxzCdIjA/ZPic8y7Go0F1n3PxmUOp9z5WjM
         yhN7/jo6GdgegqcYSLcXByj/kZ+RudiZKBCJHu+ogX5nBRtnH2ySpTFIfqiswrBKfeDR
         n3Bg==
X-Gm-Message-State: AOAM533yA02p6n01B/clV/PDjb0Aq7x0aDqS6u3waDLyfZ/PWBDzN6wd
        9AWeqxaMr96Zp8jDbfAbezU=
X-Google-Smtp-Source: ABdhPJxIc+gc9zOUuNlyGQrm8QdWL5LHINDJQyv4IKVUsbTyM2PT94CDQWAP1Do24rYcZePTUMRxrA==
X-Received: by 2002:a17:90b:3117:b0:1bf:70e7:2543 with SMTP id gc23-20020a17090b311700b001bf70e72543mr1035916pjb.37.1647291542928;
        Mon, 14 Mar 2022 13:59:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 3-20020a17090a190300b001c61add3386sm374276pjg.35.2022.03.14.13.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 13:59:02 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/19] 4.9.307-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220314145911.396358404@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4c53c984-98e9-1289-476b-ade6b4ceb3b6@gmail.com>
Date:   Mon, 14 Mar 2022 13:58:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220314145911.396358404@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 3/14/22 7:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.307 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 14:59:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.307-rc2.gz
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
