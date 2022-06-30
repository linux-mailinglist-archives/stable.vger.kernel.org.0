Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733195626FC
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 01:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiF3XV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 19:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiF3XVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 19:21:55 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B26559255;
        Thu, 30 Jun 2022 16:21:53 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id n12so877147pfq.0;
        Thu, 30 Jun 2022 16:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4fwRruBH61EbutyJBh3f6DOQd9ertsIzMrVniuscmw0=;
        b=Lo13YwMcypIrm7RVyO1ZiITAdFwfYQI85MCzyAEu7lpvhtHcI3oMrf2ivyIfV7xA1k
         BX7FxP2foLMm5odq0M2DzWPOQ/4gCanIm/QXND9e4NzoyYAcOeZH46xKH31eKEUaAa6x
         B847hfjs234ErnOhwakAuz9PQgbcGRANyHFLoOzEG2lDH27SZDOSmb1xG29yfqoq+4M5
         b7Ry0zjPfTmF5UnosGNAM0sddFAAubfoJTwaKXaxIkM1yB3rlurUNupwmtmCUTcmQiH8
         RnraOSQcmEOFeeXfxL6g4TeHpgl+o14vzeeb1EyS5hXeW2wXgdELkYPV4YOsn3c95p8C
         ysqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4fwRruBH61EbutyJBh3f6DOQd9ertsIzMrVniuscmw0=;
        b=Gtl5URSfO0Ktj2mkf0rvdhuyiXDrF3C/yt1N64CcRzwM8fIK2GpS0UpcgglmznRibt
         WyAyH0Ljh3wzxszvEaDDCcadN34D1o1Vw2AnZJF5b6vCatG4TYfiFViV5dH3H3SZJYWJ
         /ONviO+k3IGtIsowYuEcQBRd6rXPwT52BkQ24CM1VaoVe8it4VecOygqwZFothFkf4oz
         QM+D+GhxgBmos+L3pt4Dxoh9ssx5EBtTHdnm/IejAVKBGjR/o/kUt0hSCRWbegXk+X+S
         nTCz/5JpL/fMfipWf2u65MoM6kQEiQI1v5Jx2CGgbezTu3P72qgcYZAPMfBfd6th+BF0
         mJpw==
X-Gm-Message-State: AJIora+4Tcl7XcWhbJ1vYQxc38TvRZtpK9l9Ah2X9qhzQ+Ns3Pyg+zxr
        IoJISOLUZQzZso7OmKmoUUU=
X-Google-Smtp-Source: AGRyM1vlGXSOmdxpAUzCunPvcbte4At4Sx1yPPcdqYLGItVQGCkSDVDVeNTOiwj1LIAFa/i+1CXLdQ==
X-Received: by 2002:a63:f413:0:b0:40d:ba87:53f8 with SMTP id g19-20020a63f413000000b0040dba8753f8mr9736805pgi.193.1656631312602;
        Thu, 30 Jun 2022 16:21:52 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id f8-20020a170902ab8800b0016a0bf0ce2esm14078877plr.92.2022.06.30.16.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 16:21:52 -0700 (PDT)
Message-ID: <73867ea2-9db4-4e52-62d5-be37c1fb171c@gmail.com>
Date:   Thu, 30 Jun 2022 16:21:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/28] 5.15.52-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220630133232.926711493@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
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



On 6/30/2022 6:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.52 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.52-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
