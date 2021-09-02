Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C823FF5D0
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 23:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhIBVuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 17:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbhIBVuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 17:50:23 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5397AC061575;
        Thu,  2 Sep 2021 14:49:24 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id i8-20020a056830402800b0051afc3e373aso4382738ots.5;
        Thu, 02 Sep 2021 14:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qC6fKub5RJ2+PJw7ZVQbjsoOe+0GbAzY7xfbjn1oJkU=;
        b=fKa/1adzwzNq77FpCt03gK8SXTsEP7PvupSIRRaQ2A8ln8J4rmniQLZUHwmFnDXzyz
         04EDyHc3FhjehicfIYDQXW6qrExBAm4+kAd7k8EurPnfbXg7NrhYy1FnDDnERj7bihFU
         OLEYumqQ5SrDKAIHVoGjGlfN7Jg+qt5G64ntugx9PrwItnTLe9xsQ0mywtrGQkvFm3gS
         3aHVDZ/Q0WRz3rkwpj0aulT2LPowfLJdGKb0ecdG0ilEhJTK1KqQNFVOPYwYi1/Iu8Wj
         fwJNsvfh3sNmzM3JXuxVOpAIPvEEKvmWvgktZpuDKRCASdqCoNQWXiMLlOMwo5mx7zCC
         8ruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=qC6fKub5RJ2+PJw7ZVQbjsoOe+0GbAzY7xfbjn1oJkU=;
        b=am6Y5u/0JtDLezy1oQ7EU/9WJnFf3F3TG8n2WxBgeIOZf1UoN0LCYtELtfWvE3YNVL
         8RzeuPMvrLincAweXoQnFgtwWeo+m7CcUG4MSm6gNAsWvU+8hiRm7x1K8B6aR5ljFJfh
         E19A3qzCc6/141A+q1FiFpQMng1y1WZIi9zAr/QBzLKb/EELBQLyN1pzg4c+D40kDyyS
         oeZYwHW1smHv/18gzUb3db1fLT1puqPF3q9PTpOg8GfgDKrII0uClkrOJphBDVsfAOU1
         yNl2twGv7G8OdPitYfEl1LYO93ik7+4OVUQC05KqfmOoMBTUEfG3TMIIn/XQ7Zy1j3gs
         gdrw==
X-Gm-Message-State: AOAM530LdeI3VqAR9tPma24BKeyS6+MI/JQstLAMY2fJmKKDv3TQZ8sL
        1swrRAqZk648FK4jUNFcj6Q=
X-Google-Smtp-Source: ABdhPJwyGFJyG2XYwbd+QeUI4tKa8PmQjxAkqGijNygqOhKADtsoJxSKFNgMPCMAakPNwbAOvZyBcQ==
X-Received: by 2002:a05:6830:2151:: with SMTP id r17mr290320otd.141.1630619363715;
        Thu, 02 Sep 2021 14:49:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s14sm619748oiw.8.2021.09.02.14.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:49:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 2 Sep 2021 14:49:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/10] 4.4.283-rc1 review
Message-ID: <20210902214921.GA4158230@roeck-us.net>
References: <20210901122248.051808371@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901122248.051808371@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 02:26:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.283 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 338 pass: 338 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
