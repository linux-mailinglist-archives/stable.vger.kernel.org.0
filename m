Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEBD40B746
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhINS53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhINS53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 14:57:29 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1225C061574;
        Tue, 14 Sep 2021 11:56:11 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id b6so21853627wrh.10;
        Tue, 14 Sep 2021 11:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XbrrZHIg9xf5B60GHb8r2y6YcNQD5ne4NXsZq1WQOL0=;
        b=FMKk4DrwDPrzwn1051mx0iW3hLrO2I2MkWNm+Zf9fkKWWNI4RtQFsMlg4mebLTNpCM
         fyPbWZ/A+QjIixltc9IxxtIul7C1y2huBKxBZMMMV3NhPILygTTmZ/02DmakutsxUted
         XwudI44mBwbKlej90r8j7XAvrS6D5LMBcgvtHJwadBFNp2N+m2HzFEZ+Das51suki1XX
         W57WXX9xWPRT/X0/4PjZZAzoE/0+/++xG8ClsvBSDrl30DiNKUo2Gje4tSN6Hsy7WCNb
         9VfDQUoxPc+BE6bCvCs+0jYgIksbBo/wcnGivZWgNutdRE9EIfHU4JQRKy2oPIeQgQCv
         bDNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XbrrZHIg9xf5B60GHb8r2y6YcNQD5ne4NXsZq1WQOL0=;
        b=5lwYdyuVJcgIhGvveq69vpMtTEk8JHOi1wUmL4PNHHgxxoQyM8u/3xdrBpss5nsvqp
         OddK0u2m7VN8DCTdhTBVd0l9k8+UBkyRChWDpepDJqqF0NwWCF1pmOVs1GtmxRyG3TP7
         MEhfdW3QoM8vdNJfh5J54AcdpITLchWCJEZWAsP+eX1a4GoDwB7YswPAk/oU4Y6ETGkg
         nDDFNop2S6Pam1ot/Df3luwNk++LuXIOf+fbvpst3llXrWTbfiGIHGK/z5BR8QRjkZ/w
         84xQWPwpvue3FzHFAyJVRI0jUyqVlxVFRBhMU5gVphLeDu63A7hf05rfsTKvbSn7MeF1
         eVKg==
X-Gm-Message-State: AOAM533ZcaZYqd8RNFl/sRV606t0VmqpTFkdlMtgoRqvSu0ZGFCoJrhj
        jD4FrNej2iw+N/kjLwPsVvy7E5hEWt4=
X-Google-Smtp-Source: ABdhPJztksNVUb3bRqgqBiIFtG0jq0fnOiPBbtu7mXOWD2CBy03wZsYH3n4+oxkyuBOZt8u2dBkVpA==
X-Received: by 2002:a5d:64a7:: with SMTP id m7mr707296wrp.171.1631645770213;
        Tue, 14 Sep 2021 11:56:10 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id y9sm2183265wmj.36.2021.09.14.11.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 11:56:09 -0700 (PDT)
Date:   Tue, 14 Sep 2021 19:56:08 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/236] 5.10.65-rc1 review
Message-ID: <YUDwSD/mIWrF60li@debian>
References: <20210913131100.316353015@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Sep 13, 2021 at 03:11:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.65 release.
> There are 236 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 63 configs -> no new failure
arm (gcc version 11.1.1 20210816): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/134
[2]. https://openqa.qa.codethink.co.uk/tests/132


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
