Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F773B52A1
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 11:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhF0JAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 05:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhF0JAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 05:00:36 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC88C061574;
        Sun, 27 Jun 2021 01:58:11 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso8331594pjp.2;
        Sun, 27 Jun 2021 01:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sJzQYMfdLr/FWwnhoBx+HcrPD/wFgYM+uN9MRIrljR8=;
        b=k8usj9rD4Us1Ta2dllTQVyixS/TGHTvls5PhYg2D8pvVJVVnKWHZ7qHavotUcT+kF5
         8hbmY2v5C9rvFFZ136lNQ86JYIHN5n0BC0vxTtA/VK91AFvovH2d5Xje/wXeC3xqcZcQ
         fHLu6RNMVXQ6ncA/dmnHeoxbUhN07tJKlmTyEjH5+T4yTPry2NTNwg6VuNLJCapovvLc
         6pEVHw8LzpugSiw7i4zxvCbWCQTK13HCXD2rLBVPtNFPwdgylFDGW7yeyeLIkTFBpGEk
         4iiUYLBJgb3Pevw+qrEGaQKrrhajwBWoL1zjC+udpgnK0S3sYF7cnG7ueduuWe5reWx2
         z/hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sJzQYMfdLr/FWwnhoBx+HcrPD/wFgYM+uN9MRIrljR8=;
        b=WgkV4RmZ24YoIPgOfTzcM7DxJFT4dDfPNSGXIGiIbJvR8uYc5+8YzLUUXBkZVTZKgo
         jxZvam/Nt3YULuiFQwthoaXD2hLSTs0P49gfVbrw2AF+4Wklf2mp70GoqjHLfvahAkBb
         Wps9vUu6OaYZbhoB0eRAryw9Q/bBw45MAgf8LWs7oQUGhDvb7Bu6Tv/OzA4gtodYxMiJ
         D4mPvA0CvAWEQwFcLIJK3u5DU6r06xykuYMWEqnNmW3D5YpoGGTUZT4SKT9SZt2ilx/i
         /VLKlX3/zdmAk9r8AD5LoySas3F/ZVZ+ZkuM4ldII9ValagSnRZ1CJQn76nXkz3oyf8k
         7Nqw==
X-Gm-Message-State: AOAM531MN90ReejY6HSTaXKQzIdQztalHQpf4qHOgVfY18+KBVanYsNQ
        Vg8AKngddMXslF9ZwoeajfhJoVyKxyM=
X-Google-Smtp-Source: ABdhPJzcGmGYVGnegTe6jQczhUbL6Z0LBn3xQX75wSkQVEK33XLVVPWIuMjkTMEkPJGsJsb4Q4orJQ==
X-Received: by 2002:a17:90a:d09:: with SMTP id t9mr16134874pja.66.1624784291144;
        Sun, 27 Jun 2021 01:58:11 -0700 (PDT)
Received: from mail.google.com ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id n34sm4256697pji.45.2021.06.27.01.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 01:58:10 -0700 (PDT)
Date:   Sun, 27 Jun 2021 16:57:59 +0800
From:   Changbin Du <changbin.du@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 045/146] net: make get_net_ns return error if NET_NS
 is disabled
Message-ID: <20210627085759.n75m3uulvll47bdf@mail.google.com>
References: <20210621154911.244649123@linuxfoundation.org>
 <20210621154912.823486108@linuxfoundation.org>
 <20210623142635.GB27348@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623142635.GB27348@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 04:26:35PM +0200, Pavel Machek wrote:
> Hi!
> > 
> > There is a panic in socket ioctl cmd SIOCGSKNS when NET_NS is not enabled.
> > The reason is that nsfs tries to access ns->ops but the proc_ns_operations
> > is not implemented in this case.
> > 
> > [7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
> > [7.670268] pgd = 32b54000
> > [7.670544] [00000010] *pgd=00000000
> > [7.671861] Internal error: Oops: 5 [#1] SMP ARM
> > [7.672315] Modules linked in:
> > [7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
> > [7.673309] Hardware name: Generic DT based system
> > [7.673642] PC is at nsfs_evict+0x24/0x30
> > [7.674486] LR is at clear_inode+0x20/0x9c
> > 
> > The same to tun SIOCGSKNS command.
> > 
> > To fix this problem, we make get_net_ns() return -EINVAL when NET_NS is
> > disabled. Meanwhile move it to right place net/core/net_namespace.c.
> 
> -EINVAL sounds like wrong error code for valid operation kernel was
> configured to do. -ENOTSUPP?
>
This is to align with the existing code which returns -EINVAL.
For the issue we fixed, yes, -EOPNOTSUPP (not -ENOTSUPP) should be better.

> Best regards,
> 								Pavel
> 								
> -- 
> http://www.livejournal.com/~pavelmachek



-- 
Cheers,
Changbin Du
