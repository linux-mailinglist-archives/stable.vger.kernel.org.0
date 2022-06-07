Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75C354022D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 17:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243884AbiFGPNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 11:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239925AbiFGPNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 11:13:51 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C271E3E4
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 08:13:49 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id gl15so21990478ejb.4
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 08:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=i/SuxAwOXiJzhOAxxc15cveCQd5XdNrs1UZ5Tv+sksg=;
        b=lXngIvipO/ffeeE2v3H7QXpdeAGMxQkii9RTqv1RAt1Ds2zrA0ma+F9OLYSuN9YmTk
         qQs52oZydFWaDzFgGgX6FVfBSqyf6ztYo3dRtkMMEiqF1qeq9aHyNjsbg88AqxlpDoZm
         CR2xs0pMR0zZzSBw+jXMp04urQsRv7O3xe5aLFkdVICm80GHdcJ5oiUkiTfWe6Yj8a53
         8gyNSpc8b+foAF6Qtb4qjwZ+D8IeZqXLU2lAO7ZEXN5ksySszg2coRdPF7M9RsxW/NWI
         YqC+pNroRcli7phEI/GQrMD55nMq6FgRzVtzyITW0T77eUlQHXO6xW2KE7s2yO3dJVU9
         vpSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=i/SuxAwOXiJzhOAxxc15cveCQd5XdNrs1UZ5Tv+sksg=;
        b=QK9430jqHBSYzUC1qYESGOnDgsc6B40qDJguWHGyekt+MHNd1S942IPiQLDRNxKYzl
         YpxV43+b66bdqWMxQb2MLFEXbhGlKyJa7CsBqyOY915vPerp3zmDNB97bax7J/nW305a
         ZgPtcwTOySnRzh12vkDGB88V7p1vzVh/LEx12TFkMY+jopu8DkE6oM4t4HpaMBoUKK8r
         y8opl29ZfELgYd7UNx/7OimaeEUT/Ith8Nb+ILG5ARW8fMmVjNevI1KaO3Kgr9lxlXKu
         dbKFT/HNVqe/HEf/2M/fPjhU2ybz2J/DSRubHSRiPx/QglSkCJg/9Pl4oVirZNNf/R49
         CFpA==
X-Gm-Message-State: AOAM5333cg6nJoUBBlBX1kt4xfbQlMat0jdfF71/Jei0yeH7IkR4k+Rp
        TqkmIA1MyUXgES/H1jpB5Izq+abkwUwcv6WxgAs=
X-Google-Smtp-Source: ABdhPJxCM6WKugmHlr+78KpSUPgBYE0MXPX7C8caTnaJu0SCIfgEOdEOJWYqmlTWzCe1T5Hn4l9SI7FijJA3BvKIJNU=
X-Received: by 2002:a17:907:7fa5:b0:711:c8e2:2f4c with SMTP id
 qk37-20020a1709077fa500b00711c8e22f4cmr12294756ejc.49.1654614827315; Tue, 07
 Jun 2022 08:13:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:907:1c23:0:0:0:0 with HTTP; Tue, 7 Jun 2022 08:13:45
 -0700 (PDT)
Reply-To: jesspayne72@gmail.com
From:   Jess Payne <pw5105644@gmail.com>
Date:   Tue, 7 Jun 2022 16:13:45 +0100
Message-ID: <CAOvk-TuMqSmS_Hm6S2UupAOMscHpcL8hShxhq8EOXf6V0pSUFQ@mail.gmail.com>
Subject: =?UTF-8?B?5oiR6ZyA6KaB5L2g55qE5biu5Yqp44CC?=
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
        *      [2a00:1450:4864:20:0:0:0:633 listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [pw5105644[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [pw5105644[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jesspayne72[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
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

5oiR5biM5pyb5L2g6IO955CG6Kej6L+Z5p2h5L+h5oGv77yM5Zug5Li65oiR5q2j5Zyo5L2/55So
57+76K+R57uZ5L2g5YaZ5L+h44CCDQoNCuaIkeaYr+adsOilv8K35L2p5oGp5Lit5aOr5aSr5Lq6
44CCDQoNCuWcqOe+juWbvemZhuWGm+eahOWGm+S6i+mDqOmXqOOAgue+juWbve+8jOS4gOWQjeS4
reWjq++8jDMyIOWyge+8jOaIkeWNlei6q++8jOadpeiHque+juWbveeUsOe6s+ilv+W3nuWFi+WI
qeWkq+WFsOW4gu+8jOebruWJjeS4juaIkeeahOWQjOS6i+WcqOWIqeavlOS6muePreWKoOilv+aJ
p+ihjOS4gOmhueeJueauiuS7u+WKoeOAgg0KDQrmiJHmmK/kuIDkuKrlhYXmu6HniLHlv4PjgIHo
r5rlrp7lkozmt7Hmg4XnmoTkurrvvIzlhbfmnInoia/lpb3nmoTlub3pu5jmhJ/vvIzmiJHllpzm
rKLnu5Por4bmlrDmnIvlj4vlubbkuobop6Pku5bku6znmoTnlJ/mtLvmlrnlvI/vvIzmiJHllpzm
rKLnnIvliLDlpKfmtbfnmoTms6LmtpvlkozlsbHohInnmoTnvo7kuL3ku6Xlj4rlpKfoh6rnhLbm
iYDmi6XmnInnmoTkuIDliIfmj5DkvpvjgILlvojpq5jlhbTog73mm7TlpJrlnLDkuobop6Pmgqjv
vIzmiJHorqTkuLrmiJHku6zlj6/ku6Xlu7rnq4voia/lpb3nmoTllYbkuJrlj4vosIrjgIINCg0K
5oiR5LiA55u05b6I5LiN5byA5b+D77yM5Zug5Li65Yeg5bm05p2l55Sf5rS75a+55oiR5LiN5YWs
5bmz77yb5oiR5ZyoIDIxDQrlsoHml7blpLHljrvkuobniLbmr43jgILmiJHniLbkurLnmoTlkI3l
rZfmmK/luJXnibnph4zmlq/kvanmganlkozmiJHnmoTmr43kurLnjpvkuL3kvanmganjgILmsqHm
nInkurrluK7liqnmiJHvvIzkvYbmiJHlvojpq5jlhbTmiJHnu4jkuo7lnKjnvo7lhpvkuK3mib7l
iLDkuoboh6rlt7HjgIINCg0K5oiR57uT5ama55Sf5LqG5LiA5Liq5a2p5a2Q77yM5L2G5LuW5Y67
5LiW5LqG77yM5Zyo5oiR5LiI5aSr5byA5aeL6IOM5Y+b5oiR5ZCO5LiN5LmF77yM5oiR5LiN5b6X
5LiN5pS+5byD5ama5ae744CCDQoNCuaIkeS5n+W+iOW5uOi/kOWcqOaIkeeahOWbveWutue+juWb
veWSjOWIqeavlOS6muePreWKoOilv+i/memHjOaLpeacieaIkeeUn+a0u+S4remcgOimgeeahOS4
gOWIh++8jOS9huayoeacieS6uue7meaIkeW7uuiuruOAguaIkemcgOimgeS4gOS4quivmuWunuea
hOS6uuadpeS/oeS7u++8jOS7luS5n+S8muW7uuiuruaIkeWmguS9leaKlei1hOaIkeeahOmSseOA
guWboOS4uuaIkeaYr+aIkeeItuavjeWcqOS7luS7rOatu+WJjeeUn+S4i+eahOWUr+S4gOS4gOS4
quWls+WtqeOAgg0KDQrmiJHkuI3orqTor4bkvaDvvIzkvYbmiJHorqTkuLrmnInkuIDkuKrlj6/k
u6Xkv6Hku7vnmoTlpb3kurrvvIzlj6/ku6Xlu7rnq4vnnJ/mraPnmoTkv6Hku7vlkozoia/lpb3n
moTllYbkuJrlj4vosIrvvIzlpoLmnpzkvaDnnJ/nmoTmnInkuIDkuKror5rlrp7nmoTlkI3lrZfv
vIzmiJHkuZ/mnInkuIDkupvkuovmg4XopoHlkozkvaDliIbkuqvnm7jkv6HjgILlnKjkvaDouqvk
uIrvvIzlm6DkuLrmiJHpnIDopoHkvaDnmoTluK7liqnjgILmiJHmi6XmnInmiJHlnKjliKnmr5Tk
uprnj63liqDopb/otZrliLDnmoTmgLvpop3vvIg0NzANCuS4h+e+juWFg++8ieOAguaIkeWwhuWc
qOS4i+S4gOWwgeeUteWtkOmCruS7tuS4reWRiuivieS9oOaIkeaYr+WmguS9leWBmuWIsOeahO+8
jOS4jeimgeaDiuaFjO+8jOWug+S7rOaYr+aXoOmjjumZqeeahO+8jOaIkei/mOWcqOS4jiBSZWQN
CuacieiBlOezu+eahOS6uumBk+S4u+S5ieWMu+eUn+eahOW4ruWKqeS4i+Wwhui/meeslOmSseWt
mOWFpeS6huS4gOWutumTtuihjOOAguaIkeW4jOacm+S9oOS7peaIkeeahOWPl+ebiuS6uui6q+S7
veaOpeWPl+WfuumHke+8jOW5tuWcqOaIkeWcqOi/memHjOWujOaIkOWQjuWmpeWWhOS/neeuoeWu
g++8jOW5tuiOt+W+l+aIkeeahOWGm+S6i+mAmuihjOivge+8jOS7peS+v+WcqOS9oOeahOWbveWu
tuS4juS9oOS8mumdou+8m+S4jeimgeWus+aAlemTtuihjOS8mumAmui/h+eUteaxh+Wwhui1hOmH
kei9rOe7meaCqO+8jOi/meWvueaIkeS7rOadpeivtOWuieWFqOS4lOW/q+aNt+OAgg0KDQrnrJTo
rrA75oiR5LiN55+l6YGT5oiR5Lus6KaB5Zyo6L+Z6YeM5b6F5aSa5LmF5ZKM5oiR55qE5ZG96L+Q
77yM5Zug5Li65oiR5Zyo6L+Z6YeM5bm45YWN5LqO5Lik5qyh54K45by56KKt5Ye777yM6L+Z5a+8
6Ie05oiR5a+75om+5LiA5Liq5YC85b6X5L+h6LWW55qE5Lq65p2l5biu5Yqp5oiR5o6l5pS25ZKM
5oqV6LWE5Z+66YeR77yM5Zug5Li65oiR5bCG5p2l5Yiw5L2g55qE5Zu95a625Ye66Lqr5oqV6LWE
77yM5byA5aeL5paw55Sf5rS777yM5LiN5YaN5b2T5YW144CCDQoNCuWmguaenOaCqOaEv+aEj+iw
qOaFjuWkhOeQhu+8jOivt+WbnuWkjeaIkeOAguaIkeS8muWRiuivieS9oOaOpeS4i+adpeeahOa1
geeoi++8jOW5tue7meS9oOWPkemAgeabtOWkmuWFs+S6juWfuumHkeWtmOWFpemTtuihjOeahOS/
oeaBr+OAguS7peWPiumTtuihjOWwhuWmguS9leW4ruWKqeaIkeS7rOmAmui/h+eUteaxh+Wwhui1
hOmHkei9rOenu+WIsOaCqOeahOWbveWutu+8jOeUteaxh+S5n+aYr+mTtuihjOWIsOmTtuihjOea
hOi9rOW4kOOAguiLpeacieWFtOi2o+ivt+iBlOezu+acrOS6uuOAgg0K
