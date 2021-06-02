Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DAB397F04
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 04:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhFBC03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 22:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhFBC03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 22:26:29 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03783C061574;
        Tue,  1 Jun 2021 19:24:46 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id x15so1274225oic.13;
        Tue, 01 Jun 2021 19:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XQZRxSlrXKPWsFIfaSArrygt9L4IbWOCFh5ezu7ugoQ=;
        b=itLLTZtNYz2OIEeG7voIe9tPqZ/xwYDi6dmEQSi9ipdCMyAyf37K9WnGJPsVLNIEnv
         0VmGlo6GKyZe03L+KMgC0LCDQ0C8/71oxWiIx6YbysnSN/q3kz+SuC5c6zfepngi0OT1
         qsInqkZ+Sb2vfzoI09lifl5jbWKRgnifB1I4DO8LmUWcFe5d0/NES1LlMYax2X/YP+Cd
         KS9hObmUxfZmjDznEPOaSeTqoXyrSHcmUpsIjCJZF1jVa5+Gx02QtN1mLlo+NDl+Aq1z
         duNFi3xFKSOdsMrh5UviQ5yS8qXdAGvGce6mI2vBOoTnMXlP6YzdCvHbbnCyAVKjgxmL
         hvYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=XQZRxSlrXKPWsFIfaSArrygt9L4IbWOCFh5ezu7ugoQ=;
        b=uGfj+oqTaUQP2m801v51HTsIXtwyWIAY8lbabdlHB5JN4gzFxqup36INNkZ9og5+0t
         ZY1q0AG9bj52QMwQ9IS2yqDNQh2hcaBpos460D+6RjXezJg0YihTxu/0XclcpT0teL5a
         anVekZbUWZQ3m6KRKpP7L22raPH4ijtKHLKk/fJAFqoOimhW94JMkTAElP5odrAa4jDp
         K5LQu4xVDeg/L9VqWM1F6VvxBmEcZjJdICfNRV/xrik2IzPMX3DPVotK7rmEMjAhEDxu
         PbBsD4NeUsXU9ir1QFhvsm4qnp5WNQUh4xkD9bU6tUhZ8bsMsVmMPWFaCuKMTJdhL+/Z
         Xq4A==
X-Gm-Message-State: AOAM532c+bUtdU+YjBwU+R0Cqr4i3pwJ/tx5PrLsmtGLeijLUnDeNxZH
        jQzOIOdYYBHYF+Xlb0oT0S8=
X-Google-Smtp-Source: ABdhPJyuw7oNNF+tEG0gl+Qa8iC/E2xN9mxsj1H7QEaYBiHrNhxOQ3YRgxp1R22qx/+QJqSSFXDu2A==
X-Received: by 2002:aca:be8a:: with SMTP id o132mr2090591oif.3.1622600685413;
        Tue, 01 Jun 2021 19:24:45 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z25sm3799746oic.30.2021.06.01.19.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 19:24:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Jun 2021 19:24:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/252] 5.10.42-rc1 review
Message-ID: <20210602022443.GF3253484@roeck-us.net>
References: <20210531130657.971257589@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 03:11:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.42 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
