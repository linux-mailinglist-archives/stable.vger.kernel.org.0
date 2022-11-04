Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEB7619550
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 12:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiKDLXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 07:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiKDLXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 07:23:40 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E89C286C0
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 04:23:39 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-13bd19c3b68so5173582fac.7
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 04:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/HadXuDDv9ArPhHztrF1H6tMSaUzkjdk7J33lVGoh6I=;
        b=LNecgVPiVh0a842GXn6RdsxTXLJ/Pge2rmBr0ViGKVmoYtLCpN/f+Iqg7Rynky6wjW
         YGQkmteEVSKMwl9gYTEnha4TKL+Iwu5Wx85uBUD0455PqFS16OlAVWLu40hvE8qCacXI
         1jy5AGDmVZTaSNydkztd/NbqkRC2QBtvKramUMB9wLjXUIyCgRBBOAS4JxfPzLufWRg+
         xWwG88ZX7xsGpbaqU8oWJw+bhwmY34t8txaKJIBmjK2cQsERyXuHRWnirfN+SvqMkorf
         TxWkOyJvoYH69ftKAE1BqjMs0cgNSeeYjANuWPwCcmsbYlBTmpf/4u66bIua7og6Gp4r
         /Stg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/HadXuDDv9ArPhHztrF1H6tMSaUzkjdk7J33lVGoh6I=;
        b=abwpoPtkSExNerowYAJa2sLJBLV8vqPwhqiBF1ko1yQHIbmaKrAgq/tn0wY8UNWp0H
         hjv6NnUmDXZibJajQnCiTDqN/wOzOjld0iOl+qhnvGK6K8YnNxFGtTrHq9G8bJPI7YDr
         Hhp3vDWORry/GY2tUGDrdPKd4LLD4uXd8owivEorEeC4tiugQRRUUoZ+dwHFjw4xqkHV
         7+F8j/jdoPain/juYlJKW/F4wBEtssKoj1oWO+oryJRCh6hQfmFtaXxyuqEbyqQv4iNt
         pci/cjF6iG6Qoy8bEvKVwVyC0TpQ5K6oTQqYGk6/G7ugbwsLktBxORlPK7uY49RX74JB
         Omlg==
X-Gm-Message-State: ACrzQf3hCjkv3oRQhbL8G4i2KdhEFW9kjE32KK6i+FvHJamWk+OZ1Cbf
        p63ufcJY7uatunI6ytcqU/77ZZtfrAqcZuluht4=
X-Google-Smtp-Source: AMsMyM7pEx8PfzjlNAwnhRMsHBeA4x7F95XFjxlfXSg7v+VJjbenj/G6AYgVz1xzpa7zP38GkSzmXfyQD8oWOMJRn/0=
X-Received: by 2002:a05:6870:3414:b0:13c:787e:15ba with SMTP id
 g20-20020a056870341400b0013c787e15bamr20213062oah.164.1667561018822; Fri, 04
 Nov 2022 04:23:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:1282:b0:dc:4058:1ad5 with HTTP; Fri, 4 Nov 2022
 04:23:38 -0700 (PDT)
Reply-To: janepayne700@gmail.com
From:   jane payne <bayalaadeline1@gmail.com>
Date:   Fri, 4 Nov 2022 04:23:38 -0700
Message-ID: <CAFBSHWfM8FCLiS63=kygs3xG6-vjcME=3sdeMR+P=CqEFDfWhQ@mail.gmail.com>
Subject: =?UTF-8?B?5oiR6ZyA6KaB5L2g55qE5biu5Yqp?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:2a listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [janepayne700[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [bayalaadeline1[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [bayalaadeline1[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
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

5oiR5biM5pyb5L2g6IO955CG6Kej6L+Z5p2h5L+h5oGv77yM5Zug5Li65oiR5q2j5Zyo5L2/55So
57+76K+R57uZ5L2g5YaZ5L+h44CCDQoNCuaIkeaYr+eugMK35L2p5oGp5Lit5aOr5aSr5Lq644CC
DQoNCuWcqOe+juWbvemZhuWGm+eahOWGm+S6i+mDqOmXqOOAgue+juWbve+8jOS4gOWQjeS4reWj
q++8jDMyIOWyge+8jOaIkeaYr+adpeiHque+juWbveeUsOe6s+ilv+W3nuWFi+WIqeWkq+WFsOea
hOWNlei6q++8jOebruWJjeWcqOWIqeavlOS6muePreWKoOilv+aJp+ihjOS4gOmhueeJueauiuS7
u+WKoeOAgg0KDQrmiJHmmK/kuIDkuKrlhYXmu6HniLHlv4PjgIHor5rlrp7lkozmt7Hmg4XnmoTk
urrvvIzlhbfmnInoia/lpb3nmoTlub3pu5jmhJ/vvIzmiJHllpzmrKLnu5Por4bmlrDmnIvlj4vl
ubbkuobop6Pku5bku6znmoTnlJ/mtLvmlrnlvI/vvIzmiJHllpzmrKLnnIvliLDlpKfmtbfnmoTm
s6LmtpvlkozlsbHohInnmoTnvo7kuL3ku6Xlj4rlpKfoh6rnhLbmiYDmi6XmnInnmoTkuIDliIfm
j5DkvpvjgILlvojpq5jlhbTog73mm7TlpJrlnLDkuobop6PmgqjvvIzmiJHorqTkuLrmiJHku6zl
j6/ku6Xlu7rnq4voia/lpb3nmoTllYbkuJrlj4vosIrjgIINCg0K5oiR5LiA55u05b6I5LiN5byA
5b+D77yM5Zug5Li65Yeg5bm05p2l55Sf5rS75a+55oiR5LiN5YWs5bmz77yb5oiR5ZyoIDIxDQrl
soHml7blpLHljrvkuobniLbmr43jgILmiJHniLbkurLnmoTlkI3lrZfmmK/luJXnibnph4zmlq/k
vanmganlkozmiJHnmoTmr43kurLnjpvkuL3kvanmganjgILmsqHmnInkurrluK7liqnmiJHvvIzk
vYbmiJHlvojpq5jlhbTmiJHnu4jkuo7lnKjnvo7lhpvkuK3mib7liLDkuoboh6rlt7HjgIINCg0K
5oiR57uT5ama55Sf5LqG5LiA5Liq5a2p5a2Q77yM5L2G5LuW5Y675LiW5LqG77yM5Zyo5oiR5LiI
5aSr5byA5aeL6IOM5Y+b5oiR5ZCO5LiN5LmF77yM5oiR5LiN5b6X5LiN5pS+5byD5ama5ae744CC
DQoNCuaIkeS5n+W+iOW5uOi/kOWcqOaIkeeahOWbveWutue+juWbveWSjOWIqeavlOS6muePreWK
oOilv+i/memHjOaLpeacieaIkeeUn+a0u+S4remcgOimgeeahOS4gOWIh++8jOS9huayoeacieS6
uue7meaIkeW7uuiuruOAguaIkemcgOimgeS4gOS4quivmuWunueahOS6uuadpeS/oeS7u++8jOS7
luS5n+S8muW7uuiuruaIkeWmguS9leaKlei1hOaIkeeahOmSseOAguWboOS4uuaIkeaYr+aIkeeI
tuavjeWcqOS7luS7rOatu+WJjeeUn+S4i+eahOWUr+S4gOS4gOS4quWls+WtqeOAgg0KDQrmiJHk
uI3orqTor4bkvaDvvIzkvYbmiJHorqTkuLrmnInkuIDkuKrlj6/ku6Xkv6Hku7vnmoTlpb3kurrv
vIzku5blj6/ku6Xlu7rnq4vnnJ/mraPnmoTkv6Hku7vlkozoia/lpb3nmoTllYbkuJrlj4vosIrv
vIzlpoLmnpzkvaDnnJ/nmoTmnInkuIDkuKror5rlrp7nmoTlkI3lrZfvvIzmiJHkuZ/mnInkuIDk
upvkuovmg4XopoHlkozkvaDliIbkuqvnm7jkv6HjgILlnKjkvaDouqvkuIrvvIzlm6DkuLrmiJHp
nIDopoHkvaDnmoTluK7liqnjgILmiJHmi6XmnInmiJHlnKjliKnmr5Tkuprnj63liqDopb/otZrl
iLDnmoTmgLvpop3vvIg0NzANCuS4h+e+juWFg++8ieOAguaIkeWwhuWcqOS4i+S4gOWwgeeUteWt
kOmCruS7tuS4reWRiuivieS9oOaIkeaYr+WmguS9leWBmuWIsOeahO+8jOS4jeimgeaDiuaFjO+8
jOWug+S7rOaYr+aXoOmjjumZqeeahO+8jOaIkei/mOWcqOS4jiBSZWQNCuacieiBlOezu+eahOS6
uumBk+S4u+S5ieWMu+eUn+eahOW4ruWKqeS4i+Wwhui/meeslOmSseWtmOWFpeS6huS4gOWutumT
tuihjOOAguaIkeW4jOacm+aCqOS7peaIkeeahOWPl+ebiuS6uui6q+S7veaOpeWPl+ivpeWfuumH
ke+8jOW5tuWcqOaIkeWcqOi/memHjOWujOaIkOWQjuWmpeWWhOS/neeuoeWug++8jOW5tuiOt+W+
l+aIkeeahOWGm+S6i+mAmuihjOivge+8jOS7peS+v+WcqOaCqOeahOWbveWutuS4juaCqOS8mumd
ou+8m+S4jeimgeWus+aAlemTtuihjOS8mumAmui/h+eUteaxh+Wwhui1hOmHkei9rOe7meaCqO+8
jOi/meWvueaIkeS7rOadpeivtOWuieWFqOS4lOW/q+aNt+OAgg0KDQrnrJTorrA75oiR5LiN55+l
6YGT5oiR5Lus6KaB5Zyo6L+Z6YeM5b6F5aSa5LmF77yM5oiR55qE5ZG96L+Q77yM5Zug5Li65oiR
5Zyo6L+Z6YeM5bm45YWN5LqO5Lik5qyh54K45by56KKt5Ye777yM6L+Z5a+86Ie05oiR5a+75om+
5LiA5Liq5YC85b6X5L+h6LWW55qE5Lq65p2l5biu5Yqp5oiR5o6l5pS25ZKM5oqV6LWE5Z+66YeR
77yM5Zug5Li65oiR5bCG5p2l5Yiw5L2g55qE5Zu95a625Ye66Lqr5oqV6LWE77yM5byA5aeL5paw
55Sf5rS777yM5LiN5YaN5b2T5YW144CCDQoNCuWmguaenOaCqOaEv+aEj+iwqOaFjuWkhOeQhu+8
jOivt+WbnuWkjeaIkeOAguaIkeS8muWRiuivieS9oOaOpeS4i+adpeeahOa1geeoi++8jOW5tue7
meS9oOWPkemAgeabtOWkmuWFs+S6juWfuumHkeWtmOWFpemTtuihjOeahOS/oeaBr+OAguS7peWP
iumTtuihjOWwhuWmguS9leW4ruWKqeaIkeS7rOmAmui/h+eUteaxh+Wwhui1hOmHkei9rOenu+WI
sOaCqOeahOWbveWutu+8jOeUteaxh+S5n+aYr+mTtuihjOWIsOmTtuihjOeahOi9rOW4kOOAguiL
peacieWFtOi2o+ivt+iBlOezu+acrOS6uuOAgg0K
