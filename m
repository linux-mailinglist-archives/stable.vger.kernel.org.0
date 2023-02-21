Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F65869EBBE
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 01:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjBVALU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 19:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjBVALT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 19:11:19 -0500
X-Greylist: delayed 1963 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Feb 2023 16:11:17 PST
Received: from pijkaqwt.kolliers.com (pijkaqwt.kolliers.com [92.52.217.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCC32449D
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 16:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; s=dkim; d=kolliers.com;
 h=Reply-To:From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding; i=bara@kolliers.com;
 bh=9MCVbH6FWJctFLxnEOCLJvHXl/U=;
 b=ecqvDq7irVGDWCuGeeCT+7418wm4M7XQixTi8LrWwyaihmbjW25jT7PokrC/0h2QH1K1QcgnV6aC
   CUYrsiuUoBYIgT93U9yQecurI/0v+Hn9zlW514ZnMLtnFE4KXM6S0oTFEBAEAj+4hL+ov91WgVDK
   qqP7FANXejAZ8C6CEfLZ5WP5H/oGgP7YU8jX+p0H1L1lU6zIuK/Hb27qIUGR3HSgXisXf/TIUu0j
   5SyIz+aN9RowTs93RIZzp6updd58fcvLInVTCXzSxjcXFq1jOd5ZWEkhFhBBaBFW8fAAVb2vIznK
   AEJT3VKIVBbksTCepQfC7BjB4ILxbiK6pZhH2w==
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns; s=dkim; d=kolliers.com;
 b=DcwoVmpQjHkY6iJftJN1I6Q+3MqQCnMzKLHgTJ6vrXRrv5bJwZF2NI6luYIbR/Gqzfx1MKMESoLy
   bcv/dKm3c9EWiw14KZrb3DY1yqmhN8wG30dRX5YnEB8IWzSyiQ7S/DmIHAdOAvQoXarAKjog7yvE
   uNN59mU9S5vEjuPk0/DyQ2cxlgEHkraswKbPIfUN3EaBY+U7MF9qP9JgmL1rHZMV/5c59GSVM9kb
   uPui3OgFri2AkCuA4BC7UEfjGoHzub71Rz+oJmYYNdal3IrO9vjdZ/k6db5114X0VikP1TlI4IMW
   zB1+DRlNRzr4WGYEVhDl3U32jJZ8+9Q5ELCAVg==;
Reply-To: esq.mustafaa@gmail.com
From:   Mustafa Ayvaz <bara@kolliers.com>
To:     stable@vger.kernel.org
Subject: stable
Date:   21 Feb 2023 15:38:32 -0800
Message-ID: <20230221153832.70B9636908F31F15@kolliers.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        LOCALPART_IN_SUBJECT,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_DBL_MALWARE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  2.5 URIBL_DBL_MALWARE Contains a malware URL listed in the Spamhaus
        *       DBL blocklist
        *      [URIs: kolliers.com]
        *  1.3 RCVD_IN_BL_SPAMCOP_NET RBL: Received via a relay in
        *      bl.spamcop.net
        *      [Blocked - see <https://www.spamcop.net/bl.shtml?92.52.217.53>]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [92.52.217.53 listed in wl.mailspike.net]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  1.1 LOCALPART_IN_SUBJECT Local part of To: address appears in
        *      Subject
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bom dia stable@vger.kernel.org,

Sou o advogado Mustafa Ayvaz, advogado pessoal do falecido Sr.=20
Robert, que perdeu a vida devido ao coronav=C3=ADrus, contra=C3=ADdo=20
durante sua viagem de neg=C3=B3cios =C3=A0 China. Entrei em contato com=20
voc=C3=AA para trabalhar comigo na transfer=C3=AAncia de um fundo:=20
$4,420,000.00 (quatro milh=C3=B5es, quatrocentos e vinte mil d=C3=B3lares)=
=20
legado deixado por ele.

Procurei minuciosamente o parente mais pr=C3=B3ximo de meu cliente=20
falecido, mas falhei porque n=C3=A3o tenho sua resid=C3=AAncia atual e=20
detalhes de contato. Enquanto pesquisava, encontrei seu perfil=20
com o mesmo sobrenome e na mesma localidade com o parente mais=20
pr=C3=B3ximo. Decidi entrar em contato com voc=C3=AA e us=C3=A1-lo como par=
ente=20
genu=C3=ADno.

Solicito seu consentimento para apresent=C3=A1-lo como parente mais=20
pr=C3=B3ximo de meu falecido cliente, j=C3=A1 que ambos t=C3=AAm o mesmo=20=

sobrenome. Os fundos ser=C3=A3o ent=C3=A3o transferidos para voc=C3=AA como=
=20
benefici=C3=A1rio e compartilhados de acordo com um padr=C3=A3o/propor=C3=
=A7=C3=A3o=20
de compartilhamento proposto de 60:40, ou seja, 60% para mim e=20
40% para voc=C3=AA. Por favor, entre em contato comigo imediatamente=20
para obter mais informa=C3=A7=C3=B5es.

Cumprimentos
Mustaf=C3=A1 Ayvaz
