Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE743196FC6
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 21:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgC2Tz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 15:55:28 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34308 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbgC2Tz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 15:55:28 -0400
Received: by mail-lj1-f194.google.com with SMTP id p10so15543115ljn.1
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 12:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xrEIG2YvwPNlIc5vvI62R25VB+sWUFk6xaT0eN/F8CI=;
        b=Pi2Ae1/CMhSjzk5l8Fk+B6GUdryJTfSayzbFdhp6BVNsADL96W7Rjm6yz7wTMkm0mj
         aTK/rmFQRt2hjoBDeMMdy4HcC+zG11XcuPidCN+6LSIeqfknhQruw8xEYl2AoN6CkW4P
         tmWQpy4zYlf4L101Ml81f5gcRVV4LSPgsx/Eg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xrEIG2YvwPNlIc5vvI62R25VB+sWUFk6xaT0eN/F8CI=;
        b=bMfsjhhdo3AQI++dCh5cGhx7xUUo0ENUcWb4idHH9ZmYwbV0H1mJqcqjSlvRP5VZtJ
         713bi6CGXyCux9wX7gQ6W8k2wOXwd2NZnzQE4e4HxHWW/yUtl5geQVwT0R7GLUyL0Bhm
         MQdICbAamPLKvljavDEJXp+d1D4UPv0xRTW+NHrptFKVmbWjP7Xj7Q9miBVRGbZD7Fm4
         WAl2mYYZmRiUQCrwUKYuO5KMndkuhsSgLmuLmASRQhrrBJWbC/GK0XwgxPTl5TneJ8Zs
         sVaDqoIzDU6lZNwqORAAe0nfIwDEu/W/TMkw6Lsh2KOk7EOgqZ1hNtCjlvGrBUqTt+Rr
         tqXg==
X-Gm-Message-State: AGi0PuYS3yYAwmPnksfxKQHGCIs0c95HPbngrDaj0dRRfhVGo9Dv1Dr4
        koHjOE1BxI8FnCc5EXPuh6wjYWVThoc=
X-Google-Smtp-Source: APiQypIAJe8SOlVYchCACazC+RZb4w6vPrsewnwRBC9c6aCsb0howqIb+qaThlg/CZ1aW9pDhfSGHw==
X-Received: by 2002:a2e:7606:: with SMTP id r6mr5144775ljc.118.1585511726268;
        Sun, 29 Mar 2020 12:55:26 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id d6sm7693962lfn.72.2020.03.29.12.55.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 12:55:26 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id n17so15766672lji.8
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 12:55:25 -0700 (PDT)
X-Received: by 2002:a2e:7c1a:: with SMTP id x26mr4950926ljc.209.1585511725246;
 Sun, 29 Mar 2020 12:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200328191456.4fc0b9ca86780f26c122399e@linux-foundation.org>
 <20200329021719.MBKzW0xSl%akpm@linux-foundation.org> <CAHk-=wgs1mfvk8pwefSD2A4=RgH6td50x9D-yn3Axm7icp5Xag@mail.gmail.com>
 <b80d7cea-a8f7-11c9-66fa-bdc272bdf099@redhat.com> <20200329194354.xrbzlvlbjimy3pzz@chatter.i7.local>
In-Reply-To: <20200329194354.xrbzlvlbjimy3pzz@chatter.i7.local>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 29 Mar 2020 12:55:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wheAem=MzY=F0ox7tuxFR47SgUj7zB+2S_KOhEB49zsPA@mail.gmail.com>
Message-ID: <CAHk-=wheAem=MzY=F0ox7tuxFR47SgUj7zB+2S_KOhEB49zsPA@mail.gmail.com>
Subject: Re: [patch 2/5] drivers/base/memory.c: indicate all memory blocks as removable
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 29, 2020 at 12:43 PM Konstantin Ryabitsev
<konstantin@linuxfoundation.org> wrote:
>
> It would appear that the workflow Andrew uses to queue up patches from
> you isn't expecting quoted-printable formatting, which is why when Linus
> gets them, they are mangled.

I don't think that's the case.

Why? Because I see _proper_ handling of MIME and quoted-printable from
Andrew all the time.

For example, anything from J=C3=A9r=C3=B4me Glisse always ends up having be=
en
quoted-printable, simply because of how J=C3=A9r=C3=B4me's emails look, and
because he has 8-bit characters in his name.

There are other examples of the same thing - a lot of the emails I get
from Andrew do end up having quoted-printable encoding.

It's only David's patches that then end up having lost the encoding
marker, but have QP sequences in the commit message.

The odd thing is that the *patches* are fine, even if they have equals
signs etc that would have been QP-encoded too. So it's literally just
the commit message that tends to be corrupt.

Which is why I was suspecting people cut-and-pasting the raw emails
for examplanations or something similar.

                Linus
