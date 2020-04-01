Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8A419AAC9
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 13:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732297AbgDAL3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 07:29:45 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39965 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732147AbgDAL3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 07:29:45 -0400
Received: by mail-oi1-f194.google.com with SMTP id y71so21833778oia.7;
        Wed, 01 Apr 2020 04:29:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CMgX5oMxxxpJfDIIfr3hCoL4i8NLmLwWjDXA1GtboKk=;
        b=hk0tLTaruLS2yYz6mGW2htnOwsUJMzUqrOiydXURx+pRj6hzVwbEtrYMvx//4IKfp2
         W8KKlSX75/FLlCETr4R80ycWCWuzgDOM5EOwpGVo+gJ+ywq/wX5XOQarp9qxobF8aIPk
         28tQC2faOF9WachZ+enZwftyGaN7KA5ufdtOkBWzrhhFY8tAhCpY4UPdp/4A+UHoBrwv
         CHb1bhmNB2bApwovRZuSKOxmJnrD5ARJ2sGZWBouQTLDFXUnpEYwYKItQKEbpsZherBt
         Tle/2GoEsKOuRA+a06S3dcrvdFKidWsTwZnGkJsxz+uFhR86Hens3pIh4Mbpx70TyLX6
         FI0Q==
X-Gm-Message-State: AGi0PuYUavX7xORyjAjivuD3yB+EdZNlenwKKKUCYdxzvEjlJUTv7Z3r
        h9Ebwd2WxLACAuLWN/ubsXox8+qViQkB8yKdJrA=
X-Google-Smtp-Source: APiQypImRxqUBTjaUJGqN7kGau0r41uofK6tCeaMoXyqvTB7Txm3lJkXGOpCp4Jon4bK1XPd8wdKH60nR3YeFmhBaic=
X-Received: by 2002:aca:f07:: with SMTP id 7mr2326913oip.68.1585740584583;
 Wed, 01 Apr 2020 04:29:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585343507.git.gayatri.kammela@intel.com>
 <9359b8e261d69983b1eed2b8e53ef9eabfdfdd51.1585343507.git.gayatri.kammela@intel.com>
 <CAJZ5v0j8OaqM6k52Ar9sYn0Ea_u9+MBB0rcMWv6vGBt5jXCQBQ@mail.gmail.com>
 <20200330172439.GB1922688@smile.fi.intel.com> <BYAPR11MB362459660B914BEF1526AD8DF2CB0@BYAPR11MB3624.namprd11.prod.outlook.com>
 <CAJZ5v0inmWu6_ZYLCKart6F873SqK5AyvVXOCS83Yr=KQAQV_Q@mail.gmail.com>
In-Reply-To: <CAJZ5v0inmWu6_ZYLCKart6F873SqK5AyvVXOCS83Yr=KQAQV_Q@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 1 Apr 2020 13:29:33 +0200
Message-ID: <CAJZ5v0gYaZW8ycWQkcymz9W8svtNVnLGxsPZXEf4tP8Tpsmyew@mail.gmail.com>
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

On Tue, Mar 31, 2020 at 8:19 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Tue, Mar 31, 2020 at 1:22 AM Kammela, Gayatri
> <gayatri.kammela@intel.com> wrote:
> >
> > > -----Original Message-----
> > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Sent: Monday, March 30, 2020 10:25 AM
> > > To: Rafael J. Wysocki <rafael@kernel.org>
> > > Cc: Kammela, Gayatri <gayatri.kammela@intel.com>; Zhang, Rui
> > > <rui.zhang@intel.com>; Linux PM <linux-pm@vger.kernel.org>; Platform
> > > Driver <platform-driver-x86@vger.kernel.org>; Linux Kernel Mailing List
> > > <linux-kernel@vger.kernel.org>; Len Brown <lenb@kernel.org>; Darren Hart
> > > <dvhart@infradead.org>; Alex Hung <alex.hung@canonical.com>; Daniel
> > > Lezcano <daniel.lezcano@linaro.org>; Amit Kucheria
> > > <amit.kucheria@verdurent.com>; Westerberg, Mika
> > > <mika.westerberg@intel.com>; Peter Zijlstra <peterz@infradead.org>;
> > > Prestopine, Charles D <charles.d.prestopine@intel.com>; 5 . 6+
> > > <stable@vger.kernel.org>; Pandruvada, Srinivas
> > > <srinivas.pandruvada@intel.com>; Wysocki, Rafael J
> > > <rafael.j.wysocki@intel.com>
> > > Subject: Re: [PATCH v2 1/3] ACPI: fix: Update Tiger Lake ACPI device IDs
> > >
> > > On Mon, Mar 30, 2020 at 06:43:35PM +0200, Rafael J. Wysocki wrote:
> > > > On Fri, Mar 27, 2020 at 10:34 PM Gayatri Kammela
> > > > <gayatri.kammela@intel.com> wrote:
> > >
> > > > > -       {"INT1044"},
> > > > > -       {"INT1047"},
> > > > > +       {"INTC1040"},
> > > > > +       {"INTC1043"},
> > > > > +       {"INTC1044"},
> > > > > +       {"INTC1047"},
> > > > >         {"INT3400"},
> > > > >         {"INT3401", INT3401_DEVICE},
> > > > >         {"INT3402"},
> > > > > --
> > > >
> > > > I can take this along with the other two patches in the series if that
> > > > is fine by Andy and Rui.
> > >
> > > One nit is to fix the ordering to be alphanumeric or close enough (I admit in
> > > some cases it might require unneeded churn) to that.
> > Thanks Andy and Rafael! Should I send v3 for this series with right ordering this time?
>
> No need, I can fix up the ordering just fine.
>
> > > Otherwise,
> > > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>
> Thanks!

Now applied as 5.7 material with the changes mentioned above.

Please check the bleeding-edge branch in my tree.
