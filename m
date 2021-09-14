Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAFE40B62A
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 19:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhINRrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 13:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbhINRrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 13:47:49 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1768C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 10:46:31 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id e16so13405pfc.6
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 10:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=30/B84g0scVe64w1jrJPAZx8Vu/dGGlZHuOB6QGy0Rs=;
        b=RX+Ricnc4mmAv/2u3XbIfohQD7aUkR5aJ5OTlSvGLp5M85x/LTP2P05AipcYelIDJ3
         wLfcoD+QlsV7Uq+8fE3q1QnE+7ZcIf+kjtWCEHmbbp+eJ0e7f7R1Gky7wN33PU3WWQl1
         QcFTHx+ryxw+dJM2lQRfrPwczd0yif6mVX59ueVVZV3O+HnXX+qgT7J09v7koiTcmxTA
         jElVUo7qtfnXc58sreR7P5KN7wURFXbIEyT1agjHoU4YgRXZA9KDRljEfwd6ppOEKA5c
         qxgaA3g4hne6kR9VbCp6GoaQs1pFsNtR2XsIcoDTgnd4onlGk6P1LhtneyRs6sJWs1zJ
         yj6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=30/B84g0scVe64w1jrJPAZx8Vu/dGGlZHuOB6QGy0Rs=;
        b=fPCXO1sm0jG+mt04diBF7jTThydLtSy4ujP90CDHHtXUz236EDBY3SUTWVh8INk7Yb
         6JmXyulg6sKH0pRfAnAzne8cXaDTJQYJ9It035J0P8T6mqLY14i2SgVAXTY4h81nDrIB
         1s7h4eJp6jmgaOccxs6exKvtdL5yfOq82UbKwNRxNMiIXmr7Gta7REwRGdEVnIWaKeO3
         7l94ve9rBdpgQFlwkg6TjSBj+YVWt1mlgEOA73T5aGaVGn4xYMVKoS9XNF0LCvvb2zLl
         jDfyJOxdWz2nGkzjbqLRwhSzc9T72Lbfc/Q3g/T+Ky0SfrhO9UVsgkddlCIT2r9IxV/3
         n5Nw==
X-Gm-Message-State: AOAM531UG1vZh13jv0NhWKn5u8v85WIwRvB2CQQZ9KR12Y+7qCXkipsd
        XZhLihNc+dFxOf3UOQ6Vxt71oZfPn+//elKKesJ/OQ==
X-Google-Smtp-Source: ABdhPJxUeTTwLZ7dZVb7Aqg1iR36DJipbk6h5IrKFiR+Fg8R/Iea/pxUrveUY66JJyNJIBPnyaH0QEdNGlp4fR3d7bg=
X-Received: by 2002:a63:3545:: with SMTP id c66mr16405202pga.377.1631641591034;
 Tue, 14 Sep 2021 10:46:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210913223339.435347-1-sashal@kernel.org> <20210913223339.435347-4-sashal@kernel.org>
 <CAPcyv4i5OHv2wHTO1Pdjz+qzAAWEha-7HdDdt42VyO_FasLSEA@mail.gmail.com> <YUDVXV8egoZP05SF@sashalap>
In-Reply-To: <YUDVXV8egoZP05SF@sashalap>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 14 Sep 2021 10:46:20 -0700
Message-ID: <CAPcyv4iiF1b53zn+zVvCjJFs2JKX=HvHAVggae-wULVD8jBFBQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.14 04/25] cxl/pci: Introduce cdevm_file_operations
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 10:01 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, Sep 14, 2021 at 08:42:04AM -0700, Dan Williams wrote:
> >On Mon, Sep 13, 2021 at 3:33 PM Sasha Levin <sashal@kernel.org> wrote:
> >>
> >> From: Dan Williams <dan.j.williams@intel.com>
> >>
> >> [ Upstream commit 9cc238c7a526dba9ee8c210fa2828886fc65db66 ]
> >>
> >> In preparation for moving cxl_memdev allocation to the core, introduce
> >> cdevm_file_operations to coordinate file operations shutdown relative to
> >> driver data release.
> >>
> >> The motivation for moving cxl_memdev allocation to the core (beyond
> >> better file organization of sysfs attributes in core/ and drivers in
> >> cxl/), is that device lifetime is longer than module lifetime. The cxl_pci
> >> module should be free to come and go without needing to coordinate with
> >> devices that need the text associated with cxl_memdev_release() to stay
> >> resident. The move will fix a use after free bug when looping driver
> >> load / unload with CONFIG_DEBUG_KOBJECT_RELEASE=y.
> >>
> >> Another motivation for passing in file_operations to the core cxl_memdev
> >> creation flow is to allow for alternate drivers, like unit test code, to
> >> define their own ioctl backends.
> >
> >Hi Sasha,
> >
> >Please drop this. It's not a fix, it's just a reorganization for
> >easing the addition of new features and capabilities.
>
> I'll drop it, but just to satisfy my curiousity: the description says it
> fixes a use-after-free bug in the existing code, is it not the case?

It does fix a problem if the final put_device() happens after the
module text has been unloaded. However, I am only aware of the
artificial trigger for that (CONFIG_DEBUG_KOBJECT_RELEASE=y). I.e. if
CONFIG_DEBUG_KOBJECT_RELEASE=n I am not aware of any agent that will
hold a device reference besides the driver itself. That was the
rationale for not tagging this for -stable.
