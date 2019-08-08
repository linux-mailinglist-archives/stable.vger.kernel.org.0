Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D6F86597
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 17:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732477AbfHHPVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 11:21:18 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44486 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfHHPVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Aug 2019 11:21:17 -0400
Received: by mail-ot1-f67.google.com with SMTP id b7so69842224otl.11
        for <stable@vger.kernel.org>; Thu, 08 Aug 2019 08:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=62wPsGMynwfej/OoKErjBbr2fFO4UlH7moOGmVEgcPY=;
        b=QWLuNsnE+aKeazvULF2iiss/MAzTxMI+IOnAKBvxpWmbKVHzAkXrbqU8MztcyHrsiO
         jwrWHhPavRYFK5SVLhhCMoMdICyjKxDtbox4bzwFiQ0nIs5e4NZGRqYCkdxpWRsDUmP3
         I+uu/NadCvnKhBlaQWYnKt+TpQKb/8KbISU3dcuDRJrQKgM6Za/37sy4M6Y4/ma9CJzH
         ADGOcG0wVYpgqzLHNusWCg4Csc+rdplcWdM4JOBEElYeMpBtIpYO8LU9fhLYYZzZm6cY
         6oSw1kpRjJp20WjnH17p/4+tl2yDx3AwkQ0BfVPHdOWkr1HljyIMB+T5BJ7JXfzsQBgW
         T5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=62wPsGMynwfej/OoKErjBbr2fFO4UlH7moOGmVEgcPY=;
        b=rO4YXBm6mk0OvUEQJuZNtTtsZATIJ27pRypjT6mRhC/2I5YCGcm6JYqjEpU7iYyvO0
         6x4sVoEwhH47onI4Tt1RSPm2tNct8Y0W3zcZWNwvqy1ix1sw5Tpva1EMV7vAVFveKfGP
         4O6nrSVQ2OwKvey/qNh0ZjsRhtyIiFLX0/QWOLVDDfw29RuzEo1gcA52G8uRTdV4iRHA
         ChX9uLokufpu88zFN0NEw8+ZNBfVPDgyCu4zbYKd1PYKqWs+bX8B7qTXfAKIiCNYu7+k
         mt2oqmTZ/vz4FfPYTyUSbRFwdf2fVX8pwD1pgK1RH2hF/xstq1Q3Krt2ut/zP7IubNjF
         Nx9Q==
X-Gm-Message-State: APjAAAWip9upaDR+2QGywpmjzA00XVcWmzxj206PfKhbRRoaDz536D5R
        cCFiTKziJn2AkaIsYzMmsuiV3ZlEIDou+Q==
X-Google-Smtp-Source: APXvYqx9RE6Vox98TEtIIsFUKykzsoBLg0onKqFTUwKeBChj/gjMpCrWA/HAhtKoaa5YQPAa/GPzOw==
X-Received: by 2002:aca:ec82:: with SMTP id k124mr2762749oih.73.1565277676885;
        Thu, 08 Aug 2019 08:21:16 -0700 (PDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com. [209.85.210.51])
        by smtp.gmail.com with ESMTPSA id h13sm31449512otq.11.2019.08.08.08.21.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 08:21:16 -0700 (PDT)
Received: by mail-ot1-f51.google.com with SMTP id l15so120084725otn.9
        for <stable@vger.kernel.org>; Thu, 08 Aug 2019 08:21:15 -0700 (PDT)
X-Received: by 2002:a9d:7248:: with SMTP id a8mr14036212otk.363.1565277675268;
 Thu, 08 Aug 2019 08:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190808022819.108337-1-balsini@android.com> <20190808090049.GC1265@kroah.com>
In-Reply-To: <20190808090049.GC1265@kroah.com>
From:   Alessio Balsini <balsini@android.com>
Date:   Thu, 8 Aug 2019 08:21:04 -0700
X-Gmail-Original-Message-ID: <CAKM9miJ=CmW0b-_3UDg7BySg73qVs2ctSiz7dQL5TXuOkacGyw@mail.gmail.com>
Message-ID: <CAKM9miJ=CmW0b-_3UDg7BySg73qVs2ctSiz7dQL5TXuOkacGyw@mail.gmail.com>
Subject: Re: [PATCH 3.18.y 4.4.y 4.9.y] block: blk_init_allocated_queue() set
 q->fq as NULL in the fail case
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, xiao jin <jin.xiao@intel.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oops, thanks!

On Thu, Aug 8, 2019 at 2:00 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Aug 08, 2019 at 03:28:19AM +0100, Alessio Balsini wrote:
> > From: xiao jin <jin.xiao@intel.com>
> >
> > commit 54648cf1ec2d7f4b6a71767799c45676a138ca24 upstream.
> >
> > We find the memory use-after-free issue in __blk_drain_queue()
> > on the kernel 4.14. After read the latest kernel 4.18-rc6 we
> > think it has the same problem.
> >
> > Memory is allocated for q->fq in the blk_init_allocated_queue().
> > If the elevator init function called with error return, it will
> > run into the fail case to free the q->fq.
> >
> > Then the __blk_drain_queue() uses the same memory after the free
> > of the q->fq, it will lead to the unpredictable event.
> >
> > The patch is to set q->fq as NULL in the fail case of
> > blk_init_allocated_queue().
> >
> > Fixes: commit 7c94e1c157a2 ("block: introduce blk_flush_queue to drive flush machinery")
> > Cc: <stable@vger.kernel.org>
> > Reviewed-by: Ming Lei <ming.lei@redhat.com>
> > Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
> > Signed-off-by: xiao jin <jin.xiao@intel.com>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Alessio Balsini <balsini@android.com>
> > ---
> >  block/blk-core.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 50d77c90070d..7662f97dded6 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -870,6 +870,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
> >
> >  fail:
> >       blk_free_flush_queue(q->fq);
> > +     q->fq = NULL;
> >       return NULL;
> >  }
> >  EXPORT_SYMBOL(blk_init_allocated_queue);
> > --
> > 2.22.0.770.g0f2c4a37fd-goog
> >
>
> Guenter sent this backport a day before you did, so I took his version
> and added your s-o-b to it.
>
> thanks,
>
> greg k-h
