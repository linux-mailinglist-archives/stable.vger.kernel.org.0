Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C299153DE1D
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 21:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiFETwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 15:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344175AbiFETwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 15:52:45 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2C0140E9
        for <stable@vger.kernel.org>; Sun,  5 Jun 2022 12:52:44 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id h72so3842270iof.11
        for <stable@vger.kernel.org>; Sun, 05 Jun 2022 12:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3x72/ah7oVy1n7hZQ2TRq4JYjiu8oyFxE5Jon1kCtcA=;
        b=QiePSIkILAnUEPV9awij3cpmCBz/Ro60CK6KrQGI5bxc3C85/fc/DzkAoIaOByChpG
         kQxV7Al2dBvyRR0CJ5CKynMKtnYMZ3Ox/32ZP2Vp4BfvX3LxTJzHUR+ShbZ2ryDxTRLd
         oOVQw/m3gRemi+uHFCi5U7NjP/ibdtmn50n7TXk9nESOQVP3jYBQ5cTtwf9DpznabgZB
         vhZ9ppUERWyjLc0Zzw8nPGGmgOlH+RAhlLsus8LMGd+URNXft71IwDFxrkhXeO2MpkH2
         +ogjvDyKl8fTFMHcn1ZkSxCizk+jZ9CrYBqLnNTq+ppY5D93vmeh3wSGSjJYEOJGbDen
         q4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=3x72/ah7oVy1n7hZQ2TRq4JYjiu8oyFxE5Jon1kCtcA=;
        b=k/UQ8dhswQ7g4eLMsL7aH/sk8dxo+XofIxMMb5HmrcPX4E1G/caT60PtQ56/ZPAncf
         kaLZGeK7ZYoda/+NZCnHEqZaQm8jVrhp9c3m8osKNGrD3L9M+TM5c8R7XI3U4l5WmPG1
         fgC2lFiuWn6aAbP0+cR72mEk7HSpPuChCLJl3+89ecZGLvcQ3byvYSmWXwZX0G8PVNhN
         SCihKgbJvjew2LrXqf5LGkGonoKNrXtDbOkn/i/sIcwlBYwjahvbtyFjg+ne0l9T4ykh
         kcGlRKWc7jQX0uo6dlnzecfsPmDj7e6/Qe2HhAVw6FZL0fDKOdFfa9l9Ds7cXpOy6WDz
         pe1g==
X-Gm-Message-State: AOAM5317w/hmZ2UF6tm+rl+YRlwOmqT6/HgZWlhQZIJXoUrpIjwqjTZu
        OKWe4Q/t85mhqhaeJD17noTUcT3ocyEyuptZhxA=
X-Google-Smtp-Source: ABdhPJxF0b3kd4u5CVLKWMtukCWZk1OHnEM97mtT3ri6Ky/yjxExVrg/uFtiX/p2ReWcq6P/Zp7mP+zfLpCLfhvvpZQ=
X-Received: by 2002:a02:cca3:0:b0:331:7566:28cf with SMTP id
 t3-20020a02cca3000000b00331756628cfmr7910835jap.99.1654458763960; Sun, 05 Jun
 2022 12:52:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6638:1650:0:0:0:0 with HTTP; Sun, 5 Jun 2022 12:52:43
 -0700 (PDT)
Reply-To: mrstheresaheidi8@gmail.com
From:   Ms Theresa Heidi <rev.johnpatrick1@gmail.com>
Date:   Sun, 5 Jun 2022 12:52:43 -0700
Message-ID: <CAMiB5XhHvpRztdY_hoY_EgTtcpE4dipSTHssJ+qudh03CLK1Rw@mail.gmail.com>
Subject: =?UTF-8?B?5oCl5LqL5rGC5Yqp77yB?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=7.3 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d2c listed in]
        [list.dnswl.org]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 0.9990]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 0.9990]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [rev.johnpatrick1[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [rev.johnpatrick1[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrstheresaheidi8[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

5oWI5ZaE5o2Q5qy+77yBDQoNCuivt+S7lOe7humYheivu++8jOaIkeefpemBk+i/meWwgeS/oeeh
ruWunuWPr+iDveS8mue7meS9oOS4gOS4quaDiuWWnOOAgiDmiJHlnKjpnIDopoHkvaDluK7liqnn
moTml7blgJnpgJrov4fnp4HkurrmkJzntKLpgYfliLDkuobkvaDnmoTnlLXlrZDpgq7ku7bogZTn
s7vjgIINCuaIkeaAgOedgOayiemHjeeahOaCsuS8pOWGmei/meWwgemCruS7tue7meS9oO+8jOaI
kemAieaLqemAmui/h+S6kuiBlOe9keS4juS9oOiBlOezu++8jOWboOS4uuWug+S7jeeEtuaYr+ac
gOW/q+eahOayn+mAmuWqkuS7i+OAgg0KDQrmiJHmmK82MuWygeeahOeJueiVvuiOjirmtbfokoLl
pKvkurrvvIznm67liY3lm6DogrrnmYzlnKjku6XoibLliJfnmoTkuIDlrrbnp4Hnq4vljLvpmaLk
vY/pmaLmsrvnlpfjgIINCjTlubTliY3vvIzmiJHnmoTkuIjlpKvljrvkuJblkI7vvIzmiJHnq4vl
jbPooqvor4rmlq3lh7rmgqPmnInogrrnmYzvvIzku5bmiorku5bmiYDmnInnmoTkuIDliIfpg73n
lZnnu5nkuobmiJHjgIIg5oiR5bim552A5oiR55qE56yU6K6w5pys55S16ISR5Zyo5LiA5a625Yy7
6Zmi6YeM77yM5oiR5LiA55u05Zyo5o6l5Y+X6IK66YOo55mM55eH55qE5rK755aX44CCDQoNCuaI
keS7juaIkeW3suaVheeahOS4iOWkq+mCo+mHjOe7p+aJv+S6huS4gOeslOi1hOmHke+8jOWPquac
iTI1MOS4h+e+juWFg++8iDI1MOS4h+e+juWFg++8ieOAgueOsOWcqOW+iOaYjuaYvu+8jOaIkeat
o+WcqOaOpei/keeUn+WRveeahOacgOWQjuWHoOWkqe+8jOaIkeiupOS4uuaIkeS4jeWGjemcgOim
gei/meeslOmSseS6huOAgg0K5oiR55qE5Yy755Sf6K6p5oiR5piO55m977yM55Sx5LqO6IK655mM
55qE6Zeu6aKY77yM5oiR5LiN5Lya5oyB57ut5LiA5bm044CCDQoNCui/meeslOmSsei/mOWcqOWb
veWklumTtuihjO+8jOeuoeeQhuWxguS7peecn+ato+eahOS4u+S6uueahOi6q+S7veWGmeS/oee7
meaIke+8jOimgeaxguaIkeWHuumdouaUtumSse+8jOaIluiAheetvuWPkeaOiOadg+S5pu+8jOiu
qeWIq+S6uuS7o+aIkeaUtumSse+8jOWboOS4uuaIkeeUn+eXheS4jeiDvei/h+adpeOAgg0K5aaC
5p6c5LiN6YeH5Y+W6KGM5Yqo77yM6ZO26KGM5Y+v6IO95Lya5Zug5Li65L+d5oyB6L+Z5LmI6ZW/
5pe26Ze06ICM6KKr5rKh5pS26LWE6YeR44CCDQoNCuaIkeWGs+WumuS4juaCqOiBlOezu++8jOWm
guaenOaCqOaEv+aEj+W5tuacieWFtOi2o+W4ruWKqeaIkeS7juWkluWbvemTtuihjOaPkOWPlui/
meeslOmSse+8jOeEtuWQjuWwhui1hOmHkeeUqOS6juaFiOWWhOS6i+S4mu+8jOW4ruWKqeW8seWK
v+e+pOS9k+OAgg0K5oiR6KaB5L2g5Zyo5oiR5Ye65LqL5LmL5YmN55yf6K+a5Zyw5aSE55CG6L+Z
5Lqb5L+h5omY5Z+66YeR44CCIOi/meS4jeaYr+S4gOeslOiiq+ebl+eahOmSse+8jOS5n+ayoeac
iea2ieWPiueahOWNsemZqeaYrzEwMCXnmoTpo47pmanlhY3otLnkuI7lhYXliIbnmoTms5Xlvovo
r4HmmI7jgIINCg0K5oiR6KaB5L2g5ou/NDUl55qE6ZKx57uZ5L2g5Liq5Lq65L2/55So77yM6ICM
NTUl55qE6ZKx5bCG55So5LqO5oWI5ZaE5bel5L2c44CCDQrmiJHlsIbmhJ/osKLmgqjlnKjov5nk
u7bkuovkuIrmnIDlpKfnmoTkv6Hku7vlkozkv53lr4bvvIzku6Xlrp7njrDmiJHnmoTlhoXlv4Pm
hL/mnJvvvIzlm6DkuLrmiJHkuI3mg7PopoHku7vkvZXkvJrljbHlj4rmiJHmnIDlkI7nmoTmhL/m
nJvnmoTkuJzopb/jgIINCuaIkeW+iOaKseatie+8jOWmguaenOaCqOaUtuWIsOi/meWwgeS/oeWc
qOaCqOeahOWeg+WcvumCruS7tu+8jOaYr+eUseS6juacgOi/keeahOi/nuaOpemUmeivr+WcqOi/
memHjOeahOWbveWutuOAgg0KDQrkvaDkurLniLHnmoTlprnlprnjgIINCueJueiVvuiOjirmtbfo
koLlpKvkuroNCg==
