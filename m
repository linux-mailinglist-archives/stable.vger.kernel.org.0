Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535565100E2
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 16:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239060AbiDZOwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 10:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiDZOwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 10:52:50 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566B440919
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 07:49:42 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b24so22639684edu.10
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 07:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mvynCR4cO4QOkBVHhRv3kzIAsqUthxufQR/FcZ/66Lk=;
        b=bE2uNMTuP2NKDEUOnkpUrSw9S4QFp/MhimrBCddJAy8fXlOOhbQuG5U0s5d6S8xqHf
         B15dSablodhFflS+rClVzfz7w0wlNQJH4vv9lfbsz3vWIbl+z/YjdqJKXjtsJ2q9bSk4
         DNKeVdNEn6uRVvDIU0RknTLporBCk458SJTqz379gw6V9qAzvQo8PxgJ2AnwUl2Izqpp
         FFnKlkRhOGQDy0heWN9LISLSHS60RTet1uk2MzjwfKyiIx5wa2tGi/H4aODPxlH07H0p
         UG2M7PdrgeHb+Uwfe5XqUSNqvWJ+Jzcp7yiwFQpinQKWE9WGnUj4TwcIAyWXzydHzRGL
         nJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mvynCR4cO4QOkBVHhRv3kzIAsqUthxufQR/FcZ/66Lk=;
        b=rJfln1fFbO7/VKXRp5wTKIHSHsDKeGs4pZsznf4Mdwond+TBtHNKuyfWh7ttnsR5oS
         Xr7ziaV1jbut6afW1InqtdCm+ZuchBzIt8Yt7S/GwmrLGtzDNP+lVjD7RN+F8jo9JnE7
         uljYhmNdnJwNGJyM2Sx5a18Mmd5rIaHMMRvvkzX5JiC1yLKr6iVJfzqr8R1eTIrQfIAk
         c2P4CBkkTYK7aMPtlFl+s890p8mUejw8diogAcbXfTM0A0SrmzsmV+96JnCjrWulEeu+
         /U7ZFs0YKYWPaLBKB/PIpx370NEiyyA4zu3QWoMwG+C2S1Vl6Z1wNXAT+WeDiRRDfPpu
         KuQA==
X-Gm-Message-State: AOAM533ZS5JhV9R0Z36E3y4VY0IWRFla2l8EJsLI6BVHXE5hl2VyfGDz
        9YLmZZ7gRp6Mlb16h6JdVVBLZ4xfGPIItWWv61nb
X-Google-Smtp-Source: ABdhPJw0gW9ceSnqk6tOUk4O1MY8g08VupKW5eqHLboa+2kOrqUfJaguM+2H4n5HNZDvPwVPJaYdabKoeqqVeJHo8jg=
X-Received: by 2002:a05:6402:4388:b0:423:f7c9:7e04 with SMTP id
 o8-20020a056402438800b00423f7c97e04mr25263568edc.298.1650984580931; Tue, 26
 Apr 2022 07:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <YmeoSuMfsdVxuGlf@kroah.com> <CACycT3sLgihkgX5cB6GxDehaTsPn9rqhtWF7G_=J=__oTopJZw@mail.gmail.com>
 <YmfIv2YuARnPe97k@kroah.com> <CACycT3sq6WM1uCa+ix79AwTJHaEOhkLycwkZOhqPhABZ4xa2AA@mail.gmail.com>
 <YmfpKGZB06Ix5WPu@kroah.com> <CACycT3vD9o+_uLaevCZ=W==YRA_WJP8UJ6czHTtsUny8Rwgd0A@mail.gmail.com>
 <Ymf03l+Ag8ZBSGm2@kroah.com> <CACycT3vmN0z=in1hcT7XuW4p-vzq9SAgPJNGGkooc+C+qftWjw@mail.gmail.com>
 <20220426101640-mutt-send-email-mst@kernel.org> <CACycT3vLdjH820EBzz+4u5+6JH+hjnFTK1mtSJje9Uq1j_KTdQ@mail.gmail.com>
 <20220426103742-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220426103742-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 26 Apr 2022 22:50:10 +0800
Message-ID: <CACycT3tx60nvvaTPS9p6Na3mX9MC+Pud84V5fGdLRr85qGsxbA@mail.gmail.com>
Subject: Re: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
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

On Tue, Apr 26, 2022 at 10:38 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Apr 26, 2022 at 10:37:17PM +0800, Yongji Xie wrote:
> > On Tue, Apr 26, 2022 at 10:18 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Apr 26, 2022 at 10:02:02PM +0800, Yongji Xie wrote:
> > > > > This should not be needed, when your module is unloaded, all devices it
> > > > > handled should be properly removed by it.
> > > > >
> > > >
> > > > I see. But it's not easy to achieve that currently. Maybe we need
> > > > something like DEVICE_NEEDS_RESET support in virtio core.
> > >
> > > Not sure what the connection is.
> > >
> >
> > If we want to force remove all working vduse devices during module
> > unload, we might need to send a DEVICE_NEEDS_RESET notification to
> > device driver to do some cleanup before, e.g., return error for all
> > inflight I/Os.
> >
> > Thanks,
> > Yongji
>
> IMHO DEVICE_NEEDS_RESET won't help much with that, it's more in
> case device is still there but needs a reset to start working.
>

OK, we just want a reset without restarting work in our case. Looks
like we might need some other mechanism to achieve that.

Thanks,
Yongji
