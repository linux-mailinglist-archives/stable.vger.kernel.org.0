Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337056367BD
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 18:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238904AbiKWRyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 12:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237461AbiKWRyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 12:54:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AF56A6AE;
        Wed, 23 Nov 2022 09:54:52 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANHedPH006294;
        Wed, 23 Nov 2022 17:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=nEZKY3cYQvi6llmkgS2lgDkSrNKUslHwGSoyl9pGr20=;
 b=3X4QB67dqCoqNOcOzfqLxiVLunQdk+WZ2c/fN5dxk8HgN67llfQ5TZ8kL+lOj2upNjNN
 g3r8Zr26G9h9BYtDAuSlwRW6Z+V+6kGlyoRM94ErSlXHqhy/ya5h2q7dDNnDfib37aJ+
 MmRpO3DRLJhHuwvMNNy42jkUMlkMWYO6aS7cRLPPkf9ayxcRkoajP+izaepPdDZMor8E
 CZaTXiV9jnVIgm0D86H9d+2/AYIRr4HFOPyNRchH8Ha5coZOIJ0XXH8fv3ifThUr8NgU
 J9HFV/FOu6/C69Gq8heyB/6vQrrhXJf0ci/pohdwmcH6EB90wtvnzJmmpal+4jqZ8GY4 NA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1nd88jbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 17:54:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ANHDpnL010770;
        Wed, 23 Nov 2022 17:54:40 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2049.outbound.protection.outlook.com [104.47.73.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkdfbg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 17:54:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjPqmmQmqkLAo+cKL4skMjLp2lkWAQeyobKhoKYMDEIz7xpCzKCM7/0p0/BqR4R/N8H+iRXxLYcsIhJbw3ViR5Wo0a+KjoDg5CWjynWEPogRqlJKzH+cXiZQ0mElUowLFG+pDScmtZV8Oq4Zn85SKW0YrFTPv9ik9IHhP6KrWHfTchx63ESyN/LA2ktxl93wbNE751p26DZlX7+0gMkLKnyOc+wxz5ooJCSY1j1AHWdQ/8LNhbxl2HTeCfj1vvjF2hH0Ktmr4InXj4e7YhPhAZ4Xx34ArSeiVn16+dF0RMdGoQPaeOBpTMFQMB543ZG4vbQYTnTMj82LcdHnFhAPOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nEZKY3cYQvi6llmkgS2lgDkSrNKUslHwGSoyl9pGr20=;
 b=dtzAXdz2jYMr1TE8ybezBOR0owTXGN4lTrnqkLVZCcTI6pHj3sZCm0SbSvz5+oAn4CSXRXoPC8TGY6DaPUESdI/MLdolXFNPoKDBp25PpdaBIw5db3LAwLQ3Uj105FRRoe+ijEOBZOl4xwgfrI6jFvdwOD6b7hAChdG/aEI8/ZwLvkOtlGfuGqH3i1uR0qH2XvX4xb15ZXVD8Wq/zYefFya9pMda1XMbMEgzmMC9i9nCo3LU+cAXK0JLfma499b/9HZY4tiDJQ3zHey1pT2lZ0P+yaK7d+8WJ8W3cpnKb16b1OIy9aS25G8spYKm8cx0gh8TxGoMFw9dXnUktyvHDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nEZKY3cYQvi6llmkgS2lgDkSrNKUslHwGSoyl9pGr20=;
 b=Os8hs4570rMmfLwT8OxLoMLpHtOU74yA6F8Hziwr5dGFzq0uvHvkkxqaYt4g6f7kJe2u1zUrqenz47iQr+XrDwGmRFr0VRB7xXU+pJLDrflBIu/rYrVPfVb7z2mshsCtISrGTTR9rFJ41xNDMCQ5oydjg16bvyhPe3AcnhQPgtE=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH8PR10MB6525.namprd10.prod.outlook.com (2603:10b6:510:22b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Wed, 23 Nov
 2022 17:54:38 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::b500:ee42:3ca6:8a9e]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::b500:ee42:3ca6:8a9e%6]) with mapi id 15.20.5857.018; Wed, 23 Nov 2022
 17:54:37 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Anders Blomdell <anders.blomdell@control.lth.se>
CC:     Jeff Layton <jlayton@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] Make nfsd_splice_actor work with reads with a
 non-zero offset that doesn't end on a page boundary
Thread-Topic: [PATCH 1/1] Make nfsd_splice_actor work with reads with a
 non-zero offset that doesn't end on a page boundary
Thread-Index: AQHY/2QsqGGpH6E0p0+3XcdGTC+ryq5MyoWA
Date:   Wed, 23 Nov 2022 17:54:37 +0000
Message-ID: <A81AF482-D4FE-4449-B42F-FA31651F93BD@oracle.com>
References: <ba550d60-7fd2-a68f-0ea1-798fd9eb3315@control.lth.se>
In-Reply-To: <ba550d60-7fd2-a68f-0ea1-798fd9eb3315@control.lth.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|PH8PR10MB6525:EE_
x-ms-office365-filtering-correlation-id: a31b4270-d67f-442d-9e00-08dacd7bc9fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3TxoW6327r7l2EiBjxkUPwsnfq6JpWRbLX7jUKMK0YV8+jya0acV5XZhyPO0cqaVm2rWuSs0sNvmQG31xTXzYLbWJIRw0Srz9vPSmtU3YeIwmT0vqN2bA7+jGLM5uGTbbbceYQWo8/FfjZYepE+h968N0kjEISTSS+j7oRRDNwL5pyhCntUZ5mMsf5Jp9ICA22aBKUIO8KSFdTU9GIHHroPQ2Vzg8eTU7CCU22s+GpixI32AKv3X0gcBFEfBpAu1sSkv5DvYtvUdDWTYbh6MI6r9VgLo5inNZvGQm0th5nAIjF2jtrCkFl5uzFznFvbOM8DpZ+AINTO3eFMg9YYKsCI8tMYsTLmkPMMi8NlYZF+1Iei1Sdgrx5PIY7uHu9j7W4D7CFioKApozrRIShasWJYDFUTfN76xwL9+j5u4L1bw1H13fSY3NY2NZwO/LBAP43zsbNykyPjOLSBACg3M5pedY9c4aS5d61zDzwBSj2iz0wa8PN/qkKHxzYagtZXpDvYVuj8mwwJfCtokvwxPOSUI38OIjG3yoA0uL2VKatx3AvYmvwZrntUjIFBxaqKIIINbo2VxUpHmgF5taQpycYLByEP34jHE7Mq+CwqzthQaNwefcuCC7ZA3D50Ekv2mU3vbyCqMy0dOmOqje537Sa3r5BjsW4LJKgL1JHIW0fGVy5507k6y/5S3twKDHVcqD8ED9T1ER2IsolWMww9dBzdt0bAXD1CICvwtDuTvTinnY2ocVC9mHHeS9qU17VfvH8BpJmdedOAfoz9T6C8RKtge0EXBkWzZKfRdT+RoDg0iVd+msHIhfM+Nn5Jh8kVR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199015)(33656002)(38070700005)(86362001)(36756003)(186003)(6506007)(122000001)(83380400001)(38100700002)(2906002)(5660300002)(66556008)(2616005)(6512007)(26005)(53546011)(6486002)(91956017)(54906003)(66446008)(8676002)(71200400001)(966005)(478600001)(66946007)(66476007)(6916009)(8936002)(64756008)(76116006)(4326008)(316002)(41300700001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VXoJRr/+iY67B5AVj4AwgP14BeDBx0V5AuZr0aA5dAdV/J/LkoUDwiOELZlG?=
 =?us-ascii?Q?v2A6O77TKz3KXrkracbNlgmJ8ZhGOKizNCblAXa8ixnHrM3jCJmYVZZYhbeb?=
 =?us-ascii?Q?sIFDDIgC102afnzk0HhM1VOouXBmEM4Bo+rucZGXEX8cseDDg9VVElPZPcE3?=
 =?us-ascii?Q?rN7Hr60wsoHvbZxDYk8jG6F2SjOyb7aPL+Ip+LP33GGmtq9uyghMMEfR7hho?=
 =?us-ascii?Q?dHIZZRRxhmVtuxw3QHq+sxfEdebnf58pKyGq1bO2uPoUmM2FdkpGEhRRzd4Y?=
 =?us-ascii?Q?iXa/jBCQBM9JRbtwkzYowV0C8Nnyp9/Rn8SDtdXup5eUA7O88iYSRZ6iCptD?=
 =?us-ascii?Q?FTisa9oL9qrmHrW3+JUFfDVREljTZda+YZfPZIvKcWAp0kjuXegJni7CW+7N?=
 =?us-ascii?Q?dAj8nL3KLkRPLc3i99Hg/YFI7f9n+CclQATJI7y2+ecDlIouNXLBB98AMO4y?=
 =?us-ascii?Q?dzyRFLRtFe7Ys8YQXNjtVIOAeZ6DQsldcKIiWj+gZX3s3oD3yxfsYyEtcU0P?=
 =?us-ascii?Q?ydPyItdz6VI5knmiXvuj5Ervi0T7rrXPTyyTr3JouxxKbQVrV+oeT/Q3Qi7q?=
 =?us-ascii?Q?BCKOX/9r22S+MlRALZCIy4NbLKmMss4Ls8qCXL+mkjcIGrk2m4oSXc/Z4pUG?=
 =?us-ascii?Q?h6w+/Ci/DEqUzDPfyOUOwAcDmwPEkF9vJw3C/iKjjBr78H+c9M0ZNosEbkgc?=
 =?us-ascii?Q?GqzQ2buiguYmqQBcA7qezlP41FE63uCQCuDTahtAUlXXH3tBreoAJKS3njOI?=
 =?us-ascii?Q?KkkumIgbKRsB37E7zgOPwDd0aBXB9waQhCJ0kesE6uxqyfRIUP3SD485Ig8S?=
 =?us-ascii?Q?0FvAgx6IPX1jqv6UHe/9nknyTAXs2ALAZZB42fKfmDutISLU5GasS5xUEsHQ?=
 =?us-ascii?Q?LZlLU7xYY7ktD7GAM/Pztez3urqtpMPDc0ioudfpJVjmWA1D5gyV/Ve4UhqW?=
 =?us-ascii?Q?CuifdEjmTc3p90aGbsf1srMzxfy8TsNQXVfLeuxIZ+fnbCkY2UojijndUUbr?=
 =?us-ascii?Q?PscgSEB1lmMsTYYfCXI7k2TQ7myaNH2Qb9yTn5nHeR08F0WSQgY2OSFC6lWe?=
 =?us-ascii?Q?KPQl/8G0Sfw5VI72udAN6ea+fPofMOw87dG4GXoN67hPZG4k9oCWMwZ90do3?=
 =?us-ascii?Q?/8d71vGSMIYZ3JYekru6b2PC0sWcEtngtwMbJ1hOPlpYVThaes6wLY9zlehw?=
 =?us-ascii?Q?Nk90npyW3tvR6ObWUNMqzU7XH4Xuu/qt9ta0IfHQS8J0rlprmkzkKvIDqjYZ?=
 =?us-ascii?Q?/yID+WiJwsiOHBrkOE+dYk5R4JG9wuwhNQ8y06j2W9RHxkI+oJX1CkRCfPIw?=
 =?us-ascii?Q?2lUednE4cVqL7zeeAGDS2WZVI0VZzNGdLYN3rIs9TEDGVMnk1VEzpWQ5T3z0?=
 =?us-ascii?Q?GtEwsjDh3g22aEe8iJmxAGNAl714+AOM7Qhx3E7EP6M+aBk+EExIhb9L54xf?=
 =?us-ascii?Q?fNCgVx0zwjUkndLoo9JqVq4kYTLOur3meR9WmKOmGCYcR4hyOJ4/7RSHp5F7?=
 =?us-ascii?Q?2oLkm3xh4PzLtt4+CSUWzBJFyqO7Z93MsfT/4fEWzHZtB+OIi37gq2wfKZF6?=
 =?us-ascii?Q?+RGWRQ1Ab89QlClIHGhgt91iMgUu44ssFpjVAP7/3HMwDDc+aeZ2rXtY62lV?=
 =?us-ascii?Q?Xg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BC9DFC56CF5DF243AB03CB1ECFBB7F3F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?BS/AQlXl6OlL3i4vB4DN5f8ZonMySonK0CJtBrLgd5GxPr3ZnHjdNq6MUcnf?=
 =?us-ascii?Q?hLX54auP84lsyxYL5uP5SDjMJ9I32CbZI9I+KIJBpcRopV7NpYVvXCZC+IGG?=
 =?us-ascii?Q?9jESvT8Hi8MR7RVU/3YZGfzzCTG04LBsC0DYSjpR5c2TKq6HEXNi0E2VvRhN?=
 =?us-ascii?Q?4PKlJaOTru+WhTDTdw8BbmSkMRTSPTi4o0i2V1rGJZnrHTPvxTdUk/f0vEO0?=
 =?us-ascii?Q?3NzAsBOwfOj9vPPX5Ck1jJOZLwZVKTUl4rY80G1kRZuQ1csBsk5Dr0812if9?=
 =?us-ascii?Q?0qfYXkYkR+KIXGFxKEEhHrx28LFDBdGBvhutQr9WUJA2qjLZQf3TU8NzGv18?=
 =?us-ascii?Q?yCh0rmnYumNdx5Ld0m1NfH5y0xKlHQe2rmLyJ5AoEsoZhlQOCaoV6PkvRnJ4?=
 =?us-ascii?Q?wiy4UiGsxsow++pD5WooiPBoeCSDhN6bwC4H2Ww/dEcmUQr74lfPTQudRiBH?=
 =?us-ascii?Q?AUsg5Td5+DizFUOA23Y1UazY02TCOW84oL6GBJUydom2vlMcyk0Rwx47yZ+G?=
 =?us-ascii?Q?sLnk71/ur71rV3Lqaix7n5gp0aZ0y6BpRi//xKGoVPb8uMcUWEZ7JCFZE2S1?=
 =?us-ascii?Q?TAvGrvmhlxptOSV2QPqGSO15KrutXbRCuT9X/AbF1BCOrCwxtgaz5u1IN/P/?=
 =?us-ascii?Q?9it7IJLFIz4P9tUzDl3+9r98YslfnNO4H8NGx+s0+SqwGyuhGA70u1jExI3U?=
 =?us-ascii?Q?UbgKnpMTAVaC65UiXPKQIDe0Ulytm/jFTt40yeJh/uQ34m6wNUjeMpac4mA6?=
 =?us-ascii?Q?Yp50o0NXfj/WSzIDB5Xq0qAZ2urJ3HOCnIhrGMV3TWJh7SRLRLG2kgCozMPd?=
 =?us-ascii?Q?NhuxdcbuDtJ9H09vDVe1XbXhDefI4O0PwKhrF1KwtuFp6D/J7Rqq/Yn0lKOQ?=
 =?us-ascii?Q?1tyMPynvaxRdZ1uCVk9keZIQPK8OB3uSYs/5foJNJlRwsEw23Pht5kyj7oGV?=
 =?us-ascii?Q?qOLI2gJ30BWePzD3fdB0Qs5b+fE9HXDGy7DkX9M/4X0s0dz4bYM/cLYbvsU8?=
 =?us-ascii?Q?RLsz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a31b4270-d67f-442d-9e00-08dacd7bc9fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 17:54:37.9415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BqlX8eY6U30i0QNrAmRThf9j8jCqguqsxZtrouOpCAUjWb9zKXcJKJkVpACfdGiDUBEwa9nd/QPtzKZSttFN9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6525
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_10,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211230132
X-Proofpoint-GUID: 7DQ5VU-j7xNy92k8B2xAVSSEHK57TObx
X-Proofpoint-ORIG-GUID: 7DQ5VU-j7xNy92k8B2xAVSSEHK57TObx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Nov 23, 2022, at 12:50 PM, Anders Blomdell <anders.blomdell@control.lt=
h.se> wrote:
>=20
> Make nfsd_splice_actor work with reads with a non-zero offset that doesn'=
t end on a page boundary.
>=20
> This was found when virtual machines with nfs-mounted qcow2 disks failed =
to boot properly (originally found
> on v6.0.5, fix also needed and tested on v6.0.9 and v6.1-rc6).
>=20
> Signed-off-by: Anders Blomdell <anders.blomdell@control.lth.se>
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=3D2142132
> Fixes: bfbfb6182ad1 "nfsd_splice_actor(): handle compound pages"
> Cc: stable@vger.kernel.org # v6.0+
>=20
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -873,7 +873,7 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struc=
t pipe_buffer *buf,
>        unsigned offset =3D buf->offset;
>         page +=3D offset / PAGE_SIZE;
> -       for (int i =3D sd->len; i > 0; i -=3D PAGE_SIZE)
> +       for (int i =3D sd->len + offset % PAGE_SIZE; i > 0; i -=3D PAGE_S=
IZE)
>                svc_rqst_replace_page(rqstp, page++);
>        if (rqstp->rq_res.page_len =3D=3D 0)        // first call
>                rqstp->rq_res.page_base =3D offset % PAGE_SIZE;

Thanks. I actually find Al's suggestion (posted in the other thread)
preferable. Can you test that and repost? I will then apply the fix
immediately to nfsd's for-rc tree.


--
Chuck Lever



