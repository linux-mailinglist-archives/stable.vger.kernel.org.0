Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00324FB6FC
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 19:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfKMSDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 13:03:10 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:43053 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfKMSDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 13:03:09 -0500
Received: by mail-il1-f194.google.com with SMTP id r9so2619071ilq.10;
        Wed, 13 Nov 2019 10:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nkMxg4bs0DY+fIenh6frbtx62cRKfHn1vX+M8COZOOM=;
        b=ZOJotr2theprfi37s1ZEIS5HHCaeL01Ab4HU5FUqizNaVMrYRTk4el/33r/GtMwgJx
         gP9lK+Uj7/CPHrRUlpL34TEYUIqnW/WZ91lxe8yxHXCY7GPimgK5aaJVySsPdS5WP3Q9
         MoPnQCkLJBQfX8K65SYN32vyf5T3XvKQ/iUxOeTRzOdo5lhvfot79VRaWgJfSVRsbAjY
         6b93BTjyxUXfnT38ACpOPQSLCoQvPJBxcIAetT4unDApSPQSVWbNIG1UlWP1GBQn8fdN
         f65KaOmfq+5w4Ao8GkocnWjJeAP98sXWLtoI5S1rsWMV469MzVHghhMcP0Jt6MxbHDbM
         fkiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nkMxg4bs0DY+fIenh6frbtx62cRKfHn1vX+M8COZOOM=;
        b=V/sKGFYQsBWnNbepsp6NpqM0VKBk0eB4VWKl76j2W5/TkOc0wrtwFN3bDVbdb0F3QY
         Bn/RgJpTM60o+57s2UkECN/Xhsop2UwVXG9NsIhJJqelTkNyh6qDsvikx0WRccV19NGQ
         SeLMN/A4OjQ3SVqntszssSIMclnnB+Cxv5jWudBErabu6xUDw450Ho39TV6D3I+N70+F
         crICZ7iTQDK46XsDrdvRm+mOVBTHnmjzki7K7txWxunA2TsyCbu/aZKw9kPZmMBgir3E
         DvY0t6VLuppuPHNUCoYvIXxV7XodHEh3lsLcNLAvKl6/toG1i+CQW9ikdsmG96x+fv7L
         fe+A==
X-Gm-Message-State: APjAAAUlV1anpTLXNVsCWGTexTqu7gEGglwSWWKKnlu2eYvlsEc7oPdk
        aFszjKYcrzTlVk3iKA7FcoKDhamuZ+rrE0GsI4I=
X-Google-Smtp-Source: APXvYqwv3ffUNkAkeZW/JhON9obx0IFBdDOnyhASnVKWZt22SwhgbxtOrGqRpWEjNjq1r4lCXRxECbyDTjz5rKC0CEo=
X-Received: by 2002:a05:6e02:c91:: with SMTP id b17mr5199609ile.33.1573668188735;
 Wed, 13 Nov 2019 10:03:08 -0800 (PST)
MIME-Version: 1.0
References: <20191109004033.1496871-1-bjorn.andersson@linaro.org>
 <20191109004033.1496871-2-bjorn.andersson@linaro.org> <CAOCk7NrkpwyuZnq7C3CgLDBHoCXM=SMxvt_iv+nQzS9atT3B9A@mail.gmail.com>
In-Reply-To: <CAOCk7NrkpwyuZnq7C3CgLDBHoCXM=SMxvt_iv+nQzS9atT3B9A@mail.gmail.com>
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date:   Wed, 13 Nov 2019 11:02:57 -0700
Message-ID: <CAOCk7Nq4MgZ1ai6vu+hq3H8qu7P924JCsy1_ru7=5MCF2Z2nwg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] remoteproc: qcom_q6v5_mss: Don't reassign mpss
 region on shutdown
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Ohad Ben-Cohen <ohad@wizery.com>,
        Avaneesh Kumar Dwivedi <akdwived@codeaurora.org>,
        MSM <linux-arm-msm@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Sibi Sankar <sibis@codeaurora.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 12, 2019 at 10:01 AM Jeffrey Hugo <jeffrey.l.hugo@gmail.com> wrote:
>
> On Fri, Nov 8, 2019 at 5:40 PM Bjorn Andersson
> <bjorn.andersson@linaro.org> wrote:
> >
> > Trying to reclaim mpss memory while the mba is not running causes the
> > system to crash on devices with security fuses blown, so leave it
> > assigned to the remote on shutdown and recover it on a subsequent boot.
> >
> > Fixes: 6c5a9dc2481b ("remoteproc: qcom: Make secure world call for mem ownership switch")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>
> Stuff still works on the laptop, and I don't hit the access violation
> with the crash dump scenario on the mtp.
>
> Reviewed-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> Tested-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

Actually, nack that.  See comment below.

>
> > ---
> >
> > Changes since v1:
> > - Assign memory back to Linux in coredump case
> >
> >  drivers/remoteproc/qcom_q6v5_mss.c | 20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
> > index de919f2e8b94..efab574b2e12 100644
> > --- a/drivers/remoteproc/qcom_q6v5_mss.c
> > +++ b/drivers/remoteproc/qcom_q6v5_mss.c
> > @@ -875,11 +875,6 @@ static void q6v5_mba_reclaim(struct q6v5 *qproc)
> >                 writel(val, qproc->reg_base + QDSP6SS_PWR_CTL_REG);
> >         }
> >
> > -       ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
> > -                                     false, qproc->mpss_phys,
> > -                                     qproc->mpss_size);
> > -       WARN_ON(ret);
> > -
> >         q6v5_reset_assert(qproc);
> >
> >         q6v5_clk_disable(qproc->dev, qproc->reset_clks,
> > @@ -969,6 +964,10 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
> >                         max_addr = ALIGN(phdr->p_paddr + phdr->p_memsz, SZ_4K);
> >         }
> >
> > +       /* Try to reset ownership back to Linux */
> > +       q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm, false,
> > +                               qproc->mpss_phys, qproc->mpss_size);
> > +
> >         mpss_reloc = relocate ? min_addr : qproc->mpss_phys;
> >         qproc->mpss_reloc = mpss_reloc;
> >         /* Load firmware segments */
> > @@ -1058,9 +1057,14 @@ static void qcom_q6v5_dump_segment(struct rproc *rproc,
> >         void *ptr = rproc_da_to_va(rproc, segment->da, segment->size);
> >
> >         /* Unlock mba before copying segments */
> > -       if (!qproc->dump_mba_loaded)
> > +       if (!qproc->dump_mba_loaded) {
> >                 ret = q6v5_mba_load(qproc);
> >
> > +               /* Try to reset ownership back to Linux */
> > +               q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm, false,
> > +                                       qproc->mpss_phys, qproc->mpss_size);

If the load fails, we can't pull the memory otherwise we'll hit the
access violation (serror).  I happened to see this on a production
device, where I think the load fails because crashdumps are not
enabled.

> > +       }
> > +
> >         if (!ptr || ret)
> >                 memset(dest, 0xff, segment->size);
> >         else
> > @@ -1111,10 +1115,6 @@ static int q6v5_start(struct rproc *rproc)
> >         return 0;
> >
> >  reclaim_mpss:
> > -       xfermemop_ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
> > -                                               false, qproc->mpss_phys,
> > -                                               qproc->mpss_size);
> > -       WARN_ON(xfermemop_ret);
> >         q6v5_mba_reclaim(qproc);
> >
> >         return ret;
> > --
> > 2.23.0
> >
