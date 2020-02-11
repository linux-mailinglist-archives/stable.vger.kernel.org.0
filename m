Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95741598E4
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 19:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgBKSmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 13:42:39 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:44544 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728375AbgBKSmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 13:42:39 -0500
Received: by mail-io1-f67.google.com with SMTP id z16so12904627iod.11
        for <stable@vger.kernel.org>; Tue, 11 Feb 2020 10:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tb6kXJT2IPt0OzdthJIyzIwD+V8Zde13ETSgdH0IZ40=;
        b=zQBE1Fk+YV6ZOEET9w+OD3R7NhX3F43AMNwTH3W4y72xDmECkuQrSvqQj5gWLm5NRJ
         ba61XeL5xmSzXqBz+u4El1iNtDATvmwfAnV7g0MA9asd4/ET4MQCQoQSJq6e8jHRDqBO
         o/8t16A73pSr813cJ8lHzakkPwNqn7bUKyTI6rhFojrYMzsTsu+SIN8tJXGuh3wR+TpA
         NMg1g9zy7/Ek+Cw2iF48WNVEsUUSgOcmDeosaUegjmWowtZDxU56TCiwwNsyctpk0DJa
         fCEAoi4FYx7wMvIBlyFm5VP+S32fy9h9m1COnI8sh305XvseBd6OXIvJBWkWJpiCEpAK
         6wig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tb6kXJT2IPt0OzdthJIyzIwD+V8Zde13ETSgdH0IZ40=;
        b=Xl/Pfjsi4goxpSC5J2N6Wt3TW4FLaxC0mYE7Z9HiSdE5zmrRhUG1Ze3yIRvjYp47MZ
         TkXyJIJlwl7Vozs1zyZqCJEKlLhWLGl0N5691JALxx1gE0k2C+dbQ2PZ/P8jVDKXUcus
         owFrv/LS05/UeMNR/t0r7eyyhW/T+3rJIQ+t8z+6GvAwK/P0uB7qYy6tz7WVxBq6sT8y
         57PNaX8BMxsTlraPQCjkHzCYvXdg/+3t005ClYU79EMLnkU8lprGhEaca90p/3Ojmf1n
         n9iQuwFystaOBQOBqOm17WnP3fNICrNr/SZsVg30+T2Je/Y2zSyyO8HC7SYhzDvQvPGh
         IgKg==
X-Gm-Message-State: APjAAAUkW+akUPVdB5tC3mTxbUE4ZjiRaCQ/UZDUC01FW6CubuVE9tqO
        a6Bssx2qdbcRHFZtJnHvftdbcXeCoNu5aMqt41oJ3w==
X-Google-Smtp-Source: APXvYqye9IvbqDD5VFHUvUHHYimyx5TYHJqSTs2p4McDlYyzMSbvgCTZJANcgR4hgrFbeGHQEL0LI+OvORy5yN2Z4x0=
X-Received: by 2002:a02:cc41:: with SMTP id i1mr15412023jaq.71.1581446558643;
 Tue, 11 Feb 2020 10:42:38 -0800 (PST)
MIME-Version: 1.0
References: <20200204062641.393949-1-bjorn.andersson@linaro.org>
 <20200204062641.393949-2-bjorn.andersson@linaro.org> <20200210230548.GA20652@xps15>
 <20200211011601.GD3261042@ripper>
In-Reply-To: <20200211011601.GD3261042@ripper>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Tue, 11 Feb 2020 11:42:27 -0700
Message-ID: <CANLsYkzzxW46Kawx2LcDbqD2A_bXXf6bJTkYA7=V37E-3p4Row@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] remoteproc: qcom_q6v5_mss: Don't reassign mpss
 region on shutdown
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Ohad Ben-Cohen <ohad@wizery.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-remoteproc <linux-remoteproc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        "# 4 . 7" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Feb 2020 at 18:16, Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> On Mon 10 Feb 15:05 PST 2020, Mathieu Poirier wrote:
>
> > Hi Bjorn,
> >
> > On Mon, Feb 03, 2020 at 10:26:40PM -0800, Bjorn Andersson wrote:
> > > Trying to reclaim mpss memory while the mba is not running causes the
> > > system to crash on devices with security fuses blown, so leave it
> > > assigned to the remote on shutdown and recover it on a subsequent boot.
> > >
> > > Fixes: 6c5a9dc2481b ("remoteproc: qcom: Make secure world call for mem ownership switch")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > > ---
> > >
> > > Changes since v2:
> > > - The assignment of mpss memory back to Linux is rejected in the coredump case
> > >   on production devices, so check the return value of q6v5_xfer_mem_ownership()
> > >   before attempting to memcpy() the data.
> > >
> > >  drivers/remoteproc/qcom_q6v5_mss.c | 23 +++++++++++++----------
> > >  1 file changed, 13 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
> > > index 471128a2e723..25c03a26bf88 100644
> > > --- a/drivers/remoteproc/qcom_q6v5_mss.c
> > > +++ b/drivers/remoteproc/qcom_q6v5_mss.c
> > > @@ -887,11 +887,6 @@ static void q6v5_mba_reclaim(struct q6v5 *qproc)
> > >             writel(val, qproc->reg_base + QDSP6SS_PWR_CTL_REG);
> > >     }
> > >
> > > -   ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
> > > -                                 false, qproc->mpss_phys,
> > > -                                 qproc->mpss_size);
> > > -   WARN_ON(ret);
> > > -
> > >     q6v5_reset_assert(qproc);
> > >
> > >     q6v5_clk_disable(qproc->dev, qproc->reset_clks,
> > > @@ -981,6 +976,10 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
> > >                     max_addr = ALIGN(phdr->p_paddr + phdr->p_memsz, SZ_4K);
> > >     }
> > >
> > > +   /* Try to reset ownership back to Linux */
> > > +   q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm, false,
> > > +                           qproc->mpss_phys, qproc->mpss_size);
> >
> > Would you mind adding more chatter here, something like what is mentioned in the
> > changelog?  That way I anyone trying to review this code doesn't have to suffer
> > through the same mental gymnastic.
> >
>
> Sure thing, as this patch shows this dynamic wasn't clear - and this
> patch is based on my observations. With it we no longer crash the entire
> system by hitting a security violation during a crash, but there's still
> some details that I'm uncertain about.
>
> > > +
> > >     mpss_reloc = relocate ? min_addr : qproc->mpss_phys;
> > >     qproc->mpss_reloc = mpss_reloc;
> > >     /* Load firmware segments */
> > > @@ -1070,8 +1069,16 @@ static void qcom_q6v5_dump_segment(struct rproc *rproc,
> > >     void *ptr = rproc_da_to_va(rproc, segment->da, segment->size);
> > >
> > >     /* Unlock mba before copying segments */
> > > -   if (!qproc->dump_mba_loaded)
> > > +   if (!qproc->dump_mba_loaded) {
> > >             ret = q6v5_mba_load(qproc);
> > > +           if (!ret) {
> > > +                   /* Try to reset ownership back to Linux */
> > > +                   ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
> > > +                                                 false,
> > > +                                                 qproc->mpss_phys,
> > > +                                                 qproc->mpss_size);
> > > +           }
> >
> > I'm a bit puzzled here as to why a different reclaim strategy is needed.  It is
> > clear to me that if q6v5_mba_load() returns 0 then the MBA is running and we can
> > safely reclaim ownership of the memory.  But is it absolutely needed when we
> > know that 1) the MCU has crashed and 2) said memory will be reclaimed in
> > q6v5_mpss_load()?
> >
>
> The ownership transfer here is a jump into secure world, which somehow
> together with the firmware running on the modem processor will update
> the access permissions for the mpss memory region.
>
> As we enter this function the recovery handling in the core has just
> stopped the remote processor, so we know it's off. As such we must first
> boot the remote processor again, in order to reclaim the access to the
> mpss memory region.
>
> New in this revision is the fact that this operation might actually be
> rejected (e.g. on end-user hardware).
>
> So we need to guard the memcpy below on either of these cases, as unless
> we've successfully booted the modem processor and gotten permission to
> read the mpss memory this operation will trigger a security violation
> and the device will reboot.
>
> > If so I think an explanation in the code is needed.
> >
>
> Makes sense, I will formulate above explanation into a comment. As well
> as review the other callers of q6v5_xfer_mem_ownership().
>
> > I also assume there is no way to know if the mba is running, hence not taking
> > any chance.  If that's the case it would be nice to add that to the comment in
> > q6v5_mpss_load().
> >
>
> We know that we enter q6v5_mpss_load() with the modem processor just
> booted, but the memory assignment is there to handle the case where the
> mpss memory region for some reason was left in the hands on the modem.
> I will have to do some more digging to figure out if this is a valid
> scenario or not.

I'm really happy that you're also not sure about this patch... I spent
hours (no joke) trying to figure out the workflow and logic of using
q6v5_xfer_mem_ownership() and even then I'm ambivalent...  Carefully
understanding and documenting the scenarios we trying to handle will
go a long way in terms of future stability of the system.

>
> Thanks for your review Mathieu!
>
> Regards,
> Bjorn
>
> > Thanks,
> > Mathieu
> >
> > > +   }
> > >
> > >     if (!ptr || ret)
> > >             memset(dest, 0xff, segment->size);
> > > @@ -1123,10 +1130,6 @@ static int q6v5_start(struct rproc *rproc)
> > >     return 0;
> > >
> > >  reclaim_mpss:
> > > -   xfermemop_ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
> > > -                                           false, qproc->mpss_phys,
> > > -                                           qproc->mpss_size);
> > > -   WARN_ON(xfermemop_ret);
> > >     q6v5_mba_reclaim(qproc);
> > >
> > >     return ret;
> > > --
> > > 2.23.0
> > >
