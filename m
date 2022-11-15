Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E042629458
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 10:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbiKOJcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 04:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbiKOJcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 04:32:00 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403DFEE21;
        Tue, 15 Nov 2022 01:31:56 -0800 (PST)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AF8Luse008822;
        Tue, 15 Nov 2022 01:31:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=V2kvU10ycpE7hVg0u5gI+BFmLeTG4+vpVITKAUAbezo=;
 b=oDOq4XdSes7P3myUKbnYeRROXLstvzQUDGi7PkvlezxX2xeIxKyvWofCeAHRlaRxv/g+
 HLBgnxAMh7NMKqh9AmFIdZAB2NZEVUxm1kt/v9Zwsf/IJK2H3XIpmM8ztB1yOpXRlYr9
 LQ7C/d/q51tD7L6hlrUiyNlSD2gOPjdEDsfLrjB0h3rHUbLOkeLQx1jod+EUQiwTlJIa
 EZKDbZJyayiYqSOjzqvolrPSt3aYDZxCQCPALHFS4lqNiQ26qtgSNX8vQxgOQLN5z7Ki
 0ikKmUqfR6xMBWi4Z5rmmSFElr6ty4jqhIf9FY5piQEz2g/goJ9mZEnS9C5shnZ7F+d1 9g== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3kv76n878k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Nov 2022 01:31:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhhHEfzJTvq5KBIKYSipUwPq9ozgDSvXFWMGxV++NFXh4GTpDpsNwVGnPIONVq5ErMwD9D+PzAFS8dO32olsNeOmy0Sl62/+XCOnbiklrLJSe8Uuc6jZQC+rsbZ55Mp5+T/g2fCqL8K3RCTpZ7ix2vfQEwCl0qJSQv3gBNxPBgXAp/JfZ8cwIfC9LZi9wVZueR/dFUAV3DUCpHjBh2TMAgQgZs1MyqM1lxhxxYUiKfMFEy04QrG7LRe4XNYwdHQOoVYLqZGBy4kiYMlD/t2PZyepszrRxq4TqJviB1tPnjMRfvP4aSVOizb4Ao0uoxDQsuWjLSaSO1AfLzoGwNmeLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2kvU10ycpE7hVg0u5gI+BFmLeTG4+vpVITKAUAbezo=;
 b=Eyks2Skf3Pq0YNIUIqkCioIhuCcEpvs2D3g3phA4MQZB7nBD19BEZWyenDUAvrBvEykH7Cnhof95S6LRX1MOhyi4vQd+utVZv42jt80Pcv/EIZOaoNkzHmDmEtFFO4LQ7fOdk/BjiJMcIaeoOO76IH5sdGFegeKmmwt44JU5II+wiz5/ZZMgZPdG0BL6e4fnuq5hccseTVfJzbNCrIw9b2vvqbkuuR1RDppvP/CYQQbM1QJr6Wk3ZeIbII1ueacDVZ8gokrog80F8i+ZCcn0TdB8FT4Y4zMMaCGFqK9ekIj07eWK523cVexPpOkX3JjCwYpPooioJkpHk2si/94R1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2kvU10ycpE7hVg0u5gI+BFmLeTG4+vpVITKAUAbezo=;
 b=pdZheS+JKPxDqFPZycTkrDFKECL2Ha4oD6ge7wnhQbAM0DyreP9QTjSBQsT/FXiHbEraFXIqrGHjx4qf5h6K+C9xWYHIUvUutIr4LoYR7E4C018Ga3O1ZPmmiHArnl/qeagrDZwAb95lwRlbzs8z0V335ZMhsnvDi55Md4ZyOHM=
Received: from SN6PR07MB5392.namprd07.prod.outlook.com (2603:10b6:805:74::27)
 by CH0PR07MB8932.namprd07.prod.outlook.com (2603:10b6:610:f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Tue, 15 Nov
 2022 09:31:48 +0000
Received: from SN6PR07MB5392.namprd07.prod.outlook.com
 ([fe80::ac5:8513:16c4:f77d]) by SN6PR07MB5392.namprd07.prod.outlook.com
 ([fe80::ac5:8513:16c4:f77d%5]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 09:31:48 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <hzpeterchen@gmail.com>
CC:     Peter Chen <peter.chen@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Topic: [PATCH v2] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Index: AQHY57Ge68RMVQuhaUeO0fOrXMci/K4h2uCAgAAVsiCAD7z/gIABUoKQgARwzACAAEix4IABUNwAgAbPTfA=
Date:   Tue, 15 Nov 2022 09:31:48 +0000
Message-ID: <SN6PR07MB53927E089EB9CEC843E7FD00DD049@SN6PR07MB5392.namprd07.prod.outlook.com>
References: <1666620275-139704-1-git-send-email-pawell@cadence.com>
 <20221027072421.GA75844@nchen-desktop>
 <BYAPR07MB5381482129407B849BA9A616DD339@BYAPR07MB5381.namprd07.prod.outlook.com>
 <20221106090221.GA152143@nchen-desktop>
 <BYAPR07MB5381CD42617915D95122D56FDD3C9@BYAPR07MB5381.namprd07.prod.outlook.com>
 <CAL411-qttOGNyZH28bURje0Y3_zVF4XuzVS1zQh2DgPNN0smWw@mail.gmail.com>
 <BYAPR07MB53818794749C701BD908D112DD019@BYAPR07MB5381.namprd07.prod.outlook.com>
 <CAL411-o+ZjYP_R_n0Aae8b2zhQwYw373btX=4DA0hCKYzsuj+w@mail.gmail.com>
In-Reply-To: <CAL411-o+ZjYP_R_n0Aae8b2zhQwYw373btX=4DA0hCKYzsuj+w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNTI1MGZhYjgtNjRjOC0xMWVkLWE4NGQtMDBiZTQzMTQxNTFlXGFtZS10ZXN0XDUyNTBmYWJhLTY0YzgtMTFlZC1hODRkLTAwYmU0MzE0MTUxZWJvZHkudHh0IiBzej0iNDc2NiIgdD0iMTMzMTI5NzgzMDY1NzE1ODkzIiBoPSJEQTB6RVJtbDNvbUhVQ3lQZmt4ZHhYZjJYSTQ9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR07MB5392:EE_|CH0PR07MB8932:EE_
x-ms-office365-filtering-correlation-id: 7961525a-ed0c-4328-ac94-08dac6ec3847
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LNvx8NNRtx0KHYYVTJxYF45LSf/miu1Joe0biDG97gOKheXagLNEe1nH0M1HfwkarbDNc3Zf0iUunzdGmOxDpT85YTin3qskuF8AKbM8ltce4qXdDB1c0Bx2Th4YWwfb90oHnGo4TFn7l4/i1mGsq0zg57bnBMAPW3IkF53Z5DJmvufim33Lw++eJ9UghVNbvVwfAJW+VRQ2I5RK3b4l/idQGTW7zxNssMo8zLgNu+0fKXOgEr+Cv5nbXxxA3QCfiPNd8VlRrBFF9sYQjK1BITVcR666WZIJqqQtpLWLA8/RQzFvWE0xPpoNcHpMSe0I9y4urt7K4JlXqaHiBlb4PFELa3lfFn5te1Ext1BYWlzgro0OwEoKL6xEpV0jgmfJT07TRLjJ0OBlSEDVj/nnrItWjW8d2ii9Ks2QpJchncjQzpqyy6uTwf3XurP179bosMCg1mCqpNQxmMnjS/pLp86lxVnexMfxLghE5cmmt1T6WwQwAtxpDGg7TEk1GE8k6lqAr3ICKMjDSWot6lRVCFKfEdlchEUWx16BqULySpKq0LDkTHZxfXY/+gTHTCnjSTzyKmfjQFCbUTXL287oiosg7BOOW+orTLBt0k8cRoUXFInvwY5Ldkq91HvRYbyb1Q4fUBB5p0b2JehmqftJWQ7x0wCH5m+/YPmkt1I7UzDT/DDAlljWGx2BEIYjExWsiOVK7obKDv8RY772f4DRDyGDL6zLuhLcGPSEUP0MNS3mCYWFf4rPPH/pmKel4tRffmUq7GEpTaiN6UXqHyT+aw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR07MB5392.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(36092001)(451199015)(38100700002)(6506007)(122000001)(7696005)(5660300002)(52536014)(8936002)(26005)(9686003)(86362001)(38070700005)(41300700001)(4326008)(66446008)(66946007)(66556008)(76116006)(8676002)(64756008)(66476007)(83380400001)(316002)(478600001)(2906002)(71200400001)(6916009)(54906003)(55016003)(186003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWc3UEdCR1Q1Z0U3UlZrbnZEdW5qNzFYNllRQTMrcHcvdXhGbHVXaC96dzNU?=
 =?utf-8?B?OS9pQStwY0JZZmI0QnJwR0t0SEw1eWlWVDlKMVhlUnA2TmJxSWkrUHE1Y3dQ?=
 =?utf-8?B?UFJEUGdFdGw0d0dvWS9paG9ueFkxanFqbWpRdGdKWGh3L2tZVlo2dWxXNVpM?=
 =?utf-8?B?Qkp2eG9FeXpXMURyU094NGFSMExPa2M1WW44YnhrYVJVSFdSN0d4V0xqN0R3?=
 =?utf-8?B?MXRnMDlwdVJLYi9aN3UweEtoVWJsZEN5eXRWY2Z6V3VJWlRROHpvS05leUZO?=
 =?utf-8?B?RUg5Mm5pQ3ZZZTA5Y1NIS0FqUzRCaDBkazNHUnMwbXNsUFhXYW1kb0NtemxW?=
 =?utf-8?B?aXJCTzNwZ0VhRVlaTUEzOXdmak1jRGg4Uld2RVRLR0tZTFlBaUhGOC8rdVhZ?=
 =?utf-8?B?bzJvVkdURDNjVldTZTNJM1VIMzZiSDYyYXM2OWJzeElQUWJrei94YUJCOEhu?=
 =?utf-8?B?ZkI0dlNxN0ZGcTc1S281MlRnenhIbXBrcVA3dE4zUFJvSHorM2VlcTFCR1Zi?=
 =?utf-8?B?a0tDN1lMRFhSRHlUb3kwaDh3bkE4ZVdTQ3p1bWdSK0lDL2k5RkpPK0JScDlu?=
 =?utf-8?B?UUpZUjVINnRoWDVGUWViT3gvS2xDYlE0N0VTcHJUcmRQYkd4NmxyZzhFbE1m?=
 =?utf-8?B?NnRlMlM2Y0hNeTVjdlVOSHhGOTgxOVlMK2ZJU2RCRHYvWGc5RmwwVEwyd0FL?=
 =?utf-8?B?b3UzM3dqRDB5T1d0QzlhMjBxd3lrZUZaTnpkRXhTNzRDVExnZWZuR2UwaHor?=
 =?utf-8?B?ZkR0WHZjSWNsU0YrcDUyU1RVeHp5WlFSaWRHUyt1OVg0ZnlMcGtnMHcraW9N?=
 =?utf-8?B?QnFOTGhVa1NJWC85UUxablZqVDQ1TXJPemcyZTI2eU5LOUptMW5SM2tQNUdz?=
 =?utf-8?B?aXJRNW1KUXR6cS8zWEw2NVFzWEFxQTRNQjg0QVpOL1NhYmo3N3gwa2xwY1Zm?=
 =?utf-8?B?QjZZNGJsanZqYlBML0hmKzdHUXJ2ZXhBYURLcHlHZmpMemNZd3R0L3A2Z0Iw?=
 =?utf-8?B?RjJjUVczaUxENytIdGMzNTBIZEJqWnRZWGs0Z3l0MmtVdW10QU9PQVYyeWoy?=
 =?utf-8?B?WWdEZ3JDVkk0dmVSYytXSHJXNFZ0c2puMm5rTkRsLzIxeFRFWmlNNTJlVGZE?=
 =?utf-8?B?elYyV1p6TGFUR1ltYUdNZFNMcTAxeS9zMWg1K0JkbG43aTEwS0dHTCt2dUJI?=
 =?utf-8?B?ZjBjT2tzbUlwb2c1TzBvdmtKSXRZMW42RzFtUzFtK2ZBTE5rNWJYdHRSZ0ky?=
 =?utf-8?B?N2JIMS83V0xPNzh4NDFzbllDWUpLNExaWUpWU3dHSE02OWVwYkkvMzJ1a1pR?=
 =?utf-8?B?MjBrL01TVDVBMTVwVE9KOTY2Qy91cjFZcUI4ZXJFQURYK0ZaaWVEV0c2eERa?=
 =?utf-8?B?MkxBenFnbWJ6ZHlSTDRpRFlZYmZyZmJyTmdOZVJyZG5TZm1JTU1weHJJS0ZP?=
 =?utf-8?B?S0hjK1pScm14a2VWcFJXeHorWEpvSjNxME4xdWNlc1BPdENmSFp5aHJtY0x2?=
 =?utf-8?B?cjRGck5SblJSR3luZW9icnphYXA0NjRwakx2VU50aGsyazlGODk5b0E4OHVQ?=
 =?utf-8?B?MUJSQlI3TFB3Y2ltTDl6KzU1N0pBcnlNY3BiYkRzanRWbTNLN0pGOURhMUF2?=
 =?utf-8?B?Qk5GUmJKOEZCVTVPL01uOXQybWJZM1laVWJVY3A4V3MvbEdiSDlpbTNtTGxa?=
 =?utf-8?B?YUdBVnpoQ0hJcGtxQVlWK29nczI2VXRYRjF2TnZiUlBTdTg0dWZya2czVnhI?=
 =?utf-8?B?T3ZWQ3F4bzdRSXJMeDNwM3BpUWlzK24zbDU5di9YMTYrVGhubG15WGVreHoz?=
 =?utf-8?B?RWRGMzkxQ0J4a3lpL1kxbzBkZFlUMXNjeS9ocUl4blI2Z0JmNGtyZWpIMDIw?=
 =?utf-8?B?ZGpjbEQyNjEzdWdiNFltVm1XbkZxNmFtTGtLWS95MFl2RFFQNksrUlpkNFV3?=
 =?utf-8?B?M0gxejJ4VWdoRFNIMENEL3lMTVdwMklkM1VYS0F6UnZKbDFlZExmMElWbVdR?=
 =?utf-8?B?dGNnaUxnNzVTVC9GY2JoOHhNaHBDT1FWa01jNE5TRWRYU3diS2JkQ1JrMWZz?=
 =?utf-8?B?UkJxbHE2aEN0YjNLUThKYS94ZTRyMiswc2pOUG1YUkphQ28zVWJqdkdnNFY4?=
 =?utf-8?Q?oUyIk1sIEtUfcG7+ivawpYBH2?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR07MB5392.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7961525a-ed0c-4328-ac94-08dac6ec3847
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 09:31:48.4993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QzlOH28rjS4+Q9TT6EBXvqBexY6Li+OAa0JnH0cBiyqXhWBdZZZj2QbSUNbLhl0iiLXLfLVFNXxByUZFiWrOifp8RsB3YwDL60SHb5ge76A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR07MB8932
X-Proofpoint-ORIG-GUID: cpR0mo-mnojVheUuGnVI8ObqWj5P8UR2
X-Proofpoint-GUID: cpR0mo-mnojVheUuGnVI8ObqWj5P8UR2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_04,2022-11-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 phishscore=0
 mlxlogscore=639 mlxscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211150066
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pk9uIFRodSwgTm92IDEwLCAyMDIyIGF0IDE6MzggUE0gUGF3ZWwgTGFzemN6YWsgPHBhd2VsbEBj
YWRlbmNlLmNvbT4NCj53cm90ZToNCj4+DQo+PiA+T24gTW9uLCBOb3YgNywgMjAyMiBhdCAxOjM5
IFBNIFBhd2VsIExhc3pjemFrIDxwYXdlbGxAY2FkZW5jZS5jb20+DQo+PiA+d3JvdGU6DQo+PiA+
Pg0KPj4gPj4gPg0KPj4gPj4gPg0KPj4gPj4gPk9uIDIyLTEwLTI3IDA4OjQ2OjE3LCBQYXdlbCBM
YXN6Y3phayB3cm90ZToNCj4+ID4+ID4+DQo+PiA+PiA+PiA+DQo+PiA+PiA+PiA+T24gMjItMTAt
MjQgMTA6MDQ6MzUsIFBhd2VsIExhc3pjemFrIHdyb3RlOg0KPj4gPj4gPj4gPj4gUGF0Y2ggbW9k
aWZpZXMgdGhlIFREX1NJWkUgaW4gVFJCIGJlZm9yZSBaTFAgVFJCLg0KPj4gPj4gPj4gPj4gVGhl
IFREX1NJWkUgaW4gVFJCIGJlZm9yZSBaTFAgVFJCIG11c3QgYmUgc2V0IHRvIDEgdG8gZm9yY2UN
Cj4+ID4+ID4+ID4+IHByb2Nlc3NpbmcgWkxQIFRSQiBieSBjb250cm9sbGVyLg0KPj4gPj4gPj4g
Pj4NCj4+ID4+ID4+ID4+IGNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCj4+ID4+ID4+ID4+
IEZpeGVzOiAzZDgyOTA0NTU5ZjQgKCJ1c2I6IGNkbnNwOiBjZG5zMyBBZGQgbWFpbiBwYXJ0IG9m
DQo+PiA+PiA+PiA+PiBDYWRlbmNlIFVTQlNTUCBEUkQgRHJpdmVyIikNCj4+ID4+ID4+ID4+IFNp
Z25lZC1vZmYtYnk6IFBhd2VsIExhc3pjemFrIDxwYXdlbGxAY2FkZW5jZS5jb20+DQo+PiA+PiA+
PiA+Pg0KPj4gPj4gPj4gPj4gLS0tDQo+PiA+PiA+PiA+PiBDaGFuZ2Vsb2c6DQo+PiA+PiA+PiA+
PiB2MjoNCj4+ID4+ID4+ID4+IC0gcmV0dXJuZWQgdmFsdWUgZm9yIGxhc3QgVFJCIG11c3QgYmUg
MA0KPj4gPj4gPj4gPj4NCj4+ID4+ID4+ID4+ICBkcml2ZXJzL3VzYi9jZG5zMy9jZG5zcC1yaW5n
LmMgfCA3ICsrKysrKy0NCj4+ID4+ID4+ID4+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+PiA+PiA+PiA+Pg0KPj4gPj4gPj4gPj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdXNiL2NkbnMzL2NkbnNwLXJpbmcuYw0KPj4gPj4gPj4gPj4gYi9kcml2ZXJzL3Vz
Yi9jZG5zMy9jZG5zcC1yaW5nLmMgaW5kZXgNCj4+ID4+ID4+ID4+IDA0ZGZjYWEwOGRjNC4uYWE3
OWJjZTg5ZDhhDQo+PiA+PiA+PiA+PiAxMDA2NDQNCj4+ID4+ID4+ID4+IC0tLSBhL2RyaXZlcnMv
dXNiL2NkbnMzL2NkbnNwLXJpbmcuYw0KPj4gPj4gPj4gPj4gKysrIGIvZHJpdmVycy91c2IvY2Ru
czMvY2Ruc3AtcmluZy5jDQo+PiA+PiA+PiA+PiBAQCAtMTc2OSw4ICsxNzY5LDEzIEBAIHN0YXRp
YyB1MzIgY2Ruc3BfdGRfcmVtYWluZGVyKHN0cnVjdA0KPj4gPj4gPj4gPj4gY2Ruc3BfZGV2aWNl
ICpwZGV2LA0KPj4gPj4gPj4gPj4NCj4+ID4+ID4+ID4+ICAgLyogT25lIFRSQiB3aXRoIGEgemVy
by1sZW5ndGggZGF0YSBwYWNrZXQuICovDQo+PiA+PiA+PiA+PiAgIGlmICghbW9yZV90cmJzX2Nv
bWluZyB8fCAodHJhbnNmZXJyZWQgPT0gMCAmJiB0cmJfYnVmZl9sZW4gPT0gMCkNCj58fA0KPj4g
Pj4gPj4gPj4gLSAgICAgdHJiX2J1ZmZfbGVuID09IHRkX3RvdGFsX2xlbikNCj4+ID4+ID4+ID4+
ICsgICAgIHRyYl9idWZmX2xlbiA9PSB0ZF90b3RhbF9sZW4pIHsNCj4+ID4+ID4+ID4+ICsgICAg
ICAgICAvKiBCZWZvcmUgWkxQIGRyaXZlciBuZWVkcyBzZXQgVERfU0laRT0xLiAqLw0KPj4gPj4g
Pj4gPj4gKyAgICAgICAgIGlmIChtb3JlX3RyYnNfY29taW5nKQ0KPj4gPj4gPj4gPj4gKyAgICAg
ICAgICAgICAgICAgcmV0dXJuIDE7DQo+PiA+PiA+PiA+PiArDQo+PiA+PiA+PiA+PiAgICAgICAg
ICAgcmV0dXJuIDA7DQo+PiA+PiA+PiA+PiArIH0NCj4+ID4+ID4+ID4NCj4+ID4+ID4+ID5Eb2Vz
IHRoYXQgZml4IHRoZSBpc3N1ZSB5b3Ugd2FudCBhdCBidWxrIHRyYW5zZmVyLCB3aGljaCBoYXMN
Cj4+ID4+ID4+ID56ZXJvLWxlbmd0aCBwYWNrZXQgYXQgdGhlIGxhc3QgcGFja2V0PyBJdCBzZWVt
cyBub3QgYWxpZ24gd2l0aA0KPj4gPj4gPj4gPnlvdXIgcHJldmlvdXMNCj4+ID4+ID5maXguDQo+
PiA+PiA+PiA+V291bGQgeW91IG1pbmQgZXhwbGFpbmluZyBtb3JlPw0KPj4gPj4gPj4NCj4+ID4+
ID4+IFZhbHVlIHJldHVybmVkIGJ5IGZ1bmN0aW9uIGNkbnNwX3RkX3JlbWFpbmRlciBpcyB1c2Vk
IGFzIFREX1NJWkUNCj4+ID4+ID4+IGluIFRSQi4NCj4+ID4+ID4+DQo+PiA+PiA+PiBUaGUgbGFz
dCBUUkIgaW4gVEQgc2hvdWxkIGhhdmUgVERfU0laRT0wLCBzbyB0cmIgZm9yIFpMUCBzaG91bGQN
Cj4+ID4+ID4+IGhhdmUgc2V0IGFsc28gVERfU0laRT0wLiBJZiBkcml2ZXIgc2V0IFREX1NJWkU9
MCBvbiBiZWZvcmUgdGhlDQo+PiA+PiA+PiBsYXN0IG9uZSBUUkIgdGhlbiB0aGUgY29udHJvbGxl
ciBzdG9wcyB0aGUgdHJhbnNmZXIgYW5kIGlnbm9yZQ0KPj4gPj4gPj4gdHJiIGZvciBaTFANCj4+
ID5wYWNrZXQuDQo+PiA+PiA+Pg0KPj4gPj4gPj4gVG8gZml4IHRoaXMsIHRoZSBkcml2ZXIgaW4g
c3VjaCBjYXNlIG11c3Qgc2V0IFREX1NJWkUgPSAxIGJlZm9yZQ0KPj4gPj4gPj4gdGhlIGxhc3Qg
VFJCLg0KPj4gPj4gPg0KPj4gPj4gPiAgICAgICBpZiAoIW1vcmVfdHJic19jb21pbmcgfHwgKHRy
YW5zZmVycmVkID09IDAgJiYgdHJiX2J1ZmZfbGVuID09IDApDQo+fHwNCj4+ID4+ID4gLSAgICAg
ICAgIHRyYl9idWZmX2xlbiA9PSB0ZF90b3RhbF9sZW4pDQo+PiA+PiA+ICsgICAgICAgICB0cmJf
YnVmZl9sZW4gPT0gdGRfdG90YWxfbGVuKSB7DQo+PiA+PiA+ICsgICAgICAgICAgICAgLyogQmVm
b3JlIFpMUCBkcml2ZXIgbmVlZHMgc2V0IFREX1NJWkU9MS4gKi8NCj4+ID4+ID4gKyAgICAgICAg
ICAgICBpZiAobW9yZV90cmJzX2NvbWluZykNCj4+ID4+ID4gKyAgICAgICAgICAgICAgICAgICAg
IHJldHVybiAxOw0KPj4gPj4gPiArDQo+PiA+PiA+ICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+
PiA+PiA+ICsgICAgIH0NCj4+ID4+ID4NCj4+ID4+ID5Ib3cgeW91ciBhYm92ZSBmaXggY291bGQg
cmV0dXJuIFREX1NJWkUgYXMgMSBmb3IgbGFzdCBub24tWkxQIFRSQj8NCj4+ID4+ID5XaGljaCBj
b25kaXRpb25zIGFyZSBzYXRpc2ZpZWQ/DQo+PiA+Pg0KPj4gPj4gRm9yIGxhc3Qgbm9uLVpMUCBU
UkIgVERfU0laRSBzaG91bGQgYmUgMCBvciAxLg0KPj4gPj4NCj4+ID4+IFdlIGhhdmUgdGhyZWUg
Y2FzZXNzOg0KPj4gPj4gMS4NCj4+ID4+ICAgICAgICAgVFJCMSAtIGxlbmd0aCA+IDENCj4+ID4+
ICAgICAgICAgVFJiMiAtIFpMUA0KPj4gPj4NCj4+ID4+IEluIHRoaXMgY2FzZSBUUkIxIHNob3Vs
ZCBoYXZlIHNldCBURF9TSVpFID0gMS4gSW4gdGhpcyBjYXNlIHRoZSBjb25kaXRpb24NCj4+ID4+
ICAgICAgICAgaWYgKG1vcmVfdHJic19jb21pbmcpDQo+PiA+PiAgICAgICAgICAgICAgICAgcmV0
dXJuIDE7DQo+PiA+Pg0KPj4gPj4gcmV0dXJucyBURF9TSVpFPTEuIEluIHRoaXMgY2FzZSBtb3Jl
X3RyYl9jb21taW5nIGZvciBUUkIxIGlzIDEgYW5kDQo+PiA+PiBmb3INCj4+ID4+IFRSQjIgaXMg
MA0KPj4gPj4NCj4+ID4NCj4+ID5UaGlzIG9uZSBpcyBteSBxdWVzdGlvbi4gSG93IGJlbG93IGNv
bmRpdGlvbiBpcyB0cnVlIGZvciB5b3VyIGNhc2UgMToNCj4+ID4NCj4+ID4gaWYgKCFtb3JlX3Ry
YnNfY29taW5nIHx8ICh0cmFuc2ZlcnJlZCA9PSAwICYmIHRyYl9idWZmX2xlbiA9PSAwKSB8fA0K
Pj4gPiAgICAgICAgICB0cmJfYnVmZl9sZW4gPT0gdGRfdG90YWxfbGVuKQ0KPj4NCj4+IEZvciBU
UkIxOg0KPj4gICAgbW9yZV90cmJzX2NvbWluZyA9IHRydWUNCj4+ICAgIHRyYW5zZmVycmVkID09
IDAgJiYgdHJiX2J1ZmZfbGVuID09IDAgIC0gZmFsc2UgLSBpdCBkb2VzIG5vdCBtYXR0ZXIgaW4g
dGhpcw0KPmNhc2UNCj4+ICAgIHRyYl9idWZmX2xlbiA9PSB0ZF90b3RhbF9sZW4gLSB0cnVlDQo+
DQo+V2h5IHRyYl9idWZmX2xlbiBlcXVhbHMgdG8gdGRfdG90YWxfbGVuZ3RoPyBDb25zaWRlcmlu
ZyB0aGUgYnVsayB0cmFuc2Zlcg0KPndpdGggcmVxdWVzdCBsZW5ndGggbGFyZ2VyIHRoYW4gNjRL
Qi4NCj4NCg0KWW91IGhhdmUgcmlnaHQsIHRoZXJlIG1pZ2h0IHN0aWxsIGJlIGEgcHJvYmxlbSB3
aXRoIFpMUC4gDQpJJ3ZlIHBvc3RlZCB0aGUgdjMgaW1wbGVtZW50ZWQgYSBsaXR0bGUgZGlmZmVy
ZW50bHkuDQoNClRoYW5rcw0KUGF3ZWwNCg0KPg0KPj4gICBzbyB3aG9sZSBjb25kaXRpb24gaXMg
dHJ1ZS4NCj4+DQo+PiAgIEJlY2F1c2UgbW9yZV90cmJfY29tbWluZyA9IHRydWUgc286DQo+PiAg
ICAgICAgICAgICAgaWYgKG1vcmVfdHJic19jb21pbmcpDQo+PiAgICAgICAgICAgICAgICAgICAg
ICAgICByZXR1cm4gMTsNCj4+IHJldHVybnMgVERfU0laRSA9IDENCj4+DQo+PiBGb3IgVFJCMiAt
IFpMUDoNCj4+ICAgIG1vcmVfdHJic19jb21pbmcgPSBmYWxzZQ0KPj4gICAgdHJhbnNmZXJyZWQg
PT0gMCAmJiB0cmJfYnVmZl9sZW4gPT0gMCAgLSBmYWxzZSAtIGl0IGRvZXMgbm90IG1hdHRlciBp
biB0aGlzDQo+Y2FzZQ0KPj4gICAgdHJiX2J1ZmZfbGVuID09IHRkX3RvdGFsX2xlbiAtIHRydWUN
Cj4+DQo+PiAgIEJlY2F1c2UgbW9yZV90cmJfY29tbWluZyA9IGZhbHNlIHNvIGZ1bmN0aW9uIHJl
dHVybnMgVERfU0laRSA9IDAgIGZvcg0KPmxhc3QgWkxQIHRyYi4NCj4+DQo+PiBQYXdlbA0K
