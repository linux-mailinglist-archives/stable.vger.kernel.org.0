Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78FB66441D
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 16:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238841AbjAJPH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 10:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238840AbjAJPGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 10:06:53 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947B188DD7;
        Tue, 10 Jan 2023 07:06:17 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ADL8Ns031765;
        Tue, 10 Jan 2023 15:06:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=tfige72pfR+RkPwm/dv5WVK5Z5iPNbWHOXeO3VTmKN0=;
 b=i/KkDS4OT3sAlBLc6/elSVzMT0b7Ksg2v0Q2T+UJY1xbR2KzuC0bqBru+VKCahYDFgm7
 HZWXsYKqA5DA06fb1NsqU/eQWrxFpZWfH1W0QqWa75KGd38h5OUo/QwvIjqcVK4tnePK
 E468wjYt/R1sXnOz2RXME/msQTKAVuaTouMwv8rZzy8Nbkq8jhRrsmUiGeQ5XzfF0b/e
 CJPi+07rDCbQ6NMJb3GZhyZRPDTOG0zuzOjTRCDDhNsMAyMVFudD909HVoQJT2APqpr3
 Uc/nujWLciJTxZY1l+Vd25/LWQ8IeXN4RH5V43DKiGuZ+13qCx5ReA+3Kn3+LFvAJdsT 3A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n185t8aum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 15:06:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30AF3nBw010452;
        Tue, 10 Jan 2023 15:06:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1ab384eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 15:06:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgjJIC4JlFw4zlk5mxU0QoyBUyUzTL77zoEgUIHwQkneh9qxO2Dw1cThCqI7aGjrc4HYmA6S/XLyIKElvTcKgl/JYO3bwov/gU89Ws8VcXFKzjMG4TYo4kAaN3nHIZyg0pic7mR+hvbjEfBjqhWI+yxMJLNh+WExzO/bMEuA47tJPkm2Q7XePNN0GRDccR8y9C8Ai2U4s41lsCqiOR4If41zbsD4F+aN2Vu8axAngL2V3DhC/fafN8VVB7NGkN8QCGRwsSF6AgdXncA7WIIvu1pLz51wld+XMsdR6Nne9rWc9ax6AZ6kwnhuHWYdyddBQwOldlNGRRYFYn2Y56N64A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tfige72pfR+RkPwm/dv5WVK5Z5iPNbWHOXeO3VTmKN0=;
 b=R+tO6OpIQpoAXOn4ajDVtWpGylzVRo8OF0B/0DkmJUYPj/6Lj3iJ7ag7afO6vswK52BwhyjsFckwZMQCiKODY2sDxf7A+Y6kN5TBP9kAaw2Z339PWlgGttCq4toQuEQ04eWMr+wBiopnk9bTjDg+m6RxZwr/+D5XYa7/2KEaNyNSRsl4jILQaO1ir2rRD42sO3feZ1VxfOTjHR+1ZhgrCP7DedYS/4O0Sh/WYVM7KgycUxDyAtovm1fh5swuXGZS6I95li81uz1q4CNfpNawi/MwGaHei3Qz4h7PB2oZUZSOkCz3cW+QYz9s2bjOMOy7ZYfeRP31qvEx3oZe8jlCZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfige72pfR+RkPwm/dv5WVK5Z5iPNbWHOXeO3VTmKN0=;
 b=fJDOzjA1S25I5WDhaojg1IErh2lYnp5AVpJwGfVhf/dQU1X1cmzbCmGMZak81Zj2ZfwI5ry5xnVox40ooefZOe1fl1WX+ptTdn3Z348dLVOVfIzBLShEMkabnDdx/Mxj29JxTFhucLKApFhumN7O+qAmfd/dhfdkQIQSFN9zEJg=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by MN2PR10MB4223.namprd10.prod.outlook.com (2603:10b6:208:1dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Tue, 10 Jan
 2023 15:06:09 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::475f:4f66:d927:ea15]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::475f:4f66:d927:ea15%9]) with mapi id 15.20.6002.011; Tue, 10 Jan 2023
 15:06:09 +0000
Message-ID: <9ae29224-beff-66b1-cfcd-881bd5351e1c@oracle.com>
Date:   Tue, 10 Jan 2023 20:36:00 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.15 514/530] io_uring/rw: fix errored retry return values
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dan Carpenter <error27@gmail.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20221024113044.976326639@linuxfoundation.org>
 <20221024113108.274007846@linuxfoundation.org>
Content-Language: en-US
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20221024113108.274007846@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0016.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:263::6) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|MN2PR10MB4223:EE_
X-MS-Office365-Filtering-Correlation-Id: b02cb481-509b-47da-6ba7-08daf31c348d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RjJFKBh+c6h8bFJmsw9UncNp2Ty6f3DEJQzy74NlFmSmxn9ntItdXWJjsTCTO5PWUejDLpktqjYEnDLlKyFhiIWg8r4RvZ0uZk0u7g6Rqb9wKrhcP7W8eh/xMyQl1/RHpZud9KawCq47e9qhXG/FJNVfDIJb80JCAJ3dBt2wpFLpKkBSwvCBlEukBRYjNwktW7y7otR4zqlGbrHQNMax2NFMfMuRmggmsCTiNqGLMx0uy32vuLQEnQn520bWVNIYXJ5gSwzt2QPq/Uv1mN9e9ri/Ej3vhvd1rnuAcwpfp2tQQxfZcMpUxugJeOmukaveA4BKDoByhoAWAiWJA+xngA+V/FbcgQ9HwGagfzgKyLXeKdrRiizvdv3o95qR/qHoFbbI/PE/ahYSTDDcS0R522A78rUOPMUZMeAUWRiefNz30ThDkHtt/kNajinmApuH1Bn4v9Of/BjezjJg4sObJkUK/7KdxbTq1CqzEOgVSpxZ2448vAjEfgGjneBVD1WId9YDFqXHov2vd+Qffkz+jIB+pDA65TxBWsbbh2wpPLpJ1AbiueR2KdjGjkSQRZq5gMz8mBRrdGgUVl6OI27B9aTmKvBkVX+QhHgYrychuzhSDETR6uYnIvlo4hY3B8fnvUFZ8pxM3R+R6pFN1yl5YfmB1PHBY/mM5K1pxgLwTlta1VFgdoljX+0Wrejzd9QZvt/dzYhM/lDhRDuRbkwE9SqjIpjd6GxSMEK+01vdpfCjrVGuvP9Gsdb+B4Jbcpww
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199015)(38100700002)(83380400001)(8676002)(31696002)(66556008)(86362001)(4326008)(5660300002)(66476007)(2906002)(8936002)(66946007)(41300700001)(107886003)(186003)(6666004)(53546011)(2616005)(6512007)(6506007)(26005)(316002)(54906003)(966005)(478600001)(6486002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGRNdUUzZHJ5bDhuNkdBc0ZoOFMvUUVyZHR3ci9GcEd5Vm5WTkpSVldKNlJk?=
 =?utf-8?B?SzF4RTZDSWdWVzFLb2VDWXhpVjlid0U0UnBWMXhRcjVGQlp0ZXFWUlV4VGlF?=
 =?utf-8?B?ZUVlMHBBMUN5dDdHTnBBK29MeVl0VW9XZVVocklVN3N0Wi9oTk5mQnJTd2ZY?=
 =?utf-8?B?OStNc29XeTcyb0tSVC94d1h4QWZaRFdZb2thT1dXS3pFZnZDTGEwNjJTR0cr?=
 =?utf-8?B?Vk1XSzRETktwL1hWQVZWWWswSk9WN0lwZEMwb0RhRWFYUzhrNmZ1YUhPZU8w?=
 =?utf-8?B?d1J6VUR5MEMyYnFDZ1V5ZUxGcGVFSW93TUN2SUVPTjIvSTJkY0tlR0VrRG5h?=
 =?utf-8?B?cTNoTGhnMWFFWWtnQ0IrKzMrREgyWTVFZ21ybGhkblVWSFNrUURYR3VhVGFY?=
 =?utf-8?B?UjEweGNsK0tFcVBNZzhZSkdCTzdRSHNISWVNazFWNkpsUWpDYzIzLzlvSjJE?=
 =?utf-8?B?eHlPRzNoUnN6M3kwbU1NbGFIYUpObW1xaU8ramxvdFhWdlpOMHdxekFDL1k1?=
 =?utf-8?B?NXJabm1iUmp5VjByenFZcDJjNS9CQkZ0NHcwNWdEWEVOY2JlQVIzOCt0SW1U?=
 =?utf-8?B?VkJYYmh6VUEwRXdqUGJtRHFYaWpPVy92aDczS0lWMXQwSXU0S0V5V0ZhOHU1?=
 =?utf-8?B?cWg1anB0Vnp2NE5iVG11clVCbXNFRW9FOGlNZ3NaYy93ODRyZGFxQUhaQzJM?=
 =?utf-8?B?VTlRSjMvNUdhZDhQbE9uUy9TdVQ1eENGREpUMkV0SW8rUE1LTkFYcTRZWk0x?=
 =?utf-8?B?ckdmV2l5U0FaeUt1RSs2eEJjTUV6U1JBNXJTb2hVd2p5LzR0ZU5hTCtPVVVV?=
 =?utf-8?B?RXhja1JjbjNYa0wrTUdBMUFTM0FhWmF5S3JEaWtOaVlZaWpnQU5rQ0doVkRw?=
 =?utf-8?B?aFpES0NZcENORXZRZG0yZ1RtQXJtRG5UQ095bVIzQkdvQ3cyWHpsS0ZhRXcv?=
 =?utf-8?B?WGNBYWhveWhLNDFFVm0zUmlPZk5BOW5oK3B5UHRqeHZwZkJxb09sa2M5cDZ2?=
 =?utf-8?B?MXVoanlOcFpjNnJldG52Lys4MklHdDVyYmVBRi9CMVZWT0ZTYlpLd2hIZERp?=
 =?utf-8?B?cm1GNEdqRzhVekdLRWhrZmdsV21GdWI0T3BpelU2aUZ4TEtzbiswcDJqKzZX?=
 =?utf-8?B?clorMEtDdFlRaFhZUGdUVEFLOFdiZGNxYjJhekxLd0NUR3MrZUpMNURKTGk5?=
 =?utf-8?B?Y0NlamR5clhKYW5raGkraVBGY0Q2VjJRRVhQRnFhNWd4L2FPalluL0FPWElx?=
 =?utf-8?B?MXNIZHEzQ01KL2tYN1YvYmRQRVJLcWRyR0tmOFVqUDV4LzVoRnN3dlpqUzNp?=
 =?utf-8?B?TmpCamN4TDl3dFFmbUg5czJUR3dyamROL0EyODkzZ29SQnVmc1BZazllUTZk?=
 =?utf-8?B?UENCUkdsR095dllaV1htUnNmK0hCbUtNRjgweS9lSTBmUU0wRWRkQUdnOHJ1?=
 =?utf-8?B?cHc5WXA0UUNnUks4M1AxVFluOUlWYllIelY2bEZXZUZ1Z1JxSlNqTWJyZzF4?=
 =?utf-8?B?cHZ4NHUwYnV5NlVSa2E2NVhRTXY5NnhuV1g1cldlWnpzNi9hakhVNHhYUExE?=
 =?utf-8?B?UjVEUkxrMDFZTjJob0V5SHVTZzlvVm11VksycDcwRDNpRVJ2TXNTMVRQT0R3?=
 =?utf-8?B?UXNOMElmc2hiUzkxc3lrdGZpc2xHZE5XdzVpS2VuK1k0S2lwUXVpUUtoWDlt?=
 =?utf-8?B?N3F2UkJyQ0pvM3lBc05oNVU0OFNBcEIwdHM0ZTZsdlNneDdjS2JvTjNka2Nn?=
 =?utf-8?B?WWw5eHJNMEJscWFva0JmTFpYdUV6Ly9hc0tlV0tpNmJzUEFiR3grd09HTFhO?=
 =?utf-8?B?UlZjU29IT2pIaFlmRjlaRmZQV3dXcFloYzJxSmhaWkhvVHVqeDRHZEdOdmti?=
 =?utf-8?B?c0tCckNpZzhvdnlSTGV6MWpmY0xMTW5WejlFc25IdmwyOUo3TlpJZGROSEVx?=
 =?utf-8?B?aUZkR1R6bGdNV2NFWWJ1blF6eUM2K0VlUW1Lb0dET3A2VzV4MkVEUTZwdVhy?=
 =?utf-8?B?cUt0cjJ6bldxNVBEYWp2ZEQyUEpZL1Mwa0dCYmNWcXpMOU1TOFd0S2lSUG44?=
 =?utf-8?B?b0o2MlUwc1cvUzV3RE5EbnZmOU1FQnZCOFJySy9UaVEwYlZlRTVBazBQYnkv?=
 =?utf-8?B?cG1Lb1owK2xtVTN6cHdZUWlyK2N6VFB5Z2VHQk0rRUJsdFV1UWowWE5RY3VT?=
 =?utf-8?Q?wLyiA2INVNxbRuV9nHgAqcs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3YSpuN2supRCZWzf8gie6MbGJmydRrh81I8fiCdRHB3HWdYMHaJWB8V31go0x12WPjEFw6job5OD7uU9RaA8CQsMRp9m5bxoTuBNcEg7PbqcIs9xnkvSD/liYFISM9X6hhRdwgXwPgNl5O8AYDTSubjWtVPh486XY1BPsAG7TjyTmbAthXHkDCHWDl87AyQ0RbT2e/kqg/4K6oGPCWaz8yYRmXT4AdWwEpOx0R7iAeSWSqjLNCAWeyqA8G4i/txykwuMxf1sOrilLSaS2/WTmIxw6nKx9sxbly80eAmybu7MNWOxTJmwG2nsGpEiv041xufxw0yLc7jk37J2SZAmv1ZVyX4nutUuafryBFL2iUf8WkzqBuUsPFHPg6siRIPrMZlCFLDjN0bpfKm9vx3Kr0HbQbBXVpylOcednKekOTFgMfQJdI3D2lF3lYEzz/6cwshnmAx1QWDmjPb2pN+xk8RjvTQLJedzWeycOlNy3zH5SBCNhSWkVqc1MVKds8dRbgD4/GFbP0Uf+iFLJd/GyXPMEvxFD5bt7gr2zGPgVkho67qBB9qLiz1qPW3jDQ41xwpavdEebNKRMVqVcIgWZ8/he2p9rUelWaRZP7jmLNjtjQHQqp5mU6ab7pcjMEVHSTN5Gk7Sg7fEsLt04+5nnSaq7NAtUc1UczkqZn8P6T3RqF8koCs4X6JLjNMLZ/HGg0iCQSe6uay8m5rjpTYsacyocAsUZUAeW6AB4PbZOeAiSbYEj0g9A7pnvgKZEc0BuOZzA/C2avpQF4A6OtABSXSf1GrN+41fudIS0Y9jmqiz/y6U8lnkvY9a7FBiyBxlXe2DbfMYnyBhixnqwGp1lkbppn9lNVFfozYg/hWFrFd1HpYw5wODZdIJUYLH7Vw0rxtlbKeKAvpxNfYBa6IeRQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b02cb481-509b-47da-6ba7-08daf31c348d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 15:06:09.5631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1shwR2gqrNQNcutEuL4xt0rlH7osEj/lLue3xa59PmqqYyNyavnupu6EMVu31LiPsqj9b/jM4RDv2I9OR51wAjeWIcirssn6pWsbot//ZLFlpSMALLqMwmE2OE5X7ow7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4223
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_06,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301100094
X-Proofpoint-ORIG-GUID: Pu2o7ToJtyKyivbOg0Ag0OTn4ew3o2Da
X-Proofpoint-GUID: Pu2o7ToJtyKyivbOg0Ag0OTn4ew3o2Da
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Greg,

On 24/10/22 5:04 pm, Greg Kroah-Hartman wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> [ upstream commit 62bb0647b14646fa6c9aa25ecdf67ad18f13523c ]
> 

This commit 62bb0647b14646fa6c9aa25ecdf67ad18f13523 also changes second 
argument from unsigned to long.

> Kernel test robot reports that we test negativity of an unsigned in
> io_fixup_rw_res() after a recent change, which masks error codes and
> messes up the return value in case I/O is re-retried and failed with
> an error.
> 
> Fixes: 4d9cb92ca41dd ("io_uring/rw: fix short rw error handling")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Link: https://lore.kernel.org/r/9754a0970af1861e7865f9014f735c70dc60bf79.1663071587.git.asml.silence@gmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/io_uring.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2701,7 +2701,7 @@ static bool __io_complete_rw_common(stru
>   	return false;
>   }
>   
> -static inline unsigned io_fixup_rw_res(struct io_kiocb *req, unsigned res)
> +static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
>   {

I think the res should be of type 'long'.
I noticed this when I ran smatch on 5.10.y io_uring backport from 5.15.y 
patch.

Smatch warning: io_fixup_rw_res() warn: unsigned 'res' is never less 
than zero.

static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
{
         struct io_async_rw *io = req->async_data;

         /* add previously done IO, if any */
         if (io && io->bytes_done > 0) {
                 if (res < 0) //// unsigned comparison with zero.
                         res = io->bytes_done;
                 else
                         res += io->bytes_done;
         }
         return res;
}

We don't have upstream commit to backport in this case. Should we fix 
this with no-upstream reference commit?

Thanks,
Harshit


>   	struct io_async_rw *io = req->async_data;
>   
> 
> 
> 
> 
