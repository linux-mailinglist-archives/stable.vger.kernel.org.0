Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F3C1A1819
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 00:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgDGW0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 18:26:23 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52881 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgDGW0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 18:26:23 -0400
Received: by mail-pj1-f67.google.com with SMTP id ng8so343817pjb.2;
        Tue, 07 Apr 2020 15:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J6jgVx8UtXSs7xAZNp6Vy45fSSdaEZe2Op7yX79fp4w=;
        b=d84g2sKJMrprsqxkvvIuJG8rbJIoDYuW/BNFQYNVKBVPXf4ayO2obrPrb0aiX6mfsb
         MKoWK7u0huz909TUbzd+yL7a60Mc8a1JH7hpl4F46tFDGXyhMJuEKedca/fYZEyXzwEt
         v8k6nLXDgOWTeaKXZDaNEDfgqLBk1z+Tm/Ag+tQOBydHwwPUzbaKJpplbRwYp3dOlEn7
         KlPDdfVV2bOq/xm2RtaP5zXwjK+YfMVWbmrauRTaFUM9iBXir1G9vWmnLSyNmr7gvKRT
         wiyjio7udk6HualqXKfbOiSp47R5TpfTr349VUJqD2rOO4nn60GzxuaBu6kED25IbA+6
         9FaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J6jgVx8UtXSs7xAZNp6Vy45fSSdaEZe2Op7yX79fp4w=;
        b=p8kEjmeIzeZePIh2nsAPIc8+gm8FrjtijGiJF1Dhb8BueV3XGxd62icW21x5K6dea0
         nZS0+BP0ut50kCBRiWLTHZDU6caIT9YbItJwOXx2pbR5aj5rUugupmAytG3lgBYURyV5
         b27XNDo+Wiy84+/6+cXE1FnpoSzgESHzNeC5TyOx3w2YupMWfAb56A9QTXAmc0ALFoNk
         PUt38E6mhV5t8RrhQwi/C6OpYkozAfzX9XtsLvldXRKb+EPUhNfRTglUsw21CvG+DPcp
         OedKwfsB2yS006UF+EItB0ZPPGz6pYlXSV3aWUyttTuqm5zu6lY7/xm8UZ95wT8vOg+c
         OQ2A==
X-Gm-Message-State: AGi0PuYuKwVBCD4ou+DHRhYS61nVhHEeyqQEpnuD9bLHtTiNYTe0wLBC
        AGiCs66QaKGGpAuWppZ1YCQDXJF6wS1NBYDC82E=
X-Google-Smtp-Source: APiQypJnIbbumJ1u0PQMBkzvJmO8JkWoo+AhO9EJIN5DI/VbIQI+3MONMOfFLJPMeR+aEfQalJ/TY/j8kSLR+LAcgNc=
X-Received: by 2002:a17:90a:8546:: with SMTP id a6mr1739682pjw.8.1586298382222;
 Tue, 07 Apr 2020 15:26:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200407213058.62870-1-hdegoede@redhat.com> <cfd3171a-94fb-7382-28e1-a236cb6759cc@redhat.com>
In-Reply-To: <cfd3171a-94fb-7382-28e1-a236cb6759cc@redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 8 Apr 2020 01:26:10 +0300
Message-ID: <CAHp75VdqQnHbMSSeoDESMgywH-1VxBTT=Uo_GLV1aycmg=MXtA@mail.gmail.com>
Subject: Re: [PATCH] platform/x86: intel_int0002_vgpio: Only bind to the
 INT0002 dev when using s2idle
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        "5 . 3+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 8, 2020 at 1:24 AM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi all,
>
> I just realized that I should have added a cover letter to this
> patch to discuss how to merge it.
>
> Rafael has already queued up the
> "[PATCH v3 2/2] platform/x86: intel_int0002_vgpio: Use acpi_register_wakeup_handler()"
> in his tree. Looking at both patches the parts of the file the
> touch are different enough that that should not be a problem though.
>
> So I guess this can go through platform/x86 as usual, or
> (assuming everyone is ok with the change itself) alternatively
> Rafael can take it to make sure there will be no conflicts?

You will need different patches for v5.7 and the rest.
In v5.7 new CPU macros are in use.

-- 
With Best Regards,
Andy Shevchenko
