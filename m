Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A248F20A270
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 17:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389744AbgFYPyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 11:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389678AbgFYPyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 11:54:22 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA0EC08C5C1;
        Thu, 25 Jun 2020 08:54:21 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p3so3487384pgh.3;
        Thu, 25 Jun 2020 08:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t3TNDoNuL9vjeEkISORiqXUd88wGv+PqQ0SpmQj4j+E=;
        b=DuiS5JyzlWIwBUWUokM9JQo1RGFMRbVaZL/De6h7AvRGXjTNCAJ3ffedD5WXnGsRBD
         CBCw3i2xaRN22fTRsDIipu1IPSJAemMIL2YVfAikqM33geN4JEZs5niFHlHU5oUDdPiV
         7L7KHynNwrn0eeS6tnL+/09jxwOKibHClV53vRR4BZUETj0s8edAAo9hyn4duRnfuiZQ
         3bHKc2mXXkDEVO6RR2DcpLIEb4QUUk5ZGvyeo+0t3ofQ18wrXSWmgzrcfHbEAzLb1IXz
         f5qebSOPWoCIwiFsBPIxhp89D6qceBQPm7kPvBgky2ZxSSl9xu64uEzVmqOMqbfOpGQ4
         Dx1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=t3TNDoNuL9vjeEkISORiqXUd88wGv+PqQ0SpmQj4j+E=;
        b=NUTqcK9Kpv7R4WaFF3q1y9NhdObvdoc9WVvlUh4OA+r6UvJQlGSPY6z4IXNsvLdt0T
         LfhCI5OUpH/K2hUYOH4BiA0RfPYvsFYg5sOIN2Tkl542MEdrnx7hAqDG11Ka/NN9ukmK
         /LXWER/AH8JNU5g/cskXuTfG8IRzWrqlLNpamA9uP0bvY/sNtMmLqTd6mmlat0MHpkz6
         ETb8WW7EiwdkTTtGsgQGKoimQ85qvr4JOmLIzuD8Qz84brFgNd1xutPDOpuky9liudJL
         LRWqYlACzseLzFoVY11HgUm4k6XEzy0vy371SLhVLEkXOXRQAGDzMYFDmkz/73ObOT2R
         FyZA==
X-Gm-Message-State: AOAM531YLGpbiHdrTNWXCDS4u/y3PvStV1lCPavpDQc4ns6/D3zcmVWt
        cKFNKlIYCE1CL7wkgkvoBv4=
X-Google-Smtp-Source: ABdhPJyZNWcj86QyWLzSW1e3a048p2vmzm48x+k4iqj6rtb65Oa/LRY9Ue+g+hpiyuVBw5kuunDwaQ==
X-Received: by 2002:a63:2946:: with SMTP id p67mr3394288pgp.227.1593100461488;
        Thu, 25 Jun 2020 08:54:21 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i184sm22745477pfc.73.2020.06.25.08.54.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Jun 2020 08:54:20 -0700 (PDT)
Date:   Thu, 25 Jun 2020 08:54:19 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/139] 4.14.186-rc3 review
Message-ID: <20200625155419.GA149301@roeck-us.net>
References: <20200624172341.891497820@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624172341.891497820@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 07:26:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.186 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Jun 2020 17:23:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Guenter
