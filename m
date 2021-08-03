Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514F53DEB05
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 12:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhHCKgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 06:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbhHCKgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 06:36:13 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B45BC06175F;
        Tue,  3 Aug 2021 03:36:01 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b13so13906098wrs.3;
        Tue, 03 Aug 2021 03:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5gnsnzTGI54ChlStN7U51FwYFJHyQet6tZdsRBwdagg=;
        b=fpkA1Qr8QHvpMIZSgQrmalSO/MWPPaXNJAQT7Roa2w/W/+Ia+CO5lg7HoDNFoMsakw
         eXh+v9wno5ozCZ6s2Tz04fsjKhnUQ4SubcOvMe2K2C+9a8Owtd01rK/EmN4EF+eLFM0K
         s4GDlBLexIjFbj0EISKPdqgSdUTYL8DxPc5es6bXdr4094u0gVpLBjZI8b/9TMeBtumb
         S9H9Dm7ylMHRkRBi3706be7xyuFO/mn9YlcoHzYOohYpAQFWL61v0iR3Q+YBB9A9iknN
         pOZlIBf47VIH/AhMjVq8dWXgv6wqvp/CcHIPKhDL56qF4ItyS5q0F5mgf/spXIf4NDwV
         IAxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5gnsnzTGI54ChlStN7U51FwYFJHyQet6tZdsRBwdagg=;
        b=sY0dQ+EOalCJCXkMYvdq5AczMwT/uxkG6WqKFoBGJ4eETy41nas9MXSB0j2YHy6ydq
         lb565yxPH/YmxQQV5v3WJ1vxZtoRjE7x5BOiggdjkZtrOLPzrnq1+lMDknIf8n4pr3+x
         /gGXa2GnEvENUXy4WnEYwvXUkSYXT0t6btDDlW4qSeMlv9Ko7LUIWK2JJutkVzgps4Gn
         3fDeYCWsgFUQhbuYVokJGi2EfpJNwI6BNRtlxOQjWzNa6yC/LowajteZlAFP+wmuQgO1
         RFweRMizZn/rUNUZfoWEEIKFlJqzpAgAVK/cW4bS/yDIf57B12jHkh6WJYing0HnNvaz
         y5bg==
X-Gm-Message-State: AOAM530Jq42TE/gZCyg3xTnMzreBUIKneKco2TtgAUpLErBKaXZOFOEh
        +uy6CK7G7zUN+POnDZ9QciQ=
X-Google-Smtp-Source: ABdhPJyWpLkXEiPW9udwjTC40JRgY4wWWDkK1h+sS4aphghCXTY/a8GS6BK94LrUzev5Gq8waSAokg==
X-Received: by 2002:a5d:61c8:: with SMTP id q8mr22211371wrv.151.1627986959799;
        Tue, 03 Aug 2021 03:35:59 -0700 (PDT)
Received: from debian ([78.40.148.180])
        by smtp.gmail.com with ESMTPSA id l2sm13580435wru.67.2021.08.03.03.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 03:35:59 -0700 (PDT)
Date:   Tue, 3 Aug 2021 11:35:57 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/40] 5.4.138-rc1 review
Message-ID: <YQkcDRc8iF/+wHnA@debian>
References: <20210802134335.408294521@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Aug 02, 2021 at 03:44:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.138 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 65 configs -> no failure
arm (gcc version 11.1.1 20210723): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

