Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CD86955D8
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 02:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBNBWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 20:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjBNBWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 20:22:50 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ECBAD27
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 17:22:44 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31DMO8V6026623;
        Tue, 14 Feb 2023 01:22:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=uHbVN3FUZoeHlUBP9UJ8sj8F8D24zTPoDEKm7sWn9Ro=;
 b=vNXxMpvYZaUTq0/kKGoKBBvRWcKMqg92C7hy69qggMKrYOlIWzTELXtvzokGOhxY4QAY
 YTTrrb7YUPbs2i7eDqRxF4qWO49KsjTO20RSV+4e3GhYI3OLhkm5FiC904a6xU1W66Gb
 7k2w2gdsHBRGkhAEdRoGG6e2zifTLwVO5bIzdbrI9XWRPWwO6OGstPb3trP5GiJrKWGM
 WQqPqFK/lVyXF6jbTusUvRhqtg5QpjTZZ093F+TpL8F1ciw3MXcpHrIfu3HUqilbHFxh
 vDmMZtlZsPrWcd6HMpPAw0PPmubmXxl8Ddnyq4rNWSFQw0ykcaaZlRQHQ6dKNHBJAocD rQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m0vada-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 01:22:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31DMmTxl032487;
        Tue, 14 Feb 2023 01:22:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f4vd34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 01:22:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Si0jjIzjytlW+Vau7D65rhgueu02VwPN7wD7d4PQr6ULoKjwBVZt3mcAu2h2sVy/+UWlYuRPzJa/CKRFZsz/27vh5/Hlrp8R9na0Ya2ZRKIhlIh6trkTbiGPxloIZYOx73p43/C2Dz/VuW6v/8JveV/1GKdXZRSCXNPFW8YguRS4kCqXFpedvqUorceu7+b8Ge8YVTmUoduwERibLykbXceOEFyYanmWuA1TXr6Ze4kox6l18xMr2pIrqsVSPHQ54wlGmRdnH3U+HHjM/5dF9LKbw4nC1lXmFR9xuuqEtJN87tdhyxfMJ1xSL+ZU23kW5hRYnptAzJjpH/fyAN5bjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHbVN3FUZoeHlUBP9UJ8sj8F8D24zTPoDEKm7sWn9Ro=;
 b=LujG038U15Be2O4RmwG4j5/j4uRSQdG+mlrPEoj/jIDwJ8DUrHJ88JR+PGs5D/M3pVFx0HVj5pvPGVWQIj6IU9y7D/2MKvbNGeTH1UaOzZJcZvRYuJvgkaaB2XXSMBYI43/WdriTNPJ4OfZcnVu/Kw7Z2QHKJZFHV7Otu9iUjqKmDRhW0qtAe/evLpDGFBWKnbJjbpabcra+xJPymsXyZuGqZNbZ+dleMX2a7ctHlG2f50zc/L3Y2WlOmY+XMbHCXEgUzuYQhHqul86Luoz2CvLekbsELClFyztkJqsS80bZR+IbQKh6YIqb3oPKe1FqEYgESZK3uOH5SDr2tsAa3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHbVN3FUZoeHlUBP9UJ8sj8F8D24zTPoDEKm7sWn9Ro=;
 b=NIuiGducg4sWqacTAiWb17Tz7NOYnlWl7AH4nFwnvSISdDTxT/7Qk0gHHlqpo6IgByxSqEnbXKFPo88K+nUTy2BYJq+tcLDHIvOfQ2a6Tnljjh5YYMFHIbmyDhXaTPRMeFRYCI2HspPsKX2G4HsSplTRsAvjgd+o2Q4tV5jMjTk=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by DM4PR10MB6693.namprd10.prod.outlook.com (2603:10b6:8:113::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.16; Tue, 14 Feb
 2023 01:22:07 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a%8]) with mapi id 15.20.6111.010; Tue, 14 Feb 2023
 01:22:07 +0000
Date:   Mon, 13 Feb 2023 17:22:04 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, david@redhat.com, jthoughton@google.com,
        mhocko@suse.com, naoya.horiguchi@linux.dev, peterx@redhat.com,
        shy828301@gmail.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, vishal.moola@gmail.com, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] migrate: hugetlb: check for hugetlb
 shared PMD in node" failed to apply to 5.4-stable tree
Message-ID: <Y+riPN74R68GOaGU@monkey>
References: <1675761364213238@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675761364213238@kroah.com>
X-ClientProxiedBy: MW3PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:303:2b::16) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|DM4PR10MB6693:EE_
X-MS-Office365-Filtering-Correlation-Id: b18fc37c-0a21-49ee-4df5-08db0e29e33e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DKkIF58Ilza1r6fmaVL7nU+8ogp4vM1y+8UCHEkkev73+bZfVAAinwe92x5FHLxajRgiaHESpTwLBB/0yrFFJYCQesgLTxbaR0XATfYv9+mXYwgcD0AR9egUMORD5jokpEBjoC+IgTvB6WnpDEd5nxjO651qqiPWrLVrDcnP6Keacu8NSuuNKOaUTVjH+eZGhKsgmNxHg+g+jMm2eZO/VDKyNhs96KTKev/0uNuqNBcuW7WEjROTsNbzOkyuG++zykDpGt3EX3p3Tr8sgItFczrhj533dmq8cqOVyTVvyOlgXRF9LBYtHJT7iTs4TgWPnr+q+e6ENQi1VOBrMMrKxcRxuW+ulfCBKHaUAEOfpksTjYHQgbWuPK0BdB9ntvXR29kG10IvvxrKEp4mRtMpis6kXg5ghGOoI9PBo55Y/j6rmE4zi/yCJIy2KQIy1Up/0DLgh9it3jQyou3iVBKsEKwCy72ojBDR3Y3uHHMp4MEfV9ra3NKppBMlC2x5aHy+3+GXGeP1y1xpGNYgYS4J2fSWdkGTS9M0Moc7picgaYZcdIOQ/9sMMs0m+15nxdX/ZxlE9X4zf5qXnvM1D00+TxwH8fZr3hEDilZV1jxoBc0di9/kH02Krulf5pSA/H3SlUP6TG92y5OKpt0BMSjuAZrJDalEg81RYPwj6nC7RoGdmZo0wjzOzuMmQ8unkMqI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199018)(53546011)(6506007)(6512007)(186003)(26005)(9686003)(478600001)(6486002)(966005)(6666004)(33716001)(86362001)(38100700002)(7416002)(2906002)(5660300002)(8936002)(44832011)(66556008)(8676002)(41300700001)(4326008)(6916009)(316002)(66476007)(66946007)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n3IHfGzyUPsouZgWtmj6q9Fl/BMOsD6YsTPBWQkZR05YGoZ+SlFOigOBgL/F?=
 =?us-ascii?Q?TeMcMLGDAtM6ebtOXSsjRjjGFbc1m+0Y5wc93BF+a71R5j4STAukr/6rBv4y?=
 =?us-ascii?Q?ieJAHj5ElskUSoZOeSmfH8+rKsvXcu+76tsHfTfz0XcPZ9Q5shXj2sl/r8Cn?=
 =?us-ascii?Q?OJhS/XCm1tf23R7x9k5g6XhfhcDkehTZu3DaSGKzq37xtPc6hITbp1czIznr?=
 =?us-ascii?Q?vHSzq+WxRj/6v00XYMXQvg4BN0MhfY3l4XwfDXzrLS65hwE/RHhd4eqQwWoD?=
 =?us-ascii?Q?X/nX5FYh2Gr4ke5wMfFtwUtDFfxjp3uE5FrZFDgsP4l47wbAHhG5HFl8aZRU?=
 =?us-ascii?Q?BOCiV/bXrtGQe53lKnuJdX0AauvIuL12Bh/zQps7VoBEQ+pm4sjisK32Knl7?=
 =?us-ascii?Q?C44L5Q+Oot5PuPfV4ywkZa/CK3Kg+MmwJSXyZfMbw96hnYdiO2HCn2qihoIv?=
 =?us-ascii?Q?wrAfaRSIu+BSUTStyocLNsRvTQLMuPrUaLwG9am5lDos5/YrpP99kRv0Rk5P?=
 =?us-ascii?Q?zLZVwucvejYGeACRhDgMEE+F9pDkc+UflexWPx7LClVbIy1n0heHNvMaVLEl?=
 =?us-ascii?Q?ED3krXHwQzEPJpHbMDQo87zLAkWW20KFzBdKboA5FSG48RGkuq3R1HJCbXSU?=
 =?us-ascii?Q?cCqT7feNiMnhTzmsOi4CXkmTlaVPWIcwCA9LtEHvuJSQJZDNQuh268TYaYrA?=
 =?us-ascii?Q?gumXIL7vdFC7Me1xUqV7cykXk5MWE9sdzZwoZxeFK6cSrK+GHCjSTCspDUsD?=
 =?us-ascii?Q?4LVJjR8iV6rt9jZaL23aQ28BMQwMHaNxTDC1PpOxNkgqghYSI7o5CVhWO1S1?=
 =?us-ascii?Q?TM2PriHEZoStOlFcWIIksWJYlxeGaAa14S3RsjVCOV+sQ33m0nHHVjP/y7k5?=
 =?us-ascii?Q?6muocJZGIZFXDwHbBOiPZZut9Xmm+Uf+/T+yPaB6VJNbgQJn6czo+NAo8sW7?=
 =?us-ascii?Q?Y0mQeix4iQ7pOTVZ/XmeXqPmf/ei7m/VdjqEc2OTLGn6KUd5b9HyHXwEK2li?=
 =?us-ascii?Q?VbXcLCJqP3EKIH0rhWH6nzcv+eyXJdFFHy5hs1gHeAK/CKRhF+8ic+j38r+a?=
 =?us-ascii?Q?qZknJ1thK96zNBbzltOGkMN2MK1Yw4our536gw+7wLuiT7IqSY5fhJ+T/iXY?=
 =?us-ascii?Q?+LHqetlNAUzpCEHSiCuNrv+Bb6SlbdcGOLqkgIJ9EEjdRIzlpMH+Lj7hObUP?=
 =?us-ascii?Q?BdBAahamKmTr0y2sSglmKr9eDSKuTo2G1g25+/54Sxkpc1rLKPvyJrS57+UV?=
 =?us-ascii?Q?yTRGNIWr9mnr4N3jh38AEyum2jk6a658l55qCt2SvRDgMwiKQ4egV35niziL?=
 =?us-ascii?Q?wrHsVPrVRRKrzv0+7CHud2KSTJ4EeMAbJsbL5iKGB6XkjcW0AZZSRUz3LboF?=
 =?us-ascii?Q?qD+26/5Sk4/KPEYmbHZBg4C5tgNPohd+DONi0bflXUUy78O2l8ynSpLB7EDG?=
 =?us-ascii?Q?3s+vJghUgrJZ9C2xeSiAXGy1mqt7TEDykiOg9z2cFEhck4wf8cs6lACZJIAU?=
 =?us-ascii?Q?xKdXAe0GBSJje740jFzFfvhJgdLhQdlNjncfzSN1SMFRS9Rn1Pqegex12CO0?=
 =?us-ascii?Q?9H5kkkMHpqTfhPLZcbEKjAbahFs/CXwpoNE9zLz4vlkTiEqXkJSrRc/GzDY+?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?3wcAd6Q46Y91c4A80RAWLOmK+zeFeXD3/A3jSNaY9OYhyDmqk9sW2yHYLH5r?=
 =?us-ascii?Q?Z3uEZOwEFhJ6Mxd/Xi+4Rq38ZFYRhlneHtaVxdK3SXMYKkeHgu6uM9TwwDHR?=
 =?us-ascii?Q?wgpCM+3owD0pcWoYHlG4RQzcSLZ6PUmf/kZ1xU1aZveE2XnfAl2qHmfGN6Lz?=
 =?us-ascii?Q?NV+sEgCbAk4YcfUU1O6l2xJ2/+5wg/x6vtOfLdH89WXN4O5VGy3CYln2eFK0?=
 =?us-ascii?Q?YQlV+97Gx3ShocEIUBqdSpPJ2Ah5vwttiGsdR13ISC9C9tpWWQYJOkU8UKTn?=
 =?us-ascii?Q?GTVxt8AgoFtYgiCOfpA0UTcf38JoUcb5fq/pwi9xXgQlvT1q2V2hduocu8lN?=
 =?us-ascii?Q?srUgfY7wMN8MbdMu2lw1dtHMHH5Hz/xUqs9jmZ21tXqXzQln1Ezrz17tQx9q?=
 =?us-ascii?Q?eJ1LXHLo2Uai5P6nTYLqs1dkm4GweUeoF+wMHHPlSRt/rUeE4y9cc+5OGRfB?=
 =?us-ascii?Q?v6d058d4CiPmt4QjZI8JPCccNKCmHQoCJ31awuOBRQT6pAhcXksP9YuI5TTw?=
 =?us-ascii?Q?cHyBiDQ6I0NzsGzgBK475/H5LLCgEEG6nG7cgx7N3v2nOVYbgRfjX//PnRgi?=
 =?us-ascii?Q?j3wYT9YBrzuFSyugmpGNhVm+GNqjJgAgErZm646JUN2wAnBXXa3DXwZ4tKCd?=
 =?us-ascii?Q?FTkED7B90ZFSJNx9pIKm5/Pn4i9DICqRyDQScsatpCpDs/x5qpr3mh6MUU81?=
 =?us-ascii?Q?Y0Zl6kv7c3nwaqwc/kK2YvjGhGbWB1tEA6/nza3JlVbERi8Uqq238vdSHSkg?=
 =?us-ascii?Q?v5KB1/ct57vs2DkwB5nW0yl4Dpk/Hr5Kne7P6UwJBjg8L44933QI8+G/gMnj?=
 =?us-ascii?Q?45gHuumhBtjv9fI42IHtoTkSZi5ttFfI5sH9PWJjNoHdwKabL5hDKOkJzBKZ?=
 =?us-ascii?Q?4a1f7B26aaqV48dCwa7GOnePyKLTtTB/2TPkfaBELvH7/9cY7Y/Q6JFXetw/?=
 =?us-ascii?Q?U+NES0m1HFm1eOOOFZAi6LWt9OL69GuJobgAQZ3BfzWDVGpdseBC2oUgMn6V?=
 =?us-ascii?Q?h4UI1SbA0OknHFelIArAd4zJ5DPtVNZiD61zl3wNzikyrmEmkaJ0wgh1Ii7g?=
 =?us-ascii?Q?NPiCk035cjRXl8sb3iKeoeIGQISWtA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18fc37c-0a21-49ee-4df5-08db0e29e33e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 01:22:07.4203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUR+kLT0Y6FR3sa7wkXE4WKF4urX/IJxHUSmfJlgXxOOLqaVBMDgnzXromApt7evTl1treoTsB3/WKgpy9pHlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6693
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_13,2023-02-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302140007
X-Proofpoint-GUID: KeWtY6L06kEWuf7qA_d1J0y4LljsyIk3
X-Proofpoint-ORIG-GUID: KeWtY6L06kEWuf7qA_d1J0y4LljsyIk3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/07/23 10:16, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Updated patch below.  Note that this depends on backport of upstream
commit 3489dbb696d25602aea8c3e669a6d43b76bd5358 which is already queued
up for 5.4-stable tree.

From 4e75ce608386f0a641455580b05e0a41d1dbba3b Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Thu, 26 Jan 2023 14:27:21 -0800
Subject: [PATCH] migrate: hugetlb: check for hugetlb shared PMD in node
 migration

commit 73bdf65ea74857d7fb2ec3067a3cec0e261b1462 upstream.

migrate_pages/mempolicy semantics state that CAP_SYS_NICE is required to
move pages shared with another process to a different node.  page_mapcount
> 1 is being used to determine if a hugetlb page is shared.  However, a
hugetlb page will have a mapcount of 1 if mapped by multiple processes via
a shared PMD.  As a result, hugetlb pages shared by multiple processes and
mapped with a shared PMD can be moved by a process without CAP_SYS_NICE.

To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is found
consider the page shared.

Link: https://lkml.kernel.org/r/20230126222721.222195-3-mike.kravetz@oracle.com
Fixes: e2d8cf405525 ("migrate: add hugepage migration code to migrate_pages()")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/mempolicy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index f7b231f67156..36c2a9619ba5 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -571,7 +571,8 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
 		goto unlock;
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
-	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1))
+	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
+	     !hugetlb_pmd_shared(pte)))
 		isolate_huge_page(page, qp->pagelist);
 unlock:
 	spin_unlock(ptl);
-- 
2.39.1

