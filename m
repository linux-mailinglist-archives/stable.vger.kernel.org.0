Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6663F4335BC
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 14:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbhJSMTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 08:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbhJSMTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 08:19:36 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9A3C06161C;
        Tue, 19 Oct 2021 05:17:23 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o20so47482354wro.3;
        Tue, 19 Oct 2021 05:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=88KvQ8MdXceC+8zAxE6BfvdHFdBiDoLz2q1m2brnxJg=;
        b=ph3KzMorHixjCmz+KxPL+y5l3Nt5LN2mD/D405UejLV5yZHpcyNlRglibRQNFC8MSu
         Yrgb05GM7byNXhWw0bZI95dz5JovFOFOMI8XKRjBvnHrFWvi0gh3qstYQx+V66JfHxJ5
         qg5rPS45jDqsvKk/QbypiiLcUeoM/itB8AoV7Rt7t6mz7q1b2Od5mTn1rrKyGhUVb6wk
         SlTwrWoM4iZA+jCynT2QS2AC9cm8dvzLkEVn0xUISgFXGgPdpMza7EFAtb6aPON6kOts
         6Cc6xfKjm5NQGK0Ape1FMTPhe5wMoFASmcUcYBAt9xRTpATqkbn2q1eVANT+aPXpN2a9
         rYPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=88KvQ8MdXceC+8zAxE6BfvdHFdBiDoLz2q1m2brnxJg=;
        b=Ht6wItzFoBuMWQaNRzj+Z3VGbbVWa6FI6TyZC6WfQmSIece4BQyAtiVaXRQjZjoQAG
         vatmEX9nZZdMPyxdKbGsDDm9FgJiep/ZcG/bfq4O03FM4VnOfRtxEVOyVFvp6DER/R+w
         R2MYIyw1XDVrrA1WOfAhZnyWHO95x4YcA6aa3y8j2xI5o8/HG7Bulp/VkX6izWENq/Ah
         FZRXx1bmCJoQ7kCqFswQVBRKYsCV9dqnwUsKMmg5m1ixGTQh2qSskrKHNEI2KlzYu787
         tW4raoA0L0SxcPLf+Lei9NQhbEv7j42pYX9INuhIIEdunXG7L1viCKBE3j3dSnyrtafM
         bDig==
X-Gm-Message-State: AOAM530iJ+gX/xvHyWpAGWdheBecv9kx7azd4mQ7Yu/xLiTqjMDSzpzo
        1Maon9h+RCP0VGJNVDPdtkY=
X-Google-Smtp-Source: ABdhPJygDFMM+4zG93QvACgtlY1sa6gBUvtnwusr9gsXn6Pc98vLG71Nnf5xiPdvsQGapADZPeN8HQ==
X-Received: by 2002:adf:a3c3:: with SMTP id m3mr43691158wrb.83.1634645842510;
        Tue, 19 Oct 2021 05:17:22 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id c185sm2124671wma.8.2021.10.19.05.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 05:17:22 -0700 (PDT)
Date:   Tue, 19 Oct 2021 13:17:20 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/68] 5.4.155-rc2 review
Message-ID: <YW63UBHVOOQtVRBE@debian>
References: <20211018143049.664480980@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018143049.664480980@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Oct 18, 2021 at 04:31:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.155 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 14:30:36 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 65 configs -> no new failure
arm (gcc version 11.2.1 20211012): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/285


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

