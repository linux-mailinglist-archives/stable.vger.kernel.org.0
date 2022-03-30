Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6884EBC67
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 10:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244108AbiC3ILd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 04:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244107AbiC3ILa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 04:11:30 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD362E9C6
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 01:09:43 -0700 (PDT)
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220330080940epoutp046ed7e8b5a37d364acca8651d65476de1~hGjtISgxd2677726777epoutp04m
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:09:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220330080940epoutp046ed7e8b5a37d364acca8651d65476de1~hGjtISgxd2677726777epoutp04m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648627780;
        bh=oIz+AE6Xzia4TBFNmDbIV3dyybDCOlgXYDikWpN/4Ko=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=fpzIieF0N6OSSlVlU5GbFxJ4IylG8ewZWRYjOyUgdwO9q/C0fQteXk2HQZzovfIXc
         lkSfJiyKcKzU2tzDFGpsATTbO+1696UP6ZtUWNLHsyt5wv/47giPsUxB3NY+eUg+M6
         me1AfLz9T0FUJ7ciSrh+vWJOTKaYFryL4HbaaK0w=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220330080939epcas1p132e9d26849dec704183e5add699d4210~hGjsbzL5q1039910399epcas1p10;
        Wed, 30 Mar 2022 08:09:39 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.36.225]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KSzcK4nshz4x9QP; Wed, 30 Mar
        2022 08:09:37 +0000 (GMT)
X-AuditID: b6c32a37-ab31da8000002578-0c-624410415120
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        A5.01.09592.14014426; Wed, 30 Mar 2022 17:09:37 +0900 (KST)
Mime-Version: 1.0
Subject: RE:(2) Request for reverting the commit for Samsung HID driver
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
In-Reply-To: <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
Date:   Wed, 30 Mar 2022 17:09:37 +0900
X-CMS-MailID: 20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLJsWRmVeSWpSXmKPExsWy7bCmnq6jgEuSwcXnyhY/X05jtJhwyt1i
        V8c7VovXx7ezWmz8dYvVYvnNr8wWtxd4WjQvXs9msXXJXFaLW8dbGS02T37EYnHz0zdWi3l/
        17JaTDzYxmqxYOMjRotHKzYxWbzbK+Mg6PG0fyu7x85Zd9k9Nq3qZPPYP3cNu0ffllWMHk2n
        2lk9Pm+SC2CPyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
        dcvMAbpfSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgVqBXnJhbXJqXrpeXWmJl
        aGBgZApUmJCdsXPFB8aCH3YVPz/dZmtgnGXTxcjJISFgInH46XXGLkYuDiGBHYwSR5ZcBnI4
        OHgFBCX+7hAGMYUF3CUePCoEKRcSUJC4vrOBGcQWFrCU2HZ/EjuIzSZgLrF1wyo2EFtEIFxi
        8Yz37CAjmQVusUlMWv+RHWIXr8SM9qcsELa0xPblWxlBbE4BB4k5f3+yQsRFJW6ufssOY78/
        Np8RwhaRaL13lhnCFpR48HM3VFxSYtbkJVB2scSPD1eg5pRINM6/CjVHX2L6k7dgvbwCvhLL
        Wn6wgfzFIqAqsavbHsSUEHCReHHNAqSCWUBbYtnC18wgYWYBTYn1u/QhhihK7Pw9lxGihE/i
        3dceVpindsx7wgRhq0j0AlMJxEQpiSvr4yHCHhIr7r5khoTxaUaJr39/sU5gVJiFCOZZSBbP
        Qli8gJF5FaNYakFxbnpqsWGBMTxmk/NzNzGC07GW+Q7GaW8/6B1iZOJgPMQowcGsJML78aBz
        khBvSmJlVWpRfnxRaU5q8SFGU6CHJzJLiSbnAzNCXkm8oYmlgYmZkYmFsaWxmZI476pppxOF
        BNITS1KzU1MLUotg+pg4OKUamJSU56o47Zyrq60f5pM72+vYjaDuf8d4fRfe6GUwFfy898vj
        LkF5vs7qZ78/pb7luX9l6+NPh2V+2a92d5lzdUOKKr/b7GQWxk3fuM2fhT9Z2e44h21G0srd
        3WvW/Ge6nSA//7p9gPppKb6Va/RFg/4nhay54VV+xGVdjv2UiXujZvYEsc4qKLr35h9Hmdyl
        WmutP3tXWbz3PrlI7cCq1y0t95atkWk5fayr7vuZivo1e5cFzS/9J+/ZEOV8J0FP+p1zZjVr
        UfmpDXXZnlPSlX71CzM7VKm7/Zl6V1/TT8Hn/Tw1Ra0fVX0GJlYxG19LMPPyK5zccoOp2/1p
        jYSZT5DIwVer+p4v1GPwn7V+mxJLcUaioRZzUXEiAAZlpClQBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587
References: <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
        <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
        <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p5>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Dear Jiri Kosina,

Thank you for your propt reponse.


Please refer to accossories below.


static const struct hid_device_id samsung_devices=5B=5D =3D =7B
	=7B HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE)=
 =7D,
	=7B HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_K=
BD_MOUSE) =7D,
    =7B HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SAMSUNG_ELECTRONICS, USB_DEVICE_=
ID_SAMSUNG_WIRELESS_KBD) =7D,
    =7B HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SAMSUNG_ELECTRONICS, USB_DEVICE_=
ID_SAMSUNG_WIRELESS_GAMEPAD) =7D,
    =7B HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SAMSUNG_ELECTRONICS, USB_DEVICE_=
ID_SAMSUNG_WIRELESS_ACTIONMOUSE) =7D,
    =7B HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SAMSUNG_ELECTRONICS, USB_DEVICE_=
ID_SAMSUNG_WIRELESS_UNIVERSAL_KBD) =7D,
    =7B HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SAMSUNG_ELECTRONICS, USB_DEVICE_=
ID_SAMSUNG_WIRELESS_MULTI_HOGP_KBD) =7D,
	=7B =7D
=7D;
MODULE_DEVICE_TABLE(hid, samsung_devices);


Mobile users prefer to use Bluetooth devices instead of USB devices.
The commit should be reverted for Bluetooth accessories.

Due to internal problem, it takes time to upload Samsung's patch.
So, please first revert the commit :)

Thanks

BR.
Junwan.

=C2=A0=0D=0A---------=C2=A0Original=C2=A0Message=C2=A0---------=0D=0ASender=
=C2=A0:=C2=A0Jiri=C2=A0Kosina=C2=A0<jikos=40kernel.org>=0D=0ADate=C2=A0:=C2=
=A02022-03-30=C2=A016:52=C2=A0(GMT+9)=0D=0ATitle=C2=A0:=C2=A0Re:=C2=A0Reque=
st=C2=A0for=C2=A0reverting=C2=A0the=C2=A0commit=C2=A0for=C2=A0Samsung=C2=A0=
HID=C2=A0driver=0D=0A=C2=A0=0D=0AOn=C2=A0Wed,=C2=A030=C2=A0Mar=C2=A02022,=
=C2=A0=EC=A1=B0=EC=A4=80=EC=99=84=C2=A0wrote:=0D=0A=C2=A0=0D=0A>=C2=A0autho=
r=0D=0A>=C2=A0Greg=C2=A0Kroah-Hartman=C2=A0<gregkh=40linuxfoundation.org>=
=C2=A02021-12-01=C2=A019:35:03=C2=A0+0100=0D=0A>=C2=A0=0D=0A>=C2=A0committe=
r=0D=0A>=C2=A0Benjamin=C2=A0Tissoires=C2=A0<benjamin.tissoires=40redhat.com=
>=C2=A02021-12-02=C2=A015:36:18=C2=A0+0100=0D=0A>=C2=A0=0D=0A>=C2=A0commit=
=0D=0A>=C2=A093020953d0fa7035fd036ad87a47ae2b7aa4ae33=C2=A0(patch)=0D=0A>=
=C2=A0=0D=0A>=C2=A0tree=0D=0A>=C2=A0f734e9962e28cedcccfbb109e510d39a18ed6d3=
4=C2=A0/drivers/hid/hid-samsung.c=0D=0A>=C2=A0=0D=0A>=C2=A0parent=0D=0A>=C2=
=A0720ac467204a70308bd687927ed475afb904e11b=C2=A0(diff)=0D=0A>=C2=A0=0D=0A>=
=C2=A0download=0D=0A>=C2=A0linux-93020953d0fa7035fd036ad87a47ae2b7aa4ae33.t=
ar.gz=0D=0A>=C2=A0=C2=A0=0D=0A>=C2=A0HID:=C2=A0check=C2=A0for=C2=A0valid=C2=
=A0USB=C2=A0device=C2=A0for=C2=A0many=C2=A0HID=C2=A0drivers=0D=0A>=C2=A0=0D=
=0A>=C2=A0Many=C2=A0HID=C2=A0drivers=C2=A0assume=C2=A0that=C2=A0the=C2=A0HI=
D=C2=A0device=C2=A0assigned=C2=A0to=C2=A0them=C2=A0is=C2=A0a=C2=A0USB=C2=A0=
=0D=0A>=C2=A0device=C2=A0as=C2=A0that=C2=A0was=C2=A0the=C2=A0only=C2=A0way=
=C2=A0HID=C2=A0devices=C2=A0used=C2=A0to=C2=A0be=C2=A0able=C2=A0to=C2=A0be=
=C2=A0=0D=0A>=C2=A0created=C2=A0in=C2=A0Linux.=C2=A0However,=C2=A0with=C2=
=A0the=C2=A0additional=C2=A0ways=C2=A0that=C2=A0HID=C2=A0devices=C2=A0can=
=C2=A0=0D=0A>=C2=A0be=C2=A0created=C2=A0for=C2=A0many=C2=A0different=C2=A0b=
us=C2=A0types,=C2=A0that=C2=A0is=C2=A0no=C2=A0longer=C2=A0true,=C2=A0so=C2=
=A0=0D=0A>=C2=A0properly=C2=A0check=C2=A0that=C2=A0we=C2=A0have=C2=A0a=C2=
=A0USB=C2=A0device=C2=A0associated=C2=A0with=C2=A0the=C2=A0HID=C2=A0device=
=C2=A0=0D=0A>=C2=A0before=C2=A0allowing=C2=A0a=C2=A0driver=C2=A0that=C2=A0m=
akes=C2=A0this=C2=A0assumption=C2=A0to=C2=A0claim=C2=A0it.=0D=0A>=C2=A0=0D=
=0A>=C2=A0=0D=0A>=C2=A0diff=C2=A0--git=C2=A0a/drivers/hid/hid-samsung.c=C2=
=A0b/drivers/hid/hid-samsung.c=0D=0A>=C2=A0index=C2=A02e1c31156eca0..cf5992=
e970940=C2=A0100644=0D=0A>=C2=A0---=C2=A0a/drivers/hid/hid-samsung.c=0D=0A>=
=C2=A0+++=C2=A0b/drivers/hid/hid-samsung.c=0D=0A>=C2=A0=0D=0A>=C2=A0=40=40=
=C2=A0-152,6=C2=A0+152,9=C2=A0=40=40=C2=A0static=C2=A0int=C2=A0samsung_prob=
e(struct=C2=A0hid_device=C2=A0*hdev,=0D=0A>=C2=A0=0D=0A>=C2=A0int=C2=A0ret;=
=0D=0A>=C2=A0=0D=0A>=C2=A0unsigned=C2=A0int=C2=A0cmask=C2=A0=3D=C2=A0HID_CO=
NNECT_DEFAULT;=0D=0A>=C2=A0=0D=0A>=C2=A0=0D=0A>=C2=A0+=C2=A0if=C2=A0(=21hid=
_is_usb(hdev))=0D=0A>=C2=A0=0D=0A>=C2=A0+=C2=A0return=C2=A0-EINVAL;=0D=0A>=
=C2=A0=0D=0A>=C2=A0+=0D=0A>=C2=A0=0D=0A>=C2=A0ret=C2=A0=3D=C2=A0hid_parse(h=
dev);=0D=0A>=C2=A0=0D=0A>=C2=A0if=C2=A0(ret)=C2=A0=7B=0D=0A>=C2=A0=0D=0A>=
=C2=A0hid_err(hdev,=C2=A0=22parse=C2=A0failed=5Cn=22);=0D=0A>=C2=A0=0D=0A>=
=C2=A0=0D=0A>=C2=A0Bluetooth=C2=A0HID=C2=A0devices=C2=A0like=C2=A0Keyboard=
=C2=A0and=C2=A0mice=C2=A0don't=C2=A0work=C2=A0at=C2=A0all=C2=A0because=C2=
=A0=0D=0A>=C2=A0of=C2=A0this=C2=A0commit.=0D=0A=C2=A0=0D=0ACould=C2=A0you=
=C2=A0please=C2=A0elaborate=C2=A0a=C2=A0little=C2=A0bit=C2=A0more=C2=A0--=
=C2=A0which=C2=A0Bluetooth=C2=A0device=C2=A0=0D=0A(VID/PID)=C2=A0are=C2=A0y=
ou=C2=A0referring=C2=A0to=C2=A0please?=C2=A0hid-samsung=C2=A0as-is=C2=A0in=
=C2=A0mainline=C2=A0=0D=0Ashould=C2=A0only=C2=A0match=C2=A0against=C2=A0the=
se=C2=A0two:=0D=0A=C2=A0=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0static=C2=A0const=C2=A0struct=C2=A0hid_device_id=C2=A0samsung_devices=5B=
=5D=C2=A0=3D=C2=A0=7B=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=7B=C2=A0HID_USB_DEVICE(USB=
_VENDOR_ID_SAMSUNG,=C2=A0USB_DEVICE_ID_SAMSUNG_IR_REMOTE)=C2=A0=7D,=0D=0A=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=7B=C2=A0HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG,=C2=A0US=
B_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE)=C2=A0=7D,=0D=0A=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=7B=C2=A0=7D=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=7D;=
=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0MODULE_DEVICE_TABLE(h=
id,=C2=A0samsung_devices);=0D=0A=C2=A0=0D=0Awhich=C2=A0are=C2=A0both=C2=A0U=
SB=C2=A0devices,=C2=A0not=C2=A0Bluetooth.=0D=0A=C2=A0=0D=0A>=C2=A0We=C2=A0S=
amsung=C2=A0applies=C2=A0several=C2=A0patches=C2=A0to=C2=A0Samsung=C2=A0dri=
vers=C2=A0for=C2=A0Android=C2=A0models=C2=A0=0D=0A>=C2=A0based=C2=A0on=C2=
=A0Linux=C2=A0kernel=C2=A0Samsung=C2=A0Driver.=C2=A0For=C2=A0example,=C2=A0=
add=C2=A0Samsung=C2=A0=0D=0A>=C2=A0accessories=C2=A0or=C2=A0define=C2=A0key=
=C2=A0codes=C2=A0for=C2=A0special=C2=A0key=C2=A0processing.=0D=0A>=C2=A0=0D=
=0A>=C2=A0We=C2=A0don't=C2=A0want=C2=A0any=C2=A0changes=C2=A0in=C2=A0Samsun=
g=C2=A0hid=C2=A0driver=C2=A0by=C2=A0others.=0D=0A=C2=A0=0D=0AThat's=C2=A0no=
t=C2=A0how=C2=A0Linux=C2=A0development=C2=A0works=C2=A0though.=0D=0A=C2=A0=
=0D=0A>=C2=A0Soorer=C2=A0or=C2=A0later,=C2=A0I=C2=A0have=C2=A0a=C2=A0plan=
=C2=A0to=C2=A0contribute=C2=A0a=C2=A0modified=C2=A0driver=C2=A0by=C2=A0=0D=
=0A>=C2=A0Samsung=C2=A0that=C2=A0is=C2=A0currently=C2=A0in=C2=A0use=C2=A0on=
=C2=A0Samsung=C2=A0Android.=0D=0A=C2=A0=0D=0AThat=C2=A0would=C2=A0be=C2=A0v=
ery=C2=A0much=C2=A0appreciated,=C2=A0thanks.=0D=0A=C2=A0=0D=0AOnce=C2=A0you=
=C2=A0do=C2=A0so,=C2=A0you=C2=A0can=C2=A0very=C2=A0well=C2=A0become=C2=A0ma=
intainers=C2=A0of=C2=A0hid-samsung=C2=A0driver=C2=A0=0D=0A(which=C2=A0would=
=C2=A0make=C2=A0a=C2=A0lot=C2=A0of=C2=A0sense=C2=A0for=C2=A0someone=C2=A0fr=
om=C2=A0Samsung=C2=A0to=C2=A0actually=C2=A0=0D=0Aparticipate=C2=A0in=C2=A0d=
evelopment=C2=A0of=C2=A0that=C2=A0driver),=C2=A0and=C2=A0have=C2=A0much=C2=
=A0better=C2=A0influence=C2=A0=0D=0Aon=C2=A0what=C2=A0goes=C2=A0in=C2=A0and=
=C2=A0in=C2=A0which=C2=A0form.=0D=0A=C2=A0=0D=0A>=C2=A0Anyway,=C2=A0we=C2=
=A0sincerely=C2=A0hope=C2=A0you=C2=A0will=C2=A0revert=C2=A0this=C2=A0commit=
=C2=A0because=C2=A0Samsung=C2=A0=0D=0A>=C2=A0driver=C2=A0is=C2=A0not=C2=A0j=
ust=C2=A0for=C2=A0USB=C2=A0accessories.=0D=0A=C2=A0=0D=0AI=C2=A0still=C2=A0=
would=C2=A0like=C2=A0to=C2=A0understand=C2=A0this=C2=A0part,=C2=A0because=
=C2=A0as=C2=A0far=C2=A0as=C2=A0I=C2=A0can=C2=A0tell,=C2=A0=0D=0Athe=C2=A0in=
-kernel=C2=A0one=C2=A0is.=0D=0A=C2=A0=0D=0AThanks,=0D=0A=C2=A0=0D=0A--=C2=
=A0=0D=0AJiri=C2=A0Kosina=0D=0ASUSE=C2=A0Labs=0D=0A=C2=A0=0D=0A=C2=A0
