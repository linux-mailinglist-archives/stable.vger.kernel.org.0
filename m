Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF4964341E
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiLETmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbiLETlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:41:51 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19A426AD9
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:39:26 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B5JNe4T019472;
        Mon, 5 Dec 2022 19:37:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=JK+fCFdZFTu+HfwCr04NjInbPTapB27RLu3O6FaSwAA=;
 b=tf8HTg4eLre8g1YW/gzUzMW2PtZNL/0dhykvKjHo+TPwaThdZXab/CZQJzD2o4dtQ4Uc
 gD8ob6g7/I2UogRrviUG3dobm1fMQb1//4W/sPGcGi3o3b5vCCOyvTSIEDMhQPmzQTOf
 RWQdkMbDl9IX8vCWZh35JGa6qAtk5dybpaGcHdAtSLktL0HltKL03Rc+0oFGWYwPTrpk
 UnXutqVtGs158q4S+1aalNZhKsXi+4RC1ZYOx1IYBUns4whoYCmAmLJY2dlsU4PaJwWZ
 MWNw5mWXkqGnHQAzY3eueVmsyNOxjHN6kiMBvLozF0+OUj1WA7VFkEcbYiOErRof8Ojy zQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7yeqmwcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 19:37:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B5JZ2Xm005307;
        Mon, 5 Dec 2022 19:37:13 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m8uct686d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 19:37:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVfV9zvQZ7BNYpxxVCDg20+Mznnej4xjdpPG16XUw0o6x6dOcv1r/X6vL4jiuggBb38vm7DBFuzukvn8CK7KPyJM7Cal0ZeNIg9ksyre83EOt43XIS6mnrAgMah0r/HH3uC/HR2lyc9+H9ChMcO32PTe25E3WM+1LTbTq8tsbu/m9lbqCn4TNR4yqv7L4XvP8c3n9CgZAfPeQROiYlp3TVVYTukWKvN4z/OmFyTXcrb7XI+0zXVwT0/Wtui8dw7zlnFwzx2+4sbtpHNnfgDN5KQuI7Tq8noor1wdAoAc//NFLZKpFTRUOqTo/ultvWQBEZrF9bhStZa09S9COJA+7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JK+fCFdZFTu+HfwCr04NjInbPTapB27RLu3O6FaSwAA=;
 b=k1Bjj6it0QI9929IBML/YMQSz/wBDg/A6j6kzbgMZSZvoDJ1od+YglIWtN3vGAVAjNXpPopQCJtaJfQxUfNhtGJzF+Ms/YaSlQ+be5j7Pd1oBvJwhfbqyXE0R/2HMnYMrDPGGCwJ49c8a1J03D62ht34QL9XqzcLeC/Y2kU8/nUSPsL4DISbBZ87lpSLssC3SQzzunTm5zJ5q1FPO4sGrm42JrddctKItfYGGF3RWSgfSEEQM7H+hLUoIjV20fJbyWlGnB25szKF9cWtS0DqMoswGU0JqVDKZjclDQXKG3TyUgCnKkHS4mpiw+B4Y9ZE4PYZEz+7zWq+Am1z5JpEIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JK+fCFdZFTu+HfwCr04NjInbPTapB27RLu3O6FaSwAA=;
 b=ord9WIu9L2BzkiKXO/VmVANgKt8HlbccuWsvcbNAEGpotJ9DbVJVxsLAKaIbD9vHIQFyO9oOdEorXYCezln/BHyZllkielC0VFpquWNGLVMwsNObaDxk6xhdkA4w5fmCUpyyyLrMgCnro0Dpsp8OxFuYG4T50REXGAf2Z3qQBaA=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by DS0PR10MB6270.namprd10.prod.outlook.com (2603:10b6:8:d2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 19:37:11 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 19:37:11 +0000
Date:   Mon, 5 Dec 2022 11:37:08 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, almasrymina@google.com,
        axelrasmussen@google.com, david@redhat.com,
        harperchen1110@gmail.com, nadav.amit@gmail.com,
        naoya.horiguchi@linux.dev, peterx@redhat.com, riel@surriel.com,
        stable@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED" failed to apply to 6.0-stable tree
Message-ID: <Y45IZJ+NX76pJ+yn@monkey>
References: <167006657717429@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167006657717429@kroah.com>
X-ClientProxiedBy: MW2PR2101CA0030.namprd21.prod.outlook.com
 (2603:10b6:302:1::43) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|DS0PR10MB6270:EE_
X-MS-Office365-Filtering-Correlation-Id: 423256f8-03ac-4ec1-b09d-08dad6f81a63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQjKan+iVVPv2rcJX6HOI/vy7ao2Si2ZtB0Uv5GuymYjsoyppX+BEoWPHngpafI5+LfQq1L5hXcsimM4SyukaWhB0/UqNCgIS3eYkj4oEmQ1KOSjAR30POVUNXGoW3eBvIrdSjz11NcwCTpcPCxCCwRO2DykKwkTQTLoojgh62QJ1oSAppxFi7VSVFoTOSe2YduZGHAuluT1bHR3jZQO2F1obQwy/Qz4j946X318HMsK7ha2pG1roQ8Azbohmsr5Dqf5H4Fkq6XVK5xxG/LX26cypZmCjEHc0sdk+VmZpLBxeefU64LEL8MLtO93Bn+zwgvz3GAQ4MWnWoXFziy0dV41ee3OgXYgRnZuvv0qyxK0zODs5c7ca5uxm2FzVjF/JRyCmFW8cGyW9jWoTXCP3bQAueF3IdxTYzfWNv2duBgJok792T7atE1txZZZLlyDq7MV0mc2XRmnznnc9Vg0LiPRB777g+vc/NZPetpuwCs60cf7bYouZ9Ke1U3eVoNvk+wR79X3J8j/PKdhJ/9zJwUfcxYpUp6TyzXrL25o+0sDa07C7J0WMF9uqfuuqoQwM/fKeilEGj1rtySj+qlzhOsGsrEOwQzv3ohG8wbJiZUwnnh/PYdcv9ZWjaMhhzwycbdhLC9pMDQCwpeq8IpzlzOXWqeyfeYZe5ITJwLwsq36La+qp4KQe9MB8Fulxi2GlGXO5wY4TZUkU6pmW3iAlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199015)(83380400001)(33716001)(186003)(86362001)(38100700002)(41300700001)(66946007)(2906002)(66476007)(66556008)(8936002)(44832011)(5660300002)(7416002)(6916009)(316002)(9686003)(6506007)(6666004)(6512007)(53546011)(478600001)(6486002)(966005)(26005)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tjbMqLTaeq/UQzxtUabSVJdf+rssjOFymlurgWXA59w+45x0r31k50L47ChK?=
 =?us-ascii?Q?IiK1Wn7GSwu7HG0ghXoAGALYyVe/RUZuXiCsN4Mu3vjFLKNUBgfPauAQ6EjY?=
 =?us-ascii?Q?VXhzCXV8/GbCqs8cb+Kxx6D97HvmpVHn4X7xrmMcvjwxTreAflk1s235p69G?=
 =?us-ascii?Q?rb4Yb7dasLirm61lCpjSf7LQgLDUxOKgY3qww7HD7jlSWPE415DWnGXyUDrx?=
 =?us-ascii?Q?VMjOY/0ywA2Gg2QYc5dHHion4j7yAz4NEHqLEbNUBGeG30w6t2iBhvhwivQB?=
 =?us-ascii?Q?x25lKM+X1b+vFcK1H5fA+TpZd3LHYO6dGh6kviFkVm5Hh0Tg/DC+BSzgX9xN?=
 =?us-ascii?Q?EerN6bJp0d9Ud5/AbCi45sq2ABV+XDYngA8xtrc6ufBqpdFQr3ythcUgKm76?=
 =?us-ascii?Q?9lBo02JOH2CdlnASClFk9aPATIfyVSyKnwdaRa2bG+GqWXuD0jyYmR5cfFi/?=
 =?us-ascii?Q?1K5S5yyfy/D4UrMhq9YqV4v/ABMU7AsC4bCaMq/cTYK6f+aOoFLBOcjaARQN?=
 =?us-ascii?Q?hH8Y/rMGWBjsAvEmiCchQpHeAKk07BiLhzCIIMQYWJSc+SEcztmurp+v32rL?=
 =?us-ascii?Q?jm0Xm5nDD7llcTiBQb+CLDoNkI8js3z/ABqWT2cbuqY/GpI65Spg2w9Sta68?=
 =?us-ascii?Q?7NNzPilEGC81w/DvwThcElEqfYn+01tVyUxkJogAUQmFdPNRIb0gXLQqVCjA?=
 =?us-ascii?Q?a/Y46TgHAHhQvP3I2oQuYw6GOy86f4HFskkoDx/vwj1LmsWwGxZNoA1Bgibe?=
 =?us-ascii?Q?upQOtm2OX8glQZtQd6+U63s3kO5P200PJ7LIFnaCpn/v/shySNTzS1crUnC3?=
 =?us-ascii?Q?6ozNyztwKyh1tt61vMUvz8RRLYfFj+UfdLBZMdzx49sf/4aWilKy7ykcOFVZ?=
 =?us-ascii?Q?t+Kk/OGjrvH/cegeTpjQBamSmIkXv1sXONgDTd4rSqGManYtoX2ZKw+8/aqp?=
 =?us-ascii?Q?OwHetVlICUoMXpf8QPOpMjfR+bTPW1s0ZP5a81WqPKSB3kXmlkuv7kq5txWy?=
 =?us-ascii?Q?qMgWlQ3Ovl0InQsyQyLA4Dzy9DbHqEyh93NdLzeR/FvvZHU+lWcdnDcIZmWd?=
 =?us-ascii?Q?Tp7mw/F1go6faqTM30GfcvfDq+pJG03NsQ3MVyJRQ9kC1r1+dXlmXsN4c2PB?=
 =?us-ascii?Q?ACogfc+rNfJwdk/5M8vfxjLnovBhfbRBxzu1PVF3pvDEzqFEVmSB9h8qztMK?=
 =?us-ascii?Q?48qWBqeDmeuowJllmN/e+M+QcKGW8JWqMU/fvRzNQfUhYVKNLQwvzQxQt5Ob?=
 =?us-ascii?Q?L6k036K/Pu1LP9x179pxi1zGQtj8F6iAcSUUjh68q2POlKWb08iqBu56c7LV?=
 =?us-ascii?Q?WOUQzVn8qBYqZaW+LsO2NezuVbnV+rmy4zgMQmh5eQ+umrymrv0/XhTN2oxx?=
 =?us-ascii?Q?csmLy6OdZwuDsefRVw/RA67OoYCUplPJdoxabokfA5KI6/g1uS94MeSL1oSt?=
 =?us-ascii?Q?2pspxb2lo1ut764xfG0uU90FERFkIctspACLyqCTGM8EIrHFuAXc+QxD+Ppo?=
 =?us-ascii?Q?ySJW0jm34LRR3jGpNOwAz8PSIGbsaYr+en8aSF9QoKTO/UzWI0AtuVQ4aBKm?=
 =?us-ascii?Q?YFuy+dIS3YmbcrRtKBuZHZnq5j/kc7eToFc1298TQD0vgSlCPKIfQ+k9BH+8?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?FNdORK4wcJ1f9BEbpxpxyzVssUmIrgpkUnlnA0Kgkqm+o2Q96E9K/9uF1Ie2?=
 =?us-ascii?Q?jRLIgcxGIGCC3OGFwSgFwSwDQt3p40nGnHDtPi2K5IOrfJvNzRZlHRnPGSqG?=
 =?us-ascii?Q?2SyBVOPtA7aMN10xcivBCGUioPABpbl0WDBpKlCaQSD6FHSwSLfWh6ukDrMJ?=
 =?us-ascii?Q?001Sr30B+cmYqGzEkhHjA3261tTERB9xyGSLYYpQqwMO3xdkpOSBihivs3oS?=
 =?us-ascii?Q?DjkrCh8llirO34bmanC3/PswewwrEp7uzVbzkNR5PF5412tvPT8Gnv3xot0+?=
 =?us-ascii?Q?c3arFLAa1CTveJKKzz7fgA4AWIpnoIOQRaXfqLUVBn3PagaCEJu9yQ5Kw6EY?=
 =?us-ascii?Q?qqCsEK4UtMbXB+fGaCZdTXOuFfQ0xa8LK0+00ZpPBf2Zav+U64UAlO+PJNUG?=
 =?us-ascii?Q?siGbSnFzjgg1alv2SO3Sy7bpyqVTdEcNtV1MuulT6q7PX42+Wo8/84LHKOj+?=
 =?us-ascii?Q?AdwIQPS+Zdz3FlkBn1E/HfK+n+58lO8kc+TX5D158wznomOCELvsNyVS+aUN?=
 =?us-ascii?Q?nWJYGGr2dHHXLlowLF+nsFP/h2rzigSRTkSykpxG3zorw3O/ZRtKTVQvQxYy?=
 =?us-ascii?Q?LlUT8yyt4dVs4w7nIVeoGGpkTx9oHp2aehA5wYOiuCij1OgnH4RMjA215pkM?=
 =?us-ascii?Q?M9ywgni/s8B94YF5a4lTr6vbe3aypZiTOxcuxg4AddstBQnRPeSEAROfXe5a?=
 =?us-ascii?Q?ZQdC7ed54nXphiOrngTW60XABXf5dqYFYd2QmtXH72lR0S1z65oGbiNOWv/J?=
 =?us-ascii?Q?JHfFQJzOA1Cb5zq/+x/GkjI6lGEDBZq6SqHp7oE8+ZsCUyV0WM7+yb3eURyO?=
 =?us-ascii?Q?DcG0LaprmfLNMqEuzBAOfROUvgQAfVUAdplYsPMndmswByLq4B4w4k0kDxD+?=
 =?us-ascii?Q?LQXhbff+epBfghoOmEHSxjgHbujbDYNS/gDe0MTF5gCbQRr26jKIt5D5j5TV?=
 =?us-ascii?Q?pxYu7rEFqEe0UBMwVKaN2WqUjZXLK44HNINr3ORA/faFWG4fLcIJcJRkQZZV?=
 =?us-ascii?Q?0VSl9Oxsa89AiWvIxHMB6w90QCC+ojvWREEddVFaUgWUbIDFMTQk8Ai3PTzO?=
 =?us-ascii?Q?++6fC+2TNEkNgBiIQFkah7QcFUPsVVAyADIlGy06Tip+D1gzREqfSfZUjYGn?=
 =?us-ascii?Q?jRtaKpoIGLqmpzWsiGONbQkInm56GudIAg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 423256f8-03ac-4ec1-b09d-08dad6f81a63
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 19:37:11.0726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5XgjI6sBSTQMoFr36zwaVodyalDpuhZWueCi2QJqlu/4RXWoIY0PJbOgmorEqU2ezjzrAnh6dKuNW4Qq9HThlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6270
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212050163
X-Proofpoint-GUID: inkAxnCMqU0rKiOCLxghl4XBrt3qN1qx
X-Proofpoint-ORIG-GUID: inkAxnCMqU0rKiOCLxghl4XBrt3qN1qx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/03/22 12:22, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.0-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Not exactly sure of the policy here where the commit title does not apply to
the backport.  I left the title 'as is' and added a note about differences.
The commit message already anticipated a backport and mentions this as well.


From d0c568ab5c0b2c2c3aae8a3dd04a7c41cf1088c9 Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Mon, 14 Nov 2022 15:55:06 -0800
Subject: [PATCH 2/2] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED
 processing

commit 04ada095dcfc4ae359418053c0be94453bdf1e84 upstream.

madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear page
tables associated with the address range.  For hugetlb vmas,
zap_page_range will call __unmap_hugepage_range_final.  However,
__unmap_hugepage_range_final assumes the passed vma is about to be removed
and deletes the vma_lock to prevent pmd sharing as the vma is on the way
out.  In the case of madvise(MADV_DONTNEED) the vma remains, but the
missing vma_lock prevents pmd sharing and could potentially lead to issues
with truncation/fault races.

This issue was originally reported here [1] as a BUG triggered in
page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag to
prevent pmd sharing.  Subsequent faults on this vma were confused as
VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping was
not set in new pages added to the page table.  This resulted in pages that
appeared anonymous in a VM_SHARED vma and triggered the BUG.

Address issue by adding a new zap flag ZAP_FLAG_UNMAP to indicate an unmap
call from unmap_vmas().  This is used to indicate the 'final' unmapping of
a hugetlb vma.  When called via MADV_DONTNEED, this flag is not set and
the vm_lock is not deleted.

NOTE - Prior to the introduction of the huegtlb vma_lock in v6.1,  this
       issue is addressed by not clearing the VM_MAYSHARE flag when
       __unmap_hugepage_range_final is called in the MADV_DONTNEED case.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/

Link: https://lkml.kernel.org/r/20221114235507.294320-3-mike.kravetz@oracle.com
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 include/linux/mm.h |  2 ++
 mm/hugetlb.c       | 25 ++++++++++++++-----------
 mm/memory.c        |  2 +-
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7368a99e4e55..fa4d973c1363 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1794,6 +1794,8 @@ struct zap_details {
  * default, the flag is not set.
  */
 #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
+/* Set in unmap_vmas() to indicate a final unmap call.  Only used by hugetlb */
+#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
 
 #ifdef CONFIG_MMU
 extern bool can_do_mlock(void);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dbb558e71e9e..022a3bfafec4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5145,17 +5145,20 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 {
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
-	/*
-	 * Clear this flag so that x86's huge_pmd_share page_table_shareable
-	 * test will fail on a vma being torn down, and not grab a page table
-	 * on its way out.  We're lucky that the flag has such an appropriate
-	 * name, and can in fact be safely cleared here. We could clear it
-	 * before the __unmap_hugepage_range above, but all that's necessary
-	 * is to clear it before releasing the i_mmap_rwsem. This works
-	 * because in the context this is called, the VMA is about to be
-	 * destroyed and the i_mmap_rwsem is held.
-	 */
-	vma->vm_flags &= ~VM_MAYSHARE;
+	if (zap_flags & ZAP_FLAG_UNMAP) {	/* final unmap */
+		/*
+		 * Clear this flag so that x86's huge_pmd_share
+		 * page_table_shareable test will fail on a vma being torn
+		 * down, and not grab a page table on its way out.  We're lucky
+		 * that the flag has such an appropriate name, and can in fact
+		 * be safely cleared here. We could clear it before the
+		 * __unmap_hugepage_range above, but all that's necessary
+		 * is to clear it before releasing the i_mmap_rwsem. This works
+		 * because in the context this is called, the VMA is about to
+		 * be destroyed and the i_mmap_rwsem is held.
+		 */
+		vma->vm_flags &= ~VM_MAYSHARE;
+	}
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
diff --git a/mm/memory.c b/mm/memory.c
index 68d5b3dcec2e..a0fdaa74091f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1712,7 +1712,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
-		.zap_flags = ZAP_FLAG_DROP_MARKER,
+		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};
-- 
2.38.1

