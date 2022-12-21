Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FF7652C98
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 06:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiLUF7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 00:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbiLUF7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 00:59:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63401DA42
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 21:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671602332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YqEHm3UzxG6ffY8Bp/o4RuRuWIrmYvg6Ffwy9vsFjIs=;
        b=cGRdnJYu5AAYmk8hC7Q/ia9KHAQmwTDxeCT+VIkVLYwDAcvIwA94MsaGAnSgNQqdulbPqk
        92+BUQ8iQV55DlrwM8ejbbK98+vf9Iyge/il0YXZDIdAOMw/yytkdhic6yGnBEubncFt1/
        RJIbFNr6CDiQ7s60vDBFUGrEOyvKEtw=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-558-QCmw1Ck2OC6Cp77QSgG_zQ-1; Wed, 21 Dec 2022 00:58:48 -0500
X-MC-Unique: QCmw1Ck2OC6Cp77QSgG_zQ-1
Received: by mail-ot1-f72.google.com with SMTP id u11-20020a9d4d8b000000b006782ebb9bf5so3651120otk.11
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 21:58:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YqEHm3UzxG6ffY8Bp/o4RuRuWIrmYvg6Ffwy9vsFjIs=;
        b=xpIPGSvH84S0UoiG/bTqnEwL5aG85EDWNHxw7+t/GjZysOA0RLQiU7fRDvfc/8iRie
         GZI9Hz2P7kKKkREHkQNNlp4wyiSZg5dVoZa5MVUSdpB/U06/30ZtJSXEdZpD81NKmgQL
         bv67ElDUS5JOPeO2x62k9Gq19XbArpvqxu6qdqF6pUnbMYgUKVAQGUFNF2MSwB8COso9
         uUV7Pg2/lQ1Hdpe0Xa0u6QL+FPmJuqUo1LVsGPsgzGHMROOITcvOp4nkVhuEQ+ps+PVK
         Ap3vUpEqYCtd/jTfmZCsYp5AhFsH8GxUJsBj+VuLeU5tHWLhMn6fwoJFz8G/qXOtT1nv
         2lrg==
X-Gm-Message-State: AFqh2krITDneivuecYE7nZf6adg5DrJUlxWj7jaKxA+3c31I8NbhfMEt
        Q0M/beUGZqoYF7yi3XHV9iGJUTWFZsiJkY1TZ+whZmPIuVnCqO4DijM7LVYq4vLJaagH3ppwovq
        UTEJOlak7GHbxjZY9SemT25CwY1X6oIRt
X-Received: by 2002:a05:6870:ac21:b0:144:910f:43ea with SMTP id kw33-20020a056870ac2100b00144910f43eamr23560oab.140.1671602328023;
        Tue, 20 Dec 2022 21:58:48 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsDR9nnF7mnDlflQ/HQ+MgFqmKyqDpmpzDNyhXa+P22bXXqLYMkGFpt1uwqUiJhWJY6UGD9PZR/L2LPB+ouxTY=
X-Received: by 2002:a05:6870:ac21:b0:144:910f:43ea with SMTP id
 kw33-20020a056870ac2100b00144910f43eamr23554oab.140.1671602327855; Tue, 20
 Dec 2022 21:58:47 -0800 (PST)
MIME-Version: 1.0
References: <20221220140205.795115-1-lulu@redhat.com> <CACGkMEuJuUrA220XgHDOruK-aHWSfJ6mTaqNVQCAcOsPEwV91A@mail.gmail.com>
In-Reply-To: <CACGkMEuJuUrA220XgHDOruK-aHWSfJ6mTaqNVQCAcOsPEwV91A@mail.gmail.com>
From:   Cindy Lu <lulu@redhat.com>
Date:   Wed, 21 Dec 2022 13:58:11 +0800
Message-ID: <CACLfguUgsWrE+ZFxJYd-h81AvMQFio0-VU9oE0kpj7t5D2pJvg@mail.gmail.com>
Subject: Re: [PATCH] vhost_vdpa: fix the compile issue in commit 881ac7d2314f
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Dec 2022 at 11:23, Jason Wang <jasowang@redhat.com> wrote:
>
> On Tue, Dec 20, 2022 at 10:02 PM Cindy Lu <lulu@redhat.com> wrote:
> >
> > The input of  vhost_vdpa_iotlb_unmap() was changed in 881ac7d2314f,
> > But some function was not changed while calling this function.
> > Add this change
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 881ac7d2314f ("vhost_vdpa: fix the crash in unmap a large memory")
>
> Is this commit merged into Linus tree?
>
> Btw, Michael, I'd expect there's a respin of the patch so maybe Cindy
> can squash the fix into the new version?
>
> Thanks
>
This is not merged in linus tree, and this compile issue was hit in mst's tree
should I send a new version squash the patch and the fix?

Thanks
Cindy
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > ---
> >  drivers/vhost/vdpa.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 46ce35bea705..ec32f785dfde 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -66,8 +66,8 @@ static DEFINE_IDA(vhost_vdpa_ida);
> >  static dev_t vhost_vdpa_major;
> >
> >  static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
> > -                                  struct vhost_iotlb *iotlb,
> > -                                  u64 start, u64 last);
> > +                                  struct vhost_iotlb *iotlb, u64 start,
> > +                                  u64 last, u32 asid);
> >
> >  static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
> >  {
> > @@ -139,7 +139,7 @@ static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
> >                 return -EINVAL;
> >
> >         hlist_del(&as->hash_link);
> > -       vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
> > +       vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1, asid);
> >         kfree(as);
> >
> >         return 0;
> > --
> > 2.34.3
> >
>

