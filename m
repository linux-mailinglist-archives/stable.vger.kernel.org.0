Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8834F542C
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 06:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbiDFEjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 00:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839973AbiDFBGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 21:06:38 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7579022C6E6
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 16:03:28 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id r2so969756iod.9
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 16:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N0y9mPPrZg6yPHcKPUn9Zg8uBX7ANAqy/SfmEM9BLO8=;
        b=ZS8LSatlk0Ep53N5/oKPpeXUMUkZOptah6fkZ3QeP5kc83dLgfWUw7ISjE4UjuV/sa
         lov+jlt+y42x47tmHSGjdccwZFT6M+D2uI48DK4JblhLBk8/wKA2FEQhrc+rg2rR4jy9
         sZ5O8TiTOdeyx0D1ObhsU2sZhfS6W6LvLhZAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N0y9mPPrZg6yPHcKPUn9Zg8uBX7ANAqy/SfmEM9BLO8=;
        b=NCh9dqSUUYMTfKufsm9Zdl4MFb/IoEoe+7yko+k5IjCC68t+2LM86XRzGBz68b6uGZ
         hT+FhnI00F/wknfkMfxkA1JcZJxFRlljg6h4jRZAkUfPuXgqo4UJLN+/xokeOmQJ8z2C
         tB6CYuipCOlr/jz9GCh9ng0LNWS8w2Nteub706ztuxQMdh8JnMnib87isQT9LJ36AZ7W
         jdmvr6NjigX5xL4vdLLV6j3dQ05PargUoUq5LXHakAjYGtUYIsoVGya5eDHA3ineZLTf
         t/b9v++3qNXtOmfiHweJktFwRo43eQsuhPygLdkNE/zVZUQf8rOIu21+iVW2+TazEwzG
         eTiw==
X-Gm-Message-State: AOAM5323BWaO/5IggtHBq7mbTFLeF0Ag1yfpvfXVaahKrNASGzcD2nk8
        YTSu4ERVwGTMTdRFtVGuc0jInQ==
X-Google-Smtp-Source: ABdhPJxe4MvqQAfJPT5x3ciMDW8nLtoufRWxOssNG42EjM+bAA6b1OAj52zwhWlrGR1nibIbj2L8mA==
X-Received: by 2002:a05:6602:2e10:b0:649:e2d4:3334 with SMTP id o16-20020a0566022e1000b00649e2d43334mr2729846iow.210.1649199806459;
        Tue, 05 Apr 2022 16:03:26 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id d14-20020a056602328e00b006494aa126c2sm9085976ioz.11.2022.04.05.16.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 16:03:26 -0700 (PDT)
Subject: Re: [PATCH 5.16 0000/1017] 5.16.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9882445d-ef29-689a-33de-ce66dfc79d31@linuxfoundation.org>
Date:   Tue, 5 Apr 2022 17:03:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/22 1:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.19 release.
> There are 1017 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
  
Build failed on my system. The following is the problem commit. There
are no changes to the config between 5.16.18 and this build.

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
     ASoC: SOF: Intel: hda: Remove link assignment limitation

   CC [M]  sound/soc/sof/intel/hda-dai.o
sound/soc/sof/intel/hda-dai.c: In function ‘hda_link_stream_assign’:
sound/soc/sof/intel/hda-dai.c:86:24: error: implicit declaration of function ‘get_chip_info’; did you mean ‘get_group_info’? [-Werror=implicit-function-declaration]
    86 |                 chip = get_chip_info(sdev->pdata);
       |                        ^~~~~~~~~~~~~
       |                        get_group_info
sound/soc/sof/intel/hda-dai.c:86:22: error: assignment to ‘const struct sof_intel_dsp_desc *’ from ‘int’ makes pointer from integer without a cast [-Werror=int-conversion]
    86 |                 chip = get_chip_info(sdev->pdata);
       |                      ^
sound/soc/sof/intel/hda-dai.c:94:35: error: ‘const struct sof_intel_dsp_desc’ has no member named ‘quirks’
    94 |                         if (!(chip->quirks & SOF_INTEL_PROCEN_FMT_QUIRK)) {
       |                                   ^~
sound/soc/sof/intel/hda-dai.c:94:46: error: ‘SOF_INTEL_PROCEN_FMT_QUIRK’ undeclared (first use in this function)
    94 |                         if (!(chip->quirks & SOF_INTEL_PROCEN_FMT_QUIRK)) {
       |                                              ^~~~~~~~~~~~~~~~~~~~~~~~~~
sound/soc/sof/intel/hda-dai.c:94:46: note: each undeclared identifier is reported only once for each function it appears in
cc1: all warnings being treated as errors
make[4]: *** [scripts/Makefile.build:287: sound/soc/sof/intel/hda-dai.o] Error 1
make[3]: *** [scripts/Makefile.build:549: sound/soc/sof/intel] Error 2
make[2]: *** [scripts/Makefile.build:549: sound/soc/sof] Error 2
make[1]: *** [scripts/Makefile.build:549: sound/soc] Error 2
make: *** [Makefile:1846: sound] Error 2

thanks,
-- Shuah
