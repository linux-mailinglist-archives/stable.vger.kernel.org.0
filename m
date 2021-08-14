Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A206A3EC23F
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 13:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238090AbhHNLIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 07:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238171AbhHNLIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 07:08:13 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06620C061764;
        Sat, 14 Aug 2021 04:07:45 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q10so16788775wro.2;
        Sat, 14 Aug 2021 04:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZEY/uF0AeUO9OWR3QBYe8GxcPV4XclzDjl0uDg22/T4=;
        b=WDSM2ElhSY+NkPt4Bj1avBdT2k5a0rgS0Tq7jTrXODCrox7g8qbi1y7eQ0lKqmjChh
         KQWI+voq8L61IBPwb75hrPMrKeJWASh7hC1g6d2N782x4m91EBBJBf4tim4evhiJDMXY
         MAuIsvbmRbOZd5UAqWu6RMIwRH39+WiydpA+T2HiqN6PFGFrwzKjY2214Eg9LApog9FH
         6DyrMaoGou33Qtfuo1nOXrvon8E6dPqIyGFbO5foqlh2kToVgGMk7JpyVd4NkY5tAuwb
         P/sHKu4Ex+tqLlHjnwJFw/wKgEIRKCX/OiZ5u0T6jklrIdKdPz2E7V28n9J12kJ2EdgR
         vX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZEY/uF0AeUO9OWR3QBYe8GxcPV4XclzDjl0uDg22/T4=;
        b=ZR5nDHWsN15RAR0ZoLGoXTo84SomHdJZnKhQ3KLYDoOTkYWpkLqRUPCzNDVdZP8xCC
         xt9OwE/1Cw1+TA7kCtRArxTPaYvaOwTHCN5PybjTD5cnwpnXtsOo8wAujWwB1IBXbw76
         eY7t9xKP6LOOWQE/3WvKc55C0W0yYwyh/4yIEin07ubWEWn65t8IiR6UlowXotDBtep2
         gIpWkN75m7kyf35OBg2pRcnwDpNisi6tCFeozwfw2hzoz4OsIQliPsgdZJqbFTgaEQAV
         WuRnVjW2V/Up6dBmhUkJpjop7y8FdfXqXp8LuATU088IC/Gus15YSPKeZNwV09UBiaBu
         +o2Q==
X-Gm-Message-State: AOAM533G1K35VOSfygImW6hhetsXuVUX8HXKnBGqYYEQxbXh3puB2qVI
        BcBA35zSCD5ptblqRNiqgFg=
X-Google-Smtp-Source: ABdhPJw0m3quq7d/oPw3fzVovVfYdz6VSkYHmM3JzaLDVPaCk2kb7lBaJcpebOgRCVYteOEhM6uEjg==
X-Received: by 2002:a5d:6991:: with SMTP id g17mr7994617wru.253.1628939263605;
        Sat, 14 Aug 2021 04:07:43 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id u15sm3721790wmq.33.2021.08.14.04.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 04:07:43 -0700 (PDT)
Date:   Sat, 14 Aug 2021 12:07:41 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/19] 5.10.59-rc1 review
Message-ID: <YRej/WIWD1zJphN5@debian>
References: <20210813150522.623322501@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813150522.623322501@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Aug 13, 2021 at 05:07:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.59 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 63 configs -> no failure
arm (gcc version 11.1.1 20210723): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/29
[2]. https://openqa.qa.codethink.co.uk/tests/30


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
