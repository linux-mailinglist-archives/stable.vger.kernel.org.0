Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02E1423054
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 20:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhJESsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 14:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhJESsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 14:48:54 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B018C061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 11:47:04 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so2715561pjb.1
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 11:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=u3UVtloaaMqDkztEGASyWNnbDwu0ymuLbk5cZTT/COQ=;
        b=mnrZaWoSGZgIp2Y8L8arWRubUrQqIdO31mUMyeD/78384fvEntAzOsPsNDVX7X9tIg
         UYN1C+8qGSnbQPFoEoz7lFcIog+WsZs4XEUhoKp/n8HZQHgRMsJ0Xh4fbLHP2GXWFNj6
         ch0Cdb8Ia3gn/9vbMa6nNotAthJNDt+szShiQYj+VUwRJiQVtxt2z61KMvltrJSwkT7G
         0PPLGGmdf6m4oHg2sylqkmlAWh3doEXhGJRV2rhbc8mebexX2RDE6EhQ2rSxc5G0pOqh
         pU8zM7mFCK2zkYn6qRRzYV8V1OnRbVzO++EaSpZyZpea5e7sX4tYKdGcesrHFp7Q+/Mi
         JUdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=u3UVtloaaMqDkztEGASyWNnbDwu0ymuLbk5cZTT/COQ=;
        b=LZSUE+cSqZJuhdSeilDFqIDC/UshEcZzFdl8JIYr0CFBzFBDK/J2bNnpvpfhPUn3Cv
         WzzsuMe5MIFY3ih+DmZzdopd2NjtwtSQjWnjQBTjtZ6nLNfUJKrvaViyidXnLGTStRQQ
         pVPIQLUwYrFK8TYHerMPJU+0PSAh0ZO/pc/o+Lljez7Xegz4mBbTJlr0WqAzKgjnlSFs
         o6k/ZUsHuBEy5BfFMgQjK5OX3S7AfZxe+2YsxMpSkI+6emGlv6v8HgOb2wjAfNX3o4Jd
         HkA38XNGV/8z6vJnltn2qmWsktf2Wkt2pmIlKIurJFfbY3UaI9duC7QQnOCVAgHT+jQ0
         TD/Q==
X-Gm-Message-State: AOAM532rBM0hV+eMcYDZymNJgqjwFvvTUvEPz03Qhh50Wwj8GzpzmyNE
        KffUAY7HBeCSbDNVwM9454uLNpqTnAUubNt4izM=
X-Google-Smtp-Source: ABdhPJzUW0B9IUEgvHYC2i8dFKYYymPA6UqUSEGpmcw0/eI0FwyDp2ot3JGybwkrgtHlImym6R4RRsx/qtcKymQ3PQM=
X-Received: by 2002:a17:902:da83:b0:13e:651a:dc91 with SMTP id
 j3-20020a170902da8300b0013e651adc91mr6684594plx.26.1633459622932; Tue, 05 Oct
 2021 11:47:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90a:634c:0:0:0:0 with HTTP; Tue, 5 Oct 2021 11:47:02
 -0700 (PDT)
Reply-To: jesspayne72@gmail.com
From:   Jess Payne <paynecollins54@gmail.com>
Date:   Tue, 5 Oct 2021 11:47:02 -0700
Message-ID: <CABqO3ArAsP7QJCtkPsccmzdEn8AS7AkSR3yV5y6woW_RYxK9rg@mail.gmail.com>
Subject: =?UTF-8?B?5oiR6ZyA6KaB5L2g55qE5biu5YqpIC8gSSBuZWVkIHlvdXIgYXNzaXN0YW5jZQ==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

5oiR5piv5p2w6KW/5L2p5oGp5Lit5aOr5aSr5Lq644CCDQoNCuWcqOe+juWbvemZhuWGm+eahOWG
m+S6i+mDqOmXqOOAgue+juWbve+8jOS4gOWQjeS4reWjq++8jDMyIOWyge+8jOaIkeWNlei6q++8
jOadpeiHque+juWbveeUsOe6s+ilv+W3nuWFi+WIqeWkq+WFsO+8jOebruWJjempu+aJjuWcqOWI
qeavlOS6muePreWKoOilv++8jOS4juaBkOaAluS4u+S5ieS9nOaImOOAguaIkeeahOWNleS9jeaY
r+esrDTmiqTnkIbpmJ/nrKw3ODLml4XmlK/mj7TokKXjgIINCg0K5oiR5piv5LiA5Liq5YWF5ruh
54ix5b+D44CB6K+a5a6e5ZKM5rex5oOF55qE5Lq677yM5YW35pyJ6Imv5aW955qE5bm96buY5oSf
77yM5oiR5Zac5qyi57uT6K+G5paw5pyL5Y+L5bm25LqG6Kej5LuW5Lus55qE55Sf5rS75pa55byP
77yM5oiR5Zac5qyi55yL5Yiw5aSn5rW355qE5rOi5rWq5ZKM5bGx6ISJ55qE576O5Li95Lul5Y+K
5aSn6Ieq54S25omA5oul5pyJ55qE5LiA5YiH5o+Q5L6b44CC5b6I6auY5YW06IO95pu05aSa5Zyw
5LqG6Kej5oKo77yM5oiR6K6k5Li65oiR5Lus5Y+v5Lul5bu656uL6Imv5aW955qE5ZWG5Lia5Y+L
6LCK44CCDQoNCuaIkeS4gOebtOW+iOS4jeW8gOW/g++8jOWboOS4uui/meS6m+W5tOadpeeUn+a0
u+WvueaIkeS4jeWFrOW5s++8m+aIkeWkseWOu+S6hueItuavje+8jOmCo+W5tOaIkSAyMQ0K5bKB
44CC5oiR54i25Lqy55qE5ZCN5a2X5piv5biV54m56YeM5pav5L2p5oGp77yM5oiR55qE5q+N5Lqy
5piv546b5Li95L2p5oGp44CC5rKh5pyJ5Lq65biu5Yqp5oiR77yM5L2G5b6I6auY5YW05oiR57uI
5LqO5Zyo576O5Yab5Lit5om+5Yiw5LqG6Ieq5bex44CCDQoNCuaIkee7k+WpmueUn+S6huWtqeWt
kO+8jOS9huS7luatu+S6hu+8jOS4jeS5heaIkeS4iOWkq+W8gOWni+asuumql+aIke+8jOaJgOS7
peaIkeS4jeW+l+S4jeaUvuW8g+WpmuWnu+OAgg0KDQrmiJHkuZ/lvojlubjov5DvvIzlnKjmiJHn
moTlm73lrrbnvo7lm73lkozliKnmr5Tkuprnj63liqDopb/ov5nph4zmi6XmnInmiJHnlJ/mtLvk
uK3miYDpnIDnmoTkuIDliIfvvIzkvYbmsqHmnInkurrkuLrmiJHmj5Dkvpvlu7rorq7jgILmiJHp
nIDopoHkuIDkuKror5rlrp7nmoTkurrmnaXkv6Hku7vvvIzku5bkuZ/kvJrlsLHlpoLkvZXmipXo
tYTmiJHnmoTpkrHmj5Dkvpvlu7rorq7jgILlm6DkuLrmiJHmmK/miJHniLbmr43lnKjku5bku6zl
jrvkuJbliY3nlJ/kuIvnmoTllK/kuIDkuIDkuKrlpbPlranjgIINCg0K5oiR5LiN6K6k6K+G5L2g
5pys5Lq677yM5L2G5oiR6K6k5Li65pyJ5LiA5Liq5YC85b6X5L+h6LWW55qE5aW95Lq677yM5LuW
5Y+v5Lul5bu656uL55yf5q2j55qE5L+h5Lu75ZKM6Imv5aW955qE5ZWG5Lia5Y+L6LCK77yM5aaC
5p6c5L2g55yf55qE5pyJ5LiA5Liq6K+a5a6e55qE5ZCN5a2X77yM5oiR5Lmf5pyJ5LiA5Lqb5Lic
6KW/6KaB5ZKM5L2g5YiG5Lqr55u45L+h44CC5Zyo5L2g6Lqr5LiK77yM5Zug5Li65oiR6ZyA6KaB
5L2g55qE5biu5Yqp44CC5oiR5oul5pyJ5oiR5Zyo5Yip5q+U5Lqa54+t5Yqg6KW/6L+Z6YeM6LWa
5Yiw55qE5oC76aKd77yIMjUwDQrkuIfnvo7lhYPvvInjgILmiJHkvJrlnKjkuIvkuIDlsIHnlLXl
rZDpgq7ku7bkuK3lkYror4nkvaDmiJHmmK/lpoLkvZXlgZrliLDnmoTvvIzkuI3opoHmg4rmhYzv
vIzku5bku6zmsqHmnInpo47pmanvvIzogIzkuJTmiJHov5jlnKjkuI4gUmVkDQrmnInogZTns7vn
moTkurrpgZPkuLvkuYnljLvnlJ/nmoTluK7liqnkuIvlsIbov5nnrJTpkrHlrZjlhaXkuobpk7bo
oYzjgILmiJHluIzmnJvmgqjlsIboh6rlt7HkvZzkuLrmiJHnmoTlj5fnm4rkurrmnaXmjqXmlLbl
n7rph5HlubblnKjmiJHlnKjov5nph4zlrozmiJDlkI7noa7kv53lroPnmoTlronlhajlubbojrfl
vpfmiJHnmoTlhpvkuovpgJrooYzor4Hku6XlnKjmgqjnmoTlm73lrrbkuI7mgqjkvJrpnaLvvJvk
uI3opoHlrrPmgJXpk7booYzkvJrlsIbotYTph5HlrZjlgqjlnKgNCkFUTSBWSVNBIOWNoeS4re+8
jOi/meWvueaIkeS7rOadpeivtOaYr+WuieWFqOS4lOW/q+aNt+eahOOAgg0KDQrnrJTorrA75oiR
5LiN55+l6YGT5oiR5Lus6KaB5Zyo6L+Z6YeM5ZGG5aSa5LmF77yM5oiR55qE5ZG96L+Q77yM5Zug
5Li65oiR5Zyo6L+Z6YeM5Lik5qyh54K45by56KKt5Ye75Lit5bm45a2Y5LiL5p2l77yM6L+Z5L+D
5L2/5oiR5a+75om+5LiA5Liq5YC85b6X5L+h6LWW55qE5Lq65p2l5biu5Yqp5oiR5o6l5pS25ZKM
5oqV6LWE5Z+66YeR77yM5Zug5Li65oiR5bCG5p2l5Yiw5L2g5Lus55qE5Zu95a625Ye66Lqr5oqV
6LWE77yM5byA5aeL5paw55Sf5rS777yM5LiN5YaN5b2T5YW144CCDQoNCuWmguaenOaCqOaEv+aE
j+iwqOaFjuWkhOeQhu+8jOivt+WbnuWkjeaIkeOAguaIkeS8muWRiuivieS9oOS4i+S4gOatpeea
hOa1geeoi++8jOW5tue7meS9oOWPkemAgeabtOWkmuWFs+S6juWfuumHkeWtmOWFpemTtuihjOea
hOS/oeaBr+OAguS7peWPiumTtuihjOWwhuWmguS9leW4ruWKqeaIkeS7rOmAmui/hyBBVE0gVklT
QQ0KQ0FSRCDlsIbotYTph5Hovaznp7vliLDmgqjnmoTlm73lrrYv5Zyw5Yy644CC5aaC5p6c5L2g
5pyJ5YW06Laj77yM6K+35LiO5oiR6IGU57O744CCDQo=
