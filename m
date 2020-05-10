Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB0B1CCC12
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 17:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgEJP5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 11:57:09 -0400
Received: from mail.rosalinux.ru ([195.19.76.54]:51496 "EHLO mail.rosalinux.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbgEJP5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 May 2020 11:57:09 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 May 2020 11:57:07 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.rosalinux.ru (Postfix) with ESMTP id 91E34DA459911;
        Sun, 10 May 2020 18:51:31 +0300 (MSK)
Received: from mail.rosalinux.ru ([127.0.0.1])
        by localhost (mail.rosalinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id IfKzOEszkeBJ; Sun, 10 May 2020 18:51:16 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.rosalinux.ru (Postfix) with ESMTP id 1E1CEDA459912;
        Sun, 10 May 2020 18:51:16 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rosalinux.ru 1E1CEDA459912
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosalinux.ru;
        s=A1AAD92A-9767-11E6-A27F-AC75C9F78EF4; t=1589125876;
        bh=zU5crUFJSjX+syB2bujcN29Vsq7Lak+v+Tf3s9uVNFA=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=UA4KFUnvEnM8Or9CumwKh7O18X12QpgjHQZbe90wkg4cqYreq9zzQ7HGDoLlp0vNo
         DV4Ab805L9qYcIsXK9BjiOIL+rfiqVPTNv58JyHUIb3lTlglPupeuouU5tN1U929n0
         2R7T16XVUB0sjEG53v00dqpeJuclXe4wI3ra6oknFmI6h0uQ8BAA1j53hl9EiLJEVa
         gkd2idRDzs25/U5RPozq1Dy4p/udo/EooYjBcvccOAUymkm9IKVphO/RKQjUrQFNmA
         z+wbo95TEfBQ26b561/GcR9HAmzxyYfREU9HZ1fBAT7QsCaj2IANhdkiPK1KhgZFh4
         qjy12R4Spm7QA==
X-Virus-Scanned: amavisd-new at rosalinux.ru
Received: from mail.rosalinux.ru ([127.0.0.1])
        by localhost (mail.rosalinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MU_LT7tWbDwP; Sun, 10 May 2020 18:51:16 +0300 (MSK)
Received: from [192.168.1.173] (broadband-90-154-70-119.ip.moscow.rt.ru [90.154.70.119])
        by mail.rosalinux.ru (Postfix) with ESMTPSA id DED2FDA459910;
        Sun, 10 May 2020 18:51:15 +0300 (MSK)
Subject: Re: sign-file: full functionality with modern LibreSSL
To:     keyrings@vger.kernel.org
References: <f13b4174-bcfa-6569-0601-65a9bfc9bb92@rosalinux.ru>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
From:   Mikhail Novosyolov <m.novosyolov@rosalinux.ru>
Message-ID: <375f18b9-c23a-7f59-4432-374816725a79@rosalinux.ru>
Date:   Sun, 10 May 2020 18:51:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f13b4174-bcfa-6569-0601-65a9bfc9bb92@rosalinux.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: ru-RU
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

19.03.2020 00:31, Mikhail Novosyolov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> Current pre-release version of LibreSSL has enabled CMS support,
> and now sign-file is fully functional with it.
>
> See https://github.com/libressl-portable/openbsd/commits/master
>
> To test buildability with current LibreSSL:
> ~$ git clone https://github.com/libressl-portable/portable.git
> ~$ cd portable && ./autogen.sh
> ~$ ./configure --prefix=3D/opt/libressl
> ~$ make
> ~# make install
> Go to the kernel source tree and:
> ~$ gcc -I/opt/libressl/include -L /opt/libressl/lib -lcrypto -Wl,-rpath=
,/opt/libressl/lib scripts/sign-file.c -o scripts/sign-file
>
> Fixes: f8688017 ("sign-file: fix build error in sign-file.c with libres=
sl")
>
> Signed-off-by: Mikhail Novosyolov <m.novosyolov@rosalinux.ru>

I would like to remember about this.

LibreSSL 3.1.1 has been released, and this patch (https://patchwork.kerne=
l.org/patch/11446123/) is required to sign kernel modules using libressl.

Libressl 3.1.1 can sign them with functional parity with OpenSSL.

> ---
> =C2=A0scripts/sign-file.c | 7 ++++---
> =C2=A01 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/scripts/sign-file.c b/scripts/sign-file.c
> index fbd34b8e8f57..fd4d7c31d1bf 100644
> --- a/scripts/sign-file.c
> +++ b/scripts/sign-file.c
> @@ -41,9 +41,10 @@
> =C2=A0 * signing with anything other than SHA1 - so we're stuck with th=
at if such is
> =C2=A0 * the case.
> =C2=A0 */
> -#if defined(LIBRESSL_VERSION_NUMBER) || \
> -=C2=A0=C2=A0=C2=A0 OPENSSL_VERSION_NUMBER < 0x10000000L || \
> -=C2=A0=C2=A0=C2=A0 defined(OPENSSL_NO_CMS)
> +#if defined(OPENSSL_NO_CMS) || \
> +=C2=A0=C2=A0=C2=A0 ( defined(LIBRESSL_VERSION_NUMBER) \
> +=C2=A0=C2=A0=C2=A0 && (LIBRESSL_VERSION_NUMBER < 0x3010000fL) ) || \
> +=C2=A0=C2=A0=C2=A0 OPENSSL_VERSION_NUMBER < 0x10000000L
> =C2=A0#define USE_PKCS7
> =C2=A0#endif
> =C2=A0#ifndef USE_PKCS7
