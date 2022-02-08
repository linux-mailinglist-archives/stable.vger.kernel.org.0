Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3424ADAA1
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 15:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358248AbiBHOBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 09:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377294AbiBHOBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 09:01:06 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCEACC03FED2;
        Tue,  8 Feb 2022 06:01:04 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id w11so30955138wra.4;
        Tue, 08 Feb 2022 06:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4FtU9kX5hrkDZtN795Al3MMAz8CfFhP/v7tRtMsIPlo=;
        b=eBuK6MSuOTfOj3zN1jc4QcazeyEbXboPZ9f9o5uRh4twyQWgDxZdwJywjyQmcIcfQp
         YidLOtSsNzpCkjrPUZFKnKwVukz9WVNt7D45DIOcH9xX/AbR1El0rTeR4Vpnb+JL0vXM
         aQpS0FBRQaRUNzmTWdhwqL3Nh9Luaq7iVE8vyl0LqFarsnjBig/fJZA4WWkvkWejH2SU
         VJO3KWFzvMGKPz+owfuLTcvetKMSV7jGn2Kb9Kn6Ekij/R8ObX5m60gNZCB1SZPPJRHi
         Ey7PUSKx8D4IQRBPLcCVMyDeCW8ZQgFXptVdE4jUcfudpq9cDX6EBdorWe+u8eSKSwka
         Ka0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4FtU9kX5hrkDZtN795Al3MMAz8CfFhP/v7tRtMsIPlo=;
        b=SDVm4b/vOEkufr0oT+4klDlvkZdGrLWxXybscGODbWFIxPBt9QV1uUaISRy1I/7uuO
         8tOxZkbnwvL1Me8V7bWVdsOx+qqjjnBD93Qwhf+M57Uo66TapkE7kJK0SohFHCPrkzBP
         WNFw5Fao0+8cSdHl6BlCGalKUtea5ZqCF2IRS3EI5whjrNRRNS8YPdEyM+QqX+FqjcFV
         RKrn2QLfA6zr4q6s8YT6ip/GdgEUwl/fZS3BWjCvgIl2t1j43GwHEBs1DlZyeSW5aSuk
         perPefwcghyw0bF3v+DXfYSriP6Hs1iG9CPsfZ4vvFHykBRjyEVKGZx/ELHOhGSk/kfq
         l62A==
X-Gm-Message-State: AOAM531g75YBDtZ5Tm386R3TVrPwye2vt6J9/mPSb/bIECOp2hc5CAsM
        OZ5SSYc8b2HWw4jr5cRQA54=
X-Google-Smtp-Source: ABdhPJx/b8/Ihm2+3HfolHbcVtsskPDPftVKvbTACiryI5EOK83HEhrXjaYcIiS73SKmkpA4V5/4BA==
X-Received: by 2002:a5d:6950:: with SMTP id r16mr3729979wrw.462.1644328862686;
        Tue, 08 Feb 2022 06:01:02 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id j19sm2540960wmq.17.2022.02.08.06.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 06:01:02 -0800 (PST)
Date:   Tue, 8 Feb 2022 14:01:00 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/74] 5.10.99-rc1 review
Message-ID: <YgJ3nF5RGa7VKcwT@debian>
References: <20220207103757.232676988@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Feb 07, 2022 at 12:05:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.99 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 63 configs -> no new failure
arm (gcc version 11.2.1 20220121): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/724
[2]. https://openqa.qa.codethink.co.uk/tests/726


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

