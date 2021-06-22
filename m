Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAA83B01B4
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 12:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhFVKuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 06:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhFVKuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 06:50:13 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85160C061574;
        Tue, 22 Jun 2021 03:47:56 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a11so23076703wrt.13;
        Tue, 22 Jun 2021 03:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XYhLJyFYUJE3sMZVL1rPRIzjsw8eBEGke7u45/pXfsw=;
        b=ASG9aBFsulCr6KcMFavHH3rQgSmO+Nx0oogPgKjAGY4OCJb08U/gNMOeocRgR/zuWR
         TLNU/GsE/aFuAXdkvM9JXI73f+jUFLUWP95krSN9ma4Xc0t5WKPgARgFizNdFlw3yxjV
         sMdGWB4CCyAkJAg4QWczaWoBTQccS/F0VYATF5djCpWaHkWPfZXvYjjjrKuBWy//GtPu
         lhR72rZwj8BsBI65Xc1YjGIxTu0sQ2xfReaLLymfPwK552TNzThWT1GCM6p1yaqYtwiq
         lszk9omywh3oVG/wT4l3WKpEBGPwB5D0LWExk2zAPtpEB1mzVrE/ONBuquqIXHrb747I
         x+3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XYhLJyFYUJE3sMZVL1rPRIzjsw8eBEGke7u45/pXfsw=;
        b=G8MxNFSjB+yuZ6X3KEGoXoE9nJpcuWJBk1llVxS5djFMFRzk3xI2r8sWU2dvWUX33F
         v9ToQoCvHpkF2j/Q4GlAY4puN/4ezBG9xu6LLcynnIyiiEI3AfQ8xN+/nH2n5hq3Ga9W
         rA5nJIAB1nlmj21zoxOy6zxIisamioMXo2pMRS46fw2nGetjaiI9UMg435gl8Pd2HsrL
         sGWKLzJnN1FWIfYeiQBIyaTUy91gtZG3GhxnkoHS2PUeywRyrSGzI85oHKRLDHkqFano
         WqoHGQ5Wfc2mofBvobVTFU/dhO/PYengOPFWPBZyGnn4VNWJYt1PDLzSyZ/PHa5TgXqF
         n6lQ==
X-Gm-Message-State: AOAM532sa17K4TFRBUinA4h/A2MwWB7Ph1wLJmjHov4iL8SDIJ6ixky5
        BYYfKeG7QU0c5tdL7bTepJ0=
X-Google-Smtp-Source: ABdhPJyqNT/TW0zBU9p7Sfo4og2oaxQ8588BWEbK0a6IbYk6SKwXCz/pAPuyhiNhpovlYuyIJhwibA==
X-Received: by 2002:adf:c843:: with SMTP id e3mr3988091wrh.25.1624358875183;
        Tue, 22 Jun 2021 03:47:55 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id r1sm2067795wmn.10.2021.06.22.03.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:47:54 -0700 (PDT)
Date:   Tue, 22 Jun 2021 11:47:53 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/146] 5.10.46-rc1 review
Message-ID: <YNG/2SumlwhgySuI@debian>
References: <20210621154911.244649123@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jun 21, 2021 at 06:13:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.46 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210615): 63 configs -> no failure
arm (gcc version 11.1.1 20210615): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210615): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
