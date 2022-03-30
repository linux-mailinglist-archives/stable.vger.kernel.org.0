Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A3F4EBD8A
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 11:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbiC3JXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 05:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236477AbiC3JXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 05:23:52 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0245E2AE0B
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 02:22:06 -0700 (PDT)
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220330092201epoutp047a4fef88cf6b531454457a1ee6e54088~hHi3wa4W53261432614epoutp04p
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:22:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220330092201epoutp047a4fef88cf6b531454457a1ee6e54088~hHi3wa4W53261432614epoutp04p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648632121;
        bh=uW6f6W9MFPxS2eipKHJ6y3QB7y7EyjqW81nBvPh8Nz4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=srjSQ7/OKYY14jxpLbvyUIcZVk7I/Os5rgvQvDIf8zuKwiF1AKRDCsGuTBv+4vGSk
         O5JdWjzZighNlcG4WVSKDSVZyX7DQCKiYkkYtDlQGGGKHIa+SKA2axxuOqOxoPmjL1
         jyK5v4vKVNbatQgeODWWlzn7a7mZxx9iGFpwS9t8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20220330092200epcas1p3887df7cf62ce08406d500c75fe5808f8~hHi3CyaNc1058210582epcas1p3f;
        Wed, 30 Mar 2022 09:22:00 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.36.227]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KT1Cp4M8fz4x9Pq; Wed, 30 Mar
        2022 09:21:58 +0000 (GMT)
X-AuditID: b6c32a36-1edff70000002055-ee-6244213641d9
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.0E.08277.63124426; Wed, 30 Mar 2022 18:21:58 +0900 (KST)
Mime-Version: 1.0
Subject: RE:(2) (3) (2) (2) Request for reverting the commit for Samsung HID
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
In-Reply-To: <YkQfPEKX0pd+tkz3@kroah.com>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220330092058epcms1p799e10561617c02a14d5d8b413722f678@epcms1p7>
Date:   Wed, 30 Mar 2022 18:20:58 +0900
X-CMS-MailID: 20220330092058epcms1p799e10561617c02a14d5d8b413722f678
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHJsWRmVeSWpSXmKPExsWy7bCmvq6ZokuSwaEVihY/X05jtJhwyt1i
        V8c7VovXx7ezWmz8dYvVYvnNr8wWtxd4WjQvXs9msXXJXFaLW8dbGS02T37EYnHz0zdWi3l/
        17JaTDzYxmqxYOMjRotHKzYxWbzbK+Mg6PG0fyu7x85Zd9k9Nq3qZPPYP3cNu0ffllWMHk2n
        2lk9Pm+SC2CPyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
        dcvMAbpfSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgVqBXnJhbXJqXrpeXWmJl
        aGBgZApUmJCd0Xh6DlvBNK6KxYdb2RsYD3F2MXJySAiYSDy98Iuti5GLQ0hgB6PEhofPgRwO
        Dl4BQYm/O4RBaoQFQiXaZq1gBLGFBBQkru9sYIaIW0psuz+JHcRmEzCX2LphFViriECRxIRX
        aSAjmQX2skncfAVRIyHAKzGj/SkLhC0tsX35VrCZnAKaEk8+7ISqEZW4ufotnP3+2HxGCFtE
        ovXeWWYIW1Diwc/dUHFJiVmTl0DZxRI/PlxhhbBLJBrnX4Waoy8x/clbsF5eAV+JCzv7mEDu
        ZBFQleg/KAVR4iIxd+ZisBJmAW2JZQtfM4OUMAOdtn6XPkSJosTO33MZIUr4JN597WGF+WrH
        vCdMELaKRC8wmYC0SghISVxZHw8R9pBYcfclMySQ37BIdN6fxDiBUWEWIpxnIVk8C2HxAkbm
        VYxiqQXFuempxYYFRvCoTc7P3cQITshaZjsYJ739oHeIkYmD8RCjBAezkgjvx4POSUK8KYmV
        ValF+fFFpTmpxYcYTYE+nsgsJZqcD8wJeSXxhiaWBiZmRiYWxpbGZkrivKumnU4UEkhPLEnN
        Tk0tSC2C6WPi4JRqYApy3BCx/OSBmAydm6KyMxR31M7e9eaCzovFHO8ZHqja3H91drWXtMXa
        iU5z3tl1JyYftVm0YFXj5IrbU5hC4lmb5CKP1JkLz9EOcNmrfD0q3H96/b/G2RvmJJfOKfsZ
        Hd0jZ+qRvVCHzzqQfbaQkFFVufZZ28qyAmmBc/7W97+eP/HyRmvGtPdzrTIUXWQedr2u1xdk
        tV1Vz7Dv5IXYXWwasSwXL8deLjcKahRbLPG1eZe4X8yk01z5t+tWS87W9/09o0vkU4DHp+ta
        VWurpqRN59G+sl9wV05lxrO9ET8rF5z9ZZ+/R1r28adb1kc+WF3R/jFT2L9om8b+pVX8NUcW
        CK5PWXjp0ZNpc56z+CuxFGckGmoxFxUnAgDKZDOIUQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587
References: <YkQfPEKX0pd+tkz3@kroah.com>
        <nycvar.YFH.7.76.2203301047560.24795@cbobk.fhfr.pm>
        <YkQVq1RvWTp1xxJO@kroah.com> <YkQRXqlzVjBLbvp2@kroah.com>
        <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
        <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
        <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
        <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
        <20220330084401epcms1p1fe9efa50452a84f7bbb22a4de82b5a0a@epcms1p1>
        <20220330090150epcms1p42e28758b515942ecdee680cdef3ef0b9@epcms1p4>
        <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p7>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


No. If so, I will not apply in house patches.
I'm a Bluetooth person, and I'm only interested in Bluetooth devices.
Codes for Bluetooth devices will never be worked along the commit, anyway, =
no reason to include them.

Thanks.

--------- Original Message ---------
Sender : gregkh=40linuxfoundation.org=C2=A0<gregkh=40linuxfoundation.org>=
=0D=0ADate=20:=202022-03-30=2018:13=20(GMT+9)=0D=0ATitle=20:=20Re:=20(3)=20=
(2)=20(2)=20Request=20for=20reverting=20the=20commit=20for=20Samsung=20HID=
=20driver=0D=0A=C2=A0=0D=0AOn=C2=A0Wed,=C2=A0Mar=C2=A030,=C2=A02022=C2=A0at=
=C2=A006:01:50PM=C2=A0+0900,=C2=A0=EC=A1=B0=EC=A4=80=EC=99=84=C2=A0wrote:=
=0D=0A>=C2=A0=C2=A0=0D=0A>=C2=A0Thank=C2=A0you=C2=A0for=C2=A0good=C2=A0advi=
ce.=0D=0A>=C2=A0=0D=0A>=C2=A0I'll=C2=A0check=C2=A0security=C2=A0problem=C2=
=A0when=C2=A0I=C2=A0add=C2=A0in-house=C2=A0patch.=0D=0A>=C2=A0I=C2=A0have=
=C2=A0no=C2=A0idea=C2=A0about=C2=A0how=C2=A0the=C2=A0commit=C2=A0improves=
=C2=A0security=C2=A0level.=0D=0A=C2=A0=0D=0AThen=C2=A0please=C2=A0do=C2=A0n=
ot=C2=A0remove=C2=A0it.=0D=0A=C2=A0=0D=0A>=C2=A0Was=C2=A0there=C2=A0any=C2=
=A0security=C2=A0problem?=0D=0A=C2=A0=0D=0AYes=C2=A0there=C2=A0was,=C2=A0it=
=C2=A0is=C2=A0now=C2=A0fixed.=0D=0A=C2=A0=0D=0Athanks,=0D=0A=C2=A0=0D=0Agre=
g=C2=A0k-h=0D=0A=C2=A0
