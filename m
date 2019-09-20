Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8838B99E2
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 01:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfITXAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 19:00:04 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44340 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfITXAE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 19:00:04 -0400
Received: by mail-pl1-f195.google.com with SMTP id q15so3851542pll.11;
        Fri, 20 Sep 2019 16:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=De39hz22dQEBdHKSHHQzsk2bdb/AfbkcxOJ2cj3f/3o=;
        b=QmGf8fnoSJRL9b9fpyAuTeFHcrwMZPJsqHGXU7uNtnUWLlEtz70iBWSjg+CZZDgPQu
         0PrETpgXtN/ERBiq+oTCvXWlTP+G5qMFKRhWEsIwS9sY9Zqp5BsdvVAh2xd+fezGt4kZ
         +xAEnsuF8EBfkiIZBUmS9tfGNqkSK0BCOzRBAuV4NBMqjI4HWj6Eia0w1XAXy96gdLky
         6BMWXOOZ519Kgua50FyFXGydzZg2jIA2B+kunb80hb37ReJgfgsaoYyQ8XJsVCzwoiub
         DlHnfzYmdVqtZoTqm+eaCm2Pl0op2IYKVA1MTZyBpwvRdP0Y1aTpmT9qB22IBmO4J57q
         TKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=De39hz22dQEBdHKSHHQzsk2bdb/AfbkcxOJ2cj3f/3o=;
        b=kbdxE+u7ehr4IN4mVNbnMhQapBW2K4YdVjoO5RJxerbVRmz8YXQaLL3ucErssQxJPZ
         spaymETtXQxXAiUjqtLa6jdIpbqo76GvGnPG1X4VUlur4G8yVuqx8JN7ywGZ3cQ6XL0H
         jGWoG5vGrhclRiPrAme8DqUKoHyZKMqXHPp2EAnRqfhaM6W/GcL0HyjRQsCYOWeMWb38
         lmOy8gSfRfnOu212w+uFNMArPEVkyvCrg/bJOovBItaBM9iTgl/sx07w8Vyv4ZFnjNmw
         11zWulTMBiDNdAuNihjjPE7WgIoP4phAYGmtEpPd6jIwp9ZdAtRDe9ZkBOYRyYXOjzVr
         2MwQ==
X-Gm-Message-State: APjAAAUOrOVDpeP8+Qq4y5Lwg4cnwSkakk19sww0x4UMxYggyjHsqXWu
        qC7wZk6t7UuYBp/mMKxX49neq1OA
X-Google-Smtp-Source: APXvYqybAE/L6AhdiFAn0l6VCwfk1LdQL+NW9LSz9muG45nl6A9wP39gqunIAizGq/KYVzKUstRoow==
X-Received: by 2002:a17:902:8f88:: with SMTP id z8mr5494597plo.232.1569020404056;
        Fri, 20 Sep 2019 16:00:04 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z6sm2914145pgk.18.2019.09.20.16.00.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Sep 2019 16:00:02 -0700 (PDT)
Date:   Fri, 20 Sep 2019 16:00:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH 3.16 000/132] 3.16.74-rc1 review
Message-ID: <20190920230001.GA32583@roeck-us.net>
References: <lsq.1568989414.954567518@decadent.org.uk>
 <20190920200423.GA26056@roeck-us.net>
 <8dbced01558cd8d4a1d4f058010e7d63e5f6810e.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dbced01558cd8d4a1d4f058010e7d63e5f6810e.camel@decadent.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 10:16:49PM +0100, Ben Hutchings wrote:
> On Fri, 2019-09-20 at 13:04 -0700, Guenter Roeck wrote:
> > On Fri, Sep 20, 2019 at 03:23:34PM +0100, Ben Hutchings wrote:
> > > This is the start of the stable review cycle for the 3.16.74 release.
> > > There are 132 patches in this series, which will be posted as responses
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Mon Sep 23 20:00:00 UTC 2019.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 136 pass: 135 fail: 1
> > Failed builds:
> > 	arm:allmodconfig
> > Qemu test results:
> > 	total: 229 pass: 229 fail: 0
> > 
> > Build errors in arm:allmodconfig are along the line of
> > 
> > In file included from include/linux/printk.h:5,
> >                  from include/linux/kernel.h:13,
> >                  from include/linux/clk.h:16,
> >                  from drivers/gpu/drm/tilcdc/tilcdc_drv.h:21,
> >                  from drivers/gpu/drm/tilcdc/tilcdc_drv.c:20:
> > include/linux/init.h:343:7: error: 'cleanup_module'
> > 	specifies less restrictive attribute than its target 'tilcdc_drm_fini': 'cold'
> > 
> > In addition to a few errors like that, there are literally thousands
> > of similar warnings.
> 
> It looks like this is triggered by you switching arm builds from gcc 8
> to 9, rather than by any code change.
> 
Ah, good point.

> Does it actually make sense to try to support building Linux 3.16 with
> gcc 9?  If so, I suppose I'll need to add:
> 

It helps streamline my builds and reduces the number of compilers
I have to keep around. No problem, though; I can switch back to an older
compiler for arm on 3.16.

Guenter
