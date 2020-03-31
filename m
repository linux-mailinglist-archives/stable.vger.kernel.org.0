Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAD6198C31
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 08:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgCaGTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 02:19:41 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34075 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgCaGTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 02:19:41 -0400
Received: by mail-ot1-f68.google.com with SMTP id m2so6176307otr.1;
        Mon, 30 Mar 2020 23:19:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XCdJCbcFAqKbu5o4UMmbzXHaFPJd9Ik8M7QfW5a9gSE=;
        b=fAdt+P+TSKsLmQG16uvwEgJI6R2W8qSmVKlRVlUuSaL6tK94YZbiGI8cxjtAVgKekF
         gBo2sOAB/Nmbz1tKSWemDsaDaneA3UEcIfXQTEJu4x9StbilSAnYbevMr02IFJ+u8mcp
         Vu0NGrTdWmK3DQsuxdz3tDdUOvhvgm+SKS8nZty0ikhxLU/IUU3ZKHCSGqfHgpmRXpYi
         EcNdnW9kmkFnpB1tKvYNmxVoseeFi/qY731g9G+7d+BtpZKCzNZcslxYjMK1NpnQ5AM+
         oI0OLSs9osopGxohIgF9OfD3N1XEgCd9nVV7tr+3r5rZiF8VybiKpmsSMfvEc0AgfvEu
         xOVA==
X-Gm-Message-State: ANhLgQ3j/2txs4XNjaaDyBFY8lmcGOsC/eDVz9cKYTl7mj9rxLUeN/yD
        sGDZYN1FMvTp+NI4bckfBrWArAsuRSwSL3BDVlw=
X-Google-Smtp-Source: ADFU+vsLlPUWVwHlm1MZohs4ZiijuCiA9dRuDMtpcpQVflJWE1hgPv4eVishiq59gAA1qUXFEEGgkbR2+8SmWFBYtRo=
X-Received: by 2002:a9d:7402:: with SMTP id n2mr12255889otk.262.1585635580865;
 Mon, 30 Mar 2020 23:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585343507.git.gayatri.kammela@intel.com>
 <9359b8e261d69983b1eed2b8e53ef9eabfdfdd51.1585343507.git.gayatri.kammela@intel.com>
 <CAJZ5v0j8OaqM6k52Ar9sYn0Ea_u9+MBB0rcMWv6vGBt5jXCQBQ@mail.gmail.com>
 <20200330172439.GB1922688@smile.fi.intel.com> <BYAPR11MB362459660B914BEF1526AD8DF2CB0@BYAPR11MB3624.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB362459660B914BEF1526AD8DF2CB0@BYAPR11MB3624.namprd11.prod.outlook.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 31 Mar 2020 08:19:29 +0200
Message-ID: <CAJZ5v0inmWu6_ZYLCKart6F873SqK5AyvVXOCS83Yr=KQAQV_Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ACPI: fix: Update Tiger Lake ACPI device IDs
To:     "Kammela, Gayatri" <gayatri.kammela@intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Alex Hung <alex.hung@canonical.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Prestopine, Charles D" <charles.d.prestopine@intel.com>,
        "5 . 6+" <stable@vger.kernel.org>,
        "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 1:22 AM Kammela, Gayatri
<gayatri.kammela@intel.com> wrote:
>
> > -----Original Message-----
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Sent: Monday, March 30, 2020 10:25 AM
> > To: Rafael J. Wysocki <rafael@kernel.org>
> > Cc: Kammela, Gayatri <gayatri.kammela@intel.com>; Zhang, Rui
> > <rui.zhang@intel.com>; Linux PM <linux-pm@vger.kernel.org>; Platform
> > Driver <platform-driver-x86@vger.kernel.org>; Linux Kernel Mailing List
> > <linux-kernel@vger.kernel.org>; Len Brown <lenb@kernel.org>; Darren Hart
> > <dvhart@infradead.org>; Alex Hung <alex.hung@canonical.com>; Daniel
> > Lezcano <daniel.lezcano@linaro.org>; Amit Kucheria
> > <amit.kucheria@verdurent.com>; Westerberg, Mika
> > <mika.westerberg@intel.com>; Peter Zijlstra <peterz@infradead.org>;
> > Prestopine, Charles D <charles.d.prestopine@intel.com>; 5 . 6+
> > <stable@vger.kernel.org>; Pandruvada, Srinivas
> > <srinivas.pandruvada@intel.com>; Wysocki, Rafael J
> > <rafael.j.wysocki@intel.com>
> > Subject: Re: [PATCH v2 1/3] ACPI: fix: Update Tiger Lake ACPI device IDs
> >
> > On Mon, Mar 30, 2020 at 06:43:35PM +0200, Rafael J. Wysocki wrote:
> > > On Fri, Mar 27, 2020 at 10:34 PM Gayatri Kammela
> > > <gayatri.kammela@intel.com> wrote:
> >
> > > > -       {"INT1044"},
> > > > -       {"INT1047"},
> > > > +       {"INTC1040"},
> > > > +       {"INTC1043"},
> > > > +       {"INTC1044"},
> > > > +       {"INTC1047"},
> > > >         {"INT3400"},
> > > >         {"INT3401", INT3401_DEVICE},
> > > >         {"INT3402"},
> > > > --
> > >
> > > I can take this along with the other two patches in the series if that
> > > is fine by Andy and Rui.
> >
> > One nit is to fix the ordering to be alphanumeric or close enough (I admit in
> > some cases it might require unneeded churn) to that.
> Thanks Andy and Rafael! Should I send v3 for this series with right ordering this time?

No need, I can fix up the ordering just fine.

> > Otherwise,
> > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Thanks!
