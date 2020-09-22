Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8D6274A01
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 22:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgIVUTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 16:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgIVUTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 16:19:19 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E04C061755;
        Tue, 22 Sep 2020 13:19:19 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id w16so22437726oia.2;
        Tue, 22 Sep 2020 13:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o1R/kW6GVRAs5CVcnuW7FpWbPErDd4a0RkF34GZHgzk=;
        b=JvQZVMNaY/STvErduUedjmsspq3g08MYTO8QKFbYdVixOAzrAl3LIZ2zy7NvE+W5sU
         PLCmpBIkCkM9mCja+WyN/XqvGLpCZHPHYTH9M3UVmC9rxP63z53FDwem43G0GGEZyktv
         HEutVfEMfFG4vyWj0WJ6x4cInR11qeqyesMoewkfMBK30YymKhxIsbX4i/qDhOGpF3Hh
         UrPl/oZA52ti+twSNc33hxve0KCfe78t54PXDGC96Wp2B4ZuKo454/TUit5qjOjZPjj2
         FYjAT8NLWduNfn3Lk2Jvo/lypaLCk457kigUvL0ksHLgWaPtuMbdhYQyx9bZY0nD/5+A
         xCnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=o1R/kW6GVRAs5CVcnuW7FpWbPErDd4a0RkF34GZHgzk=;
        b=m/JM8SVu4qP6J2yKBBr7KqasaVuyg4vsgck3dXDGeU+htKGgUseEhdiM2cZ6RUTD6G
         astxy8CpE+ZZ73Yz6IDCF1FZOug7Wb90bfVDVE7SJU2hLPZgdcwMrZx2ac402YVxdmdC
         Z/JG0P0+PktyH1GJBsaxTFuU1UCV/IHRZpfDUSdku9AvXgiPkCdS5tr6kX6uIRyE/GWx
         mbm59yGwYaMFOzdTpUqCCU8YW6vh9DrOWXmBu+NiEqFMFrTF/dJ5X0vBQh3RBDzNBB6g
         sdWKVLuK161kgL7SwDe4w931GMF75KvaTuyGXy0qWmwnbDFMrLRcxbrgZPjh2ftHb6+k
         YRpQ==
X-Gm-Message-State: AOAM530ico7Y9BkiiLERAEW6OH8ZrdYIoMCajsIkjgmvWjTUl9otjaVS
        feQnUSeW64h+rHbbSRBOJrE=
X-Google-Smtp-Source: ABdhPJxsoPy8NqcZckL/LETGwLcvZrC2/4sBrQi3Sq3bwdD8TYS71n+HnOCPo+pVeqoQEKhXRdFIRg==
X-Received: by 2002:aca:f40a:: with SMTP id s10mr3839124oih.126.1600805959176;
        Tue, 22 Sep 2020 13:19:19 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f11sm8466458oot.4.2020.09.22.13.19.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Sep 2020 13:19:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 22 Sep 2020 13:19:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/72] 5.4.67-rc1 review
Message-ID: <20200922201917.GE127538@roeck-us.net>
References: <20200921163121.870386357@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 06:30:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.67 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Sep 2020 16:31:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
