Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23E045F687
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 22:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237559AbhKZVig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 16:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhKZVgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 16:36:35 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D36C06173E;
        Fri, 26 Nov 2021 13:33:21 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id v15so21238856ljc.0;
        Fri, 26 Nov 2021 13:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=sxqcIjSFGAKIxMCugWfN70Te+bGd3kOxeqXTHrWguDM=;
        b=jhNbO6BZsgucD8J1Jm72kMdgTt5CYGIfaNPydl7735+cJqxkEVZ3hGmLvyHs//hd24
         K9H624feCwv2V7W5F5n5F0DttFcCFvNJtNqAe/8y6Krq1B9Ifh1fyaFScgB7mi6X7eaW
         9BiJ6iRMSvDgwj1chhSe35u7CKrUXddYJpxdeOSb8b32Tnty1Ji8YNaAt4SBtLJar13l
         1PmqtZkJSBsqTFAQPdQ3r/BCW3rsladZ8K4TKrToq6eZTfImR5RnLkK4FVeIIieRCWhg
         HKIw1qGInQwOcnRtW9o0/Jd6loKiRfKxTvdrwEYRAkUfjxemUCprI51GupmP3sG3c7D9
         +0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=sxqcIjSFGAKIxMCugWfN70Te+bGd3kOxeqXTHrWguDM=;
        b=g92o7S9iTmvRn9oa3778F98b67g4jSx6HDQvXMUFbEsvRvnyRS+L45f0nD8ytpRvwi
         u3ssXHgXTJxETyqeOxsl4pe/fg9lllpoXqD9NkaweDU1d1U5Jsso9/qeGcWb4Ui8n24W
         M3fv1uY3LwluD+n4LvITRq02r7So0xTnW/jDiyogu5gR9OSMp6pYKEYUAs6IAEKNS8tZ
         bvT9+zVLxRdiEg6Mq1XzpOsTcxMYIXsXzsqXF0f+GtTA0SsOpKmYwxINTBWLeYrdl8Ky
         yu4GFl0bu2jITW75htdnwTR+JYdRCnnaMiAsj8GLddiaIT59rgsCV95Pt/6/NnQE0aOJ
         4rpQ==
X-Gm-Message-State: AOAM530LOSsguXYmcI6DqGDvGHPJBRwu7v/Nx4Asc3JLj2WMiQF1I0Ua
        P465dB9NpsQQTBQ5AbCbrwU97XW9g8cJ094/Wc+WTcs9OQE=
X-Google-Smtp-Source: ABdhPJzezbih18E7sKlvuHHPdJwZXWyAPU/MK2cDTnZuFqVkz5GFoXMLhVVf86mJERrzSoCM4TRJxf/VsjSbYz/ZJbE=
X-Received: by 2002:a2e:740b:: with SMTP id p11mr34110578ljc.215.1637962399497;
 Fri, 26 Nov 2021 13:33:19 -0800 (PST)
MIME-Version: 1.0
References: <CAGnHSE=uOEiLUS=Sx5xhSVrx-7kvdriC=RZxuRasZaM2cLmDeQ@mail.gmail.com>
 <CAGnHSEmFoAS-ZY6u=ar=O0UU=FPgEuOx5KLcBWkboEVdeFXbGg@mail.gmail.com>
In-Reply-To: <CAGnHSEmFoAS-ZY6u=ar=O0UU=FPgEuOx5KLcBWkboEVdeFXbGg@mail.gmail.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sat, 27 Nov 2021 05:33:08 +0800
Message-ID: <CAGnHSEmkTyq_QqP9S6TemsHOKxj2Gzq3R7X6+PxbQs_R-iBB7Q@mail.gmail.com>
Subject: Re: [Regression][Stable] sd use scsi_mode_sense with invalid param
To:     linux-scsi@vger.kernel.org, damien.lemoal@wdc.com,
        martin.petersen@oracle.com, sashal@kernel.org,
        stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Could you help pulling c749301ebee82eb5e97dec14b6ab31a4aabe37a6 into
the stable branches in which 17b49bcbf8351d3dbe57204468ac34f033ed60bc
has been pulled? Thanks!

Regards,
Tom

On Sat, 27 Nov 2021 at 05:21, Tom Yan <tom.ty89@gmail.com> wrote:
>
> Ahh, looks like the required change to sd
> (c749301ebee82eb5e97dec14b6ab31a4aabe37a6) has been added to upstream
> but somehow got missed when 17b49bcbf8351d3dbe57204468ac34f033ed60bc
> was pulled into stable...
>
> On Sat, 27 Nov 2021 at 05:11, Tom Yan <tom.ty89@gmail.com> wrote:
> >
> > Hi,
> >
> > So with 17b49bcbf8351d3dbe57204468ac34f033ed60bc (upstream),
> > scsi_mode_sense now returns -EINVAL if len < 8, yet in sd, the first mode
> > sense attempted by sd_read_cache_type() is done with (first_)len being
> > 4, which results in the failure of the attempt.
> >
> > Since the commit is merged into stable, my SATA drive (that has
> > volatile write cache) is assumed to be a "write through" drive after I
> > upgraded from 5.15.4 to 5.15.5, as libata sets use_10_for_ms to 1.
> >
> > Since sd does not (get to) determine which mode sense command to use,
> > should scsi_mode_sense at least accept a special value 0 (which
> > first_len would be set to), which is use to refers to the minimum len
> > to use for mode sense 6 and 10 respectively (i.e. 4 or 8)?
> >
> > Regards,
> > Tom
