Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D3E4E22E7
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 10:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241874AbiCUJGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 05:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbiCUJGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 05:06:38 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3F8931A1
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 02:05:13 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d18so12138643plr.6
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 02:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=7giopjWTyujn3G/xgAOAojss0g1xOFmKeCsas97kVGU=;
        b=h1r111w0IoNADAqUSnIrye1Efk50TcSVSgsPQo1p5dUP72Mmtu18TvGLmvHqUP8Gyi
         3vqOiIhspE/t0IfmnoaG8U8u0nBEI0fy/VPAg1pDaGFGno9X+QFa1YCTbRaq0ohis/iy
         A1ecfjEtcYo1Vqcc+o4sK3hl/7gtorZyvBolhR/igU32el1VQCxAmIeQZYBHED5xb9a/
         e1mDjCeEB3upEBi8QulzvoPQY432APyXne+9FJ7X3idfyaD/uxKsr2BoCf1BFfCOEJZk
         TAWSNlSz9HCJNMUyIpbzMCJ8DwesIwbR9Ms1IMjjsq29oqJxPUy1WEvXfxPu2Cj4vaWh
         oX8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=7giopjWTyujn3G/xgAOAojss0g1xOFmKeCsas97kVGU=;
        b=uTW8MFFMKwQGm1Zxd5FEJo6IiGaRQlBVEhzaBYCnv9lom1gAScqEF6uUdoi73lxqjE
         4mjRxTVaOZlaNLi/SItxWW3t/oDIBgAAmS/L01C0QP2f9Ol7LzQTHqm08he7tzJLLrEo
         I3xj29Xfpa79mz1L43KnDze1nDTlwQtTkKQKQ6vVda/VNU1H+Z6fGXZswqooEM6DX+lH
         gpHK/z+cdQmuf74I6fFJDGl1Nlvyce8Uu7gcIZAfJcRRs4IsOMWCvF5aig7WDQMAjPyz
         4oObMlxkZY20Z/i0LWvk0RoyMx5xmJo4bxXu8dy+jOj+Qt1XyfKStfkiDEZ8H8MEUgiZ
         mKBA==
X-Gm-Message-State: AOAM533W1li2VolNDHHo4DmLbGJGIalMwzRtttR3QPYOa/OYCKoZ64u/
        eAMm3/7np6gxhlEhG1yaIlnNfKCmlvSewcRg1Yw=
X-Google-Smtp-Source: ABdhPJzUW4m5ByRDluheon/PZ1HhmZHGnQkyXAG1mKMIv1sGO9GWmohNAaN9BQX6NRoeMDvKqvKyYtXWPVoQ1Y/BrSA=
X-Received: by 2002:a17:902:74c3:b0:153:efa3:a127 with SMTP id
 f3-20020a17090274c300b00153efa3a127mr11815412plt.106.1647853513516; Mon, 21
 Mar 2022 02:05:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90a:8b02:0:0:0:0 with HTTP; Mon, 21 Mar 2022 02:05:12
 -0700 (PDT)
Reply-To: susannelegitfirm155@gmail.com
From:   Susanne Klatten <usmanabdulaziz8812@gmail.com>
Date:   Mon, 21 Mar 2022 10:05:12 +0100
Message-ID: <CAPxMV8m6FRxGyfGaxXeEHpWO=X-O--VZKqX5+__iys6VFO=rcQ@mail.gmail.com>
Subject: =?UTF-8?B?UE/Fu1lDWktB?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.3 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,FUZZY_CREDIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:636 listed in]
        [list.dnswl.org]
        * -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
        *      [score: 0.0311]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [usmanabdulaziz8812[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [usmanabdulaziz8812[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [susannelegitfirm155[at]gmail.com]
        *  1.7 FUZZY_CREDIT BODY: Attempt to obfuscate words in spam
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

cze=C5=9B=C4=87

Nazywam si=C4=99 Susanne Klatten i jestem Z Niemiec, mog=C4=99 kontrolowa=
=C4=87 Twoje
problemy finansowe bez uciekania si=C4=99 do Bank=C3=B3w w zakresie Pieni=
=C4=85dze
Kredytowe. Oferujemy po=C5=BCyczki osobiste i po=C5=BCyczki biznesowe, jest=
em
zatwierdzonym i certyfikowanym po=C5=BCyczkodawc=C4=85 z wieloletnim
do=C5=9Bwiadczeniem w udzielaniu po=C5=BCyczek i udzielamy po=C5=BCyczek z
zabezpieczeniem i bez zabezpieczenia w zakresie od 2.000,00 =E2=82=AC ($) d=
o
maksymalnie 500 000 000,00 =E2=82=AC ze sta=C5=82ym oprocentowaniem 3% w st=
osunku
rocznym. Czy potrzebujesz po=C5=BCyczki? Napisz do nas na:
susannelegitfirm155@gmail.com

  Mo=C5=BCesz r=C3=B3wnie=C5=BC zobaczy=C4=87 m=C3=B3j link i dowiedzie=C4=
=87 si=C4=99 wi=C4=99cej o mnie.

  https://en.wikipedia.org/wiki/Susanne_Klatten
  https://www.forbes.com/profile/susanne-klatten

  E-mail: susannelegitfirm155@gmail.com
  Podpis,
  Przewodnicz=C4=85cy Wykonawczy
  Susanne Klatten
