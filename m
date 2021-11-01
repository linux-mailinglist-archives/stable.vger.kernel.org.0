Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253C5442430
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 00:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhKAXkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 19:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhKAXkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 19:40:25 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F359C061714;
        Mon,  1 Nov 2021 16:37:51 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id o4so27280741oia.10;
        Mon, 01 Nov 2021 16:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e2mdM0peCZ4cgcx4A3YAk77zuJUshS0glbkrFtwmIm8=;
        b=qUjrSiy+Jtac+F/8hwEpP1b/QGdCLzQHSEyWQ9AbsztHNtqmsQFLVyG8/xMZNjwY5p
         nnNR1egNnD/Dhrp0jTq3ZW51ZCqyXoRyTeX1STjKOw6gkKBBw32myX+l3nMgI5q5om/k
         MC4xlFjPDzn0x2rdbv9llK4riIDTYOzONcn5hscMRx6XJRQQ9LJkF8dHIdOb2QwG1An6
         HbXfyK/rsN6ud3kl3BB8OEpeTcOuDMWOwHeUxRUThJC+vPGwCO7UGcVqxbPI/OMOwiol
         xkEkqVHypTgXc5h6HFBknxkySCa5LxMc/Nv/wBxYchPJcePPQzGKblzySlRHniOv2wTu
         bfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=e2mdM0peCZ4cgcx4A3YAk77zuJUshS0glbkrFtwmIm8=;
        b=rqYOYauQ1xlWIUWik3C46ztMzWkxRR/ftzL2NhYLUYWy+RWA1FOcaNmaEengTriAvt
         12oujwuZ7YdaQh7Oixil6CuEw5d3wjH+cnRnjf58CLvcxmSoDroTQSIn/AplakiOXfaP
         IRQvULkoWAe46uT/mTBDPvicPYZ5IaE+97VlLIL0I/a1rfha6286tZp5rp6y42DlYqMj
         0/H7JynGBQzpVLvvNmNyfxqxBZ2Nt+N3DRflxMS4hVQuYqpwF3QEaymiKUJqDlirM+VV
         SBNvh7xiy2AicUJJ8/egskocVOQrGhD24yWaUqrhhMs0NYO39b1CEoU84bYbm+NWIQ6J
         G/MQ==
X-Gm-Message-State: AOAM531qHNjoWLdyfHwu2QkrIaTJqPINtufuN3uP3+QFv27eXpGcH2ol
        ll7xoVXOaH4r8SrdphB7Uk4=
X-Google-Smtp-Source: ABdhPJxvllxAZMZpwMyygSo/lWAKyyK6sDr+v1M2vUCCKHDiWlmrHGET+i5Mks83/tUSG07IKNnApA==
X-Received: by 2002:a05:6808:17a2:: with SMTP id bg34mr1887574oib.70.1635809870721;
        Mon, 01 Nov 2021 16:37:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l2sm4513099otl.61.2021.11.01.16.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 16:37:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 1 Nov 2021 16:37:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/51] 5.4.157-rc2 review
Message-ID: <20211101233748.GE415203@roeck-us.net>
References: <20211101114235.515637019@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101114235.515637019@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 12:43:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.157 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 11:42:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 446 pass: 446 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
