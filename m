Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30EEB193893
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 07:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgCZG3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 02:29:24 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38187 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgCZG3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 02:29:24 -0400
Received: by mail-qt1-f196.google.com with SMTP id z12so4407298qtq.5;
        Wed, 25 Mar 2020 23:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i/fR/C9Juri0O/Jhyl78nI5aWq5H07mNdQL1ZjQ2Fec=;
        b=TnTEJoGdQx6OJqsozzttXtil7b93cqEcsDMe/4Usq1B9UsX477kc9HDF7Z7/VOcyYi
         p7lttbaMB2JqdE+oaceLAwS7bE8NaGBzBTUTm6+ci3w86CjvhXkY46AIggU+UFq6xdsY
         jqcrc5j9pDdgchwaYXKlo7DT3i7hcji0pZjkTIT6tcu0+YuPncv7S5qpCOpDFXfdD0Iw
         y5XGUGdXFtpfYoUnQSy1XC0FFkqslvwhdHWNZswjZg9U32/vuTtwF0kFKrqSfO+V1L4Z
         7oMlfz9xJRbuX6vx/rRXJ2Fcm8iz/NR0lnlNxZY1UAbQ+ch93hNHtxzREyYQOOhozJFe
         1Omg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i/fR/C9Juri0O/Jhyl78nI5aWq5H07mNdQL1ZjQ2Fec=;
        b=lSHieQr9A++8+PyXnEqcOqLos0eFK55ShFezpT9egmUGAPYMGLDEPYlZQGmneKYkIB
         2Vh30Zrj+iUJDl3LuRRxrLninkgfiXl2qhx/dT8FDl/DISHvsoz4obmN+6d/95psOWR4
         m6aREuVZuauGHXOUR660fus3teA7q+EaDLMkkgcZeERYmH+tPmoHGzytpc5R5pfzrD6g
         WR9XDDm3B5hK5jfG91LUqnB4eZNWLGI6aFwOXSZImQMscHKLfTlJ6nnKkd06V+bagqQU
         4U5TPAavwxhP3zDwqHT3mxh3pPVQWePS6YZ8BxJb8+zWJpmt5IXbO+kOztmpNoWUyivW
         FnuQ==
X-Gm-Message-State: ANhLgQ0DxP9wiWvEFCchT07sVHvgG34eMFFeXpx0YVftrzhmddDRWyhA
        ynh82YEucHRSM7nJFmGMeCFdVkqu1v1jHOlTpQI=
X-Google-Smtp-Source: ADFU+vuW7W+dnPI3JZdBOUL+LkQTG1+kch2523GrC5jr9/D/ICe/XfKnDLFtomAtj/XzaiY1zV90rW4YIMb2hw+YrtU=
X-Received: by 2002:ac8:748d:: with SMTP id v13mr6769092qtq.390.1585204162674;
 Wed, 25 Mar 2020 23:29:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200325151708.32612-1-skunberg.kelsey@gmail.com> <20200325221033.GA88141@google.com>
In-Reply-To: <20200325221033.GA88141@google.com>
From:   Kelsey <skunberg.kelsey@gmail.com>
Date:   Thu, 26 Mar 2020 00:29:11 -0600
Message-ID: <CAFVqi1R0Cc4+wqwCr9-8HoTU+6cShzorD44YzDNyex+jv1dztA@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH v2] PCI: sysfs: Change bus_rescan
 and dev_rescan to rescan
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org,
        Kelsey Skunberg <kelsey.skunberg@gmail.com>,
        rbilovol@cisco.com, stable <stable@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Bodong Wang <bodong@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bjorn,

On Wed, Mar 25, 2020 at 4:10 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> Hi Kelsey,
>
> On Wed, Mar 25, 2020 at 09:17:08AM -0600, Kelsey Skunberg wrote:
> > From: Kelsey Skunberg <kelsey.skunberg@gmail.com>
> >
> > rename device attribute name arguments 'bus_rescan' and 'dev_rescan' to 'rescan'
> > to avoid breaking userspace applications.
> >
> > The attribute argument names were changed in the following commits:
> > 8bdfa145f582 ("PCI: sysfs: Define device attributes with DEVICE_ATTR*()")
> > 4e2b79436e4f ("PCI: sysfs: Change DEVICE_ATTR() to DEVICE_ATTR_WO()")
> >
> > Revert the names used for attributes back to the names used before the above
> > patches were applied. This also requires to change DEVICE_ATTR_WO() to
> > DEVICE_ATTR() and __ATTR().
> >
> > Note when using DEVICE_ATTR() the attribute is automatically named
> > dev_attr_<name>.attr. To avoid duplicated names between attributes, use
> > __ATTR() instead of DEVICE_ATTR() to a assign a custom attribute name for
> > dev_rescan.
> >
> > change bus_rescan_store() to dev_bus_rescan_store() to complete matching the
> > names used before the mentioned patches were applied.
> >
> > Fixes: 8bdfa145f582 ("PCI: sysfs: Define device attributes with DEVICE_ATTR*()")
> > Fixes: 4e2b79436e4f ("PCI: sysfs: Change DEVICE_ATTR() to DEVICE_ATTR_WO()")
> >
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Kelsey Skunberg <kelsey.skunberg@gmail.com>
> > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >
> > v2 updates:
> >       commit log updated to include 'Fixes: *' and Cc: stable to aid commit
> >       being backported properly.
> >
> >  drivers/pci/pci-sysfs.c | 17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> > index 13f766db0684..667e13d597ff 100644
> > --- a/drivers/pci/pci-sysfs.c
> > +++ b/drivers/pci/pci-sysfs.c
> > @@ -464,7 +464,10 @@ static ssize_t dev_rescan_store(struct device *dev,
> >       }
> >       return count;
> >  }
> > -static DEVICE_ATTR_WO(dev_rescan);
> > +static struct device_attribute dev_rescan_attr = __ATTR(rescan,
> > +                                                     0220, NULL,
> > +                                                     dev_rescan_store);
> > +
> >
> >  static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
> >                           const char *buf, size_t count)
> > @@ -481,9 +484,9 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
> >  static DEVICE_ATTR_IGNORE_LOCKDEP(remove, 0220, NULL,
> >                                 remove_store);
> >
> > -static ssize_t bus_rescan_store(struct device *dev,
> > -                             struct device_attribute *attr,
> > -                             const char *buf, size_t count)
> > +static ssize_t dev_bus_rescan_store(struct device *dev,
> > +                                 struct device_attribute *attr,
> > +                                 const char *buf, size_t count)
> >  {
> >       unsigned long val;
> >       struct pci_bus *bus = to_pci_bus(dev);
> > @@ -501,7 +504,7 @@ static ssize_t bus_rescan_store(struct device *dev,
> >       }
> >       return count;
> >  }
> > -static DEVICE_ATTR_WO(bus_rescan);
> > +static DEVICE_ATTR(rescan, 0220, NULL, dev_bus_rescan_store);
> >
> >  #if defined(CONFIG_PM) && defined(CONFIG_ACPI)
> >  static ssize_t d3cold_allowed_store(struct device *dev,
> > @@ -641,7 +644,7 @@ static struct attribute *pcie_dev_attrs[] = {
> >  };
> >
> >  static struct attribute *pcibus_attrs[] = {
> > -     &dev_attr_bus_rescan.attr,
> > +     &dev_attr_rescan.attr,
> >       &dev_attr_cpuaffinity.attr,
> >       &dev_attr_cpulistaffinity.attr,
> >       NULL,
> > @@ -1487,7 +1490,7 @@ static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
> >
> >  static struct attribute *pci_dev_hp_attrs[] = {
> >       &dev_attr_remove.attr,
> > -     &dev_attr_dev_rescan.attr,
> > +     &dev_rescan_attr.attr,
> >       NULL,
> >  };
>
> Thanks for taking care of this!  Two questions:
>
> 1) You supplied permissions of 0220, but DEVICE_ATTR_WO()
> uses__ATTR_WO(), which uses 0200.  Shouldn't we keep 0200?
>

Good catch. Before changing to DEVICE_ATTR_WO(), the permissions used
was (S_IWUSR | S_IWGRP), which would be 0220. This means the
permissions were mistakenly changed from 0220 to 0200 in the same
patch:

commit 4e2b79436e4f ("PCI: sysfs: Change DEVICE_ATTR() to DEVICE_ATTR_WO()")

To verify DEVICE_ATTR_WO() is using __ATTR_WO() can be seen in
/include/linux/device.h
To verify permissions for __ATTR_WO() is 0200 can be seen in
/inlcude/linux/sysfs.h

These attributes had permissions 0220 when first being introduced and
before the above mentioned patch, so I'm on the side to believe that
0220 should be used.

The commits that introduced the files:
commit 738a6396c223 ("PCI: Introduce /sys/bus/pci/devices/.../rescan"):
commit b9d320fcb625 ("PCI: add rescan to /sys/.../pci_bus/.../"):

May you please sanity check this logic to use 0220? I can create a
second patch to change the permissions from the currently used 0200 to
0220.

> 2) I think the use of __ATTR() for the device side and DEVICE_ATTR()
> for the bus side is confusing.  Couldn't we accomplish the same thing
> with a patch like the following (compiled but not tested)?
>
> Bjorn
>
>
> commit 06094b3fd9f1 ("PCI: sysfs: Revert "rescan" file renames")
> Author: Kelsey Skunberg <kelsey.skunberg@gmail.com>
> Date:   Wed Mar 25 09:17:08 2020 -0600
>
>     PCI: sysfs: Revert "rescan" file renames
>
>     We changed these sysfs filenames:
>
>       .../pci_bus/<domain:bus>/rescan  ->  .../pci_bus/<domain:bus>/bus_rescan
>       .../<domain:bus:dev.fn>/rescan   ->  .../<domain:bus:dev.fn>/dev_rescan
>
>     and Ruslan reported [1] that this broke a userspace application.
>
>     Revert these name changes so both files are named "rescan" again.
>
>     The argument to DEVICE_ATTR_WO() determines both the struct
>     device_attribute name and the .store() function name.  We have to
>     use __ATTR() so we can specify different .store() functions for
>     the two "rescan" files.
>
>     [1] https://lore.kernel.org/r/CAB=otbSYozS-ZfxB0nCiNnxcbqxwrHOSYxJJtDKa63KzXbXgpw@mail.gmail.com
>
>     [bhelgaas: commit log]
>     Fixes: 8bdfa145f582 ("PCI: sysfs: Define device attributes with DEVICE_ATTR*()")
>     Fixes: 4e2b79436e4f ("PCI: sysfs: Change DEVICE_ATTR() to DEVICE_ATTR_WO()")
>     Link: https://lore.kernel.org/r/20200325151708.32612-1-skunberg.kelsey@gmail.com
>     Signed-off-by: Kelsey Skunberg <kelsey.skunberg@gmail.com>
>     Cc: stable@vger.kernel.org  # v5.4+
>
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 13f766db0684..bf025a2c296d 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -464,7 +464,8 @@ static ssize_t dev_rescan_store(struct device *dev,
>         }
>         return count;
>  }
> -static DEVICE_ATTR_WO(dev_rescan);
> +static struct device_attribute dev_attr_dev_rescan = __ATTR(rescan, 0200, NULL,
> +                                                           dev_rescan_store);
>
>  static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
>                             const char *buf, size_t count)
> @@ -501,7 +502,8 @@ static ssize_t bus_rescan_store(struct device *dev,
>         }
>         return count;
>  }
> -static DEVICE_ATTR_WO(bus_rescan);
> +static struct device_attribute dev_attr_bus_rescan = __ATTR(rescan, 0200, NULL,
> +                                                           bus_rescan_store);
>
>  #if defined(CONFIG_PM) && defined(CONFIG_ACPI)
>  static ssize_t d3cold_allowed_store(struct device *dev,


This can be done, yes! I agree this could help clarify and clean up the code.

I can implement your commit log as well.

Let me know your thoughts for the permissions and I'll get an updated
version out right away.

Thank you!

-Kelsey
