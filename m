Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF2053CD75
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 18:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbiFCQqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 12:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244665AbiFCQqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 12:46:33 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4066751E60
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 09:46:30 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id u2so6557622iln.2
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 09:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=i/SuxAwOXiJzhOAxxc15cveCQd5XdNrs1UZ5Tv+sksg=;
        b=hoX7CbUqR2PquPKhIwMcnVGYkOsQIPe2Rb+71lbwFN1Jkjh9Dy1tCHEnqWdynyWg82
         gCBOefLj4qYy1ANZHVspIJ3QL2b6tcVhsudIEacSzxr9VC8S6bQIRSHGzeKFAv5deAFZ
         JY2jbI5F3dQj+Mm+/2a3dW2CI4G40R0TNFnpNnvxt56zWieo7MO7mlJrL13IBkr92Iyv
         OxAecv7nsCze+IUX1EPIouMkG1DYi/ZChCYZ3ytN/Va1N4PFAuKJPAwuDTReaCMnPDbs
         9PkTStbkZ+k4rpD5aibQknVj/t6HbGbQGMqtG6yhqe2acNtclh/bNYDJQmgyKSvbgIrQ
         3tiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=i/SuxAwOXiJzhOAxxc15cveCQd5XdNrs1UZ5Tv+sksg=;
        b=iAgicoccZ16w42oqTGPpabaBhyY87I2qrLYiILVxqesF2c+2x3AYOcRtKCffawrgzQ
         4y4a3vgcJ0O9cRWNnNfIRv2SBzEv9p3GBYSENALFMgYwmDFqy8gv3t94wco2OKr7NP2s
         c0bGT+O25IGddpGoXYNx8s2p+gWxHXANQDvgtaz4Sk3pgdqjw753QUYM0WUx5134LNr+
         6/3Bk1Y1fwlZieYYxyicMTQWU5Lsp32uygMdDie6JBfplFKqNgqYNI0VzgrKl13rPvlK
         4fbr+k0am5O+IykU57ggaC+/KTPTU4hhn7xG5i6hGInTSN7i4WQFdg7aO6QyA4Kr/De1
         WajQ==
X-Gm-Message-State: AOAM530y16Jti1O+GdZypvx7GNQTq7nKbW5H8DsrAXpo1KtIww4XLHD8
        +HP6guC1w882uKm2/9WCqR82VrtIEIaFejNZHsE=
X-Google-Smtp-Source: ABdhPJzf3AJyHsflmcn3vYEXxD5kEx43yRGVW1Ii+V9a3gdBeu2zV2/NUU7KS9X7H32JMRi7hmMBj3n3qrRlJsb31Hk=
X-Received: by 2002:a05:6e02:1a44:b0:2d3:ff91:12a3 with SMTP id
 u4-20020a056e021a4400b002d3ff9112a3mr2382864ilv.82.1654274789426; Fri, 03 Jun
 2022 09:46:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6602:27c5:0:0:0:0 with HTTP; Fri, 3 Jun 2022 09:46:28
 -0700 (PDT)
Reply-To: jesspayne72@gmail.com
From:   Jess Payne <joeladmu1@gmail.com>
Date:   Fri, 3 Jun 2022 17:46:28 +0100
Message-ID: <CALD7h0NS1Tx4uERMvOA=FNPpipdmR1tTHr6S+fMy9Huz8u9wOQ@mail.gmail.com>
Subject: =?UTF-8?B?5oiR6ZyA6KaB5L2g55qE5biu5Yqp44CC?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:12b listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 0.9999]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 0.9999]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jesspayne72[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [joeladmu1[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [joeladmu1[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
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
