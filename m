Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06F84F543F
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 06:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392293AbiDFEql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 00:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1840880AbiDFBNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 21:13:36 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613AD238D3A
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 16:06:15 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id k25so989687iok.8
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 16:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P36/6Cm2aQZzffVwQ5KNbgPy5Yv4/2dGZXsphP7/mZ4=;
        b=hmS7OssYUcHwhlhF0lDCYYCxSJRS79RnmddgJ/ElRdFdz9WdSe/MgDkE8ayOScIgyk
         PM0CzPfRZseVJj4VgtyTiD9iXKXwUMrFCgVshefzF0uRG2mIY2DWPQnX0qPT9Z2ft6SQ
         KiHy57MfYcSLe0rPB60or0hcg6EdlCJ97Mdic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P36/6Cm2aQZzffVwQ5KNbgPy5Yv4/2dGZXsphP7/mZ4=;
        b=2MHoz+2fLor6KQlg63a1TIYt+tSNHXAT4tZqvOH2JLF4pcWf3ZZ0zZXfLwWHNlhPA3
         TQtSXawnmhMbK+/0XoQVnEJETQ0zd7c5GRuhzp3JeBcfkEWs0esrg91MqZ5xs+r4efXn
         TMK9Xi2XGU/OlQ+6+NDJ0wYuux6a6w0HMc2hielk/rxQE8q4MDVgeq8lpVJyu6UoT+V1
         KmIUvflWoXJKmfLNfRiLbP15wd7D+bTYBFuSECDw+jHREbpy9RcfYbsQdYWv/7u3Hkl5
         PLbVsMUaWewRN54uHZc8sFI8lxrlmGu16LIcedqY6RXBK6i8vYKEmgGRlR4Ag63EiH05
         1IOQ==
X-Gm-Message-State: AOAM532InaPO+95c80232d383aku258c092QrfVzDwn0uPh12IYkhUvy
        U+fzNPBSTb2901iGxE2UGswbNg==
X-Google-Smtp-Source: ABdhPJxNUfELhkIpw4ON8hQdXt0ICPym3zJ9+ujU70u7aRXxj9OaDhXrYcPQ2dNPWcNnecH3RP3Rng==
X-Received: by 2002:a05:6602:2d49:b0:645:dcf0:3151 with SMTP id d9-20020a0566022d4900b00645dcf03151mr2776873iow.61.1649199974622;
        Tue, 05 Apr 2022 16:06:14 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id k3-20020a0566022a4300b0064ca623b65esm9968404iov.4.2022.04.05.16.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 16:06:14 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/913] 5.15.33-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4273d632-9686-3809-2ef0-e87bb431f798@linuxfoundation.org>
Date:   Tue, 5 Apr 2022 17:06:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
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

On 4/5/22 1:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 913 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.33-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Build failed on my system. The following is the problem commit. There
are no changes to the config between 5.15.32 and this build.

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
