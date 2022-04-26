Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3230850FFE4
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 16:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbiDZOEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 10:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiDZOEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 10:04:43 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E3A16595
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 07:01:34 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id kq17so13140816ejb.4
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 07:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ldxu+Hb4WZBrIV2HQY6fhJbjILlQwHpDcn0uIDepoUg=;
        b=LosmQrPy4bncs9Ced6H462zNpq3XcrPNe7WUCVu3EwJ2d305KUCA+R5yVJl6E7o0/k
         M40ONIIhmIw17+o/v8lUnBlc5qMLAS6n/QeWK71ovPrfbVq7bIBAzZHoJJxLIn3ZIxRZ
         XpRquKsRYArButUkypo1u4dP7o97V5zYqtC+ZDiqCANGOxKUsZankiPv9Vey0UipbOk9
         R1RzP8/JWzhDBuwPlvDnKS+qeDqNTd8r0A+7E787IdB5yV1W0L6FyTUPcr0dhTndYcwi
         MwqC/U9EZIkjB86MqbjspA4i1erS/25as5kwYjH8jhm4aNR+OJF/W4jibfDVld2YW8dE
         01wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ldxu+Hb4WZBrIV2HQY6fhJbjILlQwHpDcn0uIDepoUg=;
        b=2Daf47sc1NkW3K6E+KmkvMntJxtb3dZ3eiuTKbZNVI9xS0j1BHp2JIy8YdnZQ5F3c0
         ZWFcnmlP4irl22dgA9HT2aOJQ7+3stpLoq6q7aC4KoV4kppx1tGC0CdIo1+VHv9PWLeK
         Jex7xlVcDI9GsMJgr+Dc9HhR7lOK7AmfcM80a90XSr8mRU+A9oj68PcvP6LcDQYlbb8z
         rJZC1gH+C3LlNol2NwII7YtkU8AaCrobiSkblcMlDfE4ZA4+U6ZJcgQQf9PmPEFTr1J5
         +IVtE7sOcJPTpCmWNIbwXlWQb7+zwM87TQnMTt8QJEli/bPHKSOuZ7BIzQixruQQJVa0
         FsKA==
X-Gm-Message-State: AOAM533u4tqa+HzYJ/yoU8JENKZ+9WaeAPGeBvUA4OSJwq1OyQFJeWbx
        UXTAZp33ucMviAP4PNKc2VIeoTV2oIeV/e931T3QAbP0kA==
X-Google-Smtp-Source: ABdhPJxrVxwA8uTjaJE2fTOV21qJ1IhciIvFGEbpy+DJkji/E8MDazwY0+4QbyKkYXgUeim1d1GcgR/ahnVCRO2QJt4=
X-Received: by 2002:a17:907:6e04:b0:6e0:736b:d786 with SMTP id
 sd4-20020a1709076e0400b006e0736bd786mr21272749ejc.667.1650981693217; Tue, 26
 Apr 2022 07:01:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220426073656.229-1-xieyongji@bytedance.com> <YmeoSuMfsdVxuGlf@kroah.com>
 <CACycT3sLgihkgX5cB6GxDehaTsPn9rqhtWF7G_=J=__oTopJZw@mail.gmail.com>
 <YmfIv2YuARnPe97k@kroah.com> <CACycT3sq6WM1uCa+ix79AwTJHaEOhkLycwkZOhqPhABZ4xa2AA@mail.gmail.com>
 <YmfpKGZB06Ix5WPu@kroah.com> <CACycT3vD9o+_uLaevCZ=W==YRA_WJP8UJ6czHTtsUny8Rwgd0A@mail.gmail.com>
 <Ymf03l+Ag8ZBSGm2@kroah.com>
In-Reply-To: <Ymf03l+Ag8ZBSGm2@kroah.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 26 Apr 2022 22:02:02 +0800
Message-ID: <CACycT3vmN0z=in1hcT7XuW4p-vzq9SAgPJNGGkooc+C+qftWjw@mail.gmail.com>
Subject: Re: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel test robot <oliver.sang@intel.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 9:34 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 26, 2022 at 09:17:23PM +0800, Yongji Xie wrote:
> > On Tue, Apr 26, 2022 at 8:44 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Apr 26, 2022 at 08:30:38PM +0800, Yongji Xie wrote:
> > > > On Tue, Apr 26, 2022 at 6:26 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Tue, Apr 26, 2022 at 05:41:15PM +0800, Yongji Xie wrote:
> > > > > > On Tue, Apr 26, 2022 at 4:07 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > > >
> > > > > > > On Tue, Apr 26, 2022 at 03:36:56PM +0800, Xie Yongji wrote:
> > > > > > > > The control device has no drvdata. So we will get a
> > > > > > > > NULL pointer dereference when accessing control
> > > > > > > > device's msg_timeout attribute via sysfs:
> > > > > > > >
> > > > > > > > [ 132.841881][ T3644] BUG: kernel NULL pointer dereference, address: 00000000000000f8
> > > > > > > > [ 132.850619][ T3644] RIP: 0010:msg_timeout_show (drivers/vdpa/vdpa_user/vduse_dev.c:1271)
> > > > > > > > [ 132.869447][ T3644] dev_attr_show (drivers/base/core.c:2094)
> > > > > > > > [ 132.870215][ T3644] sysfs_kf_seq_show (fs/sysfs/file.c:59)
> > > > > > > > [ 132.871164][ T3644] ? device_remove_bin_file (drivers/base/core.c:2088)
> > > > > > > > [ 132.872082][ T3644] kernfs_seq_show (fs/kernfs/file.c:164)
> > > > > > > > [ 132.872838][ T3644] seq_read_iter (fs/seq_file.c:230)
> > > > > > > > [ 132.873578][ T3644] ? __vmalloc_area_node (mm/vmalloc.c:3041)
> > > > > > > > [ 132.874532][ T3644] kernfs_fop_read_iter (fs/kernfs/file.c:238)
> > > > > > > > [ 132.875513][ T3644] __kernel_read (fs/read_write.c:440 (discriminator 1))
> > > > > > > > [ 132.876319][ T3644] kernel_read (fs/read_write.c:459)
> > > > > > > > [ 132.877129][ T3644] kernel_read_file (fs/kernel_read_file.c:94)
> > > > > > > > [ 132.877978][ T3644] kernel_read_file_from_fd (include/linux/file.h:45 fs/kernel_read_file.c:186)
> > > > > > > > [ 132.879019][ T3644] __do_sys_finit_module (kernel/module.c:4207)
> > > > > > > > [ 132.879930][ T3644] __ia32_sys_finit_module (kernel/module.c:4189)
> > > > > > > > [ 132.880930][ T3644] do_int80_syscall_32 (arch/x86/entry/common.c:112 arch/x86/entry/common.c:132)
> > > > > > > > [ 132.881847][ T3644] entry_INT80_compat (arch/x86/entry/entry_64_compat.S:419)
> > > > > > > >
> > > > > > > > To fix it, don't create the unneeded attribute for
> > > > > > > > control device anymore.
> > > > > > > >
> > > > > > > > Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
> > > > > > > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > > > > > ---
> > > > > > > >  drivers/vdpa/vdpa_user/vduse_dev.c | 7 +++----
> > > > > > > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > > > > > index f85d1a08ed87..160e40d03084 100644
> > > > > > > > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > > > > > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > > > > > @@ -1344,9 +1344,9 @@ static int vduse_create_dev(struct vduse_dev_config *config,
> > > > > > > >
> > > > > > > >       dev->minor = ret;
> > > > > > > >       dev->msg_timeout = VDUSE_MSG_DEFAULT_TIMEOUT;
> > > > > > > > -     dev->dev = device_create(vduse_class, NULL,
> > > > > > > > -                              MKDEV(MAJOR(vduse_major), dev->minor),
> > > > > > > > -                              dev, "%s", config->name);
> > > > > > > > +     dev->dev = device_create_with_groups(vduse_class, NULL,
> > > > > > > > +                             MKDEV(MAJOR(vduse_major), dev->minor),
> > > > > > > > +                             dev, vduse_dev_groups, "%s", config->name);
> > > > > > > >       if (IS_ERR(dev->dev)) {
> > > > > > > >               ret = PTR_ERR(dev->dev);
> > > > > > > >               goto err_dev;
> > > > > > > > @@ -1595,7 +1595,6 @@ static int vduse_init(void)
> > > > > > > >               return PTR_ERR(vduse_class);
> > > > > > > >
> > > > > > > >       vduse_class->devnode = vduse_devnode;
> > > > > > > > -     vduse_class->dev_groups = vduse_dev_groups;
> > > > > > >
> > > > > > > Ok, this looks much better.
> > > > > > >
> > > > > > > But wow, there are some problems in this code overall.  I see a number
> > > > > > > of flat-out-wrong things in there that should have been caught by code
> > > > > > > reviews.  Some examples:
> > > > > > >         - empty release() callbacks.  That is a huge sign the code
> > > > > > >           design is wrong and broken and you are just trying to make the
> > > > > > >           driver core quiet for some reason.  The documentation in the
> > > > > > >           kernel explains why this is not ok.
> > > > > >
> > > > > > Sorry, I failed to find the documentation. Do you mean we should
> > > > > > remove the empty release() callbacks?
> > > > >
> > > > > Yes, why are they needed?
> > > > >
> > > > > (hint, retorical question, you added them to remove the driver core
> > > > > warning when the device is removed, which means someone added them just
> > > > > because they thought that their code could ignore the hints that the
> > > > > driver core was telling them.)
> > > > >
> > > >
> > > > OK, I see.
> > > >
> > > > > Please properly free the memory here.
> > > > >
> > > >
> > > > One question is how to deal with the case if the device/kobject is
> > > > defined as a static variable. We should not need to free any resources
> > > > in this case. Or do you suggest just using dynamic allocation here?
> > >
> > > A kobject can NEVER be a static variable[1].  That's not how the driver
> > > model works at all.  If this is how this code is written, it needs to be
> > > fixed.
> > >
> >
> > OK, I see.
> >
> > > [1] Ok, yes, drivers and busses and classes have static kobjects, ignore
> > >     them...
> > >
> > > >
> > > > > > >         - __module_get(THIS_MODULE);  That's racy, buggy, and doesn't do
> > > > > > >           what you think it does.  Please never ever ever do that.  It
> > > > > > >           too is a sign of a broken design.
> > > > > >
> > > > > > I don't find a good way to remove it. We have to make sure the module
> > > > > > can't be removed until all vduse devices are destroyed.
> > > > >
> > > > > That will happen automatically when the module is removed.
> > > > >
> > > > > > And I think __module_get(THIS_MODULE) should be safe in our case since
> > > > > > we always call it when we have a reference from open().
> > > > >
> > > > > What happened if someone removed the module _right before_ this was
> > > > > called?  You can not grab your own reference count safely.
> > > > >
> > > >
> > > > I don't get you here. We should already grab a reference count from
> > > > open() before calling this. So it should fail if someone tries to
> > > > remove the module at this time.
> > >
> > > Then why are you trying to grab the module reference again?
> > >
> > > > > Please just remove it, it's not needed and is broken.  There should not
> > > > > be any reason that the module can not be unloaded, UNLESS a file handle
> > > > > is open, and you properly handle that already.
> > > > >
> > > >
> > > > But in our case, I think we should prevent unloading the module If we
> > > > already created some vduse devices via /dev/vduse/control (note that
> > > > the control device's file handle could be closed after device
> > > > creation). Otherwise, we might get some crashes when accessing those
> > > > created vduse devices.
> > >
> > > Then the code is written incorrectly, this should not be an issue at
> > > all.  Your devices will all be cleaned up properly before your code is
> > > unloaded from the system.
> > >
> >
> > In current design, the vduse device can't be cleaned up properly until
> > it is unbinded from the vDPA bus explicitly. So I use the extra
> > __module_get() to make sure we can't unload the module until the
> > device is cleaned up properly.
>
> Then something is wrong, it should not work that way.
>
> > > Note that no other driver or bus does this, what makes this different?
> > >
> >
> > I can see some similar behavior in loop and rbd modules.
>
> Never treat the loop code as a good example :)
>

OK.

> This should not be needed, when your module is unloaded, all devices it
> handled should be properly removed by it.
>

I see. But it's not easy to achieve that currently. Maybe we need
something like DEVICE_NEEDS_RESET support in virtio core.

Thanks,
Yongji
