Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771DD6624C5
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 12:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbjAILzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 06:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236787AbjAILy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 06:54:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE95B1929C;
        Mon,  9 Jan 2023 03:54:55 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309BUVkZ023385;
        Mon, 9 Jan 2023 11:54:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : references : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=PBPdY4IJkDIfvn2rZwzmbEvNO2pA4TyuBazLMOpk+fQ=;
 b=q7EM0F11DR+KYoh0SGZjYyazUNLFvlVg342X1W9JmwPhe+OJ3UavgxVxeo07ix4/tJMb
 K7LoK+v2lWK4xrIGDHKFAihuGgD4x1Fh5TMD9F497xQcZHx50ZwmGlSly3KPOKsNfBqN
 EmMqdsSJ5tfm1oSamji19gzXKd8fcgiOz5G5aaDrp+MTEU+WEXArNheqrx0SYwLPBsT2
 LUG0l1G17KQiErJYP01tDkuwB7kBBTImZHp6p0I07bzaj8qSIigZBfR8lY6alwIkGOdp
 R2yJ7MtYcWhilTfWGhPCJ87kBhBsc3YJsI2EvLzeyls180uYNfYyYEVYqgih+uXFDwKW Dg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mycxb9vh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 11:54:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309AbxJh000715;
        Mon, 9 Jan 2023 11:54:50 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mxy63v4wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 11:54:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0lNWBtqwCmx8Fk8LVqaOEQWJx/CzkCMiqvvhY+/t+9J6HGQD0Mhav3KUZsjzCu0H5oEqocu0N/tSWKIWIW8byWuRLkIfobQ5woAuRdJ7vTWzTRJoi6ZxI5ZfY6KIQQjSIdfaP6pYF0+D4X5d/eilKMQ9OEvZ0ucdu/1s/o0dBjuBCbFMWEgv/S6G2TEZGUIivR8Z3w2OGF2DCAXqBLA/pb515tcu72/xSZTfqtcLKclQ8bZwzJnDUno9EZgoUoMevY/f7+vid+EmBfBoI6M3wlwpWXeSJ7KEiYj1HMav7AopTlVUE2GqSH7UY76v1Vr55wiMkm0GKZdzEyhAQFeIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBPdY4IJkDIfvn2rZwzmbEvNO2pA4TyuBazLMOpk+fQ=;
 b=f6XzclL3rgItWj19pMqh+IONCEuCH02rVFxqYgE3D1PI7NCjlvX7+HLSpF+PXXxfvqajz4qDGQV9IQdGjGMJhBQU85H856VOA/lP4Wy8lDtS+VDLTxdYn5UWaWvNovGSy+mESgQDFi6OodfSNVopOcki+M06lsThXhiJgXX5nDr1mgsqClSJWcFSmI8zWUwuujDXDDCYtCEIpRd8zlIEFnkMCms73IOn7Ic7wcsvhhxeWSlEqIdSiZzOTB5BSqfqoWzNFDfcE8NrsrTHgPQ5F1Wz9btfrMqgoOhhmC7ILBEhT966Aq9ZyryPY3tQoE01TE9qhJHL1bj+XUYosh5yNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBPdY4IJkDIfvn2rZwzmbEvNO2pA4TyuBazLMOpk+fQ=;
 b=L4JpzBfwGFYBbI2dPMHOUxaw7/Kg3QtZzvEASi2gUbECvHznNivougHT4U9CiXYk60ih/dMZ6E7g/I1MM19IQhKhkLbEawfT5pdMVixFYsRsuiKCnBINizWkynfNeKtXqREd7An/ngnCCDKApTdNEvlOeAAvsexGBKnzxUb7Ruw=
Received: from DS0PR10MB6798.namprd10.prod.outlook.com (2603:10b6:8:13c::20)
 by CH0PR10MB5258.namprd10.prod.outlook.com (2603:10b6:610:c9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Mon, 9 Jan
 2023 11:54:48 +0000
Received: from DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::b30f:e3aa:6ba:5c8d]) by DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::b30f:e3aa:6ba:5c8d%5]) with mapi id 15.20.6002.009; Mon, 9 Jan 2023
 11:54:48 +0000
From:   Nick Alcock <nick.alcock@oracle.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Allen Webb <allenwebb@google.com>,
        Nick Alcock <nick.alcock@oracle.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v9 02/10] rockchip-mailbox: Fix typo
References: <20221219191855.2010466-1-allenwebb@google.com>
        <20221219204619.2205248-1-allenwebb@google.com>
        <20221219204619.2205248-3-allenwebb@google.com>
        <Y6FaUynXTrYD6OYT@kroah.com>
        <CAJzde04Hbd2+s-Bqog2V81dBEeZD7WWaFCf2BkesQS4yUAKiNA@mail.gmail.com>
        <Y6H6/U0w96Z4kpDn@bombadil.infradead.org>
        <CAJzde04igO0LJ46Hsbcm-hJBFtPdqJC6svaoMkb3WBG0e1fGBw@mail.gmail.com>
        <Y6IDOwxOxZpsdtiu@bombadil.infradead.org>
Emacs:  featuring the world's first municipal garbage collector!
Date:   Mon, 09 Jan 2023 11:54:43 +0000
In-Reply-To: <Y6IDOwxOxZpsdtiu@bombadil.infradead.org> (Luis Chamberlain's
        message of "Tue, 20 Dec 2022 10:47:23 -0800")
Message-ID: <87cz7nsz24.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1.91 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0209.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::16) To DS0PR10MB6798.namprd10.prod.outlook.com
 (2603:10b6:8:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB6798:EE_|CH0PR10MB5258:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f74a879-2c02-4bb2-3192-08daf2384e9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q3otplNdA50MFte46N14yKCx4ssgQetJ55HUo3XGTqMtLp7ScGaYxkQZBOOl9OY4q7IyD59R2T8tSSmskrh4lVl4bPp0F/TrtC9xa5TRXkpnaZu/8ksaXeI4bSG/rHxBjpUSEX24YHLpisqMomg7eFtx637gYlAGY+9f07kUpJn+WXLcV/jZF4dk6m3Gr7NqyCg7WkS7imq4ERZmtQ1Ty+zyzx3zDFR059E/f6G3c3LJ9JRfXM92pn9DwkIT7stn2aJXVHdKOx5daVI5QSXnylvUQQ3hSSZha7+z8m19VBEr3nwW8AUc9ESDeBwLxB17XQldm8byxioIuDhV1ELGJfjCLWSch2+9aM+VVQyjQgZwrJExGC0kyxwuEgy2er3mzWc0Vw04Xp4ylcoE+RTVV7LeT0jJchaDeVBB4OPeSRH4DsTAmJsbkpKimHlmJ3+sp2IDKxERATFVh5S0n80+p3sOiABYlAdz2/jT25rXroRk7OP7eP1FMIbaK6aV4skBUbUQfYCj/SQkmoUX2X8HnkBPjsrEUYyjkbtE1Cfs4Bb5/ZjLJ2XeRkKVC9oExUMBcjlGSu2XHwqoS+j18tr6gL9KyPYIFbFAUzYT7AvvGIzjtCJyc1OvjPjR1Bya/KnIPL51w94o+g5rgkl8mTKoAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB6798.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(396003)(376002)(136003)(451199015)(66899015)(36756003)(86362001)(2906002)(8676002)(8936002)(66946007)(66556008)(4326008)(66476007)(44832011)(6916009)(5660300002)(7416002)(83380400001)(38100700002)(478600001)(316002)(54906003)(6486002)(41300700001)(6512007)(186003)(9686003)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g8oR8f+2kETmRB5lY1st7AxVAlgo4MXOz3EY8DlTukq4Ak4WAqTDoat/kOTb?=
 =?us-ascii?Q?1F7MW8z04ixGl06hAvqIAPUHVxiJYTZmT0DzVZVXaDzZDWRejJIq6jDq9/xr?=
 =?us-ascii?Q?KSi5wGB6QB3xFos6uLk191SKcbkfHVJNnns3n9cs/CILab1nsUpzTxXvoPXb?=
 =?us-ascii?Q?bqPHutZtrndYBF99JF31fPHJVRyCd2iUpg+1q1dO8C1F2UMh6AcxY7qp5sic?=
 =?us-ascii?Q?84M7mb8a6RoTBycYGWmlW8ajYvAulRo7dWy+m+gh65//1bpoCAWJPRt5GwbA?=
 =?us-ascii?Q?fr3hw8GVKIkbWPRxboFO//MZweurYbu2HCrOTT9+mid9XsqbwrT3+93Cg8IK?=
 =?us-ascii?Q?Ize6qsurqHbqX14TateEXlUr8tViw6I7cztbzn76RGPQJ/An+bxW6qgT79HG?=
 =?us-ascii?Q?cen6mrGWF6WkLrWNTMA2LYrZ2UIbjz2ya+4nHhOXMFMUMMKqr5m0Gzh4w+Le?=
 =?us-ascii?Q?lVtLTwXCCe6jsokxN2BQoQn/Monu9m4xe7y5ZIF2CZ0iy54TQPHiNFYpfjZI?=
 =?us-ascii?Q?f5zL0V1yPZ/UOYkqWKRVCyX4DRORA6uU33MK36iXamNwTlXpAAqo8knKUJ0X?=
 =?us-ascii?Q?p5suM5wK6iNh3r1u1uxSyiT18Gnov+yKTDiKyCo2Rsm2oyPCSURa8nW5bTtp?=
 =?us-ascii?Q?yal/t7KRvPP6Yn7DxDRPvlTQXCtH21fx1cBB1LrP2WmOmE6efU1aEzWmxLmt?=
 =?us-ascii?Q?f7duSKEbT05UzbtoH1y/QI2kwdug1xr0/8usRdX7R84qA0nt+cRdRcb+vaZ9?=
 =?us-ascii?Q?+6sJD3zmprIQlnFG5jZFcWMLDbaMfoK6aasRBDGY+NjDwAjw5Bm34ga1wL+i?=
 =?us-ascii?Q?OsFfmeMpmuSEkM6njr+AL9DBGGQ4JjNkW+iBnr3nWmhkGXH35cp6I0sn5yES?=
 =?us-ascii?Q?G2ueWoCVfsX+fQEb26aHxw2uL0cVOjyuFHDXTQA3HcUBruSM2sJ7mt23L7DC?=
 =?us-ascii?Q?O7+prwaSscCDy8wSVcthO6VMssQfsa9so75TLEEP83m8+Y0HzvsWdjOwnQUn?=
 =?us-ascii?Q?uY6I2wY3ULM1MW/0YpxnCNN+EuB2dhHKL8toydElo3H/wd0OrRyDdaucxOXO?=
 =?us-ascii?Q?FXWhKqDm+SKYyUtgCPKlnnnvIzrFqYzsqBOXXrmCcoi5PzE081FimNk3/kQG?=
 =?us-ascii?Q?mqZtJIX5bTaYuirQ6fjktcfLpBxK3oTFeMeKFllTUL5vosk/llqonXMZ52iF?=
 =?us-ascii?Q?9HoTEuTxXImsuXRsUNYtVi5wVn6Qws5J6oVo7HcPFGjIyNChic1jVJ8x9DF/?=
 =?us-ascii?Q?Hx3l25X1S9op717j65Jdtx23WgVTc32bNY+LYkE8VKWmEUplf9cyA2xYtJzj?=
 =?us-ascii?Q?hNjVOtBW2c4I4rLJgB+fYFyYcLKE4xktUrtuYrMBkdc+jEY0A72UYt6TR5cu?=
 =?us-ascii?Q?sV7GkUnjZtiOcLZopjySK3o8EPHlWrUrIfFQmfXSFz1g4rpznYcrSxPUf/E1?=
 =?us-ascii?Q?JpVD8qYKsCmmY6MDqK5Ycqum7ABd9sOSqSQGbNvw5uaOQrVaVx2G5k8jTYkr?=
 =?us-ascii?Q?eAqeZ9+6AdcOhdpnFwHgpZ9Iz+RGSS3JAtzjf/7ru1EoEBh1GzAX3Yupsmai?=
 =?us-ascii?Q?+9jeHvaEhQAyLUwHPEZg4jMjUYyLc6QzQdsj9qDlAZ/UaZZX5bUPK4uJhyaN?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GIz+c5MrKGgZ+qKTmVXKB1UBE8jEBtMBWWwDLWrpyw2Upud/7/WqxyREwsxEZIlRneuhDtNFH3m2RYjd9ehcvNq7FABm6ao/TMfA24oheo3tgTUSfbb5lSyeUgZkTvMa7DMPtpqIQhZIOz0GZVumoAKElX2zeXE5pDZhQPCuf2z5kiJPQ7hjfEmMBuPNVS4we2XXzmo6ZjR0BBrGRnszNNn/dfKUAS0ZFdfCe7ZUvEEhiup1joyH+P5og6hSDOZjDmrpY4VRcFaRoLXUTpqZFYUzxI9tlHMtVbklp64XMhsNDRjNBBV2F1Ah+iY+YoTYXz8UaM0OqxE1Vt/VwbcgoQyhOw+SZ7+RXqgToCHIVIw/1YUMK/8Jun3Rdi7QYyazfO6S0nxS/OD4LypsXUQGCnyksb6UEHocnZ2dd9HcXTBT7LmhBlvpRDwNseho/mtKNBwNHL/hjiWpxe2BJACuiRaUSqXBBfsNUyPiSf/Xj2ntw3KPQZpgyJa4SRT7gkv/KgoLzrsvqgvl2TcLphmGkHDxs4YILKYRIaqln6FNkgzkd4m/inL+tES3fAlE02Gh3jb0RDtabXL+rPAA19rOS18tSi357je+MnKY7XrgG+XG2p6QRO4vbwNbxMDW7FSKztQqhLYH+CKl7AA6worUsaJUHqKMgmR0ZSI1SZL6F/oLF+sLXB8M1DTEzZ6sprk6WOrrZildMTs4I/LnYC5zP4dyjH0kYg5WHI4gH/hYLq1wQUDH7LfSopwP6Q5FjMtbORO/9ApTn5PT5JlRe76mYrJUUbkMCf/IWJd/IWI0cjUgQZ/UfYEhVS95Uyp1i5w8wUBqvivII8MxKtU42LcHl4KioIXRZG3oVZaepw6b4Oz2OUT8c7SKEl2d47BxdJoFXflhM0mJDBVb9RxPnS5QAg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f74a879-2c02-4bb2-3192-08daf2384e9f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB6798.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 11:54:47.9524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ckBn359WYP4+3KGc+nXZwEFY8JS+57e5bd+sDg2MSjd82vanAZsH+8gakxKizBzuJAt5flPbPn91+RxqW9gXJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5258
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_05,2023-01-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=615 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090085
X-Proofpoint-GUID: yW36OEsOiDRnYcTcHhfWitIia6SfmOXo
X-Proofpoint-ORIG-GUID: yW36OEsOiDRnYcTcHhfWitIia6SfmOXo
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20 Dec 2022, Luis Chamberlain uttered the following:
>> It also raises the question how many modules have device tables, but
>> do not call MODULE_DEVICE_TABLE since they are only ever built-in.
>> Maybe there should be some build time enforcement mechanism to make
>> sure that these are consistent.
>
> Definitely, Nick Alcock is doing some related work where the semantics
> of built-in modules needs to be clearer, he for instance is now removing
> a few MODULE_() macros for things which *are never* modules, and this is
> because after commit 8b41fc4454e ("kbuild: create modules.builtin
> without Makefile.modbuiltin or tristate.conf") we rely on the module
> license tag to generate the modules.builtin file. Without that commit
> we end up traversing the source tree twice. Nick's work builds on
> that work and futher clarifies these semantics by adding tooling which
> complains when something which is *never* capable of being a module
> uses module macros. The macro you are extending, MODULE_DEVICE_TABLE(),
> today is a no-op for built-in, but you are adding support to extend it
> for built-in stuff. Nick's work will help with clarifying symbol locality
> and so he may be interested in your association for the data in
> MODULE_DEVICE_TABLE and how you associate to a respective would-be
> module. His work is useful for making tracing more accurate with respect
> to symbol associations, so the data in MODULE_DEVICE_TABLE() may be
> useful as well to him.

The kallmodsyms module info (and, thus, modules.builtin) and
MODULE_DEVICE_TABLE do seem interestingly related. I wonder if we can in
future reuse at least the module names so we can save a few KiB more
space... (in this case, the canonical copy should probably be the one in
kallmodsyms, because that lets kallmodsyms reuse strings where modules
and their source file have similar names. Something for the future...)

> You folks may want to Cc each other on your patches.

I'd welcome that.

btw, do you want another kallmodsyms patch series from me just arranging
to drop fewer MODULE_ entries from non-modules (just MODULE_LICENSE) or
would this be considered noise for now? (Are we deadlocked on each
other, or are you still looking at the last series I sent, which I think
was v10 in late November?)

-- 
NULL && (void)
