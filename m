Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F571600873
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 10:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJQIN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 04:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiJQIN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 04:13:26 -0400
X-Greylist: delayed 1082 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 17 Oct 2022 01:13:21 PDT
Received: from mx2.addit.com.br (mx2.addit.com.br [177.126.173.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B03B5C369
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 01:13:20 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx2.addit.com.br (Postfix) with ESMTP id 44C498297C8;
        Mon, 17 Oct 2022 04:44:17 -0300 (-03)
Received: from mx2.addit.com.br ([127.0.0.1])
        by localhost (brspzbmta02.addit.com.br [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Avjd3JTA8umZ; Mon, 17 Oct 2022 04:44:17 -0300 (-03)
Received: from localhost (localhost [127.0.0.1])
        by mx2.addit.com.br (Postfix) with ESMTP id 9B9187A0C32;
        Mon, 17 Oct 2022 04:44:16 -0300 (-03)
DKIM-Filter: OpenDKIM Filter v2.10.3 mx2.addit.com.br 9B9187A0C32
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grupocanopus.com.br;
        s=A91C73B4-5EA2-11E7-804A-BC494DC02954; t=1665992656;
        bh=dOZbWrecQuif/uGO1fPhmzegUj960tWmRPWutjgfjrg=;
        h=Date:From:Message-ID:MIME-Version;
        b=eydPv4d1OIEt66yKHLMRr67gl5Rh+2D3YHwC6+F2band/cxrhLOV0TJ4q8n1QluAD
         AQzqa1zBiMSFhf9QhImp38WCZulgxpWfXQmWWMS8xlBhTX7lPqyPpOBGJYqo42RJyD
         THqNT1IqFeXs3lphJZoW3EAfIa2zhQkSleuyR360yBaiAqtluWS+sZyvaQxe4sC7BB
         cxsXGlcwoyMo6ffqo5n5HwrVG604io+H/kEONFF3a5o+mFR01lXVVpgqN7U2zD0IlP
         Cbmt7d8n3XR5UscDdZ7PFqxPleJTP8oAd9gro6rJdaNFiskwJUIWvjeOqhBn+a4ZEN
         lbkp3uuQIN0Kw==
X-Virus-Scanned: amavisd-new at brspzbmta02.addit.com.br
Received: from mx2.addit.com.br ([127.0.0.1])
        by localhost (brspzbmta02.addit.com.br [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7dWcJOyBDEXK; Mon, 17 Oct 2022 04:44:16 -0300 (-03)
Received: from brspzbmbx03.addit.com.br (brspzbmbx03.addit.com.br [10.0.5.13])
        by mx2.addit.com.br (Postfix) with ESMTP id 7473C877CCA;
        Mon, 17 Oct 2022 04:44:14 -0300 (-03)
Date:   Mon, 17 Oct 2022 04:44:14 -0300 (BRT)
From:   "Paul G.Allen Family Foundation" 
        <ricardo.fernandes@grupocanopus.com.br>
Reply-To: pga.donationss2022@gmail.com
Message-ID: <410078728.14101.1665992654451.JavaMail.zimbra@grupocanopus.com.br>
Subject: =?utf-8?B?0JHQtdC90LXRhNGW0YbRltCw0YA=?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Originating-IP: [106.210.102.118]
X-Mailer: Zimbra 8.8.15_GA_4372 (zclient/8.8.15_GA_4372)
Thread-Index: ABRNYe5yBydeuyEAQhDpTZ5ib9bWkw==
Thread-Topic: =?utf-8?B?0JHQtdC90LXRhNGW0YbRltCw0YA=?=
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,MISSING_HEADERS,RCVD_IN_DNSWL_LOW,
        REPLYTO_WITHOUT_TO_CC,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


=D0=A8=D0=B0=D0=BD=D0=BE=D0=B2=D0=BD=D0=B8=D0=B9 =D0=B1=D0=B5=D0=BD=D0=B5=
=D1=84=D1=96=D1=86=D1=96=D0=B0=D1=80!

=D0=92=D0=B8 =D0=BE=D1=82=D1=80=D0=B8=D0=BC=D0=B0=D0=BB=D0=B8 1 000 000,0=
0 =D0=B4=D0=BE=D0=BB=D0=B0=D1=80=D1=96=D0=B2 =D0=A1=D0=A8=D0=90 =D1=8F=D0=
=BA =D0=B1=D0=BB=D0=B0=D0=B3=D0=BE=D0=B4=D1=96=D0=B9=D0=BD=D1=96 =D0=BF=D0=
=BE=D0=B6=D0=B5=D1=80=D1=82=D0=B2=D0=B8/=D0=B4=D0=BE=D0=BF=D0=BE=D0=BC=D0=
=BE=D0=B3=D1=83 =D0=B2=D1=96=D0=B4 =D0=A4=D0=BE=D0=BD=D0=B4=D1=83 =D1=81=D1=
=96=D0=BC=E2=80=99=D1=97 =D0=9F=D0=BE=D0=BB=D0=B0 =D0=93. =D0=90=D0=BB=D0=
=BB=D0=B5=D0=BD=D0=B0. =D0=92=D0=B0=D1=88=D1=83 =D0=B5=D0=BB=D0=B5=D0=BA=D1=
=82=D1=80=D0=BE=D0=BD=D0=BD=D1=83 =D0=B0=D0=B4=D1=80=D0=B5=D1=81=D1=83 =D0=
=B1=D1=83=D0=BB=D0=BE =D0=B2=D0=B8=D0=B1=D1=80=D0=B0=D0=BD=D0=BE =D0=B2 =D0=
=86=D0=BD=D1=82=D0=B5=D1=80=D0=BD=D0=B5=D1=82=D1=96 =D0=BF=D1=96=D0=B4 =D1=
=87=D0=B0=D1=81 =D0=B2=D0=B8=D0=BF=D0=B0=D0=B4=D0=BA=D0=BE=D0=B2=D0=BE=D0=
=B3=D0=BE =D0=BF=D0=BE=D1=88=D1=83=D0=BA=D1=83. =D0=91=D1=83=D0=B4=D1=8C =
=D0=BB=D0=B0=D1=81=D0=BA=D0=B0, =D0=B7=D0=B2=E2=80=99=D1=8F=D0=B6=D1=96=D1=
=82=D1=8C=D1=81=D1=8F =D0=B7 =D0=BD=D0=B0=D0=BC=D0=B8 =D1=8F=D0=BA=D0=BD=D0=
=B0=D0=B9=D1=88=D0=B2=D0=B8=D0=B4=D1=88=D0=B5. =D0=94=D0=BB=D1=8F =D0=BE=D1=
=82=D1=80=D0=B8=D0=BC=D0=B0=D0=BD=D0=BD=D1=8F =D0=B4=D0=BE=D0=B4=D0=B0=D1=
=82=D0=BA=D0=BE=D0=B2=D0=BE=D1=97 =D1=96=D0=BD=D1=84=D0=BE=D1=80=D0=BC=D0=
=B0=D1=86=D1=96=D1=97 =D0=B2=D1=96=D0=B4=D0=B2=D1=96=D0=B4=D0=B0=D0=B9=D1=
=82=D0=B5: https://pgafamilyfoundation.org/

=D0=92=D1=96=D0=B4 =D1=96=D0=BC=D0=B5=D0=BD=D1=96 =D1=84=D0=BE=D0=BD=D0=B4=
=D1=83 =D0=B2=D1=96=D1=82=D0=B0=D1=94=D0=BC=D0=BE =D0=B2=D0=B0=D1=81.

=D0=97 =D0=BD=D0=B0=D0=B9=D0=BA=D1=80=D0=B0=D1=89=D0=B8=D0=BC=D0=B8 =D0=BF=
=D0=BE=D0=B1=D0=B0=D0=B6=D0=B0=D0=BD=D0=BD=D1=8F=D0=BC=D0=B8,
=D0=94=D0=BE=D0=BA=D1=82=D0=BE=D1=80 =D0=92=D0=B5=D0=BB =D0=91=D1=83=D1=88
