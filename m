Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D016C3FF5D5
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 23:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347541AbhIBVvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 17:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347539AbhIBVvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 17:51:07 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E5EC061757;
        Thu,  2 Sep 2021 14:50:08 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id k12-20020a056830150c00b0051abe7f680bso4370824otp.1;
        Thu, 02 Sep 2021 14:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nUagDyENuPFWDSd7z4DUrfuwlfAnluvZDZVrgJZ0pUI=;
        b=DTfA/SKYRAzt8FvRwG0zGHx+wXKzneP5cBa2HsbrhPRe38sdnmPwU1ywHkZ9RESqWQ
         ExFJqKTLvZCms9mwDBMZLxP0itF3HqYKQH4qxX6JF0g5uSVg0ibrzoRhmwevJdJdc9KK
         vhhhB9EC6ksBtkWGeMAdmpUTfDl8h6YV6E1tvTOXyKZIUtN+MrdZIfKMEvy5G1tkHy09
         2IMFiPrk/q1Sa3z+kW3w9irXWvSAUbj57nGlqNNl54aOVmHtFQOYHX9YtOcrAfuGzdFQ
         3RwolCDx7PpFhgO/Oi+tNYaoy6/FgJMq5D/zlutPLzmyBR75/MFGdxzT5XPN3WG1MQsj
         el9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=nUagDyENuPFWDSd7z4DUrfuwlfAnluvZDZVrgJZ0pUI=;
        b=kW4E7Cxyf+T+CGRi59auoS3drOlRplywEXhwcmd3+CV36VFsGv60KpnZJswMwgY5gJ
         EanMFYd/p9Y8szgTv2ZdJYiihUZJC/Eke/PMTIcruvy7I0laRSxv1Ib1KZUfBoMz0zMT
         iKwNW3JObv1qnfsNc+wtQGoPbnrfVa8DMeVloHLpYFOdUrDGtFv1FAt/EmcRsR+lpr6w
         ALTE5Mr+GfuZNSbNloBZxSVSHEL2QrmBFxtUVnc2MyX35eYTcZph8SwcwRQGC6IHjOGk
         SDNFy298CvPMtyJ0xmn9prHP8CoMKTiCpQQynbBPBHnR5Mbyr6sz1rX/Icmolygv+lkG
         yjpg==
X-Gm-Message-State: AOAM532VbI9L/49KnHlHdzpSRrE1/ZWmzxXSF8F/kKtCeEo3fyh741T3
        D74V6IBKPSAJyQ5vAtusf3Q=
X-Google-Smtp-Source: ABdhPJwKNvx6JiVB+BSp45Iwn3ZmgANkAjwHP7G9nbd2CbpS+t1j/XFvC9aNGg7+gxgYPMVWp3Ad1Q==
X-Received: by 2002:a9d:719b:: with SMTP id o27mr283061otj.257.1630619407710;
        Thu, 02 Sep 2021 14:50:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p64sm629767oih.29.2021.09.02.14.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:50:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 2 Sep 2021 14:50:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/23] 4.14.246-rc1 review
Message-ID: <20210902215006.GC4158230@roeck-us.net>
References: <20210901122249.786673285@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901122249.786673285@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 02:26:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.246 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 420 pass: 420 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
