Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7611A7FEFE
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 18:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391479AbfHBQ4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 12:56:06 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38634 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728856AbfHBQ4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 12:56:06 -0400
Received: by mail-lj1-f195.google.com with SMTP id r9so73489953ljg.5;
        Fri, 02 Aug 2019 09:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EPPkokBEv9j1HeWKFcgfAyMgJ7iKf2u5vn4lVvJ2P+Q=;
        b=Y/VQhvis6mV3rjwPKYuIWxYDYjDY9kb08o070K3IsGqAvM1Bb9ic+urEy0UKFxWGY7
         mFGaHcNLmSePeZ4ykoXD8DzYw54n+iLBafp2/pG0WWh2clrA7yCS141OM/8SeyzHIuXz
         Hx/FlalXnlwtbQCOaQIoY/o6MsARz4eECua+ycRPDmGONAiWsKw+uHtJ4M56jWq5wMY2
         RHiq5VNAwoGsKzZJ9Z1OZenw8g2Z2Uk/dHHTnY5vOiwqvB4tIFtLO8pH9MSSBOD61479
         MI4ngeiPKMVxhsZ6doTL/yiAJv1gahNDRwmwCU7wUUrvgTMGVelWl5qaOxlcHAJ88bIC
         0lAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EPPkokBEv9j1HeWKFcgfAyMgJ7iKf2u5vn4lVvJ2P+Q=;
        b=RQgWgmaLD3YN4yZhQf+lbWdZa9cuiCeu5vFyIn96sfpYUZ76S3Mo4vFoM7WSDZ4Ooy
         RWZrlD9k440KJx9yQvBw2ojLZaowcXxhfnsKJKjVDZ0eBdZ2xX4xz2iRh13YvRfqI1n8
         YD6Zce7MkiMsi4AQbYdRtnn0sE0SesWpsBfq39YWHAn78fw95mVhZuuEy0hJ134HCEjQ
         tDiARGk+GBzZVm5QfB//xAElfQzVOoE6lA1MHa5/BSnoVFh82btWCqxPqKSumTn8C2z0
         aSO7gI3U8iIB7qbeAzSdJccBNcIEv0R+Bi1BBBdQ8G0hrGjswLRIjOUrlv2TISUyuNhx
         XeUA==
X-Gm-Message-State: APjAAAXrY6viCnKIiX6EVesr9gbWWijiGM7cF2SO+DPEUAlVcpjSUEzz
        XpzVZPURYCurCcyLL9leHfEbOi31GrMT5pAPLDxDlV4S
X-Google-Smtp-Source: APXvYqw21KblkDjD8XIECXSFvc0LkhF9tGP/yaN81tFSY2dPWbejuy9VqzWKs0pdNdbYJwlV6sPNgEWGghtdMq3JfqE=
X-Received: by 2002:a2e:9198:: with SMTP id f24mr73227810ljg.221.1564764964729;
 Fri, 02 Aug 2019 09:56:04 -0700 (PDT)
MIME-Version: 1.0
References: <259986242.BvXPX32bHu@devpool35> <20190606185900.GA19937@kroah.com>
 <CANiq72n2E4Ue0MU5mWitSbsscizPQKML0QQx_DBwJVni+eWMHQ@mail.gmail.com>
 <4007272.nJfEYfeqza@devpool35> <CANiq72=T8nH3HHkYvWF+vPMscgwXki1Ugiq6C9PhVHJUHAwDYw@mail.gmail.com>
 <20190802103346.GA14255@kroah.com> <CANiq72kcZZwp2MRVF5Ls+drXCzVbCfZ7wZ8Y+rU93oGohVAGsQ@mail.gmail.com>
 <20190802112542.GA29534@kroah.com> <CANiq72mSLmP-EaOgY0m2qgTMVsAnyE6iuW5Kjdw5mSy1ZH0y-A@mail.gmail.com>
 <20190802155627.GB28398@kroah.com>
In-Reply-To: <20190802155627.GB28398@kroah.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 2 Aug 2019 18:55:53 +0200
Message-ID: <CANiq72k-2Gtb8Q_f2Nhy6aud-QwuSiJ8oEJbwt-pjd+bs8qDVg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Linux_4=2E9=2E180_build_fails_with_gcc_9_and_=27cleanu?=
        =?UTF-8?Q?p=5Fmodule=27_specifies_less_restrictive_attribute_than_its_targ?=
        =?UTF-8?Q?et_=E2=80=A6?=
To:     Greg KH <greg@kroah.com>
Cc:     Rolf Eike Beer <eb@emlix.com>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 2, 2019 at 5:56 PM Greg KH <greg@kroah.com> wrote:
>
> I see a ton of warnings on those kernels today.  I'll look into it next
> week after I apply your patches to see what's missing.

Yeah, the objtool ones -- I thought you were referring to the
-Wmissing-attributes that Rolf asked about (I am not sure why Rolf has
those as -Werror rather than warnings, though).

I can take a look at the objtool ones and see if applying some of the
patches helps, although I have never looked into how objtool works, so
no promises :)

Cheers,
Miguel
