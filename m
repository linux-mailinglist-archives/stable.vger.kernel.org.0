Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24D1661E78
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 06:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjAIFiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 00:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjAIFiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 00:38:52 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA0AE09A;
        Sun,  8 Jan 2023 21:38:50 -0800 (PST)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3093I3xa004488;
        Sun, 8 Jan 2023 21:38:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=RNkcNYSbW+Vmrp9L0xFIAEuM/QOsYcUcejPI/8v4Vt8=;
 b=AnABwtZCMnysBhH2br6Avrd8nIhs3VYqf2mGnL1QTagkRjfxiHBy/0m/KiGvM9yrlwl5
 +PidHPoPhZCGQ00+gPVbgfMypNeZC5uzDC6O8lfAXs0mvLy725apddyIH4oIr45Dgiue
 ffkLZXSDRGigwAgw+k24EuTJS9D1kOboP9Hk8dwtVqh9jYuYrxm0WRvDzayN0kVEsVbC
 9jS8mA/cwdkJF6vbScJ6LWmpKyP6brGyvw6Aca23lbk+x1JvUeqFlX+O4E1l0MXaEQpk
 DstvJgfXKuvszteUCcwOr4WBTD0OifBhGQZj/1jyl5tIhZ4Gct4ndMw/McUB7KNzPWLQ sg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3my576nusm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 08 Jan 2023 21:38:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmJ8yM8R7NCCmTgnncQYmsyeTAS35BuXOp+jAHG4gjuAQ687CgnQRdjW28IFtZJt6Es3PcggSV7jxsOjzONX1tbL9OfHWQctzVh+QaK4HcI5PQZmUHDdabLkw9iyvqjzBDg8l9zd8FtvANYxq9VoxI6Ieoe6XRUstm3RcyClYO+FBi9XZ7lsPUGXF33ZdPoP4nLmcqUXlzlHAPYy5tXgr2aIWp/aefzcL4BOJwR4W/kIYFeYNBhPy4KzStUIty7MvmPzbDB3lhwRf2WTNuwXRL8P4D93Bo2K8ZQXjMsMEIluRdvIbLMfEYaUO8GZNRev3GspEiqVWFE1J19K4Lo6dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNkcNYSbW+Vmrp9L0xFIAEuM/QOsYcUcejPI/8v4Vt8=;
 b=Zp2RxunMhYuNFUTyys+K+7qbBBXjMsRvp4WGPz+XLop/c8vIexc3FTjzU/MJHv26HhvZtDIlWt28FzY9Mv4ir4QrRqyEjSH5mWJD7DMLRPVRU7mLj0kmLJIye8DXUQAPXTVidbGrggW3hQygzwDVJ0uupIpF6r4LrXfPsoa/3zWp1blXsDNAHBDFtlAMT0U4m8KStTYK+FSNIXDrRbC9mLEpVfV3myHPxknaGatnqalzq6CJfsmZayIDIi6AZrMfwSqAbZpTK3I0FfrsiXNvmsNoJBtrPKbk+afdYOnA39ijtbvIbBhqooyQB4XCrE7+k2cGO/7EH8F23ewm4YOoCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNkcNYSbW+Vmrp9L0xFIAEuM/QOsYcUcejPI/8v4Vt8=;
 b=QnPHMyopXNyWlYXs2QL4nd9G0lB78fJD+jaqdJMEpuCGBpy5/QeMol5nOwai+Odt/wPzJLRxl7VYNCEXyumpy2HpEKLr3lX8yJlJmbjayX8CDZ5SnBh1kG2BLIx2VMMhFGM55ROLnZukgafEzEfIynmPDEL7EvPBcq3mWcFdkiU=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by DM6PR07MB6713.namprd07.prod.outlook.com (2603:10b6:5:148::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 05:38:32 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::f36d:8292:963:59c6]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::f36d:8292:963:59c6%4]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 05:38:31 +0000
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
Thread-Index: AQHY+Nk1O9kuBWtXZk65xRZeSi7JF65DBooAgAAAr4CASApYAIAKzONg
Date:   Mon, 9 Jan 2023 05:38:31 +0000
Message-ID: <BYAPR07MB5381157D62415BFFBD328C5ADDFE9@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20221115100039.441295-1-pawell@cadence.com>
 <CAL411-o4BETLPd-V_4yR6foXbES=72-P4tq-fQ_W_p0P_3ZqEw@mail.gmail.com>
 <BYAPR07MB5381AE961B59046ECB615C65DD069@BYAPR07MB5381.namprd07.prod.outlook.com>
 <CAL411-rFz5Dde4F_uWbksxJG2uqbD7VsU2GG1JQ0mU3LpbeoUA@mail.gmail.com>
In-Reply-To: <CAL411-rFz5Dde4F_uWbksxJG2uqbD7VsU2GG1JQ0mU3LpbeoUA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctZDc2ZTBkYzEtOGZkZi0xMWVkLWE4NTctMDBiZTQzMTQxNTFlXGFtZS10ZXN0XGQ3NmUwZGMzLThmZGYtMTFlZC1hODU3LTAwYmU0MzE0MTUxZWJvZHkudHh0IiBzej0iNDQyMSIgdD0iMTMzMTc3MTYzMDgzMzMwODE2IiBoPSJWdlJrcFJRM0swSVhZdWQzRXl1c25EbkR5L3c9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|DM6PR07MB6713:EE_
x-ms-office365-filtering-correlation-id: 9db9fca2-2f18-48d0-2321-08daf203be52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2qTbiPc8OUfFngRcU7inTaTwNxyhO6XF0ZkgbMK61R7yUsaSdRUWZkknj7XF5UTCDmzRZcvQsjKg6YgZsc15AZIMvu5XH7201QDiDVyAlwt1XPclFfyx9awuxDaJSn8s7cnKuvVYDb10Mb3oN2JlsX5WnTtig7LHVlc52Laxgqk+gLHO4XOcd70j74XxwimY2XiMsmOgcROakGH1kWjjyKRxZm9L8ctRpIKeCHHRBS7eKUhK9dAE9JqFNA76dBWhXUe77lrMUSLbwfkoAK9ipWkhrFMTP0nYnpKozIYMuxHkPJnbMvP4EcdeiSkke3IomflEyu7p4SBdv+flNlaDHdLBkmfV26ues0J+0awubaWWzYefXV0N6nBHBfjp6aVh29wbjYorRbvRNaX2MbL/mtTeU1ZWOrkzn5+l9om6cxXMfZRVenIWHU4ajVQbutSJWAa88INZ05rF6hM685pE/jmYvlQbS2FfWVvmWpYYwiYAog9h+OjxcswjvK2SEJOZ5WtMJBjclctfSui8Js/OehudRQqTySYd2Xgfcrj2Ch/YKJhxgmEm98bsu3CusD82i9NlsYRzngPUwyvgyDKbM1PVTCW6isWlMVYHBD89IjR7W3ktHZ/BknkiML4SyMph6hCeGDYB08PBK4cdR5rAzDqTM9oYsegjk/jUa79lexnqCg6wu9JJHPWj43ajmdpVTuQtb695Scdwyr8/c9mS9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(36092001)(451199015)(83380400001)(122000001)(86362001)(2906002)(5660300002)(41300700001)(52536014)(8936002)(38100700002)(55016003)(6506007)(9686003)(478600001)(66446008)(26005)(8676002)(6916009)(186003)(64756008)(316002)(66476007)(4326008)(7696005)(66946007)(71200400001)(54906003)(38070700005)(76116006)(66556008)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K29wQmxvZHhXQnVnclVldDczVGpPVDVBMTBCZTJ5NWZmWGNqeGFka2VlaWF3?=
 =?utf-8?B?Wi85aVlhVDVPaFN4SXJSR3Y3b2hBYzZ3bmNLZEJJUlNKRi9McysyblRFUmdJ?=
 =?utf-8?B?ZnlWOGFrS2x3a2h1cTR3OUtxYnc4M1BEV0syZlVGM0l5Z3VNRGpOR25yUUJa?=
 =?utf-8?B?dzYxVUdaV29oVVlucWtiRTh2RTVlVHBtd3V4c2dNNEhFNlhDTHB4QmZWU3B3?=
 =?utf-8?B?a1hpL2VkamZFV01NRGROOWNRR3JXRko5TnpJMnRvTXVVZGo5Vi9hQWFReHV0?=
 =?utf-8?B?cCtMbmhIc2N3Nk5tNjFSUmRIcUx1S3VXQlhjb3ZTTlRYQVhPUXV3SEZudnF4?=
 =?utf-8?B?UWJ0NHhwdG91NUViVFpMVTR0QXhFdlQ5ZVZVL25NN1dYbksxb2FmbzJ6ZGdu?=
 =?utf-8?B?RHlYT3lkWFVJaFpiU3hLTmxIT25QWmpkbGp0eVZ4TG9UNFM5RU9rN2xnZXNa?=
 =?utf-8?B?cFZSRG1aa3ZEc0FqakpOeCt0Q3d0RjlwZHlnYjMva215Ukx6Wi9FdkhMaGJp?=
 =?utf-8?B?MWI2TEFMWTVaQzlla3lKQU0zSktDSE9YRGlGOUdJMmllNTlWSzhwSXlMVENq?=
 =?utf-8?B?aEdxN25QajJKdXlOd3JMbTVWKzI2Q29RYVVSRm80RUFNcVRoY21TYlBObFM2?=
 =?utf-8?B?RUxGM2J3REpyWnJPWlJoTGNLWG45dEpZQTdTYU5INUNqVHFRclNTak1tR0RN?=
 =?utf-8?B?K091ZWpYZEpTY3hUUjJHZ0F5SmIrMjU2NXFHNFdWSzRNY1I3anB6bFh1WWp3?=
 =?utf-8?B?Vmdtd0JwQlJFVTIvZ1Z6ejFsL1Q2TWdFODdaQU4vV05XVTc1YWhHamF3OENk?=
 =?utf-8?B?YnRlbTdmd0lBQXM4L3grV2UyMC8waUpIYnhNY1c3OTVHS2hVSkNpWTdlSHRj?=
 =?utf-8?B?UWx3bXpaYzJkRkYzdzBMa1ZrTy9RWkV6bXF1dGNYVmxYd1JHZlI5REhRYTlo?=
 =?utf-8?B?eDlha0ZUakVkblFUUlJQeXVXMnU5Z0UvWWlyd2pLOTdlUmJqUXMxcGU1V1FF?=
 =?utf-8?B?UzRKdjF5eUVNbm1wWmpDaEp6RnVEYVVldEZBeU1JVTVzVVZiVDdIVFpVVVlV?=
 =?utf-8?B?amV1NmF3MnJHMCtNWXdQZ1Bnb1dnTFRTNzE5VndNOEYyb0xKcjZBRGNtMWl2?=
 =?utf-8?B?L0Q2MzdsbDMwODR2WjRlRXhCVUFld09wMFhiMkpJN05HR2RGektLNVJseUZy?=
 =?utf-8?B?Q0pmNFYzV2FhQTRlQzNUMHdHNnZIdE1zQW54QWU5VVMzZ3NkMGoweVZBV0dz?=
 =?utf-8?B?bktGNWxvV0xCTlhuSXlmTVZJSHR4ZFRwa0FERk9rdHpyQm9jUlRobjB4Vy9O?=
 =?utf-8?B?TkpDOTdZYnFRMTV3QUc3UVdOZzRSbmtsa0Zic081UFJXSEFaNlFCY2FGZDlQ?=
 =?utf-8?B?MkJQNXZtSWcwT09mdzdGcTBWcmEwOWk2bzZLWi9aYkhhSEx5WnpEOHp6elhP?=
 =?utf-8?B?cFNpWEFJWCs4aWkrNXE5MnA2U29PVnlVUVE0NUdRS0M0L2ZlL1lJWlFmS2hS?=
 =?utf-8?B?cWd0STl3WlRtR29rUEZwTWwxcXhaRDcwR091SS9laWhaRjczTTdHeGdWQVRw?=
 =?utf-8?B?ejAvQ01iQ2x0eTNLRVNLVTJJUEx5QlZCWWFmUE1yKzNPSitDeWNvcEFJRG9W?=
 =?utf-8?B?SkYrakZieXBTWDJleTEzRkFuWjZncHBMUUlSOGV2QktSUFQ3UWNNRFJyU3JL?=
 =?utf-8?B?eTFQQkVOMUNqenhmVzRSOXF0dTdPT2dxRjZWSldiL3JidHNkMnl1STY5N01E?=
 =?utf-8?B?UGd6ejRaZHI3aGlPTkd6OGw1WWhMaG84OTd2d0l3cHZCb2w3bE9FSDhidmQw?=
 =?utf-8?B?c3dFWjZua1FtUlVLdWp2M3BOYWFFaXZsTTJCa2hjbGdwbjhIWE44NmcvZWlN?=
 =?utf-8?B?UkR4cFRUWmJ3SHhPSUtEQjFYb1dsU01URU1VZmlsSGs1R3FHcW1LbXUwNDE0?=
 =?utf-8?B?eE0vSjh4NjVJalZTWHZiMG1NWVlEUmQ1TTVXYVZ2aDZCRklmeWthenlyVUtJ?=
 =?utf-8?B?Um1UMkNGQ0F5TytoSGVkSEs2NmlNS1BGM29KdCtzcmZtZDN2ZGRvdUtCanl2?=
 =?utf-8?B?RzYyak9CTkRKT2t4UGxLS0NQMy8zSTZSaUkycnJHOTJLd0hKQ3YwL3MzK2p2?=
 =?utf-8?B?NldhdWd0YWU2aWpRMU55UitBaDNCSlhkV1lqT3ZZTUNxMElzUEJoem1KZVV6?=
 =?utf-8?B?S2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db9fca2-2f18-48d0-2321-08daf203be52
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 05:38:31.7599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1tCg2crROvdf0UaicvGeRsO8+mkV4mG5sL1XYF7FN5WwAFPgUA+L7WleRsl4OOZQa2n0hEorrTUsh6NINQSoU04zMx+QSPQ2/479ksRDYOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6713
X-Proofpoint-GUID: 2z6Gsndn2hlcjw7EHzVJ60O-oemobFWz
X-Proofpoint-ORIG-GUID: 2z6Gsndn2hlcjw7EHzVJ60O-oemobFWz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-08_19,2023-01-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxlogscore=645
 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301090038
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pg0KPk9uIFRodSwgTm92IDE3LCAyMDIyIGF0IDg6MjcgUE0gUGF3ZWwgTGFzemN6YWsgPHBhd2Vs
bEBjYWRlbmNlLmNvbT4NCj53cm90ZToNCj4+DQo+PiA+DQo+PiA+T24gVHVlLCBOb3YgMTUsIDIw
MjIgYXQgNjowMSBQTSBQYXdlbCBMYXN6Y3phayA8cGF3ZWxsQGNhZGVuY2UuY29tPg0KPj4gPndy
b3RlOg0KPj4gPj4NCj4+ID4+IEFmdGVyIGRvb3JiZWxsIERNQSBmZXRjaGVzIHRoZSBUUkIuIElm
IGR1cmluZyBkZXF1ZXVpbmcgcmVxdWVzdA0KPj4gPj4gZHJpdmVyIGNoYW5nZXMgTk9STUFMIFRS
QiB0byBMSU5LIFRSQiBidXQgZG9lc24ndCBkZWxldGUgaXQgZnJvbQ0KPj4gPj4gY29udHJvbGxl
ciBjYWNoZSB0aGVuIGNvbnRyb2xsZXIgd2lsbCBoYW5kbGUgY2FjaGVkIFRSQiBhbmQgcGFja2V0
IGNhbiBiZQ0KPmxvc3QuDQo+PiA+Pg0KPj4gPj4gVGhlIGV4YW1wbGUgc2NlbmFyaW8gZm9yIHRo
aXMgaXNzdWUgbG9va3MgbGlrZToNCj4+ID4+IDEuIHF1ZXVlIHJlcXVlc3QgLSBzZXQgZG9vcmJl
bGwNCj4+ID4+IDIuIGRlcXVldWUgcmVxdWVzdA0KPj4gPj4gMy4gc2VuZCBPVVQgZGF0YSBwYWNr
ZXQgZnJvbSBob3N0DQo+PiA+PiA0LiBEZXZpY2Ugd2lsbCBhY2NlcHQgdGhpcyBwYWNrZXQgd2hp
Y2ggaXMgdW5leHBlY3RlZCA1LiBxdWV1ZSBuZXcNCj4+ID4+IHJlcXVlc3QgLSBzZXQgZG9vcmJl
bGwgNi4gRGV2aWNlIGxvc3QgdGhlIGV4cGVjdGVkIHBhY2tldC4NCj4+ID4+DQo+PiA+PiBCeSBz
ZXR0aW5nIERGTFVTSCBjb250cm9sbGVyIGNsZWFycyBEUkRZIGJpdCBhbmQgc3RvcCBETUEgdHJh
bnNmZXIuDQo+PiA+Pg0KPj4gPj4gRml4ZXM6IDc3MzNmNmMzMmUzNiAoInVzYjogY2RuczM6IEFk
ZCBDYWRlbmNlIFVTQjMgRFJEIERyaXZlciIpDQo+PiA+PiBjYzogPHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmc+DQo+PiA+PiBTaWduZWQtb2ZmLWJ5OiBQYXdlbCBMYXN6Y3phayA8cGF3ZWxsQGNhZGVu
Y2UuY29tPg0KPj4gPj4gLS0tDQo+PiA+PiAgZHJpdmVycy91c2IvY2RuczMvY2RuczMtZ2FkZ2V0
LmMgfCAxMiArKysrKysrKysrKysNCj4+ID4+ICAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9u
cygrKQ0KPj4gPj4NCj4+ID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9jZG5zMy9jZG5zMy1n
YWRnZXQuYw0KPj4gPj4gYi9kcml2ZXJzL3VzYi9jZG5zMy9jZG5zMy1nYWRnZXQuYw0KPj4gPj4g
aW5kZXggNWFkY2IzNDk3MThjLi5jY2ZhZWJjYTZmYWEgMTAwNjQ0DQo+PiA+PiAtLS0gYS9kcml2
ZXJzL3VzYi9jZG5zMy9jZG5zMy1nYWRnZXQuYw0KPj4gPj4gKysrIGIvZHJpdmVycy91c2IvY2Ru
czMvY2RuczMtZ2FkZ2V0LmMNCj4+ID4+IEBAIC0yNjE0LDYgKzI2MTQsNyBAQCBpbnQgY2RuczNf
Z2FkZ2V0X2VwX2RlcXVldWUoc3RydWN0IHVzYl9lcA0KPiplcCwNCj4+ID4+ICAgICAgICAgdTgg
cmVxX29uX2h3X3JpbmcgPSAwOw0KPj4gPj4gICAgICAgICB1bnNpZ25lZCBsb25nIGZsYWdzOw0K
Pj4gPj4gICAgICAgICBpbnQgcmV0ID0gMDsNCj4+ID4+ICsgICAgICAgaW50IHZhbDsNCj4+ID4+
DQo+PiA+PiAgICAgICAgIGlmICghZXAgfHwgIXJlcXVlc3QgfHwgIWVwLT5kZXNjKQ0KPj4gPj4g
ICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KPj4gPj4gQEAgLTI2NDksNiArMjY1MCwx
MyBAQCBpbnQgY2RuczNfZ2FkZ2V0X2VwX2RlcXVldWUoc3RydWN0IHVzYl9lcA0KPj4gPiplcCwN
Cj4+ID4+DQo+PiA+PiAgICAgICAgIC8qIFVwZGF0ZSByaW5nIG9ubHkgaWYgcmVtb3ZlZCByZXF1
ZXN0IGlzIG9uIHBlbmRpbmdfcmVxX2xpc3QgbGlzdCAqLw0KPj4gPj4gICAgICAgICBpZiAocmVx
X29uX2h3X3JpbmcgJiYgbGlua190cmIpIHsNCj4+ID4+ICsgICAgICAgICAgICAgICAvKiBTdG9w
IERNQSAqLw0KPj4gPj4gKyAgICAgICAgICAgICAgIHdyaXRlbChFUF9DTURfREZMVVNILCAmcHJp
dl9kZXYtPnJlZ3MtPmVwX2NtZCk7DQo+PiA+PiArDQo+PiA+PiArICAgICAgICAgICAgICAgLyog
d2FpdCBmb3IgREZMVVNIIGNsZWFyZWQgKi8NCj4+ID4+ICsgICAgICAgICAgICAgICByZWFkbF9w
b2xsX3RpbWVvdXRfYXRvbWljKCZwcml2X2Rldi0+cmVncy0+ZXBfY21kLCB2YWwsDQo+PiA+PiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAhKHZhbCAmIEVQX0NNRF9E
RkxVU0gpLA0KPj4gPj4gKyAxLCAxMDAwKTsNCj4+ID4+ICsNCj4+ID4+ICAgICAgICAgICAgICAg
ICBsaW5rX3RyYi0+YnVmZmVyID0gY3B1X3RvX2xlMzIoVFJCX0JVRkZFUihwcml2X2VwLQ0KPj4g
Pj50cmJfcG9vbF9kbWEgKw0KPj4gPj4gICAgICAgICAgICAgICAgICAgICAgICAgKChwcml2X3Jl
cS0+ZW5kX3RyYiArIDEpICogVFJCX1NJWkUpKSk7DQo+PiA+PiAgICAgICAgICAgICAgICAgbGlu
a190cmItPmNvbnRyb2wgPQ0KPj4gPj4gY3B1X3RvX2xlMzIoKGxlMzJfdG9fY3B1KGxpbmtfdHJi
LT5jb250cm9sKSAmIFRSQl9DWUNMRSkgfCBAQA0KPj4gPj4tMjY2MCw2DQo+PiA+PiArMjY2OCwx
MCBAQCBpbnQgY2RuczNfZ2FkZ2V0X2VwX2RlcXVldWUoc3RydWN0IHVzYl9lcCAqZXAsDQo+PiA+
Pg0KPj4gPj4gICAgICAgICBjZG5zM19nYWRnZXRfZ2l2ZWJhY2socHJpdl9lcCwgcHJpdl9yZXEs
IC1FQ09OTlJFU0VUKTsNCj4+ID4+DQo+PiA+PiArICAgICAgIHJlcSA9IGNkbnMzX25leHRfcmVx
dWVzdCgmcHJpdl9lcC0+cGVuZGluZ19yZXFfbGlzdCk7DQo+PiA+PiArICAgICAgIGlmIChyZXEp
DQo+PiA+PiArICAgICAgICAgICAgICAgY2RuczNfcmVhcm1fdHJhbnNmZXIocHJpdl9lcCwgMSk7
DQo+PiA+PiArDQo+PiA+DQo+PiA+V2h5IHRoZSBhYm92ZSBjaGFuZ2VzIGFyZSBuZWVkZWQ/DQo+
PiA+DQo+Pg0KPj4gRG8geW91IG1lYW4gdGhlIGxhc3QgbGluZSBvciB0aGlzIHBhdGNoPw0KPj4N
Cj4+IExhc3QgbGluZToNCj4+IERNQSBpcyBzdG9wcGVkLCBzbyBkcml2ZXIgYXJtIHRoZSBxdWV1
ZWQgdHJhbnNmZXJzDQo+Pg0KPg0KPlNvcnJ5LCBJIGhhdmUgYmVlbiB2ZXJ5IGJ1c3kgcmVjZW50
bHksIHNvIHRoZSByZXNwb25zZSBtYXkgbm90IGJlIGluIHRpbWUuDQo+SSBtZWFuIHdoeSBpdCBu
ZWVkcyB0byByZS1hcm0gdGhlIHRyYW5zZmVycyBhZnRlciBETUEgaXMgc3RvcHBlZD8NCg0KQmVj
YXVzZSBkcml2ZXIgY2FuIGhhdmUgcXVldWVkIG1vcmUgdHJhbnNmZXJzLiBPbmx5IG9uZSBvZiB0
aGVtIGFyZQ0KZGVxdWV1ZWQuIEluIHRoZSB2YXN0IG1ham9yaXR5IG9mIHRoZSByZXN0IHJlcXVl
c3Qgd2lsbCBiZSByZW1vdmVkIGluIHRoZQ0KbmV4dCBzdGVwcywgYnV0IHRoZXJlIGNhbiBiZSBj
YXNlIGluIHdoaWNoIHdlIGhhdmUgcXVldWVkIGUuZy4gMTAgdXNiIHJlcXVlc3RzDQphbmQgb25s
eSBvbmUgb2YgdGhlbSB3aWxsIGJlIHJlbW92ZWQuIEluIHN1Y2ggY2FzZSB0aGUgZHJpdmVyIGNh
biBzdHVjay4NClRvIGF2b2lkIHRoaXMgZHJpdmVyLCByZWFybSB0aGUgZW5kcG9pbnQgaWYgdGhl
cmUgYXJlIG90aGVyIHRyYW5zZmVyDQppbiB0cmFuc2ZlciByaW5nLg0KDQpSZWdhcmRzLA0KUGF3
ZWwNCg0KPg0KPg0KPj4gSWYgeW91IG1lYW5zIHRoaXMgcGF0Y2g6DQo+PiBJc3N1ZSB3YXMgZGV0
ZWN0ZWQgYnkgY3VzdG9tZXIgdGVzdC4gSSBkb27igJl0IGtub3cgd2hldGhlciBpdCB3YXMgb25s
eQ0KPj4gdGVzdCBvciB0aGUgcmVhbCBhcHBsaWNhdGlvbi4NCj4+DQo+PiBUaGUgcHJvYmxlbSBo
YXBwZW5zIGJlY2F1c2UgdXNlciBhcHBsaWNhdGlvbiBxdWV1ZWQgdGhlIHRyYW5zZmVyDQo+PiAo
ZW5kcG9pbnQgaGFzIGJlZW4gYXJtZWQpLCBzbyBjb250cm9sbGVyIGZldGNoIHRoZSBUUkIuDQo+
PiBXaGVuIHVzZXIgYXBwbGljYXRpb24gcmVtb3ZlZCB0aGlzIHJlcXVlc3QgdGhlIFRSQiB3YXMg
c3RpbGwgcHJvY2Vzc2VkDQo+PiBieSBjb250cm9sbGVyLiBJZiBhdCB0aGF0IHRpbWUgdGhlIGhv
c3Qgd2lsbCBzZW5kIGRhdGEgcGFja2V0IHRoZW4NCj4+IGNvbnRyb2xsZXIgd2lsbCBhY2NlcHQg
aXQsIGJ1dCBpdCBzaG91bGRuJ3QgYmVjYXVzZSB0aGUgdXNiX3JlcXVlc3QNCj4+IGFzc29jaWF0
ZWQgd2l0aCBUUkIgY2FjaGVkIGJ5IGNvbnRyb2xsZXIgd2FzIHJlbW92ZWQuDQo+PiBUbyBmb3Jj
ZSB0aGUgY29udHJvbGxlciB0byBkcm9wIHRoaXMgVFJCIERGTFVTSCBpcyByZXF1aXJlZC4NCj4+
DQo+PiBQYXdlbA0KPj4NCj4+ID4NCj4+ID4+ICBub3RfZm91bmQ6DQo+PiA+PiAgICAgICAgIHNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoJnByaXZfZGV2LT5sb2NrLCBmbGFncyk7DQo+PiA+PiAgICAg
ICAgIHJldHVybiByZXQ7DQo+PiA+PiAtLQ0KPj4gPj4gMi4yNS4xDQo+PiA+Pg0K
