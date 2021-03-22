Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A8334520A
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 22:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCVVvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 17:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhCVVuy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 17:50:54 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D68CC061574;
        Mon, 22 Mar 2021 14:50:53 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso17502818otq.3;
        Mon, 22 Mar 2021 14:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EPab3DPz+6s2CYJ/lrrpciQB/ZsXIEYle+nb25umlL8=;
        b=ETld37qyItYjVgeLdFuHZLWl7eNmx6Xk0sXkrU67RkvjzZwuNh9QrbjFVG+s+Dc+Jw
         SCcqZ1Kj6/dFIGzlL1TQnfS49S+EnGpH7Opq6zSolY0fefjeg77h5CxIbUSTw0aBozuu
         1NCAt1cQtoRT+3/aV0A8/gcUDNsuT0GhyVjyrEoBfojr7kp6bW0g2LFkJbx8G8DC7rBp
         iDf3w0Pr/Dq17cO/f44FmOyo1R0XEtpUIQgSkiUwPLVO7jtHX3QeoVFKlJwFQxCfoKSz
         kt90nUPEqc0yzv3+BOlQcW5DnYRu/YfIFYuGgfwax/pIqDs0br6BmrZVVtkmmq1wSkz0
         94CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=EPab3DPz+6s2CYJ/lrrpciQB/ZsXIEYle+nb25umlL8=;
        b=Y0Hx4oH9aWqBFFhIF5WiNoYliV62r5mUWjxyI7eQlkQu3OD/n8U4ZUtE2vImrmBYqa
         TeIo56X4qgwjunDdYTzVuh//5aVZD/ioYkUsdJK1xBn2DrI4DTZ++GzNV46SlFGmcHlJ
         IcMUIH9v2oKr8QYC6+Xj1yNMqxWMG5sJJQEjchpofobiO3ji7FQUyUlVD7QqMdPyIVhh
         GRPT2VUCRLQ4FxDSrl9SWx8EZIji/qb3rPfmmfUKv5pcVvs2KUHa+pfyWkMD/Rlzd2uo
         ibt517NGlmWj80s4i8Nv7lN/pk0IXztml2YuxfNXlmWASTeHX7YFlX6Y9S2lxWYAu/ys
         uQZQ==
X-Gm-Message-State: AOAM5334wiJfH4o01xrfcVMbq3cojxXzwfQxbaYke/T7ul8MZuMhuncb
        Or2fpsMaEFQ7HW69/iDNbX0JFzA/r3s=
X-Google-Smtp-Source: ABdhPJwHvB27tBz+nI0nBcJG9FPJJd8nTKDC0AVrQccOQm02NvBTGqEoPzUxt5QOfCCeKYZsU0hFHg==
X-Received: by 2002:a9d:701d:: with SMTP id k29mr1626464otj.268.1616449852872;
        Mon, 22 Mar 2021 14:50:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o23sm3760197otp.45.2021.03.22.14.50.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Mar 2021 14:50:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Mar 2021 14:50:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/120] 5.11.9-rc1 review
Message-ID: <20210322215050.GA51597@roeck-us.net>
References: <20210322121929.669628946@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 01:26:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.9 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 437 pass: 437 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
