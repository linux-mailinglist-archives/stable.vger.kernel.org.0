Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4661866B90C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 09:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjAPI2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 03:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjAPI2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 03:28:41 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E6210AA6;
        Mon, 16 Jan 2023 00:28:38 -0800 (PST)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30G8KWgd030141;
        Mon, 16 Jan 2023 00:28:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=I9SadkGut8FjSTe6n4ICh5eUPvxJ45WGYTPaSQca8vA=;
 b=NKpM2Jk1oJjnVswLpzFF+hOcNMjEc5AezGeg0G81cI75KwHkY0IUSaG5Z9HeQlT+TYh3
 tfWGTTFdqA1Nzp3fggPS+ORoJErH/Q0Ye934hDjf44LuXhQhtFHCArYdjLkrSx45Gy0y
 MmibOjk42K1nzbecYb+HsHRcNKXEusFTYWxEKchVMaZQFsn6LdMdzqaz6Kd0k5IDAcV3
 cXGa3y1h1EtaX3+M23ugALDFS4/cf/qjQdjJLmhAouKyXAw2DUDgGy0lhbUFx/YYYafA
 5w4BdBO2mFB9/fWIj3ywBqCpg9idXnIyNxA53mkD1cjHPjfQYDQ0VuhS0wS8pppY1M+h RA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3n3rv5xtf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 00:28:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LyNO1oa+qg0ZF+XvAVV0qyx+toFkUJKTJoMW7ikgFhzy7h8Y5mUAg4D+ZGnPT5sy66ipTgylyEH1BnJxaZPXJmf/OnhloxYEg9QVTnCtHEEsMIDEdvYOBg3vXfXFPwtwzWriLIjRWstjokpzmo79cuaqcuUUId1xwnLLdrp2LOVAv4E3aHNpKMYatyiOc4/O+Yc1iNnZhBDM3SXAo0jb2hEQEUyQynNnycrv3KuJlfC5iX9cvT5Vjqj7r/z89w/1uFoba965DSQ5YnwiDrENIWWh3nJWuhIB6zpTskYU7Z9cQrlt+jSOhKOhx+QC9Ws1FflFL7TVyCimyEUpuhVmMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9SadkGut8FjSTe6n4ICh5eUPvxJ45WGYTPaSQca8vA=;
 b=MRzSCfwEPIAnYxlEIP3VCg7UC6pgZoj32Wsn7mdmQnmo9pA9l8PPeB94HgcJ4z5Ayt+4i485ccp0htzt5FyqgS0Ri+gvJZ8dyqqdpt0SQFbiWUVrwj85HJDAREqcmE0bJq1ckYxumOSx0AT71TQUhAXLCkZjIjKA2ibMlGO8S++osNwv+cyt5loufguB5PnSJxAaKVVyOWHQ0m4gFtQ6MXG+vcFdyXjSiFfAhZ6OqTYZd3CLNRV4cUKw5CgF+3DxAprUbJURZyBlUnB93Mt/R3d/VP9QFLo2nGFRbIdtbEObDcZakJPz3BC3WiyS4mQu2nuXgc/zjKgwjoA1Ow2vAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9SadkGut8FjSTe6n4ICh5eUPvxJ45WGYTPaSQca8vA=;
 b=damWJCdm9FBRXss5Z/kvM6fxW8gXMfSh20C1uzprp2rsbLzeeSWbmpuYE3i7xrjLYPSkn9Fa8H8ffpuQwZElD9dyRPXfk+niVMQODTkIv7q0AI47l+sCE7nEgSYIZas1+sh+c3aXF5dXG67QT/fZcqUAFIwh9OcR2BjfkwTXR60=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by BYAPR07MB5304.namprd07.prod.outlook.com (2603:10b6:a03:6c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 08:28:21 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::f36d:8292:963:59c6]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::f36d:8292:963:59c6%4]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 08:28:20 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     Peter Chen <hzpeterchen@gmail.com>,
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
Thread-Index: AQHY+Nk1O9kuBWtXZk65xRZeSi7JF65DBooAgAAAr4CASApYAIAKzONggABV2YCACuHUEA==
Date:   Mon, 16 Jan 2023 08:28:20 +0000
Message-ID: <BYAPR07MB53819D916AFB3CE7E41E60EADDC19@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20221115100039.441295-1-pawell@cadence.com>
 <CAL411-o4BETLPd-V_4yR6foXbES=72-P4tq-fQ_W_p0P_3ZqEw@mail.gmail.com>
 <BYAPR07MB5381AE961B59046ECB615C65DD069@BYAPR07MB5381.namprd07.prod.outlook.com>
 <CAL411-rFz5Dde4F_uWbksxJG2uqbD7VsU2GG1JQ0mU3LpbeoUA@mail.gmail.com>
 <BYAPR07MB5381157D62415BFFBD328C5ADDFE9@BYAPR07MB5381.namprd07.prod.outlook.com>
 <20230109101321.GA94204@nchen-desktop>
In-Reply-To: <20230109101321.GA94204@nchen-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctYjllNzVhMGYtOTU3Ny0xMWVkLWE4NTgtMDBiZTQzMTQxNTFlXGFtZS10ZXN0XGI5ZTc1YTExLTk1NzctMTFlZC1hODU4LTAwYmU0MzE0MTUxZWJvZHkudHh0IiBzej0iNTI2NiIgdD0iMTMzMTgzMzEyOTgxMDM2NjAzIiBoPSJCVjFlcHNDbXRsay8zYkNZVGN3MkJacVRGSTg9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|BYAPR07MB5304:EE_
x-ms-office365-filtering-correlation-id: 9575931d-dc6d-489f-921c-08daf79ba050
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: er6lWVlvpnvjMK2dIS4BYI+0syIJ3lBj1yUQjNKl5Taqenc0Ibdtc8/JWwyfL+dWkBx3Z7jHnBD8cIRe58eQr1S4Yeq6aSKxR5W6Lhit8OWgiJwWu3zz/TE/llpqy8//xPv2wgig1OTL6NM5nZAssV4Udp2q9FvhCVLOQQwxiyR9mKRzGn56bQpxIJ0i5Jl9upRuCvTKJczuecpmlCE5/qXiduq+Asvi4u25ufouiP2wGRu+TDhuMqHmjD/sInvHS2QgUuP4tyRuGwIizbnDP5FuXVRnqwG0BUpS4wMxkZH+w4Lcvdt6XUni64NKTrHunF7ZzZ2nRtAXBWsT7r6jjxe2AUG3fUoq0iUUtF9HR4GJGBwW+xEYrotunLYGmy6Td02ece75CFwgFhTfK+lO2IeOp3QJe+ZMOhN2WoKtc1hLZezClN6abx0yifkQtAE5oCMY11bxoumBYtx2I3YQ5zt5qauiqfGa7Pwx+NZyAyMJ5pn1HSPcpAxFiBEm9Zhf2UPdRbi12tLLH7I1904ciJUwwkBQsfAiLPP8jDc71t6v3ccASDgBM4RwuRjZ31+keFFJJiaZZj3WxPdr2vVXYi3zgQY+AAAN0B6gUNesnnwc5yYm4/x2d1ik3VeETuy4bgfJ7f/k8BBb2Yw/TIpUkj/jR1AzEcCi7q0wLefXxQsoHJ8Ld0Nfyn7/TMooUO3ZDe9LkL+EWTMtWQftfsrfzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(36092001)(451199015)(38100700002)(86362001)(38070700005)(8676002)(8936002)(52536014)(66556008)(55016003)(4326008)(64756008)(66476007)(66446008)(76116006)(66946007)(6916009)(2906002)(5660300002)(83380400001)(122000001)(33656002)(478600001)(7696005)(71200400001)(54906003)(316002)(41300700001)(9686003)(26005)(186003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3BkbDAyOWVSbmZRVkx6M1NLS09OdDVaZXo2UHMyQ2NDSk92c0kxWnBYM1RH?=
 =?utf-8?B?TjYvSG5WeWhjb3p4YVZyb1g3Ny9jbTZ5MFRTTzlvUm16YmM0VHVPaHY0OGx2?=
 =?utf-8?B?cEVESkpGbytIQlQ1L0I3TC93bTZmcjFFcG1yT01zeXJvd2p5ME00bTJJRHB0?=
 =?utf-8?B?a1lEUU84YThhWUFXS29FbFpBb0dKNUhqKy9yZDVKWXpWdm9DYVEyc1lCeWZo?=
 =?utf-8?B?R09EV2tjOS9sY2RlVnF0Z1hGRkpNbEJwSkdCTUNvVkZvOUFyTTg4NEVJanhh?=
 =?utf-8?B?MWluK1I5cDI5eEh3NUQrY2pUUFBKOEwyTlhWRzd2QVljM1pzVDRLMFNaTi9L?=
 =?utf-8?B?em1CeHpPQ0l6emdEY3lZRjBTc1BYcXJsNVRoSnpWUWMzdlpGSHJqMHBPS1NL?=
 =?utf-8?B?VGpQUW00elgvZE4xd1hiMjZNb0lBWHpXbWpuaURhSTBkNXZEb2tnUFlvNk41?=
 =?utf-8?B?dnJrQS9HT3liOVFvK1N5VjNhU1crdmdYcWhNVXpRSmozWWtlVzhHbkVCc2V0?=
 =?utf-8?B?UXFhejBQK0lrN1c3VzNTa0N1MjFRKzV1eStVcG02SjcxMEt1Mld0cmM0dERU?=
 =?utf-8?B?U2FzOTVMejNsZUxUaitIUTBNK2dwejkydnMvRGgvNGd0azJQQVBMcEVUYkI4?=
 =?utf-8?B?bE54cmptOGhFRXpqcmlnSGozU0VIVU1QOEVqeHY5dHkrNFNrSTdBNHZzaUFy?=
 =?utf-8?B?ZjBjSGFyZm5qRXdMbCs3cXlNVmFDU2IrUldsZ0hlR2pobWVHM1RJU0RUS0dw?=
 =?utf-8?B?UVgxY3hUaXFEMzRuM1ZGdlFoeHFNTUE4d09HZXgraEpIbFVhM1hvN3IrdnU3?=
 =?utf-8?B?MDFpYW1HSXVZYURYUWJBWVNIUlVSOE5JKzNRWittN0pUaGo2elJJenRrQ09w?=
 =?utf-8?B?TnU0N3BHL3lKZW5KTzY1c25HK2dTQllTRU43R2xNdCttcHRWZnFBWmxjNVB0?=
 =?utf-8?B?dnpnZ0p5WW9adzcvM00rcjRLTlpCWlN0RjFPOFJrMHZFWGFEVG80L1JXam5Z?=
 =?utf-8?B?RWVGaVB5Z0RVMDBJN1dKMEh4RXdVbnRiYXQwT20wZFI4Y0tUSEJpUWRrRkVP?=
 =?utf-8?B?WFczM3QxN0l4ZUo4ZDV6ZitVdTFsbFZtbVozYStsRkpsT2Z2U0J2ZGY4Ujh5?=
 =?utf-8?B?ZUw3cDJZL0lSWFZYYnlyNTFiU1RUYlhoN0ZhNU9GYW5LZjN6RU9kVTNOU0Ry?=
 =?utf-8?B?UDY3TmJIR1ExY0hFbUNsSTVQeDdENXl6YkQ1a2dPNG1LSjR3dkgybnl3cWtp?=
 =?utf-8?B?L0hIb2hILzB1RFR6UWRjcldOZndpYkliNGlGT0Vub2RYeDJhNWc0enM4WEx5?=
 =?utf-8?B?OElXbzBzUk8yLzJzU2VTR2VaMkhyMnJzeXB6RzlyNjJNbkZyQXFUaHZQekox?=
 =?utf-8?B?ekFMaVplRVZQblRUVkpqZG5nWHN2Q2J1cFFsSC9SY1hSNzYxTzdqTFVnbUNx?=
 =?utf-8?B?SStJWElnV25LdVJ1SXBic3JOdUZ2bitpN0V2R25sQTBZdGFBdm5mZkZtQWlC?=
 =?utf-8?B?alZPVk5LUWcxMmcwUDR5T0hnT0dxY0hwb3dSaUxqRE1LZzY4NnVha1JxY2lt?=
 =?utf-8?B?YWlrUEhkaThQcGxLbVRYajJoNmQzZE94ZThuWTRKbnZhVjJaMU9hcmJUdjlJ?=
 =?utf-8?B?ZDdyZEE1dDlKVnZNY3lVTVhyd21VQ0tTcVp0OGdYdUVlQnZuUk92em5hb1l4?=
 =?utf-8?B?ZWpBdUxSQ01JUEhtcTVNTnZkais1V0lBWmxsWEthMkY2ckkwdk1IOWlqdFJY?=
 =?utf-8?B?SkdZa2UrTUJJSThuSDlRRFZPSzh3UEhsU0dNQ3d5bGNYQ2huWWp0NVpqVWpx?=
 =?utf-8?B?ak1QcXNBd25MdGlCbG5jUnY4WVVVVndQTk5oM3hzTUJHUHJHWTZNSGFjQ2d1?=
 =?utf-8?B?UTYzV291VEEzNmhUWllnV3dIa2VVQmxiWm9rdTN3MnlLREVaT2ZsekxEdzFk?=
 =?utf-8?B?MzEzcUV6c1I3c1prSWlocWdZVlJBRjZEcmNrVmxvb0oyOWtQanVvbVNHNTBV?=
 =?utf-8?B?S0FIMDBJNUJxWVFUcU0wSEIxQWNNMFdvcVNUSjBULzdZUUlTOHpnTXc2eG1G?=
 =?utf-8?B?TnRicGprd0w2WXc3bTl1MERMR1ErSTROVVZXbWJyVGpaTXZZZ2h4ZW11YmFv?=
 =?utf-8?B?YmxzK0NGN3FpMzRvUFlKRm1uK3JEYlg1emR5VUV2c0hWOVRnb3dBeUw2dzQ5?=
 =?utf-8?B?NUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9575931d-dc6d-489f-921c-08daf79ba050
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 08:28:20.7504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uGfVDBUBxjLTMRP1+J+LTBN2Tq+lnxBpKot9JgQyy/fjwrYM0Zroi0JZkfxFOmdSFttdv+Sv3kyi4NuCBc+dzMLAsJfiyl/FnUuaOzykX5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB5304
X-Proofpoint-ORIG-GUID: mr9J8SztWYwyN8WQLQfL7bxS1pgX9cm-
X-Proofpoint-GUID: mr9J8SztWYwyN8WQLQfL7bxS1pgX9cm-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_06,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 suspectscore=0
 bulkscore=0 mlxlogscore=988 mlxscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160061
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pg0KPg0KPk9uIDIzLTAxLTA5IDA1OjM4OjMxLCBQYXdlbCBMYXN6Y3phayB3cm90ZToNCj4+ID4N
Cj4+ID5PbiBUaHUsIE5vdiAxNywgMjAyMiBhdCA4OjI3IFBNIFBhd2VsIExhc3pjemFrIDxwYXdl
bGxAY2FkZW5jZS5jb20+DQo+PiA+d3JvdGU6DQo+PiA+Pg0KPj4gPj4gPg0KPj4gPj4gPk9uIFR1
ZSwgTm92IDE1LCAyMDIyIGF0IDY6MDEgUE0gUGF3ZWwgTGFzemN6YWsNCj4+ID4+ID48cGF3ZWxs
QGNhZGVuY2UuY29tPg0KPj4gPj4gPndyb3RlOg0KPj4gPj4gPj4NCj4+ID4+ID4+IEFmdGVyIGRv
b3JiZWxsIERNQSBmZXRjaGVzIHRoZSBUUkIuIElmIGR1cmluZyBkZXF1ZXVpbmcgcmVxdWVzdA0K
Pj4gPj4gPj4gZHJpdmVyIGNoYW5nZXMgTk9STUFMIFRSQiB0byBMSU5LIFRSQiBidXQgZG9lc24n
dCBkZWxldGUgaXQgZnJvbQ0KPj4gPj4gPj4gY29udHJvbGxlciBjYWNoZSB0aGVuIGNvbnRyb2xs
ZXIgd2lsbCBoYW5kbGUgY2FjaGVkIFRSQiBhbmQNCj4+ID4+ID4+IHBhY2tldCBjYW4gYmUNCj4+
ID5sb3N0Lg0KPj4gPj4gPj4NCj4+ID4+ID4+IFRoZSBleGFtcGxlIHNjZW5hcmlvIGZvciB0aGlz
IGlzc3VlIGxvb2tzIGxpa2U6DQo+PiA+PiA+PiAxLiBxdWV1ZSByZXF1ZXN0IC0gc2V0IGRvb3Ji
ZWxsDQo+PiA+PiA+PiAyLiBkZXF1ZXVlIHJlcXVlc3QNCj4+ID4+ID4+IDMuIHNlbmQgT1VUIGRh
dGEgcGFja2V0IGZyb20gaG9zdCA0LiBEZXZpY2Ugd2lsbCBhY2NlcHQgdGhpcw0KPj4gPj4gPj4g
cGFja2V0IHdoaWNoIGlzIHVuZXhwZWN0ZWQgNS4gcXVldWUgbmV3IHJlcXVlc3QgLSBzZXQgZG9v
cmJlbGwNCj4+ID4+ID4+IDYuIERldmljZSBsb3N0IHRoZSBleHBlY3RlZCBwYWNrZXQuDQo+PiA+
PiA+Pg0KPj4gPj4gPj4gQnkgc2V0dGluZyBERkxVU0ggY29udHJvbGxlciBjbGVhcnMgRFJEWSBi
aXQgYW5kIHN0b3AgRE1BIHRyYW5zZmVyLg0KPj4gPj4gPj4NCj4+ID4+ID4+IEZpeGVzOiA3NzMz
ZjZjMzJlMzYgKCJ1c2I6IGNkbnMzOiBBZGQgQ2FkZW5jZSBVU0IzIERSRCBEcml2ZXIiKQ0KPj4g
Pj4gPj4gY2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPj4gPj4gPj4gU2lnbmVkLW9mZi1i
eTogUGF3ZWwgTGFzemN6YWsgPHBhd2VsbEBjYWRlbmNlLmNvbT4NCj4+ID4+ID4+IC0tLQ0KPj4g
Pj4gPj4gIGRyaXZlcnMvdXNiL2NkbnMzL2NkbnMzLWdhZGdldC5jIHwgMTIgKysrKysrKysrKysr
DQo+PiA+PiA+PiAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykNCj4+ID4+ID4+DQo+
PiA+PiA+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvY2RuczMvY2RuczMtZ2FkZ2V0LmMNCj4+
ID4+ID4+IGIvZHJpdmVycy91c2IvY2RuczMvY2RuczMtZ2FkZ2V0LmMNCj4+ID4+ID4+IGluZGV4
IDVhZGNiMzQ5NzE4Yy4uY2NmYWViY2E2ZmFhIDEwMDY0NA0KPj4gPj4gPj4gLS0tIGEvZHJpdmVy
cy91c2IvY2RuczMvY2RuczMtZ2FkZ2V0LmMNCj4+ID4+ID4+ICsrKyBiL2RyaXZlcnMvdXNiL2Nk
bnMzL2NkbnMzLWdhZGdldC5jDQo+PiA+PiA+PiBAQCAtMjYxNCw2ICsyNjE0LDcgQEAgaW50IGNk
bnMzX2dhZGdldF9lcF9kZXF1ZXVlKHN0cnVjdCB1c2JfZXANCj4+ID4qZXAsDQo+PiA+PiA+PiAg
ICAgICAgIHU4IHJlcV9vbl9od19yaW5nID0gMDsNCj4+ID4+ID4+ICAgICAgICAgdW5zaWduZWQg
bG9uZyBmbGFnczsNCj4+ID4+ID4+ICAgICAgICAgaW50IHJldCA9IDA7DQo+PiA+PiA+PiArICAg
ICAgIGludCB2YWw7DQo+PiA+PiA+Pg0KPj4gPj4gPj4gICAgICAgICBpZiAoIWVwIHx8ICFyZXF1
ZXN0IHx8ICFlcC0+ZGVzYykNCj4+ID4+ID4+ICAgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZB
TDsNCj4+ID4+ID4+IEBAIC0yNjQ5LDYgKzI2NTAsMTMgQEAgaW50IGNkbnMzX2dhZGdldF9lcF9k
ZXF1ZXVlKHN0cnVjdA0KPnVzYl9lcA0KPj4gPj4gPiplcCwNCj4+ID4+ID4+DQo+PiA+PiA+PiAg
ICAgICAgIC8qIFVwZGF0ZSByaW5nIG9ubHkgaWYgcmVtb3ZlZCByZXF1ZXN0IGlzIG9uIHBlbmRp
bmdfcmVxX2xpc3QgbGlzdA0KPiovDQo+PiA+PiA+PiAgICAgICAgIGlmIChyZXFfb25faHdfcmlu
ZyAmJiBsaW5rX3RyYikgew0KPj4gPj4gPj4gKyAgICAgICAgICAgICAgIC8qIFN0b3AgRE1BICov
DQo+PiA+PiA+PiArICAgICAgICAgICAgICAgd3JpdGVsKEVQX0NNRF9ERkxVU0gsICZwcml2X2Rl
di0+cmVncy0+ZXBfY21kKTsNCj4+ID4+ID4+ICsNCj4+ID4+ID4+ICsgICAgICAgICAgICAgICAv
KiB3YWl0IGZvciBERkxVU0ggY2xlYXJlZCAqLw0KPj4gPj4gPj4gKyAgICAgICAgICAgICAgIHJl
YWRsX3BvbGxfdGltZW91dF9hdG9taWMoJnByaXZfZGV2LT5yZWdzLT5lcF9jbWQsIHZhbCwNCj4+
ID4+ID4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICEodmFsICYN
Cj4+ID4+ID4+ICsgRVBfQ01EX0RGTFVTSCksIDEsIDEwMDApOw0KPj4gPj4gPj4gKw0KPj4gPj4g
Pj4gICAgICAgICAgICAgICAgIGxpbmtfdHJiLT5idWZmZXIgPQ0KPj4gPj4gPj5jcHVfdG9fbGUz
MihUUkJfQlVGRkVSKHByaXZfZXAtIHRyYl9wb29sX2RtYSArDQo+PiA+PiA+PiAgICAgICAgICAg
ICAgICAgICAgICAgICAoKHByaXZfcmVxLT5lbmRfdHJiICsgMSkgKiBUUkJfU0laRSkpKTsNCj4+
ID4+ID4+ICAgICAgICAgICAgICAgICBsaW5rX3RyYi0+Y29udHJvbCA9DQo+PiA+PiA+PiBjcHVf
dG9fbGUzMigobGUzMl90b19jcHUobGlua190cmItPmNvbnRyb2wpICYgVFJCX0NZQ0xFKSB8IEBA
DQo+PiA+PiA+Pi0yNjYwLDYNCj4+ID4+ID4+ICsyNjY4LDEwIEBAIGludCBjZG5zM19nYWRnZXRf
ZXBfZGVxdWV1ZShzdHJ1Y3QgdXNiX2VwICplcCwNCj4+ID4+ID4+DQo+PiA+PiA+PiAgICAgICAg
IGNkbnMzX2dhZGdldF9naXZlYmFjayhwcml2X2VwLCBwcml2X3JlcSwgLUVDT05OUkVTRVQpOw0K
Pj4gPj4gPj4NCj4+ID4+ID4+ICsgICAgICAgcmVxID0gY2RuczNfbmV4dF9yZXF1ZXN0KCZwcml2
X2VwLT5wZW5kaW5nX3JlcV9saXN0KTsNCj4+ID4+ID4+ICsgICAgICAgaWYgKHJlcSkNCj4+ID4+
ID4+ICsgICAgICAgICAgICAgICBjZG5zM19yZWFybV90cmFuc2Zlcihwcml2X2VwLCAxKTsNCj4+
ID4+ID4+ICsNCj4+ID4+ID4NCj4+ID4+ID5XaHkgdGhlIGFib3ZlIGNoYW5nZXMgYXJlIG5lZWRl
ZD8NCj4+ID4+ID4NCj4+ID4+DQo+PiA+PiBEbyB5b3UgbWVhbiB0aGUgbGFzdCBsaW5lIG9yIHRo
aXMgcGF0Y2g/DQo+PiA+Pg0KPj4gPj4gTGFzdCBsaW5lOg0KPj4gPj4gRE1BIGlzIHN0b3BwZWQs
IHNvIGRyaXZlciBhcm0gdGhlIHF1ZXVlZCB0cmFuc2ZlcnMNCj4+ID4+DQo+PiA+DQo+PiA+U29y
cnksIEkgaGF2ZSBiZWVuIHZlcnkgYnVzeSByZWNlbnRseSwgc28gdGhlIHJlc3BvbnNlIG1heSBu
b3QgYmUgaW4gdGltZS4NCj4+ID5JIG1lYW4gd2h5IGl0IG5lZWRzIHRvIHJlLWFybSB0aGUgdHJh
bnNmZXJzIGFmdGVyIERNQSBpcyBzdG9wcGVkPw0KPj4NCj4+IEJlY2F1c2UgZHJpdmVyIGNhbiBo
YXZlIHF1ZXVlZCBtb3JlIHRyYW5zZmVycy4gT25seSBvbmUgb2YgdGhlbSBhcmUNCj4+IGRlcXVl
dWVkLiBJbiB0aGUgdmFzdCBtYWpvcml0eSBvZiB0aGUgcmVzdCByZXF1ZXN0IHdpbGwgYmUgcmVt
b3ZlZCBpbg0KPj4gdGhlIG5leHQgc3RlcHMsIGJ1dCB0aGVyZSBjYW4gYmUgY2FzZSBpbiB3aGlj
aCB3ZSBoYXZlIHF1ZXVlZCBlLmcuIDEwDQo+PiB1c2IgcmVxdWVzdHMgYW5kIG9ubHkgb25lIG9m
IHRoZW0gd2lsbCBiZSByZW1vdmVkLiBJbiBzdWNoIGNhc2UgdGhlIGRyaXZlcg0KPmNhbiBzdHVj
ay4NCj4+IFRvIGF2b2lkIHRoaXMgZHJpdmVyLCByZWFybSB0aGUgZW5kcG9pbnQgaWYgdGhlcmUg
YXJlIG90aGVyIHRyYW5zZmVyDQo+PiBpbiB0cmFuc2ZlciByaW5nLg0KPj4NCj4NCj5TaW5jZSB0
aGlzIGxvZ2ljIChyZS1hcm0gdGhlIHBlbmRpbmcgcmVxdWVzdCkgaXMgZGlmZmVyZW50IHdpdGgg
Y3VycmVudCBvbmUsDQo+cGxlYXNlIHRlc3QgaXQgd2VsbCB0byBhdm9pZCBvdGhlciB1c2UgY2Fz
ZXMuIEFmdGVyIHlvdSBoYXZlIGZ1bGx5IHRlc3RlZCwgZmVlbA0KPmZyZWUgdG8gYWRkIG15IGFj
azoNCj4NCj5BY2tlZC1ieTogUGV0ZXIgQ2hlbiA8cGV0ZXIuY2hlbkBrZXJuZWwub3JnPg0KDQpJ
IGNvbmZpcm0gdGhhdCBpdCB3b3JrcyBjb3JyZWN0IHdpdGggbXkgdGVzdHMuIA0KQWxzbyBvdXIg
Y3VzdG9tZXIgd2hvIHJhaXNlZCB0aGlzIGlzc3VlIGNvbmZpcm1lZCB0aGF0IGl0IHdvcmsgb24g
aGlzIHRlc3RzLg0KDQpQYXdlbA0KDQo+DQo+UGV0ZXINCj4NCj4+IFJlZ2FyZHMsDQo+PiBQYXdl
bA0KPj4NCj4+ID4NCj4+ID4NCj4+ID4+IElmIHlvdSBtZWFucyB0aGlzIHBhdGNoOg0KPj4gPj4g
SXNzdWUgd2FzIGRldGVjdGVkIGJ5IGN1c3RvbWVyIHRlc3QuIEkgZG9u4oCZdCBrbm93IHdoZXRo
ZXIgaXQgd2FzDQo+PiA+PiBvbmx5IHRlc3Qgb3IgdGhlIHJlYWwgYXBwbGljYXRpb24uDQo+PiA+
Pg0KPj4gPj4gVGhlIHByb2JsZW0gaGFwcGVucyBiZWNhdXNlIHVzZXIgYXBwbGljYXRpb24gcXVl
dWVkIHRoZSB0cmFuc2Zlcg0KPj4gPj4gKGVuZHBvaW50IGhhcyBiZWVuIGFybWVkKSwgc28gY29u
dHJvbGxlciBmZXRjaCB0aGUgVFJCLg0KPj4gPj4gV2hlbiB1c2VyIGFwcGxpY2F0aW9uIHJlbW92
ZWQgdGhpcyByZXF1ZXN0IHRoZSBUUkIgd2FzIHN0aWxsDQo+PiA+PiBwcm9jZXNzZWQgYnkgY29u
dHJvbGxlci4gSWYgYXQgdGhhdCB0aW1lIHRoZSBob3N0IHdpbGwgc2VuZCBkYXRhDQo+PiA+PiBw
YWNrZXQgdGhlbiBjb250cm9sbGVyIHdpbGwgYWNjZXB0IGl0LCBidXQgaXQgc2hvdWxkbid0IGJl
Y2F1c2UgdGhlDQo+PiA+PiB1c2JfcmVxdWVzdCBhc3NvY2lhdGVkIHdpdGggVFJCIGNhY2hlZCBi
eSBjb250cm9sbGVyIHdhcyByZW1vdmVkLg0KPj4gPj4gVG8gZm9yY2UgdGhlIGNvbnRyb2xsZXIg
dG8gZHJvcCB0aGlzIFRSQiBERkxVU0ggaXMgcmVxdWlyZWQuDQo+PiA+Pg0KPj4gPj4gUGF3ZWwN
Cj4+ID4+DQo+PiA+PiA+DQo+PiA+PiA+PiAgbm90X2ZvdW5kOg0KPj4gPj4gPj4gICAgICAgICBz
cGluX3VubG9ja19pcnFyZXN0b3JlKCZwcml2X2Rldi0+bG9jaywgZmxhZ3MpOw0KPj4gPj4gPj4g
ICAgICAgICByZXR1cm4gcmV0Ow0KPj4gPj4gPj4gLS0NCj4+ID4+ID4+IDIuMjUuMQ0KPj4gPj4g
Pj4NCj4NCj4tLQ0KPg0KPlRoYW5rcywNCj5QZXRlciBDaGVuDQo=
