Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0384EBCAF
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 10:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239965AbiC3I0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 04:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiC3I0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 04:26:00 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0D44A3F2
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 01:24:14 -0700 (PDT)
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220330082412epoutp025009725f717297e59d13ee258756069d~hGwZcvx3u1868518685epoutp02S
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:24:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220330082412epoutp025009725f717297e59d13ee258756069d~hGwZcvx3u1868518685epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648628652;
        bh=gh8Dr58LLTSzU27UcUbRs4p+GvvsjXRc+eoKpqhsvok=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=ZDQ9epTQfmgSY1bYHypUjBObUjCiGiK+093znSdXWzY4FAnDqNZNHYdh7BNKHmOaU
         JtCb+p9Nc9ACf5PzSyqlytKZMAftPdlhMi6qor22t83SkPrDyuIbdJ8EAXXbTJYVKk
         ZNvWzCpAyjD4WdtqAJBf63r2gL9KXYlV7X4q/wAE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20220330082411epcas1p4c7d088f2f0c72aa008fa452c9c1a15eb~hGwYw6st50164801648epcas1p4h;
        Wed, 30 Mar 2022 08:24:11 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.38.249]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KSzx54vbBz4x9Pw; Wed, 30 Mar
        2022 08:24:09 +0000 (GMT)
X-AuditID: b6c32a39-ff1ff70000006fe8-35-624413a9c2a8
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        AD.59.28648.9A314426; Wed, 30 Mar 2022 17:24:09 +0900 (KST)
Mime-Version: 1.0
Subject: RE:(2) (2) Request for reverting the commit for Samsung HID driver
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
In-Reply-To: <YkQRXqlzVjBLbvp2@kroah.com>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
Date:   Wed, 30 Mar 2022 17:23:08 +0900
X-CMS-MailID: 20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1CTdRzH++7Zsw1q+jCwvmHXjSehAw7YcINnCuQFVyOgI7q8rrPWIzwB
        B2xrz/Ag/QMlEAl0OA7cDnDKj+EkFj+Gg1LOUVJA/ANEwwOMYyl6IGqS4JFtPCP773Xve39+
        fj9fHiK4xgnk5Sq1lEZJ5uMcX3bfUGhUxCX/pMOi++ZgYn2pDhC6kXeJgYoVlLg3fAUlujZm
        UMLsfIwQN03JRGmzlUPYWhpRYma4DBA9+gU24Xy4hhJNm9+iRM31cpQwdS0AYqG9m0WsXH3t
        gJ/cdcbGlfcbZ7nybsspjnywsYMrP91rAfITIydR+aPu19O5n+TF5VBkFqURUspMVVauMjse
        T/lQkaiQxojEEWIZEYsLlWQBFY8npaZHvJOb7+4fFx4h8wvdUjpJ03hUQpxGVailhDkqWhuP
        U+qsfHWMOpImC+hCZXakktLuE4tE0VK38fO8nDV9P0s9H1J07WsDqwS0BlcCHg9iEvjzLKgE
        vjwBZgdQr29APTof84Obdv9K4MPzx1LgkqkG9bAAE8Lp/hKE0WWwb/4s18McLBbavrNwPKEB
        mAbq7n7hSYlgVznQeZfxQIwPz510sRneDa+YbcDDPlgotE0OAUbfBZ2Xl7nbfP/Gea8eAMvm
        fkUY9oO31r/36q9Co77FyzR8sjqJMqyFx89PefNEwfrF5a1YPpYG5y9OsTzMxoLheKnJ208S
        NFR3beVBsHDYduEe4pkFcfdmHYhiLEGw/2mj17IDrjyuQrfHsjctshjeA6vdZ8JsNhBOWhWM
        LIfts0sIs+VOFuxtWQc6IDQ+X7Txf4WNzwubAGIBL1NquiCbosVq6X9Pm6kq6AZbhxwms4P6
        5dVIB2DxgANAHoIH8B9cTzws4GeRxV9RGpVCU5hP0Q4gdY9cgwTuylS5f4JSqxBLZCJJTLSE
        2CvbG4O/wrfUjZICLJvUUnkUpaY023Esnk9gCSsu4I2DL8x1VNmHOmpajzrGz9Xy1mBnscP5
        /sNvguJ8z4h7VOb2DJF84oPiz2Tm5Z6XDPGu36b+yct8ULXfbPf/ZUQyqNGOWcRL3DdjpYtv
        Pf1xJtT+ceqz0aK/wg2bz/C2alfF2Eeljamtw8mT07pHQUpjW+KLvbcKDUf2TYAn41Z4e7U9
        IyE9uvambCPZL8tGmdIarM6xQyHH9g9O7zy4pylqd4qx4lMKeft4w/rf9adDEvoI/s6BHWJ9
        +OhQaTP1e9EP5ZeSmy93ppfV6/sP/HnqWFpLceUfjjC+dTDsPXN5ievonUMnTJt3am/rMjpb
        G2/89GWeoM4Ynhw6tyEx9E3gbDqHFIchGpr8F4Q8amdRBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587
References: <YkQRXqlzVjBLbvp2@kroah.com>
        <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
        <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
        <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
        <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p3>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



As I said, AP manufacturers don't consider validation of patches.
They just import linux patches into their Board Support Packages without co=
nsideration.


So, I can remove the condition that you made once I add Bluetooh accessorie=
s to Samsung driver in Linux Mainline?



--------- Original Message ---------
Sender : gregkh=40linuxfoundation.org=C2=A0<gregkh=40linuxfoundation.org>=
=0D=0ADate=20:=202022-03-30=2017:14=20(GMT+9)=0D=0ATitle=20:=20Re:=20(2)=20=
Request=20for=20reverting=20the=20commit=20for=20Samsung=20HID=20driver=0D=
=0A=C2=A0=0D=0AOn=C2=A0Wed,=C2=A0Mar=C2=A030,=C2=A02022=C2=A0at=C2=A005:09:=
37PM=C2=A0+0900,=C2=A0=EC=A1=B0=EC=A4=80=EC=99=84=C2=A0wrote:=0D=0A>=C2=A0=
=0D=0A>=C2=A0Dear=C2=A0Jiri=C2=A0Kosina,=0D=0A>=C2=A0=0D=0A>=C2=A0Thank=C2=
=A0you=C2=A0for=C2=A0your=C2=A0propt=C2=A0reponse.=0D=0A>=C2=A0=0D=0A>=C2=
=A0=0D=0A>=C2=A0Please=C2=A0refer=C2=A0to=C2=A0accossories=C2=A0below.=0D=
=0A>=C2=A0=0D=0A>=C2=A0=0D=0A>=C2=A0static=C2=A0const=C2=A0struct=C2=A0hid_=
device_id=C2=A0samsung_devices=5B=5D=C2=A0=3D=C2=A0=7B=0D=0A>=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=7B=C2=A0HID_USB_DEVICE(USB_VENDO=
R_ID_SAMSUNG,=C2=A0USB_DEVICE_ID_SAMSUNG_IR_REMOTE)=C2=A0=7D,=0D=0A>=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=7B=C2=A0HID_USB_DEVICE(USB=
_VENDOR_ID_SAMSUNG,=C2=A0USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE)=C2=A0=7D=
,=0D=0A>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=7B=C2=A0HID_BLUETOOTH_DEVICE(USB_VEN=
DOR_ID_SAMSUNG_ELECTRONICS,=C2=A0USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD)=C2=A0=
=7D,=0D=0A>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=7B=C2=A0HID_BLUETOOTH_DEVICE(USB_=
VENDOR_ID_SAMSUNG_ELECTRONICS,=C2=A0USB_DEVICE_ID_SAMSUNG_WIRELESS_GAMEPAD)=
=C2=A0=7D,=0D=0A>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=7B=C2=A0HID_BLUETOOTH_DEVIC=
E(USB_VENDOR_ID_SAMSUNG_ELECTRONICS,=C2=A0USB_DEVICE_ID_SAMSUNG_WIRELESS_AC=
TIONMOUSE)=C2=A0=7D,=0D=0A>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=7B=C2=A0HID_BLUET=
OOTH_DEVICE(USB_VENDOR_ID_SAMSUNG_ELECTRONICS,=C2=A0USB_DEVICE_ID_SAMSUNG_W=
IRELESS_UNIVERSAL_KBD)=C2=A0=7D,=0D=0A>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=7B=C2=
=A0HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SAMSUNG_ELECTRONICS,=C2=A0USB_DEVICE_=
ID_SAMSUNG_WIRELESS_MULTI_HOGP_KBD)=C2=A0=7D,=0D=0A>=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=7B=C2=A0=7D=0D=0A>=C2=A0=7D;=0D=0A>=C2=A0=
MODULE_DEVICE_TABLE(hid,=C2=A0samsung_devices);=0D=0A>=C2=A0=0D=0A>=C2=A0=
=0D=0A>=C2=A0Mobile=C2=A0users=C2=A0prefer=C2=A0to=C2=A0use=C2=A0Bluetooth=
=C2=A0devices=C2=A0instead=C2=A0of=C2=A0USB=C2=A0devices.=0D=0A>=C2=A0The=
=C2=A0commit=C2=A0should=C2=A0be=C2=A0reverted=C2=A0for=C2=A0Bluetooth=C2=
=A0accessories.=0D=0A>=C2=A0=0D=0A>=C2=A0Due=C2=A0to=C2=A0internal=C2=A0pro=
blem,=C2=A0it=C2=A0takes=C2=A0time=C2=A0to=C2=A0upload=C2=A0Samsung's=C2=A0=
patch.=0D=0A>=C2=A0So,=C2=A0please=C2=A0first=C2=A0revert=C2=A0the=C2=A0com=
mit=C2=A0:)=0D=0A=C2=A0=0D=0ANo,=C2=A0not=C2=A0at=C2=A0all.=0D=0A=C2=A0=0D=
=0AThe=C2=A0commit=C2=A0is=C2=A0correct,=C2=A0as=C2=A0the=C2=A0driver=C2=A0=
code,=C2=A0as=C2=A0contained=C2=A0in=C2=A0the=C2=A0kernel=0D=0Atree,=C2=A0r=
equires=C2=A0that=C2=A0check=C2=A0to=C2=A0solve=C2=A0a=C2=A0problem=C2=A0wh=
ere=C2=A0this=C2=A0driver=C2=A0can=C2=A0be=0D=0Aused=C2=A0to=C2=A0exploit=
=C2=A0the=C2=A0system.=0D=0A=C2=A0=0D=0AAny=C2=A0out-of-tree=C2=A0changes=
=C2=A0you=C2=A0make,=C2=A0you=C2=A0are=C2=A0required=C2=A0to=C2=A0maintain=
=C2=A0and=C2=A0keep=0D=0Aup=C2=A0to=C2=A0date=C2=A0in=C2=A0order=C2=A0to=C2=
=A0have=C2=A0them=C2=A0remain=C2=A0working.=C2=A0=C2=A0That=C2=A0is=C2=A0a=
=C2=A0requirement=0D=0Aof=C2=A0you,=C2=A0we=C2=A0have=C2=A0no=C2=A0idea=C2=
=A0what=C2=A0changes=C2=A0anyone=C2=A0else=C2=A0makes,=C2=A0that=C2=A0would=
=C2=A0be=0D=0Aimpossible.=0D=0A=C2=A0=0D=0AThis=C2=A0is=C2=A0the=C2=A0real=
=C2=A0cost=C2=A0of=C2=A0keeping=C2=A0out-of-tree=C2=A0changes,=C2=A0your=C2=
=A0management=0D=0Aknows=C2=A0this=C2=A0and=C2=A0plans=C2=A0for=C2=A0it=C2=
=A0in=C2=A0their=C2=A0budgeting.=C2=A0=C2=A0There=C2=A0is=C2=A0nothing=C2=
=A0that=0D=0Awe=C2=A0can=C2=A0do=C2=A0about=C2=A0this.=0D=0A=C2=A0=0D=0ASo=
=C2=A0the=C2=A0change=C2=A0needs=C2=A0to=C2=A0remain=C2=A0in=C2=A0order=C2=
=A0for=C2=A0the=C2=A0code=C2=A0to=C2=A0be=C2=A0correct.=0D=0AWithout=C2=A0i=
t,=C2=A0you=C2=A0have=C2=A0a=C2=A0broken=C2=A0and=C2=A0totally=C2=A0insecur=
e=C2=A0system.=0D=0A=C2=A0=0D=0AIf=C2=A0you=C2=A0wish=C2=A0to=C2=A0make=C2=
=A0the=C2=A0changes=C2=A0you=C2=A0list=C2=A0above=C2=A0to=C2=A0the=C2=A0dri=
ver,=C2=A0you=C2=A0now=0D=0Aneed=C2=A0to=C2=A0make=C2=A0more=C2=A0changes=
=C2=A0in=C2=A0order=C2=A0to=C2=A0properly=C2=A0handle=C2=A0the=C2=A0fixes=
=C2=A0we=C2=A0made=0D=0Ato=C2=A0the=C2=A0code.=C2=A0=C2=A0Please=C2=A0submi=
t=C2=A0your=C2=A0changes=C2=A0so=C2=A0that=C2=A0we=C2=A0can=C2=A0review=C2=
=A0them=C2=A0and=0D=0Aaccept=C2=A0them=C2=A0if=C2=A0they=C2=A0are=C2=A0corr=
ect.=0D=0A=C2=A0=0D=0Athanks,=0D=0A=C2=A0=0D=0Agreg=C2=A0k-h=0D=0A=C2=A0
