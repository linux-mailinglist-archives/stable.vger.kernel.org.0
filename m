Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E954968D6FB
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjBGMlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjBGMlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:41:00 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BB2EFB2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:40:46 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id r28so12491342oiw.3
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 04:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=15KzPvmOdTlQWGaEcDJ9OBFjd6pRc6oCKubZtMiRsms=;
        b=IwIXSKYYOZWTf95zklEEgGMBCM+Al2/w6Y5Gq+Hk0qWWVtIJyZUCzzqH+KBumriiBe
         G7MWpXq4qiAITbEvv5HG1StduHvEtfBBHPrQcOGpeqZWrLbzG/hUmWH+O1vUUVHlGz1i
         hrCj7HpUtD433M1Pf+XJfVHBbdzajvqqWHwyap3+w0HsMQSmXd0fveGnROOR5gXxh+qO
         SsyPtSaF2CTvLrjTWMfR6AJpoWoyNPuYcOh3BCNyJgIyyhJheCzfTuimsj81Zu9Gied6
         MD0j/xnneMcbYXZjykYg1do7SDdFwIrAa3mojf8UCghtrRGkOYPez0Upiac2OJgQEKvJ
         aPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=15KzPvmOdTlQWGaEcDJ9OBFjd6pRc6oCKubZtMiRsms=;
        b=rnWwCTTA06j/O8YSJXuA7nb7IaXFv7Y62g9W0q9zwGeVCFpzJ0eD6xnOMWPeqbA7MZ
         eejO/+roAGlTBzfaW25zV9Qff98GX4gayimD2AOCWjb/e5QlfoGlS9OKdyyrCBxqbIic
         NPIfwaxlEMbvFwwcTQUb8gydym5LZiQBY4sZBT0lSvP0pF+vxX8/Hk5XGwJSACDcWhJ5
         xaeN6XPM2YmCfkMPvoYH1nN+iKc3wDgXNRS//PhJayfO7cs4/FUdYID5XGHZ9XBA4LG4
         QLcQbN8wTd2iEdSOHBQ0fwybO5I/Ncyr722XU59W0FBlAjtdm5h7AKYnpSUR7FbjN7ie
         zbbg==
X-Gm-Message-State: AO0yUKXHjOMvoiP4yTfeU+wj7nYLFLQ+E2ZBiF3F9XiOZ0QsYGeW2t5x
        7W5coecg1Hti5TxxwMRw5cUGfX14ErfGnWNbjGo=
X-Google-Smtp-Source: AK7set9aIz2Lvw44xePKWHF6ciEuLGG/hqJJuHi+l+iKQlJ22R3luVpALAU39gug634rj5Ttilltja+UzcoLAaA7NV4=
X-Received: by 2002:a05:6808:424d:b0:36e:f9d4:a488 with SMTP id
 dp13-20020a056808424d00b0036ef9d4a488mr289566oib.239.1675773646162; Tue, 07
 Feb 2023 04:40:46 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6358:3628:b0:ed:16f6:56f4 with HTTP; Tue, 7 Feb 2023
 04:40:45 -0800 (PST)
Reply-To: jessicapayne814@gmail.com
From:   Jessica Payne <alicesambo279@gmail.com>
Date:   Tue, 7 Feb 2023 04:40:45 -0800
Message-ID: <CAMi2s73x6D7eNZDjpXi-5D0h5F8MOmmb7xEPTpnUuskTpJ3BGw@mail.gmail.com>
Subject: =?UTF-8?B?5oiR6ZyA6KaB5L2g55qE5biu5Yqp?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:230 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [alicesambo279[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [alicesambo279[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jessicapayne814[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

5oiR5piv5p2w6KW/5Y2hwrfkvanmgankuK3lo6vlpKvkurrjgIINCg0K5Zyo576O5Zu96ZmG5Yab
55qE5Yab5LqL6YOo6Zeo44CCIOe+juWbve+8jOS4gOWQjeS4reWjq++8jDMyIOWyge+8jOWNlei6
q++8jOadpeiHque+juWbveS/hOS6peS/hOW3nuWFi+WIqeWkq+WFsOW4gu+8jOebruWJjeS4juWQ
jOS6i+S4gOi1t+WcqOWIqeavlOS6muePreWKoOilv+aJp+ihjOS4gOmhueeJueauiuS7u+WKoeOA
gg0KDQrmiJHmmK/kuIDkuKrmnInniLHlv4PjgIHor5rlrp7lkozmt7Hmg4XnmoTkurrvvIzmnInl
vojlpb3nmoTlub3pu5jmhJ/vvIzmiJHllpzmrKLnu5Por4bmlrDmnIvlj4vlubbkuobop6Pku5bk
u6znmoTnlJ/mtLvmlrnlvI/vvIzmiJHllpzmrKLnnIvlpKfmtbfnmoTms6LmtarlkoznvqTlsbHn
moTnvo7mma/ku6Xlj4rlpKfoh6rnhLbnmoTkuIDliIcg5o+Q5L6b44CCDQrlvojpq5jlhbTog73m
m7TlpJrlnLDkuobop6PkvaDvvIzmiJHorqTkuLrmiJHku6zlj6/ku6Xlu7rnq4voia/lpb3nmoTl
lYbkuJrlj4vosIrjgIINCg0K5oiR5LiA55u05b6I5LiN5byA5b+D77yM5Zug5Li65aSa5bm05p2l
55Sf5rS75a+55oiR5LiN5YWs5bmz77ybIOaIkeWcqCAyMSDlsoHpgqPlubTlpLHljrvkuobniLbm
r43jgIIg5oiR54i25Lqy55qE5ZCN5a2X5piv5biV54m56YeM5YWL5L2p5oGp5ZKM5oiR55qE5q+N
5Lqy546b5Li95L2p5oGp44CCDQrmsqHmnInkurrluK7liqnmiJHvvIzkvYbmiJHlvojpq5jlhbTm
iJHnu4jkuo7lnKjnvo7lhpvkuK3mib7liLDkuoboh6rlt7HjgIINCg0K5oiR57uT5LqG5ama77yM
5pyJ5LqG5a2p5a2Q77yM5L2G5LuW5Y675LiW5LqG77yM5LiN5LmF5ZCO5oiR5LiI5aSr5byA5aeL
5Ye66L2o77yM5omA5Lul5oiR5LiN5b6X5LiN5pS+5byD5ama5ae744CCDQoNCuWcqOaIkeeahOWb
veWutue+juWbveWSjOWIqeavlOS6muePreWKoOilv+i/memHjO+8jOaIkeS5n+W+iOW5uOi/kO+8
jOaLpeacieeUn+a0u+aJgOmcgOeahOS4gOWIh++8jOS9huayoeacieS6uue7meaIkeW7uuiuruOA
giDmiJHpnIDopoHkuIDkuKror5rlrp7nmoTkurrmnaXkv6Hku7vku5bvvIzku5bkuZ/kvJrnu5nm
iJHlu7rorq7lpoLkvZXmipXotYTjgIINCuWboOS4uuaIkeaYr+aIkeeItuavjeeUn+WJjeWUr+S4
gOeUn+S4i+eahOWls+WtqeOAgg0KDQrmiJHkuI3orqTor4bkvaDmnKzkurrvvIzkvYbmiJHorqTk
uLrmnInkuIDkuKrlgLzlvpfkv6HotZbnmoTlpb3kurrvvIzku5blj6/ku6Xlu7rnq4vnnJ/mraPn
moTkv6Hku7vlkozoia/lpb3nmoTllYbkuJrlj4vosIrvvIzlpoLmnpzkvaDnnJ/nmoTmnInor5rl
rp7lkozor5rlrp7nmoTlkI3lo7DvvIzmiJHkuZ/mnInkuIDkupvkuJzopb/opoHlkozkvaDliIbk
uqsNCuebuOS/oeOAgiDlnKjkvaDouqvkuIrvvIzlm6DkuLrmiJHpnIDopoHkvaDnmoTluK7liqnj
gIIg5oiR5oul5pyJ5oiR5Zyo5Yip5q+U5Lqa54+t5Yqg6KW/6LWa5Yiw55qE5oC75ZKM77yINTcw
IOS4h+e+juWFg++8ieOAgg0K5oiR5Lya5Zyo5LiL5LiA5bCB55S15a2Q6YKu5Lu25Lit5ZGK6K+J
5oKo5oiR5piv5aaC5L2V5YGa5Yiw55qE77yM5LiN6KaB5oOK5oWM77yM5a6D5Lus5rKh5pyJ6aOO
6Zmp77yM6ICM5LiU5oiR6L+Y5Zyo5LiO57qi6Imy5pyJ6IGU57O755qE5Lq66YGT5Li75LmJ5Yy7
55Sf55qE5biu5Yqp5LiL5bCG6L+Z56yU6ZKx5a2Y5YWl5LqG6ZO26KGM44CCDQrmiJHluIzmnJvk
vaDkvZzkuLrmiJHnmoTlj5fnm4rkurrmnaXmjqXmlLbln7rph5HvvIzlubblnKjmiJHlrozmiJDo
v5nph4znmoTlt6XkvZzlkI7lpqXlloTkv53nrqHlroPvvIzlubbojrflvpfmiJHnmoTlhpvkuovp
gJrooYzor4HvvIzku6Xkvr/lnKjkvaDnmoTlm73lrrbkuI7kvaDkvJrpnaLvvJsNCuS4jeimgeaL
heW/g+mTtuihjOS8mumAmui/h+eUteaxh+Wwhui1hOmHkei9rOe7meaCqO+8jOi/meWvueaIkeS7
rOadpeivtOaXouWuieWFqOWPiOW/q+aNt+OAgg0KDQrnrJTorrA7IOaIkeS4jeefpemBk+aIkeS7
rOimgeWcqOi/memHjOW+heWkmuS5heS7peWPiuaIkeeahOWRvei/kO+8jOWboOS4uuaIkeWcqOi/
memHjOS4pOasoeeCuOW8ueiireWHu+S4reW5uOWtmOS4i+adpe+8jOi/meS/g+S9v+aIkeWvu+aJ
vuS4gOS4quWAvOW+l+S/oei1lueahOS6uuadpeW4ruWKqeaIkeaOpeaUtuWSjOaKlei1hOWfuumH
ke+8jOWboOS4uuaIkeWwhuadpeWIsOi0teWbvQ0K5Ye66Lqr5oqV6LWE77yM5byA5aeL5paw55qE
55Sf5rS777yM5LiN5YaN5b2T5YW144CCDQoNCuWmguaenOaCqOaEv+aEj+iwqOaFjuWkhOeQhu+8
jOivt+WbnuWkjeaIkeOAgiDmiJHkvJrlkYror4nkvaDmjqXkuIvmnaXnmoTmtYHnqIvvvIzlubbl
kJHkvaDlj5HpgIHmm7TlpJrmnInlhbPlrZjlhaXotYTph5HnmoTpk7booYznmoTkv6Hmga/jgIIN
CuS7peWPiumTtuihjOWwhuWmguS9leW4ruWKqeaIkeS7rOmAmui/h+eUteaxh+Wwhui1hOmHkei9
rOenu+WIsOaCqOaJgOWcqOeahOWbveWuti/lnLDljLrvvIzov5nkuZ/mmK/pk7booYzliLDpk7bo
oYznmoTovazotKbjgIIg5aaC5p6c5L2g5pyJ5YW06Laj77yM6K+35LiO5oiR6IGU57O744CCDQo=
