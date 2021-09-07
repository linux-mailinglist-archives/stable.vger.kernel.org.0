Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BED402F18
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 21:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345606AbhIGTsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 15:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236862AbhIGTsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 15:48:18 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0397BC061757
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 12:47:11 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id lc21so439677ejc.7
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 12:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N9otEH3ER4+vClNTReF/OzEffgc/Rwc7xeZ8X4aJVGE=;
        b=T7Tx11t8FZiGm+i4WywmrqwjGcPyHyx2XDrAJs1Lj/2zHzDdhN5/UsG0diUJC6Ufoz
         0txtM/V3dAwdElDdSbxCE+/r1/aTJTSB0jY9PFEmvDflr151Iahw8BB6sZ79K9f7894b
         +lgmtKtrRHyltv9VueYGxvcjbIXVfD55pN3A98325mtrxCUncORxkOkMooR+v9qeH2Kd
         lH8QSn/ZK3vPUKutJDG2sMPZA0qyonWIrdKw+FMbfAQZSiOV1s6zmw+OhxmmyCfc6V+H
         bUEN5Uom114T+0M6CzMQtPDJQrpDpl+nt1inKln4suRlTHb7OvFy4RZdl9p/HA09BOvg
         gFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N9otEH3ER4+vClNTReF/OzEffgc/Rwc7xeZ8X4aJVGE=;
        b=Pye3aGInup0i+bUHahyE+3pyN5zDPYfQ0KCWTw2z+Vz1wbBD+MQEsoOaInQVvx+xOl
         Aj0L7IxEhG1p3cQ9rZqHwF/a7Qj+S7zJgPSv/6qyalsX6fKeibElIvgiCrMqZaEmWRXi
         BQt99l4btCj/8kxyRQkLA9fedAxKNCT0b1zczgz1Fh2P9dxK6Ax4XYF/N2X5K6tBMTS9
         kUzM24VjQs9l3bLa07QjCLQhB9Q+pyVAeP3dtI/oz7LAv/oB/FpODXDFGR5sExVd8Wby
         qhHoypKgBD8UEbk49HBVLW0ChFts6l/xLe9jU2FOJqladYtbvVRy8e+zuF2dNRfZHvYt
         c3VQ==
X-Gm-Message-State: AOAM530ihp/8lULx+9xN/se5O8qcCTdyZlRi1cK2AVu3dO64NlNLe4TM
        ozJCUz49CNgOe8dTouluRj/Gznw8wPyD0xscvUCIC4ZJbw==
X-Google-Smtp-Source: ABdhPJwE7ZwqYCa5aBojV9w+zCqMd845sudx0MG3jp2xq8CwHSDUX3VF+OrrUle3jgdjzPy8sxu96/CDDKqbPgZ1c2w=
X-Received: by 2002:a17:906:7208:: with SMTP id m8mr32611ejk.82.1631044030307;
 Tue, 07 Sep 2021 12:47:10 -0700 (PDT)
MIME-Version: 1.0
References: <163072203373.2250120.8373702699578427249.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163072204525.2250120.16615792476976546735.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHC9VhTNu8E9WkzUHbQC9xKK5U74L8oqetUtPXGX2RSofMcqgw@mail.gmail.com> <CAPcyv4gR+WbYf-dT0niT23UY8jZZVBXMk4R-1_0exPcbHrs=0Q@mail.gmail.com>
In-Reply-To: <CAPcyv4gR+WbYf-dT0niT23UY8jZZVBXMk4R-1_0exPcbHrs=0Q@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 7 Sep 2021 15:46:59 -0400
Message-ID: <CAHC9VhTo-eV4oUF-ia67X-KK-qyB=M0xDv-=p0-xA-4=0BJ6uA@mail.gmail.com>
Subject: Re: [PATCH 2/6] cxl/pci: Fix lockdown level
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        stable <stable@vger.kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        "Schofield, Alison" <alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 7, 2021 at 1:39 PM Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, Sep 3, 2021 at 8:57 PM Paul Moore <paul@paul-moore.com> wrote:
> >
> > On Fri, Sep 3, 2021 at 10:20 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > A proposed rework of security_locked_down() users identified that the
> > > cxl_pci driver was passing the wrong lockdown_reason. Update
> > > cxl_mem_raw_command_allowed() to fail raw command access when raw pci
> > > access is also disabled.
> > >
> > > Fixes: 13237183c735 ("cxl/mem: Add a "RAW" send command")
> > > Cc: Ben Widawsky <ben.widawsky@intel.com>
> > > Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > > Cc: <stable@vger.kernel.org>
> > > Cc: Ondrej Mosnacek <omosnace@redhat.com>
> > > Cc: Paul Moore <paul@paul-moore.com>
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > ---
> > >  drivers/cxl/pci.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Hi Dan,
> >
> > Thanks for fixing this up.  Would you mind if this was included in
> > Ondrej's patchset, or would you prefer to merge it via another tree
> > (e.g. cxl)?
>
> I was planning to merge this via the cxl tree for v5.15-rc1.

Okay, thanks.

-- 
paul moore
www.paul-moore.com
