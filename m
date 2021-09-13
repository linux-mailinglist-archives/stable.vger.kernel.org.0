Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A11C409E9A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 22:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243696AbhIMUzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 16:55:16 -0400
Received: from mout.gmx.net ([212.227.15.18]:55017 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244584AbhIMUzN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 16:55:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631566431;
        bh=8LyRUmRax3hCQti0YfuqbJX2nczTd/Squcie9S85a+8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=g7nFy/z0PY4tvbyJWJLup+J0g1wGQ8/DMV5IbHxxDkgGzguTsNoUbl+UbsY4zdqGl
         6rtV3oO2qWPQ7CzTj/g7KwjrFsw1Jjjs8mkV9hTy1K8vdDAGeAp3qNRMbtkXGIpz1Z
         wRKg6q8i33JE5mOKh/tZaKkbT3dT71P0mh7fF/d0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [46.223.119.124] ([46.223.119.124]) by web-mail.gmx.net
 (3c-app-gmx-bs69.server.lan [172.19.170.214]) (via HTTP); Mon, 13 Sep 2021
 22:53:50 +0200
MIME-Version: 1.0
Message-ID: <trinity-27f56ffd-504a-4c34-9cda-0953ccc459a3-1631566430623@3c-app-gmx-bs69>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, p.rosenberger@kunbus.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Aw: Re: [PATCH] tpm: fix potential NULL pointer access in
 tpm_del_char_device()
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 13 Sep 2021 22:53:50 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <204a438b6db54060d03689389d6663b0d4ca815d.camel@kernel.org>
References: <20210910180451.19314-1-LinoSanfilippo@gmx.de>
 <204a438b6db54060d03689389d6663b0d4ca815d.camel@kernel.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:mRkR/BryvYpdOREPVnSkv4q0GMCGed0FmfaW+Ko5NshPxZKEfu7va6u5xiYPB+DIck60l
 aOczt6/VhN5Jfg+sGpER8I+Hfqz+XmNyIa5AY8MSk1UfOo8UPaM6k6a/BS9HliCW0rmRWGE40Gv4
 BkKGFAdup4fQyXsMaGZRGWIQv5zlc3OidRSIREpuCmjPZYXUR/6BBwb+2UU2zwGN7W4nvbK5/YYJ
 4qQyjuEetyu9FChhkyF5TlZKansz2utakOO8YjkbrHhS3y9mN1vzuZ6lsOBogWaMMvY+ywsvkFc+
 O0=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:uYuHfN1JriI=:DtBZSOURbchsaDSgWzW7Ft
 ZZm2cxBJMVEcr3QvMPfDI4v/RcUvDnLYOfBN7a51Bcoc0HgJNHTZlf8KVYoPcn/hFFDCqmfBP
 I3Lpd0YPn20QvyhQdJ79OqozjJspVp0oEbWYKJHGgp8NurvSn4sJqdTl6clcrsRbigpOBJtP3
 j0ForO/Y5/hQRiz24DNFT5x/0mHuAdPfBwx2l0pki92pf4FNfTxA7LoUxgwBXQNaqWt55tUg0
 RHk1w+03EVofwjKTD/xaZMVYsz91RmCfvsZnn3gNVV1gG5fG7eZcwX6Mg2/xHFUiR4CdPrAnh
 3r0eHecwbsowgUxVbX99fx40t2+cNkxPLpcLvA6bs/F0PQVcoXnK+9J2UloCS3VoBz770RXjb
 SMgghoWUcIyNT2QgKjcffVr0IGBDDFURdtkWq2A/qVL3PzkOw4FUu3dad+/pvrYBlPMknP39Q
 zt0trDwTJ2YltPwVUEIuMBYcS1KRHNDrPtYNYnAo2Kg4PL0A0OLlhvaTnL4bfsS7JYleLBkDj
 Fg0DBU+zNjUtdi6uNh6qqAx28xNvy8EB5nIykIAEzZK3zsu0TI9PFfDPsW2eD1JnrnS2nCC29
 j8LdpEtvQ1LHCi+JXH/xYtbNg9zuRMpO2R8i+9g6TRrOOZi9PsDDsaFwVZyJWCdRixhB6FYrX
 wkPS0/xq7ipPgWfP8VdYNaJhtnr5iC/UGH+Krt3eUBtaFdHl1IjdR48xx0ceoCJsmtYcsHhi1
 9ZXGbvq2bcz3mk7Miom/eOT7nGWgMKf9OKD5gcsASiMlT5QwHEcA/eWduF6X6PZJBxYowvPKl
 yYPKKiv
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

> Gesendet: Montag, 13. September 2021 um 22:25 Uhr
> Von: "Jarkko Sakkinen" <jarkko@kernel.org>
> An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de, jgg@zi=
epe.ca
> Cc: p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org, linux-ker=
nel@vger.kernel.org, stable@vger.kernel.org
> Betreff: Re: [PATCH] tpm: fix potential NULL pointer access in tpm_del_c=
har_device()
>
> On Fri, 2021-09-10 at 20:04 +0200, Lino Sanfilippo wrote:
> > In tpm_del_char_device() make sure that chip->ops is still valid.
> > This check is needed since in case of a system shutdown
> > tpm_class_shutdown() has already been called and set chip->ops to NULL=
.
> > This leads to a NULL pointer access as soon as tpm_del_char_device()
> > tries to access chip->ops in case of TPM 2.
> >
> > Fixes: dcbeab1946454 ("tpm: fix crash in tpm_tis deinitialization")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> > ---
>
> Have you been able to reproduce this in some environment?
>
> /Jarkko
>
>

Yes, this bug is reproducable on my system that is running a 5.10 raspberr=
y kernel.
I use a SLB 9670 which is connected via SPI.

Regards,
Lino
