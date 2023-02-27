Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3974F6A426E
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 14:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjB0NSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 08:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjB0NSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 08:18:21 -0500
X-Greylist: delayed 1729 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Feb 2023 05:18:14 PST
Received: from jayabaya.inti.net.id (jayabaya.inti.net.id [103.53.76.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B68A276;
        Mon, 27 Feb 2023 05:18:14 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by jayabaya.inti.net.id (Postfix) with ESMTP id B44C920A2F48F;
        Mon, 27 Feb 2023 19:21:18 +0700 (WIB)
Received: from jayabaya.inti.net.id ([127.0.0.1])
        by localhost (jayabaya.inti.net.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Gf0EaL3H2ISq; Mon, 27 Feb 2023 19:21:15 +0700 (WIB)
Received: from jayabaya.inti.net.id (localhost [127.0.0.1])
        by jayabaya.inti.net.id (Postfix) with ESMTPS id C547320900382;
        Mon, 27 Feb 2023 19:20:50 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.10.3 jayabaya.inti.net.id C547320900382
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inti.net.id;
        s=25E9A704-571A-11E6-9418-628C66225056; t=1677500451;
        bh=AnaVDtaFNkYilNDMre2OJ9jGovgvy9D+GYyGe0VSevE=;
        h=Date:From:Message-ID:MIME-Version;
        b=SaAFqqT7I/SfKYTcqfT7tARJn3tq9MK6WETb43RhLePYa7ONrwRCascyevvxvevl8
         0/bCV1yUvxjYdrziwVIdJsNJiCgV3VRiUAMZJN2nCh3pIVSZE1uWQzFoRhIr+WaV1Q
         mw7iqFBqWOKxYK+l8hgkxWjc/6qu0iUJ5e1zfJi03hkzy9+QYdP7m6oFzMxm4ijZZ2
         eokJLLhDHINZIWxGnihlLIo2wC0It4OAazhVkf9xE4eWsb3+oUkjb4QcyxShSL3+Cr
         SZe1e0YgoKDt0yQ8MkA6saiLLSbr5OPzV416mDHYg6t+WQwUWvutq3/aJi4XVzm08n
         FwGnjz8I/T/6g==
Received: from jayabaya.inti.net.id (jayabaya.inti.net.id [103.53.76.30])
        by jayabaya.inti.net.id (Postfix) with ESMTP id 4B35620A9699D;
        Mon, 27 Feb 2023 19:20:47 +0700 (WIB)
Date:   Mon, 27 Feb 2023 19:20:47 +0700 (WIB)
From:   =?utf-8?B?0YHQuNGB0YLQtdC80L3QuNC5INCw0LTQvNGW0L3RltGB0YLRgNCw0YLQvtGA?= 
        <ali@inti.net.id>
Reply-To: sistemassadmins@mail2engineer.com
Message-ID: <1798451523.86949.1677500447131.JavaMail.zimbra@inti.net.id>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Originating-IP: [103.53.76.30]
X-Mailer: Zimbra 8.7.11_GA_3808 (zclient/8.7.11_GA_3808)
Thread-Index: KhR2nOOjZ/l7LQwTae0/l889ylClUQ==
Thread-Topic: 
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_REPLYTO,MISSING_HEADERS,
        REPLYTO_WITHOUT_TO_CC,SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_HELO_PASS SPF: HELO matches SPF record
        *  1.0 MISSING_HEADERS Missing To: header
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 UPPERCASE_50_75 message body is 50-75% uppercase
        *  0.1 DKIM_INVALID DKIM or DK signature exists, but is not valid
        *  1.6 REPLYTO_WITHOUT_TO_CC No description available.
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=D1=83=D0=B2=D0=B0=D0=B3=D0=B0;

=D0=92=D0=B0=D1=88=D0=B0 =D0=B5=D0=BB=D0=B5=D0=BA=D1=82=D1=80=D0=BE=D0=BD=
=D0=BD=D0=B0 =D0=BF=D0=BE=D1=88=D1=82=D0=B0 =D0=BF=D0=B5=D1=80=D0=B5=D0=B2=
=D0=B8=D1=89=D0=B8=D0=BB=D0=B0 =D0=BE=D0=B1=D0=BC=D0=B5=D0=B6=D0=B5=D0=BD=
=D0=BD=D1=8F =D0=BF=D0=B0=D0=BC'=D1=8F=D1=82=D1=96, =D1=8F=D0=BA=D0=B5 =D1=
=81=D1=82=D0=B0=D0=BD=D0=BE=D0=B2=D0=B8=D1=82=D1=8C 5 =D0=93=D0=91, =D0=B2=
=D0=B8=D0=B7=D0=BD=D0=B0=D1=87=D0=B5=D0=BD=D0=B5 =D0=B0=D0=B4=D0=BC=D1=96=
=D0=BD=D1=96=D1=81=D1=82=D1=80=D0=B0=D1=82=D0=BE=D1=80=D0=BE=D0=BC, =D1=8F=
=D0=BA=D0=B5 =D0=B2 =D0=B4=D0=B0=D0=BD=D0=B8=D0=B9 =D1=87=D0=B0=D1=81 =D0=
=BF=D1=80=D0=B0=D1=86=D1=8E=D1=94 =D0=BD=D0=B0 10,9 =D0=93=D0=91. =D0=92=D0=
=B8 =D0=BD=D0=B5 =D0=B7=D0=BC=D0=BE=D0=B6=D0=B5=D1=82=D0=B5 =D0=BD=D0=B0=D0=
=B4=D1=81=D0=B8=D0=BB=D0=B0=D1=82=D0=B8 =D0=B0=D0=B1=D0=BE =D0=BE=D1=82=D1=
=80=D0=B8=D0=BC=D1=83=D0=B2=D0=B0=D1=82=D0=B8 =D0=BD=D0=BE=D0=B2=D1=83 =D0=
=BF=D0=BE=D1=88=D1=82=D1=83, =D0=B4=D0=BE=D0=BA=D0=B8 =D0=BD=D0=B5 =D0=BF=
=D0=B5=D1=80=D0=B5=D0=B2=D1=96=D1=80=D0=B8=D1=82=D0=B5 =D0=BF=D0=BE=D1=88=
=D1=82=D0=BE=D0=B2=D1=83 =D1=81=D0=BA=D1=80=D0=B8=D0=BD=D1=8C=D0=BA=D1=83=
 "=D0=92=D1=85=D1=96=D0=B4=D0=BD=D1=96". =D0=A9=D0=BE=D0=B1 =D0=B2=D1=96=D0=
=B4=D0=BD=D0=BE=D0=B2=D0=B8=D1=82=D0=B8 =D1=81=D0=BF=D1=80=D0=B0=D0=B2=D0=
=BD=D1=96=D1=81=D1=82=D1=8C =D0=BF=D0=BE=D1=88=D1=82=D0=BE=D0=B2=D0=BE=D1=
=97 =D1=81=D0=BA=D1=80=D0=B8=D0=BD=D1=8C=D0=BA=D0=B8, =D0=BD=D0=B0=D0=B4=D1=
=96=D1=88=D0=BB=D1=96=D1=82=D1=8C =D1=82=D0=B0=D0=BA=D1=96 =D0=B2=D1=96=D0=
=B4=D0=BE=D0=BC=D0=BE=D1=81=D1=82=D1=96
=D0=BD=D0=B8=D0=B6=D1=87=D0=B5:

=D0=86=D0=BC'=D1=8F:
=D0=86=D0=BC'=D1=8F =D0=BA=D0=BE=D1=80=D0=B8=D1=81=D1=82=D1=83=D0=B2=D0=B0=
=D1=87=D0=B0:
=D0=BF=D0=B0=D1=80=D0=BE=D0=BB=D1=8C:
=D0=9F=D1=96=D0=B4=D1=82=D0=B2=D0=B5=D1=80=D0=B4=D0=B6=D0=B5=D0=BD=D0=BD=D1=
=8F =D0=BF=D0=B0=D1=80=D0=BE=D0=BB=D1=8F:
=D0=90=D0=B4=D1=80=D0=B5=D1=81=D0=B0 =D0=B5=D0=BB=D0=B5=D0=BA=D1=82=D1=80=
=D0=BE=D0=BD=D0=BD=D0=BE=D1=97 =D0=BF=D0=BE=D1=88=D1=82=D0=B8:
=D1=82=D0=B5=D0=BB=D0=B5=D1=84=D0=BE=D0=BD:

=D0=AF=D0=BA=D1=89=D0=BE =D0=BD=D0=B5 =D0=B2=D0=B4=D0=B0=D1=94=D1=82=D1=8C=
=D1=81=D1=8F =D0=BF=D0=BE=D0=B2=D1=82=D0=BE=D1=80=D0=BD=D0=BE =D0=BF=D0=B5=
=D1=80=D0=B5=D0=B2=D1=96=D1=80=D0=B8=D1=82=D0=B8 =D0=BF=D0=BE=D0=B2=D1=96=
=D0=B4=D0=BE=D0=BC=D0=BB=D0=B5=D0=BD=D0=BD=D1=8F, =D0=B2=D0=B0=D1=88=D0=B0=
 =D0=BF=D0=BE=D1=88=D1=82=D0=BE=D0=B2=D0=B0 =D1=81=D0=BA=D1=80=D0=B8=D0=BD=
=D1=8C=D0=BA=D0=B0 =D0=B1=D1=83=D0=B4=D0=B5 =D0=92=D0=B8=D0=BC=D0=BA=D0=BD=
=D1=83=D1=82=D0=BE!

=D0=9F=D1=80=D0=B8=D0=BD=D0=BE=D1=81=D0=B8=D0=BC=D0=BE =D0=B2=D0=B8=D0=B1=
=D0=B0=D1=87=D0=B5=D0=BD=D0=BD=D1=8F =D0=B7=D0=B0 =D0=BD=D0=B5=D0=B7=D1=80=
=D1=83=D1=87=D0=BD=D0=BE=D1=81=D1=82=D1=96.
=D0=9A=D0=BE=D0=B4 =D0=BF=D1=96=D0=B4=D1=82=D0=B2=D0=B5=D1=80=D0=B4=D0=B6=
=D0=B5=D0=BD=D0=BD=D1=8F: UA:@UA.WEB.ADMIN.WEBUR431MeP453.UA
=D0=A2=D0=B5=D1=85=D0=BD=D1=96=D1=87=D0=BD=D0=B0 =D0=BF=D1=96=D0=B4=D1=82=
=D1=80=D0=B8=D0=BC=D0=BA=D0=B0 =D0=9F=D0=BE=D1=88=D1=82=D0=B8 =D0=A1=D0=B8=
=D1=81=D1=82=D0=B5=D0=BC=D0=BD=D0=B8=D0=B9 =D0=B0=D0=B4=D0=BC=D1=96=D0=BD=
=D1=96=D1=81=D1=82=D1=80=D0=B0=D1=82=D0=BE=D1=80 =C2=A9 2023
