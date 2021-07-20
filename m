Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E80E3CF76A
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 12:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbhGTJ0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 05:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbhGTJYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 05:24:15 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65717C061574;
        Tue, 20 Jul 2021 03:04:52 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id k4so25339984wrc.8;
        Tue, 20 Jul 2021 03:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FkncoK4z3XIIH4UxE4jURuQvl4L8o2I/AqkI4CFZSuw=;
        b=sGVtYxBN9BYAE+4YmjqiqZAMOa2dQ2L8VM/Hgiglp3GT26GKHVScfvL3h0rfW5Xa48
         DYf2me1pC4/O8BFq6TtSB9U90JGRGfz6hH/YFG5nkOpbhnN36PmD7Gkjej9ahOHH2Nlt
         whROup9lKmNGIk9ARUwvgugc0e6yF1C7XhecwXezuMkd3PJC/7LyiqoveB0V4vg9CWmH
         iJRWKsfbB+znNk/W+AhYkYKYQ+TK9uOEVFVXuM6OL5VmNfrS0Fo4k37sg3qDEXaYX/pv
         iyvS4808J9EZvVliLYicMp+gVigqpzjjA5IsfaDUFV3FlvKbJ2RzvUX3E4y2gyIsBKUX
         PXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FkncoK4z3XIIH4UxE4jURuQvl4L8o2I/AqkI4CFZSuw=;
        b=ng+k8do0y8ZuRz/57u4j41i3tqf1/oaO0IcDhl30hyo0E6K43SlVQXJOcDfxkLRQ5F
         pBdmBpNAJe9K58pG7zv5t9rgB37MV5J/bKxoTZKxERR1zhd2y3TISOQZ33ZdEhhgZsw+
         Bo2C6Vb4BV8h0pNjsc4VntHzb/ZWe3i9wM0q8fijZ3SabNx4P7KnFUpuBh/FKztAhvrg
         tHaUGzcaKkrMSa/+DKPc8qwWe0vEWqk/51n9ydslBV9bhK81d87NoQqRf6inKo/CrxZH
         pHZ2pcUJ3V6s+EgjRBR4Lkdd5gC+2FjaJjzjUC83Q2rKyNxGrMRMnEw3Hci8Ft8AvS3l
         +Vlg==
X-Gm-Message-State: AOAM531kqod/NK9f4Em7qyibIwj7e2HXOEWx6l7Cfiub5UmWyM1CY5y8
        2bCKe2k7bSDm10OULHIx6ns=
X-Google-Smtp-Source: ABdhPJwyGIMVS6XYyIV80JjAOUbVqT+m/5LFMmWtUDdkE2mPQ7F/BNvEZCNVw8nN/53boCWcG0zoxw==
X-Received: by 2002:a5d:4010:: with SMTP id n16mr34695192wrp.142.1626775490954;
        Tue, 20 Jul 2021 03:04:50 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id d8sm24157678wra.41.2021.07.20.03.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 03:04:50 -0700 (PDT)
Date:   Tue, 20 Jul 2021 11:04:48 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/148] 5.4.134-rc2 review
Message-ID: <YPafwMAjBPTFk6d3@debian>
References: <20210719184316.974243081@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719184316.974243081@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jul 19, 2021 at 08:45:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.134 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:54 +0000.
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
