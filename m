Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473854ED16C
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 03:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352387AbiCaByA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 21:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352386AbiCaBx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 21:53:58 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C1E49243
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 18:52:11 -0700 (PDT)
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220331015209epoutp03fb786089e449b134faee848ab70e8c7b~hVDX5CSWR1098510985epoutp03k
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 01:52:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220331015209epoutp03fb786089e449b134faee848ab70e8c7b~hVDX5CSWR1098510985epoutp03k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648691529;
        bh=CmJ4idTqqG5xfzb4PI73iLy6U1KKHUgcuzzYGeveMtU=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=B9jf+TjVvWHBVlELn6b6uTj/6vNql+sM/zMuiP9Axh4o28qUuD5C8QAwpZSrVq2TW
         BHL0MNlvDA9p3bixdmF94dNnhyf27pianLKmUvyDmAivd6X6n6Ey4Z5k+wfhd497TU
         K0P4xxgBD4Yep+KqBCU+vZD1733ADKrAYosrxprE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220331015208epcas1p271237be4636b123ed1d67ec5f3bde219~hVDXLD2FO2152121521epcas1p2c;
        Thu, 31 Mar 2022 01:52:08 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.36.226]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4KTRBG2pvkz4x9QT; Thu, 31 Mar
        2022 01:52:06 +0000 (GMT)
X-AuditID: b6c32a39-ff1ff70000006fe8-a6-62450946a09d
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.F3.28648.64905426; Thu, 31 Mar 2022 10:52:06 +0900 (KST)
Mime-Version: 1.0
Subject: RE:(2) Request for reverting the commit for Samsung HID driver
Reply-To: junwan.cho@samsung.com
Sender: =?UTF-8?B?7KGw7KSA7JmE?= <junwan.cho@samsung.com>
From:   =?UTF-8?B?7KGw7KSA7JmE?= <junwan.cho@samsung.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        =?UTF-8?B?7KGw7KSA7JmE?= <junwan.cho@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Jiri Kosina <jikos@kernel.org>,
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
In-Reply-To: <8b24038d-75a0-1124-642d-647ac8af0db3@kernel.org>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220331015105epcms1p404df5e500988fca3aeabcc2e05cb172e@epcms1p4>
Date:   Thu, 31 Mar 2022 10:51:05 +0900
X-CMS-MailID: 20220331015105epcms1p404df5e500988fca3aeabcc2e05cb172e
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUxTZxTGfbm9bcHUXVvQd2xqd/cVHR+ttPgywWl02mVi2MzcMpd0F7ih
        2E97yyJm6eqcsuEcdgYhndgusgEXGFoFC6YOS4DYqc0ijAHrxCoyJTCsq8AcyVpa5v775clz
        npNz3vPyMWE3N5lfrDPRRh2lIbkJnLau1ampW+Nfz5fc8InQ7L0TAB3zbkMdn0/iaLz3Ao7O
        /j2Eo7rBEIaGHW+gg6dbuKi1tgZHQ72HADp3PMBBPt8ZHhoMPsLRqblmHFkvH8aR42wAoEC9
        Mw5Nup/dKFSMVrTyFO02P0/hZL/gKn6saeIpvjrPAsWn3jJc8dC5Mo/3vjpbRVOFtFFM6wr0
        hcW6ohzyzZ3KzUp5pkSaKs1C60ixjtLSOeSW7XmpW4s14SFI8UeUpiQs5VEMQ6ZvyDbqS0y0
        WKVnTDkkbSjUGDINaQylZUp0RWk62vSqVCJZKw8bP1SrmqeqcYP3qX2ukwGOBVQuKQfxfEjI
        YFP9DawcJPCFhAtANjSAlwM+X0AshXMuUQRFxDY4EtgbsQsJMRxot2ARFhFZsO3m17wIc4l1
        sPUMy43EJBLfhGOuOuYzMcLNhYP3oy5ICGB12Sgnys/AC3WtIMLxxAZ4+24bN6onwcHGCd4C
        /9ljB1FOhId+v4ZFeSkcmb0Y05+GtuO1MWbgzFQfHmUTPGDvj+Wkw6o7E/O1AiIXHvnt8Hwv
        DvEiDLazMc8WOHPpr/kcjHgFfv/tOBYZHiNWw5aO9KjlOdj+uCZmWQInQ1/iC2O5Tt2Ji/IL
        8Gj4WiKlkEiGfS3KqKyA9f57sTVXcWFL2SPsGBDbnmza9r/GtieNHQBjwTLawGiLaEZqkP/3
        uAV6rRPM3/OaLBeomphK84A4PvAAyMfIRMGDy5vzhYJCqnQ/bdQrjSUamvEAeXhkK5acVKAP
        fwidSSmVZUlkmWtlKCMrI5NcLmBP/EQJiSLKRKtp2kAbF+ri+PHJlri3tRv7feaxtu3/iCvV
        jpSGwIr1D+z3+0cJo7esrnZupnMMTgybl1/LoM4V5+TVVit7K3rt8affFStDTXf9kgSF1XNw
        UYNmb5fZ3OxvGf7seW+Dm/tLsO9Xn7hnT8/M1VKPbSVgg5um97mr6yQ3A/h740lqy23jYn/u
        9NFAijtoodhMetVrt1Iah3Zc3D10q0e3auDlkw+7suW791g7fd9lp4sYy/Uqt/kds3V/Q2X3
        FFub+3ORtvFIyo5NMx3lL13xik1DhfXWH3pVokFn6diKwKWC2ZB71y5XSCIg8g5c7368s+ID
        m31k0R/TzYvXf+w739ktW6bKd35yRTD2lo3kMCpKugYzMtS/5KHObVgEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587
References: <8b24038d-75a0-1124-642d-647ac8af0db3@kernel.org>
        <YkQnvMpk9cRX8/F9@kroah.com> <YkQRXqlzVjBLbvp2@kroah.com>
        <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
        <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
        <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
        <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
        <20220330084401epcms1p1fe9efa50452a84f7bbb22a4de82b5a0a@epcms1p1>
        <20220330090150epcms1p42e28758b515942ecdee680cdef3ef0b9@epcms1p4>
        <20220330092058epcms1p799e10561617c02a14d5d8b413722f678@epcms1p7>
        <20220330094354epcms1p282a35cfc39cea0b76125387a496d9284@epcms1p2>
        <20220330095806epcms1p34fa55d36ed5ce200fb74a9a23aa279a5@epcms1p3>
        <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p4>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org




If bottom posting is natural, why doesn't our mailing system support bottom=
 positing?
It's not clear which method is more efficient. Still a lot of people are ar=
guing which is the most effective way.
I don't want to scroll down to read your reply.
Don't force it on others.

I have simply sent an inquiry email, and you only need to respond to it.

I didn't write a tech thread. This is a kind of business mail.=20
I'm sending you a business email about fixes that affect our products.
Do you understand?
Do I have to copy your most recent mail and add the '>' myself to do it the=
 way you like it?
If you tell me how, I'll think about it.

=C2=A0=0D=0A=C2=A0=0D=0A---------=20Original=20Message=20---------=0D=0ASen=
der=20:=20Krzysztof=20Kozlowski=C2=A0<krzk=40kernel.org>=0D=0ADate=20:=2020=
22-03-31=2003:43=20(GMT+9)=0D=0ATitle=20:=20Re:=20Request=20for=20reverting=
=20the=20commit=20for=20Samsung=20HID=20driver=0D=0A=C2=A0=0D=0AOn=C2=A030/=
03/2022=C2=A011:58,=C2=A0=EC=A1=B0=EC=A4=80=EC=99=84=C2=A0wrote:=0D=0A>=C2=
=A0You=C2=A0are=C2=A0the=C2=A0first=C2=A0person=C2=A0to=C2=A0point=C2=A0thi=
s=C2=A0out=C2=A0while=C2=A0exchanging=C2=A0emails.=0D=0A>=C2=A0I=C2=A0don't=
=C2=A0know=C2=A0how=C2=A0to=C2=A0send=C2=A0in=C2=A0your=C2=A0favorite=C2=A0=
style=C2=A0in=C2=A0our=C2=A0mail=C2=A0system.=0D=0A>=C2=A0This=C2=A0is=C2=
=A0the=C2=A0last=C2=A0email,=C2=A0so=C2=A0don't=C2=A0be=C2=A0annoyed.=0D=0A=
=C2=A0=0D=0AGreg=C2=A0is=C2=A0not=C2=A0the=C2=A0first=C2=A0person=C2=A0poin=
ting=C2=A0this=C2=A0out.=C2=A0We=C2=A0all=C2=A0did.=C2=A0:)=0D=0ATop-postin=
g=C2=A0makes=C2=A0reading=C2=A0and=C2=A0responding=C2=A0much=C2=A0more=C2=
=A0difficult.=C2=A0It's=0D=0Ainefficient.=C2=A0Proper=C2=A0quoting=C2=A0is=
=C2=A0the=C2=A0basis=C2=A0of=C2=A0efficient=C2=A0email=0D=0Acommunication=
=C2=A0and=C2=A0well=C2=A0known=C2=A0between=C2=A0tech=C2=A0folks=C2=A0in=C2=
=A0internet.=0D=0A=C2=A0=0D=0ABest=C2=A0regards,=0D=0AKrzysztof=0D=0A=C2=A0=
=0D=0A=C2=A0
