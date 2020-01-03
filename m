Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E79A12FA0F
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 16:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgACP4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 10:56:51 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:52479 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbgACP4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 10:56:51 -0500
Received: from mail-qv1-f45.google.com ([209.85.219.45]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MC3L9-1isbSW2jtt-00CVW5; Fri, 03 Jan 2020 16:56:49 +0100
Received: by mail-qv1-f45.google.com with SMTP id y8so16385056qvk.6;
        Fri, 03 Jan 2020 07:56:49 -0800 (PST)
X-Gm-Message-State: APjAAAXpWAAcWsL0c11bt7l/seQLaP6iUtt3BJBKllxxroWXw8vFI1FI
        MXwtILgMrPa9gpor774GFPVcADV2rIwAd6R5hCM=
X-Google-Smtp-Source: APXvYqwAZtlDU9yS/thCGFJhNrhvQGPNxuoWiizEZDxJ5nrJCe1L3kDS/UikuNsEdYJa8Y3FeqWFHQmLu8XM2ZS7NUQ=
X-Received: by 2002:a0c:e7c7:: with SMTP id c7mr68933990qvo.222.1578067008436;
 Fri, 03 Jan 2020 07:56:48 -0800 (PST)
MIME-Version: 1.0
References: <20200102215829.911231638@linuxfoundation.org> <CA+G9fYuPkOGKbeQ0FKKx4H0Bs-nRHALsFtwyRw0Rt5DoOCvRHg@mail.gmail.com>
 <CAK8P3a1+Srey_7cUd0xfaO8HdMv5tkUcs6DeDXzcUKkUD-DnGQ@mail.gmail.com>
 <CAK8P3a24EkUXTu-K2c-5B3w-LZwY7zNcX0dZixb3gd59vRw_Kw@mail.gmail.com> <20200103154518.GB1064304@kroah.com>
In-Reply-To: <20200103154518.GB1064304@kroah.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 3 Jan 2020 16:56:32 +0100
X-Gmail-Original-Message-ID: <CAK8P3a00SpVfSE5oL8_F_8jHdg_8A5fyEKH_DWNyPToxack=zA@mail.gmail.com>
Message-ID: <CAK8P3a00SpVfSE5oL8_F_8jHdg_8A5fyEKH_DWNyPToxack=zA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, LTP List <ltp@lists.linux.it>,
        Jan Stancek <jstancek@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:4fMLrImlcdsyOYIxBRFPO2dG0gOCSP3VpN+YNO478EJfix+DVzo
 jL7J692OmqUzwCCaueFEkzm6A0x+awbG6L3JulFk1emi2R5M/rKOMn40wsbZ8EgpXC2PQQ9
 gT1rlP09DGAp2X4gtusFT/6ZBOudRKGGkpwaXVVLSYVOzNpGIp4GJi4DRgorWMdDWkW8NI9
 ASnbqgLhV9hz5N12Y1Rhg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:62Aiqo52ap0=:tLFUxBUYtAlTl7pbpokuIX
 2eMQ+rf4ItCgtV8LuCDSHX4zEgaRvWZl4SOn51tO7lyUPsk1/eX4t8xt4zmuSLAQ7CYG1x+T9
 WP7W5mTkU5Bao8wn1f9/OfqKyjrlUNp8CFoXFnHTdvpSPyUkQSM8C5dW636GEuQcH9cUWcp0N
 feXWN4YjX4ocz5LKBY5S8daPsLjlWk/tto2id1a1tIoJNhsUTtrH57vI8D2x61cdiFEXszA1S
 GAmenkjP+H1IQdfGpYfZ2KIwVKQE+s3VI12AmjUIt2PhgFA1HOL5Bys6qFAmYj7Kzln1Ac6wz
 pIlNZWuIMKywCNtG++9RlWlXNASMaZUlLTdItXwJwcUq0Nf7ut6OlbICv8+oivXcFOijNF4sP
 FjMSts+ek1TXqJN6kdjV8W5Vr3Igc/6eNa5+CswTrAxsu4obWE0FgXiuU1LNnPwGvVTE7CabS
 j0cUko7yyq7QddXWcTaObwWKOlFcMd8nUt3KjoNIpfX0Vy9yinlWa0aolQtNERSnX4X3xHS2w
 YkeYgK0+TGLX13aa1Qu7WKzFooLm7DQIjsiPnMp8VE7hs7CbODkNVNoB4uwu84S0Og0yQ6XaD
 jwnCRhUJxT95xwirdkJmSfKhbwWfXFqvRKp8GBsfjOtmpmBMmSepqmiycw9NasvyAnTvXk4SF
 dW8z2HEoa2nkO9VkasgSmqFjYjK2VPeEWWc5CpC9CyB98X4jTF46tlV3Ej7G+oeKv3LTu8YHW
 XTr1Fwby7ugZ9Qk4I+pk6yfln1L9/IAB9MCGLomNGzdGsMyVN/u9WOUveac8GHTIcsX5sPxMp
 lkT77snXX59v3oHMBQGRYibXL/0zESofyk9WcqY0NdGtBplv9B4j2cmi73okB1gdFpawNbHdS
 8T8DhNTl+8ui6qfIg8iA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 3, 2020 at 4:45 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Jan 03, 2020 at 04:29:56PM +0100, Arnd Bergmann wrote:
> > On Fri, Jan 3, 2020 at 4:25 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > On Fri, Jan 3, 2020 at 4:03 PM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > > >
> > > > On Fri, 3 Jan 2020 at 03:42, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > >
> > > -ENOENT is what you get when hugetlbfs is not mounted, so this hints to
> > >
> > > 8fc312b32b2  mm/hugetlbfs: fix error handling when setting up mounts
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.4.y&id=3f549fb42a39bea3b29c0fc12afee53c4a01bec9
> >
> > I see that Mike Kravetz suggested not putting this patch into stable in
> >
> > https://lore.kernel.org/lkml/befca227-cb8a-8f47-617d-e3bf9972bfec@oracle.com/
> >
> > but it was picked through the autosel mechanism later.
>
> So does that mean that Linus's tree shows this LTP failure as well?

Yes, according to
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/ltp-syscalls-tests/memfd_create04
mainline has the same testcase failure, it started happening between
v5.4-10135-gc3bfc5dd73c6 and v5.4-10271-g596cf45cbf6e, when the patch
was originally merged into 5.5-rc1.

> This does seem to fix a real issue, as shown by the LTP test noticing
> it, so should the error code value be fixed in Linus's tree?

No idea what to conclude from the testcase failure, let's see if Mike has
any suggestions.

      Arnd
