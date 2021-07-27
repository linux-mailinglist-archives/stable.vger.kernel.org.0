Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DB93D7A73
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 18:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhG0QEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 12:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhG0QEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 12:04:07 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61250C061757;
        Tue, 27 Jul 2021 09:04:07 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id n12so12260523wrr.2;
        Tue, 27 Jul 2021 09:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VsDMUYockiZuXvVYr73KBmPP+LsqDzpmkZzF+o+5MWk=;
        b=dLsFRgO8xI3nPxgpoAWRBCU3ptmhLJpg2OR1SF1TTxDnTnLf8wEEMiNvRLUHBJvRvU
         gwnNdeA+xG2gkenXWksIjxsTPwZ/tEtTQ0wvuJnS/bKKKoM7+Cd+FHp7Sv+0b4IfuLjH
         tR/bK/qbGpml/I5ebV4bzR7S8qIEj5UG32WXfduUv2xSyRHqCnRDyNR6uVTsRw5X8dQL
         vbIhVTG6tNVnqsHt3QFTQLfUX5p/bRfuC8XuPF/2eBh4ukTyUJnDB6ptGyXERqXj5Awc
         fgBhYmLpIxsJQSYtn4Ayg/80US1UbefbykUx6UXC5F0UCJMe5u41hXgeNgCAA2csthPb
         ec3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VsDMUYockiZuXvVYr73KBmPP+LsqDzpmkZzF+o+5MWk=;
        b=JeEpEAUYNp4wBGGXXej8VD3IcNQfGUZQAWdy0T68K8cL5cFRRb9HYCsc4v6PKJV2ji
         w9zEIpY9fuZQUNok7w67RRHnhxMfM8c5TVMK5pzkT+P7/eZaGDzhSmdztvIUugPLXQ/1
         30btMLGejYl2dozGM9TCmZI4Fl7PGnBYIBxuHzZCPz9DRKlwvRRb1W7HVQXtiNECKf5x
         SL5rGV7o8V8MBlZgj5Al9eohNWBydkd/uanwJejtGc6pjxgiRZT2/HbPtanihZuStToV
         z4VW0IDplQIuAYmiHxf9kkvRNjHn0HzXC5TPqariywzMhwcjZqYiVDE+8sutnEhurmP0
         AE8A==
X-Gm-Message-State: AOAM5310zT204WZf2O+TMME0vySSJoOrzQCpe80oSboYL3uvVjHEQ3Ow
        krb4m7o95F4DtcQmmSrhSU8=
X-Google-Smtp-Source: ABdhPJytGg7In+nDIe1Bd/0awrlyurRXsRggi8Dvbfc6tlTuEXofdpvNMrhg4rQU71SMuOJL9xk8aA==
X-Received: by 2002:a5d:5987:: with SMTP id n7mr25506523wri.263.1627401846036;
        Tue, 27 Jul 2021 09:04:06 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id k6sm2693885wrm.10.2021.07.27.09.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:04:05 -0700 (PDT)
Date:   Tue, 27 Jul 2021 17:04:03 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/168] 5.10.54-rc2 review
Message-ID: <YQAuc5uUnMjaOWwg@debian>
References: <20210726165240.137482144@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726165240.137482144@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jul 27, 2021 at 07:06:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.54 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 16:52:14 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 63 configs -> no failure
arm (gcc version 11.1.1 20210723): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
