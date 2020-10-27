Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEFC29AA76
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 12:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1422069AbgJ0LWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 07:22:11 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:52648 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438671AbgJ0LWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 07:22:09 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09RBKZqN013257;
        Tue, 27 Oct 2020 04:22:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=SXIvu4hDCMYJ9gf9w6OHvPuIM/ntPGAqk57CWhWcpjo=;
 b=hJhWKSyLJq3QO5GcAWGROn4wspP381ufv795OiV4SUlZDx8P3hFX6BSJvZ2f4b1zthOy
 AYIfT4ThOUKOyd4ZjA+w3xST8SxMEsOhj0E8d9Kipdc5lG+sornsb0KQkv/sGbLoRvD0
 LgO8ACQWTbkjh91A1e5IgdzrOYCCl4XvSgqDoQLewk0mOiQI3Mckkwg8P+mDgUdld3gy
 s5/w10m0FAkLW058vbW+SortyAETF4ktSt+Wq2xCLSlDBWEMC+ejvu+8Ou9DGrbqSDhJ
 M8y1NBn+QB7kLXdGlk4zoFY1qOujPkYfiz8qmR3buocQgonRx13j3cj02WtJDdtS/loU Ig== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by mx0b-0014ca01.pphosted.com with ESMTP id 34cfux37k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 04:22:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIoDvljb6EEDbrbzwoLgIzy0ty4vgXIhzQ1Xakh4OI6pUm6gkAV9gqrSNo8hzB/ETvcW+EVN3M55OR9mUO16loA5uiNy1D3fDFp4RhtImD1JT2F4/Wm5+wNrViaVHQw3iodgfyylMJvhJZlBC5sqRPTo4RuMmW4EzGiQbi5NzLSD44EiYYFpA3bg+9pnihv+yqlaFDB5kEAbHT6TMR3FBElx4hmovUsVE2XogbvUsSZhOGFt1KonF6LVnaNVriesONrw3y7pQJScHbwDJA6HR9Phgn1fSxPoVMrMVds99hg0bNxYtFhszVmT/w9IIpAeZ6IEGUB9dNPVxte3+r4wDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXIvu4hDCMYJ9gf9w6OHvPuIM/ntPGAqk57CWhWcpjo=;
 b=TapmBRj0bCglsZZvCt/3RxBkWWr/5hN57WWYB8UGcU8QhVSrT9l23xR+UYfDwTx4qEaNfeCu096pnzz3eYAWMyc50/YYRQ5i66Dz5cYPlZMiziqzE6lINAoVZQI4duhT0oOmnYnMccjT8Eq4y9MipVk0iFRo0f0vTAVXd9loi/2pO5uk7Jp7wW14Twt0D0Zvnuc0TAHMl8nuCzghpaNaMd6b354mqUOCDEiqtMy6KQJx4ol54QvGBxTK/MnqiypAwK0z1qrmjAZcBi2Jc2EDZO4rZah45VQeIBo/YmBpA7SXbit+L+7u/ZmDex92Bp913E1rXqeVkKywyPEew2EpWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXIvu4hDCMYJ9gf9w6OHvPuIM/ntPGAqk57CWhWcpjo=;
 b=bL0TPgRhxKYSmP8D0PBTBAH2Wk7ogcrIFdKTPI9V9JEbrNt1OLE9Ho3vVD1p6yTcceVYSNqMgANWJ07joPFAME5XWvg3P02a6Yf7C996RqapDxgHOXwHhddXKIizVamHcPLufZp4kNwAO2MP65JuTboQG0hXNuZ4ykfSICDK7Bc=
Received: from DM6PR07MB5529.namprd07.prod.outlook.com (2603:10b6:5:7a::30) by
 DM5PR07MB4133.namprd07.prod.outlook.com (2603:10b6:4:b3::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.20; Tue, 27 Oct 2020 11:21:59 +0000
Received: from DM6PR07MB5529.namprd07.prod.outlook.com
 ([fe80::2087:7f2b:5dc6:a960]) by DM6PR07MB5529.namprd07.prod.outlook.com
 ([fe80::2087:7f2b:5dc6:a960%6]) with mapi id 15.20.3477.027; Tue, 27 Oct 2020
 11:21:59 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Felipe Balbi <balbi@kernel.org>, Peter Chen <peter.chen@nxp.com>,
        "rogerq@ti.com" <rogerq@ti.com>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jun.li@nxp.com" <jun.li@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Peter Chen <peter.chen@nxp.com>
Subject: RE: [PATCH v2 3/3] usb: cdns3: Fix on-chip memory overflow issue
Thread-Topic: [PATCH v2 3/3] usb: cdns3: Fix on-chip memory overflow issue
Thread-Index: AQHWqA4bmwECGWeMkUCpX9nCXT6rQamrNsEAgAAdW0A=
Date:   Tue, 27 Oct 2020 11:21:59 +0000
Message-ID: <DM6PR07MB55299C4481210E50CF571584DD160@DM6PR07MB5529.namprd07.prod.outlook.com>
References: <20201022005505.24167-1-peter.chen@nxp.com>
 <20201022005505.24167-4-peter.chen@nxp.com> <878sbsc92j.fsf@kernel.org>
In-Reply-To: <878sbsc92j.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctOWU4ZDU3ZTAtMTg0Ni0xMWViLTg3NmItMWM0ZDcwMWRmYmE0XGFtZS10ZXN0XDllOGQ1N2UxLTE4NDYtMTFlYi04NzZiLTFjNGQ3MDFkZmJhNGJvZHkudHh0IiBzej0iMTQ5MiIgdD0iMTMyNDgyNzEzMTYyMjUxMDUzIiBoPSJNbHBxT1RIblR0d3hNK0RtczdzeWg5N0d0ZUE9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=cadence.com;
x-originating-ip: [185.217.253.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8890b667-3aa0-472d-69b2-08d87a6a852d
x-ms-traffictypediagnostic: DM5PR07MB4133:
x-microsoft-antispam-prvs: <DM5PR07MB4133056A30BF6D9FC33E1949DD160@DM5PR07MB4133.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cl9mEa3jxQBWB7FSxUmnZM8Y3zRgWoiS0uZ0RNVaXtQEjlUFqc48RZTy/+HZbAGU1/2hJ0BTz9EFPK9fXz9WjQxu0nJci0FqkUzEj0cHsms7YT/8yH5cbfG4oM5ucWppeWsBB7yeljE2+Q5K42B/0lphse4vsl8WZF/TVE2QJPcOA9Gb6UpBTvH949IdC4Vy/UBs6i+LAgRpRvMm3h2IV8AjODEtl2xWnGpI7d1IcSqSG/OIdLXVtUWPhCEHl/ogkvGP/W3ceapt6NNTKAaclAd0Y+5gyrT2kejNveIZZJYDvVQbhoXziGyqr51mHHT6/eXE8N0wSHmF16TRoRlMoRBay00MBINRZkHUsXnp+bcIRZRmUgUsxLHatd7jD4Ax
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR07MB5529.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(36092001)(26005)(4326008)(9686003)(6506007)(8676002)(8936002)(83380400001)(71200400001)(54906003)(7696005)(316002)(110136005)(186003)(66556008)(66476007)(66946007)(76116006)(52536014)(478600001)(86362001)(64756008)(2906002)(33656002)(5660300002)(55016002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: TU9+yTOL45RlC93vE1bja+FFDWEQJ+oV8Tc1Ogk0ughpZr+Abh13T1LZPmVB8k5XyN3wQ1KqWZ+EvFO6kfx8UrVkrmbIr1P260LEvgNh6O2lAab6SYKMD5x14RzojEpIzpDGY6zIBOT+9WKTeVu09Uc3p1aA6qeQN00ygF1oKjdvKCLCIVBYsad+iR5LcKxsJ9dwLUXhsq6YkGiGMqb+EGxJxpH6X1JKGk4IzDMOffMs8hiSmJBdzkAqBwduC06VV4D16Cu/B+fa6kKF7vrfXqA+5LvlTZG0Mg2A264AQFmY587dgQ2GhdMEsvilsuAoNzBJFE6VwnL3zQdYnASZoKS69nQuDNyarrZR+2HT1VEIop565qKSwuJtBiKQbQa9K5iXY/OPXUxmt1Mf3oPpwl9o4cZDmFtrK5vuVKEv0h9tugTWc6nYZsULS97libW0MAbJt9A2yZGREtgErMg/ezJrZOmWJbteWz+pypHPABJB5G/jLt39p5YsRtD4xc5wW0dpirWVVWTOcK/wjLPgOowzL/2cJL2qB6nS9n8b0Y6Kg2WSD2PZRk1ZglYG+/ZMZUVtOjSC6olkFbClw5SQeNvW0ZJjmbSTD9JVCktWVJsFCLo/dfl9qJFzv3EJFDwrRngcJLzRUwmZh+mTZQ9nfg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR07MB5529.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8890b667-3aa0-472d-69b2-08d87a6a852d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 11:21:59.1553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kb3A6NHQ6bmsrY4bkVZdbQfb5R0zW98zscvKMpViyAI9Pr/FmeLts1fhQDzWiC98dfTTGWYzEd+JVhVremY6KHZ0w1TU32tIYO/BVqgu6eE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR07MB4133
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-27_05:2020-10-26,2020-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 mlxlogscore=787
 priorityscore=1501 suspectscore=0 spamscore=0 adultscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270075
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

>
>Peter Chen <peter.chen@nxp.com> writes:
>> From: Pawel Laszczak <pawell@cadence.com>
>>
>> Patch fixes issue caused setting On-chip memory overflow bit in usb_sts
>> register. The issue occurred because EP_CFG register was set twice
>> before USB_STS.CFGSTS was set. Every write operation on EP_CFG.BUFFERING
>> causes that controller increases internal counter holding the number
>> of reserved on-chip buffers. First time this register was updated in
>> function cdns3_ep_config before delegating SET_CONFIGURATION request
>> to class driver and again it was updated when class wanted to enable
>> endpoint.  This patch fixes this issue by configuring endpoints
>> enabled by class driver in cdns3_gadget_ep_enable and others just
>> before status stage.
>>
>> Cc: <stable@vger.kernel.org> #v5.8+
>> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
>> Reported-and-tested-by: Peter Chen <peter.chen@nxp.com>
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> Signed-off-by: Peter Chen <peter.chen@nxp.com>
>
>comment from previous thread is still valid. Far too extensive change to
>qualify for stable or -rc. Sure there isn't a minimal patch possible?
>

I think that it's the only way to fix this issue. This fix require to displ=
acement=20
of code fragments and it's the reason why this patch is such extensive.

Regards,
Pawel
=20


