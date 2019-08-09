Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0FB878E1
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 13:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406452AbfHILkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 07:40:11 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:58406 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726420AbfHILkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 07:40:11 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79BcTtr015447;
        Fri, 9 Aug 2019 07:40:05 -0400
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u7xkj6vns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 07:40:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3g8PPhSYYmZVqmg4IZbfPO8w5pHfvBDfbyueX1f+4llVfLhvHFL9amphs/BCbaOxU5YoHR9IRwS4qZQeZGgk+9eKQPcpyI5iRa1GODWkuMHkwarSOTP/So7zSkx3o74CO0uPDti4UUI45JQC62RCr8RLLBhVBFx0dvOENF9Gediv0nMygd21IyYwrhUx/4r3P7wj0O5dbyPpe93hOyObKnEk5KszCnSOdZnMGn7J5aY1oqDxBFUKqCvp0Iaxr6SakkVGpdBF8bO31+cU4K0ep745wBYcypDfy3SofL2uNtq2SqYcKKc/hvujVEMHmZzGB04GWKtFKyOeYhqTCYNjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YG5b5u+UAW+tnkuSvviq/U56ecfWaTfme8ajRm1nxQ=;
 b=J1FYaiBrkx2spQUvL41mgtRJsWJV90uLt74Vwbk2RsxIMzbECIzJiS3qbroKRIDrSThyepgDpo6xEBGuaz9BsxUjfIQTEJMAAKnK/vcYpmb8IUisDCr4+pw+lbfTJldx88H5r09s6EWfQYkwYHx7Nb11Dc0vjSI/ascWszhlnI/pHcxGOgNer9SjgaAbF2e4p1anYtvW0pRt393oytX74Gw45owxu0mhg2HyYV402FN8yeKcrJVgegKuFi3wzx0/mFsfXFxy7qowR1RsjsWNA5lazigEM+6hgAxDuEqhS1D1AjoQ1f/vhgCrmzEySGG5UjNMCUbbMCmCjH+M9vc+bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YG5b5u+UAW+tnkuSvviq/U56ecfWaTfme8ajRm1nxQ=;
 b=OEuP4sIAn4whH4g6yp9R6OlysMjwjPBMOquFWjUAAq+8xKqvmH1+/cjlELvAtQWCFWl6PRYafU+DVP400aJURnozTrYnpOGmH7wDvtOaqhNBJVPCUF/n3mt+kkgaBdsncIFwTAFGmkfPPpb7jNtzQ/EZXr//2bI3hIRIH/RpVhM=
Received: from BN6PR03CA0063.namprd03.prod.outlook.com (2603:10b6:404:4c::25)
 by BYAPR03MB4184.namprd03.prod.outlook.com (2603:10b6:a03:7d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16; Fri, 9 Aug
 2019 11:40:03 +0000
Received: from CY1NAM02FT021.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::207) by BN6PR03CA0063.outlook.office365.com
 (2603:10b6:404:4c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Fri, 9 Aug 2019 11:40:03 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT021.mail.protection.outlook.com (10.152.75.187) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 11:40:02 +0000
Received: from NWD2HUBCAS8.ad.analog.com (nwd2hubcas8.ad.analog.com [10.64.69.108])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x79BdxCE000947
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 04:39:59 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS8.ad.analog.com ([fe80::90a0:b93e:53c6:afee%12]) with mapi id
 14.03.0415.000; Fri, 9 Aug 2019 07:40:02 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "colyli@suse.de" <colyli@suse.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] bcache: Revert "bcache: use sysfs_match_string()
 instead of __sysfs_match_string()"
Thread-Topic: [PATCH v2 1/1] bcache: Revert "bcache: use
 sysfs_match_string() instead of __sysfs_match_string()"
Thread-Index: AQHVTnmxeKSFjvfekUuIGrIbaWtbyqby9HOA
Date:   Fri, 9 Aug 2019 11:40:01 +0000
Message-ID: <32305f1e72f625762316aadb55c73a13e7f3ed1a.camel@analog.com>
References: <20190809061405.73653-1-colyli@suse.de>
         <20190809061405.73653-2-colyli@suse.de>
In-Reply-To: <20190809061405.73653-2-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.113]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <40D1F678B363BB4D80888BBB435DA4E3@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(39860400002)(376002)(346002)(396003)(136003)(2980300002)(189003)(199004)(2486003)(7736002)(305945005)(7636002)(6246003)(5660300002)(36756003)(86362001)(4326008)(356004)(8676002)(47776003)(476003)(2616005)(126002)(229853002)(8936002)(54906003)(110136005)(6116002)(436003)(106002)(11346002)(446003)(336012)(246002)(186003)(316002)(26005)(14454004)(3846002)(118296001)(76176011)(486006)(14444005)(50466002)(102836004)(7696005)(478600001)(2501003)(70586007)(70206006)(426003)(5024004)(2906002)(23676004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4184;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b3bf431-d09e-4451-77dc-08d71cbe516c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BYAPR03MB4184;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4184:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4184405D36FFC17BFE4D8A22F9D60@BYAPR03MB4184.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: pThvyyDeeIAXiBleNBvRCRgcPeMNMv8bRcH/qpK1oyGz3ZFcsG2pl+PwRadc0sbI18U3B43CN/gpZnrum+cJ2rpyCDr9gZGCrlt6r1QRg5zmYnThxNEwcR/nFUw/jRlyIHf7Qod8VeJ7kCpUIp/tBKmUNRDRSbFUU23laaLb43IMTzV1CORiVf8seh+pmyaDDzfPWqBLetkx86ziZfIupNs1n7mU6SKPa4D4i6iCHtsNWRSpbKF9FWNaSWoHs2Io8AHPO/fMgwWUSm4AOVK4P5r4Wf3kJ/hJB7vce0Qnk6HxkN8vMLxD1okDz4X4WIzIEWTfWwN+9Gi4AGVch7OqEuIhHwLVKcW/4pcXzAiqzDdsBz3MuhapuZxeIvBMZKNeyFTxnXDfP/py2wQ0k74dLafBBQRmhKBH0x40Mb2Iaeo=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 11:40:02.8075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3bf431-d09e-4451-77dc-08d71cbe516c
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4184
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090121
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDE5LTA4LTA5IGF0IDE0OjE0ICswODAwLCBDb2x5IExpIHdyb3RlOg0KPiBbRXh0
ZXJuYWxdDQo+IA0KPiBUaGlzIHJldmVydHMgY29tbWl0IDg5ZTAzNDFhZjA4MmRiYzE3MDAxOWY5
MDg4NDZmNGE0MjRlZmM4NmIuDQo+IA0KPiBJbiBkcml2ZXJzL21kL2JjYWNoZS9zeXNmcy5jOmJj
aF9zbnByaW50X3N0cmluZ19saXN0KCksIE5VTEwgcG9pbnRlciBhdA0KPiB0aGUgZW5kIG9mIGxp
c3QgaXMgbmVjZXNzYXJ5LiBSZW1vdmUgdGhlIE5VTEwgZnJvbSBsYXN0IGVsZW1lbnQgb2YgZWFj
aA0KPiBsaXN0cyB3aWxsIGNhdXNlIHRoZSBmb2xsb3dpbmcgcGFuaWMsDQo+IA0KPiBbIDQzNDAu
NDU1NjUyXSBiY2FjaGU6IHJlZ2lzdGVyX2NhY2hlKCkgcmVnaXN0ZXJlZCBjYWNoZSBkZXZpY2Ug
bnZtZTBuMQ0KPiBbIDQzNDAuNDY0NjAzXSBiY2FjaGU6IHJlZ2lzdGVyX2JkZXYoKSByZWdpc3Rl
cmVkIGJhY2tpbmcgZGV2aWNlIHNkaw0KPiBbIDQ0MjEuNTg3MzM1XSBiY2FjaGU6IGJjaF9jYWNo
ZWRfZGV2X3J1bigpIGNhY2hlZCBkZXYgc2RrIGlzIHJ1bm5pbmcgYWxyZWFkeQ0KPiBbIDQ0MjEu
NTg3MzQ4XSBiY2FjaGU6IGJjaF9jYWNoZWRfZGV2X2F0dGFjaCgpIENhY2hpbmcgc2RrIGFzIGJj
YWNoZTAgb24gc2V0IDM1NGUxZDQ2LWQ5OWYtNGQ4Yi04NzBiLTA3OGI4MGRjODhhNg0KPiBbIDUx
MzkuMjQ3OTUwXSBnZW5lcmFsIHByb3RlY3Rpb24gZmF1bHQ6IDAwMDAgWyMxXSBTTVAgTk9QVEkN
Cj4gWyA1MTM5LjI0Nzk3MF0gQ1BVOiA5IFBJRDogNTg5NiBDb21tOiBjYXQgTm90IHRhaW50ZWQg
NC4xMi4xNC05NS4yOS1kZWZhdWx0ICMxIFNMRTEyLVNQNA0KPiBbIDUxMzkuMjQ3OTg4XSBIYXJk
d2FyZSBuYW1lOiBIUEUgUHJvTGlhbnQgREwzODAgR2VuMTAvUHJvTGlhbnQgREwzODAgR2VuMTAs
IEJJT1MgVTMwIDA0LzE4LzIwMTkNCj4gWyA1MTM5LjI0ODAwNl0gdGFzazogZmZmZjg4OGZiMjVj
MGIwMCB0YXNrLnN0YWNrOiBmZmZmOWJiYWNjNzA0MDAwDQo+IFsgNTEzOS4yNDgwMjFdIFJJUDog
MDAxMDpzdHJpbmcrMHgyMS8weDcwDQo+IFsgNTEzOS4yNDgwMzBdIFJTUDogMDAxODpmZmZmOWJi
YWNjNzA3YmYwIEVGTEFHUzogMDAwMTAyODYNCj4gWyA1MTM5LjI0ODA0M10gUkFYOiBmZmZmZmZm
ZmE3ZTQzMmUzIFJCWDogZmZmZjg4ODFjMjBkYTAyYSBSQ1g6IGZmZmYwYTAwZmZmZmZmMDQNCj4g
WyA1MTM5LjI0ODA1OF0gUkRYOiAzZjAwNjU2ODYzNjE2MzYyIFJTSTogZmZmZjg4ODFjMjBkYjAw
MCBSREk6IGZmZmZmZmZmZmZmZmZmZmYNCj4gWyA1MTM5LjI0ODA3NV0gUkJQOiBmZmZmODg4MWMy
MGRiMDAwIFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IGZmZmY4ODgxYzIwZGEwMmENCj4gWyA1
MTM5LjI0ODA5MF0gUjEwOiAwMDAwMDAwMDAwMDAwMDA0IFIxMTogMDAwMDAwMDAwMDAwMDAwMCBS
MTI6IGZmZmY5YmJhY2M3MDdjNDgNCj4gWyA1MTM5LjI0ODEwNF0gUjEzOiAwMDAwMDAwMDAwMDAw
ZmQ2IFIxNDogZmZmZmZmZmZjMDY2NTg1NSBSMTU6IGZmZmZmZmZmYzA2NjU4NTUNCj4gWyA1MTM5
LjI0ODExOV0gRlM6ICAwMDAwN2ZhZjI1M2I4NzAwKDAwMDApIEdTOmZmZmY4ODkwM2Y4NDAwMDAo
MDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMA0KPiBbIDUxMzkuMjQ4MTM3XSBDUzogIDAwMTAg
RFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzDQo+IFsgNTEzOS4yNDgxNDld
IENSMjogMDAwMDdmYWYyNTM5NTAwOCBDUjM6IDAwMDAwMDBmNzIxNTAwMDYgQ1I0OiAwMDAwMDAw
MDAwNzYwNmUwDQo+IFsgNTEzOS4yNDgxNjRdIERSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAw
MDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAwMDAwMDAwMDAwMDAwDQo+IFsgNTEzOS4yNDgxNzldIERS
MzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZTBmZjAgRFI3OiAwMDAwMDAwMDAw
MDAwNDAwDQo+IFsgNTEzOS4yNDgxOTNdIFBLUlU6IDU1NTU1NTU0DQo+IFsgNTEzOS4yNDgyMDBd
IENhbGwgVHJhY2U6DQo+IFsgNTEzOS4yNDgyMTBdICB2c25wcmludGYrMHgxZmIvMHg1MTANCj4g
WyA1MTM5LjI0ODIyMV0gIHNucHJpbnRmKzB4MzkvMHg0MA0KPiBbIDUxMzkuMjQ4MjM4XSAgYmNo
X3NucHJpbnRfc3RyaW5nX2xpc3QuY29uc3Rwcm9wLjE1KzB4NWIvMHg5MCBbYmNhY2hlXQ0KPiBb
IDUxMzkuMjQ4MjU2XSAgX19iY2hfY2FjaGVkX2Rldl9zaG93KzB4NDRkLzB4NWYwIFtiY2FjaGVd
DQo+IFsgNTEzOS4yNDgyNzBdICA/IF9fYWxsb2NfcGFnZXNfbm9kZW1hc2srMHhiMi8weDIxMA0K
PiBbIDUxMzkuMjQ4Mjg0XSAgYmNoX2NhY2hlZF9kZXZfc2hvdysweDJjLzB4NTAgW2JjYWNoZV0N
Cj4gWyA1MTM5LjI0ODI5N10gIHN5c2ZzX2tmX3NlcV9zaG93KzB4YmIvMHgxOTANCj4gWyA1MTM5
LjI0ODMwOF0gIHNlcV9yZWFkKzB4ZmMvMHgzYzBiY2hfc25wcmludF9zdHJpbmdfbGlzdCgpDQo+
IFsgNTEzOS4yNDgzMTddICBfX3Zmc19yZWFkKzB4MjYvMHgxNDANCj4gWyA1MTM5LjI0ODMyN10g
IHZmc19yZWFkKzB4ODcvMHgxMzANCj4gWyA1MTM5LjI0ODMzNl0gIFN5U19yZWFkKzB4NDIvMHg5
MA0KPiBbIDUxMzkuMjQ4MzQ2XSAgZG9fc3lzY2FsbF82NCsweDc0LzB4MTYwDQo+IFsgNTEzOS4y
NDgzNThdICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHgzZC8weGEyDQo+IFsgNTEz
OS4yNDgzNzBdIFJJUDogMDAzMzoweDdmYWYyNGVlYTM3MA0KPiBbIDUxMzkuMjQ4Mzc5XSBSU1A6
IDAwMmI6MDAwMDdmZmY4MmQwM2YzOCBFRkxBR1M6IDAwMDAwMjQ2IE9SSUdfUkFYOiAwMDAwMDAw
MDAwMDAwMDAwDQo+IFsgNTEzOS4yNDgzOTVdIFJBWDogZmZmZmZmZmZmZmZmZmZkYSBSQlg6IDAw
MDAwMDAwMDAwMjAwMDAgUkNYOiAwMDAwN2ZhZjI0ZWVhMzcwDQo+IFsgNTEzOS4yNDg0MTFdIFJE
WDogMDAwMDAwMDAwMDAyMDAwMCBSU0k6IDAwMDA3ZmFmMjUzOTYwMDAgUkRJOiAwMDAwMDAwMDAw
MDAwMDAzDQo+IFsgNTEzOS4yNDg0MjZdIFJCUDogMDAwMDdmYWYyNTM5NjAwMCBSMDg6IDAwMDAw
MDAwZmZmZmZmZmYgUjA5OiAwMDAwMDAwMDAwMDAwMDAwDQo+IFsgNTEzOS4yNDg0NDFdIFIxMDog
MDAwMDAwMDA3YzlkNGQ0MSBSMTE6IDAwMDAwMDAwMDAwMDAyNDYgUjEyOiAwMDAwN2ZhZjI1Mzk2
MDAwDQo+IFsgNTEzOS4yNDg0NTZdIFIxMzogMDAwMDAwMDAwMDAwMDAwMyBSMTQ6IDAwMDAwMDAw
MDAwMDAwMDAgUjE1OiAwMDAwMDAwMDAwMDAwZmZmDQo+IFsgNTEzOS4yNDg4OTJdIENvZGU6IGZm
IGZmIGZmIDBmIDFmIDgwIDAwIDAwIDAwIDAwIDQ5IDg5IGY5IDQ4IDg5IGNmIDQ4IGM3IGMwIGUz
IDMyIGU0IGE3IDQ4IGMxIGZmIDMwIDQ4IDgxIGZhIGZmIDBmDQo+IDAwIDAwIDQ4IDBmIDQ2IGQw
IDQ4IDg1IGZmIDc0IDQ1IDw0ND4gMGYgYjYgMDIgNDggOGQgNDIgMDEgNDUgODQgYzAgNzQgMzgg
NDggMDEgZmEgNGMgODkgY2YgZWIgMGUNCj4gDQo+IFRoZSBzaW1wbGVzdCB3YXkgdG8gZml4IGlz
IHRvIHJldmVydCBjb21taXQgODllMDM0MWFmMDgyICgiYmNhY2hlOiB1c2UNCj4gc3lzZnNfbWF0
Y2hfc3RyaW5nKCkgaW5zdGVhZCBvZiBfX3N5c2ZzX21hdGNoX3N0cmluZygpIikuDQo+IA0KPiBU
aGlzIGJ1ZyB3YXMgaW50cm9kdWNlZCBpbiBMaW51eCB2NS4yLCBzbyB0aGlzIGZpeCBvbmx5IGFw
cGxpZXMgdG8NCj4gTGludXggdjUuMiBpcyBlbm91Z2ggZm9yIHN0YWJsZSB0cmVlIG1haW50YWlu
ZXIuDQoNClNvcnJ5IGFib3V0IHRoZSBicmVha2FnZS4NCg0KQWNrZWQtYnk6IEFsZXhhbmRydSBB
cmRlbGVhbiA8YWxleGFuZHJ1LmFyZGVsZWFuQGFuYWxvZy5jb20+DQoNClRoZSBhbHRlcm5hdGl2
ZSB3b3VsZCBoYXZlIGJlZW4gdG8gZXh0ZW5kL2ZpeCBiY2hfc25wcmludF9zdHJpbmdfbGlzdCgp
LCBidXQgSSBhbHNvIGFncmVlIHJldmVydGluZyBpcyBlYXNpZXIuDQoNClRoYW5rcw0KQWxleA0K
DQo+IA0KPiBGaXhlczogODllMDM0MWFmMDgyICgiYmNhY2hlOiB1c2Ugc3lzZnNfbWF0Y2hfc3Ry
aW5nKCkgaW5zdGVhZCBvZiBfX3N5c2ZzX21hdGNoX3N0cmluZygpIikNCj4gU2lnbmVkLW9mZi1i
eTogQ29seSBMaSA8Y29seWxpQHN1c2UuZGU+DQo+IFJlcG9ydGVkLWJ5OiBQZWlmZW5nIExpbiA8
cGZsaW5Ac3VzZS5jb20+DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IENjOiBBbGV4
YW5kcnUgQXJkZWxlYW4gPGFsZXhhbmRydS5hcmRlbGVhbkBhbmFsb2cuY29tPg0KPiAtLS0NCj4g
IGRyaXZlcnMvbWQvYmNhY2hlL3N5c2ZzLmMgfCAyMCArKysrKysrKysrKystLS0tLS0tLQ0KPiAg
MSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9iY2FjaGUvc3lzZnMuYyBiL2RyaXZlcnMvbWQvYmNhY2hl
L3N5c2ZzLmMNCj4gaW5kZXggOWYwODI2NzEyODQ1Li5lMjA1OWFmOTA3OTEgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbWQvYmNhY2hlL3N5c2ZzLmMNCj4gKysrIGIvZHJpdmVycy9tZC9iY2FjaGUv
c3lzZnMuYw0KPiBAQCAtMjMsMjQgKzIzLDI4IEBAIHN0YXRpYyBjb25zdCBjaGFyICogY29uc3Qg
YmNoX2NhY2hlX21vZGVzW10gPSB7DQo+ICAJIndyaXRldGhyb3VnaCIsDQo+ICAJIndyaXRlYmFj
ayIsDQo+ICAJIndyaXRlYXJvdW5kIiwNCj4gLQkibm9uZSINCj4gKwkibm9uZSIsDQo+ICsJTlVM
TA0KPiAgfTsNCj4gIA0KPiAgLyogRGVmYXVsdCBpcyAwICgiYXV0byIpICovDQo+ICBzdGF0aWMg
Y29uc3QgY2hhciAqIGNvbnN0IGJjaF9zdG9wX29uX2ZhaWx1cmVfbW9kZXNbXSA9IHsNCj4gIAki
YXV0byIsDQo+IC0JImFsd2F5cyINCj4gKwkiYWx3YXlzIiwNCj4gKwlOVUxMDQo+ICB9Ow0KPiAg
DQo+ICBzdGF0aWMgY29uc3QgY2hhciAqIGNvbnN0IGNhY2hlX3JlcGxhY2VtZW50X3BvbGljaWVz
W10gPSB7DQo+ICAJImxydSIsDQo+ICAJImZpZm8iLA0KPiAtCSJyYW5kb20iDQo+ICsJInJhbmRv
bSIsDQo+ICsJTlVMTA0KPiAgfTsNCj4gIA0KPiAgc3RhdGljIGNvbnN0IGNoYXIgKiBjb25zdCBl
cnJvcl9hY3Rpb25zW10gPSB7DQo+ICAJInVucmVnaXN0ZXIiLA0KPiAtCSJwYW5pYyINCj4gKwki
cGFuaWMiLA0KPiArCU5VTEwNCj4gIH07DQo+ICANCj4gIHdyaXRlX2F0dHJpYnV0ZShhdHRhY2gp
Ow0KPiBAQCAtMzM4LDcgKzM0Miw3IEBAIFNUT1JFKF9fY2FjaGVkX2RldikNCj4gIAl9DQo+ICAN
Cj4gIAlpZiAoYXR0ciA9PSAmc3lzZnNfY2FjaGVfbW9kZSkgew0KPiAtCQl2ID0gc3lzZnNfbWF0
Y2hfc3RyaW5nKGJjaF9jYWNoZV9tb2RlcywgYnVmKTsNCj4gKwkJdiA9IF9fc3lzZnNfbWF0Y2hf
c3RyaW5nKGJjaF9jYWNoZV9tb2RlcywgLTEsIGJ1Zik7DQo+ICAJCWlmICh2IDwgMCkNCj4gIAkJ
CXJldHVybiB2Ow0KPiAgDQo+IEBAIC0zNDksNyArMzUzLDcgQEAgU1RPUkUoX19jYWNoZWRfZGV2
KQ0KPiAgCX0NCj4gIA0KPiAgCWlmIChhdHRyID09ICZzeXNmc19zdG9wX3doZW5fY2FjaGVfc2V0
X2ZhaWxlZCkgew0KPiAtCQl2ID0gc3lzZnNfbWF0Y2hfc3RyaW5nKGJjaF9zdG9wX29uX2ZhaWx1
cmVfbW9kZXMsIGJ1Zik7DQo+ICsJCXYgPSBfX3N5c2ZzX21hdGNoX3N0cmluZyhiY2hfc3RvcF9v
bl9mYWlsdXJlX21vZGVzLCAtMSwgYnVmKTsNCj4gIAkJaWYgKHYgPCAwKQ0KPiAgCQkJcmV0dXJu
IHY7DQo+ICANCj4gQEAgLTgxNiw3ICs4MjAsNyBAQCBTVE9SRShfX2JjaF9jYWNoZV9zZXQpDQo+
ICAJCQkgICAgMCwgVUlOVF9NQVgpOw0KPiAgDQo+ICAJaWYgKGF0dHIgPT0gJnN5c2ZzX2Vycm9y
cykgew0KPiAtCQl2ID0gc3lzZnNfbWF0Y2hfc3RyaW5nKGVycm9yX2FjdGlvbnMsIGJ1Zik7DQo+
ICsJCXYgPSBfX3N5c2ZzX21hdGNoX3N0cmluZyhlcnJvcl9hY3Rpb25zLCAtMSwgYnVmKTsNCj4g
IAkJaWYgKHYgPCAwKQ0KPiAgCQkJcmV0dXJuIHY7DQo+ICANCj4gQEAgLTEwODgsNyArMTA5Miw3
IEBAIFNUT1JFKF9fYmNoX2NhY2hlKQ0KPiAgCX0NCj4gIA0KPiAgCWlmIChhdHRyID09ICZzeXNm
c19jYWNoZV9yZXBsYWNlbWVudF9wb2xpY3kpIHsNCj4gLQkJdiA9IHN5c2ZzX21hdGNoX3N0cmlu
ZyhjYWNoZV9yZXBsYWNlbWVudF9wb2xpY2llcywgYnVmKTsNCj4gKwkJdiA9IF9fc3lzZnNfbWF0
Y2hfc3RyaW5nKGNhY2hlX3JlcGxhY2VtZW50X3BvbGljaWVzLCAtMSwgYnVmKTsNCj4gIAkJaWYg
KHYgPCAwKQ0KPiAgCQkJcmV0dXJuIHY7DQo+ICANCg==
