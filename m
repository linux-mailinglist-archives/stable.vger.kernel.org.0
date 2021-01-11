Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A202F223C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 22:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731601AbhAKVxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 16:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbhAKVxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 16:53:22 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1067EC061794;
        Mon, 11 Jan 2021 13:52:42 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id b24so375437otj.0;
        Mon, 11 Jan 2021 13:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MNlYwxDOfslgb4S7/BZu08Qx/liNx2QumVwdNmujsoQ=;
        b=TDH7ifkjS0HCskFq6Rj4uaYHTdezLIVHxIYoFjYzTR4R/ZYvfmGWsK77yupfj0YGIx
         sT5kB1gpha9/CeANMdNAhOKOPwEiWoPM4LYujfvNrDDNvosQqi5WK5EgM0bVBkMB8/JC
         0hD5aXe+3KQ6fspboDaK99AKTG45Zg2jKQySWFpIFmf8HQvrZixHQZdzSBp1Q0u7ZR1d
         05U1F09NzGUotCBiWE9mgSADMXt4s/5y+LQUFipa3f2YnPhFjIjuXueAwqcGbnypt6up
         1eQUIYQeq74IkC0AqNKb6f1U/Ppf2EtWJrw9JRZg/izYTnEXU1mVUjb4QafxaXKtT+FI
         bBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MNlYwxDOfslgb4S7/BZu08Qx/liNx2QumVwdNmujsoQ=;
        b=M4KxqqQML1/pnogjUOjmMImB15e07GKEW3IPIOOYPh6QMuotaB45lEok6+p7X5q8U6
         00/mupqe8YYOXNs4Ps4lrRzqIIA8WV9aV6wx/pdPHDxGuMLHsrP0D3Vb5Eor7ynM+E+I
         fi0NuAnkbpsevMcAND+u+jalDJ0sGiwr9NAOgtdzV4h4+071ubzVKNTsEwvKx9cMYtgg
         N9YGsj7Z/+bY/JYQASjiZHLyTz5ILFLtQr/V4vtWQPVfnOgcBt7ssXNgJQmDkYa5aNtI
         tZvcfhi6P71M3AxeaOgS4xgTPBxDWi2hgLvEWfx6vlPKvFrgroZ3mlbGuVgvzVs0Dlh5
         pUeg==
X-Gm-Message-State: AOAM531SGUyMYb+1+HJdG0uc2J6CwhMLLQWw04NuFwvHzWefsUNYRG6j
        5kxgeMbjtZwRGl+KraSy6WE=
X-Google-Smtp-Source: ABdhPJwmK2YKD4E1E7qcnPQ6Jsyb4/JTSBDMFg7o5fK5XJFPn7ZpiFypMbuiY4rBZomNp2hWfQ/ONg==
X-Received: by 2002:a05:6830:11d5:: with SMTP id v21mr751004otq.306.1610401961548;
        Mon, 11 Jan 2021 13:52:41 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s139sm230934oih.10.2021.01.11.13.52.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 13:52:40 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Jan 2021 13:52:39 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/45] 4.9.251-rc1 review
Message-ID: <20210111215239.GB56906@roeck-us.net>
References: <20210111130033.676306636@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 02:00:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.251 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
