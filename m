Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279BF42FA9D
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 19:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242435AbhJOR75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 13:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237652AbhJOR75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 13:59:57 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE2FC061762
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 10:57:50 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id r1-20020a4a9641000000b002b6b55007bfso3253006ooi.3
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 10:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7ZGon4E8dSNWz8zPVVd4qTwSTJg6X7vbKHakOYUSXlw=;
        b=xVjIrZSY1ag4v/ZBhceOcmQPenpzdo3t1prFDjt/fGbsKpEG3DCwePoR5FT51zLL/Y
         U2FKdELYTirUdSrsZMXbnirst5GT49118+Ttxk3cAqm/9mD1Znu8+GQ4Izni3oE/3ZBr
         +shxCn6al5v0zALGnP+KrnTHD0opfhaMVFXNT3QPrUMXKRx5qzAQ9XbUpNHzDpau99Mc
         OD7vg5ofO+Af2bJ7F5n19LF+rsJ4kTU/ROy6VirZ8qh2siGgQZMMemrhEvTvASV62vTA
         OmyWnZ1sA5iU819zWoSm4MTxiZ9gg8Db0cv0MpSVP+XkmtKS92VzwEfwttEGWyRiWb1U
         kC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7ZGon4E8dSNWz8zPVVd4qTwSTJg6X7vbKHakOYUSXlw=;
        b=MqZxN6wH/ppfFsn/GByZ23W/0O8OkxzFAUGE6OM3aiNlB0GR/TW6WlnfwOwHBK18Fv
         vbrDdHfNIwFujL05QDdw2aYOHE1skGxiOV6+LWF2EB98qg6fyfdoCUm+XRdDQNDdXOwD
         RDBiS+h4rjTfR160AQBn74uBj4ehMulv8tp9Cmq2I9MAQc00AnwA7wKGAdgDOJanm1qh
         D+valTDQ6Vzew+ZPz7K4AMeyw1rn0nAWjDNfbWZ3PTyPIKjdHWWhjtVKrtIA5UqgU7Xg
         7mGw7xd2gIk55/GFvWpMR1b5jhUuongP+OZq43ZCBvH3hev9BWIGoIfrCnhTVsv8WKJd
         WUmw==
X-Gm-Message-State: AOAM531Jt7L9AqztwV6FGsVUHIMkU9mL8wuQtBAm9cH96gUoZwSnZ9+O
        nxR75sWXQICPbLbGCZqEXd9bvw==
X-Google-Smtp-Source: ABdhPJzaqufkmD1MuButXMwA+z+yrJMNNHo8oysa/oquqHG/SC/na8Pa0W8jjLdFtlg12OCfWHm70Q==
X-Received: by 2002:a4a:d5c8:: with SMTP id a8mr9560596oot.18.1634320669915;
        Fri, 15 Oct 2021 10:57:49 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.72.19])
        by smtp.gmail.com with ESMTPSA id v5sm1329020oix.6.2021.10.15.10.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 10:57:49 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/33] 4.14.251-rc1 review
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20211014145208.775270267@linuxfoundation.org>
 <e1379685-c2b7-e7d3-8829-3a9db2e53bf7@linaro.org>
Message-ID: <1ae5fe8c-598f-8c78-2ee3-24fcdd566c9f@linaro.org>
Date:   Fri, 15 Oct 2021 12:57:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e1379685-c2b7-e7d3-8829-3a9db2e53bf7@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 10/15/21 12:49 PM, Daniel Díaz wrote:
> ## Build
> * kernel: 4.14.251-rc1
> * git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
> * git branch: linux-4.14.y
> * git commit: dc0579022db410506fd874cd458c580df7f09db3
> * git describe: v4.14.250-34-gdc0579022db4
> * test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.250-34-gdc0579022db4
> 
> ## No regressions (compared to v4.14.250)
> 
> ## No fixes (compared to v4.14.250)

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Greetings!

Daniel Díaz
daniel.diaz@linaro.org
