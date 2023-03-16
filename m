Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8CC6BDB04
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 22:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCPVcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 17:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCPVb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 17:31:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0AD19A8;
        Thu, 16 Mar 2023 14:31:53 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GJOO1g016849;
        Thu, 16 Mar 2023 21:31:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=kjwRztwpghzeD9145CiWWMgDW7T0HpAyIYs8zd4XhXE=;
 b=jAfnIv1kgV6k9TFt14hYJ3NVCVCD2SObQIJAYJIKw1Km7s+wpb93DAiOtjjb9hQAha2X
 HsCgoYNCRNYNzvDXqicehmwrFWMrjNgIgMhlIUAUKeIrj0+8FxPzjrtasazyLJFC3pik
 H3QWUdlPC7hgElT3vLEbWipxXHXXgOomU+hD3NmpplG+ClUg4GqP2f8I4GzLhcmGgF3/
 FJ6qfCCSoN6TKiSx7SXfUe4LqJt5i/hr8Uq8nf6swBdCempcRD9rXk9RW9sB8qWsZC2k
 qJpfa5+Bt/JEuvAcmpEduKncvCRjaQrvHBMC0EKL6ZYa/unm6DFC5JQumwXVLEarEHj7 aQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29299s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 21:31:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GJxFoc020550;
        Thu, 16 Mar 2023 21:31:40 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2045.outbound.protection.outlook.com [104.47.51.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq46x2jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 21:31:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tk1mRQcYGctCydYWv4BIVrNRIO3UV7mAJcBM3B+sf4/vBqBMPFGhVAwiBxGg7otnV5XSSqYFVZdmAeemZCH14LpXsdAebjZBe+iA6hfr2zbJ3ZOUJwpCemDXM9hxdzsWMP0lzNrGedgiUlaJcZZDo/RgD/1xD0qV7PyR2YSo0F8mu1r64Y++06NCd6adPKrIg6wYHn8QkDXiB7mrX7fB7yurybpg71akgryckJnxD7Z4vW7l8+emk4Lgl4mERNvQUuT+W+vun0+DnCooOl+76m5fkZcjt0NqEkv54f9wkd94tkKB7qjA0opi7qakOJE1/88H27Gq6oZl9wH1eVr5/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjwRztwpghzeD9145CiWWMgDW7T0HpAyIYs8zd4XhXE=;
 b=mElh8034FYU35EbdD4p0ePgqtLeyC/YQqGbnyTB4YcAcejl58OU7XEN9YhpWY6pd0jtf3f5Vo59RPQ2vz29by6bSF2qMglg6Xml2L9OhI242ExoeXpoNNeeUX17YwIdTuub6u1VpIOqrzb+H8LubZOUgQbwuDy6JUNc16Ip7iFrmVBs106N8Aa0VFOWbWcQ/f4QHWSEU13SZ66acYvNyAaZRViMvx3sh4VmShn41vwePzoVX3Tt4SbwiOB6v9MMp+3/TJypLPsvuEV65Ime390eXLidbBFVeyNVskYU/e9wBhYw7Crq9JMuQhqftUONnx6B5QhyFnSgjim9810a9hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjwRztwpghzeD9145CiWWMgDW7T0HpAyIYs8zd4XhXE=;
 b=u1voinHaeMd7lwd06W95VCU7iV0TGJSA86k+dZOvHoaevY05Ar6RkdvrD+EqdeA5P9G+1PRRqxyX5IYeQdr1r73JwTXGPq9lIA+NEuBHNNhCawSmiXk7vdtQv3GJYsPXRHRYeMzT8i9CZUA/ooaU03WE72X2ZCfo3XeM9zqWi1I=
Received: from DM5PR10MB1419.namprd10.prod.outlook.com (2603:10b6:3:8::16) by
 SJ0PR10MB4784.namprd10.prod.outlook.com (2603:10b6:a03:2d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Thu, 16 Mar
 2023 21:31:38 +0000
Received: from DM5PR10MB1419.namprd10.prod.outlook.com
 ([fe80::df32:94e7:3f41:97ef]) by DM5PR10MB1419.namprd10.prod.outlook.com
 ([fe80::df32:94e7:3f41:97ef%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 21:31:38 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     "# v4 . 16+" <stable@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] nvme-pci: add NVME_QUIRK_BOGUS_NID for Samsung PM173X
Thread-Topic: [PATCH 1/1] nvme-pci: add NVME_QUIRK_BOGUS_NID for Samsung
 PM173X
Thread-Index: AQHZV45nokIbA+QLzEKTFICk+DnoIq783W8AgAEQ1IA=
Date:   Thu, 16 Mar 2023 21:31:38 +0000
Message-ID: <930CF361-37C2-4625-B5FA-245248544F92@oracle.com>
References: <20230315223436.2857712-1-saeed.mirzamohammadi@oracle.com>
 <20230316051508.GA8520@lst.de>
In-Reply-To: <20230316051508.GA8520@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR10MB1419:EE_|SJ0PR10MB4784:EE_
x-ms-office365-filtering-correlation-id: 040c2ad2-2c0d-44e0-0137-08db2665d381
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OsDd82ZfobtM0eMHyNZAWiQ2USJgZz8rarFZNyVRouFlBiH+dxviI3G2u1+iasxjCFK0iGGhgjufQjO4hbZFR0i2upfC9RW9nAPlV8cCT7cJyYT42Vh2vfkaXObOI1EvN+GGjGkODiVEjCTwqyVMk2BRfzcpjCwSTG53KwdgaOKk7nAtP6NsJ/28o9mTSz7c/3oDaxaIxBvnMcs3PkJMfiugW7p9KNCG+a76yphjPSiBE4h5npJ8D0UokEOk/drTB7hL05onPSPgqMMbQw8lJXfkgK4WJB2AA1MzSiSxsTbZFkOdfI1iDU+qpXoYnqMK1neh0f24i8GZLomfKTsFb/3F3nyfDZqFnrZfC1XtSdJwXqaNcqhU1Pd8U0tWhRMvNZJJonwpVkmXG5yAmw4qK4tQa2x/faMWNHy9NGhmF7ZydMfbWTAZmDC2BacEopajETfgJGVEVr4Uvp47dBwdFjUBJ+MJSMOXrVqF4XS3vLOfxOQNY3vhgw3i0/2DsV+AIVHXTBzYIa42jdB8x68NuJYiE3BAvbwLPmMOZSX9Jn0b7v1ZokvU3VjemQxWF8PGHzAP7+pZTQjEZgjceE4TcSPMDWS0wjCzj4WNa6tGWNfZRRBjPivnzbcImOTQ0jQbXJlahd2Bl2QO0C0Xnl3a4J/1Cl+9OWHgctG80UNRwtACH87zfSfmWoJokUCxKYdNInTvWIja9usWeuyWVL16+kKfucpVsT/16awSrDj/v8s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1419.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199018)(41300700001)(6916009)(66556008)(64756008)(4326008)(66476007)(8676002)(66946007)(66446008)(76116006)(122000001)(36756003)(38100700002)(38070700005)(86362001)(33656002)(5660300002)(8936002)(2906002)(44832011)(4744005)(478600001)(2616005)(186003)(6486002)(71200400001)(6506007)(6512007)(316002)(53546011)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWpSai83MlBaK0xWVzNyekg0NUFkak9xTXpLU3JGeDZROEhhdXp1RHVyQ3k4?=
 =?utf-8?B?TUV1WG5Sa1hndmVRb0dXd3BITG1mbTMzbnArb0JRRDdhdDJGVjhPck4vMC9S?=
 =?utf-8?B?dUFFZXpMTmxxYjZpZEwwT3BSM2VsM0hPam0vTy9mYUFRN1EwUWJSOThNWVVs?=
 =?utf-8?B?S3VieVNud0owQlVjVHdsTWNHMzZZOGRiT1BBc3FmQk9tZDRnMStkRDdFL0lh?=
 =?utf-8?B?M1Q2cFE5dVRDdEZudjMvYUsxNnp4MFpvYWZxTUkybEFyaUNRa2QyMHZGeXM5?=
 =?utf-8?B?TDUrUURHMnRmSjcvZTBXMGNMWWlFZHpWcXVobXY2TlY3YjNzbm1DVUpMcU9h?=
 =?utf-8?B?NzkwZEhBQml3UXNOV3VMYzBRdGpQdTNVRTlNM0RJUGlrSTVUaVZ2eWRLTUxV?=
 =?utf-8?B?M1lVbHpWakE1cmFleURXbGszR3M5eS91MFlvUGg1K1hmOFNHbWI3YUczbXo4?=
 =?utf-8?B?NmxQMFBhcitPc0d3VmF1ZkIzbGhsL3Z4c3ByM2dDa1NTT3F4WkZ3YTdYcG9z?=
 =?utf-8?B?bVdreThTYklJM2wrbFIxRHZZSmwyaXBEWkFjclBEWEk4eFlkd1lxQTMrYkdQ?=
 =?utf-8?B?NVBtWnluRmFxUWdwODBmandjUklnUkZjNy9maE8ySktCQ0VRNGVDaXdrS0Mx?=
 =?utf-8?B?OTNyRHk5K1gybzV6ZVlOU1NWSm1icUlzallZaUdjd0trdzBNMEtraFptbzh5?=
 =?utf-8?B?aFBTcVp0eWpHeUNDTmtVRVVER0JsYU9MSGhyUk5BVVRPc2V2YjZVSk94ZVQ2?=
 =?utf-8?B?czdRSTNWVFY4UUxCNk53azFwNjhHeW14emJQL2hteU9wMzVnQTRLZGhKSFBQ?=
 =?utf-8?B?YjRaZlRpYjRHU0wwN0NnbXNzZStzTGpMU0FEcGZneUw0Unk0bktKNGwvTlFX?=
 =?utf-8?B?K3hQMWtsSklidllvTXV5RE9FNHoremo0Y2ZIZHg4dVp0WTBrS1V2NjRPMTdS?=
 =?utf-8?B?U3BuSkptRjR0Vml0a0VqTkVBb3hlUlh3R3B2QmpOV3VCYjBkYktYRm1UeHNQ?=
 =?utf-8?B?VlpQbzBEOFZZc21Fa09mdlRmVW5FZzVyRzFpM08wcU1RbGZUdEM3TDVxZUR5?=
 =?utf-8?B?YWZZWVZuK29IYlNnVlBCcHBxbGR4bGdtNmg5WE5XS09FWW1mZXRKbkU1VFc0?=
 =?utf-8?B?NU41OEJBZlJGS2ZyYnpob2RiNlVSd3VEU2daLy83bFE3WkdZTnJoYzVwbWFM?=
 =?utf-8?B?WVZsMTVsYVJGaVIybDBpOXNpOW4vendGbmtJdzRDWTRjVkdtMnNoM29OZytL?=
 =?utf-8?B?aWxzL0JYWFhOYzcrVzhpc0I5RDdMTjh3aHBpVGlhZVR0cUxoZ1ZqLzUzT1E5?=
 =?utf-8?B?cXF5MVFXOElrM1RSRXIzY0ZZZXlhRmtjbmkzU3N3SENKODMvM0ZEMU5CSGZB?=
 =?utf-8?B?NGFDSHRlb09BWDJ1dklHRHh1MWtjQnVhN0V5R3NKalB0NmtEcWhRSXoxSFgx?=
 =?utf-8?B?TUxiVGVBUjRlN29PMXljc1RVSkNFTEZEQXYyTTZlRFhUSlM4Mk1iZWZxc0Jm?=
 =?utf-8?B?M0tSd0hTd0ZhQlA0Y0JPdHBMTHM2ZXBrT24wdk1KZ29YTWQvZGVIMTlUNnJs?=
 =?utf-8?B?dUd3TmR5S3VEcHdlVlovSlVJUDZpa01sc3l0bWRlUmxZUVBYZ0RGckZLVCs1?=
 =?utf-8?B?bGZmNVBza2FuVVZYN04wL2JlVWZKYklVd29ibUdNMEhHRmRxQlFnS3MxZGZT?=
 =?utf-8?B?N1B2YmdVODgzZ3NsOHJaSkxJc1orU0VqWHZtMUNTVEF2SFh0V2x6OElaYVNX?=
 =?utf-8?B?WjU3d0pUNUdSMDV5RUc1eUt6T2Y3SWI0L2M5dnpZQkhQcTU1dmlHYU9MaUp3?=
 =?utf-8?B?bUE1RzlMT1J3bnBPeE1BVE9aVlFLeGtTOHEwRGNUZ0Rnd09aUUVESnZSckRN?=
 =?utf-8?B?VDlGQTZubEVpWDloQnJxVVZkUHRzWFJ3N3VwMlNmYVNXbUF1cS9rVUxta1U5?=
 =?utf-8?B?UXBqVDZTcGRheEQyQ0dqWE9zR2M3VW1zNjI5Y2cyaDFoZVFoUUdmL01Ud1Ns?=
 =?utf-8?B?THBkTXhCbTBqTzR6SjgwWE9HS21oTXpCSlZ2R1MxNjQxREc1aStOL05wRThG?=
 =?utf-8?B?Q2oyZjIwSmxGbWwxNXg1NXRYZlJJbjdoVGFQVE1NdStxNjI4WUFZYndRa1pX?=
 =?utf-8?B?ZDlKWnFWS1lQU2p1c29STHcycEhKWGU2UldYcXNzOHFEelR4WEdiSjB2K0U0?=
 =?utf-8?B?b0grUVArVGY2QUw1emNnMG1FOU83UmNVSVpodjY2OFowWTVJaXlJMS9aS3RL?=
 =?utf-8?B?dU5qQlk4YUlYMEhJK3JMOVRWekNnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA4BD4F16B81BF45B43CB07F815A0E64@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UqJEqRJMomWiXMaU1pZsrGqJxjs1WW5/AQuRTGzu45/lYeugzZ/CBD+D2HwXTTCqYVZ35gIhK46Qgj1ix3f40IZbXS2eLkA+gzQKBYuOf8PiYD0HNGeLF6arek8XqhFCie69qd3qJHAgSRdlA8/zUpkyRmKQkbohbXQUmbc4IgWrBZZiNUbHesOReHN7DNO2S9o3ncUXgX5HM+rgQMEfEInsR7pZIWHeNGUXRSb3rgWxAg1DDA9Ijhl9wfTY+gYnolAx7v/BAvZyD3BdzGnc5OFvFHmf1h9X2tOqSjKRneHK36ZVIlrUFKibTUyORR+JUr7VPTBOoCHqkwOx3hXv0HdA5Rvc4z+ffdlE/APj3xUkxlR0RH9vguLPHICewCUyx1lKDq7d9KZ72qnteMllQsKLHGaTou15HBVkqBf0ri5sFGYmd5XGQOXHtsEeRq9fHxAaljZNMA2Xdp+8tYuxPS4alb4qhL6UxFiMF7I56EhatUcaRL4ieW/WqyT8zgr34l9Nhclf/vnsuZY/u99b9v9xQK7aZ6n8/H89DjslBhAHwokcL9aLYv5xUbv7JttZjmhcnhUuFXUW5lc13cuHtCSAIcLPnFX0pGQUgc3QvgLF8iMTSFjsg/g8M+eB59yQMRorzV7lLsor+ugaQhUO0HlL1iyoMni7CN9VTo2KQjEIiFg0MszZ38C+mCK9LCuAopXOMLXeK3n4SA8i+GXkkxs/Js+u7iAjLcjJ1QZkWiQQejXtFst191oJJ4n2rsENIn6dd+qttUKbgbLETI5n+mCdsWkbQVWwYNMX5/L7BolJh9SfJVz1+Tm9PcS2BAxG3ex49IA7FkqMNuicbh0ixty/ZwHS9XZ7mEeqxAmQcysPj6Ak9oeptXcVH9r+jw8bvjnwpV2Mrpz9tMnWbpn6eGqOq4E+m970xkOgurynARo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1419.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 040c2ad2-2c0d-44e0-0137-08db2665d381
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 21:31:38.4431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7/9K+UvGpCV8/wq6fvrgnQNM1hY4jek2uTvMmnvfSTLwl14frpi2PJQDB6OzQ5AEj3r9Bh292PoD44vJCd8g3DihNg/h3VmBq3fdAhrbavQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_14,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160161
X-Proofpoint-ORIG-GUID: 31VdWnDBBTd1TzaOgl68GWH_cpUEJ-oT
X-Proofpoint-GUID: 31VdWnDBBTd1TzaOgl68GWH_cpUEJ-oT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNCj4gT24gTWFyIDE1LCAyMDIzLCBhdCAxMDoxNSBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcg
PGhjaEBsc3QuZGU+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBNYXIgMTUsIDIwMjMgYXQgMDM6MzQ6
MzZQTSAtMDcwMCwgU2FlZWQgTWlyemFtb2hhbW1hZGkgd3JvdGU6DQo+PiBUaGlzIGFkZHMgYSBx
dWlyayB0byBmaXggdGhlIFNhbXN1bmcgUE0xNzMzYSBhbmQgUE0xNzNYIHJlcG9ydGluZw0KPj4g
Ym9ndXMgZXVpNjQgc28gdGhleSBhcmUgbm90IG1hcmtlZCBhcyAibm9uIGdsb2JhbGx5IHVuaXF1
ZSIgZHVwbGljYXRlcy4NCj4gDQo+IFdoYXQga2luZHMgb2YgZXVpZCBkbyB0aGV5IHJlcG9ydD8g
IERpZCB5b3UgcmVwb3J0IHRoZSBidWcgdG8gU2Ftc3VuZz8NCg0KZXVpNjQgdmFsdWVzIGFyZSBu
b3QgdW5pcXVlLiBIZXJlIGlzIGFuIGV4YW1wbGU6DQpuYW1lc3BhY2UxDQpuZ3VpZCAgIDogMzY1
NTQ2MzA1MjkwMDA3MTAwMjUzODQ1MDAwMDAwMDENCmV1aTY0ICAgOiAwMDI1MzgxOTExMDAxMDRh
DQpuYW1lc3BhY2UyDQpuZ3VpZCAgIDogMzY1NTQ2MzA1MjkwMDA3MTAwMjUzODQ1MDAwMDAwMDIN
CmV1aTY0ICAgOiAwMDI1MzgxOTExMDAxMDRhDQpuYW1lc3BhY2UzDQpuZ3VpZCAgIDogMzY1NTQ2
MzA1MjkwMDA3MTAwMjUzODQ1MDAwMDAwMDMNCmV1aTY0ICAgOiAwMDI1MzgxOTExMDAxMDRhDQpu
YW1lc3BhY2U0DQpuZ3VpZCAgIDogMzY1NTQ2MzA1MjkwMDA3MTAwMjUzODQ1MDAwMDAwMDQNCmV1
aTY0ICAgOiAwMDI1MzgxOTExMDAxMDRhDQoNCkkgaGF2ZW7igJl0IHlldCBjb250YWN0ZWQgU2Ft
c3VuZy4gRG8geW91IHJlY29tbWVuZCBhbnkgb25lIHRvIHJlYWNoIG91dCB0bz8NCg0KVGhhbmtz
LA0KU2FlZWQ=
