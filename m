Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F1D354666
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 19:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbhDER7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 13:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239751AbhDER7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 13:59:44 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D80C061756;
        Mon,  5 Apr 2021 10:59:37 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 91-20020a9d08640000b0290237d9c40382so12103757oty.12;
        Mon, 05 Apr 2021 10:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j5wT3EeeUhpIAzQZuAJ0Ik8BuZs88e1yAbvHI4LpLpU=;
        b=FT4CMOpPgiuljMMfKKtfmoJtoca+/u5rssC/vZo/bANtNvdxaR1jLjJPgT550gIfNM
         /K0kgCs+sclUA24QrXcWS5X+gSWtEfmN2mK4ZDx38upzxb69B3zKrH+aMOQsM3buFVUu
         X6vasaPzUgHFPB+LXEFGxEfgnm0PSyKSnY6Haa8o1vk3TOxQ20B1qYprqEaoGJ6vj8Yg
         A5XbGkw11Kh7B1kAl5dRXd2lOnyi/FRP1KxNUZHREQPQ+GnwuPmLpsmDq9CPIZxIIyrC
         XplMFVQy3x1It88cLJu2MLtk5Kf9XA79l2YX6xEB12NKzauLpXYlTfXYGOfOvAOkZJHG
         fUkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=j5wT3EeeUhpIAzQZuAJ0Ik8BuZs88e1yAbvHI4LpLpU=;
        b=Dwl3oRWpaoO0JjKt9/EviSrlIAUkMJji0W3n6YpURzNl3SpovQjpBoGs+q/PkiD403
         zIrYPv5BYLuEr+oKjtILZxPi3hgT134NvbToqI2ohi4jKYaaiIbqddPVqZKW/NNSfoqn
         kekHl3f8OKXxKPLeZKO6IvsqYkj7FOaO54J5/rCUZTPRLC3ja4XhYc0Rbxy9czt8xf0k
         c2bJQaoH+EuvyWuyA0bFuaDfJ9S59aHeDUPxPHCit0HCKOqlAMUjTnQinu09+/dllX6g
         vDkRE3D+KfUaAv9IUKsTdfjm3VS6Bxd6S/LRhJDttE0Ssjng6nW4MhRfP3mpt9wD9vCO
         1nxA==
X-Gm-Message-State: AOAM532A+ybWe8QPMXdS7xK9BuuGmwAQoq37IxT072JcHTb8sjpgGMKl
        ryv4FMmtrSyXXbqWcmaPT1o=
X-Google-Smtp-Source: ABdhPJxjfVLIS/GtTvLBz/5I/QS8aEVvNwVkSZXw1LHbt+vrhmUHiAdeS9kl9DzSLgbyiU/p/Dr62Q==
X-Received: by 2002:a9d:4792:: with SMTP id b18mr23243263otf.350.1617645577179;
        Mon, 05 Apr 2021 10:59:37 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j4sm3470094oom.11.2021.04.05.10.59.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Apr 2021 10:59:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Apr 2021 10:59:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/152] 5.11.12-rc1 review
Message-ID: <20210405175935.GG93485@roeck-us.net>
References: <20210405085034.233917714@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 10:52:29AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.12 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 460 pass: 460 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
