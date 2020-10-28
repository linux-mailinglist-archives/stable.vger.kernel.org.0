Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E0C29D368
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgJ1Vnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgJ1Vnq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:43:46 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA88C0613CF;
        Wed, 28 Oct 2020 14:43:45 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id c72so1104710oig.9;
        Wed, 28 Oct 2020 14:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2/oIbvj0hvkRe34531UjaBa7uTn4xS89MKM3C7SHI4s=;
        b=fdo2q/koP6JtFjGWvrMD52BMp6gf+37ZI/NYp5OqFMKw4ThFSAalSm8+4BEfxf7xjT
         jq8XKwMsKH3zdbOQAoIadOWKDAzyIHVV7V0W8dTletU0QoFdcVENgD0CEabc6i0bDemc
         KJ9r3UYKdvbyqW7fV76wO0gyvm/Jp9YJ6tn2xuZ0/mtcS2mRWX2C/LQybv62piyl0GoM
         9smD2triZ1LbAFBjyTpsfmb7eFJ1NXp/1xEw3cbAxrQng+E8J+TGON6HMaYnrZg4Smj1
         CBkacBy2/+URNnN+CnNIOw+oou61dZPM+D+O8tQKzT5DiWCPPhyfPuCbiL1IxpW0M25C
         d8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=2/oIbvj0hvkRe34531UjaBa7uTn4xS89MKM3C7SHI4s=;
        b=O5DKEWo8v+wdJQ66I8bpmYYKP6ja2vtx1I5K+Yr8tUx3MhDLtZpA+C1tpJsdCTomkg
         2zX0mU4p8yHc2+/L+m31zszbytZFRjJSdICuiObTfKF+4TihFTQ564KUCi0jfjZLX0wN
         I3TxXQdQjSTp8ZLyqHck9WTcKLcMV8XPuvuy/wp6reikPgGGfgSjbPXDxtxZcnTMvl4i
         FoLZSxuhgoTp0U79aLr8CvhKHa5N+03YokmlDViPqiuEFclsd8YXYu9h0n4Uf4VLEQ03
         0o/OB3/0cPGuCPAK5XmBe132U9iN8kOrzx8v6O+W+9ZKFKg5NDJc7zN7hBh5TJNUo8wl
         YacQ==
X-Gm-Message-State: AOAM533SFhJOMNAtl2PgXP2UCf5p0yjK+fWTc41XD0X7frYkcy50anrT
        BpKxEwR96tdLIW0Ox0K7tky372rCGAU=
X-Google-Smtp-Source: ABdhPJwYK8BEOQryt6JkThydNn4b/KYl7+MzzqBB8po9O7wDF6PpEa9Cz5x/RW6P4y3K9F8yd72beA==
X-Received: by 2002:a05:6808:b35:: with SMTP id t21mr467864oij.102.1603914990162;
        Wed, 28 Oct 2020 12:56:30 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p10sm118485oig.37.2020.10.28.12.56.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Oct 2020 12:56:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 28 Oct 2020 12:56:28 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/408] 5.4.73-rc1 review
Message-ID: <20201028195628.GD124982@roeck-us.net>
References: <20201027135455.027547757@linuxfoundation.org>
 <20201028171108.GE118534@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028171108.GE118534@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Retry.

On Wed, Oct 28, 2020 at 10:11:08AM -0700, Guenter Roeck wrote:
> On Tue, Oct 27, 2020 at 02:48:58PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.73 release.
> > There are 408 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 29 Oct 2020 13:53:50 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 157 pass: 157 fail: 0
> Qemu test results:
> 	total: 426 pass: 426 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> Guenter
