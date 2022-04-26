Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C824E510099
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 16:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241007AbiDZOj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 10:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241689AbiDZOj5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 10:39:57 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815E117E237
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 07:36:49 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g20so22619471edw.6
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 07:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TBS66VxyYRFA3xbkENxGYNtq2f4j+RilxOFZCbhJG0Y=;
        b=zhqV0wkRtgqAzobjs+pVSgYuPzbtRmZ7blZ232zwpQGvITCEeZZG/fI4Jjlh6NdOyv
         XEDqKCmCoAtCPXBAD1x3QsGgXl0HS+0OKeVQ53OXYsxQ7e2qHFKEQdyBZxySLwFGhrBv
         Fw43uC0gwPKCnAPSshx/Fos7lWnHB2hQKz44BqqI5wU3gaJm7VUjNpTqPubuZgILwyYt
         +OLZswqCYh5cmoRBIZjiLyWi9eIzTWJ+bYM9AtNEciAMOcsvK95Wm8B8+jcBW0mIxXx5
         VsgMDqsVWTzNUSXPQt6tsY94E3FHzKleaCMoY3M081XrLvDBdnp3jnxdLMWLUJYi9rM0
         MZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TBS66VxyYRFA3xbkENxGYNtq2f4j+RilxOFZCbhJG0Y=;
        b=VWhhUrxakO20Y/aKjb0Nab5jFhbF/TFf9oR7rZGeqY6CPupbnyPYC/yYjdOGmaYpWR
         ZRPllVf45O2fq+kjxNKZqXJVraEsWMY2vE+XZZXBpNGnI0nbBwCIRpi0C9BrcYOfZVZb
         YAhRevDsmSN6cqXK64R4BbQOWMFeWmNR3ebx8knBOF7TNPNMCbpbbjnyO2hhggbAQNNl
         NcqoQZieE+lF8W/jF4KfUaTPQ9gtlapg9LuK0xzrnNFdkFDIgToEt2GApXmeZonq54zl
         j20AVqPiA0aGeUSaRuF4qq+1ceKBaa+NdlaQA+0Qjw3vPZpxHSBaWLL18pqz13zAaokb
         cFOw==
X-Gm-Message-State: AOAM531bVKe84Wva8L4K4AlwCLyAGXkNCtBTRcapePVyjM8QkhzFJFkh
        HTgV8c1lvosEkqfPuHS/emAgQwU5UfaLaqfQSaaM
X-Google-Smtp-Source: ABdhPJwIfTX17UymMR5mRqXykgkd2bqnrEifSrCnFOs7QIyWCIL2KIOewK0Lf06bkuVLj7aplpeM95kTYNrI2moQvTc=
X-Received: by 2002:a50:9985:0:b0:425:c2dd:4cf7 with SMTP id
 m5-20020a509985000000b00425c2dd4cf7mr21829258edb.19.1650983808052; Tue, 26
 Apr 2022 07:36:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220426073656.229-1-xieyongji@bytedance.com> <YmeoSuMfsdVxuGlf@kroah.com>
 <CACycT3sLgihkgX5cB6GxDehaTsPn9rqhtWF7G_=J=__oTopJZw@mail.gmail.com>
 <YmfIv2YuARnPe97k@kroah.com> <CACycT3sq6WM1uCa+ix79AwTJHaEOhkLycwkZOhqPhABZ4xa2AA@mail.gmail.com>
 <YmfpKGZB06Ix5WPu@kroah.com> <CACycT3vD9o+_uLaevCZ=W==YRA_WJP8UJ6czHTtsUny8Rwgd0A@mail.gmail.com>
 <Ymf03l+Ag8ZBSGm2@kroah.com> <CACycT3vmN0z=in1hcT7XuW4p-vzq9SAgPJNGGkooc+C+qftWjw@mail.gmail.com>
 <20220426101640-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220426101640-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 26 Apr 2022 22:37:17 +0800
Message-ID: <CACycT3vLdjH820EBzz+4u5+6JH+hjnFTK1mtSJje9Uq1j_KTdQ@mail.gmail.com>
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

On Tue, Apr 26, 2022 at 10:18 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Apr 26, 2022 at 10:02:02PM +0800, Yongji Xie wrote:
> > > This should not be needed, when your module is unloaded, all devices it
> > > handled should be properly removed by it.
> > >
> >
> > I see. But it's not easy to achieve that currently. Maybe we need
> > something like DEVICE_NEEDS_RESET support in virtio core.
>
> Not sure what the connection is.
>

If we want to force remove all working vduse devices during module
unload, we might need to send a DEVICE_NEEDS_RESET notification to
device driver to do some cleanup before, e.g., return error for all
inflight I/Os.

Thanks,
Yongji
