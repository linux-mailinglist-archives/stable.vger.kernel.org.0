Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36D03E8D62
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 11:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbhHKJnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 05:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbhHKJnG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 05:43:06 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E529BC061765;
        Wed, 11 Aug 2021 02:42:42 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id k4so1477771wms.3;
        Wed, 11 Aug 2021 02:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=odJJ9sHmoCwNVh5dei4uVGzZhtNmhCcRHGxcMkOpIag=;
        b=STe6BAjuhdCpAjGE6ikpHyuDejMXhXWFoapAkSOWYCeZR8nUq/r3joEv+HUS0qa8k+
         U6Lx1HqP2gHaq/9RXczSvQlSi36gSKSnBLrndnF5l0iXLRcysmH9Wg8bfDBzy65qpDUY
         4V2VhniUGx8W3Z3cm/RUki7aFJO4PSQfWpBwi6wh7Ss5EcHKnoa+jsk/N7tOVKjb8ix0
         oL2gpxfJIDsq+g9bPPGW0HmSWizTxcGf1KOZd+mBQJkGhTQGUPKotI3lkSdfcy2xjGsx
         Gd8DsWTAGxfOfycrQhteXqq/fh2UD/Y1EJYKlW1kLHGEAqa0ffE9nclA3Uy7ujYrG5T7
         sxTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=odJJ9sHmoCwNVh5dei4uVGzZhtNmhCcRHGxcMkOpIag=;
        b=pV94nAajz84JvFflb8H94kv6LGLru8ZydE1GKVyZ2ZuOzbhPEPLvwmfsFn7sYX6Nnq
         h6NtKW+Dx2NqJUs6TX/d0o3XuHl1BJQxs4xeUy+O6SP+ikZ7QKyDKlGczG2lB9dbzl3x
         lwa55gJfKnk5Rr8RlBO+XLA03lAM9Li/9iiDsp8ZIaA+JR7M+QWqB8y75DdPyrYsPqUW
         YrwVvWSR4CuA3MHKS3xWcK20+UL8Lg8+7rgnfpVPLhIP/OwDw2SylY6IjtoaAJDUkN0z
         bnzgVPYVE6Pd3tS05FdDuvQYh4acaUfLOzNtfQeH7fvzbjo3IqZG9cUKYhGf6Feq3mzE
         yJLg==
X-Gm-Message-State: AOAM532ulgvkLuYB2nh/jBXTybAxjmp2kkHVdbzn3hPil48fRn8LddNk
        502VBKXCwLYfSiNiZRkvTXE=
X-Google-Smtp-Source: ABdhPJwH3iDisJuv2ZQDFAJTLCbD8FRtt08gzld4LM3LDbItpSkw+LbftjsMxu6wfkcKkOgV9HLG0g==
X-Received: by 2002:a05:600c:224f:: with SMTP id a15mr8881878wmm.37.1628674961526;
        Wed, 11 Aug 2021 02:42:41 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id w29sm1445896wra.88.2021.08.11.02.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 02:42:40 -0700 (PDT)
Date:   Wed, 11 Aug 2021 10:42:39 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/54] 4.19.203-rc1 review
Message-ID: <YRObj+vRBTxoEhI0@debian>
References: <20210810172944.179901509@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Aug 10, 2021 at 07:29:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.203 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 63 configs -> no failure
arm (gcc version 11.1.1 20210723): 116 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/18


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

