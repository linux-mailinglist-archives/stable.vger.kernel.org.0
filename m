Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D85472F14
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbhLMOYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:24:15 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:56090 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233599AbhLMOYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:24:14 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BDAhNFV009622;
        Mon, 13 Dec 2021 06:24:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=Es8s6teYKthGptCqxQhYSHrZN5P35hHmACPKccRYqPI=;
 b=MigAeitYMirNm14GQGX/fM40oIXhlv3reL9dsWGRdtcl/5sEfbyHFIFB40t7+oVarenn
 7B8cpgjBNfJI9sGAaTRe5Qwe53JnU9JPMM61MsVPna3Vt9FLSShcWDfccmUwLGN+CXPc
 zvzDpPCpXVTp5yciN3yGJhslqnsDFk14OTWki1kqVzU0AS5dXZcOOCJ2z4mddsa7ZuRp
 K9ATiw4FV9WalrEHReD7mOMUxiUwHq03A5Fw/kuJlu97zpRjhqFU7ZCuseYk0x8u/C6l
 HgWKW0u0fq7uxzaHV5d3XjVaxSHghwFquS0NRtjphuxxZOoFzxshQWxy7KvC8aECRJLd ZA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3cwc9rvah0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 06:24:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzdjdfaFY37LBAPvVED/WO6XPRuimgjTA4tgh8DqYL/jXBL8/H8JOla55YJ8JlxHQfLYrOakmMqYdoL32cYJK3hDLPcOC5FY+EbXjdax3Yx0wnN3dl6zyYN40MJeZPpyDiRoLMPAliJMtYBSGwuHoy7K5dCjHhSELR6JSmu0TbJG7eH/X5uooEVXvqCfoGZ57Ua3Gwkff/b4ggwZhNaEb+mRYAS0NiUvgqjHWhEwA/cCXcuPPPYB331AgQKymL0nAbgJ27ozvXeCY2knQcFiBB+GJWUmT4JtJYthvmfMGEJymcuOK4+my6hlQNzrKtMY4c7iaCP3qN6iBBbipmu0GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Es8s6teYKthGptCqxQhYSHrZN5P35hHmACPKccRYqPI=;
 b=i6ubQc3yt8TOiwrcCZYIa32RCG29Ov/R8lmKDDkLg6ZGo/LvXvZdNujqFZHUHnsLwvHB0T+qHQ7I0XORqSFqo1Uqa6q/nx+jCcOMEdQ2WVNkokZWFrsUblE5JTU0v1eDVLWer1dE6+A9G9fmRlp43x9NUUBXRB2xLzLYPdThy6HZZevXXww7mSqUY54OeARUF3Rt7ThbTEZSZ2DEdDEJHADW6Cpaq/wv3zEPOAuPYU2HMiIMP48S8UzHW1TdHAvdVzow/4uI8yOqGo5ubBEHXS+yId5Iy6X9CxKcSePCLXZL/63VSoSfT7TjcaV9nw96dy2E8TbQTWmHMCq68RuBRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Es8s6teYKthGptCqxQhYSHrZN5P35hHmACPKccRYqPI=;
 b=nwIC/1vsYc4F/IxUXYJrj3CgD+u0NE1YwIrkgsZO+t7qUqgEDePGazUFZyauMw0qawjE56gPwRrcBrd5oeiDSUAeXZlkN7daOl9CM+4eqUnwpwfdQ0wH+L1OJH/Q3cU5Ghz+VKbXpJZEQ3TAQ4ypOtNvBvERCF0pQDf5v9lvJtw=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by BYAPR07MB5127.namprd07.prod.outlook.com (2603:10b6:a03:6f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Mon, 13 Dec
 2021 14:24:03 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::241f:218b:e5aa:9024]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::241f:218b:e5aa:9024%7]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 14:24:02 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jianhe@ambarella.com" <jianhe@ambarella.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdnsp: Fix lack of
 spin_lock_irqsave/spin_lock_restore
Thread-Topic: [PATCH] usb: cdnsp: Fix lack of
 spin_lock_irqsave/spin_lock_restore
Thread-Index: AQHX8BvTZRkkqcJmf0Wg5yGRfvbOhqwwasUAgAAA2GA=
Date:   Mon, 13 Dec 2021 14:24:02 +0000
Message-ID: <BYAPR07MB53811E2C7CB05B9DEACF7A8CDD749@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20211213122001.47370-1-pawell@gli-login.cadence.com>
 <20211213132946.GD5346@Peter>
In-Reply-To: <20211213132946.GD5346@Peter>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNTEwM2IzMGYtNWMyMC0xMWVjLTg3YTYtYTQ0Y2M4MWIwYzU1XGFtZS10ZXN0XDUxMDNiMzEwLTVjMjAtMTFlYy04N2E2LWE0NGNjODFiMGM1NWJvZHkudHh0IiBzej0iMjMyMyIgdD0iMTMyODM4NzkwNDIwMDc0Nzc4IiBoPSJoWUhLcDMwMGJKcFJmc0ZtaDROTFFXbEdNRTg9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 928101ba-107d-44b7-b010-08d9be443667
x-ms-traffictypediagnostic: BYAPR07MB5127:EE_
x-microsoft-antispam-prvs: <BYAPR07MB5127F30B35891200AA481814DD749@BYAPR07MB5127.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VcvlqX/U1q1yohsOkT9nH62Q8zAMH43GzAlQm9fSqk88SwamWYtW5cR4dmh0pbbvNhztSQVC4UCMphhjI9l/3rgD7Z4Zw++e3Of5p/aegfk8DKU9/ocpEHGckUXVr9F7xDnPAyg0iTe5Gz9J/Ghox4uVjAdReL4l1IPBg9KKIfhK8t+EzvNPqcBdJ45ln48dYA6fD2SNiExBUOlgJOppHKJnkFdBrmBzGmoRh//aGksg6t+aMkusaXTpv0LnNTaz5g2aWMPfNiSoIMOr+Y0mAkZYsFetQPugA4MUawryAUBpkga5PJ7uli/AWVxXxaNf5WnErx9s7BwtT5vXXafQnYy/wVoKcn3pu1MC65kXeizwxZDfr4+MD8oClmjUgo1jJSajel59j+aNfSj3axJRqvM/YSCCW6aC+GZXa82qcI0RUwy2Y1f9jeKsIVSSUYk8RjZ5u/bkti60V/uYd8llWV7N12KjuovG9VdxNuPZLr5J2rLyr96jfC0IgKQsRXoO23VRUdCYwyfhzkpo3mkbT0lob7jlkT/iGVf8QIKHD2ZQbu3gGD2UM4yfpHklu8N2GC7KKMNOC4lNcVZeYju3tZ6QnV/Ys+NrWGnxcRXqPOZHBZ0f/s9wFrio+FfOhATD7XwuqZMvLC3deHD0Dq1qtS5TJqe1yJq5FcGXQMFlkQyQfkF3fmVrbD6198z1iGyeVUlMmjjWgXrYo1GQw6vFMisx14Kb1uBulEzWgRQyAWjq3ZA3Y9YSMsRxkZxhVeSu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36092001)(8936002)(508600001)(38070700005)(2906002)(4326008)(26005)(7696005)(55016003)(38100700002)(66476007)(122000001)(52536014)(186003)(83380400001)(54906003)(64756008)(66556008)(86362001)(9686003)(66446008)(66946007)(8676002)(33656002)(5660300002)(6506007)(316002)(76116006)(6916009)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mfq7SmoebjJhhtw/JAoDFVBBvGCf+HEfIAcwHoDFX4bh5n0pRjhGthBmFRTM?=
 =?us-ascii?Q?f2fk/adnn12WP6N3svEAoBAHv5oKt4bvBr3E50faZ6G1LxorJ86YuaqMjPsm?=
 =?us-ascii?Q?kr1mmLieLfW7i3jcvQJ4HBlvpxhwrYiyxfbZE7GZWH/+LrGas42fp6dIfYR+?=
 =?us-ascii?Q?h3KJfP1k4keRRP7GosVmpCNjkn3ea0N+TYeNSZSLaa4GyggEUaPp2rKF7zDN?=
 =?us-ascii?Q?lyiqcD1SzeJH09/oTk/Z38+2/O1iSazkTFH5+BrORd11oaL2K63rXK7OF5Cd?=
 =?us-ascii?Q?b/6gbtWer+jKUTiQqENIsWZTD20Mi1W+yvznVn1jHVf5xjGkUcVzMCM/k5qt?=
 =?us-ascii?Q?3FEicDC2EW1NrbjSt1TZ/ClP3TsIzLkXxlYnSRTgKQkyDhtUKTlhkS14mHBN?=
 =?us-ascii?Q?u+wvov5jbiy8NfJY1yGZ6ZafbEdhoVGMdxO+Dkb4EEhzULePAy6593HsatyG?=
 =?us-ascii?Q?nZMIUNLj7xRcTUnhE17OSHpBHmvo6DZBT3OUli0QZKh/QNMY2tlY3Or1K9EV?=
 =?us-ascii?Q?adLDRpUs5OiEES/vXa7DuJP1c2cn0pbvyZK8diTeXGss33BEsb4A+dungFf2?=
 =?us-ascii?Q?89QF6KYEqdbQ58X0dFQSB8UN9jFn0YoTSDkhdeLWjrgKJdPwC8yjdlp/JBYK?=
 =?us-ascii?Q?p5voM0ZBnVQLVJgMOY5C2G9dFBmQI1mIhBjgcuhg74GzBhJP+V3+pDYJ1PJp?=
 =?us-ascii?Q?Jcq6jmhG0+nRNC9Cgp69BCkWT+6e3m1GF9VrNLKjojT3atxUafcit46OoDVM?=
 =?us-ascii?Q?teUWiMKEpkzOjpsFHR5pZOsX4tM6E9sMRbTfbyOPUSFh1yXLBwOdkfdnmiq3?=
 =?us-ascii?Q?IQm2ZGcdGJz1E/wYDS97pkUcsO0EL0nw48Oij64oaqNzxehkovdatICWju27?=
 =?us-ascii?Q?MGJJZ6AI0k+UZ4PrxNrpCgOMQ03rWZat/E9ljSEoS+JejI0hGp9DVkeIIFb5?=
 =?us-ascii?Q?VtCDghf9vnZX/RLGaGbriaI20Y45hMCDVVfSA2EkCU3DuRRip8hKCdFDpzEV?=
 =?us-ascii?Q?ty8V0egdNpgx1P2RD6y1AVqG2H3LG41ov6Lau6vOB/YbBjriNinCQ3Vsfldq?=
 =?us-ascii?Q?kYTf7tBr9iqmYHfxV9GB7Ta4zCZSN68ga/g1qjZowI9qZqlTNv46MxZms3jk?=
 =?us-ascii?Q?opiQtbNaemsCaGLFnqxQ5m92naplKH+9QWdhjhkdLGIi8UPt8+Y9ZCWk6Jj1?=
 =?us-ascii?Q?pyTVjBBqggxi4VvB3nSW7GfGawRq5HMMC7ZJkCrniNWENXLLXAHkQW0mQXC9?=
 =?us-ascii?Q?fPMuhWe1OqzETtYf8iwB7EFgPIyH3SwXFmcnoXFcYUElCeF56Bj8Gm+PgcMc?=
 =?us-ascii?Q?FgmXhwDBDmi81W4eAnDdlmQ8kfWbC9kxxzdqyvPip+Gu3bDOL8eadKZ4jVpE?=
 =?us-ascii?Q?1dG8NJXN1IVuY/JXqgda8v0y6aefRMUQLZFGz000KA4vlQOM19ETBenMTEy4?=
 =?us-ascii?Q?jukTSFvurAlc0QSox45dNUSfEYEt8AZQgrEl6+uW/MNBLidMvyWKj37aY+po?=
 =?us-ascii?Q?9WJCh+S6qkRU8rj6sPH7dBKS/cQPJBCcPSct/J2sRTZXXoPYVwVcJwN/Hhrm?=
 =?us-ascii?Q?LjIxuF+0mp1J5+NMtuuJC0FJS+HfC8Z1PK9yRc8x9zHYmi4y6PQfDifKPvRh?=
 =?us-ascii?Q?HKxDZwtt0OyeZdsr4LjnsefDLNrbvWmYsN4hq7mOeD0x7/qiWbN1U1Z3OmwA?=
 =?us-ascii?Q?D6exIQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 928101ba-107d-44b7-b010-08d9be443667
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 14:24:02.7715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kUpRxiTm2Y/7p1GAP1rnl5BrWLc0AFCeRq/Kxa3EjY6OsNN2lfeMxEjxwu5tm1x8oiY8f7BaDPdURYfftwuvVI/Yhfkji7p65UBA+VWZ+3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB5127
X-Proofpoint-ORIG-GUID: fzK3qUofMedcIoITTVkhoPJjKn2HgdV-
X-Proofpoint-GUID: fzK3qUofMedcIoITTVkhoPJjKn2HgdV-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_06,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 spamscore=0
 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=919 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112130092
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>On 21-12-13 13:20:01, Pawel Laszczak wrote:
>> From: Pawel Laszczak <pawell@cadence.com>
>>
>> Patch puts content of cdnsp_gadget_pullup function inside
>> spin_lock_irqsave and spin_lock_restore section.
>> This construction is required here to keep the data consistency,
>> otherwise some data can be changed e.g. from interrupt context.
>>
>> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP =
DRD Driver")
>> Reported-by: Ken (Jian) He <jianhe@ambarella.com>
>> cc: <stable@vger.kernel.org>
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> ---
>>  drivers/usb/cdns3/cdnsp-gadget.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-=
gadget.c
>> index f6d231760a6a..d0c040556984 100644
>> --- a/drivers/usb/cdns3/cdnsp-gadget.c
>> +++ b/drivers/usb/cdns3/cdnsp-gadget.c
>> @@ -1544,8 +1544,10 @@ static int cdnsp_gadget_pullup(struct usb_gadget =
*gadget, int is_on)
>>  {
>>  	struct cdnsp_device *pdev =3D gadget_to_cdnsp(gadget);
>>  	struct cdns *cdns =3D dev_get_drvdata(pdev->dev);
>> +	unsigned long flags;
>>
>>  	trace_cdnsp_pullup(is_on);
>> +	spin_lock_irqsave(&pdev->lock, flags);
>
>If the interrupt bottom half is pending, the consistent issue may still
>exist, you may let the bottom half has finished first, eg: calling
>disable_irq before spin_lock_irqsave.
>
>Peter
>>

But bottom half procedure is also protected by spin lock, so it will be wai=
ting for completion
cdnsp_gadget_pullup and vice versa.

I think you means the case when driver in bottom half function release the =
spin lock before calling some API function.
and in this moment the pullup function starts to be handled.=20
I didn't detect such issue, but theoretically it is possible.

Let me test option with disable_irq before spin_lock_irqsave.

>>  	if (!is_on) {
>>  		cdnsp_reset_device(pdev);
>> @@ -1553,6 +1555,9 @@ static int cdnsp_gadget_pullup(struct usb_gadget *=
gadget, int is_on)
>>  	} else {
>>  		cdns_set_vbus(cdns);
>>  	}
>> +
>> +	spin_unlock_irqrestore(&pdev->lock, flags);
>> +
>>  	return 0;
>>  }
>>
>> --
>> 2.25.1
>>
>

--

Thanks,
Pawel Laszczak

