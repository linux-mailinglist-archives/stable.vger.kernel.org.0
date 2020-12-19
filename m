Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3BE2DF1DA
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 22:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgLSVuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 16:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgLSVuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 16:50:03 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2C5C0613CF;
        Sat, 19 Dec 2020 13:49:06 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id j8so1441882oon.3;
        Sat, 19 Dec 2020 13:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3eP78bpFZjBe9GdjMWYp4bqLO7v9ggbKwrJKCSlZ460=;
        b=ZgrO2KAPrWyDuRLVNEsOqX6NRgW0p7rIQPfSXUFuPCkpcSmNAFEjNRi9D4tXZZBQvO
         pacTnyn4UQhfeP3hB4Bjh3zy9OuvhD640WvUvx7ukVcQFks/ou1+inoHn5xzte/cJ8qB
         HtSkayVqgyWEN+SGml8oREM2hugloEyYZZaR9m98W1BfAVrRNKc12CxepCV3DLRHzOu7
         xcGC2V6+VVA0CS0mKX0pkpHrwfYSA01/InIi33d+2aPRZUK/nOfQ15phka6/Zq7V5o8F
         LFvHHJ0/M3t6HUkXIXjDkdEIVzo/jGzU/riAlGLsykQE89LGjUIFNVbQWFXblrS5FGTP
         /5zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=3eP78bpFZjBe9GdjMWYp4bqLO7v9ggbKwrJKCSlZ460=;
        b=RagwBht2q7NV/r7wEBmcut3Qf3+pRky/VgwYvJ7JVmc89HJxv+fZhDjA52WxGq5FLr
         bRbVBdPCu4tZY9sed+Kgb3kEI+R3bo63FMtOfSBZTF1vrP6i2YQmHBtGvLH2aDn+6SsU
         zDrNAkhxJScwrSDu+0AJrxm7WwBW4NJVFR44xm2Ee2QXSyBrwBN3PDahLgASpXU7oj0+
         dl18GMdTIjcBAaw3+SvMzC5Mea4vBHo0/fErJHdOjIjSd4LU1FFaBEpCd9IeDwPIjWMY
         7Vb5taQ4OQUrdSVzi0pUkJrC3rrhdAGKdao2p2VHT1+r2cgQYWfV1Fh1z6AJelTJlQbh
         QNJQ==
X-Gm-Message-State: AOAM530EgOMIAuykoqbvr1UK/e6IyNRnB3+QIVxBjq40h+mHpG9G8y8k
        r4hKMTxETYayHUYEFptgxBs=
X-Google-Smtp-Source: ABdhPJxPw3kQlGidQCxJGFXtnTOYwFB8NKc2ULnZpoOrwzV0UUEsBQ41/eMRwQdEVGPvOGVF7leN3w==
X-Received: by 2002:a4a:ddd2:: with SMTP id i18mr7190941oov.10.1608414545485;
        Sat, 19 Dec 2020 13:49:05 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m18sm2822487ooa.24.2020.12.19.13.49.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 19 Dec 2020 13:49:04 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 19 Dec 2020 13:49:03 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/34] 5.4.85-rc1 review
Message-ID: <20201219214903.GA22593@roeck-us.net>
References: <20201219125341.384025953@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201219125341.384025953@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 19, 2020 at 02:02:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.85 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Genter
