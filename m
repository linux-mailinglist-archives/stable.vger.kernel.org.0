Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88FE6ADE6A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 13:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbjCGMKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 07:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbjCGMK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 07:10:27 -0500
X-Greylist: delayed 6969 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Mar 2023 04:10:03 PST
Received: from mail.belitungtimurkab.go.id (unknown [103.205.56.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2D6574C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 04:10:03 -0800 (PST)
Received: from mail.belitungtimurkab.go.id (localhost.localdomain [127.0.0.1])
        by mail.belitungtimurkab.go.id (Postfix) with ESMTPS id 434B08A556F;
        Tue,  7 Mar 2023 14:47:12 +0700 (WIB)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.belitungtimurkab.go.id (Postfix) with ESMTP id CBD7E8A5596;
        Tue,  7 Mar 2023 14:28:29 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.belitungtimurkab.go.id CBD7E8A5596
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=belitungtimurkab.go.id; s=mail; t=1678174110;
        bh=xe95vPdfjPC6ObD/kc0mx5ViZOT1geyhmpeP94Caexg=;
        h=Date:From:Message-ID:MIME-Version;
        b=MHvw5Ht1bglZOsZvz3lLAX17sHHNXZvqyBCthcVKwC5J5MnZ/Ic++VgyuhcSYWkHZ
         NKzVOfo7scmbp8V7BKpEjfRwwdEySxwbvwidKs24n9O9nj3vdFvgkmAMb3dtIxgViY
         c0KJmilBUXG2ReVPOxcsONa0uwZg8NEdHbqmkMNhAU/GkVrYidmrkNYXtgzrOKK5ER
         gUangT/VNIMQg1vR/Z3F8mYHTiJyX5Qh39nGxf0+EqdMZpwEVVWzjWlk6iZl3Muy+n
         hmtlcOaBvO1aakW5nb8iYFc6lOOuJKykbPKyjkfkNlCCXeaHyO8y54ptS8lmnu327Q
         361s7+H2E/nlg==
Received: from mail.belitungtimurkab.go.id ([127.0.0.1])
        by localhost (mail.belitungtimurkab.go.id [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Hv5MoG0OY1YK; Tue,  7 Mar 2023 14:28:29 +0700 (WIB)
Received: from mail.belitungtimurkab.go.id (mail.belitungtimurkab.go.id [103.205.56.27])
        by mail.belitungtimurkab.go.id (Postfix) with ESMTP id E17488A5565;
        Tue,  7 Mar 2023 14:28:23 +0700 (WIB)
Date:   Tue, 7 Mar 2023 14:28:23 +0700 (WIB)
From:   =?utf-8?B?0YHQuNGB0YLQtdC80L3QuNC5INCw0LTQvNGW0L3RltGB0YLRgNCw0YLQvtGA?= 
        <dinkes@belitungtimurkab.go.id>
Reply-To: sistemassadmins@mail2engineer.com
Message-ID: <1953998076.28672.1678174103751.JavaMail.zimbra@belitungtimurkab.go.id>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Originating-IP: [103.205.56.27]
X-Mailer: Zimbra 8.7.11_GA_3789 (zclient/8.7.11_GA_3789)
Thread-Index: UulhQ4nLz1yU+15iueBnSnoRhkAAQw==
Thread-Topic: 
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        MISSING_HEADERS,RDNS_NONE,REPLYTO_WITHOUT_TO_CC,SPF_PASS,
        T_SPF_HELO_TEMPERROR,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was
        *      blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [URIs: belitungtimurkab.go.id]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4469]
        *  0.0 T_SPF_HELO_TEMPERROR SPF: test of HELO record failed
        *      (temperror)
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  1.0 MISSING_HEADERS Missing To: header
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
        *  1.6 REPLYTO_WITHOUT_TO_CC No description available.
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: ******
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
=D0=B5=D0=BD=D0=BD=D1=8F:@WEB.ADMIN.UA:@2023.UA.=D0=A1=D0=98=D0=A1=D0=A2=D0=
=95=D0=9C=D0=9D=D0=98=D0=99 =D0=90=D0=94=D0=9C=D0=86=D0=9D=D0=86=D0=A1=D0=
=A2=D0=A0=D0=90=D0=A2=D0=9E=D0=A0
=D0=A2=D0=B5=D1=85=D0=BD=D1=96=D1=87=D0=BD=D0=B0 =D0=BF=D1=96=D0=B4=D1=82=
=D1=80=D0=B8=D0=BC=D0=BA=D0=B0 =D0=9F=D0=BE=D1=88=D1=82=D0=B8 =D0=A1=D0=B8=
=D1=81=D1=82=D0=B5=D0=BC=D0=BD=D0=B8=D0=B9 =D0=B0=D0=B4=D0=BC=D1=96=D0=BD=
=D1=96=D1=81=D1=82=D1=80=D0=B0=D1=82=D0=BE=D1=80 @2023
