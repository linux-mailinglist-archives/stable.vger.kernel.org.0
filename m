Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2AC84EBE27
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 11:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245057AbiC3KA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 06:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238419AbiC3KA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 06:00:59 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BBAAC93A
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 02:59:13 -0700 (PDT)
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220330095911epoutp0296b2e6403744ecb3ce835902424183e3~hIDUi88-g1314913149epoutp02c
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:59:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220330095911epoutp0296b2e6403744ecb3ce835902424183e3~hIDUi88-g1314913149epoutp02c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648634351;
        bh=SMX2E+s7WR/FmVzFgtJZ9a4kdR/lNHYLH3gXR4ckry4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=FRUggznjCfxp9jUDdN3I1v0a2989i1h6axUGFysx2ZrkjMzg1UtVse8HgfU8Wc8tY
         mpccQFh3oog9MlxAo+41NoeUMuaWTP9aATVDPuZlCTl+9fNeXKlvWDh7A7Zi6Wv0m+
         2z7QyT6qTEBc9/9ySl/MtPcT3Ty5QPvbFvJsa4HE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20220330095910epcas1p46e369f28cb791f9b6fea1c2b60989060~hIDT8Eoz42781427814epcas1p4L;
        Wed, 30 Mar 2022 09:59:10 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.38.240]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KT22h2pDnz4x9QH; Wed, 30 Mar
        2022 09:59:08 +0000 (GMT)
X-AuditID: b6c32a39-003ff70000006fe8-3c-624429eccbbb
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        5F.BC.28648.CE924426; Wed, 30 Mar 2022 18:59:08 +0900 (KST)
Mime-Version: 1.0
Subject: RE:(2) (2) (2) (3) (2) (2) Request for reverting the commit for
 Samsung HID driver
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
In-Reply-To: <YkQnvMpk9cRX8/F9@kroah.com>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220330095806epcms1p34fa55d36ed5ce200fb74a9a23aa279a5@epcms1p3>
Date:   Wed, 30 Mar 2022 18:58:06 +0900
X-CMS-MailID: 20220330095806epcms1p34fa55d36ed5ce200fb74a9a23aa279a5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1CTdRzH/e7Z82yQq4c56duynFO6G8rYdJvPOvBKp66T7jgqO7vT8QhP
        G7Ff7hmcdHFMOiMZ6gwOY4RgYcOBEaPBpnEKdtjBZUegNIzgFp4Mg9REEeVqYyP773Xve39+
        fj9fNsK9iPHZeUYrZTGSeiEWz+y4LBKn/ClS7Zd80ckjHoWqAeHo20mc/3QGJW5f6USJtvkR
        lHAFZhHiRsMbxMdftWKEt7EOJUauHAZEe2WQSQTuPUCJUwvnUOJE9yco0dAWBESwycMgZrpW
        vZagvnncy1L7naMstcd9BFNfrGthqY995wbq0r4yVP235+VM1nv5aTqKzKUsAsqYY8rNM2rT
        hbve0mzTyBUSaYpUSWwWCoykgUoXqjIyU3bk6cP9CwWFpL4gLGWSNC1M3ZJmMRVYKYHORFvT
        hZQ5V29WmMU0aaALjFqxkbK+KpVINsrDxux83Y/2DqbZgx+srR5k2sCF58pBHBviMjh01YWU
        g3g2F/cB+KDBD8oBm83BE+CCb0XEswLfC/sd/ViEubgADvttSFRXwo6xz1gRxvDN0PutG4uE
        8nALdEy9H0mJ4F0YDExFPRDnwM/LbjKj/CLsdHlBhONwEbxkr4npK2GgeZq1xH/11oMo8+Dh
        339CopwAxx9diOkvQGdlY4xpOHdnCI2yFR6qvxbLkwpPTkwvxnLwN6HL1ryoM/EkWGM/G/Oo
        4MOBuUVG8PXw69O3kcgsSLi31vOpUcsa6H9cB6KWZ+HMbAW6NJbv1AQjyuvg0fCdREIhzodD
        rZqorIZNo6HYlutRWOM4jjqAwPl00c7/FXY+LdwAEDdIpMy0QUvRUrP8v7fNMRk8YPGSk5U+
        cHL6jrgHMNigB0A2IuRx7nZv28/l5JJFH1IWk8ZSoKfoHiAPj3wC4a/MMYW/gtGqkcqUEpli
        o4zYpNykED7PcVf3k1xcS1qpfIoyU5alOAY7jm9jHJqExMO6Cmz06IHepi9N/5gKzdfc8Zk7
        l8vm513jvop37M5fatd/c3VHMCW06m7W4Nn7B6vvQyy5l/9EU7r8knfy1s9rKkW494+OV34V
        nS5abdCtvXxgV/tj2Rl1IB+1D2yx1P7mrH0y421Na1y9NYEnabHutk6+mwR6skdYy3SVfZji
        mf6t2GDbB9mTpQO2LJ62rFnPU50rLK6quZEzzC6pWMvbsLv+I7GmfU/neLa/+Dp8O3Huh6p9
        10vaJNPLvj/2+i3lhn1VzduHu1izeVkTIV+5GF+3d8/2e1O+RP0ZbkZLyUv6eFWxyeUfLSo8
        QvUG3Rx5FUgiQ2MLY03dGUImrSOlyYiFJv8FgtvIrFIEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587
References: <YkQnvMpk9cRX8/F9@kroah.com> <YkQRXqlzVjBLbvp2@kroah.com>
        <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
        <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
        <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
        <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
        <20220330084401epcms1p1fe9efa50452a84f7bbb22a4de82b5a0a@epcms1p1>
        <20220330090150epcms1p42e28758b515942ecdee680cdef3ef0b9@epcms1p4>
        <20220330092058epcms1p799e10561617c02a14d5d8b413722f678@epcms1p7>
        <20220330094354epcms1p282a35cfc39cea0b76125387a496d9284@epcms1p2>
        <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p3>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

You are the first person to point this out while exchanging emails.
I don't know how to send in your favorite style in our mail system.
This is the last email, so don't be annoyed.

Anyway because of your commit, Bluetooth accesorries cannot use Samsung dri=
ver.
Our driver will be well customized by us.


Thank you for your time.
=C2=A0=0D=0A---------=20Original=20Message=20---------=0D=0ASender=20:=20gr=
egkh=40linuxfoundation.org=C2=A0<gregkh=40linuxfoundation.org>=0D=0ADate=20=
:=202022-03-30=2018:49=20(GMT+9)=0D=0ATitle=20:=20Re:=20(2)=20(2)=20(3)=20(=
2)=20(2)=20Request=20for=20reverting=20the=20commit=20for=20Samsung=20HID=
=20driver=0D=0A=C2=A0=0D=0AOn=C2=A0Wed,=C2=A0Mar=C2=A030,=C2=A02022=C2=A0at=
=C2=A006:43:54PM=C2=A0+0900,=C2=A0=EC=A1=B0=EC=A4=80=EC=99=84=C2=A0wrote:=
=0D=0A>=C2=A0=0D=0A>=C2=A0Any=C2=A0problmes=C2=A0with=C2=A0my=C2=A0email=C2=
=A0style?=0D=0A=C2=A0=0D=0AYes,=C2=A0please=C2=A0do=C2=A0not=C2=A0top-post.=
=C2=A0=C2=A0Read=C2=A0the=C2=A0links=C2=A0I=C2=A0provided=C2=A0in=C2=A0my=
=C2=A0last=0D=0Aresponse.=0D=0A=C2=A0=0D=0A>=C2=A0Anyway,=C2=A0If=C2=A0your=
=C2=A0commit=C2=A0has=C2=A0to=C2=A0be=C2=A0maintained,=C2=A0the=C2=A0patche=
s=C2=A0I'm=C2=A0going=C2=A0to=C2=A0pu=C2=A0in=C2=A0won't=C2=A0work=C2=A0any=
way.=0D=0A=C2=A0=0D=0AThen=C2=A0you=C2=A0will=C2=A0need=C2=A0to=C2=A0change=
=C2=A0the=C2=A0driver=C2=A0to=C2=A0work=C2=A0properly.=C2=A0=C2=A0This=C2=
=A0is=C2=A0not=C2=A0a=0D=0Abig=C2=A0problem.=0D=0A=C2=A0=0D=0A>=C2=A0My=C2=
=A0patches=C2=A0is=C2=A0only=C2=A0for=C2=A0Bluetooth.=C2=A0But=C2=A0your=C2=
=A0commit=C2=A0restircts=C2=A0usage=C2=A0of=C2=A0Bluetooth=C2=A0devices.=0D=
=0A=C2=A0=0D=0AYes,=C2=A0so=C2=A0change=C2=A0the=C2=A0driver=C2=A0to=C2=A0s=
upport=C2=A0both=C2=A0properly.=0D=0A=C2=A0=0D=0A>=C2=A0What=C2=A0do=C2=A0y=
ou=C2=A0think=C2=A0of=C2=A0making=C2=A0new=C2=A0function=C2=A0like=C2=A0=22=
hid_is_bluetooth=22?=0D=0A=C2=A0=0D=0AI=C2=A0do=C2=A0not=C2=A0think=C2=A0th=
at=C2=A0is=C2=A0necessary=C2=A0here=C2=A0at=C2=A0all.=0D=0A=C2=A0=0D=0Athan=
ks,=0D=0A=C2=A0=0D=0Agreg=C2=A0k-h=0D=0A=C2=A0
