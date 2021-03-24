Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43145347AF5
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 15:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbhCXOm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 10:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbhCXOmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 10:42:16 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFA5C061763;
        Wed, 24 Mar 2021 07:42:16 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id a8so21010000oic.11;
        Wed, 24 Mar 2021 07:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QC9Yl04RRN1dr9gjHudNHhgmFiM2HY1qvPpG4GDHyMU=;
        b=iMZyUIIittwdBwbUwbKVXPq486zdYl85QivQeofs/ZS5aASewE3r1rN1fpS8XF7fbC
         tnu2NtQFiGQS4iOIYBKp4v4PsnHtq6F40Kav3vams87Z9PTT3BC4pn2Z1Czaan7ypinz
         mnJ7WIkSZ7KMn0Mx37cGrjsrFQ+VptsNpzbKDxW+7m+Xo9ESl+euFobyG/r+zQVrW9bh
         3x0zEarZzJsw67WlF3ex6j4kNyaVa5ZHqEoCNSVWrgrk8yqFGE9s5RkUba5jgJQXkm/Y
         plhBM9kXZtKzEw5pnEAugxEj7uDbpODv3j9VVRK1RFt0Xy1Tbigl67i5P5vacUnDK+s3
         VzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=QC9Yl04RRN1dr9gjHudNHhgmFiM2HY1qvPpG4GDHyMU=;
        b=qaMdGvr3Iq3BZWXflADxvA8KfcPQcIUbiPQ4cCPYQH0IA15UG5zXU5sgjEavQNXAbK
         Nszp8mC0aRZrCIKDVIJCabHSsfu8C2t+0dRt7IL3SsqPf9YSVxhcjt+XqjG3NWI/bRXr
         jOYRhs3s4VCQ20s1nlGGxnVopAq3e5HFr4LRCACMPgLuDuxV2EcByEHncyywZcI6Eger
         KRBzaOYX0a+8+b3bLgtrb51lo8BXWqPnMTBbkw4sKYLBz0Wx6q3e71B9OUsb9A+S8835
         +hVnxLVOGhmY63I7Y2D5xYqAzEyOFlSijccmuesuvsfBYdsVDStbVCgkA5F5YB+DZvip
         m0gA==
X-Gm-Message-State: AOAM532EETqNn+H0hK1WuR+U4o6VXZ18X6CSSmPmSWWu/e2JbxiZYiPI
        IhxKMZ2CfkLkM8TtTJaTOHd/znrm1kg=
X-Google-Smtp-Source: ABdhPJwJVjJSAiPWJXZBVf8saK/FRo5cPp/JJ243VB3tKmroGn55ys8P0CLqtPfwdJa4RCd2ZkbVDw==
X-Received: by 2002:a54:4001:: with SMTP id x1mr2700466oie.76.1616596935630;
        Wed, 24 Mar 2021 07:42:15 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u194sm430252oia.27.2021.03.24.07.42.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Mar 2021 07:42:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Mar 2021 07:42:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/150] 5.10.26-rc3 review
Message-ID: <20210324144214.GA224108@roeck-us.net>
References: <20210324093435.962321672@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324093435.962321672@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 24, 2021 at 10:40:21AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.26 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Mar 2021 09:33:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 433 pass: 433 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
