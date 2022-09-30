Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F6A5F0457
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 07:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiI3F40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 01:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiI3F4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 01:56:25 -0400
X-Greylist: delayed 2144 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 29 Sep 2022 22:56:22 PDT
Received: from mail.pgn.gob.gt (mail.pgn.gob.gt [216.230.140.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A776611D60D
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 22:56:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.pgn.gob.gt (Postfix) with ESMTP id 8384ED5852F1A;
        Thu, 29 Sep 2022 23:08:20 -0600 (CST)
Received: from mail.pgn.gob.gt ([127.0.0.1])
        by localhost (mail.pgn.gob.gt [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id GmdGMkcgd_dY; Thu, 29 Sep 2022 23:08:20 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.pgn.gob.gt (Postfix) with ESMTP id D72A0D5852F23;
        Thu, 29 Sep 2022 23:08:19 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.pgn.gob.gt D72A0D5852F23
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pgn.gob.gt;
        s=E0581F14-500F-11EC-8EFF-93589398BF5E; t=1664514500;
        bh=p6uDRsmMjXS9HGPzoMms1Q7ir8ScWDe+tE5fjoTUKeo=;
        h=Date:From:Message-ID:MIME-Version;
        b=nx2wlvEFm7Lql011JZ3dcqaDIOzcR/kgN20MYofDqAPwvo4nsQgeffgH/EirWNA+g
         taNDU0hfgrVUCkVfLB7JKm6+Hzlolj/W2SArD/dGLpR+jkBIXB9ayAY3vQs8WkJWzh
         neTkPYENP9jVxBOtTJY35o46/iJ8R076fRndg8ewJvo1hJpKRqP7tzHUBrRPkHzTgI
         hU3L9+RmWl1SlYXvUbWR7HhEcogr2jvOyegYF/v2osNNSTAHjKElJ4CRW5q0NyZ0Jq
         8p6EqUvahXTJUr6BI6PAuPh7cLjNrZqGRNMXx4VrxQ7vC3tYD6ElU5IL3KN+bktnXI
         C5VTRL/iMNKFg==
X-Virus-Scanned: amavisd-new at pgn.gob.gt
Received: from mail.pgn.gob.gt ([127.0.0.1])
        by localhost (mail.pgn.gob.gt [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id erKRGvj4KZHY; Thu, 29 Sep 2022 23:08:19 -0600 (CST)
Received: from mail.pgn.gob.gt (mail.pgn.gob.gt [192.168.0.80])
        by mail.pgn.gob.gt (Postfix) with ESMTP id 2346BD5842B0A;
        Thu, 29 Sep 2022 23:08:17 -0600 (CST)
Date:   Thu, 29 Sep 2022 23:08:17 -0600 (CST)
From:   =?utf-8?Q?darcovsk=C3=BD?= dobrodinec 
        <marvin.aquino.jalapa@pgn.gob.gt>
Reply-To: "jonathonsherman@yahoo.com" <jonathonsherman@yahoo.com>
Message-ID: <1851549076.11850557.1664514497005.JavaMail.zimbra@pgn.gob.gt>
Subject: =?utf-8?Q?d=C3=B4vern=C3=A9_ozn=C3=A1menie?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [192.168.0.80]
X-Mailer: Zimbra 8.8.15_GA_4173 (zclient/8.8.15_GA_4173)
Thread-Index: 3nrVCi/lLbfOqDOrOM4DK11HsnNB1A==
Thread-Topic: =?utf-8?Q?d=C3=B4vern=C3=A9_ozn=C3=A1menie?=
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        MISSING_HEADERS,REPLYTO_WITHOUT_TO_CC,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.0 MISSING_HEADERS Missing To: header
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  1.6 REPLYTO_WITHOUT_TO_CC No description available.
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Ahoj,Som Jonathan Sherman. Som syn kanadsk=C3=A9ho stavite=C4=BEa. H=C4=BEa=
d=C3=A1m k=C3=BApu domu vo va=C5=A1ej krajine, kde by som sa mohol pres=C5=
=A5ahova=C5=A5 so svojou rodinou. Ak by ste boli tak=C3=BD l=C3=A1skav=C3=
=BD a pomohli mi n=C3=A1js=C5=A5 niekoho bl=C3=ADzkeho, som ochotn=C3=BD sa=
 s vami podeli=C5=A5 o 40 % svojho dedi=C4=8Dstva. Vlo=C5=BEte zlat=C3=A9 p=
eniaze do banky a ove=C4=BEa viac. Toto je len =C3=BAvod k tomu, o =C4=8Dom=
 by som sa s vami r=C3=A1d porozpr=C3=A1val. Boli by ste tak=C3=BD l=C3=A1s=
kav=C3=BD a kontaktoval ma pre viac podrobnost=C3=AD? Toto je d=C3=B4vern=
=C3=A9, nikdy som to nechcel zverejni=C5=A5. Z tohto d=C3=B4vodu sa mus=C3=
=ADm osobne obr=C3=A1ti=C5=A5 na v=C3=A1=C5=A1 e-mail. Pre bli=C5=BE=C5=A1i=
e inform=C3=A1cie ma pros=C3=ADm kontaktujte. S=C4=BEubujem, =C5=BEe ti nez=
aberiem ve=C4=BEa =C4=8Dasu. Len som potreboval niekoho, komu by som sa zve=
ril so svoj=C3=ADm tajn=C3=BDm pl=C3=A1nom s=C5=A5ahovania. ak by ste boli =
tak l=C3=A1skav=C3=AD a kontaktovali moju s=C3=BAkromn=C3=BA e-mailov=C3=BA=
 adresu: poskytnem v=C3=A1m v=C5=A1etky podrobnosti o d=C3=B4vode m=C3=B4jh=
o pres=C5=A5ahovania. s=C3=BAkromn=C3=BD e-mail: JonathonSherman&#64;outloo=
k.comS=C3=BAkromn=C3=A9 WhatsApp: &#43;1(289)6459842S Pozdravom,Jonathan Sh=
erman.
