Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D704204AE6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 09:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731158AbgFWHW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 03:22:26 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:16770 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730830AbgFWHWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 03:22:25 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N7KPdn028129;
        Tue, 23 Jun 2020 00:22:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=rOeovo9mFtrqYw99oQnQUqihLeD2ClyJd00RaG9lN40=;
 b=MF/BokT+zoOY//mpdOM0wy5JILmGSl3Ilgl84fx52DyxwJpzIQdqvHZ01EZDCHeLLggi
 XIpGgqsGH5/rs5qz4ICRVqX4yhT16k05mZ8JDNyf8jIfJbMLKTqbtWADhc+lf4ICE7Zw
 kjaqIosfLJrPkXUEks/nVZm26WkhwNFlZvUzhfX8fqsGfI1x7CydrvDAeJ6sFZS1fCht
 W48ait9exmgfuL3HQNrLKKQ9C9m6GH4mo2dybOYMdCnF+O9vz5qBzJnSkig7HKR2nCQh
 Wvwy+DDg4ndNCjd/AtZDu2AKN5FOs7CzsfjyPJX77BdALkJ6x9oSPw4IOuVrTxW4GMDM Ew== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0b-0014ca01.pphosted.com with ESMTP id 31tbucndad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 00:22:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P33iHchu5UXGxmrwu+BpJzCTvkrIjlWP1F9Jv0E1XGpEg9BByhCeXamZjwjZWMn4dGw1O9B4ItKacT5HyXwFiZE3QBJUbawwurNuXb7xz/0GC5X4dCrGuVnQDmEbnD4Hle7NdjwTSPf+uEE/1+0iuJZlXyCLUqKrypiP2bsMYn05hFvBeUuopHt9+P/MwOOd9lvdmL09kaSAsUkA2e3xW9JjraVWemtNmkoH/GYO9Cp/O6JbvH+H6XY9I85/SZkh2lTUG3TlsAKj0A8GtgulAxx2oEF2o6djQdUmrLey8/nlmB7RR/rozY3YoekS+8Gswlr0ln5iTKfuXVemNMjBgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rOeovo9mFtrqYw99oQnQUqihLeD2ClyJd00RaG9lN40=;
 b=NiREMgXCPFUxuwOpkA+ItdY+TFYi43UFX3oa1eF1V70Ojg/zWTFTl+TZvRYC9GiC67A6CtgZ02V7lGWObR/Cw4GFOyyZmlJa8ytrpnCzW5EWk7cO4UEfjJdMsimoUXKJoNPbA8QLQOBy8Ou1SodA67eIzYzZygLv8DksmGdOOhthGxvmKd7OVH1UyMEwHJ0fmDQluN54DDJruiOFBtZ4cE0PSlxsbhJKxOrvkbdItyav6iYYCMlS6a93UXCF42DCXKPamMXmojdgWbVK/vsC6F8H8M++GvMi6PqzFPA2K6mYTtSRj2BOBW2cmC4DlXIOxx0O9zJxeET5YvX42h2n7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rOeovo9mFtrqYw99oQnQUqihLeD2ClyJd00RaG9lN40=;
 b=1yZt/E8rPaI3/6kP/T7Vin7GpjBXywW7q3N5jDijEAYF30SXP6KjiPo3I2+eNkNtKo8qmNjfYZJy3po64NjiBGcSJrOcPt9vBG/syZi1C0wCCtLegn6nMjFQ3BPevTLP6zNuArSNPSVcWV3wpqk3HccIGcbYRoxaAYUDx1KK22s=
Received: from DM6PR07MB5529.namprd07.prod.outlook.com (2603:10b6:5:7a::30) by
 DM6PR07MB5676.namprd07.prod.outlook.com (2603:10b6:5:78::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.24; Tue, 23 Jun 2020 07:22:15 +0000
Received: from DM6PR07MB5529.namprd07.prod.outlook.com
 ([fe80::f447:6767:a746:9699]) by DM6PR07MB5529.namprd07.prod.outlook.com
 ([fe80::f447:6767:a746:9699%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 07:22:15 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@nxp.com>,
        "balbi@kernel.org" <balbi@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "rogerq@ti.com" <rogerq@ti.com>, Jun Li <jun.li@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/3] usb: cdns3: ep0: fix the test mode set incorrectly
Thread-Topic: [PATCH 1/3] usb: cdns3: ep0: fix the test mode set incorrectly
Thread-Index: AQHWSQus3TAr3rsOJEqrbqQsH2/av6jlwJnAgAAFpQCAAAVboA==
Date:   Tue, 23 Jun 2020 07:22:14 +0000
Message-ID: <DM6PR07MB55290EA10573F0BFCA681544DD940@DM6PR07MB5529.namprd07.prod.outlook.com>
References: <20200623030918.8409-1-peter.chen@nxp.com>
 <20200623030918.8409-2-peter.chen@nxp.com>
 <DM6PR07MB55299792641156038575FC4DDD940@DM6PR07MB5529.namprd07.prod.outlook.com>
 <AM7PR04MB7157421522B2ADE6F75A0A518B940@AM7PR04MB7157.eurprd04.prod.outlook.com>
In-Reply-To: <AM7PR04MB7157421522B2ADE6F75A0A518B940@AM7PR04MB7157.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNDEwYzkyZmYtYjUyMi0xMWVhLTg3NjctMWM0ZDcwMWRmYmE0XGFtZS10ZXN0XDQxMGM5MzAxLWI1MjItMTFlYS04NzY3LTFjNGQ3MDFkZmJhNGJvZHkudHh0IiBzej0iMTI1NyIgdD0iMTMyMzczNzA1MzIzMjk5MTU2IiBoPSJQQ3lmVTVZeTZ3VW1DVTdXek1TcHJzTC9VaW89IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=cadence.com;
x-originating-ip: [185.217.253.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09d9a7d7-6f9d-4af0-3918-08d817462786
x-ms-traffictypediagnostic: DM6PR07MB5676:
x-microsoft-antispam-prvs: <DM6PR07MB5676735C242D592CD58F7629DD940@DM6PR07MB5676.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8oVq/fziTvHozY4PpfK1gBNGDTMVbCuh24cc3UXDlNj+qy6O2fWHIDSwpx6Sa6RtqdjhpTt7wuG4cLbiZLG5MdWILjRqfVzyS0qL6aLRtPs5ntn0fVabhvS37A62himFs46kAlPnD+SU6Wsme6SrHyMVuc4VXbAGeWBCfFqcp4Agq+2hylprOOZeiIXZ4nV/ST6f8ccXwvmJKs68akkgjCXb6HneLl9TJvnaTU5ajQ15RkLoQZf3vER0WvRuJMRWtUWq6hpP9yuzxxdBvtY13ZKUjEaDtoQkuxVT4ovRDzSkuPAeD84ZCnRar3tDI6dZps0TonQQ9s6tfsPf/MS07qanhe28FAIk5kWv0azssHOFp1HtMr1F3eqW+NjLlPnq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR07MB5529.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(36092001)(71200400001)(7696005)(55016002)(54906003)(110136005)(33656002)(8936002)(26005)(9686003)(2906002)(86362001)(4326008)(186003)(8676002)(478600001)(52536014)(5660300002)(4744005)(316002)(66446008)(64756008)(66476007)(66556008)(6506007)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WR3A0qhPeafkFTHLbpUdbnIBmyhgNOL/PLbFlqGJS7z3h8EWXaRsCs0tm+WTgZk+sN4I4f160olUfhhYjJdbPlJlHQWaE5h6nrmKQ+czsKIaZfNgNozc3gghNS8X+NFE3M4RamcXXlBIiudIzMQzMOqNBBhiyf4ftX8wdlSWqW1jatpa9GaCrMJ96239+uNkhG6cDNGk4QLDhPjygMdyaWduM8SsqQ4OirkHsGZosvRxSYGU5MxRwl6TrMGOne3lEa/d54qyh9ari7zYIw2yDQBOiDkpqwZVqkTd+H5zcZ3uy4QqCiTAx1SGQhdYakdsunxkB8xHQ+kVaAhqaLtjj/1RuBVcVnXEKOMghvMEIglB/ppqEol5qB3k+FKtMWBTvWRHnsBXzKUF3WV9jdTFlJn/yw5OfTEVjoX92Q6+9hjkdrbUQtQ42ZquoGe/dWOEWUDlIO3L73X+KUBG2GfPe1QrktqmJUpstDdFA2X6kBW2Hrm10iyWgF52l5jVia1l
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09d9a7d7-6f9d-4af0-3918-08d817462786
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 07:22:14.9973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7auSNngo9d1wBGBYsYHE5bHbMePZQLgoEEcEeNgTGFUOoJqkJOg4Hp63Qj2kXKFDURbOcC/RbCj+4apCzhZXPjEAhTqyMMA0o+5Yje3eZ68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB5676
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_04:2020-06-22,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 cotscore=-2147483648 impostorscore=0
 malwarescore=0 mlxlogscore=765 bulkscore=0 priorityscore=1501 spamscore=0
 phishscore=0 suspectscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230057
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>> >diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c index
>> >2465a84e8fee..74a1ff5000ba 100644
>> >--- a/drivers/usb/cdns3/ep0.c
>> >+++ b/drivers/usb/cdns3/ep0.c
>> >@@ -327,7 +327,8 @@ static int cdns3_ep0_feature_handle_device(struct
>> cdns3_device *priv_dev,
>> > 		if (!set || (tmode & 0xff) !=3D 0)
>> > 			return -EINVAL;
>> >
>> >-		switch (tmode >> 8) {
>> >+		tmode >>=3D 8;
>> >+		switch (tmode) {
>>
>> For me it's looks the same, but it's ok.
>>
>
>Pawel, please check the coming code, it uses tmode to set the register whi=
ch
>is incorrect before shift. (line 336)

Rigth, thanks for clarification.

>
>328                 tmode >>=3D 8;
>329                 switch (tmode) {
>330                 case TEST_J:
>331                 case TEST_K:
>332                 case TEST_SE0_NAK:
>333                 case TEST_PACKET:
>334                         cdns3_set_register_bit(&priv_dev->regs->usb_cm=
d,
>335                                                USB_CMD_STMODE |
>336                                                USB_STS_TMODE_SEL(tmode=
 - 1));
>337                         break;
>
>Peter

