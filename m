Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA6C143128
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 18:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgATR4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 12:56:52 -0500
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:32888 "EHLO
        email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726642AbgATR4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 12:56:52 -0500
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2020 12:56:51 EST
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
        by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 481fLy4jmVzRhSx;
        Mon, 20 Jan 2020 18:49:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
        t=1579542586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C+Lhj8chUKLJVXXPOqbYYnVp0h/ptgB+BJqp+XECkAE=;
        b=gIdroEjiVVepp5Lvliu4o5lYB3LYwiB0nY7WVblk0QJVZYClZXUQQM5oXZM2Qb4lDhrSF6
        aM2iQN5L6lq9apLlY0J1YNcKGP6ocvkEcA+EI/+x0BKHLPGfswgYMzSjaPdcWtGEh3g1Q9
        zbKWheAn2LoZGwF44QATUXF9xSAN8vCIFPzU8myMPoEijlN0kOUNbCT7iuB8+0Fr/W47ok
        +hqPxcpLeUAayPxSLyswi0h1Wl9M3NLytkdHxDrtnNs8oSU0DPz92wp0RqBTTvQ0AsOq6v
        LKAw4zbDzZNi/mDEIQXQX8dL3hs3OfYxxFydYicYmlxp7zVk2wfPxx7sxsYWyA==
From:   Wolfgang Walter <linux@stwm.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: Linux 5.4.13
Date:   Mon, 20 Jan 2020 18:49:46 +0100
Message-ID: <2465902.uHH96e9i0Q@stwm.de>
User-Agent: KMail/4.14.3 (Linux/5.0.6-050006-generic; KDE/4.14.13; x86_64; ; )
In-Reply-To: <20200117231105.GA2130102@kroah.com>
References: <20200117231105.GA2130102@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de;
        s=stwm-20170627; t=1579542586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C+Lhj8chUKLJVXXPOqbYYnVp0h/ptgB+BJqp+XECkAE=;
        b=hTrB0haQL0u/hRjNJmn6jIRS5Mc7ZbsPjMrKPVSKKGs0cCMJPYtwnUBcT1ygZUtfclD6o0
        kpI++JzujS/ds+aLfEPihgRrUD2HwnX/CO8MyK5FCTwiggd/8wDJoMIjoGt/insa+2TlqE
        udP9tUO50oBs97trRBv3WowCfnEKDHDbC2GymX+aOCUp4N00CcdYRCx4Hhnvc8qqw/brX3
        17CmykVD/WpCftvwA/Z97r4xm1eTgnwqAH7HIIdHS40FjgasYCgP3z6doSSzgybzch3ZGn
        xIAi4zfdb6Zo49fUO2EVcVMmZXYUZsPqCFeGgv1EaaHNlMQvxT6IRwtBlv/Gsg==
ARC-Seal: i=1; s=stwm-20170627; d=stwm.de; t=1579542586; a=rsa-sha256;
        cv=none;
        b=aV/Tq0WDl9YOOPKU44rSyXjxC8zrydcaC3A+N/yFBNkrqXiUtz4Ichwrt1ZZ5drT5gy0mz
        +PtJIhBlJ7ZzTRbjHhbWjD1OPg5J1hGrDPF6DPCRT5/8BvsNGv8XU2uJ8hHuYSNv2OuKhK
        Ul2B+gRb7L33/b/5WIrOQ3ZIhs2OcfCNYZbZUvb/WHBxh9nfkyeDtwSWrRtm7ySPhch9c8
        oudcQWznXBZDRgljl0KXl8mNwdc5uoD9VFYYtpgHjNB3zzrlsLjQHkPmOF5Lx31HtA49DO
        Y+D3eHj7YkmuW4ZBLBwCm+afSfC2tkRp9yGl/VTUD3JywBY42Nadgpcf2c/HfQ==
ARC-Authentication-Results: i=1;
        email.studentenwerk.mhn.de;
        none
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Samstag, 18. Januar 2020, 00:11:05 schrieben Sie:
> I'm announcing the release of the 5.4.13 kernel.
>=20
> All users of the 5.4 kernel series must upgrade.
>=20
> The updated 5.4.y git tree can be found at:
> =09git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.=
git
> linux-5.4.y and can be browsed at the normal kernel.org git web brows=
er:
> =09https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.g=
it;a=3Dsummar
> y
>=20
> thanks,
>=20
> greg k-h
>=20

Compiling 5.4.13 I got (for one test configuration):

In file included from net/hsr/hsr_main.c:12:
net/hsr/hsr_main.h:194:20: error: two or more data types in declaration=
=20
specifiers
  194 | static inline void void hsr_debugfs_rename(struct net_device *d=
ev)
      |                    ^~~~
make[3]: *** [scripts/Makefile.build:266: net/hsr/hsr_main.o] Error 1
make[2]: *** [scripts/Makefile.build:509: net/hsr] Error 2
make[1]: *** [Makefile:1652: net] Error 2
make[1]: *** Waiting for unfinished jobs....

There seems to be already a patch:

=09https://lkml.org/lkml/2020/1/7/876

which is not in torvalds tree yet, though.

Just found it by accident, usually =09I do not use HSR.


Regards
--=20
Wolfgang Walter
Studentenwerk M=FCnchen
Anstalt des =F6ffentlichen Rechts
