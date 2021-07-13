Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472AF3C6F26
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 13:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhGMLK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 07:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbhGMLK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 07:10:59 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3152C0613DD;
        Tue, 13 Jul 2021 04:08:09 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id g8-20020a1c9d080000b02901f13dd1672aso1465914wme.0;
        Tue, 13 Jul 2021 04:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=drfQwV7z7AQjhXKnfErNYK6DBLE0YIGe+wmzQzWXqB0=;
        b=bpfFt8gKZC2rBuQfnUWTQQ8r6nfRO3tnaBgTKh82NMVElFhA6Fk1/l+f1JJBeNSyWp
         28LOJLAevMizVSzgRbIEQ9kwXRUNzrlLV7arq1mSIDUstypHaRCxlkkckZNGnr7CM+e4
         kLVstkWxQIUsIb+e+vOxHM8yO1knkqUh+Qeh2BS0uLtLj4IALBwY07KrwMECYr9cQnt4
         EFPfPiwO8IiMZDc/fpu0fRSqxu3wQsP85tO1JJQIKByg7HlIWHszz9iqOWQ+R/gDPtZa
         Ys6LXwaMNoQa1YgImZxm4Mu5E1cnLGfTYppHLFt6Fhc8ZeGkieUbtxKIOTYZKI8J4qzf
         btGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=drfQwV7z7AQjhXKnfErNYK6DBLE0YIGe+wmzQzWXqB0=;
        b=GXRdqCZRGv41TncAxr9RFpbCSeqHq9jE/KIp4fFKEVXOYIvYtt+ERtkqy6yeI4tXMR
         bj9ma/hm92bsHnQ/LHVLZj2Rp6hqMkaH0/KAwNxEPfP3IWaQD3hx01Abz1sRY2YJAY+3
         8n4NCAs/+APvo8ve7S3BdqFjJbtBGSlQiy+ByDWpCmsbFcfGTkz3aQsFWBv3NA4Fy/hx
         /JN8KkwexdNkK2c0furPHBzhnZVck8oVClZ5oaypnJ6OH9kN69KmdcWoqGpp2ONsb0bC
         iBNhPaQg0B6GXHPcoK9wdFKqIDN0SZbzud9+AVbstgoGrKSSoznoC8ASmcZz2tfI4os+
         ezgg==
X-Gm-Message-State: AOAM532dON5XPz4d+OtVon/gzDShiA57PSdNYE30ibJVINFCDnmb6i8N
        2zdRFuErsov+tcr3OosmVQM=
X-Google-Smtp-Source: ABdhPJw3muOVR2FbiF/ZWG++qqbHv7mXFi7TXbaPNfcp6VL+3LePaRE7vBruqFLfq/iGYa/GVzTkrQ==
X-Received: by 2002:a05:600c:6d8:: with SMTP id b24mr6132220wmn.111.1626174487512;
        Tue, 13 Jul 2021 04:08:07 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id g3sm13988938wru.95.2021.07.13.04.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 04:08:07 -0700 (PDT)
Date:   Tue, 13 Jul 2021 12:08:05 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/349] 5.4.132-rc2 review
Message-ID: <YO10FeaBoAqls7Wv@debian>
References: <20210712184735.997723427@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712184735.997723427@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jul 12, 2021 at 08:49:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.132 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 18:45:40 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210702): 65 configs -> no failure
arm (gcc version 11.1.1 20210702): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210702): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
