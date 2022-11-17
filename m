Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3D362D325
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 07:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239203AbiKQGDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 01:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238854AbiKQGDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 01:03:02 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512D213D4C;
        Wed, 16 Nov 2022 22:03:00 -0800 (PST)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AH4lRJ1006539;
        Wed, 16 Nov 2022 22:02:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=m8TBaDcPRPzNNpkwlLRYuQq9HRTTiyPN5bls4q6ypfY=;
 b=XXC11vSopLDr9uO+Fun7fJlLMT0VV6xB1Dsy/BmZ4eJQ3Ma+y03sJMGxpUYgNu3lEBjV
 8KnMe5oiVOXmKhWKBIXgPSYNZ+4q/eUIq0tJFQpP4uz/gj+pxOjxevT5Z3IRc6QnXrOP
 yPlK7qXONaJrVdOUYYgn2B/bwDE4llpvjcf00O14GHfzdiiAcgNLtbFILrNtUSTHR/eH
 QOk51WlACIeMGlsvT0cGWp07rG2KDLem/mJ1e+Y5+5oyGVa5ZnX9YbDZ9oGy0oQSbiIp
 uF8YhycYI9bweNbcXwZMEVxqZ2cZ00WQVTTXx41CYpDFO3lzxviYxseXsYiEMpQ06Sqr 7A== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3kwe84g86e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 22:02:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1Ec9YE4bH++5kGXKXNZOYmBkuWgwTyD/tj8ZATPs4zJOh199XrtSUsFMOsgf4JN2n/XP24LxzvzOUw3gI7Zh6tqkD6ec9Jwa5DSDLi70pq3daUJZ4nH5193fnvWTF5L3opMom5FU0o/BmNRyOIYG8HiM4QbGuENSaNDmpvNJSg38XufwOai4ZUXTaEtylUSQd+5+5s58YSoFUx96oBOTe15zPxt9e4RbfxeBELjm86dDbLCDAAbWeWA+Cv3DK+JSyuIsHylfpbKHAyDfueRuwpHR4bJecCQiuihWhQXDcJ15g2iUyNncHyeEK0sJV4JkFdPVI9AHidwcgZWAwWjug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8TBaDcPRPzNNpkwlLRYuQq9HRTTiyPN5bls4q6ypfY=;
 b=h1uQwoes5ZnBr1ccEDthtG3hrZJ90wx02EFd90OnIs8Acm32a0vniQsrBRc58KWk1s+2qdiNjGaNvMCa0Vlc7bbE2fXcTrjThNFC47yGZlulrsn/iGwESHNkC7+Jme6NKVWn3M4eDGxEhahNFDylqgQIgwDmXfg8HqX4Pzm8B6i/3/hFt3lL39i9BajFvDzbhYi3BWvx7wV/ZPUS9Itgw4Ebw6kz/2xWsFm5znGhR6SXoOq+utNFmAQRtSl9NtSS9umvCrD2gg9HQsIIJmByY3fZ/+UcIDeKYi/aQGjWvWMW88r0Ajb4heI0q7oGwnc4yZEDUW9w3j/0VfdGYW7Ccw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8TBaDcPRPzNNpkwlLRYuQq9HRTTiyPN5bls4q6ypfY=;
 b=UkSkCYY7VV4w9skREGBQNkH9ZmXOoQfA8V66NOeNosWJ9JvF9na7km9h7hKpRcqWQfU1g+GN/D7q866ldlm0HTLKjwA6y4XF9XroDkIekRVmUmifUN8LwrNUD01qF5KN5di9nn93Zeu1um49Iil5KJ2ku/nkRn1rbdkFPcQ8TzE=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by DM8PR07MB8967.namprd07.prod.outlook.com (2603:10b6:8:d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.18; Thu, 17 Nov 2022 06:02:43 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc%4]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 06:02:43 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <hzpeterchen@gmail.com>
CC:     "peter.chen@kernel.org" <peter.chen@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Topic: [PATCH v3] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Index: AQHY+NPNw+7GZd89V0WFB5xoxMG5aa5CVF6AgABIlzA=
Date:   Thu, 17 Nov 2022 06:02:43 +0000
Message-ID: <BYAPR07MB538143C4835A04CB1F2CBECADD069@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20221115092218.421267-1-pawell@cadence.com>
 <CAL411-qwcboX-vTn+3oOPna+tixFNEajYi_E_rgweqrC3CcXCA@mail.gmail.com>
In-Reply-To: <CAL411-qwcboX-vTn+3oOPna+tixFNEajYi_E_rgweqrC3CcXCA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNzA5YTFmOGItNjYzZC0xMWVkLWE4NGQtMDBiZTQzMTQxNTFlXGFtZS10ZXN0XDcwOWExZjhkLTY2M2QtMTFlZC1hODRkLTAwYmU0MzE0MTUxZWJvZHkudHh0IiBzej0iNDU4NiIgdD0iMTMzMTMxMzg1NTk2OTQ4NTIwIiBoPSJCdUxBVEhsT1ZabE9tQm9uTG1HdlQvNmxNdjg9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|DM8PR07MB8967:EE_
x-ms-office365-filtering-correlation-id: bfeb9e61-4b40-40ef-af27-08dac8615789
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OxabMXPiLz+ihTQyk9mVqaEgVp+C5W6rtuu3hzSHPsJy1tanU9BbE6w1prbksVLpk8wSHeMtg+/Bh4yHpIy7efAucDVyzpt8g0EoLvnVj+RLRLf/KNQZ4Z8kXKfLGvO4Jyd0IKLeZ+uxxsPvt27fqn2Qrt+6bl1Om2US8kmAVS50JeF7bfNjG1jaz9PCQqpOLTLovW8uvImM6ldL57zU8tZD64qfOkbNC/0EGjhKylUH1T2TeAdn7AX5zaOgV+NHmD4HRtgxtzPDw84Y1zHGkYUsGYv6qwmBQiyLPBjizXrhpdjIhtT5YVT6/zhUYY/m36g2D5O6bsKzxc4NJZMtSqkNnsTk8ACsdsI6iHG3vym8zKALXNwH2BKJYDLnbWrXr7QYTHWTO3wHEzQF+ayUHwLrv3MgGXPST95op/DBhFEY6r0BU+aDVy6hAnx7dcC613b03Td+viVV3u2jyZ7Dp5NbiZvuBUnj9X4sVtmJuxXsuTTR/1x1ngga4nva5HXMsGUOENc5+EmpNDP8d+LK9fKAWHtvEtQnudn1b9PTfpnAd7Lk3AoaAAU540Mhghfa+Etw6jQgXVu9pf/07WTmmTsVSyx5ZGj/UCLS0qfRlyA5/I8NT6urID4vyEDpawda5pacWJIplvUAPvpa+lGdTHV+fUtK3+DW7xsX+dQXZx9NOXmZkYdY2mKtRX44oT7usTDA2LZdoWIILxNIMGEeCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(36092001)(451199015)(86362001)(33656002)(122000001)(38100700002)(55016003)(38070700005)(71200400001)(9686003)(316002)(54906003)(7696005)(6506007)(6916009)(2906002)(478600001)(83380400001)(41300700001)(8676002)(66946007)(4326008)(26005)(186003)(5660300002)(64756008)(76116006)(66556008)(8936002)(52536014)(66446008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUpobmM1NEJVbmlOaXpsdHBDR1daZC9Cem1hbDkzOTNMaXllWUlObGdxZGRK?=
 =?utf-8?B?TjBjUkhmenhZcFgvVXhWd3RoZjU2VXZBUGdHbldpUzloMFZFWFRtWndmUkg1?=
 =?utf-8?B?QXI1Tm5TME95dVRxS3p6TXFQZXJPWXJva01pYmFiOEgxbHUxRFlLcllKWlhy?=
 =?utf-8?B?UUNGOXNvdHRPbkFqb3dDZ0FtblhJeWxqOEg0MlFja1hrVDlvNnZUTEZDK3NK?=
 =?utf-8?B?TlUzc3JKNHpwa01XbmxCYUdsQjZCU2Y3M3Q4MTk2WmprbVpWMlY2NThLMU4r?=
 =?utf-8?B?Y29YVXJYN2s2NDIvblJGUFIwcjAyaWI5enRycGNaYUJIZXM1MU80TGRqVk41?=
 =?utf-8?B?MjRpYzBRdUhuUlgzYkJOSlhCQUNWREM0amdwZXhQOWRTNDBneS80MHV4Wi9n?=
 =?utf-8?B?TC9vR2trYlVQQkJiS0JCYVFtRDNzYVhRYzhpcFVaOTdVV2MvYUZlSE1iT2Vx?=
 =?utf-8?B?aHVDYjhPeHU0aHRuK3dxeENoZDBTeXR2dkdSZnBEanBBRFBYcUIzMW5GMmtV?=
 =?utf-8?B?bnU2REJyd2lsTmpmY2lHdUdCOUNwZjhwd25nY2lLRjB4YnV2SHB5UUJRVURC?=
 =?utf-8?B?UlFDSmRHa1NlSm9CSUs0MHpkay96NWs0R1dPKzB1eVFpRUpxdzJ2dVU4Z1BM?=
 =?utf-8?B?TWs3YmNNdXRnTXUvM3NoejZQVnFoVjhZZzJpeDlnRXIreVA4VURhRTV6c0lJ?=
 =?utf-8?B?bmhiemZYRjUyUy9SZ3gyMmVVQmJMcmZ5ZXRjbCtqdzRtV1VFTUR4VFJVVk9l?=
 =?utf-8?B?T0wyYkg4STE5cmRsOEEyaTlFSlVPMFUyMUVFWDBJRDIxUndMajJ2cXJIc1lZ?=
 =?utf-8?B?MEREa2cvMWxiTkc4VTVRRUVXMVZ1WkNHWWlIY010TFd5Y1RHajVrV3RVZlJl?=
 =?utf-8?B?V2RPV0dpWUd2OUVZMy8zQkJ1cnRoRzV3ZXZHMU1PYUo3TkErSEhzUnVtWm9t?=
 =?utf-8?B?alVkc3ZaK0l1Z1RjOGdtbjFzbU9SMnVxemxGU2VSTHZPQjJNb2RIMHhWZURT?=
 =?utf-8?B?UFVlOS9aUGNhS0U2RlNpUmNGL1lybmpQa1prelloYU5FNkZXK1lBWDRZQVJi?=
 =?utf-8?B?OThrVHBJc25lZXkrMVg1TW1oOHA0VmNyVGpYMUNVWVhCOE9aMWVWQndVMExL?=
 =?utf-8?B?RWNnR3dQV29HVVRuSUMreXFEOTA3MFUydVpmZ0NVUzVEU2RXOGZJbktZdXUw?=
 =?utf-8?B?dnBEZUE1NVFzZlpkQWJqaEV5RTZHWTVLNlF2UTk2aEVxZXNVREMzYWM3QjFq?=
 =?utf-8?B?UXNjbnFYWFJtMVN3bGx1Q3hQQiswa3VnZkx6YjdtNjJyNUo3OFcwckxPMVRG?=
 =?utf-8?B?YzdYbmpuMGpUNlpPdVUwc3IrMXEzOEpTRlNLbjNkaUVOTkZhN0RJanhiNG0r?=
 =?utf-8?B?WWI5SUpVNEU1ekVoR21xMXR3LzE0bDl3NDh2eHpNYXBFeWc3MGw1NW5tQnov?=
 =?utf-8?B?cWh6MWJCRmFqTFVzM3FTR0NMbGEvd3VkTFB0aWdCKzNpTlRYNE9xVmhSeVZK?=
 =?utf-8?B?eHJRRnFzLzVkdVNIM2Q5eEZ2Nlh4SHRZSDMvQ083NDBPbkZjS0lsK2FVMi9U?=
 =?utf-8?B?d1dIb0VkRFN2Qk15Qy9ITDJJMkN0MHZ0NHpLNk52S2w1VnhGL0xwTVRtd1FB?=
 =?utf-8?B?VXNHYytTdW4vaCtoQ04wMGlHdDFIQUV1Yzl2aVVnMUxubVRrOVQ5VGV2UXNO?=
 =?utf-8?B?VzVkVDgyK25NbHkvTDJlQS8vb21yMHRKeDBMQm04dzJkaFc4SlU5UmF2YXhk?=
 =?utf-8?B?bTlZUGVtSkZqR3NYWmpOSmRveEkxdDU5OWl0RWtmSTQ2dlJpM2NpRWlOK1Nj?=
 =?utf-8?B?b1FCT2hVd0pLeGxzNlNoc2xNUGdBK00wMVVCYTRVNXdoL3pUNkpqei9ZSU9N?=
 =?utf-8?B?SDZ6eC9UZHkzQjY4Y1BlYWU0OVg3Rjl0ckdTakhpNWFRYmpxVzdjaTVONFRq?=
 =?utf-8?B?WmRVU2p2QVFJQ3NRcW9GTnROSmx1M2FHTjNWK0tsSGNLSjU0N0pqN3hzV1Ru?=
 =?utf-8?B?RURsQVYrMEV5SU5jSmgwbGdqcDdybkcxSHFvZnozUUxZejF6bzJxdURJUXkw?=
 =?utf-8?B?NHF5VEMyVk5OV1ZYaGZuc3h6NGtxdDYraU92WUd0WjN4aytEcWpSK29aMnFR?=
 =?utf-8?B?bUxyS0o3SjBBd0UwRUgra0JrdjVKMVdDYm16Z2JteEZQRkRvaThYRFJXMk5h?=
 =?utf-8?B?Q1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfeb9e61-4b40-40ef-af27-08dac8615789
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 06:02:43.2214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G7YmElTMo4KSrBOrToNA4VaOhNxqh9vC02fZC88ljKZqFdEYyuUHbayQUsJMTD+knrcHruFibZDxw0AYZAT5lxtzAA0cwUHdy/h72/lQrnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR07MB8967
X-Proofpoint-GUID: jpenUdQX5cnkOzNzgdNJRgRM07RdfSI0
X-Proofpoint-ORIG-GUID: jpenUdQX5cnkOzNzgdNJRgRM07RdfSI0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_02,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 mlxlogscore=823
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211170045
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pk9uIFR1ZSwgTm92IDE1LCAyMDIyIGF0IDU6MjIgUE0gUGF3ZWwgTGFzemN6YWsgPHBhd2VsbEBj
YWRlbmNlLmNvbT4NCj53cm90ZToNCj4+DQo+PiBQYXRjaCBtb2RpZmllcyB0aGUgVERfU0laRSBp
biBUUkIgYmVmb3JlIFpMUCBUUkIuDQo+PiBUaGUgVERfU0laRSBpbiBUUkIgYmVmb3JlIFpMUCBU
UkIgbXVzdCBiZSBzZXQgdG8gMSB0byBmb3JjZSBwcm9jZXNzaW5nDQo+PiBaTFAgVFJCIGJ5IGNv
bnRyb2xsZXIuDQo+Pg0KPj4gY2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPj4gRml4ZXM6
IDNkODI5MDQ1NTlmNCAoInVzYjogY2Ruc3A6IGNkbnMzIEFkZCBtYWluIHBhcnQgb2YgQ2FkZW5j
ZQ0KPj4gVVNCU1NQIERSRCBEcml2ZXIiKQ0KPj4gU2lnbmVkLW9mZi1ieTogUGF3ZWwgTGFzemN6
YWsgPHBhd2VsbEBjYWRlbmNlLmNvbT4NCj4+IC0tLQ0KPj4gdjI6DQo+PiAtIHJldHVybmVkIHZh
bHVlIGZvciBsYXN0IFRSQiBtdXN0IGJlIDANCj4+IHYzOg0KPj4gLSBmaXggaXNzdWUgZm9yIHJl
cXVlc3QtPmxlbmd0aCA+IDY0S0INCj4+DQo+PiAgZHJpdmVycy91c2IvY2RuczMvY2Ruc3Atcmlu
Zy5jIHwgMTQgKysrKysrKysrKy0tLS0NCj4+ICAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9u
cygrKSwgNCBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvY2Ru
czMvY2Ruc3AtcmluZy5jDQo+PiBiL2RyaXZlcnMvdXNiL2NkbnMzL2NkbnNwLXJpbmcuYyBpbmRl
eCA3OTRlNDEzODAwYWUuLjg2ZTExNDFlMTUwZg0KPj4gMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJz
L3VzYi9jZG5zMy9jZG5zcC1yaW5nLmMNCj4+ICsrKyBiL2RyaXZlcnMvdXNiL2NkbnMzL2NkbnNw
LXJpbmcuYw0KPj4gQEAgLTE3NjMsMTAgKzE3NjMsMTUgQEAgc3RhdGljIHUzMiBjZG5zcF90ZF9y
ZW1haW5kZXIoc3RydWN0DQo+Y2Ruc3BfZGV2aWNlICpwZGV2LA0KPj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgaW50IHRyYl9idWZmX2xlbiwNCj4+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHVuc2lnbmVkIGludCB0ZF90b3RhbF9sZW4sDQo+PiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBzdHJ1Y3QgY2Ruc3BfcmVxdWVzdCAqcHJlcSwNCj4+IC0gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGJvb2wgbW9yZV90cmJzX2NvbWluZykNCj4+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGJvb2wgbW9yZV90cmJzX2NvbWluZywNCj4+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGJvb2wgemxwKQ0KPj4gIHsNCj4+ICAgICAgICAgdTMyIG1heHAs
IHRvdGFsX3BhY2tldF9jb3VudDsNCj4+DQo+PiArICAgICAgIC8qIEJlZm9yZSBaTFAgZHJpdmVy
IG5lZWRzIHNldCBURF9TSVpFID0gMS4gKi8NCj4+ICsgICAgICAgaWYgKHpscCkNCj4+ICsgICAg
ICAgICAgICAgICByZXR1cm4gMTsNCj4+ICsNCj4NCj5QYXdlbCwgd2l0aCB5b3VyIGNoYW5nZSwg
dGhlIFREX1NJWkUgaXMgMSBvciAwLCBidXQgbm90IGxpa2UgdGhlIGtlcm5lbCBkb2MNCj5kZWZp
bmVkIGxpa2UgYmVsb3c6DQoNCkRlc2NyaXB0aW9uIGlzIG5vdCBhZGRlZCBpbiBrZXJuZWwgZG9j
IGJ1dCBpcyBhZGRlZCBiZWZvcmUgImlmICh6bHApIi4NCg0KSSB3aWxsIGFkZCBhcyBsYXN0IGxp
bmVzIGluIGtlcm5lbCBkb2MgdGhlIGRlc2NyaXB0aW9uOg0KDQogICoNCiAgKiBURCBjb250YWlu
aW5nIFpMUCBtdXN0IGhhdmUgVEQgc2l6ZSBzZXQgdG8gb25lIGluIHBlbnVsdGltYXRlIFRSQiBp
biBURC4NCiAqLw0KDQpXaWxsIHRoaXMgcGF0Y2ggYmUgY29ycmVjdCBmb3IgeW91IHRoZW4/DQoN
ClBhd2VsDQoNCj4NCj4vKg0KPiAqIFREIHNpemUgaXMgdGhlIG51bWJlciBvZiBtYXggcGFja2V0
IHNpemVkIHBhY2tldHMgcmVtYWluaW5nIGluIHRoZSBURA0KPiAqICgqbm90KiBpbmNsdWRpbmcg
dGhpcyBUUkIpLg0KPiAqDQo+ICogVG90YWwgVEQgcGFja2V0IGNvdW50ID0gdG90YWxfcGFja2V0
X2NvdW50ID0NCj4gKiAgICAgRElWX1JPVU5EX1VQKFREIHNpemUgaW4gYnl0ZXMgLyB3TWF4UGFj
a2V0U2l6ZSkNCj4gKg0KPiAqIFBhY2tldHMgdHJhbnNmZXJyZWQgdXAgdG8gYW5kIGluY2x1ZGlu
ZyB0aGlzIFRSQiA9IHBhY2tldHNfdHJhbnNmZXJyZWQgPQ0KPiAqICAgICByb3VuZGRvd24odG90
YWwgYnl0ZXMgdHJhbnNmZXJyZWQgaW5jbHVkaW5nIHRoaXMgVFJCIC8gd01heFBhY2tldFNpemUp
DQo+ICoNCj4gKiBURCBzaXplID0gdG90YWxfcGFja2V0X2NvdW50IC0gcGFja2V0c190cmFuc2Zl
cnJlZA0KPiAqDQo+ICogSXQgbXVzdCBmaXQgaW4gYml0cyAyMToxNywgc28gaXQgY2FuJ3QgYmUg
YmlnZ2VyIHRoYW4gMzEuDQo+ICogVGhpcyBpcyB0YWtlbiBjYXJlIG9mIGluIHRoZSBUUkJfVERf
U0laRSgpIG1hY3JvDQo+ICoNCj4gKiBUaGUgbGFzdCBUUkIgaW4gYSBURCBtdXN0IGhhdmUgdGhl
IFREIHNpemUgc2V0IHRvIHplcm8uICANCj4gKi8NCj4NCj5QZXRlcg0KPg0KPj4gICAgICAgICAv
KiBPbmUgVFJCIHdpdGggYSB6ZXJvLWxlbmd0aCBkYXRhIHBhY2tldC4gKi8NCj4+ICAgICAgICAg
aWYgKCFtb3JlX3RyYnNfY29taW5nIHx8ICh0cmFuc2ZlcnJlZCA9PSAwICYmIHRyYl9idWZmX2xl
biA9PSAwKSB8fA0KPj4gICAgICAgICAgICAgdHJiX2J1ZmZfbGVuID09IHRkX3RvdGFsX2xlbikg
QEAgLTE5NjAsNyArMTk2NSw4IEBAIGludA0KPj4gY2Ruc3BfcXVldWVfYnVsa190eChzdHJ1Y3Qg
Y2Ruc3BfZGV2aWNlICpwZGV2LCBzdHJ1Y3QgY2Ruc3BfcmVxdWVzdA0KPipwcmVxKQ0KPj4gICAg
ICAgICAgICAgICAgIC8qIFNldCB0aGUgVFJCIGxlbmd0aCwgVEQgc2l6ZSwgYW5kIGludGVycnVw
dGVyIGZpZWxkcy4gKi8NCj4+ICAgICAgICAgICAgICAgICByZW1haW5kZXIgPSBjZG5zcF90ZF9y
ZW1haW5kZXIocGRldiwgZW5xZF9sZW4sIHRyYl9idWZmX2xlbiwNCj4+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZnVsbF9sZW4sIHByZXEsDQo+PiAtICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1vcmVfdHJic19jb21p
bmcpOw0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBt
b3JlX3RyYnNfY29taW5nLA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB6ZXJvX2xlbl90cmIpOw0KPj4NCj4+ICAgICAgICAgICAgICAgICBsZW5ndGhf
ZmllbGQgPSBUUkJfTEVOKHRyYl9idWZmX2xlbikgfCBUUkJfVERfU0laRShyZW1haW5kZXIpIHwN
Cj4+ICAgICAgICAgICAgICAgICAgICAgICAgIFRSQl9JTlRSX1RBUkdFVCgwKTsgQEAgLTIwMjUs
NyArMjAzMSw3IEBAIGludA0KPj4gY2Ruc3BfcXVldWVfY3RybF90eChzdHJ1Y3QgY2Ruc3BfZGV2
aWNlICpwZGV2LCBzdHJ1Y3QgY2Ruc3BfcmVxdWVzdA0KPj4gKnByZXEpDQo+Pg0KPj4gICAgICAg
ICBpZiAocHJlcS0+cmVxdWVzdC5sZW5ndGggPiAwKSB7DQo+PiAgICAgICAgICAgICAgICAgcmVt
YWluZGVyID0gY2Ruc3BfdGRfcmVtYWluZGVyKHBkZXYsIDAsIHByZXEtPnJlcXVlc3QubGVuZ3Ro
LA0KPj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwcmVx
LT5yZXF1ZXN0Lmxlbmd0aCwgcHJlcSwgMSk7DQo+PiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHByZXEtPnJlcXVlc3QubGVuZ3RoLA0KPj4gKyBwcmVxLCAx
LCAwKTsNCj4+DQo+PiAgICAgICAgICAgICAgICAgbGVuZ3RoX2ZpZWxkID0gVFJCX0xFTihwcmVx
LT5yZXF1ZXN0Lmxlbmd0aCkgfA0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBU
UkJfVERfU0laRShyZW1haW5kZXIpIHwNCj4+IFRSQl9JTlRSX1RBUkdFVCgwKTsgQEAgLTIyMjUs
NyArMjIzMSw3IEBAIHN0YXRpYyBpbnQNCj5jZG5zcF9xdWV1ZV9pc29jX3R4KHN0cnVjdCBjZG5z
cF9kZXZpY2UgKnBkZXYsDQo+PiAgICAgICAgICAgICAgICAgLyogU2V0IHRoZSBUUkIgbGVuZ3Ro
LCBURCBzaXplLCAmIGludGVycnVwdGVyIGZpZWxkcy4gKi8NCj4+ICAgICAgICAgICAgICAgICBy
ZW1haW5kZXIgPSBjZG5zcF90ZF9yZW1haW5kZXIocGRldiwgcnVubmluZ190b3RhbCwNCj4+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdHJiX2J1ZmZfbGVu
LCB0ZF9sZW4sIHByZXEsDQo+PiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIG1vcmVfdHJic19jb21pbmcpOw0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBtb3JlX3RyYnNfY29taW5nLCAwKTsNCj4+DQo+PiAgICAg
ICAgICAgICAgICAgbGVuZ3RoX2ZpZWxkID0gVFJCX0xFTih0cmJfYnVmZl9sZW4pIHwNCj4+IFRS
Ql9JTlRSX1RBUkdFVCgwKTsNCj4+DQo+PiAtLQ0KPj4gMi4yNS4xDQo+Pg0K
