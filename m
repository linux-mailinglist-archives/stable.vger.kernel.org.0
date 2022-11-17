Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE1962D365
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 07:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239300AbiKQGWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 01:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbiKQGWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 01:22:04 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35ED630F62;
        Wed, 16 Nov 2022 22:22:03 -0800 (PST)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AH4sGFm013219;
        Wed, 16 Nov 2022 22:21:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=bFssIYLLmrq+WO0Gbfk0YYVd2BmNSHBvcNOiLs5U/oA=;
 b=d051qgcs9Y4VrV1cgZ/PWqsasNsm5Ozbs84SPUPQomiIKRcBkKqNQlMZ94+ir86VmKWr
 jxuv0iXohxI/OHOqpkuxDQh1aSmoYTFPoSECIey7swR3lrUu3rHGkyqIJw8yUd4wv581
 CFgOZqZTz24Cx7IT6jbFQq/sOEOguAQQzz7/dTOuFa604PSJnvIyTmgZxR2NIq2+4g3a
 st3sjzG+LD9/aD5zNnVfuEMFoNOGuKBzDREwSIdChU9PtJYkp1g5BN1UQk55+DfBDwx2
 SAKtmTgRtx3i/OtsS07rsClFhZmuWGbukWANcBywg3EDUhV3O9aG/Wc0ZLFxoZWdOTir FA== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3kweb6r8y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 22:21:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2edDfo9BO0n5WWcPjIUPR0ot/BL5k8cRrsmOWHytm8ya6iUtBN8zZq09xT8mT7vKA2qCu2vbrH0HTF76ASu7+SxKgnKGaNT/gkbLedqTzCee7BLKaw45sZU7hQgX79xT8GBSF0FG8TwP6akI9H4/FTai6/KPs7u/vB2WdzaQ6TjeJX3vDQNIFIJ+aZy4SyDQikqfqpM6QIulO1I0FACSmMZIbDeH+MWU7Jc3pYq7A1/wxlU1DQJ+UiWVTOtrt6gT1ktFXQwtJ1InNPmBOWMILrhvtJRw5/D4E/clLVbC09JYTnqwZgBCo9fk2LZm1b9ioM4FTFacf8KLtnyoYREkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFssIYLLmrq+WO0Gbfk0YYVd2BmNSHBvcNOiLs5U/oA=;
 b=DMxbm6trgKxL/B7u/FyHTHGXOe6NxAYkEiQwfcK5oUg/kvanMJHd5ULK7d1Js5Lhv+Tg27UIa41d08r4HPJtUkYhICxXXwyb5yS8BPEq9G+nsmGoBpSDdWctbpwUPdxkKCl5n3pZxL7YpWWTsTsD/pjWdXECQ1IvJ3gePdELAiMNT6O4J2n2O3Ftr4wbpE1lHXnB0kgsDEcWfKkluKNitwcDnwf90moiFIXyinyFBIp1alywYKL9F5oWoTLD9YwgBor+gAyzR3GBry7zr+KS7wyURtx6wNMSWb5pYGKYXIs5/oYo+NXHXfMJlyRiGfyAtITdC50XJu8tLu7hjTenFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFssIYLLmrq+WO0Gbfk0YYVd2BmNSHBvcNOiLs5U/oA=;
 b=hb6m8TmgSMyirf9VLwUyMpdvtoLfHisJonWQcfJqe/7leomeKS0lMdPx2DH/CBp8yu5twF9QwIC0HJ5OVk3K756oFD4QMNynBG7WwhYcN+qJIqR5TZx2Vlx6KiNBrCIuUA7a45IEYVZHcRhAYMB8YM6JJ7ETI9OvXQOt+B7B6pU=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by BYAPR07MB4630.namprd07.prod.outlook.com (2603:10b6:a02:f6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Thu, 17 Nov
 2022 06:21:49 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc%4]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 06:21:49 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <hzpeterchen@gmail.com>
CC:     "peter.chen@kernel.org" <peter.chen@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Topic: [PATCH v3] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Index: AQHY+NPNw+7GZd89V0WFB5xoxMG5aa5CVF6AgABOagCAAADBUA==
Date:   Thu, 17 Nov 2022 06:21:49 +0000
Message-ID: <BYAPR07MB538179096E37FCDEC232CE15DD069@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20221115092218.421267-1-pawell@cadence.com>
 <CAL411-qwcboX-vTn+3oOPna+tixFNEajYi_E_rgweqrC3CcXCA@mail.gmail.com>
 <CAL411-pZm_8M4gSXJQ4zC1F-1w4zfTS2JRzxRM2e-ZQFjsx_Uw@mail.gmail.com>
In-Reply-To: <CAL411-pZm_8M4gSXJQ4zC1F-1w4zfTS2JRzxRM2e-ZQFjsx_Uw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctMWM2OGQyZTMtNjY0MC0xMWVkLWE4NGQtMDBiZTQzMTQxNTFlXGFtZS10ZXN0XDFjNjhkMmU1LTY2NDAtMTFlZC1hODRkLTAwYmU0MzE0MTUxZWJvZHkudHh0IiBzej0iMzc0MCIgdD0iMTMzMTMxMzk3MDY5MzI2Mjg1IiBoPSJvcDlnYjVBUTNTZ3BkOHhaRXZndkdFUXpMSU09IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|BYAPR07MB4630:EE_
x-ms-office365-filtering-correlation-id: 66008323-7994-4c9e-8a8e-08dac86402d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b97meZce2R3Efqo9dwGS97b34MJXSGcnWj4rsneHKb/sLQArfP9IRPQOo9cRlEgxVj1HPITuXaYKtsqFvTVObkhLiBvY8FIOCSI0X2HDC/UbZv2GGCjzcGSO0zk+Q+pz1Ob/uX5t/Vf+A/FUVfvwGYPnt/hioUzAWaBHZhCpGz7LavJ6axpMPMkLXkIpEhHwJR//q0DfO3z6VQeOfm5z9yAapkIUHEm3baddhoyPxAiG7AeSqJ8IC8f0WgRxl05thXFSOWfpu3I30Llix8l6uNohs56J4mq3RJZQfgVvhlEyT2Wii00olAkWffggnVxxPQLrw14zmXSr2hJrx6Gd+BJBHmxuJlCViOZ2lEC3HwyXxmYSB58VrzlkIvrJyNq15el6T24ygIR+Mghd5wBoZt00R93pNMtcwPabb+AJbH7DMqNOyOGrYbnfwBMOE3WSLP3oSKhbmbgjEPtMMrekfyJKG4H9UzOX+EONi1CebowqsDu/LXZVoIgZYnJSmKN5FYMq80+f5t2nH55AzHwgwg5VxC861kP+nZeunaWfwVb4UL/5ccwzzw3bO8iSEUchmtuUyaHVzChF1YMu6awaBdjzD+d6rYUPLdX6DoeMRpxyLzHo7/SPvxRc8HJee8bL6aqHzkO7Bp3dVMJ4MHe6O9Y+wQb1/Js9SOdbOln94AlJzpZcC+q+wu0p0XwRbNh8w/bcl5WysuPzQJHCn/YBmg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(36092001)(451199015)(186003)(5660300002)(83380400001)(66946007)(6916009)(66446008)(76116006)(316002)(8676002)(66476007)(66556008)(8936002)(64756008)(38100700002)(41300700001)(33656002)(55016003)(4326008)(2906002)(52536014)(122000001)(38070700005)(54906003)(478600001)(86362001)(26005)(7696005)(6506007)(71200400001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFlISTdzL3kvS01aVWdnbXdxMUdqa2NFWHlRZnNGV1d1SVRIZXVqdlhKcm1K?=
 =?utf-8?B?UDd3S2hVMUM2c2E0K0FhNnJFcTNVbFBJdEREMWx2TUR1blM2dmxCN01Pa3F4?=
 =?utf-8?B?Q2tnejZseCtsdktHSjFSWnlJY25zZTlCNTJranBaWDYzbWhDRjFpZytUL0VB?=
 =?utf-8?B?TGZrM0dlaTJtdGduMUhKcGkwdGg1VHZ4ekFaMlRjWkRKVnpkN0FkQXpvWU1T?=
 =?utf-8?B?TDNnYnNPUnU4NW9RQVBjNGIyaEZjRXIyaitJK2pBTEtweGw4L2hxMzFmNnJn?=
 =?utf-8?B?TS9raGVTUFduQUc0R0RIZmlReDU3dVFobzN0RlpsVXFJOEx5VHdBUWk5Q24x?=
 =?utf-8?B?TDlwc3c3ZUNUUjgwOG9VL3BmNkpXYmxqV0VOSE1ZNld2b1g2NmpCVEU2NSsy?=
 =?utf-8?B?Z1VLaVJsYlJzLy83NTRtV3VzMlVGdXdpQnF2dENFZWxxVEJsQVA0Q2M5UXF5?=
 =?utf-8?B?d2s4R1V0VDdwOHNMU3JUbUhFaVB1cDFlc3FXQUptcnRrNWRKVzZ2QUFPRnNx?=
 =?utf-8?B?dk5VdWl5MTlxU3luUFVvNTVFdjFyMkRLbUcwMHZNYllzWm1jNGo4NDIzbEgy?=
 =?utf-8?B?QWtBODc3RTRBbGdWS1VFeDIySml2d1lRdzV2RlZqOG1aUWo4YkRxTzJZSWh2?=
 =?utf-8?B?LytFTTBDbVhKbE9FUU9TTUtEekVQNHZadDVnZk9YaHF3NjBVaFpRS3p1QmxM?=
 =?utf-8?B?RjZkWm9YZjZNQm1ZZXNweHU1a2pOV3ZWdE5WOGVQU1pOZzNiK2tvb0VWTVZY?=
 =?utf-8?B?RzNGU1ZOV0tDbW8vbklFOGVEMWVvVHY4S2hWMU1YVW9sdVY0ZDBFY2xrZG1o?=
 =?utf-8?B?OXBjcUtnazhyZ09IcXhZSDZQRkJFUGxKbmYyTGlObVovYnZueGx3OGVYNnEr?=
 =?utf-8?B?UWVFT1Z2aEJaYlZOZ3RnUzdqOWJkZjFKVmZtcHowdE1ZTVVkMmZSbEZXK3B4?=
 =?utf-8?B?TUJQN1NwZ0YxQklwcGdvYm14Z2NUZUc1ZWVtRUQxT0NWUi80K1I5VzJNR05r?=
 =?utf-8?B?RHQxY2dWTW1sUitkeFc0QTFtbDRXekRXb25VUXJUUDBqZkpDajZlWUhTMWdm?=
 =?utf-8?B?d2ZuZWJtejJxUjI3am54TjJacUFvVHYraDAvVm9FRHlmTFdEQzV4WGhxNGc5?=
 =?utf-8?B?NTlkY2VqWmVoQ01VYWdOYU4xVlRvQ0dUL1Rmb21lcXJwRjhaOERaOFk0d2Jn?=
 =?utf-8?B?blBPNS9Ob3pPSmc0ZUpMcE5PWURkaVYzcHo5QXBwK1crSnRKR0U2djRGVVp0?=
 =?utf-8?B?R1ZjTk1YOHIzQ3hXc0s1NUZ5U2FNQUpaU1ozWWJpelNnbFhUNGFObHpkOHdX?=
 =?utf-8?B?S1hhSWpCblhaVEJ2dWw3cXFPNGJTNXBqeFdqbDY0cUtIWUFwYWVqZHRxRHJT?=
 =?utf-8?B?dk81d2MvQ1UyKzR6MkNQMzE4S0FYZmZzeStvTld4SE5kRnRtbG9GdXZRTnNj?=
 =?utf-8?B?d0lhczg4QmVlWnR5bFJmTzBORldRb3lkdjJnSThud2c2Q3hudlZLWWZxRVNG?=
 =?utf-8?B?VVRtOXRrWFEyM0dZRHFlYmhUZDI5RGJZeVlweFRLamJ5T1JuNVRBWDQ1ZnJE?=
 =?utf-8?B?dS9aNS9ITGU2eXVFZGhPUUx4TWR1ZU5reUNKb3BUMHdQbVcwcXVuMGVUenFi?=
 =?utf-8?B?VmNKWVg2U2JCWVNmTUhDbUJIZElpQ2RZaTNJTW4rKzRtTHh6SFp3SnFuNkVh?=
 =?utf-8?B?K2t0YXNLK04yWENPL3BJTjlWV3JuMTlDRHVGYXh6am9ONE9JVUg3Q2RqRkFt?=
 =?utf-8?B?amNhWFNpVzNBSGUrNG5USWZUS0lyM2dRVlM3SS94UmJhdU96eGRKTnVqQVd4?=
 =?utf-8?B?YnlESzdkdkI3NVVrdXI3emlSZzY4LzVyejk3K0JLQnpqcUVndTZVL2Zoa2ly?=
 =?utf-8?B?RVM0SFV2YXZ5cFlGTnhiU3JYZDk3MEdhOEJ0RWRMWEFsa05ZZndrZ1FkU2ph?=
 =?utf-8?B?bUhEVGxTaVl1ckZMb2FvbnkvQXg1WXNJY09lS01mVXJsekt4d1JHY1FGMUU4?=
 =?utf-8?B?QU9Od0hadHBGMkJvb1JLZjJ6bVhRaVpldk1kZ1RMbFRXTDA0d2VES1prajF3?=
 =?utf-8?B?WlV1V1F4cEp5VFJaSW0yaVF5VVN4dThjeGNqa05hSFRXQ3dSR3ZRNVAwdkF0?=
 =?utf-8?B?QVZ2KzZMYWxtVDd2T1oyeWJ5UGg0bjZpNzl1b3FKVHdaVThlOUQrejQzMEo2?=
 =?utf-8?B?Z3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66008323-7994-4c9e-8a8e-08dac86402d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 06:21:49.5817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BUm4FZj9PJ48hOWyQRzrZgqeBfcxGjIfqRU78RfAEhFx8jHgkEQ2BkZvNW0IU8Vi8y85UTk2iVcDfEpv5c2xGo6zkJQ6pOuDYig8W4XEyTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB4630
X-Proofpoint-GUID: ERVPJZbsYBNHR5oqt4PpEurg1jOvhXw1
X-Proofpoint-ORIG-GUID: ERVPJZbsYBNHR5oqt4PpEurg1jOvhXw1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_02,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxlogscore=776
 malwarescore=0 mlxscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 clxscore=1015 suspectscore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211170047
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pg0KPj4gUGF3ZWwsIHdpdGggeW91ciBjaGFuZ2UsIHRoZSBURF9TSVpFIGlzIDEgb3IgMCwgYnV0
IG5vdCBsaWtlIHRoZQ0KPj4ga2VybmVsIGRvYyBkZWZpbmVkIGxpa2UgYmVsb3c6DQo+Pg0KPg0K
PlBsZWFzZSBvbWl0IG15IGNvbW1lbnRzLCBJIGRpZCBub3QgY2hlY2sgdGhlIGNvZGUgY2FyZWZ1
bGx5Lg0KPg0KPj4gLyoNCj4+ICAqIFREIHNpemUgaXMgdGhlIG51bWJlciBvZiBtYXggcGFja2V0
IHNpemVkIHBhY2tldHMgcmVtYWluaW5nIGluIHRoZQ0KPj4gVEQNCj4+ICAqICgqbm90KiBpbmNs
dWRpbmcgdGhpcyBUUkIpLg0KPj4gICoNCj4NCj5XaXRoIHlvdXIgY3VycmVudCBjaGFuZ2UsIGl0
IG1heSB3b3JrLiBCdXQgeW91ciBjaGFuZ2UgY29uZmxpY3RzIHdpdGggdGhlDQo+eEhDSSBzcGVj
IHRoYXQgZGVzY3JpYmVkIGFib3ZlLg0KPldpdGggWkxQLCB0aGUgbGFzdCB1c2VmdWwgdHJiJ3Mg
VEQgc2l6ZSBzaG91bGQgYmUgMCwgYnV0IGlmIGl0IGlzIDAsIHRoZSBjb250cm9sbGVyDQo+d2ls
bCBiZSBjb25mdXNlZC4NCj4NCj5XaXRoIHlvdXIgY2hhbmdlLCBpdCBtYWtlcyB0aGUgY29kZSBt
b3JlIGRpZmZlcmVudCB3aXRoIHhoY2kncy4gRG8geW91DQo+Y29uc2lkZXIgaGFuZGxpbmcgWkxQ
IHBhY2tldCBhdCBhbm90aGVyIFREIGluc3RlYWQgb2YgY3VycmVudCBhdCB0aGUgc2FtZSBURA0K
Pu+8nw0KDQpZZXMsIEkgY29uc2lkZXJlZCBpdCwgYnV0IHRvIHNpbXBsaWZ5IHRoZSBkcml2ZXIg
SSByZXNpZ25lZCBmcm9tIGhhbmRsaW5nIG11bHRpcGxlIFREDQpwZXIgdXNiX3JlcXVlc3QuIA0K
Q3VycmVudCBzb2x1dGlvbiBpcyBzaW1wbGVyIGFuZCBzdXBwb3J0ZWQgYnkgZGV2aWNlIGNvbnRy
b2xsZXIuDQoNCkFkZGl0aW9uYWxseSwgdGhlIG5leHQgWkxQIGZpeCBtdXN0IGJlIGFkZGVkIGZv
ciBjb250cm9sIGVuZHBvaW50IGZvciBEYXRhIFN0YWdlIA0KYW5kIHByb2JhYmx5IGl0IHdpbGwg
bm90IHdvcmsgd2l0aCAyIFREcy4NCg0KUGF3ZWwNCg0KPg0KPj4gICogVG90YWwgVEQgcGFja2V0
IGNvdW50ID0gdG90YWxfcGFja2V0X2NvdW50ID0NCj4+ICAqICAgICBESVZfUk9VTkRfVVAoVEQg
c2l6ZSBpbiBieXRlcyAvIHdNYXhQYWNrZXRTaXplKQ0KPj4gICoNCj4+ICAqIFBhY2tldHMgdHJh
bnNmZXJyZWQgdXAgdG8gYW5kIGluY2x1ZGluZyB0aGlzIFRSQiA9IHBhY2tldHNfdHJhbnNmZXJy
ZWQgPQ0KPj4gICogICAgIHJvdW5kZG93bih0b3RhbCBieXRlcyB0cmFuc2ZlcnJlZCBpbmNsdWRp
bmcgdGhpcyBUUkIgLw0KPndNYXhQYWNrZXRTaXplKQ0KPj4gICoNCj4+ICAqIFREIHNpemUgPSB0
b3RhbF9wYWNrZXRfY291bnQgLSBwYWNrZXRzX3RyYW5zZmVycmVkDQo+PiAgKg0KPj4gICogSXQg
bXVzdCBmaXQgaW4gYml0cyAyMToxNywgc28gaXQgY2FuJ3QgYmUgYmlnZ2VyIHRoYW4gMzEuDQo+
PiAgKiBUaGlzIGlzIHRha2VuIGNhcmUgb2YgaW4gdGhlIFRSQl9URF9TSVpFKCkgbWFjcm8NCj4+
ICAqDQo+PiAgKiBUaGUgbGFzdCBUUkIgaW4gYSBURCBtdXN0IGhhdmUgdGhlIFREIHNpemUgc2V0
IHRvIHplcm8uDQo+PiAgKi8NCj4+DQo+PiBQZXRlcg0KPj4NCj4+ID4gICAgICAgICAvKiBPbmUg
VFJCIHdpdGggYSB6ZXJvLWxlbmd0aCBkYXRhIHBhY2tldC4gKi8NCj4+ID4gICAgICAgICBpZiAo
IW1vcmVfdHJic19jb21pbmcgfHwgKHRyYW5zZmVycmVkID09IDAgJiYgdHJiX2J1ZmZfbGVuID09
IDApIHx8DQo+PiA+ICAgICAgICAgICAgIHRyYl9idWZmX2xlbiA9PSB0ZF90b3RhbF9sZW4pIEBA
IC0xOTYwLDcgKzE5NjUsOCBAQCBpbnQNCj4+ID4gY2Ruc3BfcXVldWVfYnVsa190eChzdHJ1Y3Qg
Y2Ruc3BfZGV2aWNlICpwZGV2LCBzdHJ1Y3QgY2Ruc3BfcmVxdWVzdA0KPipwcmVxKQ0KPj4gPiAg
ICAgICAgICAgICAgICAgLyogU2V0IHRoZSBUUkIgbGVuZ3RoLCBURCBzaXplLCBhbmQgaW50ZXJy
dXB0ZXIgZmllbGRzLiAqLw0KPj4gPiAgICAgICAgICAgICAgICAgcmVtYWluZGVyID0gY2Ruc3Bf
dGRfcmVtYWluZGVyKHBkZXYsIGVucWRfbGVuLCB0cmJfYnVmZl9sZW4sDQo+PiA+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZnVsbF9sZW4sIHByZXEsDQo+
PiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbW9yZV90
cmJzX2NvbWluZyk7DQo+PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgbW9yZV90cmJzX2NvbWluZywNCj4+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB6ZXJvX2xlbl90cmIpOw0KPj4gPg0KPj4gPiAgICAgICAg
ICAgICAgICAgbGVuZ3RoX2ZpZWxkID0gVFJCX0xFTih0cmJfYnVmZl9sZW4pIHwgVFJCX1REX1NJ
WkUocmVtYWluZGVyKQ0KPnwNCj4+ID4gICAgICAgICAgICAgICAgICAgICAgICAgVFJCX0lOVFJf
VEFSR0VUKDApOyBAQCAtMjAyNSw3ICsyMDMxLDcgQEANCj4+ID4gaW50IGNkbnNwX3F1ZXVlX2N0
cmxfdHgoc3RydWN0IGNkbnNwX2RldmljZSAqcGRldiwgc3RydWN0DQo+PiA+IGNkbnNwX3JlcXVl
c3QgKnByZXEpDQo+PiA+DQo+PiA+ICAgICAgICAgaWYgKHByZXEtPnJlcXVlc3QubGVuZ3RoID4g
MCkgew0KPj4gPiAgICAgICAgICAgICAgICAgcmVtYWluZGVyID0gY2Ruc3BfdGRfcmVtYWluZGVy
KHBkZXYsIDAsIHByZXEtPnJlcXVlc3QubGVuZ3RoLA0KPj4gPiAtICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHByZXEtPnJlcXVlc3QubGVuZ3RoLCBwcmVxLCAx
KTsNCj4+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBw
cmVxLT5yZXF1ZXN0Lmxlbmd0aCwNCj4+ID4gKyBwcmVxLCAxLCAwKTsNCj4+ID4NCj4+ID4gICAg
ICAgICAgICAgICAgIGxlbmd0aF9maWVsZCA9IFRSQl9MRU4ocHJlcS0+cmVxdWVzdC5sZW5ndGgp
IHwNCj4+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBUUkJfVERfU0laRShyZW1h
aW5kZXIpIHwNCj4+ID4gVFJCX0lOVFJfVEFSR0VUKDApOyBAQCAtMjIyNSw3ICsyMjMxLDcgQEAg
c3RhdGljIGludA0KPmNkbnNwX3F1ZXVlX2lzb2NfdHgoc3RydWN0IGNkbnNwX2RldmljZSAqcGRl
diwNCj4+ID4gICAgICAgICAgICAgICAgIC8qIFNldCB0aGUgVFJCIGxlbmd0aCwgVEQgc2l6ZSwg
JiBpbnRlcnJ1cHRlciBmaWVsZHMuICovDQo+PiA+ICAgICAgICAgICAgICAgICByZW1haW5kZXIg
PSBjZG5zcF90ZF9yZW1haW5kZXIocGRldiwgcnVubmluZ190b3RhbCwNCj4+ID4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB0cmJfYnVmZl9sZW4sIHRkX2xl
biwgcHJlcSwNCj4+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBtb3JlX3RyYnNfY29taW5nKTsNCj4+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBtb3JlX3RyYnNfY29taW5nLCAwKTsNCj4+ID4NCj4+ID4gICAg
ICAgICAgICAgICAgIGxlbmd0aF9maWVsZCA9IFRSQl9MRU4odHJiX2J1ZmZfbGVuKSB8DQo+PiA+
IFRSQl9JTlRSX1RBUkdFVCgwKTsNCj4+ID4NCj4+ID4gLS0NCj4+ID4gMi4yNS4xDQo+PiA+DQo=
