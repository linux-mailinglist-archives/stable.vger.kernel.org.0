Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDA3653D6E
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 10:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbiLVJXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 04:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235191AbiLVJXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 04:23:32 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D485C1D0E3;
        Thu, 22 Dec 2022 01:23:31 -0800 (PST)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BM8H72h018601;
        Thu, 22 Dec 2022 01:23:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=pcQH8X547k3nlGK9ObhgRzwVwYyPFrFd8MepKzGMntw=;
 b=fb3Bg8w3yE1fahKlWp1l15034E1Nqg/fk1dkU9wYTApgnzGsFgCSZgZjhCwZKpsxseDo
 u3O7IkSEQgyXSBUkxU36th6O+6oXkyotHOmRBp96K547u6wyFTb/AaHgdF5rZ/D5Pbto
 ay+LPUBK7ndpKAUEnaHfbUYWOuGwrkUPSy5SW1Wm2xdT3AvYlMkHqB1Ch7aLsvSbsEdh
 W7LpnI+O5wUdNn/6C7L+uJgjh0zegwDqEnKf97oIJt9Kzt9/ShDWEziskqJLZBVSKlHL
 IszXf3NggjV+9cjTkL8eObNLa7ck5Lw2qsxYCwJI93bdBU7el5sQjQUfk553LwDfAZW5 8Q== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2049.outbound.protection.outlook.com [104.47.51.49])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3mhb73cass-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Dec 2022 01:23:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YvVnun3Dm0i0bXQk6PgZTlzV0USTAiP9Ez03WnfIonyTxycJKdqUlUlm04s3LyDctRL79Hn5vVA2X2WBnIvLYoHokPGgLYAOtZvLHLNNvY4uFE92haf2Ms7bbHBPqo2Mm58MVQxzar72NzHt/HKy7H+e/P10El9zk+bHN5z0bKjLcKn9W94ttHFFT8tzCvmH+eCOOB5agZK/kKEMmH66oIqlLZ/P+U1m7r26vygqItzMLMklmt+Eo6bMipuJu8G00w03BezHj3rzVc6xh3LzfaVvAc1KyUm1y/v/t0l1xaQYRzgLBkngQ3MwMbh1C4q9GQzZkXk9yUbgxCmfJFBRZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pcQH8X547k3nlGK9ObhgRzwVwYyPFrFd8MepKzGMntw=;
 b=cGSaw0WefU1hKu0l2mrbbNabEuPpR43BX/UZTD6U8IU+Khj4tVSD5JAgv1PS9JCvN1GLwQ46VniNuRZHxQOqCB3pEdc+v7vRH7P40JF2kR92bXVXjXlppK3pWw1OgUbB/JAyuwX9gi2lYV+uDeD3JhrYDbTOuffJHM6+VXlWW1PjEDixnx9rts+ogL6px8yW6jK3h2SG8SaMZNkEZRYDloItlWotk9bzo17SpjGtwghHBmMl9syTkL/poQb+tzDfqmsrmIGPoXZNBFr+Cv2E97rO/EYoHKzYMeQ3MihXKjmCwN5S4Fbt3EvTRX7/VVqAqLKXA8cWrsnH4LMdPUDEuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pcQH8X547k3nlGK9ObhgRzwVwYyPFrFd8MepKzGMntw=;
 b=ejzu+SIFiJiwLN+stFGGl+AKfDEnp82TqPrd3lCwxiEb8wChylETSntriUfX+2lfrvxxwEMav7txZCd+BjIC56b4q8eiUgwiLTiNXHVzBzked4L+3DXmHF/TQac82hXy5e3Sg3in+LZiKvv6Ib+ogKs++WU1epnZkvZ60JspMmc=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by SJ0PR07MB9274.namprd07.prod.outlook.com (2603:10b6:a03:409::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 09:23:14 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::f36d:8292:963:59c6]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::f36d:8292:963:59c6%4]) with mapi id 15.20.5924.016; Thu, 22 Dec 2022
 09:23:14 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <hzpeterchen@gmail.com>
CC:     "peter.chen@kernel.org" <peter.chen@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>,
        "rogerq@kernel.org" <rogerq@kernel.org>,
        "a-govindraju@ti.com" <a-govindraju@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdns3: remove fetched trb from cache before
 dequeuing
Thread-Topic: [PATCH] usb: cdns3: remove fetched trb from cache before
 dequeuing
Thread-Index: AQHY+Nk1O9kuBWtXZk65xRZeSi7JF65DBooAgAAAr4CANtQm8A==
Date:   Thu, 22 Dec 2022 09:23:14 +0000
Message-ID: <BYAPR07MB5381EB87B6C0446CB2160413DDE89@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20221115100039.441295-1-pawell@cadence.com>
 <CAL411-o4BETLPd-V_4yR6foXbES=72-P4tq-fQ_W_p0P_3ZqEw@mail.gmail.com>
 <BYAPR07MB5381AE961B59046ECB615C65DD069@BYAPR07MB5381.namprd07.prod.outlook.com>
In-Reply-To: <BYAPR07MB5381AE961B59046ECB615C65DD069@BYAPR07MB5381.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNDBhYTA1ZjgtODFkYS0xMWVkLWE4NTQtMDBiZTQzMTQxNTFlXGFtZS10ZXN0XDQwYWEwNWZhLTgxZGEtMTFlZC1hODU0LTAwYmU0MzE0MTUxZWJvZHkudHh0IiBzej0iMzY1NSIgdD0iMTMzMTYxNzQ1OTE2MTc3NDMxIiBoPSJWNy9vL0dKVE9OWGpnYjA5YWdEc3daSUZ3TXM9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|SJ0PR07MB9274:EE_
x-ms-office365-filtering-correlation-id: f9234ea2-463f-42e2-d48a-08dae3fe2707
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IxmeI4h/DnCvcqjrHg5ANF25S5BQ6+fxLfEul6IVyzS3e06jUSK/HIO+r5kSXYABMdYcXXt5NyMDsJtLS1gJ6uopXM76vp9FtSBon5S+gijDzwrkJyFx3gPoO+8caZ3zcGlV6cgPrvfdwgsd0+MwKqg4EnsKCKYRAOHix44ZJkyOm8fwBFHA3k1oF4TwWvcWJdPH8l8iaXvsGSguqZ4Ws8igCthCgaGUvWavz2hdlG/6AM65LC9aIOYTJ1pYVHQsOEStEBeecQ80Q0kVQscXZFFByluTJl9eyfPLhIGatUCKrCOy/llw1skADOHiplmOHXu40XE0Pm+39+N9Qrg0miqwgs8haPIsxlBsLwopWfvBoO6IH1VjwFBPicIirlpeTCghA2vtHYxfEMay16K1hvd5jG2swEQMQpY1q0EqOHTKlztcIzrBuFQnZSUXknnNSYFi4pxVbZ7E6Ixvfy/LMgszMkQ/VLt6r4ynvxbwJDEs9wohae6dnW874eacC1uYDartX2X/eGOWYT9FqBtQ0k+P9e6+i5PtPUhR/b8TeE69dKET2niVmyN2UVgissjZnblrAWWVWOXSdJV8xXfJ1FMZTWn254nAswAjpD7XXyrmbT+BkHFiy4owIvBK1KHssOVQsCRiNLVFA5IYQwWObjp98d3SPka6iNKvbXWb2KH0OUk1VOD2yfrR8a9/Vy+3pvv+vgc4Mt+RHPt64CE1Rg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(36092001)(451199015)(33656002)(2906002)(38070700005)(38100700002)(122000001)(5660300002)(41300700001)(8936002)(52536014)(86362001)(83380400001)(66446008)(66476007)(64756008)(54906003)(6916009)(71200400001)(66556008)(8676002)(4326008)(316002)(478600001)(7696005)(6506007)(55016003)(66946007)(186003)(9686003)(76116006)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0Z3c1BTWUhMdmd1U3dhbEhZUzlsMWNRUTBZZGFZRFcwUG9STWE3NHV6bmZX?=
 =?utf-8?B?OHJkWTJFSkJ5ZTEvbTkxSHEwVm1sY2t2Y1hRMWswbVpCcC9Pc01aL1BVcGNF?=
 =?utf-8?B?RjNyc0c5dkxJQ1BSQzVhcEk2endybCtQVmFPSjRBUFRLdzFsTEFUa3M3bG0y?=
 =?utf-8?B?ZGdtcnk0eU8zQWtmb0pvVllCZWIzTEF6dFpZTDlBT0dHd0ZwZkxVRHUwYVp1?=
 =?utf-8?B?NGxBWWZIWU12N0VOZjhQSDdrNTcweWdGTWpJMUc1UGtzbUxpT1FaZTIrUnhZ?=
 =?utf-8?B?T0J5ekNOdlV0NXdmamJwWE9mbVFKVTVJTTI4N1dFVmZzOUdGVzRNU2lDUno5?=
 =?utf-8?B?U0Z2TXhFdHIxQno4MnlZSnBwcFNzOVlvWDYva29DT2RSRXlBL01BSjNLN0xk?=
 =?utf-8?B?aG4wbk9hV0xRM2Y3eFkrQ3diU2hKVGtac1JnSHBLaFNQclp3R1FJZER0eUVs?=
 =?utf-8?B?bTlrUEJ1ZHhBQW9yVDcrR3VMeTRDaFdNTDQ1OHZKak9CREZ4WWgwbTQ4eDAw?=
 =?utf-8?B?WVpTNVlncEZHaTJEWERpWHBkbU1RVzZaMVZYQmxRbmlhN3gwMGFRa2tDNFNG?=
 =?utf-8?B?QllScFl0N0F3TFhLUlYyUU0yV1l3cUFoSGRsTTlaQWtuQ0dOZmZ2TjM0ajZ3?=
 =?utf-8?B?enFBTEI3WHdCTEd6YVo5bG1idkFKd3hmT1YrcElJdHVxRndaTSt5TFdxRTk3?=
 =?utf-8?B?Rm91RjEvd240SW5RSEVQMzZhTTdRVWplQ1oxb0ROaFZ3cVQ5UVViVVFTQiti?=
 =?utf-8?B?T3VIR0RCRUhKT2dOUWsyc0JmMkFGVnlSalpPblhPcTdSZ1U3dDhuOGxuNmZF?=
 =?utf-8?B?SnBBOTEwNHVxVjRwVGVrVUg3SnF6azVORThVQWNDK2xXQ3FRUEdsbjBWTFFX?=
 =?utf-8?B?Y0lwUEEzR0xKakdMcFlxVUh1b000bU5waFZ4K1VaSnBZZU4wQzNqZXRhMFc0?=
 =?utf-8?B?VGFHakkzQmsvNUl1UmZ2NUdDYnlDRGY4ZXpBVmVnOHZlczliMDRMVWFOVEdM?=
 =?utf-8?B?OEF1SFF2bXUzZnY4dmNlekhUdnlnOW4zVXB5SG9sdXlKcHdxL2FQUnQ2dlln?=
 =?utf-8?B?L1BnWG1IeFJDRStDVHJ5M1V4S2VQMUhtUUVlOW85MStRSGNma2t6T3B3Z2dL?=
 =?utf-8?B?b2F0YjJmWTIwc1hBS1BJMUtnM0dwQUJPU3NkcDlLck8zeVkybjNmUFFJY040?=
 =?utf-8?B?RzNMV1k3K1YzY01QOFpHZVNYLzg1OEo4L2N1VndjSHB3M0pQUEh6b1Q0ZFBP?=
 =?utf-8?B?Wk53OExFckVJWWlRVVJySkg3UjJNTDA2ZEZpQVY1MjFwUld4MXpRWStmcm5T?=
 =?utf-8?B?cmRVbkFBQjA5dFFqclRGUGkrRzNycHlmWDNPZkpMVkE2ODFOdkpmcjgvU2Z6?=
 =?utf-8?B?VDVEZ296STRMdjlxSnpLYnlVelZnZk9haTN4VHlDTG9YUDZhSVBOaFV4VkFJ?=
 =?utf-8?B?SlFGcEZzVnNKRG1sTnVmQUp0dkEzS28zYml4NHp4TUNaQ21hdVZCVVpXSjQ4?=
 =?utf-8?B?ai8yL2YxcnM4ZW9FRWZOU1VTWGFQbHQrK3RNSlJYSndKQzVvMTc3SVNRUkpr?=
 =?utf-8?B?NG9kdkhtMUpXTW5Hd0FqVStOQzVmNGcwb1Z0N3RCR3EwTXozTFF1NUtYQkdD?=
 =?utf-8?B?RGNqbytIaWsxZU1JV3dXd090KzE1NjZHTzhqNjJBVVBYSDVqYU9CR3dubGU2?=
 =?utf-8?B?YXV5MWU5Z1IwejBTRTY5VFp6eHhMb0RtL0J4SmhndkxUNGFVN3ZuNEYxYkRy?=
 =?utf-8?B?SWFIc1ZrU1BxU2pnd2p5cjFXWEx1WTJHZk9jbEQ5anMvamZOSzExa3RpVmxt?=
 =?utf-8?B?MVYzdmY0NVF6WTNWQ041UTAzenZaTTVPeFRqTENZaDN3SFZlQmlxMnAyUnAr?=
 =?utf-8?B?NElHRlN0VW1NRGc4S0pacDE3U0M0bzN0K1RzWVNiczR2enRKUDZwR3pXQ3lN?=
 =?utf-8?B?aUFWK292TElBMHZoVFk2VXVDWFJWR09aRjlFVEVGTzAyR29OVU1CRHNPeVBP?=
 =?utf-8?B?SHdQMW1vV2g4N1FuVGZzS1F6OTJkbVpDcm1laEhXWVQ3Rkw4VHhuVTNKMUNl?=
 =?utf-8?B?WnNTSHdPRnFiTnR4QmZxbVd5U2lGeXpLTXBCeXEraUVSRjBPUlJCWCt6Z2tW?=
 =?utf-8?B?cjJjc2F5ajJ6MjFYMnZzVnY4TklKUTc4SVNQVlNNUlJyOFZ1cmgyeU5pVlFn?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9234ea2-463f-42e2-d48a-08dae3fe2707
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2022 09:23:14.1900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xiiU+t2PotyMmH+RGdTcqPiepGx7RBKky1ccFrgRudILtsxDwfRIR/kVMcBoiAx2WFuHDtYgfqTYpzsTUaxrR7FK6Pp1CHW0pN8SQogVTLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR07MB9274
X-Proofpoint-GUID: jcawFUyAQXY5KI3K6HmByTjpmfW5ahEq
X-Proofpoint-ORIG-GUID: jcawFUyAQXY5KI3K6HmByTjpmfW5ahEq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_03,2022-12-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=619 spamscore=0 adultscore=0 malwarescore=0
 impostorscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2212220082
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgUGV0ZXIsDQoNCldoYXQgYWJvdXQgdGhpcyBwYXRjaD8NCkNhbiB5b3UgcHVzaCBpdD8NCg0K
UmVnYXJkcywNClBhd2VsDQoNCj4+T24gVHVlLCBOb3YgMTUsIDIwMjIgYXQgNjowMSBQTSBQYXdl
bCBMYXN6Y3phayA8cGF3ZWxsQGNhZGVuY2UuY29tPg0KPj53cm90ZToNCj4+Pg0KPj4+IEFmdGVy
IGRvb3JiZWxsIERNQSBmZXRjaGVzIHRoZSBUUkIuIElmIGR1cmluZyBkZXF1ZXVpbmcgcmVxdWVz
dA0KPj4+IGRyaXZlciBjaGFuZ2VzIE5PUk1BTCBUUkIgdG8gTElOSyBUUkIgYnV0IGRvZXNuJ3Qg
ZGVsZXRlIGl0IGZyb20NCj4+PiBjb250cm9sbGVyIGNhY2hlIHRoZW4gY29udHJvbGxlciB3aWxs
IGhhbmRsZSBjYWNoZWQgVFJCIGFuZCBwYWNrZXQgY2FuIGJlDQo+bG9zdC4NCj4+Pg0KPj4+IFRo
ZSBleGFtcGxlIHNjZW5hcmlvIGZvciB0aGlzIGlzc3VlIGxvb2tzIGxpa2U6DQo+Pj4gMS4gcXVl
dWUgcmVxdWVzdCAtIHNldCBkb29yYmVsbA0KPj4+IDIuIGRlcXVldWUgcmVxdWVzdA0KPj4+IDMu
IHNlbmQgT1VUIGRhdGEgcGFja2V0IGZyb20gaG9zdA0KPj4+IDQuIERldmljZSB3aWxsIGFjY2Vw
dCB0aGlzIHBhY2tldCB3aGljaCBpcyB1bmV4cGVjdGVkIDUuIHF1ZXVlIG5ldw0KPj4+IHJlcXVl
c3QgLSBzZXQgZG9vcmJlbGwgNi4gRGV2aWNlIGxvc3QgdGhlIGV4cGVjdGVkIHBhY2tldC4NCj4+
Pg0KPj4+IEJ5IHNldHRpbmcgREZMVVNIIGNvbnRyb2xsZXIgY2xlYXJzIERSRFkgYml0IGFuZCBz
dG9wIERNQSB0cmFuc2Zlci4NCj4+Pg0KPj4+IEZpeGVzOiA3NzMzZjZjMzJlMzYgKCJ1c2I6IGNk
bnMzOiBBZGQgQ2FkZW5jZSBVU0IzIERSRCBEcml2ZXIiKQ0KPj4+IGNjOiA8c3RhYmxlQHZnZXIu
a2VybmVsLm9yZz4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBQYXdlbCBMYXN6Y3phayA8cGF3ZWxsQGNh
ZGVuY2UuY29tPg0KPj4+IC0tLQ0KPj4+ICBkcml2ZXJzL3VzYi9jZG5zMy9jZG5zMy1nYWRnZXQu
YyB8IDEyICsrKysrKysrKysrKw0KPj4+ICAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygr
KQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NkbnMzL2NkbnMzLWdhZGdldC5j
DQo+Pj4gYi9kcml2ZXJzL3VzYi9jZG5zMy9jZG5zMy1nYWRnZXQuYw0KPj4+IGluZGV4IDVhZGNi
MzQ5NzE4Yy4uY2NmYWViY2E2ZmFhIDEwMDY0NA0KPj4+IC0tLSBhL2RyaXZlcnMvdXNiL2NkbnMz
L2NkbnMzLWdhZGdldC5jDQo+Pj4gKysrIGIvZHJpdmVycy91c2IvY2RuczMvY2RuczMtZ2FkZ2V0
LmMNCj4+PiBAQCAtMjYxNCw2ICsyNjE0LDcgQEAgaW50IGNkbnMzX2dhZGdldF9lcF9kZXF1ZXVl
KHN0cnVjdCB1c2JfZXAgKmVwLA0KPj4+ICAgICAgICAgdTggcmVxX29uX2h3X3JpbmcgPSAwOw0K
Pj4+ICAgICAgICAgdW5zaWduZWQgbG9uZyBmbGFnczsNCj4+PiAgICAgICAgIGludCByZXQgPSAw
Ow0KPj4+ICsgICAgICAgaW50IHZhbDsNCj4+Pg0KPj4+ICAgICAgICAgaWYgKCFlcCB8fCAhcmVx
dWVzdCB8fCAhZXAtPmRlc2MpDQo+Pj4gICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0K
Pj4+IEBAIC0yNjQ5LDYgKzI2NTAsMTMgQEAgaW50IGNkbnMzX2dhZGdldF9lcF9kZXF1ZXVlKHN0
cnVjdCB1c2JfZXANCj4+KmVwLA0KPj4+DQo+Pj4gICAgICAgICAvKiBVcGRhdGUgcmluZyBvbmx5
IGlmIHJlbW92ZWQgcmVxdWVzdCBpcyBvbiBwZW5kaW5nX3JlcV9saXN0IGxpc3QgKi8NCj4+PiAg
ICAgICAgIGlmIChyZXFfb25faHdfcmluZyAmJiBsaW5rX3RyYikgew0KPj4+ICsgICAgICAgICAg
ICAgICAvKiBTdG9wIERNQSAqLw0KPj4+ICsgICAgICAgICAgICAgICB3cml0ZWwoRVBfQ01EX0RG
TFVTSCwgJnByaXZfZGV2LT5yZWdzLT5lcF9jbWQpOw0KPj4+ICsNCj4+PiArICAgICAgICAgICAg
ICAgLyogd2FpdCBmb3IgREZMVVNIIGNsZWFyZWQgKi8NCj4+PiArICAgICAgICAgICAgICAgcmVh
ZGxfcG9sbF90aW1lb3V0X2F0b21pYygmcHJpdl9kZXYtPnJlZ3MtPmVwX2NtZCwgdmFsLA0KPj4+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICEodmFsICYgRVBfQ01E
X0RGTFVTSCksIDEsDQo+Pj4gKyAxMDAwKTsNCj4+PiArDQo+Pj4gICAgICAgICAgICAgICAgIGxp
bmtfdHJiLT5idWZmZXIgPSBjcHVfdG9fbGUzMihUUkJfQlVGRkVSKHByaXZfZXAtDQo+Pj50cmJf
cG9vbF9kbWEgKw0KPj4+ICAgICAgICAgICAgICAgICAgICAgICAgICgocHJpdl9yZXEtPmVuZF90
cmIgKyAxKSAqIFRSQl9TSVpFKSkpOw0KPj4+ICAgICAgICAgICAgICAgICBsaW5rX3RyYi0+Y29u
dHJvbCA9DQo+Pj4gY3B1X3RvX2xlMzIoKGxlMzJfdG9fY3B1KGxpbmtfdHJiLT5jb250cm9sKSAm
IFRSQl9DWUNMRSkgfCBAQCAtMjY2MCw2DQo+Pj4gKzI2NjgsMTAgQEAgaW50IGNkbnMzX2dhZGdl
dF9lcF9kZXF1ZXVlKHN0cnVjdCB1c2JfZXAgKmVwLA0KPj4+DQo+Pj4gICAgICAgICBjZG5zM19n
YWRnZXRfZ2l2ZWJhY2socHJpdl9lcCwgcHJpdl9yZXEsIC1FQ09OTlJFU0VUKTsNCj4+Pg0KPj4+
ICsgICAgICAgcmVxID0gY2RuczNfbmV4dF9yZXF1ZXN0KCZwcml2X2VwLT5wZW5kaW5nX3JlcV9s
aXN0KTsNCj4+PiArICAgICAgIGlmIChyZXEpDQo+Pj4gKyAgICAgICAgICAgICAgIGNkbnMzX3Jl
YXJtX3RyYW5zZmVyKHByaXZfZXAsIDEpOw0KPj4+ICsNCj4+DQo+PldoeSB0aGUgYWJvdmUgY2hh
bmdlcyBhcmUgbmVlZGVkPw0KPj4NCj4NCj5EbyB5b3UgbWVhbiB0aGUgbGFzdCBsaW5lIG9yIHRo
aXMgcGF0Y2g/DQo+DQo+TGFzdCBsaW5lOg0KPkRNQSBpcyBzdG9wcGVkLCBzbyBkcml2ZXIgYXJt
IHRoZSBxdWV1ZWQgdHJhbnNmZXJzDQo+DQo+SWYgeW91IG1lYW5zIHRoaXMgcGF0Y2g6DQo+SXNz
dWUgd2FzIGRldGVjdGVkIGJ5IGN1c3RvbWVyIHRlc3QuIEkgZG9u4oCZdCBrbm93IHdoZXRoZXIg
aXQgd2FzIG9ubHkgdGVzdCBvcg0KPnRoZSByZWFsIGFwcGxpY2F0aW9uLg0KPg0KPlRoZSBwcm9i
bGVtIGhhcHBlbnMgYmVjYXVzZSB1c2VyIGFwcGxpY2F0aW9uIHF1ZXVlZCB0aGUgdHJhbnNmZXIg
KGVuZHBvaW50DQo+aGFzIGJlZW4gYXJtZWQpLCBzbyBjb250cm9sbGVyIGZldGNoIHRoZSBUUkIu
DQo+V2hlbiB1c2VyIGFwcGxpY2F0aW9uIHJlbW92ZWQgdGhpcyByZXF1ZXN0IHRoZSBUUkIgd2Fz
IHN0aWxsIHByb2Nlc3NlZCBieQ0KPmNvbnRyb2xsZXIuIElmIGF0IHRoYXQgdGltZSB0aGUgaG9z
dCB3aWxsIHNlbmQgZGF0YSBwYWNrZXQgdGhlbiBjb250cm9sbGVyIHdpbGwNCj5hY2NlcHQgaXQs
IGJ1dCBpdCBzaG91bGRuJ3QgYmVjYXVzZSB0aGUgdXNiX3JlcXVlc3QgYXNzb2NpYXRlZCB3aXRo
IFRSQiBjYWNoZWQNCj5ieSBjb250cm9sbGVyIHdhcyByZW1vdmVkLg0KPlRvIGZvcmNlIHRoZSBj
b250cm9sbGVyIHRvIGRyb3AgdGhpcyBUUkIgREZMVVNIIGlzIHJlcXVpcmVkLg0KPg0KPlBhd2Vs
DQo+DQo+Pg0KPj4+ICBub3RfZm91bmQ6DQo+Pj4gICAgICAgICBzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZwcml2X2Rldi0+bG9jaywgZmxhZ3MpOw0KPj4+ICAgICAgICAgcmV0dXJuIHJldDsNCj4+
PiAtLQ0KPj4+IDIuMjUuMQ0KPj4+DQo=
