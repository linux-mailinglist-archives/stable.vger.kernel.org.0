Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2896A3015F1
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 15:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbhAWOfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 09:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbhAWOfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 09:35:20 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F47C06174A;
        Sat, 23 Jan 2021 06:34:39 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id d18so192953oic.3;
        Sat, 23 Jan 2021 06:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oXlNINGpW/hzk951bSn5t110w+o/+uViaNm6S4mwHpU=;
        b=mzEjgqiBsPJ1YANb1jJ1+CfaWrMbrPHeBfAPVeDxyA35NRxkjV5kEkncFnKh7jnLnL
         InK9vAWcCLTtnCRX5zXKb/10vOJ3PjujiB76GZxm8pdLOtd86VoPqoONx2mK2ZHr3AXD
         eognO1s6PspyAdGT32OQ8TndnMYSdQbCXrl3u2viInXCd+kWjbsHwYHjzXovAYoqSYfB
         IJpcOIT9Z0wNWDyS7IvAXa4BDYcQR4fpDaYoPAs8cyRBUoP8uvh3tYbAjh3Qw/cJAKKD
         w/t1FsuUxzBaBBFZ19JNJb2a//s96WQJuc8uKrQKP7VpztO1YfQn2u+jcROqB6pN69vX
         4+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=oXlNINGpW/hzk951bSn5t110w+o/+uViaNm6S4mwHpU=;
        b=jF8mVYgm+PwdykaaUKhE5emYzfNAj9ryEh/0H/FerPALDqFLUmq/77EdqlmmC7rV2J
         nMlLLlK5GCTiJo3mlUyuPCyVcz4DmTgobANZYJsamLpzDBpozazstVyylSZG9a64USOw
         njYGb8D1OAGkUdwAraoLf3NVPzHXOY0nfqIakDRKkFkEfKGsnfxjlLZwcpy6SUM9WOcr
         MFgfNreevU0pH182hEK2/6LetnZKgRX/b/QpM77PqBpbzw5J9YuwfZ2hth77l55cnHEK
         t7Yt3D1LUDsunyj1cfovISTYVK93hfaTr42BXx/Ry3CBXT83kalBSLRnu/mxMV582Jix
         Oh1w==
X-Gm-Message-State: AOAM5339g+qrn+Qjsejb1SfZp9zGSPRWqUXWlqZ1Kj0cDr6Sv2vAWMvY
        dEKY31Rz4NveXYwmbiHisOE=
X-Google-Smtp-Source: ABdhPJwBBj9QTvnlUddDsQHmy6gmkf+z5bNOGrD18h2lTq2BY8L2HhEJuhZx2KxxfffQzGR8X17T+w==
X-Received: by 2002:aca:438a:: with SMTP id q132mr5982576oia.73.1611412478957;
        Sat, 23 Jan 2021 06:34:38 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y19sm2331644otq.1.2021.01.23.06.34.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Jan 2021 06:34:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 23 Jan 2021 06:34:36 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/48] 4.14.217-rc2 review
Message-ID: <20210123143436.GC87927@roeck-us.net>
References: <20210122160828.128883527@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122160828.128883527@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 05:09:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.217 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 16:08:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 404 pass: 404 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
