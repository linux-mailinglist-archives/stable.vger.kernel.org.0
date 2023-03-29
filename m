Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33296CD53F
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 10:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjC2IxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 04:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbjC2IxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 04:53:02 -0400
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8E51724;
        Wed, 29 Mar 2023 01:52:56 -0700 (PDT)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32T3V4uQ011399;
        Wed, 29 Mar 2023 01:52:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=nR5fATHlRD+6dztjh2l+tvXeJ1xoa++KLExKPXftEps=;
 b=sWa9Ymf8E5l+ECp45NIMstNZu1ZTaVu5fPJFn4EKfeuR7p6vD9lbrz9l1Rl349/p6D4z
 rwyr4k0Al3i6gB6s6uzPLUxpkFCuQF4mp91HFn0h1/F6rQoPsWuGiJv/HE6qzJZKcG/1
 SvNvrKbDvsVcS6NTVnUglBNCRVs+y2swdMNj+uPzPZLZ+TMh+A8zFFNYsKxE/Qn9DHOi
 5yczvis+Lq8ntgeC0GUp0SL+UfWIF+r9CgNzKXivjfJrpGIQXnEJUpdDIAwE1Uf2Vwz+
 Px28MFdlL053wzv6uWF92L1DxaqUbFAcOr6XyzTKoWJ2cVGIM1opqGx9KU7UAhYXIUXQ 9Q== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3pkxhtdye4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 01:52:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfgi469jf2HGEOYVbk0Tp3uwjVHq7vg5HNeIZXf+sik8KD6eyH0aAogExOtmjTnfXg5NhSkbFzOcWneYubQtGW9XK2Og974OjHF682Za8J8d8oC/rswpcuoJbdhd062MazFcRhOCKrIANrX4i4V9w9L0HXiWIOXzBGe1sJqvKYYTsyFYYrDvbJMYv/9VsGnxnBuF9u5FqNGIwF+cpmET8egwvNoYxQ6wh+uvNnbHhOx+h2nqcAl7FGmmLFqT68tROdxS/VkumOCYddz1NH4HAHgYIbfcuvUfltKF432MT185zrZW9QSSNu+DUIjaJXZwqNx7KVpu4lfDT3G2hmtvGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nR5fATHlRD+6dztjh2l+tvXeJ1xoa++KLExKPXftEps=;
 b=NheaTKf4uHcldueP4VjpC69yrew+V4PzV+bRO9dKNM7aJtsHbWI4hF+LEiY7yAbBKoTM92CklQjS9Skj0CyjGzrCLl4mYSwqeSXCDs8LKfqYblk8mYm7Xm73U06sCmPGmDUcNy++U5R9Qiq3+cvLZXDc5sCxxiQyODKYd+ZmWzGXy6S4h/Fxr3rT4Uj63KMZdjNlDGa5niuSD8tBDcC0Dpx62Jrca+z+JTfQSiyIYj4NLyBPqiQbFQc0VbVWw+6VG/iN8QS8TF06hh3rbxabygJnQzpWezrM7ZZjfunnKWCYWR4VFKTksSAEv4r70D2WorSSk3QCyQb5qBHa3NPj3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nR5fATHlRD+6dztjh2l+tvXeJ1xoa++KLExKPXftEps=;
 b=cL61he2vp2QIEQCTkBOW6qWJbw/i+RGipogjupQu+ah2x+2dw+CWBJo844VBwUe1jWo924YijtP+EDk2okH+RtAgbQSRzcGR8+Rk33PtubcWkFpDfC7t3x+LV3yabr61dnRohHjNDFLOKE1KaBabNYJ7lopbFFFJ8DALCNbpUCw=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by BN8PR07MB8003.namprd07.prod.outlook.com (2603:10b6:408:a7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 08:52:43 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::7a9f:f44:4172:5bb8]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::7a9f:f44:4172:5bb8%4]) with mapi id 15.20.6178.037; Wed, 29 Mar 2023
 08:52:43 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "peter.chen@kernel.org" <peter.chen@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] usb: cdnsp: Fixes issue with redundant Status Stage
Thread-Topic: [PATCH v2] usb: cdnsp: Fixes issue with redundant Status Stage
Thread-Index: AQHZW/J1HcM0SYCPZESHq1PJrSRph68Re5qAgAADfbA=
Date:   Wed, 29 Mar 2023 08:52:43 +0000
Message-ID: <BYAPR07MB538165F56DB6C42E6732BB34DD899@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20230321124053.200483-1-pawell@cadence.com>
 <ZCP435eCZhIIxesr@kroah.com>
In-Reply-To: <ZCP435eCZhIIxesr@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctMTAyODA3Y2MtY2UwZi0xMWVkLWE4NjItNjBhNWUyNWI5NmEzXGFtZS10ZXN0XDEwMjgwN2NlLWNlMGYtMTFlZC1hODYyLTYwYTVlMjViOTZhM2JvZHkudHh0IiBzej0iMTA4NiIgdD0iMTMzMjQ1NTM1NjE5MzIxMjQ2IiBoPSJjV2JQYld6eXJaTFB0cDN4WEtBY3I3YnJYY2c9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|BN8PR07MB8003:EE_
x-ms-office365-filtering-correlation-id: 2d334fef-3d38-4f4c-1f19-08db3032f5f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kbVK1zKv67HwBl4eCQ+LI4yJAMk6D41atl7u43/CvyH3pPCcmgITMvQWuNLfcHKXJjG10WwIlMXyUXbnK+QOZzb6U/4zl1CqIZJj+AjugU29ZhLu9u/m1TJ+iCJRyHWLnOrX91QdfXHI0eKw+8Mxee4rOdkiyz3ZvXJ9IgQoaYMsVrkj7sw80dQ/1oxY6CHDyEEJOuO10jXDfsJw+9Cnxjl83qawoROS/Tse9yw8YLRjU9dUyuJjsia/s5S9SrFId7ndDOKv9pWGmYnnAPHleYNCmen5h+pFkXiya9bL0qkHEYub1XjKL//wZts5aqKTR+Th21sb3WIYOHzD/dmWVMHE2okpadB2R5wwN9a2QEo9x06IW57OsUIH4+MTQ5XyrPDEqK+TFmVxJU9pZWFFKhS7d0TujlERc2Juph7ohrhbYVqWmALGgMzkHxlj9JjRwxlnORWzz10OkhXoqj2PwVezQ5wUOiWodrqI6qUg14fX2syLgWXkA9RbFQNbf7k1KjP5aAbo105rmTlIJm2S9dYgTOEMRp06OQQYDV1/VHprIGy8n6WiKEnibI9PqGPBXmxFEaefRwBgT1o4eRow83CeivwosneIqWowswv7JPREDevOuMPJ2psYV0lkWjCO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(366004)(39860400002)(396003)(36092001)(451199021)(86362001)(38070700005)(9686003)(83380400001)(33656002)(186003)(4744005)(5660300002)(26005)(6506007)(122000001)(8936002)(52536014)(2906002)(71200400001)(41300700001)(6916009)(55016003)(4326008)(7696005)(54906003)(66946007)(38100700002)(316002)(76116006)(66446008)(8676002)(66476007)(66556008)(64756008)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Eq0IJyJgmJXhngBeh7+s0Zl2YA7yXxsD3+0ZJs2AkaRCtXgQkKO7+OGXVQzQ?=
 =?us-ascii?Q?KMJvgFLwWGwhrBu9WYXr1mqnj91z+ladx04032ASB9emj7kcwMvbe2Th6aes?=
 =?us-ascii?Q?Jqk34flX3OicgnyXDAHNSh8Q8Pw7k7nBEz5BlCCXSvEb2OV9Sn3zFjWs/bUh?=
 =?us-ascii?Q?i+EiMqTWvQ7uLVUjzFFCzjqwJsszunnkLsVAvRr6s/4ZHeemkJppaAH0xeMU?=
 =?us-ascii?Q?jAyOoEmK0U/N8w8H12MMwAUiy9PPjChk6bZw3NUwD7QV49r5d04eKEIPq1A2?=
 =?us-ascii?Q?KMGet0WRzk7tQNF8tim8ko53Lyi+b8SXlVzh2PSSCUEtGTiN9TxXwfIoy5zN?=
 =?us-ascii?Q?XLWTThmiYATS9HWkpA/Wg4Z0y2y9Wi6Ao9N8lNxLQUyxD1csur3bNuqlj3p4?=
 =?us-ascii?Q?nRAujR5aLksp8DfORVm/MJloHoR5HV4NaSa/T3+HQzNAm3PHLjTIyjdU/sX6?=
 =?us-ascii?Q?gVdYJWSNRVjDt1AMmFSfqfwaaplZLjINp8vQZl9/7w/geXkIQ0WBvSmzlGMl?=
 =?us-ascii?Q?BgXtB4AQkZq7/J2uXU9zTKIclnGzkmek8anT90mf5QVk/zM44f4vdqlPx/pU?=
 =?us-ascii?Q?+HYzvK4I+//AvF/I+k5WEm+LJcY+DY7dvkqg2N2LmofpOsle9XGvZOt3mkf3?=
 =?us-ascii?Q?etY1KDHq8zqRNvRXZFFVNzHac1zu+NPkDF+WJbHP2xf1sOi8U6iVfySx44Mu?=
 =?us-ascii?Q?GxMs5H8Y3PAdFDMf0O9KUlb9575YB9aa5RaHyAJIGsgSIl8/RrFTXHHMh7xw?=
 =?us-ascii?Q?aBa+cVsNkrVfvmRKVS65pSsCmDwj68znZid+nKyVM38cw09YK2wYDPXcsYu2?=
 =?us-ascii?Q?6CTQU7yLqsxJbPpNX5qtzuCqheeWmg5wOpjvqG7n7D4hrBxLg5Q0w97Zd9UH?=
 =?us-ascii?Q?EhyDNDl2UiYVkE5xZ+o93eqfkptQt3Gzlj02yqvSQp87yyFMmkQNmtXzPksu?=
 =?us-ascii?Q?8W55qpKK11xC74ndq7aPpsRXaHllA8DQLiACDBx2Kv9vbHQNqiH/i4eXegSj?=
 =?us-ascii?Q?ZewfRahczeE/EnLX+7BfcpnKrXQpNKrwNZEc8AFLHqTL5RyRJsQ6Njyh+SkL?=
 =?us-ascii?Q?u1e9mCJnHGM4HgNwhgDJrSf+jECVi2xEuDY2p9Fv1JkjWgiqltAn9CUTsyEh?=
 =?us-ascii?Q?21vl879SVdCEIzTpFRtasSNafh/C0qUbZMUZSw1BgPBT81YgPejevpNrZIdU?=
 =?us-ascii?Q?5W6hpK5so5B81EF/tGltbbOLC+ejMr7RjlyfE/dUf3sUT9PZVftfrUeazzHs?=
 =?us-ascii?Q?Ep2V6jPEn2WBuqirn1UC4GWbyAOHsENeC943P8H62/eAV8JDqtRT/Ho9gVSp?=
 =?us-ascii?Q?HMXQZxqZfmyqCytC85zg2z9ghfYF//NSJdMEuYP8pJywFqe7uDwzYaEe0/c2?=
 =?us-ascii?Q?n/v2uX1eo4qjLlnFuuzxee0IOBj3T0Jkio4EEblto25mSncVwOaaMSm8zpAB?=
 =?us-ascii?Q?Vt7OgDroIchya2fGxVONdczVYH0sTfcFuWSWvt2ng716j7K1/DKiXJC+7bV/?=
 =?us-ascii?Q?NYOyxtN3YZaTfDjrljE4WKOPIQTQfSieT2dinRhBJv2bd2SHooLI986vhIw6?=
 =?us-ascii?Q?fjykxRB7yJ84ryrJDsWsD/IruD1wEeD8/gOVN37u?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d334fef-3d38-4f4c-1f19-08db3032f5f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 08:52:43.5619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZFdn1ino23MikNteiZ4vxJbKKrDnXw8WVlYkSeRSLFMdFVHh5SeBHgPD+QsiUh7QY869KHAAAzpuH7YiqfoMO8I2zI6qhW545fP4aUS4/zE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR07MB8003
X-Proofpoint-GUID: 0eTqa7pQ1SxSxENyinCZKZc21PuxJ_lm
X-Proofpoint-ORIG-GUID: 0eTqa7pQ1SxSxENyinCZKZc21PuxJ_lm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_02,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 phishscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 mlxlogscore=438
 suspectscore=0 clxscore=1011 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2303290073
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>On Tue, Mar 21, 2023 at 08:40:53AM -0400, Pawel Laszczak wrote:
>> In some cases, driver trees to send Status Stage twice.
>> The first one from upper layer of gadget usb subsystem and second time
>> from controller driver.
>> This patch fixes this issue and remove tricky handling of
>> SET_INTERFACE from controller driver which is no longer needed.
>>
>> cc: <stable@vger.kernel.org>
>> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence
>> USBSSP DRD Driver")
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>>
>> ---
>> Changelog:
>> v2:
>> - removed Smatch static checker warning
>
>This is already in 6.3-rc4, right?
>

v1 is in 6.3-rc4.

v2 fix the following issue:=20
The patch 5bc38d33a5a1: "usb: cdnsp: Fixes issue with redundant Status Stag=
e" from Mar 7, 2023, leads to the following Smatch static checker warning:

	drivers/usb/cdns3/cdnsp-ep0.c:470 cdnsp_setup_analyze()
	error: uninitialized symbol 'len'.=20

Regards,
Pawel
