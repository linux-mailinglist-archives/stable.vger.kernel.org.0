Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED23E3CEF9D
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 01:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350781AbhGSWSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 18:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387352AbhGSUGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 16:06:06 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74532C061762
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 13:44:26 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id o72-20020a9d224e0000b02904bb9756274cso19554323ota.6
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 13:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E8EfZXygkcAJObBzvlKxq2klHRac1L0O2So1MZeLDB4=;
        b=u/r+8uPdtVJp64B2C/X9bW7JckUmpB1JNKZg4v3aivX04D41BDvavFNsHhxn6x48R9
         +Vm9h1YhhR2mWa6ODz85ZfPUFfYOC5MOmpIlxxxZDq05Z5GWFXYShoqrcbOLclsX1sk9
         6QlKIyekoXjxNLlfZu7OVZZ9Ho60DG1/IRBHjj5wT2UJUcBt8EEob+MGyAyANbFR9iym
         0p0OsreXNfBHWdqX8Y0wsGCiZfSCzDUbOONmhbd/blWIHy1VbXms6KahjEdXMjnHJ4iF
         9E7xyumk4BGtmBbbkg7Fj4JAKAUCJkSTiR+vgncIg9n+L5DJRcujjo4KJM593Fqmlw4q
         EN/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E8EfZXygkcAJObBzvlKxq2klHRac1L0O2So1MZeLDB4=;
        b=rdxBcPBwj6gfTsLXBE/0B+QpBbeOb3nckAHKrwOsgQrMO+tl1twBHpdvDfXaAkENSu
         Mmwnd4T1I/n3ab88quyHbhcTyT3SGmnWzsyqQKvtcEds9yReesN0W0Qwgzp0Gywfi+F8
         JC6TYGxaEcYiBU5Pymlz0BFlsNeXPTewIq5psE1YA5DC31EpCiYqNQ/CcvSwq4QjMYdK
         Tj0lCLYZ7d2oksIZK3X8dTQj30Nfmcxg+cVl5xlnknkcZ7w0IRyZ9o7axggtdxoxKQPX
         Eof5T9ydRibRIq5ELzY3VwpW4nQ8vB5zd8nR6YiXzKZ7gBB/+Y/9xmbj7Tbu2K0BcN4l
         IaMw==
X-Gm-Message-State: AOAM5312+wpFnaZElovGzKsudJfvsX91oQXvycZRNa5DE9B5NMCa7tw7
        ksTm0LfKogPGwwP2RS4ysCiHwg==
X-Google-Smtp-Source: ABdhPJzZ22wLbukWtLkUEp0fU/dP6p5xdwlhUha8T8MuxVQLS1LKQraJ/L0Ywjr+CmsE0XtFGlpKng==
X-Received: by 2002:a9d:6319:: with SMTP id q25mr4903547otk.272.1626727597048;
        Mon, 19 Jul 2021 13:46:37 -0700 (PDT)
Received: from [192.168.17.50] ([189.219.74.83])
        by smtp.gmail.com with ESMTPSA id s6sm2770409otd.6.2021.07.19.13.46.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 13:46:36 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/148] 5.4.134-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        linux-kernel@vger.kernel.org
References: <20210719184316.974243081@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <3d770ab7-5008-cbee-98c1-101d839739cd@linaro.org>
Date:   Mon, 19 Jul 2021 15:46:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210719184316.974243081@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!


On 7/19/21 1:45 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.134 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.134-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Perf fails to compile in 5.4 on Arm, Arm64, i386 and x86 (GCC 11 and GCC 7.3):

   builtin-report.c:669:12: error: 'process_attr' used but never defined [-Werror]
     669 | static int process_attr(struct perf_tool *tool __maybe_unused,
         |            ^~~~~~~~~~~~
   cc1: all warnings being treated as errors
   make[3]: *** [/builds/linux/tools/build/Makefile.build:96: /home/tuxbuild/.cache/tuxmake/builds/current/builtin-report.o] Error 1

Greetings!

Daniel Díaz
daniel.diaz@linaro.org
