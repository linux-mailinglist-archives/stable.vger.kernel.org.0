Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C382A4EBD1D
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 11:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243127AbiC3JDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 05:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244542AbiC3JDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 05:03:42 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F5A1667F3
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 02:01:56 -0700 (PDT)
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220330090154epoutp028db755d1cabb9d37208a815c216038d2~hHRToLPmV2142621426epoutp02h
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:01:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220330090154epoutp028db755d1cabb9d37208a815c216038d2~hHRToLPmV2142621426epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648630914;
        bh=4wJV7gtFCnyuWk+1tmXHi+Kgnqas70syZvbAme1vbLU=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=CQqkn54He6yQAkrAspEkvEPmL0TiWBUnoxVQAh2nx4HK5p2kIK5qjuZvLEvQ17WMm
         +/nbomZjsyrpGv0VpRW5ujMqH6pGfySpMcKkZgc4rh953s8UZO+UZa62Ejcz+8dxtp
         7gPW1CftWN/ejTzuw9WSKPwwhTW9IdRwBwuFfipU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20220330090153epcas1p4a36c98072a13abd21eb9df65796ca11e~hHRS8gF020127501275epcas1p4F;
        Wed, 30 Mar 2022 09:01:53 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.36.224]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KT0mb3XG1z4x9QQ; Wed, 30 Mar
        2022 09:01:51 +0000 (GMT)
X-AuditID: b6c32a37-28fff70000002578-5c-62441c7fb087
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        96.2E.09592.F7C14426; Wed, 30 Mar 2022 18:01:51 +0900 (KST)
Mime-Version: 1.0
Subject: RE:(3) (2) (2) Request for reverting the commit for Samsung HID
 driver
Reply-To: junwan.cho@samsung.com
Sender: =?UTF-8?B?7KGw7KSA7JmE?= <junwan.cho@samsung.com>
From:   =?UTF-8?B?7KGw7KSA7JmE?= <junwan.cho@samsung.com>
To:     Jiri Kosina <jikos@kernel.org>,
        =?UTF-8?B?7KGw7KSA7JmE?= <junwan.cho@samsung.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "michael.zaidman@gmail.com" <michael.zaidman@gmail.com>,
        "erazor_de@users.sourceforge.net" <erazor_de@users.sourceforge.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?UTF-8?B?6rmA7J287Zi4?= <ih0923.kim@samsung.com>,
        =?UTF-8?B?67CV7LKc7Zi4?= <chun.ho.park@samsung.com>,
        =?UTF-8?B?67Cw7Jyk7Iud?= <yunsik.bae@samsung.com>,
        =?UTF-8?B?6rCV64yA7Z2s?= <daihee7.kang@samsung.com>,
        =?UTF-8?B?7J206rSR7Zi4?= <gaudium.lee@samsung.com>,
        =?UTF-8?B?66WY7LKc7Jqw?= <chunwoo.ryu@samsung.com>,
        =?UTF-8?B?64KY65GQ7IiY?= <doosu.na@samsung.com>,
        =?UTF-8?B?6rmA7IiY7ZiE?= <suhyun_.kim@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <nycvar.YFH.7.76.2203301047560.24795@cbobk.fhfr.pm>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220330090150epcms1p42e28758b515942ecdee680cdef3ef0b9@epcms1p4>
Date:   Wed, 30 Mar 2022 18:01:50 +0900
X-CMS-MailID: 20220330090150epcms1p42e28758b515942ecdee680cdef3ef0b9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJsWRmVeSWpSXmKPExsWy7bCmgW69jEuSwaGJkhY/X05jtJhwyt1i
        V8c7VovXx7ezWmz8dYvVYvnNr8wWtxd4WjQvXs9msXXJXFaLW8dbGS02T37EYnHz0zdWi3l/
        17JaTDzYxmqxYOMjRotHKzYxWbzbK+Mg6PG0fyu7x85Zd9k9Nq3qZPPYP3cNu0ffllWMHk2n
        2lk9Pm+SC2CPyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
        dcvMAbpfSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgVqBXnJhbXJqXrpeXWmJl
        aGBgZApUmJCd8er9TqaCzbwVLzoXsTcwtvJ2MXJySAiYSMzetZG1i5GLQ0hgB6PE5/tbGbsY
        OTh4BQQl/u4QBqkRFgiU+Hy0lQXEFhJQkLi+s4EZIm4pse3+JHYQm03AXGLrhlVsILaIQLjE
        4hnv2UFmMgvcYpOYtP4jO8QyXokZ7U9ZIGxpie3LQXZxcnAKOEi0fbgKFReVuLn6LTuM/f7Y
        fEYIW0Si9d5ZZghbUOLBz91QcUmJWZOXQNnFEj8+XGGFsEskGudfhZqjLzH9yVuwXl4BX4lJ
        N1czg/zIIqAq0farGKLERWLCj+Ng5cwC2hLLFr4GK2EW0JRYv0sfokRRYufvuYwQJXwS7772
        sMJ8tWPeEyYIW0WiF5hOQFolBKQkrqyPhwh7SKy4+5IZEsqdLBKfr61ln8CoMAsR0LOQLJ6F
        sHgBI/MqRrHUguLc9NRiwwJjeNwm5+duYgSnZC3zHYzT3n7QO8TIxMF4iFGCg1lJhPfjQeck
        Id6UxMqq1KL8+KLSnNTiQ4ymQB9PZJYSTc4HZoW8knhDE0sDEzMjEwtjS2MzJXHeVdNOJwoJ
        pCeWpGanphakFsH0MXFwSjUwWSb7yHAErHU8y7sua8rvk+veP1/FdUHpetAatr3LFtwpNzWu
        jmI02qGwOWdH9IQv5Q1xrFfPqTx3kP3u/+75josGEnm32f9Ncmj6vy3SUe1kt3bd/f2PrZac
        eNZ58stG58dCPy4mmLZeznL+M3kNG9PWyKVcrumLm7/7H7o/f9aL/u3Gq7eu9Et98kRu0gv7
        hmMHeoRTOWv2zcqIfXhY7niiTvnlRdG6PO9PS+Xtrv1b3/34kpTS6hs5uzQ3x2/5niFk8DHo
        rrns0wCjvd80L7jXRuypPHckY+dUfffTU//vaM1YqfvklmxGVeq0fXN5E/JN97sdktthJXLy
        muF8h67awz9mifH6rco93Kz+sVuJpTgj0VCLuag4EQAm7eyEUgQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587
References: <nycvar.YFH.7.76.2203301047560.24795@cbobk.fhfr.pm>
        <YkQVq1RvWTp1xxJO@kroah.com> <YkQRXqlzVjBLbvp2@kroah.com>
        <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
        <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
        <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
        <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
        <20220330084401epcms1p1fe9efa50452a84f7bbb22a4de82b5a0a@epcms1p1>
        <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p4>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=C2=A0=0D=0AThank=20you=20for=20good=20advice.=0D=0A=0D=0AI'll=20check=20se=
curity=20problem=20when=20I=20add=20in-house=20patch.=0D=0AI=20have=20no=20=
idea=20about=20how=20the=20commit=20improves=20security=20level.=0D=0AWas=
=20there=20any=20security=20problem?=20=20Could=20you=20let=20us=20know?=0D=
=0A=0D=0A=C2=A0=0D=0A---------=20Original=20Message=20---------=0D=0ASender=
=20:=20Jiri=20Kosina=C2=A0<jikos=40kernel.org>=0D=0ADate=20:=202022-03-30=
=2017:49=20(GMT+9)=0D=0ATitle=20:=20RE:(2)=20(2)=20(2)=20Request=20for=20re=
verting=20the=20commit=20for=20Samsung=20HID=20driver=0D=0A=C2=A0=0D=0AOn=
=C2=A0Wed,=C2=A030=C2=A0Mar=C2=A02022,=C2=A0=EC=A1=B0=EC=A4=80=EC=99=84=C2=
=A0wrote:=0D=0A=C2=A0=0D=0A>=C2=A0Sorry=C2=A0that=C2=A0I'm=C2=A0not=C2=A0fa=
milier=C2=A0with=C2=A0policy=C2=A0of=C2=A0Linux.=0D=0A>=C2=A0That=C2=A0mean=
s=C2=A0I=C2=A0cannot=C2=A0add=C2=A0the=C2=A0code=C2=A0to=C2=A0support=C2=A0=
Bluetoth=C2=A0accessories=C2=A0in=C2=A0Linux=C2=A0Main=C2=A0line?=0D=0A=C2=
=A0=0D=0AYou=C2=A0of=C2=A0course=C2=A0can=C2=A0(and=C2=A0I'd=C2=A0be=C2=A0a=
ctually=C2=A0very=C2=A0happy=C2=A0to=C2=A0take=C2=A0any=C2=A0in-house=C2=A0=
=0D=0Apatches=C2=A0you=C2=A0have=C2=A0in=C2=A0order=C2=A0for=C2=A0the=C2=A0=
hid-samsung=C2=A0driver=C2=A0to=C2=A0support=C2=A0much=C2=A0=0D=0Abigger=C2=
=A0group=C2=A0of=C2=A0devices),=C2=A0but=C2=A0together=C2=A0with=C2=A0that,=
=C2=A0the=C2=A0hid-samsung=C2=A0driver=C2=A0=0D=0Aneeds=C2=A0to=C2=A0be=C2=
=A0adjusted=C2=A0so=C2=A0that=C2=A0it=C2=A0treats=C2=A0the=C2=A0BT-specific=
=C2=A0and=C2=A0USB-speicific=C2=A0=0D=0Acodepaths=C2=A0properly.=0D=0A=C2=
=A0=0D=0A--=C2=A0=0D=0AJiri=C2=A0Kosina=0D=0ASUSE=C2=A0Labs=0D=0A=C2=A0=0D=
=0A=C2=A0
