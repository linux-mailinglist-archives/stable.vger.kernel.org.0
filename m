Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4CB2F8785
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 22:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbhAOVTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 16:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbhAOVTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 16:19:53 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E1EC061757;
        Fri, 15 Jan 2021 13:19:12 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id i18so2565865ooh.5;
        Fri, 15 Jan 2021 13:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yy5qeb8L4u1sOYNhhKkl/mSrEZopMjbVurxMtyU8LtY=;
        b=u4rqO72uRUSKDM00zbBmJla/BEoVM6ys6QFjH9ueHeZs1nkkJcogZSQ/cPNQ2di0wn
         hSsxSTasox33EfS29I2yMWZgMdVp13f/vVqh2folocl+RhJezH0NK33clDNqO+8Awv7e
         YvwvSANJ3JKlHYj27w+uUg2e8NJRzTtLPWTQbfpp7fca7tNVNEUXbm//gfKhuBm6iktF
         mX9HANCZvhE5DYqvapmV3j9ScOMx9FVsjcI0843RWx5kBrn+UdgKISTMig9w4a9O5117
         mT9OEnxtu4ccbCWNaZ+tEzKB40ykjaTApITwqTJE9K8GBw5UOvK4ywYSsHjAg8Umbqy3
         3udg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=yy5qeb8L4u1sOYNhhKkl/mSrEZopMjbVurxMtyU8LtY=;
        b=K5zlq4cVLHhmnVEJMAsHEq6GixjAwnI/CrxqOeP5D8bZydz/E/ewx/WFjQvfue7ILp
         mbLHneR+Hv1BktwVZCgWc3g74djmBFIG8C98uwZvY+wf7Xjt7hOFEs7OOCwDtnbPuVmz
         650wUF5V7jTGNSAmFOd2EZ87fFH0W+Az1mlPQvq3SRGjwiT3HMnGBqH4X/R71iXS3tCv
         BAly09Jzbiawkz5/eH537WKGdLxLKGEzw8LETDVQOijS8WM3vlhCM7TXIxXqi9HGln7A
         BZlAeTCyiCFw69060uDWP7WYcbmgOtvvrxptb7R0q+qqGeSIVuQH2yWhQ/+5LECMnOHk
         JliQ==
X-Gm-Message-State: AOAM530K9b4fJ39X5ld0NX6AgBlPHCkTcXti0JIS2J1DuylbxPlv1aFk
        YwqA5TLy/3Ap7wIfbjwiixk=
X-Google-Smtp-Source: ABdhPJyWKB96gpQwweiSoxXtpWN38r1Q/KDY2NwB9A08odYWZj6DscqACHUlYqHppzRvqsQg8G+sLA==
X-Received: by 2002:a4a:b2c6:: with SMTP id l6mr9642183ooo.7.1610745552479;
        Fri, 15 Jan 2021 13:19:12 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e205sm284457oia.16.2021.01.15.13.19.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Jan 2021 13:19:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Jan 2021 13:19:06 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/62] 5.4.90-rc1 review
Message-ID: <20210115211906.GE128727@roeck-us.net>
References: <20210115121958.391610178@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 01:27:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.90 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
