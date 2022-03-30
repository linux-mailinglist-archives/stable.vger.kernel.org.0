Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DBA4EBDEB
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 11:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244968AbiC3Jpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 05:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbiC3Jpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 05:45:46 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0401689B8
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 02:44:01 -0700 (PDT)
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220330094358epoutp0359db51eb0e2c034b6e274d08fc7189d0~hH2CRkpFB3103831038epoutp03C
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:43:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220330094358epoutp0359db51eb0e2c034b6e274d08fc7189d0~hH2CRkpFB3103831038epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648633438;
        bh=qs3MfUDSdp11wLoBTwzIFInUyy4OzWxN5MXfRBHpaq8=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=K82N8Fbn79bgfyHuINB4zamgtpfKhz33W111q7vXZeUlU5q7G3cO8k96QbdDoaN1m
         IQzqAqzDd27ViFPy5m8eBgu0EDeZDltu77bk2HCBjjU3Dtt8Vztj0QL+gP3Cis/niv
         iV8id0Psgf4bivj4+jtlQYu5jHnD8sVUkFq5Zwaw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220330094356epcas1p12ee1c40853dcf84e66d39909cb451d60~hH2A5MZI00949709497epcas1p1r;
        Wed, 30 Mar 2022 09:43:56 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.36.226]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KT1j64h0Sz4x9QW; Wed, 30 Mar
        2022 09:43:54 +0000 (GMT)
X-AuditID: b6c32a38-93fff700000255ac-f6-6244265afb00
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.0C.21932.A5624426; Wed, 30 Mar 2022 18:43:54 +0900 (KST)
Mime-Version: 1.0
Subject: RE:(2) (2) (3) (2) (2) Request for reverting the commit for Samsung
 HID driver
Reply-To: junwan.cho@samsung.com
Sender: =?UTF-8?B?7KGw7KSA7JmE?= <junwan.cho@samsung.com>
From:   =?UTF-8?B?7KGw7KSA7JmE?= <junwan.cho@samsung.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        =?UTF-8?B?7KGw7KSA7JmE?= <junwan.cho@samsung.com>
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
In-Reply-To: <YkQiRTve9ZXRhoG7@kroah.com>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220330094354epcms1p282a35cfc39cea0b76125387a496d9284@epcms1p2>
Date:   Wed, 30 Mar 2022 18:43:54 +0900
X-CMS-MailID: 20220330094354epcms1p282a35cfc39cea0b76125387a496d9284
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHJsWRmVeSWpSXmKPExsWy7bCmgW6UmkuSwYELShY/X05jtJhwyt1i
        V8c7VovXx7ezWmz8dYvVYvnNr8wWtxd4WjQvXs9msXXJXFaLW8dbGS02T37EYnHz0zdWi3l/
        17JaTDzYxmqxYOMjRotHKzYxWbzbK+Mg6PG0fyu7x85Zd9k9Nq3qZPPYP3cNu0ffllWMHk2n
        2lk9Pm+SC2CPyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
        dcvMAbpfSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgVqBXnJhbXJqXrpeXWmJl
        aGBgZApUmJCdsX/laZaCNpGK1R8mMzYwdgh3MXJySAiYSHy5uJoRxBYS2MEocfBOcRcjBwev
        gKDE3x1gJcICkRJ9fcuYIUoUJK7vbGCGiFtKbLs/iR3EZhMwl9i6YRUbSKuIQJHEhFdpXYxc
        HMwCe9kkbr6CqJEQ4JWY0f6UBcKWlti+fCvYWk4BTYnbh68zQcRFJW6ufssOY78/Np8RwhaR
        aL13lhnCFpR48HM3VFxSYtbkJVB2scSPD1dYIewSicb5V6Hm6EtMf/IWrJdXwFdi49srYPUs
        AqoSuy+uhbrHRWLn2l9gvcwC2hLLFr5mBvmFGei29bv0IUoUJXb+nssIUcIn8e5rDyvMWzvm
        PYE6X0WiF5hMQFolBKQkrqyPhwh7SKy4+5IZFCRCAr9YJA6cvcE+gVFhFiKgZyFZPAth8QJG
        5lWMYqkFxbnpqcWGBSbwqE3Oz93ECE7IWhY7GOe+/aB3iJGJg/EQowQHs5II78eDzklCvCmJ
        lVWpRfnxRaU5qcWHGE2BXp7ILCWanA/MCXkl8YYmlgYmZkYmFsaWxmZK4ry9U08nCgmkJ5ak
        ZqemFqQWwfQxcXBKNTBVfnjF4Zjx78h8xqNC91Z9DJ4za51Q27vir4cPJl2etS/jaA9HbFpf
        orxWwkM9O9vKVQ1Prb8LvFwxz7DbetqOB61n/y6eEhy4akfO19JaY0kLjykbFiZXTvVZ+k1/
        Blf9iptHtfq2SXdFrOQ8rWHc8GcTq2Jqfug9rVRh+TVrWl/dMnzxqLqy+kWsw5VpcxYosizY
        Vf91Ub39lI7uiKfxHcvmHAr9t/3v8bXPDz8uMGZ4//Pt872f1gcZPD2jfZz9tHCn57qMODYz
        l9Np/Pwz9N49yGO6aDCt88OHC5x8bifuJwR8lN4Uc6xm9sOF6TxNxQtW7Lx//prMRb09vlMf
        Vpzz+DV1b5ztjy+NDKsvLldiKc5INNRiLipOBABMv4uuUQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587
References: <YkQiRTve9ZXRhoG7@kroah.com> <YkQVq1RvWTp1xxJO@kroah.com>
        <YkQRXqlzVjBLbvp2@kroah.com>
        <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
        <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
        <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
        <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
        <20220330084401epcms1p1fe9efa50452a84f7bbb22a4de82b5a0a@epcms1p1>
        <20220330090150epcms1p42e28758b515942ecdee680cdef3ef0b9@epcms1p4>
        <20220330092058epcms1p799e10561617c02a14d5d8b413722f678@epcms1p7>
        <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p2>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Any problmes with my email style?


Anyway, If your commit has to be maintained, the patches I'm going to pu in=
 won't work anyway.
My patches is only for Bluetooth. But your commit restircts usage of Blueto=
oth devices.

What do you think of making new function like =22hid_is_bluetooth=22?


=C2=A0=0D=0A---------=20Original=20Message=20---------=0D=0ASender=20:=20gr=
egkh=40linuxfoundation.org=C2=A0<gregkh=40linuxfoundation.org>=0D=0ADate=20=
:=202022-03-30=2018:26=20(GMT+9)=0D=0ATitle=20:=20Re:=20(2)=20(3)=20(2)=20(=
2)=20Request=20for=20reverting=20the=20commit=20for=20Samsung=20HID=20drive=
r=0D=0A=C2=A0=0D=0AA:=C2=A0http://en.wikipedia.org/wiki/Top_post=0D=0AQ:=C2=
=A0Were=C2=A0do=C2=A0I=C2=A0find=C2=A0info=C2=A0about=C2=A0this=C2=A0thing=
=C2=A0called=C2=A0top-posting?=0D=0AA:=C2=A0Because=C2=A0it=C2=A0messes=C2=
=A0up=C2=A0the=C2=A0order=C2=A0in=C2=A0which=C2=A0people=C2=A0normally=C2=
=A0read=C2=A0text.=0D=0AQ:=C2=A0Why=C2=A0is=C2=A0top-posting=C2=A0such=C2=
=A0a=C2=A0bad=C2=A0thing?=0D=0AA:=C2=A0Top-posting.=0D=0AQ:=C2=A0What=C2=A0=
is=C2=A0the=C2=A0most=C2=A0annoying=C2=A0thing=C2=A0in=C2=A0e-mail?=0D=0A=
=C2=A0=0D=0AA:=C2=A0No.=0D=0AQ:=C2=A0Should=C2=A0I=C2=A0include=C2=A0quotat=
ions=C2=A0after=C2=A0my=C2=A0reply?=0D=0A=C2=A0=0D=0A=C2=A0=0D=0Ahttp://dar=
ingfireball.net/2007/07/on_top=0D=0A=C2=A0=0D=0AOn=C2=A0Wed,=C2=A0Mar=C2=A0=
30,=C2=A02022=C2=A0at=C2=A006:20:58PM=C2=A0+0900,=C2=A0=EC=A1=B0=EC=A4=80=
=EC=99=84=C2=A0wrote:=0D=0A>=C2=A0=0D=0A>=C2=A0No.=C2=A0If=C2=A0so,=C2=A0I=
=C2=A0will=C2=A0not=C2=A0apply=C2=A0in=C2=A0house=C2=A0patches.=0D=0A=C2=A0=
=0D=0AI=C2=A0do=C2=A0not=C2=A0understand=C2=A0what=C2=A0you=C2=A0are=C2=A0r=
eferencing=C2=A0here,=C2=A0sorry.=C2=A0=C2=A0Please=0D=0Aexplain.=0D=0A=C2=
=A0=0D=0A>=C2=A0I'm=C2=A0a=C2=A0Bluetooth=C2=A0person,=C2=A0and=C2=A0I'm=C2=
=A0only=C2=A0interested=C2=A0in=C2=A0Bluetooth=C2=A0devices.=0D=0A=C2=A0=0D=
=0AThat's=C2=A0fine,=C2=A0but=C2=A0this=C2=A0driver,=C2=A0as=C2=A0is=C2=A0i=
n=C2=A0the=C2=A0tree=C2=A0today,=C2=A0does=C2=A0not=C2=A0support=0D=0Abluet=
ooth=C2=A0devices.=C2=A0=C2=A0Please=C2=A0submit=C2=A0a=C2=A0patch=C2=A0to=
=C2=A0resolve=C2=A0that.=0D=0A=C2=A0=0D=0A>=C2=A0Codes=C2=A0for=C2=A0Blueto=
oth=C2=A0devices=C2=A0will=C2=A0never=C2=A0be=C2=A0worked=C2=A0along=C2=A0t=
he=C2=A0commit,=C2=A0anyway,=C2=A0no=C2=A0reason=C2=A0to=C2=A0include=C2=A0=
them.=0D=0A=C2=A0=0D=0AI=C2=A0do=C2=A0not=C2=A0understand.=C2=A0=C2=A0Pleas=
e=C2=A0explain.=0D=0A=C2=A0=0D=0Athanks,=0D=0A=C2=A0=0D=0Agreg=C2=A0k-h=0D=
=0A=C2=A0
