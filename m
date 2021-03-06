Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABE232FC14
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhCFQvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhCFQux (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 11:50:53 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A801AC06174A;
        Sat,  6 Mar 2021 08:50:53 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id b8so4983790oti.7;
        Sat, 06 Mar 2021 08:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=X4u5CTg6lws4lcP+z+XQOD34GPQao7sgvJqDLqC2bzc=;
        b=acNGURsfuWu+JtzPFFQYlBdtkfnLu0WwPT+DF5zHixwDv3Y2zhn5yIvHq1T7noahkh
         UsKL1cYlrXDqKGE0eNTj7mLW+bMBwfJW8muSCvokUhNrFrsBCROsLC0gXTNcByNlyD13
         Ag5yYimfZBA/qQQ1J/tz6gtD3R/ETKUEQTSPrxL2XebPOi5sBIIqO6enS7PGag83WxcP
         iW/lqwOSU6DLmLN69WTf7wy46N4odDo3dn0shNrFwM18v+yX+9VAy+4Qi7VBgWP7/ZCD
         B0p/5CMayDQHdLwr7+Iga60UnGEmuMgPvvm99rHi3zAHDBCGtN6q/0z1zXbLE6KQl47/
         jA3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=X4u5CTg6lws4lcP+z+XQOD34GPQao7sgvJqDLqC2bzc=;
        b=funno+4DsBqrYzi95C43Vk3cPewOYCmsKi6JRtjFBeF8TfpfCmXUnFMxje7LP+b9CR
         u6zvySpxS+/G91fR8Ic5Npf2tMrYvy4a9RzhV9de/i3mLKfqHBkdY/AXx44zS6Hu/VEH
         i6q04S2DUm8inZS23uJl+9eTAQjr87HjXySyKmPA0LxPTTd1g5+pNCgGdiBwsqlluM3r
         WpO+GKMbUhpRPgYQ2OJvJgUilpgvjYMmkdB3jVtHHqg5iP0jMFUTNLJLduXevRdGYsjj
         n8vIC66m1L+mncAL3kLBcy88AkckrzZdnMn7xM40rODR6yXiot/egQDB04c24WsXMR2s
         XNcg==
X-Gm-Message-State: AOAM533VIMgQ4mNb0IUhaSRPrZ1wQkemkpbURM8v3Dn5wIe0GI8Rhz8W
        8IP4c84Z9MPfMoTynog2yQc=
X-Google-Smtp-Source: ABdhPJxg4/OGjPzKaIFOW+Q/OFOGBbOHljpthcVdw9J1YXvP14VRstzGH0VaRejXmXsTqGoGMU9PHA==
X-Received: by 2002:a9d:6390:: with SMTP id w16mr8168406otk.178.1615049453002;
        Sat, 06 Mar 2021 08:50:53 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l191sm77870oih.16.2021.03.06.08.50.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Mar 2021 08:50:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Mar 2021 08:50:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/102] 5.10.21-rc1 review
Message-ID: <20210306165051.GH25820@roeck-us.net>
References: <20210305120903.276489876@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:20:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.21 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 430 pass: 426 fail: 4
Failed tests:
	arm:realview-pb-a8:realview_defconfig:realview_pb:mem512:arm-realview-pba8:initrd
	arm:realview-pbx-a9:realview_defconfig:realview_pb:arm-realview-pbx-a9:initrd
	arm:realview-eb:realview_defconfig:realview_eb:mem512:arm-realview-eb:initrd
	arm:realview-eb-mpcore:realview_defconfig:realview_eb:mem512:arm-realview-eb-11mp-ctrevb:initrd

kernel/rcu/tree.c:683:2: error: implicit declaration of function 'IRQ_WORK_INIT'

Guenter
