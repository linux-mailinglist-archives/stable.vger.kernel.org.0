Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799AE67755D
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 08:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjAWHCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 02:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjAWHCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 02:02:04 -0500
Received: from mx-gw-prx01.wika.co.id (pegasus.wika.zone [103.25.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1ECA13DDD
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 23:02:01 -0800 (PST)
Received: from mx-gw-prx01.wika.co.id (localhost.localdomain [127.0.0.1])
        by mx-gw-prx01.wika.co.id (Proxmox) with ESMTP id 21E6843C66;
        Mon, 23 Jan 2023 14:02:01 +0700 (WIB)
Received: from smtp-gw.wika.co.id (smtp-gw.wika.co.id [10.4.0.44])
        by mx-gw-prx01.wika.co.id (Proxmox) with ESMTP id 61B53431F1;
        Mon, 23 Jan 2023 14:02:00 +0700 (WIB)
Received: from smtp-gw-01.wika.co.id (localhost [127.0.0.1])
        by smtp-gw1.wika.co.id (Postfix) with ESMTP id 76C2518E7A;
        Mon, 23 Jan 2023 14:01:47 +0700 (WIB)
X-Virus-Scanned: amavisd-new at wika.co.id
Received: from smtp-gw.wika.co.id ([127.0.0.1])
        by smtp-gw-01.wika.co.id (smtp-gw-01.wika.co.id [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id OAn9urFv1vNJ; Mon, 23 Jan 2023 14:01:47 +0700 (WIB)
Received: from mailbox.wika.co.id (unknown [10.4.0.84])
        by smtp-gw1.wika.co.id (Postfix) with ESMTP id A499E18F31;
        Mon, 23 Jan 2023 14:01:33 +0700 (WIB)
Received: from localhost (localhost [127.0.0.1])
        by mailbox.wika.co.id (Postfix) with ESMTP id 9778B7FCF15DA;
        Mon, 23 Jan 2023 13:23:41 +0700 (WIB)
Received: from mailbox.wika.co.id ([127.0.0.1])
        by localhost (mailbox.wika.co.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id t22aUsQQI8Ws; Mon, 23 Jan 2023 13:23:41 +0700 (WIB)
Received: from localhost (localhost [127.0.0.1])
        by mailbox.wika.co.id (Postfix) with ESMTP id 70EB87FFF502E;
        Mon, 23 Jan 2023 13:23:40 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.10.3 mailbox.wika.co.id 70EB87FFF502E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wika.co.id;
        s=3A269092-2A4A-11ED-99C4-3E27D2C9E2D5; t=1674455020;
        bh=tPFCCctfbSn+qtCDcB5loatRX7+/l2Bj4wKC8R+HD54=;
        h=Date:From:Message-ID:MIME-Version;
        b=ByoPRoVs866+hexBYCazgfJTrT3FW/RRJixJamOKO36FiYIQ0DBDoNw+EHu5h1Wc+
         qS0lPBXJa62ibhf3wboITAG2g/a/0wl/5L+2yKfzsKi7kQY/gwq+kQHF4W4GiO81HM
         lSAoGrbrrkPmhP6FaXFvj7fLo2iohr3Rez0HbLjpDKUcqYfpclQxzWzoaGRusg7dsM
         hHNKeUOCiiSjAhgwHpbEWE9BpBKJR3FoQzBXc/lAErjK/tVlKmUXilTBUfsC5FHJhE
         bYRbWg3/iTOY71X5yOd+Jeaz3ADtASt8A0NdJiN5I3ko6IMayc7W4QSXRTSP8Ux9I1
         FJucR8S3WEwuQ==
X-Virus-Scanned: amavisd-new at wika.co.id
Received: from mailbox.wika.co.id ([127.0.0.1])
        by localhost (mailbox.wika.co.id [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id B5tRvwHvp2OM; Mon, 23 Jan 2023 13:23:40 +0700 (WIB)
Received: from mailbox.wika.co.id (mailbox.wika.co.id [10.5.0.1])
        by mailbox.wika.co.id (Postfix) with ESMTP id E88CB7FFF5028;
        Mon, 23 Jan 2023 13:22:56 +0700 (WIB)
Date:   Mon, 23 Jan 2023 13:22:56 +0700 (WIB)
From:   =?utf-8?B?0YHQuNGB0YLQtdC80L3QuNC5INCw0LTQvNGW0L3RltGB0YLRgNCw0YLQvtGA?= 
        <wellbeing@wika.co.id>
Reply-To: sistemassadmins@mail2engineer.com
Message-ID: <1799238512.1743311.1674454976843.JavaMail.zimbra@wika.co.id>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Originating-IP: [10.5.0.1]
X-Mailer: Zimbra 8.8.12_GA_3866 (zclient/8.8.12_GA_3866)
Thread-Index: aaxNMO4rTi21QbnnMt9xdUpb6gL9gQ==
Thread-Topic: 
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.0 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        MISSING_HEADERS,REPLYTO_WITHOUT_TO_CC,SPF_HELO_NONE,SPF_PASS,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
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

