Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66845413B78
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 22:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbhIUUgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 16:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbhIUUgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 16:36:45 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C22C061574;
        Tue, 21 Sep 2021 13:35:15 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id u22so1020506oie.5;
        Tue, 21 Sep 2021 13:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=satRlZlie+Jg84wkBEE/ou7KcRSCGk1DvmV3kkfAHnY=;
        b=bose9jK5M/4LYVQtcd9XsixOSSQgYogApQU3sIGOp9s9evQG4U46UnyUzP4fm6CUej
         AifrVT7455MgFVg6oLD0SCovAVFhxwxfFcj2sedneNkPk1mYnjTpcD0qPofP9zCts59X
         zJVr/88gpxG+tLzjvFvLOKiI/6c+/FaBOj+GI7bIyZ9dnXNQ0LTfDJr/ufz3O3uqVqTl
         X9lCwvl3tq/J3kC6yqxJEvsheeEI4SgZfH6SMoqayCTfWcFSd11AS9STt5fgD4JV65qY
         UfjuXyGlclkdn8bWPHGhgv9xr6B7mpFqn9wX96qHRj0B15Q7xoziWpLvTurH2fH0cLtI
         BHeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=satRlZlie+Jg84wkBEE/ou7KcRSCGk1DvmV3kkfAHnY=;
        b=iTFrev8MXVQYL+f6oNLv880sFYGJmTW24Q01+lBFNUUdQLnuKkGP99OGf2OQy812bb
         9fVbZQDJlYpkIPjaAJrnW9flJVlumWkpAOU2BLZThvDelI2OpBck+k+V4Kw1hf4/C+7H
         FEp6VYmI4lSNRbDou6/ijujXPtaXHMXq+S6ZkK1fhSYogfvqlPQrR65mZXj5izB1FLbK
         R7RU9Agm1fQE03A81EBmbku/V9pjRidEcc+id4MW+90kSQbaELZWup9oeZMWHAks4FVt
         E549pwxBAdoPb2bVw3T7334fGqpwAptqdM+MzIpR9iZJH0kqzsypr/SCIbRvTGBsGil9
         et/Q==
X-Gm-Message-State: AOAM5320vcjUAMu3mtqz9iAKGiQ39urcSfVKlYiHLP5TXUGoeYCkOuEN
        Xner9O3aXOX+LSjURTgXZMOS1z8z3mM=
X-Google-Smtp-Source: ABdhPJyFjoED1xPBQlQTbT0k+pY1R6I6cR2FYYvn4zhj1IyQgoFvMZcFIF/sbgq0c+qEJo/wFrBqIw==
X-Received: by 2002:aca:1004:: with SMTP id 4mr5213263oiq.162.1632256514822;
        Tue, 21 Sep 2021 13:35:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j10sm13170oiw.32.2021.09.21.13.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 13:35:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Sep 2021 13:35:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/168] 5.14.7-rc1 review
Message-ID: <20210921203513.GG2363301@roeck-us.net>
References: <20210920163921.633181900@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 06:42:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.7 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
