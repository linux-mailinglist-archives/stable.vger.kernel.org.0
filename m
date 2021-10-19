Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7E54335C2
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 14:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhJSMUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 08:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhJSMUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 08:20:51 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD98BC06161C;
        Tue, 19 Oct 2021 05:18:38 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id i12so47285074wrb.7;
        Tue, 19 Oct 2021 05:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MsFAqTdto9KD8SmdGT1+LtifFFQHI+C4P/7IoIQ82qQ=;
        b=AxTULgBhGeZOq+B3XK02Ynr6GEjAOLI5Q+JtUOyA1U8KiFMbT9GBUKifT3Rd2gMNU9
         6pbhNsBayMo2zoPAeqjVGZ/gl4bpq95eQHaSTFrU5d4Fz9sHNPEDuom8YTfITvbxxLFI
         OyunG64ebVb3BPd3FI7ISbFG3COmpM+ERpgv35F8T6KBjT0rgjoAzQ6FCaosUbmLJ0AJ
         zGikPRi6BOs7+FdpGygugGmypsoQiMDHjmaLq82ezhabu1X+ja//aCR0gWlTHw/zvBgW
         uERpalX7tsVLkoV0EpyzGE0YULFbZlzBOm6/Q/LbPv/9tAElXlfxT8JZ6gtKATrL8H65
         LLlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MsFAqTdto9KD8SmdGT1+LtifFFQHI+C4P/7IoIQ82qQ=;
        b=XdB9agRKZtopiX+aV2VAV93yyk/bnx+0dfwMuy/wkqy4yh4KEiYKGxSTPWi5MeXur/
         WfmlKlhdl9BlkIrsKHSTqSXj/Uzh1Ox28IIVoImp+UGGVVfGcD76LkHaUnTCJ+GjQsB3
         LRtsq6MB+BKMrhO1ucRB2ubfjfNBsnBkztImZAjNOR9kO0kVrCyABlEQ7k/xk/d22stC
         kKEu9EezFj5VKmP6SEmzedJF233DLYITrWPALuEbpL1F+KNqLtvlHwHjyVR5flG9BxMD
         ETtvf74DvSraRm143ud54jxMv8S+dCtNwK/vs5R0CdFsw2yx7h1QLAecXrUjaol2aLop
         HqGQ==
X-Gm-Message-State: AOAM532MOztEgzwq7OTlfxXSLCV02dROG4PlZ976R3pNRd/5rSYesc08
        Qnuug4+HFX/yjlGu6wzOQQNnZJOvO50=
X-Google-Smtp-Source: ABdhPJyhocyh75B6+WJtHR4f+NWvmfaG/j6/+yZHAutuBOIEtheMcyqKmY3s2bADyH4E0PAj2ToD0w==
X-Received: by 2002:adf:ab46:: with SMTP id r6mr43174330wrc.71.1634645917468;
        Tue, 19 Oct 2021 05:18:37 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id l20sm2246206wmq.42.2021.10.19.05.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 05:18:37 -0700 (PDT)
Date:   Tue, 19 Oct 2021 13:18:35 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/49] 4.19.213-rc2 review
Message-ID: <YW63m/OequXnGwtT@debian>
References: <20211018143033.725101193@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018143033.725101193@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Oct 18, 2021 at 04:30:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.213 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 14:30:23 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 63 configs -> no failure
arm (gcc version 11.2.1 20211012): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/287


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

