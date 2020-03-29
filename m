Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490F9196F47
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 20:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgC2S2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 14:28:23 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:35992 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728494AbgC2S2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 14:28:23 -0400
Received: by mail-lf1-f45.google.com with SMTP id u15so3060662lfi.3
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 11:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wGo+k0Ep3askjaXzN70y2u97DT8Cs5DglNrPIIVw/Yo=;
        b=fvWgbTE+VYDw0eFRzuwNME2UbJ3jnZ5L4a4OIEJHGBMq8zAhuU7s3WTvkKKkln4f7I
         ZsmZn/82GOycR8ulpTqR1JcE8kG0b0jWcxKkSUH31+P5xILRCWCH5mYD+zoiQpZEo9u4
         tbXMA7P8xelN2b7b1m7ap7dRCxij1Q0VQLGYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wGo+k0Ep3askjaXzN70y2u97DT8Cs5DglNrPIIVw/Yo=;
        b=WaK2O/zM4RASc4k50Ig2Vb3ZL/fYRBLBbJ4RFCK/81V9DyAZZBSboRZQCsvQCIvb1q
         UC1s3Y34AmWpHtX13A94ZdFYmX832YMcgIEorHwsANxyp/K+RXxum/WL4y36DWVaE/JA
         tkRCvGxpgOztNjIlO8l3+8N2VpjpiSdxeWXzsBwe2MQsAg5TUY1Jybg9bbM0z05k9hIv
         EKVspRRAycmVY26bbUwWquEdsqb7zu+zz5yfZu6g6vYKDMkZjyRLtPLgEr/KbcNqGL/j
         Po41AFvwwtSEuXYc+NUC5tDOo115W9k88U1mJ/cBjdbk9/wmAAPEniV5r2rX/bxVq5Sa
         Podg==
X-Gm-Message-State: AGi0PuZ1uhuF0Us/paU6Z1tClGgISqhZRIMEonsUY0YGEU/3+JLxKqi6
        2+NfVFRq9V85B7iDYxxGDEO5JljNDVo=
X-Google-Smtp-Source: APiQypL7K8A/UwavFlk9yNec0Fz5Z/XzPzh4xt06i55vUlH4hHkz1CS5oRhSJZ/U9YdgSN+2OCV3lg==
X-Received: by 2002:a19:844f:: with SMTP id g76mr5750989lfd.112.1585506499298;
        Sun, 29 Mar 2020 11:28:19 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id q30sm3448093lfn.18.2020.03.29.11.28.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 11:28:17 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id g27so15530279ljn.10
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 11:28:16 -0700 (PDT)
X-Received: by 2002:a2e:a58e:: with SMTP id m14mr4970045ljp.204.1585506496516;
 Sun, 29 Mar 2020 11:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200328191456.4fc0b9ca86780f26c122399e@linux-foundation.org>
 <20200329021719.MBKzW0xSl%akpm@linux-foundation.org> <CAHk-=wgs1mfvk8pwefSD2A4=RgH6td50x9D-yn3Axm7icp5Xag@mail.gmail.com>
 <b80d7cea-a8f7-11c9-66fa-bdc272bdf099@redhat.com>
In-Reply-To: <b80d7cea-a8f7-11c9-66fa-bdc272bdf099@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 29 Mar 2020 11:28:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg+UUK7hj9xKhoDfqXG4bCrOtTA-_WPoFemU_=1G_NHGQ@mail.gmail.com>
Message-ID: <CAHk-=wg+UUK7hj9xKhoDfqXG4bCrOtTA-_WPoFemU_=1G_NHGQ@mail.gmail.com>
Subject: Re: [patch 2/5] drivers/base/memory.c: indicate all memory blocks as removable
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Karel Zak <kzak@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        ndfont@gmail.com, pbadari@us.ibm.com,
        Rafael Wysocki <rafael@kernel.org>, rcj@linux.vnet.ibm.com,
        stable <stable@vger.kernel.org>, steve.scargall@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 29, 2020 at 11:04 AM David Hildenbrand <david@redhat.com> wrote:
>
>
> What I received via the mailing list (e.g., linux-mm@kvack.org)
>
> Message-Id: <20200128093542.6908-1-david@redhat.com>
> MIME-Version: 1.0
> X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
> X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
> Sender: owner-linux-mm@kvack.org
> Precedence: bulk
> X-Loop: owner-majordomo@kvack.org
> List-ID: <linux-mm.kvack.org>
> [...]
> X-Mimecast-Spam-Score: 1
> Content-Type: text/plain; charset=US-ASCII
> Content-Transfer-Encoding: quoted-printable
> X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
> [...]
>
> And a lot of this MIME crap.

Well, that may still be a perfectly fine email.

Yes, it has the MIME crap, but it also has that

  Content-Transfer-Encoding: quoted-printable

which should tell all users how to _handle_ that MIME crap.

It's sad that people in this day and age still don't just handle

  Content-Transfer-Encoding: 8bit

and just send it on untouched, but SMTP certainly encourages that bad
behavior of "convert to 7-bit MIME crap", because in theory there
could be SMTP servers out there that can't handle anything 8-bit or
with longer lines.

Those SMTP servers should just be scrapped and people told not to use
them, but sadly that's not the approach email people have taken.
They've taken the approach that old garbage SMTP servers should be
allowed to exist and destroy email for the rest of us.

> I have no idea if such a conversion is expected to be done.

It is (sadly) expected to be done by a lot of mail software.

But the problem is that some part of your email handling code then
doesn't _undo_ the MIME conversion, and leaves the MIME turds alone,
while then that "Content-Transfer-Encoding: quoted-printable" got
lost.

Do you at any point end up using a raw mbox and cut-and-pasting stuff?
Reading email in a broken mail-reader that doesn't undo MIME? Because
that's the usual way that these kinds of turds get copied.. Using raw
emails without honoring or taking that "Content-Transfer-Encoding"
into account.

                   Linus
