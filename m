Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD0E31D058
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 19:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhBPSoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 13:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhBPSoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 13:44:08 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1C0C061574;
        Tue, 16 Feb 2021 10:43:28 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id e5so9844218otb.11;
        Tue, 16 Feb 2021 10:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4yddHhHsCDSmvH6sC9R133JWOjQtgS46qmSc8mBh4uI=;
        b=t+K+NQP75QETK5F5LLYCzppT7Zj6gA/RAy7sSW0qGcuPGqXbDAgjcUdL7FYVeoaZrk
         DDfuee3+GuzJj0IX2cy8PdK4B7IEljnzK/9+gLvAg6kwf8J6zwtf5U1QPbwTji6v5PpR
         ABLzwVWFKHQNCAksbUKhu3z9QZ28DnifNR1GTi8BmD9vux8GPgZo82AqsACcMbKWn3JY
         9vGp2n249bzu3sysZkZov4V86H+DQXX7ftUBojYd6UDpUYwQjoswElwHg391BpaaDNzX
         miK/XHoKocOthH98hXuu1tG9oWxGMAve9ddHZd1HD82gVRr/ylS4QfHVh0fS5L4jm8z+
         bYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4yddHhHsCDSmvH6sC9R133JWOjQtgS46qmSc8mBh4uI=;
        b=dqAC52ZNh/CmDJFBUVTv20UTieBEObziIkV+1CDZGQGIE0anfMvBkP3xZeN++fhZVk
         dDrIw5BH+vEocflyfDuJkodaMS+psIoesyaMX9rmc36mqi3CHc3y6akch/BwPZh7dMth
         /GMEU6a3uEAbp48/iN+Qx7Tx4qX1GrxwUb9d/frSmI2GkypMuu37hvdjCe7fZOR6fHWZ
         KAqfQYWN9uR6+UTIJbbWMuGuR+DsLlPk9cuWXUK/+xMlh9LVs3So4IrUx1Fqlr5emFfS
         ciTY8fZ8+twWeVwSCfAlKWxdAaDva0URXrs3QHbSsj64yG1yhQiroFBTb9TZ2DVNHG/k
         M+WQ==
X-Gm-Message-State: AOAM531E1irYBmbsf+phcv8G0FWTB4wiEPJklBngLeDjsMmZ3Smw1E60
        j2WMCj7lbeILSfPk2wxS+CnKBu2VJ2E=
X-Google-Smtp-Source: ABdhPJyzO6HuDHLY/Xq1kU9U2aHTgvqXWm8i/Qp9r1JU4gXUAId1IUTvbyzdVxzMlJNDVCL6AQwkdw==
X-Received: by 2002:a05:6830:56e:: with SMTP id f14mr15313301otc.85.1613501007907;
        Tue, 16 Feb 2021 10:43:27 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o20sm4025942oor.14.2021.02.16.10.43.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Feb 2021 10:43:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Feb 2021 10:43:25 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/60] 5.4.99-rc1 review
Message-ID: <20210216184325.GA85364@roeck-us.net>
References: <20210215152715.401453874@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 15, 2021 at 04:26:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.99 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Feb 2021 15:27:00 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
