Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1AC706F8
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 19:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbfGVR1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 13:27:47 -0400
Received: from sonic312-24.consmr.mail.ne1.yahoo.com ([66.163.191.205]:43320
        "EHLO sonic312-24.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729578AbfGVR1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 13:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1563816464; bh=4Vxk5h8RZejECW6gKj5x0qR4nMVVnsd2PEn+qyX3nlQ=; h=Date:From:Reply-To:Subject:From:Subject; b=bd3NGJe6FQ3O1xJixsBpSeYS6GN/3FaohDhX+cjyeA3g3ksyBh8QtiLdj0vRUlVt8nq6vFPZJN7h9095UiXciYTwj7TGZ4sW8u6npW3JxPasH1JrMfFWn2DMiZJSQL4s9qdV9S8aUIToneqkT2d4NTtJqAjZJ3dm0l7g335QxqDNHKdwzQCdgLOw2pZX/ozjwT+RJN1zmu0VHAc3zJ7xicOsKxXcq6bdYIevnZbLZlvDNNo2Pgq+NXI7jTOVZAXFHSl5c0ZHAO4S3NFPeGZpJdWas6eP3wjViRX0W506wonaWZ6N4ZIKc1U9qeWv14LRLGEOuKaHxG2jJfLn0Sr+6Q==
X-YMail-OSG: uUJcCosVM1mN_zyRbuvG9JCJ7sGYT7250IuirDtOtX90Is8RPtp0D3ALa_hyZUC
 dtiQ2oLEHvfcmA1tKufba1wtAehpqwrmxWo2Q1MMW5feGnw6RUXy3I6A.b.ipXcJcJ7GEat_hqyM
 v.5VlcQ77p.u2wPqoewyK2dwHJ5rHdIPP8T8tBeGTtvAeLg_XxWj0y257GavpOhrLpHYERmVZRWp
 r2UkpDDoVaKRu4NOmFSmnkUQG0NoTuiXVb4G.ezzxIphJOcGIk3N2gRga0Z7FFcN93CgNClteD.O
 q4wcaPbA9IDwcw.ja1B.rhcvmEZ2.sUAOGgvHGPGSdT2RYrGWO2LSSaBw4njf90z1yT.ZKXslmDm
 l_o0n0gnMP7.q.2IaB7FX839x.q4BZzPTIW2NOtD6.la.KFzRvoiclu7J_FTRCQMbhbYIJrPxxqx
 sI1A3_4j_7xarsiazpjlzHHi33C8TmJDxXnn3X6wST.vK5uMQa0mfGgdfjAdm9f5g6NF1MmcxorW
 5zF6dxIj4X5nqcwDfFyrjbSIUzF9OCu9WbQUdPKFTvpCi4R3lDOji_H2w0wO3CLswH6Td5aLH7qt
 se0NsEGZ1Wv7UW3w_CDcglJJKCyBBtLTeguurCMpiZf4EBgOgDvUVeCTbf2RnVtRZOH3cQEP_qqM
 hGE5iisT.uqLzUYWHTniUOc1oAHGuMMq7IJHDU33tEjPKygtcvfUOJFycGD_cjC0AJaIPHUes5Nx
 d9TH72GF6LN.528_QRXx.LPeVjQyhnhCQOWaXjg9JovuLoDSB7cLTa8AakgdbjTrWkyo42el13xQ
 C8f9BJEvI7Dt3oudKx8_QPf4vrNZzcID8_dNIYBBpX9DBEx7Wj9Z17iLo0uHlhIK.jr4HQ9QYhVV
 3o3Abz6cI4PlXUuSQL0lyyWEt1s6hxN3BX7x4O88S0JHcl5Ykj_yCnVcy90St6UQvb3ULa9waneT
 AS1HkGlRYwMkfaR6bxyQO9pqIsEKzADk0UNC0f5t6kF.xvRnQiCgQ7Hec3HIXRoGfZvMlm7TwNnd
 sRg0el8c6IStjJ1IQTE9ue.s5Cg8NnYlORJ8JqaCNZirgadSvoBZvUHC3jpXL4.dI1c2Oj0eviVW
 YBYaNkiahnB8bUXkmqwlyHd40OYjG7oNQ5VHnbDfhStD4l3G2JJ7ff5XBKpW5vni8QmAmAx5ifwr
 9v4z1nsxicyuHuE.CgFg5bXSMqKWAdvH3fUjUSvUKHsHr0a6lPriT4tYYJ2PnX3_iVz0IyRZrwpp
 gXyD2G2i0Q9RiM4qC03Pmt.exjXjUwuVVsS4-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Mon, 22 Jul 2019 17:27:44 +0000
Date:   Mon, 22 Jul 2019 17:27:43 +0000 (UTC)
From:   Rita Williams <wir4478@gmail.com>
Reply-To: ritawi668@yahoo.co.jp
Message-ID: <106129782.5437665.1563816463976@mail.yahoo.com>
Subject: Da Sra. Rita Williams
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Meu querido em Cristo


Eu sou a Sra. Rita Williams, me casei com o Sr. David Williams, por 19 anos=
 sem um filho e meu marido morreu em 2007. Estou entrando em contato para q=
ue voc=C3=AA saiba do meu desejo de doar a quantia de US $ 6.500.000 que eu=
 herdei da minha conta. marido atrasado para caridade, atualmente o fundo a=
inda est=C3=A1 no banco. Recentemente, meu m=C3=A9dico me disse que eu tenh=
o uma doen=C3=A7a grave que =C3=A9 um problema de c=C3=A2ncer e n=C3=A3o vo=
u durar pelos pr=C3=B3ximos 2 meses.
Eu quero uma pessoa que use este fundo para orfanatos, escolas, igrejas, vi=
=C3=BAvas, propagando a palavra de Deus em seu pa=C3=ADs.
Responder-me para mais informa=C3=A7=C3=B5es, e tamb=C3=A9m Envie-me as seg=
uintes informa=C3=A7=C3=B5es, conforme abaixo.
Seu nome completo ..........
Endere=C3=A7o ...........
Foto ...............
Permanecer aben=C3=A7oado
Sua irm=C3=A3 em cristo

Sra. Rita William
