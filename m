Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C1A1AE659
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 21:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbgDQTzH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 17 Apr 2020 15:55:07 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35177 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730573AbgDQTzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 15:55:07 -0400
Received: by mail-ot1-f68.google.com with SMTP id e20so2468647otl.2;
        Fri, 17 Apr 2020 12:55:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=irXuNro8HvnRk+BrWbbABXUvW4MljqIc9AUWoi1f2Eo=;
        b=Hx40PtklOQjWpRU4woK0+sZwX9lJ18V/yloRjlwhrs9y6/7n25ydy2NPsNpMk7r2Ol
         mORS1QiQH98RV3R2k4eKZvXV02QKaKfX1gahfecWCv10NdrG2a/BDDSVCrQNTWftVB0a
         BmlNzyH2H3gfrV6uTfc6rTuo0pxBGnxLo2HHct2ZIxJhfOOkSnxskMmgxylK7MhLOyLb
         vsepFZczZPihiEwN5MyZV3WM3+duvGBcTIcjxbSjLpWNJrpJxOJ1k4zrdjpdwOtEL2Ri
         owtrJDvST2KE+Ibdq6XtehnBwc2Ge6oDnVY8WIbG1iX+T/u/DKXFarbtPLEQ1fKrWGJe
         Ersw==
X-Gm-Message-State: AGi0Pua+t8tU7LYNlTfnLEgYaExTqydMvyLcZG7EDG5EmBngYHrVqm40
        fCGVCRB8OGkatbJDrudi/GoE/Y/RS0uHc2Oxd78=
X-Google-Smtp-Source: APiQypI0BBzCQh563PyRKr+8vxbIskn+ZdpBUycqdaHyYpZErR2AUCMpj2pG/e17Vusf5CRqe6Ug/6dWW7CPyJqTQDA=
X-Received: by 2002:a9d:1d07:: with SMTP id m7mr384246otm.167.1587153306213;
 Fri, 17 Apr 2020 12:55:06 -0700 (PDT)
MIME-Version: 1.0
References: <fdd9ce1d-146a-5fbf-75c5-3a9384603312@gmx.de> <5478a950-4355-8084-ea7d-fe8b270bf2e3@infradead.org>
 <5392275.BHAU0OPJTB@kreacher> <4b21c095-fbe5-1138-b977-a505baa41a2b@gmx.de>
 <CAJZ5v0icdVL6_yGpfsorqszdi9GcLxzYdvDqTJyG4ENzkOG2pQ@mail.gmail.com> <d66ad8f1-d7c5-dd8a-0eb4-9e560dc9ada1@gmx.de>
In-Reply-To: <d66ad8f1-d7c5-dd8a-0eb4-9e560dc9ada1@gmx.de>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 17 Apr 2020 21:54:54 +0200
Message-ID: <CAJZ5v0iXJK_kFzr=cOdcTdc947MOcm2hvNV1WgvAnxOY7uvWfg@mail.gmail.com>
Subject: Re: regression 5.6.4->5.6.5 at drivers/acpi/ec.c
To:     =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 17, 2020 at 9:41 PM Toralf Förster <toralf.foerster@gmx.de> wrote:
>
> On 4/17/20 8:52 PM, Rafael J. Wysocki wrote:
> > On Fri, Apr 17, 2020 at 6:36 PM Toralf Förster <toralf.foerster@gmx.de> wrote:
> >>
> >> On 4/17/20 5:53 PM, Rafael J. Wysocki wrote:
> >>> Does the patch below (untested) make any difference?
> >>>
> >>> ---
> >>>  drivers/acpi/ec.c |    5 ++++-
> >>>  1 file changed, 4 insertions(+), 1 deletion(-)
> >>>
> >>> Index: linux-pm/drivers/acpi/ec.c
> >>> ===================================================================
> >>> --- linux-pm.orig/drivers/acpi/ec.c
> >>> +++ linux-pm/drivers/acpi/ec.c
> >>> @@ -2067,7 +2067,10 @@ static struct acpi_driver acpi_ec_driver
> >>>               .add = acpi_ec_add,
> >>>               .remove = acpi_ec_remove,
> >>>               },
> >>> -     .drv.pm = &acpi_ec_pm,
> >>> +     .drv = {
> >>> +             .probe_type = PROBE_FORCE_SYNCHRONOUS,
> >>> +             .pm = &acpi_ec_pm,
> >>> +     },
> >>>  };
> >>>
> >>>  static void acpi_ec_destroy_workqueues(void)
> >> I'd say no, but for completeness:
> >
> > OK, it looks like mainline commit
> >
> > 65a691f5f8f0 ("ACPI: EC: Do not clear boot_ec_is_ecdt in acpi_ec_add()")
> >
> > was backported into 5.6.5 by mistake.
> >
> > Can you please revert that patch and retest?
> >
> Yes, reverting that commit solved the issue.

OK, thanks!

Greg, I'm not sure why commit 65a691f5f8f0 from the mainline ended up in 5.6.5.

It has not been marked for -stable or otherwise requested to be
included AFAICS.  Also it depends on other mainline commits that have
not been included into 5.6.5.

Can you please drop it?
