Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDE01AE909
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 02:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgDRA4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 20:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgDRA4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 20:56:01 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9AFC061A0F
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 17:56:01 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id e25so3904550ljg.5
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 17:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qs6wrAd2usiw5E/NvfsaWD9NmqabIB9KmK4sn2np7kI=;
        b=U4x5PtWjYno+y9kpXnPl1TultiRn27j4BA37HWNBlr8kBkFNbIKmdMCjn5+3qALEe6
         dRH3LlE3dIu3QUb/4qxHvQ9l4xMOL9Mb/kG0fdw89qIxkUEdLh7LgPPZdg/O0R+zWCWz
         DW9rBf94bWBr7s2zss5IpNuRxdZPbLRIPLmgI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qs6wrAd2usiw5E/NvfsaWD9NmqabIB9KmK4sn2np7kI=;
        b=RTXSMqlyD537A9trEYNHGoKl4+aDFFZpPfStnJL3XcFKHeOHwDIgX7B9Xbol/Bv6x3
         YVepKratKW5M5fOjlmyauHdwOUDIFCBcxtx4uGJ0cOk4+MUxyZRVKCNH2X3wtdu9q2U3
         CK3Kw+ESqVACZvDzBumM4+/IiJOalTH22ETC4esr0jdHr4gacIuuw4yMEdfPdokdWS8w
         3+sfKsckFFyxVW5qS0gu+osPjPFnREwm69wRarwENrOFr+jVuE6X8u61FPXLeelVeBNw
         6IvtOAQi/Lycr6YprWkgiikueYk2MWUAEt8VTgdmwiH0Dxww9ocVMLUqHll2b2XkOH3j
         ewIA==
X-Gm-Message-State: AGi0PubZzFcqlR1fjPrCbK0u3Iw5BVIeoyvJfSl5aLl02i2RBBVxMFcU
        M0zbC2d9p2BKyhjF/DuAYT1+y7XUAlc=
X-Google-Smtp-Source: APiQypJar6zoW/iRbr9Awszc7rhhKY7FzkL+kgm76yDAwj5XUnS2/GEjaoOkiYyAxkA2X1ro/9d5Vw==
X-Received: by 2002:a2e:a584:: with SMTP id m4mr3640164ljp.194.1587171359625;
        Fri, 17 Apr 2020 17:55:59 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id i18sm13715441lfo.57.2020.04.17.17.55.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 17:55:57 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id k28so3264607lfe.10
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 17:55:56 -0700 (PDT)
X-Received: by 2002:ac2:4859:: with SMTP id 25mr3711879lfy.59.1587171355790;
 Fri, 17 Apr 2020 17:55:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200205194804.1647-1-mst@semihalf.com> <20200206083149.GK2667@lahna.fi.intel.com>
 <CAMiGqYi2rVAc=hepkY-4S1U_3dJdbR4pOoB0f8tbBL4pzWLdxA@mail.gmail.com>
 <20200207075654.GB2667@lahna.fi.intel.com> <CAMiGqYjmd2edUezEXsX4JBSyOozzks1Pu8miPEviGsx=x59nZQ@mail.gmail.com>
 <20200210101414.GN2667@lahna.fi.intel.com> <CAMiGqYiYp=aSgW-4ro5ceUEaB7g0XhepFg+HZgfPvtvQL9Z1jA@mail.gmail.com>
 <20200310144913.GY2540@lahna.fi.intel.com> <20200417020641.GA145784@google.com>
 <20200417090500.GM2586@lahna.fi.intel.com>
In-Reply-To: <20200417090500.GM2586@lahna.fi.intel.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 17 Apr 2020 17:55:44 -0700
X-Gmail-Original-Message-ID: <CA+ASDXM9mrkGfxtVVNWkqnDNzcok2LAqdfVbQL2RV7yWE0tMWw@mail.gmail.com>
Message-ID: <CA+ASDXM9mrkGfxtVVNWkqnDNzcok2LAqdfVbQL2RV7yWE0tMWw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: cherryview: Add quirk with custom translation of
 ACPI GPIO numbers
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-gpio@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        stanekm@google.com, stable <stable@vger.kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, levinale@chromium.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        bgolaszewski@baylibre.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

- Michal (bouncing)

On Fri, Apr 17, 2020 at 2:05 AM Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> I wonder if we can add back the previous GPIO base like this?

Thanks for the patch! At first glance, it looks like the right kind of
thing. Unfortunately, it doesn't appear to work quite right for me.
I'm out of time for today to look any further, but I (or perhaps
someone else on this email) will try to follow up next week sometime.

Cheers,
Brian
