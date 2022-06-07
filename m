Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3F453FA9A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240477AbiFGJ6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbiFGJ5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:57:37 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A08196
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 02:57:36 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id w20so5820363lfa.11
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 02:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=p7cyveT4bvEtCVZfKnt9HMSBuDucwLXScRMPEQg6smQ=;
        b=jmcJhbGUYeoEshahqXCL0L01GAMJTOJVS19zz2eme5aArqm/uU5cAafVq8kRWErxkV
         19/lAQ+WQiFiwQ2FEkWmp3iTUW/rjbStYtKr9HvavbYkhIJGysAbNC0z2Zkvvj8O+NLw
         CNOvQ4EYTxouLkR2ieZqJYeDySJkqWQv0TeNETuDq3Rrrj66Lws77zCtixqmL3g95Mmu
         BPuvmABjk9t2kBJkFyc1Y9zD+7E/HIsxE0SCSK8ozm7O6KpwaKHaqW253+l6+xGsNGoM
         FG258HMaVN5BUtcGk9HZUi1ewDcAewhKyKYNJGxwFyEh0UXxk7wXAxjFpx+h+m2MxG7z
         T6dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=p7cyveT4bvEtCVZfKnt9HMSBuDucwLXScRMPEQg6smQ=;
        b=xnKVegpNV9X81uI4kudSagBgflwlDmcXTqKrIBnzptQN8g7Gky7/l53Hi2emApnFf6
         gtGm/IMu8ldNz0y2a/ncB9QfNRmy1IUjb07R5viTe3GD3L9dAiPa5OalOnqq1q6QQjfV
         IjOGWpTh43qmGNlN5H330I9lEWnTPDLUfdCctwmzjojJ5rmXDUZUqMIgrLXeWKfdcCRU
         n7SOybk1e5Rq1gp1MEloJafWdrKez2Lug0Iy4h28jWZTn5bjdFZd3NRTLzOEgFILy+aB
         eG6nTXBzdAibpjq0vnOc8JxnW/z53Dh0scI/6BKsJyj5a4SADCjDgPwxCSWK5lUWXWlS
         x1yQ==
X-Gm-Message-State: AOAM531nXcH19/ZjZvK1iagcIAS5l4kqXOu74JVCw+b18dGpD2aZmH9J
        zNUUlk+dLR9pkIxQxhXh753alGvLS8QQToNWxLI=
X-Google-Smtp-Source: ABdhPJxLKeEufFEnFvdldhrIavu0wzaconUba65e71KNcvUVcv/nUKTKdDWAsybWO4Oepf/JMYW0ue0uCpLqhENnYHQ=
X-Received: by 2002:a05:6512:c1b:b0:479:150b:c7c9 with SMTP id
 z27-20020a0565120c1b00b00479150bc7c9mr14567478lfu.574.1654595854487; Tue, 07
 Jun 2022 02:57:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6504:51d0:b0:1cf:9a7b:1066 with HTTP; Tue, 7 Jun 2022
 02:57:33 -0700 (PDT)
Reply-To: robertbaileys_spende@aol.com
From:   Robert Baileys <mrnazy58@gmail.com>
Date:   Tue, 7 Jun 2022 11:57:33 +0200
Message-ID: <CAKTXsVkPbqaWrpUp+=tPTiQfkLyQ1+0Md3bqHc_UDDMq3OJJ1w@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:131 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrnazy58[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrnazy58[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Sehr geehrter Beg=C3=BCnstigter,

Sie erhalten diese E-Mail von der Robert Baileys Foundation. Ich bin
ein pensionierter Regierungsangestellter aus Harlem und ein Powerball
Lotterie-Jackpot-Gewinner von 343,8 Millionen US-Dollar. Ich bin der
gr=C3=B6=C3=9Fte Jackpot-Gewinner in der Geschichte der New York Lottery in
Amerika. Ich habe diese Lotterie am 27. Oktober 2018 gewonnen und
m=C3=B6chte Ihnen mitteilen, dass Google in Zusammenarbeit mit Microsoft
f=C3=BCr eine zuf=C3=A4llige ''E-Mail-Adresse'' 3 Millionen Pfund ausgibt. =
Ich
glaube fest an "Geben w=C3=A4hrend des Lebens".
Ich spende diese 3 Millionen Pfund an Sie, um auch
Wohlt=C3=A4tigkeitsorganisationen und armen Menschen in Ihrer Gemeinde zu
helfen, damit wir die Welt zu einem besseren Ort zum Leben machen
k=C3=B6nnen. Um mehr Informationen in meinem Gewinn zu erhalten, k=C3=B6nne=
n Sie
die Website besuchen, also k=C3=B6nnen Sie skeptisch sein es .
https://nypost.com/2018/11/14/meet-the-winner-of-the-biggest-lottery-jackpo=
t-in-new-york-history/Sie
Sie k=C3=B6nnen auch auf meinem YouTube nach weiteren Best=C3=A4tigungen su=
chen:
https://www.youtube.com/watch?v=3DH5vT18Ysavc
 Ich hatte eine Idee, die sich nie ge=C3=A4ndert hat: dass Sie Ihr Verm=C3=
=B6gen
verwenden sollten, um Menschen zu helfen, und ich habe beschlossen,
heimlich { 3000.000 =C2=A3} an ausgew=C3=A4hlte Menschen auf der ganzen Wel=
t zu
spenden, Menschen, die einen gro=C3=9Fen Einfluss auf die Gesellschaft
hatten durch Verhalten. Nach Erhalt dieser E-Mail sollten Sie sich als
gl=C3=BCckliche Person betrachten und daher berechtigt sein, ein
Beg=C3=BCnstigter zu sein.
Bitte beachten Sie, dass alle Antworten an
(robertbaileys_spende@aol.com) gesendet werden sollten, und erhalten
Sie weitere Informationen dar=C3=BCber, wie Sie diese Spende auf Ihr
Bankkonto erhalten.

KONTAKT-E-MAIL: robertbaileys_spende@aol.com

Gr=C3=BC=C3=9Fe,
Robert Bailey
* * * * * * * * * * * * * * * * * * * *
Powerball-Jackpot-Gewinner
E-Mail: robertbaileys_spende@aol.com
