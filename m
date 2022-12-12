Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C297B649D82
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 12:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiLLLYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 06:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbiLLLX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 06:23:57 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CDAD42
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 03:23:30 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-144bd860fdbso8011321fac.0
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 03:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XndZCgfQr2EAqckT1ow5ymFEBGbp27yY+QT4+I2szOc=;
        b=Pz30krcR8sqcT6NHYw2zCG7R8fw7wBvnLsdBNGZ5dNE+oDuRIw8rf3OLk9PB7AiBrI
         kdmbZB6pZ0canojOZOTbIdl3A0PCDOlA5lTNI0dtBo2RaMraXVTTfrrczg0UlRr4U/0o
         O5xFYHvEYra0cELgmK6wGY8jw4L1U4/fApcyRodkTE5D0ARYD6bWsddMIECbm0Mq16aC
         4jpb22ju7V5k9oQ2J3CiT9XcmBAlycoH0aNCXDN9+kPsqEknLSy2Ms3JYzPSNNqW4mFA
         xl+Rpw9jOZKxyKo7ioltBP6pD1CMgh9HnrHqK4ZTkBVLrtHzyhBNBFtWf8q0lwPRGDGU
         uPTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XndZCgfQr2EAqckT1ow5ymFEBGbp27yY+QT4+I2szOc=;
        b=pG0VvpeG/oFy5I7Q9mEyAHsMMHrAsMyul9EPRqWtxtc+r/M5EoD+2bnp8Si5JNfqjY
         j3Zfb/euMQaF3y/6qjAUMZrv3bYimzTaQ2Is12kt3YL87olkTTU4s1Xn0RssPiMetHRf
         LU+y2cpCWEey1EIcV7SstyfxXWCnk2oAlPQVJuDCvv9S1GjjKo29weNiU5peq17ZVI9P
         XEY0zgX+XfTMisX+RMkRUgFUGG3B4Hhx99JRi9O8kWkMoOngXjvXaX2vvFRhZJn0BWcA
         lRzF8+MmyPnWzfefeyvHpJZ5MOEJhmD+SQ4xYo0k4GhtClufCj8bERAN/tUmGoW5/ENd
         tbTA==
X-Gm-Message-State: ANoB5pmYiIhe+w3tbOmGBwP3lTCm//x+2V6R9PyZbx+r9xTdfbD7A0q7
        lGOJMnRX4ts215YyKBuNJGV2J0nkwjRrr6co7Mo=
X-Google-Smtp-Source: AA0mqf7xgIdBN2fGaHCKQ3Mx5f0M4dcVRf4wmNGNinpbR9aZexWgd/w1u0Zyb/FOQyh8Ls1Y9EVNzFUN+fQPn80CTU4=
X-Received: by 2002:a05:6870:5ccb:b0:145:a6c:a9ea with SMTP id
 et11-20020a0568705ccb00b001450a6ca9eamr850424oab.238.1670844209768; Mon, 12
 Dec 2022 03:23:29 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:a0d:0:0:0:0 with HTTP; Mon, 12 Dec 2022 03:23:29
 -0800 (PST)
Reply-To: jesspayne72@gmail.com
From:   Jess Payne <yilinw628@gmail.com>
Date:   Mon, 12 Dec 2022 03:23:29 -0800
Message-ID: <CAE-2KLsV1d1Vo4bzzp4rhbTdC=qptRCtLo49Z6t4rSi31KztPw@mail.gmail.com>
Subject: =?UTF-8?B?5oiR6ZyA6KaB5L2g55qE5biu5Yqp?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=7.7 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:32 listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [yilinw628[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jesspayne72[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [yilinw628[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

5oiR5biM5pyb5L2g6IO955CG6Kej6L+Z5p2h5raI5oGv77yM5Zug5Li65oiR5q2j5Zyo5L2/55So
57+76K+R5Zmo57uZ5L2g5YaZ5L+h44CCDQoNCuaIkeaYryBKZXNzIFBheW5lIOS4reWjq+OAgg0K
DQrlnKjnvo7lm73pmYblhpvnmoTlhpvkuovpg6jpl6jjgIIg576O5Zu977yM5LiA5ZCN5Lit5aOr
77yMMzEg5bKB77yM5Y2V6Lqr77yM5p2l6Ieq576O5Zu95L+E5Lql5L+E5bee5YWL5Yip5aSr5YWw
5biC77yM55uu5YmN5LiO5ZCM5LqL5LiA6LW35Zyo5Yip5q+U5Lqa54+t5Yqg6KW/5omn6KGM5LiA
6aG554m55q6K5Lu75Yqh44CCDQoNCuaIkeaYr+S4gOS4quacieeIseW/g+OAgeivmuWunuWSjOa3
seaDheeahOS6uu+8jOacieW+iOWlveeahOW5vem7mOaEn++8jOaIkeWWnOasoue7k+ivhuaWsOac
i+WPi+W5tuS6huino+S7luS7rOeahOeUn+a0u+aWueW8j++8jOaIkeWWnOasoueci+Wkp+a1t+ea
hOazoua1quWSjOe+pOWxseeahOe+juaZr+S7peWPiuWkp+iHqueEtueahOS4gOWIhyDmj5Dkvpvj
gIINCuW+iOmrmOWFtOiDveabtOWkmuWcsOS6huino+S9oO+8jOaIkeiupOS4uuaIkeS7rOWPr+S7
peW7uueri+iJr+WlveeahOWVhuS4muWPi+iwiuOAgg0KDQrmiJHkuIDnm7TlvojkuI3lvIDlv4Pv
vIzlm6DkuLrlpJrlubTmnaXnlJ/mtLvlr7nmiJHkuI3lhazlubPvvJsg5oiR5ZyoIDIxIOWygemC
o+W5tOWkseWOu+S6hueItuavjeOAgiDmiJHniLbkurLnmoTlkI3lrZfmmK/luJXnibnph4zlhYvk
vanmganlkozmiJHnmoTmr43kurLnjpvkuL3kvanmganjgIINCuayoeacieS6uuW4ruWKqeaIke+8
jOS9huaIkeW+iOmrmOWFtOaIkee7iOS6juWcqOe+juWGm+S4reaJvuWIsOS6huiHquW3seOAgg0K
DQrmiJHnu5PkuoblqZrvvIzmnInkuoblranlrZDvvIzkvYbku5bljrvkuJbkuobvvIzkuI3kuYXl
kI7miJHkuIjlpKvlvIDlp4vlh7rovajvvIzmiYDku6XmiJHkuI3lvpfkuI3mlL7lvIPlqZrlp7vj
gIINCg0K5Zyo5oiR55qE5Zu95a62576O5Zu95ZKM5Yip5q+U5Lqa54+t5Yqg6KW/6L+Z6YeM77yM
5oiR5Lmf5b6I5bm46L+Q77yM5oul5pyJ55Sf5rS75omA6ZyA55qE5LiA5YiH77yM5L2G5rKh5pyJ
5Lq657uZ5oiR5bu66K6u44CCIOaIkemcgOimgeS4gOS4quivmuWunueahOS6uuadpeS/oeS7u+S7
lu+8jOS7luS5n+S8mue7meaIkeW7uuiuruWmguS9leaKlei1hOOAgg0K5Zug5Li65oiR5piv5oiR
54i25q+N55Sf5YmN5ZSv5LiA55Sf5LiL55qE5aWz5a2p44CCDQoNCuaIkeS4jeiupOivhuS9oOac
rOS6uu+8jOS9huaIkeiupOS4uuacieS4gOS4quWAvOW+l+S/oei1lueahOWlveS6uu+8jOS7luWP
r+S7peW7uueri+ecn+ato+eahOS/oeS7u+WSjOiJr+WlveeahOWVhuS4muWPi+iwiu+8jOWmguae
nOS9oOecn+eahOacieivmuWunuWSjOivmuWunueahOWQjeWjsO+8jOaIkeS5n+acieS4gOS6m+S4
nOilv+imgeWSjOS9oOWIhuS6qw0K55u45L+h44CCIOWcqOS9oOi6q+S4iu+8jOWboOS4uuaIkemc
gOimgeS9oOeahOW4ruWKqeOAgiDmiJHmi6XmnInmiJHlnKjliKnmr5Tkuprnj63liqDopb/otZrl
iLDnmoTmgLvlkozvvIg0NzAg5LiH576O5YWD77yJ44CCDQrmiJHkvJrlnKjkuIvkuIDlsIHnlLXl
rZDpgq7ku7bkuK3lkYror4nmgqjmiJHmmK/lpoLkvZXlgZrliLDnmoTvvIzkuI3opoHmg4rmhYzv
vIzlroPku6zmsqHmnInpo47pmanvvIzogIzkuJTmiJHov5jlnKjkuI7nuqLoibLmnInogZTns7vn
moTkurrpgZPkuLvkuYnljLvnlJ/nmoTluK7liqnkuIvlsIbov5nnrJTpkrHlrZjlhaXkuobpk7bo
oYzjgIINCuaIkeW4jOacm+S9oOS9nOS4uuaIkeeahOWPl+ebiuS6uuadpeaOpeaUtuWfuumHke+8
jOW5tuWcqOaIkeWujOaIkOi/memHjOeahOW3peS9nOWQjuWmpeWWhOS/neeuoeWug++8jOW5tuiO
t+W+l+aIkeeahOWGm+S6i+mAmuihjOivge+8jOS7peS+v+WcqOS9oOeahOWbveWutuS4juS9oOS8
mumdou+8mw0K5LiN6KaB5ouF5b+D6ZO26KGM5Lya6YCa6L+H55S15rGH5bCG6LWE6YeR6L2s57uZ
5oKo77yM6L+Z5a+55oiR5Lus5p2l6K+05pei5a6J5YWo5Y+I5b+r5o2344CCDQoNCueslOiusDsg
5oiR5LiN55+l6YGT5oiR5Lus6KaB5Zyo6L+Z6YeM5b6F5aSa5LmF5Lul5Y+K5oiR55qE5ZG96L+Q
77yM5Zug5Li65oiR5Zyo6L+Z6YeM5Lik5qyh54K45by56KKt5Ye75Lit5bm45a2Y5LiL5p2l77yM
6L+Z5L+D5L2/5oiR5a+75om+5LiA5Liq5YC85b6X5L+h6LWW55qE5Lq65p2l5biu5Yqp5oiR5o6l
5pS25ZKM5oqV6LWE5Z+66YeR77yM5Zug5Li65oiR5bCG5p2l5Yiw6LS15Zu9DQrlh7rouqvmipXo
tYTvvIzlvIDlp4vmlrDnmoTnlJ/mtLvvvIzkuI3lho3lvZPlhbXjgIINCg0K5aaC5p6c5oKo5oS/
5oSP6LCo5oWO5aSE55CG77yM6K+35Zue5aSN5oiR44CCIOaIkeS8muWRiuivieS9oOaOpeS4i+ad
peeahOa1geeoi++8jOW5tuWQkeS9oOWPkemAgeabtOWkmuacieWFs+WtmOWFpei1hOmHkeeahOmT
tuihjOeahOS/oeaBr+OAgg0K5Lul5Y+K6ZO26KGM5bCG5aaC5L2V5biu5Yqp5oiR5Lus6YCa6L+H
55S15rGH5bCG6LWE6YeR6L2s56e75Yiw5oKo5omA5Zyo55qE5Zu95a62L+WcsOWMuu+8jOi/meS5
n+aYr+mTtuihjOWIsOmTtuihjOeahOi9rOi0puOAgiDoi6XmnInlhbTotqPor7fogZTns7vmnKzk
urrjgIINCg==
