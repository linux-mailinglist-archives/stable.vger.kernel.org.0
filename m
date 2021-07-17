Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16803CC215
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 10:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbhGQJBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 05:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbhGQJBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 05:01:21 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7259C06175F;
        Sat, 17 Jul 2021 01:58:24 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id g8-20020a1c9d080000b02901f13dd1672aso8207872wme.0;
        Sat, 17 Jul 2021 01:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nfIwxTHC2UAbzplalJLAoZ1ytLOVlqi4hD7eFiW46a0=;
        b=TVDDnGMyVlqz45Kv5x35mdbl3Ye1J6kgmgP3KCliwUMSX2Oi8jyXEVqtJFmZ9DygRL
         PkS99ZTaybqrbht95BJeFX4PJr8kmcc/pQf0eMJIQOgUwgKYgK4d4tY9fMUo7g/AObSd
         HoaTpqre1HEOEorS5RP7nZP4MgCA4Er48F6OI6xzxpQVtw7TnlTk2wbwfbCrTwQUipk7
         LLBnwO5XsInCggYcMq+yMQn8Wl9BOULzQtN/vPop/5tBedh7hQdNYshVkhgqTEkQC/VY
         j7qB2791MM+TYkK6JqUEadF14HW42s5TzIprYIoLNHcYKitSb4abp0JrzWRnizOWr3oM
         Q64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nfIwxTHC2UAbzplalJLAoZ1ytLOVlqi4hD7eFiW46a0=;
        b=bT52D+lSIMZiIEJpNmqpKixUos0PuyzkG/H+ffDajS9K506WRqJZg9uBC5QNpITW8v
         jC/7njC5oohnU/0NNKXxJm3JDUFOHWDCbgaswuSUJyIkeyM/IqIiszyKKkxxQbj0UAiU
         /nRxOMHDNDnez90T9nqo16LaRx8b5u7KWKSb0bh5mRxlU30/ESYQsQtGddZlmapWKSlX
         RBm7F/i61eoPLkU+hDWZ9C66unuSTPcEOz3XUWvtaZqdMM8DGCkxvOstYPnsOX4WMhti
         DLFh28gBtRGUwC8s7GznOZwhCcggul8NwH717dUMFUUVdHGE1eNDVtBllLLeKMCNtfkf
         3R0w==
X-Gm-Message-State: AOAM530TAdkWL4Yqk9xMa3mouzQ7iHW6kOKvCf8kwnRBX3T1+RSev5VU
        ekA7+P3GsrG3DXENuSguuSs=
X-Google-Smtp-Source: ABdhPJzznuiRp+fE+BVvFIsVl4tsjz2YtGMOITe+NxKxmE1bZsjQXsQYyrjti+YT4JU7hlZdI/F9+w==
X-Received: by 2002:a05:600c:5106:: with SMTP id o6mr20995020wms.18.1626512302427;
        Sat, 17 Jul 2021 01:58:22 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id p5sm9973859wme.2.2021.07.17.01.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 01:58:21 -0700 (PDT)
Date:   Sat, 17 Jul 2021 09:58:19 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/119] 5.4.133-rc2 review
Message-ID: <YPKbq2C56P3DKzkH@debian>
References: <20210716182029.878765454@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716182029.878765454@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Jul 16, 2021 at 08:28:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.133 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
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
