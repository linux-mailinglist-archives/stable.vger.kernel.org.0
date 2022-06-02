Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B21A53BCF9
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 19:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236753AbiFBRFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 13:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbiFBRFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 13:05:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6FC91584;
        Thu,  2 Jun 2022 10:05:11 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252GrsRr014288;
        Thu, 2 Jun 2022 17:05:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kCHCxu5woqrCuD/xxKFqbyVrK19bTo3Zyz9/R37oBPg=;
 b=POXUbB6C0jsAUAfXzSXHB83/AQqzvAHKtV2fG192n3i/Ow/P1+V+QoIEpfiOlnp+35mw
 SNJy5X9s7Vo2FWELZK3NP1Mhqt82lrzzgrNDcpyqdKUjtepW/s1zEQRNqOUeUqdV2qbc
 ypIfmao0SKCpO2oou4hYAE5uZ3DqCgZy0XKJS1Y6eqHyPXPTYdus55usvTCqhcxBmu3U
 0Dmuo63iwBUnRA1bb0gkp1KHj5pRm/B25uEvY1wdJsYZxjiSj58PcYGD17i7z/XwEi0U
 9Dt+ZfCwzlu2T8NNnAiB75h+3ljHKVSd16FvTqlG2v3P7mYXQHIudTNbB01VM1QFMxRQ 1Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc4xu2j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 17:05:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 252H0sth014189;
        Thu, 2 Jun 2022 17:05:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8kmu3by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 17:05:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmcN0Z3U+7qCoNdZ8GGnz/5L4iUefQ+ULZ5bZ9A5Mda8jcfRhFN/ZaXp+80w9H+SqVoP00YCDdnwcLvzByVNSs7+1aXSMz+W+4nUTOA/oyxTyg4nAmxIyCbBbi3nLmbw6/1AtAXzRavnIFt20293Xiw2mfxfcOqJ5+VtRWYZBq6u9SWSDtaqXtuokfo/D4tAyVxcTJz8mKbKaPVlFkQPuveeP7uXXGDbNnumKYfziIb/SzatpZ4BQO3bf/KGVl60uS7Bj+/4RKf3shJdOPHDqRAz8iE9/46YPeXhi1b1VI4SWceK6pRumreozvnaT98HJZ3ZJOCG5A6AK4QCOB2nvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCHCxu5woqrCuD/xxKFqbyVrK19bTo3Zyz9/R37oBPg=;
 b=gSXFj3+KTOBL+UegfTJ3sGYqLEUzjr6FWG5KxxRiCdqU8/097DQjIt/H2S7PGhrzZ+Vg4AWlDPnta7XerQh4+6Cd4mmT337g1EJAMuebP70iZyErkAGz7rmTW4rt4Xo81IwHkHacACFDudouTByqSEFs4XkRr+Sgkh0Shpadd05WhgRUV4kHAmCMZPFOmDAUl9Fovc2NZaN6I5BlBOspeVla6l2tXsyKQDHgYn0h9CySDMUY/GdE2vQ+1npFjOPweonWywDVfi5JVazp+PpaJ5KGhb6BqjiM9UcOMvD3+YqFSZ5qhcCaczUse6Yn8WQkdMHcVa5iWpEjCat+DOd33A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kCHCxu5woqrCuD/xxKFqbyVrK19bTo3Zyz9/R37oBPg=;
 b=KB8cW2+Whr4RWY4QhxPbRZwa/HghwBOT+12jsEr681nm6ODjXPnPgoeZjCibuK5HxlH8vf1PprpgXyb3hiOvI3W9hzIAUxqij4amW2ZLrs8GPwT+uC55abXF8Dk0r+IrLywXNQ/1b6PUqd1l8b8Q3pAGZ0ftI7NUxJTcWY+BaLg=
Received: from CH2PR10MB4166.namprd10.prod.outlook.com (2603:10b6:610:78::20)
 by MWHPR10MB1359.namprd10.prod.outlook.com (2603:10b6:300:1f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 17:05:02 +0000
Received: from CH2PR10MB4166.namprd10.prod.outlook.com
 ([fe80::4421:897e:e867:679c]) by CH2PR10MB4166.namprd10.prod.outlook.com
 ([fe80::4421:897e:e867:679c%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 17:05:02 +0000
From:   Stephen Brennan <stephen.s.brennan@oracle.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Howells <dhowells@redhat.com>,
        stable <stable@vger.kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        keyrings@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] assoc_array: Fix BUG_ON during garbage collect
In-Reply-To: <CAHk-=wjHHg_buCqw=Q2OtRWoFpD67OxsQ0jMzao+6rGM6hRE0A@mail.gmail.com>
References: <165295023086.3361286.8662079860706628540.stgit@warthog.procyon.org.uk>
 <8735go11v0.fsf@stepbren-lnx.us.oracle.com>
 <CAHk-=wjHHg_buCqw=Q2OtRWoFpD67OxsQ0jMzao+6rGM6hRE0A@mail.gmail.com>
Date:   Thu, 02 Jun 2022 10:05:00 -0700
Message-ID: <87r147yp1f.fsf@stepbren-lnx.us.oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:a03:74::36) To CH2PR10MB4166.namprd10.prod.outlook.com
 (2603:10b6:610:78::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 583763ca-aa4f-401e-5a1b-08da44ba088b
X-MS-TrafficTypeDiagnostic: MWHPR10MB1359:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB135921A3CD6A3B51430B7712DBDE9@MWHPR10MB1359.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nsf365t1g5yA3jne8Hy2H5wu5zRyu/+Pr/Y4f6PCOAiDNixZveQdWDeqNHsvgqwcHtQuLDF+Wk38WrEqKzW3KZJc8CQH3pA4bJLDXtczyjixS48+RLOknf6MzhmiNqqkIQsRAIiTu+rGELDDB5a7wDd72lM1LsD3c9oBasNShHNcL1YHZfg7+nVeI2NzjmTqiw0ZHobw4Lq/dDddoTQnQ6AJ0+JpOlYbrMoEtlCc9z+hgw75T06YWTRVI4Sjt998e6wPdKjtMQfVvV1ryNSlkdWbHgqdnI/ejULHkv+dl5llsizwQs6CusTYYA+zqrPKA7dv1ujbREWXznB+FVqxwLpRnxTM85CfraEJDWhD1FME2/O065Waz8Vnz1eVJOViPRiz14Bskei8uFsKv3GT+BT1HHyPXOmVWEYQOkFtubQaSenGpQE7mcfprLBq3DWBKqzEPLkH+SQVo+7RgWkurRBpkNFjZ38Qn6/9iFTeu1PEDEwm1x+e62DIwDhJp1XPDucTA070gPtHU4rE5AT7w9DJrOU7N3+xih2nxMsOP1sDvhSIZuchQk3OKDdx/lcQB8CyUs+Gb2o4B5hoFVje7LnYz1bXROpQXRVGXSiezkQLTIDy4UoueajQSLCdgwP4mTFxobbG8y6/sMlGON4dfpQ/6Qk6REq+ehOj2LGBqpKwZ0jrwT2ZWN0H8QPwXflgYRqoOp74n2g6QOeTzPJDhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4166.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(4326008)(66946007)(66556008)(66476007)(86362001)(5660300002)(38100700002)(6916009)(38350700002)(508600001)(54906003)(316002)(6486002)(186003)(53546011)(52116002)(26005)(6506007)(2906002)(6512007)(4744005)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aGxnzp0zKIsA+CuGPkBjQHPE18L27HcXciPQpmoVqcKcPoCO2ti04aR3Ij5n?=
 =?us-ascii?Q?9iVBOY1VGKIxMsbB091QRu1hZk1uMkjX+qD0g8gu79QVz7FN0PR5N5SIPO8M?=
 =?us-ascii?Q?37gMWasZOUEmxi+aUGcBsKSzDXoI+CYbPUofaedzuWqrWhoLsOUFhFX0mya5?=
 =?us-ascii?Q?kqxOXdFgv6opMnZ5oOA/3fb+7mZvxoZ+/L6+wuQftNdmeCpQIKeKyUPaLFT0?=
 =?us-ascii?Q?elSJnmV0w30JOkkSZvFNQ2MB6W3byxcpVZlO9OFFvxCSLgGEO47KIWNPtDmb?=
 =?us-ascii?Q?GNm3AtFmTZYqmCpj7csUfDBBVg3zX/YioCEcy2qzdus7yiwzkJ0aIJRx3ZVw?=
 =?us-ascii?Q?ZiV4yX3jqSHuE6nTIFQHkdDy6o/9MhRzGYRaHRFISiHY7Y0JV9jpxOMC2Lug?=
 =?us-ascii?Q?R8hxJ5MKXPHa+GtDuQ80TlUmNF+uj3hxjWW3TeaOV/izwL2TNezLQP2ReDsW?=
 =?us-ascii?Q?hTF+KaautqJj3pDvLGcEC3E7MHZq8uTZyL9B6/8OBcwjjerjGYVNPplwXR+Q?=
 =?us-ascii?Q?upB8SnXvODLr2yYKXRAOowrnlejyCws4UgV73bLTXR+3pNHKJQ4nxzjsUn/m?=
 =?us-ascii?Q?5e43CGzUl6jUHaJojRmcEGQzfNoLw234DkZ6vLMYZFI2r6YrwPTfXweMo68a?=
 =?us-ascii?Q?VN+ZhfJaQCV0JRRJLrW0kIluUf5tFGd4i2diixZOVp9Es2t0n2gEg96Vm7OG?=
 =?us-ascii?Q?aQb2XyhuEXSUDyQ+D5xFIks/0M07Y068MOy/qGv2QDfUGvthH5XN9fRfYtJA?=
 =?us-ascii?Q?yQMVAE4EUAhcp1qwMCHSivGmL5v4oWV/E2h4dKXYr/vZb8ThqOk/FAXQISh1?=
 =?us-ascii?Q?59oMc9HA8aRxp3OgXOXBPlKMTdAjM/wTPxO0Lwx0+swT950msl4/Qazcxkyb?=
 =?us-ascii?Q?8xD7U3QXSLQVqwixgo4oeNou7ANXv94L7gbs5W4tnAB7C5Ss2DhRk+rSU7zM?=
 =?us-ascii?Q?i8iATpGaSJk39fm3P5DfTfUQtj2haJR5J6IB2u8fq/3PQe4DjSO8/6wSm9H9?=
 =?us-ascii?Q?2EXravMNqF4cnP1tOeUEaoRH/L29oOr9EnAJVRmF8sknVGjirLdQBgWD7JOk?=
 =?us-ascii?Q?UVT4NoeUhe175bonGhvlAM+jrrIEmSkVVkD5whZGGV3kk1EQKLBhk7I3SbOi?=
 =?us-ascii?Q?NCpSvtT8dqk06+/eOttc2Dke/ynPeX7M7c8Z1ivgNDxKWJlG1yMJnEtbODDT?=
 =?us-ascii?Q?0lxZA+AdJ5jvlWffL16y1oyfHVZW3kSx7U9Z7icieL6lmPsZqcHwFb2NYiLL?=
 =?us-ascii?Q?55dP9+q9n6VLJHrC4XM3K3SKRchE8Pb1QSRBQrEMCYJqBFGne2ofK4Wq7v94?=
 =?us-ascii?Q?CY1pyjHX7fRoXK42Y6DU93GIck06sETD3kZQNEECgf6/nrRIpUo///7m1feE?=
 =?us-ascii?Q?Tj1xwuoH1Za+Q9rlr45u7SKnCQPJTyjL09plvcLUxsvcPx98lwEieC8vuMt5?=
 =?us-ascii?Q?ly8nsxnRfFS8lMc4t07ElKtRy/Z8c8zavK0bVwN3dBn1P9q+NNHuSlCmujvx?=
 =?us-ascii?Q?bBEF3h/f2zr/4Ut3sG+fi5zWUkAefvqtuzKsr3SYiaD9yH1svaDjQR1ZvQjB?=
 =?us-ascii?Q?PzyuENUFYrtEfkNr9eObQymIh2cyZUquL7ulfWO1J5WF4X/GY1252QrogJJI?=
 =?us-ascii?Q?2jX5VgwJY4/qiSXmkNX2gxjWnjTAlDbbMkF41Sy1yhDCjTKQ7goR7nBbhtwt?=
 =?us-ascii?Q?6mX1BYuXpq5+JlRbC+8ytHXn3MVraK2NKjj1UwBHivMx8y4dPNelCKjOmH1l?=
 =?us-ascii?Q?XydhaUVgPdCYuvUBhEHDjlzZek9U9Jc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 583763ca-aa4f-401e-5a1b-08da44ba088b
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4166.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 17:05:02.7270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DSNz20z5ydcE656q2ab9C+KME79F75/yJuBcUxWT9vCdpyJUqdzmJPXOWevG12qRvPLOVnMZpHTvVfL8Ubv6JgKE0ZJsDg0G/cjPG2jvj6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1359
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-02_05:2022-06-02,2022-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020071
X-Proofpoint-GUID: 4CMFpXUNnEMmRmxsALerkvrQyV0fKXFp
X-Proofpoint-ORIG-GUID: 4CMFpXUNnEMmRmxsALerkvrQyV0fKXFp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Jun 1, 2022 at 3:00 PM Stephen Brennan
> <stephen.s.brennan@oracle.com> wrote:
>>
>> Just wanted to check on this patch as the 5.19 window closes. David, are
>> you planning on taking this through a particular tree, or is the ask for
>> Linus to pick it directly?
>
> Ok, picked up directly.
>
> These fall through the cracks partly because it's not obvious what
> they are for. Sometimes I get pull requests from DavidH, and sometimes
> I get random patches, and while the pull requests are fairly
> unambiguous ("please pull") the same is not necessarily true of the
> patches. Are they for discussion, an RFC, or fro applying...

I understand the confusion, thanks for taking this up!

Stephen

>
> So then I pretty much guess.
>
>                  Linus
