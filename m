Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9654451009F
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 16:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiDZOlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 10:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241689AbiDZOlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 10:41:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 658BD184FBE
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 07:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650983919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Oay4ro9gliPGutvjNsoyWEuxgyMzWkRHOAjFiijjFoc=;
        b=fLgE/ywQan5Tie8UHLAm1mq1Zyhwc38a4AyI2LvkJA4Wau2/Tfn80tKxAgCj7dDU5zLEpt
        xPHLaCwLcKTMRhUSxhu9TaSMb9cQusfNq9JN3MMuNlwGBF4DYAuHjC1eZqtFeNinQCmGjD
        M1zbJcKuGlJkkJ7ftLQNNKKSc4rAk0g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-T9YhYkT3Nvut-UAqAnpONQ-1; Tue, 26 Apr 2022 10:38:37 -0400
X-MC-Unique: T9YhYkT3Nvut-UAqAnpONQ-1
Received: by mail-wm1-f72.google.com with SMTP id n4-20020a1ca404000000b00392b49c7ae3so6698547wme.3
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 07:38:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Oay4ro9gliPGutvjNsoyWEuxgyMzWkRHOAjFiijjFoc=;
        b=BWnBrX3Hw1AkTpPwTjtB8QpjQMXTMCYmcwpRsclBMqqj46Y2myZv5v2GlQp2CgnpCq
         eGokmALEL449RFimtXVoqQTV6qRHLb8rtqjKerFFigUHMo82K6tFTbUOp43Puh0exnNT
         oXiEDQtZq12Kh3UEMtWfPnlgnm9U3lBz5wp+0nv9xEJCayz0LXfjIENDVVqu2pEMQW81
         FLvZFh20d+mBhNL5psJP7eRIZBhAsRMtWMye/H++HybtjB5Rvursu4bfR7lhD5i6BrSL
         MH+tuH2Kh+LNulFRJC6o/mQ6NKz/skCe8+HA8cpFKxjAhsfhZdL2ZFAkqHml3OO3BPBo
         f4pQ==
X-Gm-Message-State: AOAM531pkaUmh010wsiJ3W1EhwCSyZHmiTLUnqUUvl8O97mwwnUr11Jv
        T7a61CDiLMZJu7/3bWsWNaK0PYQrMwtukZrW5GAoQEm67fZsug1G8d1BAl+G6iIuGeVqdbnixMh
        Z+HCMCFflerI5+/iC
X-Received: by 2002:a5d:6e0d:0:b0:207:a4d9:7950 with SMTP id h13-20020a5d6e0d000000b00207a4d97950mr18375703wrz.477.1650983916504;
        Tue, 26 Apr 2022 07:38:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylYtF6Wp5jg40DA3zQEzDDxbPs4yx70tpkzBV4+NmNwdvK4cDa8N0/lzrq04ZWnbBO/BbNBw==
X-Received: by 2002:a5d:6e0d:0:b0:207:a4d9:7950 with SMTP id h13-20020a5d6e0d000000b00207a4d97950mr18375678wrz.477.1650983916291;
        Tue, 26 Apr 2022 07:38:36 -0700 (PDT)
Received: from redhat.com ([2.53.22.137])
        by smtp.gmail.com with ESMTPSA id i14-20020a1c540e000000b00393dc91e9c9sm10891399wmb.17.2022.04.26.07.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 07:38:35 -0700 (PDT)
Date:   Tue, 26 Apr 2022 10:38:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel test robot <oliver.sang@intel.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
Message-ID: <20220426103742-mutt-send-email-mst@kernel.org>
References: <YmeoSuMfsdVxuGlf@kroah.com>
 <CACycT3sLgihkgX5cB6GxDehaTsPn9rqhtWF7G_=J=__oTopJZw@mail.gmail.com>
 <YmfIv2YuARnPe97k@kroah.com>
 <CACycT3sq6WM1uCa+ix79AwTJHaEOhkLycwkZOhqPhABZ4xa2AA@mail.gmail.com>
 <YmfpKGZB06Ix5WPu@kroah.com>
 <CACycT3vD9o+_uLaevCZ=W==YRA_WJP8UJ6czHTtsUny8Rwgd0A@mail.gmail.com>
 <Ymf03l+Ag8ZBSGm2@kroah.com>
 <CACycT3vmN0z=in1hcT7XuW4p-vzq9SAgPJNGGkooc+C+qftWjw@mail.gmail.com>
 <20220426101640-mutt-send-email-mst@kernel.org>
 <CACycT3vLdjH820EBzz+4u5+6JH+hjnFTK1mtSJje9Uq1j_KTdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3vLdjH820EBzz+4u5+6JH+hjnFTK1mtSJje9Uq1j_KTdQ@mail.gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 10:37:17PM +0800, Yongji Xie wrote:
> On Tue, Apr 26, 2022 at 10:18 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Apr 26, 2022 at 10:02:02PM +0800, Yongji Xie wrote:
> > > > This should not be needed, when your module is unloaded, all devices it
> > > > handled should be properly removed by it.
> > > >
> > >
> > > I see. But it's not easy to achieve that currently. Maybe we need
> > > something like DEVICE_NEEDS_RESET support in virtio core.
> >
> > Not sure what the connection is.
> >
> 
> If we want to force remove all working vduse devices during module
> unload, we might need to send a DEVICE_NEEDS_RESET notification to
> device driver to do some cleanup before, e.g., return error for all
> inflight I/Os.
> 
> Thanks,
> Yongji

IMHO DEVICE_NEEDS_RESET won't help much with that, it's more in
case device is still there but needs a reset to start working.

-- 
MST

