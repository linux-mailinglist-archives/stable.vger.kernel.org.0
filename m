Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A87F3C3698
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 21:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhGJTxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 15:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhGJTxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 15:53:48 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9111C0613DD;
        Sat, 10 Jul 2021 12:51:01 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so13497957oti.2;
        Sat, 10 Jul 2021 12:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/EB/8U2G1111l+DJMkZi80QsGQf3WJMRitZbswkX5W4=;
        b=b+Gt6i2jFcPD69R8QCzg8MBiOmZJtYZ7qA54L3qPdKGffgfozG+K+Hw4dxhs+zdgmv
         7GnxAzt3+lTV3ARBm+IzNE+bCtiuoZ4pNEFLYj8zNY2t/43WE1VtCqTA8CBqWaYXYCPf
         4R9Tn+R9rBApuCC1LmMVWejE1NJYJ6lVb0GK3oB7O9r2dbYLEM+OSq+A1wldjlGosv7c
         5RWgt+ByXsFPRNFkd2AYsep2PZ5rJArPjjVM3rnTaDIqmPFqxqlhvzAhenwGMrQhCtDU
         F8AceYZN6N5T92MsLIKcROF9jb9jMAbFV44e8Q05AfdrCul7VMFQ443wdxdZXaK/Vd6K
         kzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/EB/8U2G1111l+DJMkZi80QsGQf3WJMRitZbswkX5W4=;
        b=EK8t2e6m1dNdRyyh6uM3vFg1/BzHCoVAEAJXYvnOLGEtra+Zlao6eW/g71ssEE9KvF
         Nh/rsygRprmsrpkDznikJQj2W5wwpWtWENgwOeA23nmhlYJSqYS821UbS1KJHas8a7Lh
         9kfyWd2SL9oPy6KafgOcw3kHcyzBIjxqr2Maxrs2hWQ/xGkfOEJHoa4imhtJaYxaHaQv
         4c4kYbdxI+R0lhrPJPW36hwd3ntevJJrrjGSzzTfgMNOjYYyHYw837sYvlL0JVVmR0I9
         76RKk+EW6hak/R1sOclUeLo2Ac9ZaQTq2dDzTm4Ie3JE52cU1c8RJo0egAT6oajFcY71
         IoVQ==
X-Gm-Message-State: AOAM5339n4ttKt8IRNcYPxsP9kULa80z0Q8NIcieEYaDgiKsHBzJOJVd
        4ssqSaa9c0chRYVvlun8CYY=
X-Google-Smtp-Source: ABdhPJxmLY7YqsWmxqQRMYmdW+4qtcibZueFTRqPd3CG4OOiBFkBF+dLzPMm5iMxoXOnAQfFDYvaew==
X-Received: by 2002:a9d:5603:: with SMTP id e3mr27477535oti.178.1625946661127;
        Sat, 10 Jul 2021 12:51:01 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c4sm2011666ots.15.2021.07.10.12.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 12:51:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 10 Jul 2021 12:50:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 0/9] 4.9.275-rc1 review
Message-ID: <20210710195059.GB2105551@roeck-us.net>
References: <20210709131542.410636747@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709131542.410636747@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 03:18:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
