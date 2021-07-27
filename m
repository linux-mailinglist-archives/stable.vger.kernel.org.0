Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BD03D7F29
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 22:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhG0UXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 16:23:15 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:60646 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhG0UXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 16:23:15 -0400
Date:   Tue, 27 Jul 2021 20:23:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tmb.nu;
        s=protonmail; t=1627417390;
        bh=ecY+hRpUReHA1pV0A42B0RF0S3Mkstot9TO5YNR2+NI=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=MBIbsH0WeA5WTICTRuUVXoZxwWuZg6iZF1e+skw5oX6vhMak3z2ZMCtOYeaweUpeC
         WZOAz8dZyCUktTcKZ0RGMWNvZWPmBEvqZNUGttWs8uKOE2q/cFmcdpGnfGGj4fHLnK
         n1Q2DOfgXj6+B6ixbwVvooJOVFRaTv/ZJ06Q1b1c=
To:     Ben Greear <greearb@candelatech.com>, pgndev <pgnet.dev@gmail.com>
From:   Thomas Backlund <tmb@tmb.nu>
Cc:     stable@vger.kernel.org
Reply-To: Thomas Backlund <tmb@tmb.nu>
Subject: Re: very long boot times in 5.13 stable.
Message-ID: <3d8ebf91-74ac-d1d3-80a7-df5da3fe7d78@tmb.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 2021-07-27 kl. 20:06, skrev Ben Greear:
> On 7/27/21 9:50 AM, pgndev wrote:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 embedded. checking...
>>
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iiuc, it's got an i2c.=C2=
=A0 possible a uart is on Irq4 thru the i2c?
>>
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if so, might wanna take a loo=
k here:
>>
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 https://bugzilla.kernel.org/s=
how_bug.cgi?id=3D213031
>>
>> <https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__bugzilla.kernel.=
org_show-5Fbug.cgi-3Fid-3D213031&d=3DDwMFaQ&c=3DeuGZstcaTDllvimEN8b7jXrwqOf=
-v5A_CdpgnVfiiMM&r=3DHYKqseB9xg-u2kz3egvegqfgyXnEBhQotXfR3iCfdgM&m=3DgCRilk=
IAaKYuJwLWOT7O5ttfWG5rta0-6eYjPBdnTz4&s=3DVSfJDrJPSqVtQuCoCZGazYrmnWTe6xldT=
kWT_Bq7vwo&e=3D>
>>
>>
>>
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 maybe related?=C2=A0 at least=
 shares symptoms...
>>
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ACPI subsystem lead sez in of=
flist thread re: that
>>
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "It looks like commit 96b15a0=
b45182f1c3da5a861196da27000da2e3c
>> needs to
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 be reverted."
>
> I don't see that commit in linus tree nor my stable tree, can you check
> that hash and also
> show me the commit message and other info so I can track it down?
>

AFAIK, that commit is supposed to reference
0ec4e55e9f571f08970ed115ec0addc691eda613 in linus tree, landed in 5.13.2
'
and a matching thread:
"boot of J1900 (quad-core Celeron) mobo: kernel <=3D 5.12.15, OK; kernel
 >=3D 5.12.17, 5.13.4, slow boot (>> 660 secs) + hang/FAIL"

on stable@ ml.

--
Thomas

