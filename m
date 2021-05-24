Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C078C38E4A7
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 12:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhEXK54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 06:57:56 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:2944 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232575AbhEXK54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 06:57:56 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14OAgo4O025578;
        Mon, 24 May 2021 03:56:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=pD85VqRPal6cL858hwZ5DFyWnt3TV6VIYXgrgDivsB0=;
 b=QhyoI9EZrHsYdIHDKl14tovu9HclQqag+b/V97g7AugMIiYUO03PULI5Ss5dIGY3nH4H
 IhOIgTuqVYJ00JRqjHOqO/yYZ1TASndoUy8pe0IjDElhshOFjeFWLMK0NPXeWtKG8P9p
 pH1WF18ZApNqcRMhR2axysvu8aJ6ErQVAM/tJ8k1DP5HiGyyVnqHSKIsnc1sV/Hr4MZg
 DUNAhf1Tzc8d9ns7cbdgCTzRQNvlRbmMmVVvFYa3dJ05ArOKeOtH2IR4MwOt2hQ7HZkS
 +uRDiWvNJdUyZo+4LPEUFZqJZ+IcjT4OwDQ1dj8OPdYsDyJjGWtwRAoUo+baP/vySd0g Gw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0b-0014ca01.pphosted.com with ESMTP id 38qp34ammc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 May 2021 03:56:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPnM8lPga/6B1uJfvbmWS/t6rm1lc2qxUjXWNXPEu6E3RjAsh4ilw2gwx1aUvfmrFdg+yea7StPoxF3JpkiSOyGp4ZwGv3OnEszAkRF4s47GmOeq5/2wqpODUm2mkd//0+aibrfpv91za0+vYZGOzidh31YQutodrhICTWN0e7smvBW5qoJNpyp/RKCTm7ytcl/CU6R2yhBDcD/qeIxL44/x4cKcIjmOa10rM2dMNLJ7V/ocp9VCReGT7tBXscHpDoM7cXIhu4onmAO5icz7bhPuO70YSDtMIOkx2VnKYCvQFSs804nqskjMG2kRj2geO6/e0Zoi0yIwGT+M04aIjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pD85VqRPal6cL858hwZ5DFyWnt3TV6VIYXgrgDivsB0=;
 b=YxUMUx310QUDMzRcqYklK+LLFJJ7tB5OtWTLX8pAuX6hF6SG6HeCfT3wKeZ+zvDcrWop4DQN5nR/BF8XCx1IQ9SzGlXcsYZZNVHkJV4j8BhIDw48fJeEbWm8D4skB0/s5rQGq09hHRgp6j1z3QGRLwHExJ3xn1gEXezMnhtGch1Tmb3d16aX64SE1A7ZbzfahHpIJchkmaFFGUX91RLf9P0fk2DB4Ny3NzrmNUFRoKS/tLEzWyiEFaoAc1I8rT8ro2NE/A8hT52x6Aqm9cDgDHMLsbzNLRHXt/e7TbuEOIo0I6kNInMy3Sqm+aCn1cpHLpF+XPPgJBayDq+PRNNnMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pD85VqRPal6cL858hwZ5DFyWnt3TV6VIYXgrgDivsB0=;
 b=vCpIYGXYeRkLsfudiqxtzL9JU1O7deBMpqSXmicwDVFGZm4pmyMvu0MJGrgbXeZnbvvpkUIfIjcqSBrAvwsGAAIvUwRZhoU2c1QzzQ44E/7VL2dbeh2SpdjvpHUgPlcPfiJbMYQwrLvLdWOffBQKF9PIYUE7VEWA9g5/r4Da4yI=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by BYAPR07MB5862.namprd07.prod.outlook.com (2603:10b6:a03:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Mon, 24 May
 2021 10:56:24 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::21a3:4648:fcda:e438]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::21a3:4648:fcda:e438%4]) with mapi id 15.20.4129.035; Mon, 24 May 2021
 10:56:23 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Rahul Kumar <kurahul@cadence.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdnsp: Fix deadlock issue in
 cdnsp_thread_irq_handler
Thread-Topic: [PATCH] usb: cdnsp: Fix deadlock issue in
 cdnsp_thread_irq_handler
Thread-Index: AQHXTVyBsA1aWGmABkei+mvVQ77+5KrvRjQAgAMyZSA=
Date:   Mon, 24 May 2021 10:56:23 +0000
Message-ID: <BYAPR07MB5381074F9A2A8AD6CAF4C10BDD269@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20210520094224.14099-1-pawell@gli-login.cadence.com>
 <20210522095432.GA12415@b29397-desktop>
In-Reply-To: <20210522095432.GA12415@b29397-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctYTlmZTkwODAtYmM3ZS0xMWViLTg3OGMtMWM0ZDcwMWRmYmE0XGFtZS10ZXN0XGE5ZmU5MDgxLWJjN2UtMTFlYi04NzhjLTFjNGQ3MDFkZmJhNGJvZHkudHh0IiBzej0iMjY0NiIgdD0iMTMyNjYzMjczNzc5ODUyMTkwIiBoPSJvRHlNb2Z6aklWbVE0S0JGYjg3dWhQcGxRNEU9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=cadence.com;
x-originating-ip: [185.217.253.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53c89990-3aa8-4fe9-f316-08d91ea2924a
x-ms-traffictypediagnostic: BYAPR07MB5862:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR07MB5862488383E415241F4474C8DD269@BYAPR07MB5862.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p8Cysy3W/Juu5k0Unv+753oOTYL1FCbAf8BdYan0KXCJazXuW/reQ32C6qJhYd+bkPqRyGKvePCHRQphWPVJqWbD5GRGm1beRYZ+F1KsNOBGK7W+vY4RyFcCi2qs03utCAVefvFtSq6TAtvIWaES3ToygKFdDPc7goVfk1MxIcW+cTwXnyCb/QcX4/DOQLKsP5gYUPNgeV0zlMkfZldRc6PtzzSLEnI5dphRj2AwRyO1E5Ptb4mM1MOWFcE/dhcWvwACBSEJakk6y0CniFm2TJbcF0FfzypDeFbR3+j94xOGE5erwTpnEfyzUDd/13WjODRiodyLE1SMkt9MwO1aNhQNMKLKRNb4k+owngDOoN/y5K8d9VsArJIpw3dY7XXMWxkMNMhVErzY4C45hzqT5OoATqYTAweoJB5pBhrJJEK+dfD6HJsZmM9VoN+a6IuoEcbJ0Y2DeX1joP9F+5Ei4RH1SDbak+B7KdLGNaM3wEOWE18Hy2nFNCLrRMQGkIN6ErdrKJjiu3jo8Dia4Z6cpIbgO9Bj/uG6Ok7T0kw5dbPxPdj/PtiO/LLIRG6xnYv6rJQsmMQUoO7lEFgB+hOfH27tYGAiSrzoElXAuQHPTyaHDMtzPS/6/6glmXKnkhltH7VBPXqZc+zSYvHArz/fsyy4GWd+rpj6JzG9bc2NJ4c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(36092001)(8936002)(5660300002)(9686003)(478600001)(38100700002)(26005)(54906003)(8676002)(186003)(83380400001)(7696005)(52536014)(33656002)(66446008)(55016002)(66556008)(6506007)(316002)(6916009)(66946007)(122000001)(71200400001)(2906002)(4326008)(76116006)(66476007)(64756008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9cCPf2fxGlDpAwa0cJil6nVRrEREm0dwDk8+wr0Yj4toM1xkdc9NHSah+IMg?=
 =?us-ascii?Q?J4e9QGq+PDQvE7l55DMzlDJb9LZOZUHCYSvUFO1Mg1+H/7ecrwlJ+dpVIkMM?=
 =?us-ascii?Q?fJ0606+qh/gnIBjpArz+ux0r2DMYpWEdT83a4A+waoHGTpMHHvuBWtJiRvnF?=
 =?us-ascii?Q?At6uRaYA941bwxF3DeIVA+Wow0yVZ7ON78Rb/82ufhYwdISzxgwyKlr7gKJk?=
 =?us-ascii?Q?DoeIIXRbT6jY4fAv603rv8YfrAQcrXl3vEj+DsWIc2y4wLV4vSsUeJlw+NRa?=
 =?us-ascii?Q?IX+xRfS+D0bKFr15ifJNtb7AjWIC6+4L/OO8iDKUtNh4XmAtXh5B7Qge8U3f?=
 =?us-ascii?Q?jtUcGqIkAPaRovizbf0ZuphV/WYUUgNTHrZ3R3G+CZg1uBeKECJnbKRqLpw1?=
 =?us-ascii?Q?ve4LwRDZAYdNveVhFpZ3pREwnPK7s7919CXnQ6CkXEAcVqfeLgwAW1w80CcS?=
 =?us-ascii?Q?+enSzUr8pYbvsPdVSkZaP4ynIZAtJx17S+jXyHBDMyPHimqSLhMoRKq1dlYX?=
 =?us-ascii?Q?8o78pAT6TsE7xKhC4VElQqIPqt1ZjzxFMyjchANjx82l9kU9nboBaqjleGvE?=
 =?us-ascii?Q?EZOcD19yb+o3U8HYVFDPgUh6E2Th8ZxrV+UGwI3vNHO6vhelL9Mzmj5L6fKz?=
 =?us-ascii?Q?UueXfTHOklrXpqNCUYc/E5MP4PviAQU5PD/iDYNyMXhcODFNKuf7xv3Pwc1q?=
 =?us-ascii?Q?UCCw6HC4/2JDv242tdgfN46i6gBnTy7dJYx19NTVstD3MuN5nEWQWNTBQKTE?=
 =?us-ascii?Q?kKShk8Yy/c6WgtAIXFrKB0YgiUIKur/mh51geVsdiBGg4ZmwvI3bdhBMfb6+?=
 =?us-ascii?Q?oMeY0glTqiGHIpS94yalcm9N92R8UfRJvJBt7WRJAy/gF5Y3EWOY0qMt9+IX?=
 =?us-ascii?Q?QUK37a03cAyVC3zrNI4fk9/JfjjbsnWZgeiDlWy+tTXuwd74MT4IWAgRyUji?=
 =?us-ascii?Q?ZESN3Joc3Ff9FSe82/KudXItRSISBYXeJzxEDQTEpHzKR37joLjcBSrG1SiO?=
 =?us-ascii?Q?4o1CnBEwJ1GjQkN7sU5ITlOB8gXp6xfvBCRbIMCuayGFkzMm6iUcCStOQEE2?=
 =?us-ascii?Q?gmqec20t252qCX12/NSzb5hMl4nHB/rNq+QIdrEj5Y9sN5pqsRy4JQTfAMYj?=
 =?us-ascii?Q?6Gu1h3//4NIApCRsDQ4lHDcq8KO7eYy/FrLZkq6HWZ3MEwr3RPFNrxLEDuoP?=
 =?us-ascii?Q?Ee7U/C32xf+DtVEEnSW2BsPEWr7SL9p443h8F4Rex1EV3HJibftbTYcqU2LU?=
 =?us-ascii?Q?1689mTwpwvz1M2wa4GjgF5LXk0dorOP50ti17jTWEZjPge1ajFT+JshU7jza?=
 =?us-ascii?Q?ptFa48QUgf/z4guxhYdLhBuI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c89990-3aa8-4fe9-f316-08d91ea2924a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2021 10:56:23.6816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k9ud8WDZ6VSSrWDUZ82l5MyLRIk3hkZILZ+bctqEf/E9GfaTQvvqnpSF/LuOcqwzNjalvG9TSk/L7doSv7FKVOLg+Dlt5zX6wkwHPvYqg58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB5862
X-Proofpoint-ORIG-GUID: ijgMY5L_rB6cgPXAb73i5R3Vtrj_QU_-
X-Proofpoint-GUID: ijgMY5L_rB6cgPXAb73i5R3Vtrj_QU_-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-24_06:2021-05-24,2021-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105240076
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>
>On 21-05-20 11:42:24, Pawel Laszczak wrote:
>> From: Pawel Laszczak <pawell@cadence.com>
>>
>> Patch fixes the critical issue caused by deadlock which has been detecte=
d
>> during testing NCM class.
>>
>> The root cause of issue is spin_lock/spin_unlock instruction instead
>> spin_lock_irqsave/spin_lock_irqrestore in cdnsp_thread_irq_handler
>> function.
>
>Pawel, would you please explain more about why the deadlock occurs with
>current code, and why this patch could fix it?
>

I'm going to add such description to commit message:

Lack of spin_lock_irqsave causes that during handling threaded
interrupt inside spin_lock/spin_unlock section the ethernet
subsystem invokes eth_start_xmit function from interrupt context
which in turn starts queueing free requests in cdnsp driver.=20
Consequently, the deadlock occurs inside cdnsp_gadget_ep_queue
on spin_lock_irqsave instruction. Replacing spin_lock/spin_unlock
with spin_lock_irqsave/spin_lock_irqrestor causes disableing
interrupts and blocks queuing requests by ethernet subsystem until
cdnsp_thread_irq_handler ends..

I hope this description is sufficient.=20

Thanks,
Pawel

>>
>> Cc: stable@vger.kernel.org
>> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP =
DRD Driver")
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> ---
>>  drivers/usb/cdns3/cdnsp-ring.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ri=
ng.c
>> index 5f0513c96c04..68972746e363 100644
>> --- a/drivers/usb/cdns3/cdnsp-ring.c
>> +++ b/drivers/usb/cdns3/cdnsp-ring.c
>> @@ -1517,13 +1517,14 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, vo=
id *data)
>>  {
>>  	struct cdnsp_device *pdev =3D (struct cdnsp_device *)data;
>>  	union cdnsp_trb *event_ring_deq;
>> +	unsigned long flags;
>>  	int counter =3D 0;
>>
>> -	spin_lock(&pdev->lock);
>> +	spin_lock_irqsave(&pdev->lock, flags);
>>
>>  	if (pdev->cdnsp_state & (CDNSP_STATE_HALTED | CDNSP_STATE_DYING)) {
>>  		cdnsp_died(pdev);
>> -		spin_unlock(&pdev->lock);
>> +		spin_unlock_irqrestore(&pdev->lock, flags);
>>  		return IRQ_HANDLED;
>>  	}
>>
>> @@ -1539,7 +1540,7 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, void=
 *data)
>>
>>  	cdnsp_update_erst_dequeue(pdev, event_ring_deq, 1);
>>
>> -	spin_unlock(&pdev->lock);
>> +	spin_unlock_irqrestore(&pdev->lock, flags);
>>
>>  	return IRQ_HANDLED;
>>  }
>> --
>> 2.25.1
>>
>
>--
>
>Thanks,
>Peter Chen

