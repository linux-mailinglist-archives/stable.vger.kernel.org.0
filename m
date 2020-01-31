Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A9A14F0BC
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 17:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgAaQmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 11:42:09 -0500
Received: from mail-mw2nam12on2063.outbound.protection.outlook.com ([40.107.244.63]:2369
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726322AbgAaQmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 11:42:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pqs5OvL59JnA6XPraofaJkdXrdt05ZfqOIv02mIOt/Ur+noawJBD6uxjn35uKrPPqip/4bEZx7GYiIAKC5Q+FcY2dgY5DSUUSSlnXNMltSlI0xxzIzCtPntbsvKMtW8KO3AqzSaonSAo0exjL7uF2NZvZRNlGasmcmYSjbThriMZhNmH+FFCPAzQO5KXlevlguGzpxcLpvMaUi3Q4zvd0632Q8ENYKjFkF2Q6rDtkaa/63PCuMLDfuNHhdPDq1e4JtxjcE0+2hibIL/ehRY36KsjUB3S6ZA8cg6UceAAQM1N9O77PD+b7AFcVDgwSBn8CU/T4kBJDa2FlIe7hMOLIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6TTNPSYcvPApz46hRoiJySiVL+YpOUXThrEjgqaJI8=;
 b=msAAFWvlG29U3v3H78MRCJwtEOrBoJvlUXvuU+LPXFHka0cRFn7GsbnfJJUFwu1bwwd7RSW6Zlfy9CDrajrvmd1sHh7aqCIZMiFEM1bbbn2Fjcsac642JXT2rpaSKFb3gXB7ljvB8rL0A9VbQm2rxWOJnOymxoK/t5yUT4OQUCXRSyUCBShTD1HZnTZuNkaQ7+HenjcYSreLgqZPoB8y/bH2Zr3MwvtmXczW0ZtcWL4yGyLQVwiNKh2rLWqcEe9bTM14sOjRitROVEtnzJGuSq9s8uTVq+CxV6S7pSehjd/v9JY6l/SJCeSMiO3x/3mZJ3nMd50ibPMnjVlUFq/P9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6TTNPSYcvPApz46hRoiJySiVL+YpOUXThrEjgqaJI8=;
 b=QSsyBIYsK/vrFxPDRv0lp54t6y3tHWYTENqD8Ox432f6PRaSnrsA6Y7hrKBGORh/gsEDFi9YRQWc2KdMJMI1PbOLj55RhUDL02gckyiTta7cZDbUMTwQB3L96EVo/m5uIi6ds4p8vXBr9X1C/nLVMUvBan9PAAGDV0Z87kZxaEU=
Received: from BN8PR10MB3540.namprd10.prod.outlook.com (20.179.77.152) by
 BN8PR10MB3139.namprd10.prod.outlook.com (20.179.140.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Fri, 31 Jan 2020 16:42:06 +0000
Received: from BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::6922:a072:d75e:74ef]) by BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::6922:a072:d75e:74ef%7]) with mapi id 15.20.2665.027; Fri, 31 Jan 2020
 16:42:06 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: e1000e: Revert "e1000e: Make watchdog use delayed work" in 5.4
Thread-Topic: e1000e: Revert "e1000e: Make watchdog use delayed work" in 5.4
Thread-Index: AQHV2FVfbX9/ePjF/0y2k/D3g6Oxdw==
Date:   Fri, 31 Jan 2020 16:42:06 +0000
Message-ID: <7b4b20e95883db121b9aa539bea82f9c93390e7a.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joakim.Tjernlund@infinera.com; 
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3eb2c5a0-a8e3-4375-97c8-08d7a66c824e
x-ms-traffictypediagnostic: BN8PR10MB3139:
x-microsoft-antispam-prvs: <BN8PR10MB31391B2379A9FC18AD8E7B7EF4070@BN8PR10MB3139.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:288;
x-forefront-prvs: 029976C540
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(199004)(189003)(71200400001)(6512007)(4744005)(6916009)(81166006)(2616005)(8936002)(81156014)(478600001)(966005)(36756003)(5660300002)(6486002)(64756008)(86362001)(76116006)(66476007)(66946007)(66556008)(26005)(91956017)(8676002)(6506007)(186003)(316002)(2906002)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR10MB3139;H:BN8PR10MB3540.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: infinera.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OrneazfrR/eHsTZhvYgbKxM7FYIMzfyYdp37LXFxM+FdD71XHDjRAz95QVS/sScpKUmlAIhItPlT2BZ3G6CHtCych+z4l2YG6BSQn3x1y2C/zraqXoMHh2Jy+k5LddsBQVlL+N/q0hcDO81KUFRkVhzWv/oU5bq28huaoYyGJgTFS61dgOXfZAIYmpNylG4XLXPgz08kbfaz5NNrxXxp6RFsPqavhFwHLXKcYR1PVmwhX8jIklyRdvWcCkZc/YoxaKWYVjiLh/e4kGPuWLWQvP/+oFLspDoG35GgNzmW1tpB7GxAy0KNHrwKJDa8J5IEGUKUkDIK3TuDlqcyLKONEfltyJOdgLBUWYFaGOrOw5qLGvRcvoBwYsUVqQbg4uwEx1Mlvjt+KPv1UBiDfHKjYMp2B+BuDQsVACQcGDGdbCgGCe5a3Y9r1EwMKGYx+oe4gB6lVmnE0oBnQOqTVZWGOKJ1/y6vlcYuuY6yJOS3pCDab5eI3Gjk5MlBRST6GC1AiWEkPH4F3wWYj4p6o1KUgw==
x-ms-exchange-antispam-messagedata: ItAjSi53xvGGiuK3aVJQ8jKvYhMNHXTrIsRjmASzh4iBoe/kYfSGGtGgb6Z/mKmL8XM1gp63XnQy0iNPmDG4pPFwIVC6m7cFa3TQwYCWOh6L6TajkRYywvA/r5IUmsX0b6UpMBD39abgvGg6qwh3GQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1D212B2F3451F428F611B681B214D8D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb2c5a0-a8e3-4375-97c8-08d7a66c824e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2020 16:42:06.7982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gZeO6NvUbe/iJjX6FugxtQqp4Mb5NmYIrfWin5NRHlp/W4RIUu+ILRxcPkDEdTmo1KQWO9rPuUBrre8eHVwKZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3139
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T2JvdmUgY29tbWl0IHdhcyByZXZlcnRlZCBiZWNhdXNlIGl0IG1hc2sgc29tIGUxMDAwZSBjYXJk
cyB1bnN0YWJsZToNCmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwv
Z2l0L3N0YWJsZS9saW51eC5naXQvY29tbWl0L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2Ux
MDAwZS9uZXRkZXYuYz9oPWxpbnV4LTUuNS55JmlkPWQ1YWQ3YTZhN2YzYzg3YjI3OGQ3ZTQ5NzNi
NjU2ODJiZTRlNTg4ZGQNCg0KNS40IGRvZXMgbm90IGhhdmUgdGhpcyByZXZlcnQsIGZlZWxzIGZv
cmdvdHRlbj8NCg0KYnVnczoNCiBodHRwczovL2J1Z3ppbGxhLnJlZGhhdC5jb20vc2hvd19idWcu
Y2dpP2lkPTE3ODcwMjYNCiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dp
P2lkPTIwNTA2Nw0K
