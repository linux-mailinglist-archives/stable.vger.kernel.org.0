Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F7B6B1C72
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 08:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjCIHfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 02:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjCIHfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 02:35:04 -0500
Received: from mail.belitungtimurkab.go.id (unknown [103.205.56.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81C455059
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 23:34:42 -0800 (PST)
Received: from mail.belitungtimurkab.go.id (localhost.localdomain [127.0.0.1])
        by mail.belitungtimurkab.go.id (Postfix) with ESMTPS id ABCD68A56F5;
        Thu,  9 Mar 2023 11:52:25 +0700 (WIB)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.belitungtimurkab.go.id (Postfix) with ESMTP id 4CD6E8A5751;
        Thu,  9 Mar 2023 11:35:22 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.belitungtimurkab.go.id 4CD6E8A5751
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=belitungtimurkab.go.id; s=mail; t=1678336522;
        bh=xe95vPdfjPC6ObD/kc0mx5ViZOT1geyhmpeP94Caexg=;
        h=Date:From:Message-ID:MIME-Version;
        b=LYFXI2mSPWagptCYWmv0f6nbHZzpchraQL+ThVlcbspQIHVqh5CpKg/Wydi2JNjaL
         yqT2vQPFg5f4MG8pag+ERu2pRbiXQCEz/W1tB44LeNcfT96S91BNrxv9kHi4o83VCa
         Ey15aEl8aIiZLRHtOznW5QuiT8ijC2t7tiw00VUhFXFlCHBwmFRdcESUu+/YydcT80
         biD/c6lXIEKHrjod0kaiCT+aZE21oLVRhjX9ywacxZVY3fVCk3llfzDLpOhpWO/oqR
         sCzEw8m4c60YMB4njKtWvOto/14r7UlcfFPdWvcvgJS+qLhds1T46FjSKxtXrXWSnj
         oJ62KJBaCvzow==
Received: from mail.belitungtimurkab.go.id ([127.0.0.1])
        by localhost (mail.belitungtimurkab.go.id [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VMTwNeHbuMgB; Thu,  9 Mar 2023 11:35:21 +0700 (WIB)
Received: from mail.belitungtimurkab.go.id (mail.belitungtimurkab.go.id [103.205.56.27])
        by mail.belitungtimurkab.go.id (Postfix) with ESMTP id 862068A514D;
        Thu,  9 Mar 2023 11:35:20 +0700 (WIB)
Date:   Thu, 9 Mar 2023 11:35:20 +0700 (WIB)
From:   =?utf-8?B?0YHQuNGB0YLQtdC80L3QuNC5INCw0LTQvNGW0L3RltGB0YLRgNCw0YLQvtGA?= 
        <dinkes@belitungtimurkab.go.id>
Reply-To: sistemassadmins@mail2engineer.com
Message-ID: <1035183121.44570.1678336520531.JavaMail.zimbra@belitungtimurkab.go.id>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Originating-IP: [103.205.56.27]
X-Mailer: Zimbra 8.7.11_GA_3789 (zclient/8.7.11_GA_3789)
Thread-Index: J6vg0ej9WQdUjAhjRIVu5qfAqzD2Zw==
Thread-Topic: 
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        MISSING_HEADERS,RDNS_NONE,REPLYTO_WITHOUT_TO_CC,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
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
