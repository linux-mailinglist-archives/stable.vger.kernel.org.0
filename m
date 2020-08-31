Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D10257C1F
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgHaPRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728415AbgHaPRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 11:17:19 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCE8C061573;
        Mon, 31 Aug 2020 08:17:19 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 31so740117pgy.13;
        Mon, 31 Aug 2020 08:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o2tp+O/fvjT5GP7vYXsEtBxLItwJjgYMH2teIh37dm8=;
        b=fNUV6toFn7/F1MjitalN8tMYAdmNugJVStqW3KuHLW8doFsghzwRNbMHMLvicQE6wU
         yFofiIJnd8S69MJ0qisVO7fMjkiOZHclHUuY5vkd6z3h0KcquKCm0Kf+4WcGl8Y3p3bU
         jigUTQJC76Tl514EcN8HKe7gRpcJgnqwSkHIwdUSm8MYTz+Bh1819ZA76HUPW6K1UHMd
         VEHwZxciLUwUDoRkNWmCX6i252xAdWYuJ08KkPYM5sRBPFOBhisj1cfjYn2wn8U1u2nP
         lIpj0joCbU5Eqq+OBG6/flvFI0V4Uz9LDsq20f015T2lWJMjUYbooY6ZnBO9BZeOv3U2
         UwSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o2tp+O/fvjT5GP7vYXsEtBxLItwJjgYMH2teIh37dm8=;
        b=J5MwiZqccg5snq7sMKbDL0DbPTelTq2mspcji7PSnwZ1N1n/eyYbNZzxHxevlbXXM3
         uHBXOhFmItoXyR7Rfj9VmPUIdDGSTDJLAtaWH58yjTwTcGW8SGZJ8CeF+JTVkwH0GN5e
         fOkvnvKEoIcBNkibpTLrgjRtUvcGd/2WpMcvadaooxMWcN5y7rED3NoHAq2ZbVzZPp1b
         5XYMzHac717UTMRR5+MiYLqDdZ8640n4z6COrR2u200MHRjqCw8UPhK5YMljCDEJVq26
         hkHuQKILwaVz/JBH0VscXX5ieeF/BsEDYy+BHDKzswMIzgxBSbDX19Eo0FgF5x1hHkLO
         RAKg==
X-Gm-Message-State: AOAM532SDQwRkR//m3QWfjq38az11UEALh00JtpPkr6DlfPSLwWHbwYg
        CW00/OYfL3w2wUN9zQsyvys=
X-Google-Smtp-Source: ABdhPJx1SK62N2vqqPYnezhgTvO4C1jj3h6FfAnSTjpgrQAL8dJyzQVQ7aOaz5lp1ITWCAROkcSEcw==
X-Received: by 2002:aa7:8430:: with SMTP id q16mr141766pfn.69.1598887038744;
        Mon, 31 Aug 2020 08:17:18 -0700 (PDT)
Received: from gmail.com ([223.190.108.199])
        by smtp.gmail.com with ESMTPSA id y7sm7528471pgk.73.2020.08.31.08.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 08:17:18 -0700 (PDT)
Date:   Mon, 31 Aug 2020 20:45:30 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Jean Delvare <jdelvare@suse.de>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: i801: Fix runtime PM
Message-ID: <20200831151159.GA11707@gmail.com>
References: <20180627212340.GA161569@bhelgaas-glaptop.roam.corp.google.com>
 <20200828162640.GA2160001@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200828162640.GA2160001@bjorn-Precision-5520>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 28, 2020 at 11:26:40AM -0500, Bjorn Helgaas wrote:
> [+cc Vaibhav]
> 
> On Wed, Jun 27, 2018 at 04:23:40PM -0500, Bjorn Helgaas wrote:
> > [+cc Rafael, linux-pm, linux-kernel]
> > 
> > On Wed, Jun 27, 2018 at 10:15:50PM +0200, Jean Delvare wrote:
> > > Hi Jarkko,
> > > 
> > > On Tue, 26 Jun 2018 17:39:12 +0300, Jarkko Nikula wrote:
> > > > Commit 9c8088c7988 ("i2c: i801: Don't restore config registers on
> > > > runtime PM") nullified the runtime PM suspend/resume callback pointers
> > > > while keeping the runtime PM enabled. This causes that device stays in
> > > > D0 power state and sysfs /sys/bus/pci/devices/.../power/runtime_status
> > > > shows "error" when runtime PM framework attempts to autosuspend the
> > > > device.
> > > > 
> > > > This is due PCI bus runtime PM which checks for driver runtime PM
> > > > callbacks and returns with -ENOSYS if they are not set. Fix this by
> > > > having a shared dummy runtime PM callback that returns with success.
> > > > 
> > > > Fixes: a9c8088c7988 ("i2c: i801: Don't restore config registers on runtime PM")
> > > 
> > > I don't want to sound like I'm trying to decline all responsibility for
> > > a regression I caused, but frankly, if just using SIMPLE_DEV_PM_OPS()
> > > breaks runtime PM, then it's the PM model which is broken, not the
> > > i2c-i801 driver.
> > > 
> > > I will boldly claim that the PCI bus runtime code is simply wrong in
> > > returning -ENOSYS in the absence of runtime PM callbacks, and it should
> > > be changed to return 0 instead. Or whoever receives that -ENOSYS should
> > > not treat it as an error - whatever makes more sense.
> > > 
> > > Having to add dummy functions in every PCI driver that doesn't need to
> > > do anything special for runtime PM sounds plain stupid. It should be
> > > pretty obvious that a whole lot of drivers are going to use
> > > SIMPLE_DEV_PM_OPS() because it exists and seems to do what they want,
> > > and all of them will be bugged because the PCI core is doing something
> > > silly and unexpected.
> > > 
> > > So please let's fix it at the PCI subsystem core level. Adding Bjorn
> > > and the linux-pci list to Cc.
> > 
> > Thanks Jean.  What you describe does sound broken.  I think the PM
> > guys (cc'd) will have a better idea of how to deal with this.
> 
> Did we ever get anywhere with this?  It seems like the thread petered
> out.
This does seems worrying. I remember, few days earlier you pointed out a driver
i2c-nvidia-gpuc.c. In the code, gpu_i2c_suspend() is an empty-body function. And
comment mentioned that empty stub is necessary for runtime_pm to work.

And this driver also uses UNIVERSAL_DEV_PM_OPS.
