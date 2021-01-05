Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0772EB254
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 19:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbhAESSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 13:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbhAESSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 13:18:11 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E228C061574;
        Tue,  5 Jan 2021 10:17:31 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id d203so562188oia.0;
        Tue, 05 Jan 2021 10:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7PIEQKUzZYP0ZGi0p2TGikwdB1CFWfuWlcX9UKJogCc=;
        b=WWiNBhjvLhD9LU0j/Y4nEPLMvt3Kvr23aDqwgEt8NZnmoWyTCcrW5tLxzt2iYpMDFi
         7oo0nYLAq/PDMy4xYZEp6uY8BUuJekttJB4f2SXAsWbi7keWpPYGnMSh8XKKre6qyZvK
         X+kAa0iLGo5y4lWkna4xw8N4APhqjvKr59COElLxEGX1mEjmh6Zl3cJdAy2ETSxeEbrk
         f8YFLoFHOjrSvCAdyCno0ayWwIQaf1yjA4G6m1+UqSf4dYngE0iaU33L+UD8BIo3cVA0
         DlKSwk/kMQx0ZCwbSCLItH+t7UI0WtP2Bd1qNA67Q+AdKbXIQv9m1lB3Ry1/MrBGfhHv
         sIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=7PIEQKUzZYP0ZGi0p2TGikwdB1CFWfuWlcX9UKJogCc=;
        b=JOMIV13FE5Q5dfTc2uQvAxUoPK4/SUMQDrMlgKFsiLidu+Z6KiGljjFDWXHjWFs2zx
         fulC9llc8Z5K5PzraLMFhLwk0OPbjkg+IRtdNF6uqgdCACqM3LFiMjwaBB6mQRTuumgj
         E7/cgHhSvSOU/l0tTRtH/4GWH8DBbKCxfne/b0toSX8tqPI3e9k6kiLPUT1mNqdA7SVL
         T5cgyukyh9zNivF2fwOaOUMqRqnrPn/oKYjZVJC+tesaX07zDLlHjmuvCKoM+xlK4eqv
         uBUCZvPrymltxMYc2iKs43hHi7hVhihanem3P4IOcs4aEYNalvmKvIJ2MWrIXG9X3308
         O4Kg==
X-Gm-Message-State: AOAM532d7mpFoZ9B1PDyHyf+krvGN0MLzK0/92PqmhWHuKjiS313S7ek
        F8DfoOoSX/kBQ59noqK3l8Lv+DyG24w=
X-Google-Smtp-Source: ABdhPJwvYtuSRlgilKGrrzGBKVp0R+lkuAsE/vWaWDpRQUFAcuRRNEQKLKGo/C9VnCvkodBQ7AZJMQ==
X-Received: by 2002:aca:4b0d:: with SMTP id y13mr599950oia.7.1609870651050;
        Tue, 05 Jan 2021 10:17:31 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 69sm59151otc.76.2021.01.05.10.17.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 10:17:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 5 Jan 2021 10:17:29 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/63] 5.10.5-rc1 review
Message-ID: <20210105181729.GC220537@roeck-us.net>
References: <20210104155708.800470590@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 04:56:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.5 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
