Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A1647AB01
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhLTOFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhLTOFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:05:07 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15513C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 06:05:07 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id v138so29064043ybb.8
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 06:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=+9Aae4sbR4tTNbH+fr2m75YEbh7QFbT3xGgEYjyKwvg=;
        b=f0r7hHiGHjmGvki70w5UMVlOTD+IkkeMbAOQ+MGzxl/g7XJhOIkxQGvj3/YA+W0h0C
         /K1lL8PZA2/Uuv8T4vu/vA3ZRjReY5SNcnAPkY495Q7I8BRQdPYDzsU/c4PS3HXV6SBo
         JpWa3nqJ6+yvpVea/NwqrV2WlcckB6KVTMe7Jh84kzzrarB9bC4NvJUPuJAID4Xe4jBT
         tSSidydctzuP81EJ5EouAp0PbmxNys60LNyUkHWMz3DBstwjBa0Tg8/1sVbUas1nzQem
         Q4cjRXOopOXi7PNjpa+CAuowJaSxAmMQAvrVV/gTUkG0c/+14RPqIsVk9yZlj+jbbcXb
         MJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=+9Aae4sbR4tTNbH+fr2m75YEbh7QFbT3xGgEYjyKwvg=;
        b=Ngr15GHfUNNjEfSOorXCY05Fr83RM6ZBbMozS8+sX1LCZYIhcDqFHv6ZXtmiCyefj/
         kxny6tuXkKVCIIzHRJEBhB9uAAG96WeNwgQzFj6SrE3Kv88z9vRLyxI2f4iuQyKcthdF
         q9PYle3ZrDXqQhwopLTN1sM/ao1E+I4CqKryYQ+qlWjPwyFU5oJLLUM1m4NquuWuK9ks
         RoPFgM94ctfErUHeGnYHAdNQgz0CnwB2TEctTPm45x8q3bVAKUe3tW2ORsPHSLDG+Zs6
         KsDQtMpT5DMub9toIiOdM6uhbsg7QKCkTmKM3XewQYRBVcnTjsBDAhLmDDR66dgeljey
         b1Ig==
X-Gm-Message-State: AOAM533RUncQcW3fPDTNhdLE9+KUIC0IA7wOLMXY9vD+7BoCJPPdiFWL
        onMQlv2/6R8tyATLfZ5/fTRjSEyylWkzSH+POAg=
X-Google-Smtp-Source: ABdhPJzWfd5H63tViKNdaZyiM/47u2Dc1us0+sT0O5ReB8PR8KbcVLCNCiuah2GJqfDAi7QtKFK/kZJpyUwoFCPoEQw=
X-Received: by 2002:a25:a1e2:: with SMTP id a89mr22137294ybi.761.1640009105859;
 Mon, 20 Dec 2021 06:05:05 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a25:db49:0:0:0:0:0 with HTTP; Mon, 20 Dec 2021 06:05:05
 -0800 (PST)
Reply-To: barr.christiankossi37@gmail.com
From:   Christian Kossi <barr.christiankossi5@gmail.com>
Date:   Mon, 20 Dec 2021 06:05:05 -0800
Message-ID: <CA+U6v9NK_Oh9s3ixfZJs98x5hZsvEGeb+BgNAEJMq5jT7MqLGQ@mail.gmail.com>
Subject: =?UTF-8?Q?Merhaba_l=C3=BCtfen_masaj=C4=B1m=C4=B1_okuyun_ve_daha_fazla_bilg?=
        =?UTF-8?Q?i_i=C3=A7in_bana_geri_d=C3=B6n=C3=BCn?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Merhaba iyi g=C3=BCnler
Size iki kez cevaps=C4=B1z bir e-posta g=C3=B6nderdim. Bu g=C3=BCvenle ve
sizinle ileti=C5=9Fim kurdu=C4=9Fum samimiyet, l=C3=BCtfen e-postam varsa =
=C3=B6z=C3=BCrlerimi kabul edin
ki=C5=9Fisel ahlak=C4=B1n=C4=B1z=C4=B1 ihlal ediyor. Benim ad=C4=B1m Christ=
ian Kossi, ben bir hizmet=C3=A7iyim
Lom=C3=A9, Togo merkezli avukat.

Soyad benzerli=C4=9Fi nedeniyle sizinle ileti=C5=9Fime ge=C3=A7iyorum
=C3=BClkenizin bir vatanda=C5=9F=C4=B1 olan vefat eden m=C3=BCvekkilim ile =
payla=C5=9Fmak i=C3=A7in
Togo Cumhuriyeti'nde 9,600,000,00$ banka mevduat=C4=B1. erkek
Merhum m=C3=BC=C5=9Fteri 21 Nisan 2011 tarihinde bir trafik kazas=C4=B1nda =
hayat=C4=B1n=C4=B1
kaybetmi=C5=9Ftir.
hi=C3=A7bir yak=C4=B1n akraba kay=C4=B1tl=C4=B1 de=C4=9Fil. Onu bulmak i=C3=
=A7in =C3=A7e=C5=9Fitli
giri=C5=9Fimlerde bulunuldu.
sonu=C3=A7suz b=C3=BCy=C3=BCkel=C3=A7ili=C4=9Fi arac=C4=B1l=C4=B1=C4=9F=C4=
=B1yla geni=C5=9F aile.

Se=C3=A7ene=C4=9Fi =C3=B6neren bankadan resmi bir mektup ald=C4=B1m
Fon b=C3=BCnyesinde hesab=C4=B1n kullan=C4=B1lamaz hale getirilmesi ve hacz=
edilmesi prosed=C3=BCr=C3=BC
y=C3=BCr=C3=BCrl=C3=BCkteki yasalara g=C3=B6re, m=C3=BCvekkilimin paray=C4=
=B1 yat=C4=B1rd=C4=B1=C4=9F=C4=B1 banka
Tutar 9,6 milyon ABD dolar=C4=B1d=C4=B1r. Burada h=C3=BCk=C3=BCmet kanunlar=
=C4=B1na g=C3=B6re, sonra
10 y=C4=B1ll=C4=B1k s=C3=BCrenin sonunda fon =C5=9Firketin m=C3=BClkiyetine=
 geri d=C3=B6necektir.
Togo H=C3=BCk=C3=BCmeti. 10 y=C4=B1ll=C4=B1k s=C3=BCre ge=C3=A7en y=C4=B1l =
Nisan ay=C4=B1nda doldu
2021 ve hi=C3=A7 kimse hesab=C4=B1n=C4=B1zda i=C5=9Flem yapmad=C4=B1 veya t=
alep etmedi
fon, sermaye.

Size =C3=B6nerim sizi en yak=C4=B1n bankaya ibraz etmenizdir.
merhum m=C3=BCvekkilimin bir akrabas=C4=B1n=C4=B1n bu 9,6 dolar=C4=B1 banka=
ya =C3=B6demesi
al=C4=B1c=C4=B1lar=C4=B1 olarak size milyonlarca. Transferin tamamlanmas=C4=
=B1n=C4=B1n ard=C4=B1ndan,
Fonu, =C3=BCzerinde mutab=C4=B1k kal=C4=B1nan bir y=C3=BCzdeye b=C3=B6lmeyi=
 =C3=B6neriyorum.
her iki taraf i=C3=A7in de tatmin edici ve ayr=C4=B1ca hay=C4=B1r kurumlar=
=C4=B1na ba=C4=9F=C4=B1=C5=9Fta bulunmak.

Talebinizi destekleyen t=C3=BCm yasal belgeleri sa=C4=9Flayaca=C4=9F=C4=B1m=
. Her=C5=9Fey
Bunu yapabilmemiz i=C3=A7in d=C3=BCr=C3=BCst i=C5=9Fbirli=C4=9Fine ihtiyac=
=C4=B1m var.
i=C5=9Flem. Ayr=C4=B1ca bunun bir kurallara uygun olarak yap=C4=B1laca=C4=
=9F=C4=B1n=C4=B1 garanti ederim.
sizi herhangi bir ihlalden koruyacak yasal bir anla=C5=9Fma
burada veya =C3=BClkenizde yasa.

Size t=C3=BCm bilgileri verebilmem i=C3=A7in l=C3=BCtfen benimle ileti=C5=
=9Fime ge=C3=A7in.

Selamlar
Christian Kossi, avukat,
Ba=C5=9F Hukuk M=C3=BC=C5=9Faviri: Kossi & Co Associates
