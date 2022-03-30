Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150004EBCDF
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 10:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244415AbiC3Iqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 04:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235006AbiC3Iqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 04:46:54 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1230C91AE0
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 01:45:07 -0700 (PDT)
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220330084505epoutp0116930f64da0f6acb8c9b61f4fe144aaf~hHCogXMXl2339923399epoutp011
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:45:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220330084505epoutp0116930f64da0f6acb8c9b61f4fe144aaf~hHCogXMXl2339923399epoutp011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648629905;
        bh=+9zo03HURKKdKkhJ9IRbQgxbrsoaL49cjn3kTHTImk4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=BtTQcoStq/oALJHEHAe5iCmI/aGyM3X9tSFb5pHejeVWySDDhJ5qnsZx3qq7OhnRz
         tfjCEQF2AAF67tlOUrEViVOxARa+K3VW5p1e6yPzy5GDW76MECizdqaLIXsbQT5ZxU
         INP4W5EGjOUx/kpdWzs7hv6jPWiQImZkV9V6DLn4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20220330084505epcas1p3784a9dd3b67b177031f718895f41886f~hHCn5kwnc1572415724epcas1p3T;
        Wed, 30 Mar 2022 08:45:05 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.38.243]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4KT0PB63yRz4x9QH; Wed, 30 Mar
        2022 08:45:02 +0000 (GMT)
X-AuditID: b6c32a38-93fff700000255ac-a9-6244188e00bb
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        93.20.21932.E8814426; Wed, 30 Mar 2022 17:45:02 +0900 (KST)
Mime-Version: 1.0
Subject: RE:(2) (2) (2) Request for reverting the commit for Samsung HID
 driver
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
In-Reply-To: <YkQVq1RvWTp1xxJO@kroah.com>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220330084401epcms1p1fe9efa50452a84f7bbb22a4de82b5a0a@epcms1p1>
Date:   Wed, 30 Mar 2022 17:44:01 +0900
X-CMS-MailID: 20220330084401epcms1p1fe9efa50452a84f7bbb22a4de82b5a0a
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHJsWRmVeSWpSXmKPExsWy7bCmgW6fhEuSwbUb+hY/X05jtJhwyt1i
        V8c7VovXx7ezWmz8dYvVYvnNr8wWtxd4WjQvXs9msXXJXFaLW8dbGS02T37EYnHz0zdWi3l/
        17JaTDzYxmqxYOMjRotHKzYxWbzbK+Mg6PG0fyu7x85Zd9k9Nq3qZPPYP3cNu0ffllWMHk2n
        2lk9Pm+SC2CPyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
        dcvMAbpfSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgVqBXnJhbXJqXrpeXWmJl
        aGBgZApUmJCd0fhjMlPBLsmKg/fOsTQwXpLoYuTkkBAwkfh9so+1i5GLQ0hgB6PEhw9vWLoY
        OTh4BQQl/u4QBjGFBQIlLrwoACkXElCQuL6zgRnEFhawlNh2fxI7iM0mYC6xdcMqNpByEYEi
        iQmv0kAmMgvsZZO4+QqiRkKAV2JG+1MWCFtaYvvyrYwgNqeApkTj1A3MEHFRiZur37LD2O+P
        zWeEsEUkWu+dhaoRlHjwczdUXFJi1uQlUHaxxI8PV1gh7BKJxvlXoeboS0x/8hasl1fAV+LT
        5I1g9SwCqhJfVnZD1bhITGp4BRZnFtCWWLbwNTPIL8xAt63fpQ9Roiix8/dcqBI+iXdfe1hh
        3tox7wkThK0i0QtMJiCtEgJSElfWx0OEPSRW3H3JDAnkfmaJ65/msUxgVJiFCOdZSBbPQli8
        gJF5FaNYakFxbnpqsWGBCTxqk/NzNzGCE7KWxQ7GuW8/6B1iZOJgPMQowcGsJML78aBzkhBv
        SmJlVWpRfnxRaU5q8SFGU6CXJzJLiSbnA3NCXkm8oYmlgYmZkYmFsaWxmZI4b+/U04lCAumJ
        JanZqakFqUUwfUwcnFINTNbapzbtNDkY373khrnwo+7yH4Ubgw/qXG6VTjW3/azp+8z/pWl0
        befcbUG2Auz3Er/mptgvC5h+b4bRtvVmzFtOTSl5NIs1PVPk46tZC9INhdR1t5TVTv/jJBdy
        wXDbCgMlgRVxcmyH7QMW+PP/fcFXza990E/N7OOkMx9vSmcs63n6sejSmpR4hd4ZlzRKHHfs
        +h4asevbq5fOYRcSbJ6ZHXfTj1vQ9JLx/rIEM4nP09KrD27b1HshbYdQ9vLn32Xb3v8MFLzL
        yafK61t0iJFX/W3JiQudWsWJqVaCEmz+SULhHNN7k64s+md56/j5CH+nQPZZJdILF57bYD9R
        8frKpv/Pz3zQPR1b+n3rTiWW4oxEQy3mouJEABBeGFFRBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587
References: <YkQVq1RvWTp1xxJO@kroah.com> <YkQRXqlzVjBLbvp2@kroah.com>
        <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
        <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
        <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
        <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
        <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p1>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Sorry that I'm not familier with policy of Linux.
That means I cannot add the code to support Bluetoth accessories=C2=A0in=20=
Linux=20Main=20line?=0D=0ASamsung's=20Bluetooth=20accessories=20can't=20be=
=20supported=20forever=20on=20a=20Linux=20PC?=0D=0A=0D=0ACould=20you=20shar=
e=20any=20material=20or=20link=20for=20exploit=20related=20with=20this=20co=
mmit?=0D=0A=0D=0A=C2=A0=0D=0A---------=20Original=20Message=20---------=0D=
=0ASender=20:=20gregkh=40linuxfoundation.org=C2=A0<gregkh=40linuxfoundation=
.org>=0D=0ADate=20:=202022-03-30=2017:32=20(GMT+9)=0D=0ATitle=20:=20Re:=20(=
2)=20(2)=20Request=20for=20reverting=20the=20commit=20for=20Samsung=20HID=
=20driver=0D=0A=C2=A0=0D=0AOn=C2=A0Wed,=C2=A0Mar=C2=A030,=C2=A02022=C2=A0at=
=C2=A005:23:08PM=C2=A0+0900,=C2=A0=EC=A1=B0=EC=A4=80=EC=99=84=C2=A0wrote:=
=0D=0A>=C2=A0=0D=0A>=C2=A0=0D=0A>=C2=A0As=C2=A0I=C2=A0said,=C2=A0AP=C2=A0ma=
nufacturers=C2=A0don't=C2=A0consider=C2=A0validation=C2=A0of=C2=A0patches.=
=0D=0A=C2=A0=0D=0AThat=C2=A0is=C2=A0not=C2=A0our=C2=A0issue,=C2=A0but=C2=A0=
yours.=0D=0A=C2=A0=0D=0A>=C2=A0They=C2=A0just=C2=A0import=C2=A0linux=C2=A0p=
atches=C2=A0into=C2=A0their=C2=A0Board=C2=A0Support=C2=A0Packages=C2=A0with=
out=C2=A0consideration.=0D=0A=C2=A0=0D=0AThat=C2=A0is=C2=A0good=C2=A0for=C2=
=A0our=C2=A0changes,=C2=A0but=C2=A0not=C2=A0for=C2=A0yours.=0D=0A=C2=A0=0D=
=0A>=C2=A0So,=C2=A0I=C2=A0can=C2=A0remove=C2=A0the=C2=A0condition=C2=A0that=
=C2=A0you=C2=A0made=C2=A0once=C2=A0I=C2=A0add=C2=A0Bluetooh=C2=A0accessorie=
s=C2=A0to=C2=A0Samsung=C2=A0driver=C2=A0in=C2=A0Linux=C2=A0Mainline?=0D=0A=
=C2=A0=0D=0ANo,=C2=A0not=C2=A0at=C2=A0all=C2=A0unless=C2=A0you=C2=A0wish=C2=
=A0to=C2=A0have=C2=A0a=C2=A0broken=C2=A0system?=0D=0A=C2=A0=0D=0AAgain,=C2=
=A0you=C2=A0have=C2=A0the=C2=A0budget=C2=A0and=C2=A0resources=C2=A0to=C2=A0=
handle=C2=A0the=C2=A0maintenance=C2=A0and=0D=0Asupport=C2=A0of=C2=A0your=C2=
=A0out-of-tree=C2=A0changes.=C2=A0=C2=A0That=C2=A0is=C2=A0your=C2=A0respons=
ibility=C2=A0to=0D=0Ayour=C2=A0customers=C2=A0as=C2=A0per=C2=A0your=C2=A0co=
ntracts=C2=A0with=C2=A0them.=0D=0A=C2=A0=0D=0AAs=C2=A0written,=C2=A0the=C2=
=A0in-kernel=C2=A0code=C2=A0is=C2=A0correct=C2=A0and=C2=A0now=C2=A0fixed.=
=C2=A0=C2=A0If=C2=A0you=C2=A0have=0D=0Amodified=C2=A0the=C2=A0driver=C2=A0t=
o=C2=A0do=C2=A0something=C2=A0else,=C2=A0it=C2=A0is=C2=A0your=C2=A0responsi=
bility=C2=A0to=0D=0Aensure=C2=A0that=C2=A0it=C2=A0remains=C2=A0working=C2=
=A0as=C2=A0there=C2=A0is=C2=A0nothing=C2=A0that=C2=A0we=C2=A0can=C2=A0do=C2=
=A0about=0D=0Athat=C2=A0for=C2=A0obvious=C2=A0reasons.=0D=0A=C2=A0=0D=0AAnd=
=C2=A0again,=C2=A0if=C2=A0you=C2=A0remove=C2=A0those=C2=A0lines,=C2=A0you=
=C2=A0have=C2=A0a=C2=A0known=C2=A0insecure=C2=A0system,=0D=0Awhich=C2=A0I=
=C2=A0doubt=C2=A0you=C2=A0want=C2=A0for=C2=A0your=C2=A0devices.=0D=0A=C2=A0=
=0D=0APlease=C2=A0discuss=C2=A0this=C2=A0with=C2=A0your=C2=A0management=C2=
=A0as=C2=A0they=C2=A0understand=C2=A0the=C2=A0risks=0D=0Aand=C2=A0responsib=
ilities=C2=A0that=C2=A0you=C2=A0have=C2=A0undertaken=C2=A0by=C2=A0having=C2=
=A0out-of-tree=0D=0Acode.=C2=A0=C2=A0That=C2=A0is=C2=A0not=C2=A0our=C2=A0re=
sponsibility,=C2=A0but=C2=A0yours.=0D=0A=C2=A0=0D=0Athanks,=0D=0A=C2=A0=0D=
=0Agreg=C2=A0k-h=0D=0A=C2=A0
