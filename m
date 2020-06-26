Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138FC20B884
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 20:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgFZSnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 14:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFZSnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 14:43:24 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B193C03E979
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 11:43:24 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id s28so7650829edw.11
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 11:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2fViRCPiGbmFQGGxHysM7A/NvrpkiAu6F1Ew2P8DlPc=;
        b=S+ggohbfJIpW4SOtY2JQU7s9jtaYl1FmP4FczLGl76p7cr93CQt5d8sNohtmfXufOB
         Jf2BVaclP0C52cTiBknVLTAvbRo0dU/8lhqa1Q/Ch00umrHCHfse21oXsot0DBaAg5+4
         /FLfT5Xum/GeWU6Bmpeo5yLj/J9TlBoZtHP/jJKLg5Y94N3FcF7Q/fQvWCl8pFPLX6Ip
         dZfE7yCO4fA4D3RtnowyY+XdZ7DdYOZOE74pYabr0SDyhZIMUBAdE0NLS3+FDWYzOYx0
         V3bJcrugFwIxyQHfRH9Kz0DwteS2N4Nc/709Eogcccb5E6j5PG1yrJYuDqYQizRf/J/h
         WXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2fViRCPiGbmFQGGxHysM7A/NvrpkiAu6F1Ew2P8DlPc=;
        b=mXxBCY2kqKvW8zxCbxEAoMVwHcf5AIVv51LlDpO8WOjoQ7an/unorzaboprog36rQ2
         fZua0lLMelrlwqKxJFFeKQfR697sanosS7lEQJPSpHe8C/iLRins6GatLEe6wjPNGmGk
         bM84f9gdIXfmKA8jzpnYFr5ztdB819EvO3cMVexBlub1ChPNp1fTPoszXL9n9a+tGzmI
         EKXL0cTCptFqzaGSkBBpbnJapMkVA/d9AXvGPoL/pFPdQa1Wx/UdvY+EJ8nTUH3eh/UE
         ZPnwmrlfiJoSZ0OG15BOhP6544xVc0zvsqUSvv9aCDufAA7qfcMKzsvnvvVQf2mN8XI4
         62Jg==
X-Gm-Message-State: AOAM530+hy7/SNe1Akkn1BcSKoy1S2kjO53VM0W0DJvJptC/RwQ5addj
        R1Ag23tiF715AfWocbfbVQEZKU7tKORU9kLuZYEpCA==
X-Google-Smtp-Source: ABdhPJwlQ42Qr7ZtTaRCNXZWEnGE4iSIeD4BD4JeqhE9xMkDCc8/N5pEp7pGYcJtNL5pMeodJb1BjK4hdu7J2sgv6EU=
X-Received: by 2002:a50:d9cb:: with SMTP id x11mr4554546edj.93.1593197002827;
 Fri, 26 Jun 2020 11:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <159312902033.1850128.1712559453279208264.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAJZ5v0h8Eg5_FVxz0COLDMK8cy72xxDk_2nFnXDJNUY-MvdBEQ@mail.gmail.com>
In-Reply-To: <CAJZ5v0h8Eg5_FVxz0COLDMK8cy72xxDk_2nFnXDJNUY-MvdBEQ@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 26 Jun 2020 11:43:11 -0700
Message-ID: <CAPcyv4jqShnZr1b0-upwWf8L3JjKtHox_pCuu229630rXGuLkg@mail.gmail.com>
Subject: Re: [PATCH 00/12] ACPI/NVDIMM: Runtime Firmware Activation
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        Ira Weiny <ira.weiny@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Stable <stable@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 7:22 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Fri, Jun 26, 2020 at 2:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > Quoting the documentation:
> >
> >     Some persistent memory devices run a firmware locally on the device /
> >     "DIMM" to perform tasks like media management, capacity provisioning,
> >     and health monitoring. The process of updating that firmware typically
> >     involves a reboot because it has implications for in-flight memory
> >     transactions. However, reboots are disruptive and at least the Intel
> >     persistent memory platform implementation, described by the Intel ACPI
> >     DSM specification [1], has added support for activating firmware at
> >     runtime.
> >
> >     [1]: https://docs.pmem.io/persistent-memory/
> >
> > The approach taken is to abstract the Intel platform specific mechanism
> > behind a libnvdimm-generic sysfs interface. The interface could support
> > runtime-firmware-activation on another architecture without need to
> > change userspace tooling.
> >
> > The ACPI NFIT implementation involves a set of device-specific-methods
> > (DSMs) to 'arm' individual devices for activation and bus-level
> > 'trigger' method to execute the activation. Informational / enumeration
> > methods are also provided at the bus and device level.
> >
> > One complicating aspect of the memory device firmware activation is that
> > the memory controller may need to be quiesced, no memory cycles, during
> > the activation. While the platform has mechanisms to support holding off
> > in-flight DMA during the activation, the device response to that delay
> > is potentially undefined. The platform may reject a runtime firmware
> > update if, for example a PCI-E device does not support its completion
> > timeout value being increased to meet the activation time. Outside of
> > device timeouts the quiesce period may also violate application
> > timeouts.
> >
> > Given the above device and application timeout considerations the
> > implementation defaults to hooking into the suspend path to trigger the
> > activation, i.e. that a suspend-resume cycle (at least up to the syscore
> > suspend point) is required.
>
> Well, that doesn't work if the suspend method for the system is set to
> suspend-to-idle (for example, via /sys/power/mem_sleep), because the
> syscore callbacks are not invoked in that case.
>
> Also you probably don't need the device power state toggling that
> happens during regular suspend/resume (you may not want it even for
> some devices).
>
> The hibernation freeze/thaw may be a better match and there is some
> test support in there already that may be kind of co-opted for your
> use case.

Hmm, yes I guess freeze should be sufficient to quiesce most
device-DMA in the general case as applications will stop sending
requests. I do expect some RDMA devices will happily keep on
transmitting, but that likely will need explicit mitigation. It also
appears the suspend callback for at least one RDMA device
mlx5_suspend() is rather violent as it appears to fully teardown the
device context, not just suspend operations.

To be clear, what debug interface were you thinking I could glom onto
to just trigger firmware-activate at the end of the freeze phase?
