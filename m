Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE0142A6A6
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 16:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237066AbhJLODW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 10:03:22 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:41596 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237175AbhJLODS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 10:03:18 -0400
Received: by mail-ot1-f51.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so21476529ote.8;
        Tue, 12 Oct 2021 07:01:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HgDCevGRcwJ0y7fnF8qyMkxEn9+lOCmwJnIpB+HFW+E=;
        b=mvxaCE+fio4MTYaSF0Swbd1JSN5UVnSiqBjN4sOGEhO2kmxDg5qLQx26pm0PBxbr8G
         yF9LlIuEITszCH085+GGqDEKlnzw3VV8++hj2RqqET65trxT7jpmlqFes5vN+ZlG/cDQ
         V6hci5CNhN0Qk1QiciC41DxVyQ/DaZHkcz8HrA4TndBo9bdyKIp7G4lVWg3pU7itMwm4
         Y2S2HrUUQJbZ7y908NPOuO4SY3U+0j/PtZ+Ig+iebLGv19Qtv9gJf4oLe2t2vihNtqCc
         y4jdEjODoo9147gim/hMd7Xvemhr8mqYF01y8gaCZtJdHUB+oxaWTcAiyRVpE25IBqq3
         EToQ==
X-Gm-Message-State: AOAM5325E6mGUl/fojxAmJe4vQweExRDIjBlWKKaSv/Dix0RLr2N+P+n
        kvk/lgo0QAvtkCGw5PjcWzGoBls2NCtPV6yi4WGfTC8Q
X-Google-Smtp-Source: ABdhPJxNwJpPfdAizvQU4IjuZwkLgdXOBlelrPInOnlRlHOjYJdHyRP+lUxFDPayEVmyN3VtcG35JcQgPW4ZCsJTqjs=
X-Received: by 2002:a9d:728a:: with SMTP id t10mr17682827otj.198.1634047275425;
 Tue, 12 Oct 2021 07:01:15 -0700 (PDT)
MIME-Version: 1.0
References: <20211002041840.2058647-1-nakato@nakato.io> <20211002041840.2058647-2-nakato@nakato.io>
 <912fedbb-5399-bb4e-555f-9ad48a284a31@redhat.com>
In-Reply-To: <912fedbb-5399-bb4e-555f-9ad48a284a31@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 12 Oct 2021 16:01:04 +0200
Message-ID: <CAJZ5v0hmfeib9VyoXysdTZ9mkxkfy4jBZCfW_SFVammJYr1v=g@mail.gmail.com>
Subject: Re: [PATCH 2/2] ACPI: PM: Include alternate AMDI0005 id in special behaviour
To:     Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Sachi King <nakato@nakato.io>
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Mark Gross <mgross@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 3:47 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 10/2/21 6:18 AM, Sachi King wrote:
> > The Surface Laptop 4 AMD has used the AMD0005 to identify this
> > controller instead of using the appropriate ACPI ID AMDI0005.  The
> > AMD0005 needs the same special casing as AMDI0005.
> >
> > Cc: <stable@vger.kernel.org> # 5.14+
> > Signed-off-by: Sachi King <nakato@nakato.io>
>
> Rafael, I assume that you will pick up this one?  Please add the
> following tags from other parts of the thread:
>
> Link: https://github.com/linux-surface/acpidumps/tree/master/surface_laptop_4_amd
> Link: https://gist.github.com/nakato/2a1a7df1a45fe680d7a08c583e1bf863
> Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
>

Applied as 5.15-rc material.

Thanks for collecting the tags for me Hans!


> > ---
> >  drivers/acpi/x86/s2idle.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
> > index bd92b549fd5a..1c48358b43ba 100644
> > --- a/drivers/acpi/x86/s2idle.c
> > +++ b/drivers/acpi/x86/s2idle.c
> > @@ -371,7 +371,7 @@ static int lps0_device_attach(struct acpi_device *adev,
> >               return 0;
> >
> >       if (acpi_s2idle_vendor_amd()) {
> > -             /* AMD0004, AMDI0005:
> > +             /* AMD0004, AMD0005, AMDI0005:
> >                * - Should use rev_id 0x0
> >                * - function mask > 0x3: Should use AMD method, but has off by one bug
> >                * - function mask = 0x3: Should use Microsoft method
> > @@ -390,6 +390,7 @@ static int lps0_device_attach(struct acpi_device *adev,
> >                                       ACPI_LPS0_DSM_UUID_MICROSOFT, 0,
> >                                       &lps0_dsm_guid_microsoft);
> >               if (lps0_dsm_func_mask > 0x3 && (!strcmp(hid, "AMD0004") ||
> > +                                              !strcmp(hid, "AMD0005") ||
> >                                                !strcmp(hid, "AMDI0005"))) {
> >                       lps0_dsm_func_mask = (lps0_dsm_func_mask << 1) | 0x1;
> >                       acpi_handle_debug(adev->handle, "_DSM UUID %s: Adjusted function mask: 0x%x\n",
> >
>
