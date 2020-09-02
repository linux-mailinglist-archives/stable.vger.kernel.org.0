Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0502425B217
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 18:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIBQvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 12:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgIBQvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 12:51:54 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F23C061244;
        Wed,  2 Sep 2020 09:51:53 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id w186so2824266pgb.8;
        Wed, 02 Sep 2020 09:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MDQ6zE/6jTTf94dZqMVJJO0yNqdkkuqD2ZIum9z6agY=;
        b=D5HWNcO3fqSJb2fbmO436H6p2IureVMKox8lMGdkpsJhCIMWALwgteR47zQ1PL3OED
         Bpfsbk08mMDQOTjkhJuz9QB3VeBDJIp/nxBTfxyK1tW/R4JXw8LSoyigApMMxm86XSul
         6ZcIlk1BD124Jr1n4VhtpEw6k3aNgpEl0c4lGTlhdmiXiXxqkMd9qCN5R8qwzJzStnbs
         YyNv/rgNhoi98eXPOuhel175ds+TbLZkyUZt/rmjN7eAmcLBgUXDsaGCaJyWWP8OFvvJ
         XYhfM9jWPa/tvpa4vyrpBac7u5u7dMhPhHXqqioay6s92XxVCqvl+NR/eEN1CwPWyW8K
         ofDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MDQ6zE/6jTTf94dZqMVJJO0yNqdkkuqD2ZIum9z6agY=;
        b=A9vVVJ+9s1Pm4JZIskIrmf2AIHjhKADPP08f5E6yFhSHozF118gMz80hK9ZXfnIVn5
         9xweXw/AWe0ZPzJbghXd0pCeo3QI/dLm6hPZ7hSiYUjxyq7WKVVxwstF9En0z5O3D4ll
         AnYH1NHrBbZGZPlC9oAdfj9HOdfjHCwvHRMKIJzRK7RXaCQ7EO/qhao0Jmysr3gBsfmY
         lo2h/n8J5R1YS8wzhA7OteTnqlh/BbC9pP7idS6dKD5/MBO3OfLwrLpy32TzFa5vSQzN
         3rShTflbYH3NxT/tk4KPes6u0XZhZsiwZAwtoRgE9Z8KK0DsDNQHjauELxZsEglwXd41
         ujPQ==
X-Gm-Message-State: AOAM531X7JOsmg6h6D+sJvql1kjiucn3F8nAZjm3GsFrhT/ft52FHQ7Q
        /1v0HPPUGLJ+C7w0FKG89bI=
X-Google-Smtp-Source: ABdhPJxXmqTQh+bXXErTrtCeqxkYMajb6H/4VNuRUQ6RN0T/bivgtsl8lU1x28vNKFgT7k4c/QI+9g==
X-Received: by 2002:a63:fe06:: with SMTP id p6mr2544230pgh.337.1599065513033;
        Wed, 02 Sep 2020 09:51:53 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m188sm26713pfd.56.2020.09.02.09.51.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 02 Sep 2020 09:51:52 -0700 (PDT)
Date:   Wed, 2 Sep 2020 09:51:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/253] 5.8.6-rc2 review
Message-ID: <20200902165151.GF56237@roeck-us.net>
References: <20200902074837.329205434@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902074837.329205434@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 09:49:11AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.6 release.
> There are 253 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Sep 2020 07:47:48 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 153 fail: 1
Failed builds:
	powerpc:allmodconfig
Qemu test results:
	total: 430 pass: 430 fail: 0

The build failure is:

Inconsistent kallsyms data
Try make KALLSYMS_EXTRA_PASS=1 as a workaround

The suggested workaround doesn't help. I see the problem in mainline
and in -next as well, and it is elusive (meaning it is not easy to
reproduce). Given that, it is not an immediate concern.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
