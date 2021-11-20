Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCC4457EE3
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 16:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237496AbhKTPYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 10:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhKTPYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 10:24:16 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17403C061574;
        Sat, 20 Nov 2021 07:21:13 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id d5so23685809wrc.1;
        Sat, 20 Nov 2021 07:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CyM3+eJ6aCtIacq87VUybJ0cUWuQiHmdVvSz9Qi8v8s=;
        b=CNQAcXJ4z8SdArb9OgLusWsevmQHhW+tuboXBc6JnNgu86F027TOwmxWz6183a9F5v
         Lbg8p4yRRnwPTgTcQ1dZZqC9CoTuPdPOZf5gVkHbTYyoDHT+gs42lVg0XPsb6QoqgzkF
         vwTEILg/ALALrvd2GSfdATnqFJQ+d9vIXSi9e2MxRIwjD4zbBkU4yS266sjjmBZH2ZvN
         CpodapjdlkXXZTog9TUJMWm9aJHX1NTuMf1wNyLXONPaD9YQEWsX763pFdGyz0jVFMW/
         zwlqhf7ba3qwNTbpEni/G94wx/NcW/Kh/MKEFPyxC7eupl04BxlFtIdnrVqf0ba27yoR
         bZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CyM3+eJ6aCtIacq87VUybJ0cUWuQiHmdVvSz9Qi8v8s=;
        b=JDxeXWekmrnmTPmMnHna39cXOLMZ6mMunOZTjo/5ldnHPI+H6dQB34gYIoIU6myv9V
         JPcs1av0gGB8u+IUbYQ0ph5pxyPvSFOlM5P02IyK/sGp6IjUxqxu+QKdJDCmLmZlDZSg
         egoA7aRBQ1tvFVvZJsGCJiYLcjk9VC1KAOKE8fezhQXMNsE+fkICRt/BprFfi+2hRXmM
         yZQ+cmh5knwJBgOKBD+8H1gMiIWCuSbMDlPixpYxQfU4ulLRdsrqHMyWefRtBPbMW2Z1
         5iKyhnQTYxACCy/axl521sH4dwWru+hHVLKqIH87iAPNkw/QONyqdVzKQmJ/cSSC68SH
         WMwg==
X-Gm-Message-State: AOAM530ojb8Y75jHPyyCgMZJSpsyoOgJh9Y8bSiIYv5Dq3JhrgvpzW5t
        z8LI0d76uB1HWp15qf5uV78=
X-Google-Smtp-Source: ABdhPJys0Fs9mVGxnNnEGUHfR0eQm6JUHSXf3yvQ45uNMJHUZ/bPMj7ze7/j5yj7jTnetGgWC5povw==
X-Received: by 2002:a05:6000:52:: with SMTP id k18mr18199747wrx.192.1637421671581;
        Sat, 20 Nov 2021 07:21:11 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id f81sm17254100wmf.22.2021.11.20.07.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 07:21:11 -0800 (PST)
Date:   Sat, 20 Nov 2021 15:21:09 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/21] 5.10.81-rc1 review
Message-ID: <YZkSZbBIv7LHQ1DW@debian>
References: <20211119171443.892729043@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119171443.892729043@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Nov 19, 2021 at 06:37:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.81 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 63 configs -> no new failure
arm (gcc version 11.2.1 20211112): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/410
[2]. https://openqa.qa.codethink.co.uk/tests/409


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

