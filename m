Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A3B675FB2
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 22:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjATVkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 16:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjATVkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 16:40:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8604F344
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 13:40:45 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30KJwqx2019685;
        Fri, 20 Jan 2023 21:40:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=5msPha1nEIIqC5d82NArUKl5Al/itnBPtjQHAwGw+jY=;
 b=CPAMhnMNvKld/XpzfIaOD7Nxr7s2KXIWD6twqylmMZ5kT6hvK4f72kPlLmDRhDBCMYBX
 Pa8gspXrfLjXce5+WaH8KlHmwmMlVrzM24jqgxPZIWRkzj4J2tjz4k3YccIELI7/4Uzx
 BCSG6cEG3LZprmSn7WZR/QIOqkf9/DyAgNYL11HlDbwJrJWSEt71Dtx68zzLnTNePqug
 DJS1ajZAjgjk4epXjD/JsrAV1fGJtp24yIe5MYTCzqWmItrylp+fnLaDboq8Rf+3OkH8
 gt6w5rbRE96KxMEwgAA/a4Nba4GcoD9VN5pctFV0Khz6yVC6J3+hQYSILWIjjI4ug+eX tA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3m0twr75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 21:40:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30KKsTYs007723;
        Fri, 20 Jan 2023 21:40:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n6rgf2usq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 21:40:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=keKGUhCqZgeQBQzjFqmCZKNB274R227ANchvNIY+K9auK48EXXZNyiiH9JP8vdwusSVGIWpQXoBibKG9hxy9RmDjCwQ2/AwGUx2Do82JzJopTbTy9LbFuo85m8uy1ORobftjRzPCnTto9JuMKZAbr9Xu9BcPAJ3BkN3ctFsJ6VEIzAbJ4GntkKAdcTdyXcYjBFIaJ+1djy8zs40TEgiOjpvseBCUXUs84YtstUo8mFLUa/9mKIjxmRdvvBgxLp0ySqGMTwRR+neBDr0gpGEQcFlIvw15Z3NyKeZ++izmcfbvRXNzXoplV4iEv8x6nhuEySb/iQ6CkhMgn9E6lUIxMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5msPha1nEIIqC5d82NArUKl5Al/itnBPtjQHAwGw+jY=;
 b=dT/HQBSvecPi4PJrgA6H6hYnbFNoZY7evEfWe5NPWrZpOhw7yhyb82UT52e6ePV+GZbZ3xR8Mk3BeQytrQry8YYHJiLbmMcWsegTTs5j8z+JzvjIG+I0jt34cV8QIt0nuvrWoD70PxoJRv/VLBqbXMMXJrFJn5bqkcP5kvvyKpX2qM0kZwTo1vbixqeGoc5FoXVfjwCwZ3G9FrBuI6sYmx4R7ffQrH0xtm9ztp5dcNtBBNuoEykvpFDs+tv7sIbA0GW6hNBc9fW4c6fGVw7Dgck8qapAGcFF4yqK0ViXETNCb96kJDwEU6rqkmv02ZmtzD/MeHlIAfIj0O3/d+gtBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5msPha1nEIIqC5d82NArUKl5Al/itnBPtjQHAwGw+jY=;
 b=mDbxTXeWxo6AgY+Ko4dUMXz4G4f+ovv839Y0ImBVJ99XDWiUuitl98aCzIiTj955yU3+5Bn7UyzTsT0cc4ICyGfa2eJC3ZtcJ+uqqOd/yzgIVl4LCf1c16uD1bR+3M0J6awmVsJmznSzzdN4ZUBJQLL7V7LpgGbAFUM9i5clOJ8=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SA1PR10MB6469.namprd10.prod.outlook.com (2603:10b6:806:29d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Fri, 20 Jan
 2023 21:40:37 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.6002.011; Fri, 20 Jan 2023
 21:40:37 +0000
Date:   Fri, 20 Jan 2023 14:40:32 -0700
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 5.15] cpufreq: governor: Use kobject release() method to
 free dbs_data
Message-ID: <20230120214032.uzq6dgpzhfi7quol@oracle.com>
References: <20230120042650.3722921-1-haokexin@gmail.com>
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230120042650.3722921-1-haokexin@gmail.com>
X-ClientProxiedBy: SN1PR12CA0108.namprd12.prod.outlook.com
 (2603:10b6:802:21::43) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SA1PR10MB6469:EE_
X-MS-Office365-Filtering-Correlation-Id: ae289b0e-a393-4bae-6cb5-08dafb2ef7bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ywCx6fMn9JFUiLXO0+CToslrfOJts/Lpom7kuxEAY9mL2v+RZnyRmCHUYYdKoRpSsVa7iwV20HWfZeUFpK/9yGfaj4EGuiYsHQ345cwguVu+YzrA9jLNO2TgNlGbj6nhi9HcMbQI5saqvPxSC8HLPtjqD/mi5Q7qmrvVk+UB99AltlBrKTuqQGDTedLT8Lz8YXSA3RVBGrqXnOhU2Aoo5XaKTUZGfeeQ4QoIgpScaFe5Jisz0LncNNdCfFWEJprokRk2+aAoL5VveU+BIpzbgb/IBef/mcRDNdQPnDiBWdXE/Q5fRihzHliFsZufWw1qFMX2m6Aqc+VQ8KOgeVAFmZbqWASgg0QDLK9MzC3O+mm1B7pv6hZddqGpxg/jxbOphtLH3y/VQdif3k9Ux3FLy9qwMkzoZaqTEUqQ4V/p8IEG3WZ0s6tV4LlDKVdAwzUu+8tQrB6OzlBdct0titJaiUN6ViLVe9UUY+SwWmHHbAj9PQfG4hHlM+BoiwfIVCWGQZDAVJJpbL+2kHBUaFP4AEJ7R41Nf3mJgu59S3IVS2or6UHIwTU9W6bUt5/2psOWKxsr0kLCTk71BvsmcaWBha4PGZn1hsBk5vKioQnTcBLTXue5p24tsVtvlocZSlxhajfLPX+HyQdPOfMwDCIrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(346002)(396003)(366004)(451199015)(6506007)(86362001)(2906002)(8936002)(44832011)(66476007)(5660300002)(38100700002)(66946007)(66556008)(316002)(6666004)(45080400002)(54906003)(36756003)(6486002)(4326008)(478600001)(6916009)(186003)(1076003)(41300700001)(8676002)(2616005)(83380400001)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cz72bnRG2NSaH/K6WKT1VlBWi7XnfKHjMRUfxaFI1ouPcfcMirSOXpBMvnuQ?=
 =?us-ascii?Q?vZmd8Rvb+dXhuwqwXFk6lApT3gu+AeGu0pH0u58+li6JThonBecpF0/BqfRC?=
 =?us-ascii?Q?jYxhsfEkqezxuB3KgrY4Ek1tmvmmGkhhHzdknprojLx3A90e20EG0lEdfAc5?=
 =?us-ascii?Q?2lot424NlyPHGnMBCncTmal5K3xNDjFd5OyAxRqsVlJiepm/TnFkX0RGAxy7?=
 =?us-ascii?Q?jQNRMYkLZ6tWXAr5esLKqVZbJdJtrEEJd9xo1dfsmXXV+LWNvpnQfqkBMMqI?=
 =?us-ascii?Q?k8jG5K/9NftjNTOW4TlnLuF66+3vMui/EtWgVVuD0crZr6aJ6a6RJOcq+DsR?=
 =?us-ascii?Q?RI5paJVIX99LJMsd6qGTrzK186TwaryQ9v7OXKq+i1b2AoLF5XJSj/24rVqY?=
 =?us-ascii?Q?A+c6mV1zVl1JrrVSoZ+Q0E8ch7N67EAv51FfwmKutPxDWTPGVTwTZoA+HdnP?=
 =?us-ascii?Q?ReCLf5Zd8jqstnlVdSpSZvPzQjbNoz+F4+LDvbDtRqogmjRsxPbWwLD31vnv?=
 =?us-ascii?Q?TiCs991FdwjA/hJ26sNmk6qvJBXWMEI1da5ay5En83pb1nlOf1TNNLItQpAS?=
 =?us-ascii?Q?Sr3GYcjoc3QgAQ19jinmZrRE2HrDyvQbPE4P1dpsqPqmefjTwePGbT1Uk/bn?=
 =?us-ascii?Q?+dc0bjQx1tO1CCHJSbmrjdsi5pHUKaamELJPHrNwLvFJMpkvXqdhEKKMNvK9?=
 =?us-ascii?Q?x0ECCrNO0BvUhRMAmnZzNdQ7P4TFDnB+GkdNsm1LIOa/84zLNcVmFE1zSq3C?=
 =?us-ascii?Q?ws+woFrjh1SY4nIO8gDp16hycw+B4Yt2poczk3K4lHAu72pcvn/pNR4ZyT3n?=
 =?us-ascii?Q?MumyhGMz4vNqcDGX19VZEi5idTfObcOwr17saWHZv6G+Sf0vxE09cNNA964I?=
 =?us-ascii?Q?v1CAx+FxIcb7/kU8Gr6C/I4kPCzD3lQYj+605fIi3/mojaztgmlpRCgJnA5M?=
 =?us-ascii?Q?HsXvd8uazWFdShoCjFpJDHXlnIE0JSiFcHeUEDigsBjm47PjwHqKLvGUUdY3?=
 =?us-ascii?Q?D0kubgMlWTXE41Cs8pleibbZE9YNWCN4dHIoExG70NTfb5U0GfE4I78dCSil?=
 =?us-ascii?Q?3XOPSqfnAQ3Wav7+BKFKu3hGXMUUJ++SlziDCwvolUJ1FNApAvuikkTP9Qq6?=
 =?us-ascii?Q?k4raPPzrKbgSAV1kMSuxzcV0nUfhplgq4OfU8ZBJ2ExNa2GhOPBvtIRyxeFh?=
 =?us-ascii?Q?uOG/ukytbVutn90j/ENXRXjyjbZKPsNrT95Qkx9xYNMqma9vZKF/HFeqqnBi?=
 =?us-ascii?Q?aGGPnbxWdrVgQHoLvGaf111SJys8xrIl19lxpidyPKa1DvssUGbrJKySwWVB?=
 =?us-ascii?Q?dSmRkqqgLAbhwqTxbpAaxVxXuHmM/Z6o09pptVvP4NyOeyO5L+xQNHx1xXb5?=
 =?us-ascii?Q?RuRDME8aEfAydTJdGXdwuMJxS3EIgiqGDbYqw9M3qlufjcV0U7LsX06nNjro?=
 =?us-ascii?Q?H4AX26Q37VE8HS9r23yPAhujT8wOGOa4SzKTq+cUw1FcAZ6T2zeoOpor0+Zx?=
 =?us-ascii?Q?06b8zm7h5MZY2uwkpAqsiMaOZv2SqacYydeJKGN2ZoUjT+bU1z64/mEPy9Oi?=
 =?us-ascii?Q?egK72KXqfaaMeHlBpVElYRIplS6oEa/s6CCuN/q4AviMJqoKHJ2NqhN34hrH?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +oX8n5s8kjlMArVy1oqmYeRAwzQ0T4du8i5Ce2UN0zLga3klMjq/PASiaWk7KVBcprs+yoyPqEF2EJJwLRhgM/octZlnvkaXkoG3y/76lX8zh8Jrqb1a1Ee6vE2Yu+jnbWzNCjtAwvGOElSmu/KtjbxG4oX/cMqsdegeUet46adkzRdsDIW4Ah7gxQ0CVxZsfcOc7WOmxEBdXF4PA8CnWmcDilRpuyiMtEXTP3vEkjOfPYTSgAyx3L5xXIP7oIGx5Q866+icK4ppQ5YiJI/PAo/sVSnjKB7LhOh5Myfrwtm5Ws/ZSA6Ba2uX06PbtS/AYa5nG16xxb5vTjZMKYeOTH4yaHYMr/XvTWT1MCnLKav7ocPbp2/eQyckhaH4r7d6208lUEuFBakeC3Xx5ALMVv4E8aB5In209bgeAKzuAxpODqqg/3l94p0c0fJLAFyh1zsnARTrSaElcc6E8+5ef9B1KGR/BG+0tQiKNro/Kp9A9JFY/LO7XI5XC0RfGz8TSlbu3WpCSIdGbo2C1Q1dZUqQSbI6hN5Zzva4yfYL8Hjsm2f1LcOFOCla4MIOrZgen8U18I4K6P0v4WcP842OGhE4dJo9P00VXoqMDuHP9dU0xtdwlWLRZH11Pn5Oht0rcDpHjLsNTs64CXfq9czB1+bf6WVwPxWnAcplw8JNW8ynkSNo2PwyWezQnify4w8Qyl++rK8YyE5wZYetysGYwyLiD9gdorPCnz4Mk2GbxdF8HyqCOtXJEPJ3U0iBU7uo7eKfY5IknwAxgg/cxrcu8ECaZ6EK1lriFFpUnqlBaprAe4FkQihN2JzE1DsqoAXQ+WY5rX6yQBFDIaSIg5edwbKoMgVmgKA80pcmOXuZo2WjfKd8YM62NaA6Dm2MrPYkvE1hEQ17CDawBsVKYAtqyg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae289b0e-a393-4bae-6cb5-08dafb2ef7bd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 21:40:37.4175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mfl9lWrx/G7WGpZnG7AoVrivRqaFeVUpHxHsBx24rxmAQnBpryxxizNKbrz9MUys/WLqcxrFUiWjBmO+naHf8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6469
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_11,2023-01-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 mlxlogscore=749
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301200207
X-Proofpoint-GUID: L2T49jRBwiy18_F8P5zI_0zppCoN7qKP
X-Proofpoint-ORIG-GUID: L2T49jRBwiy18_F8P5zI_0zppCoN7qKP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 20, 2023 at 12:26:50PM +0800, Kevin Hao wrote:
> commit a85ee6401a47ae3fc64ba506cacb3e7873823c65 upstream.
> 
> The struct dbs_data embeds a struct gov_attr_set and
> the struct gov_attr_set embeds a kobject. Since every kobject must have
> a release() method and we can't use kfree() to free it directly,
> so introduce cpufreq_dbs_data_release() to release the dbs_data via
> the kobject::release() method. This fixes the calltrace like below:
> 
>   ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x34
>   WARNING: CPU: 12 PID: 810 at lib/debugobjects.c:505 debug_print_object+0xb8/0x100
>   Modules linked in:
>   CPU: 12 PID: 810 Comm: sh Not tainted 5.16.0-next-20220120-yocto-standard+ #536
>   Hardware name: Marvell OcteonTX CN96XX board (DT)
>   pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>   pc : debug_print_object+0xb8/0x100
>   lr : debug_print_object+0xb8/0x100
>   sp : ffff80001dfcf9a0
>   x29: ffff80001dfcf9a0 x28: 0000000000000001 x27: ffff0001464f0000
>   x26: 0000000000000000 x25: ffff8000090e3f00 x24: ffff80000af60210
>   x23: ffff8000094dfb78 x22: ffff8000090e3f00 x21: ffff0001080b7118
>   x20: ffff80000aeb2430 x19: ffff800009e8f5e0 x18: 0000000000000000
>   x17: 0000000000000002 x16: 00004d62e58be040 x15: 013590470523aff8
>   x14: ffff8000090e1828 x13: 0000000001359047 x12: 00000000f5257d14
>   x11: 0000000000040591 x10: 0000000066c1ffea x9 : ffff8000080d15e0
>   x8 : ffff80000a1765a8 x7 : 0000000000000000 x6 : 0000000000000001
>   x5 : ffff800009e8c000 x4 : ffff800009e8c760 x3 : 0000000000000000
>   x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0001474ed040
>   Call trace:
>    debug_print_object+0xb8/0x100
>    __debug_check_no_obj_freed+0x1d0/0x25c
>    debug_check_no_obj_freed+0x24/0xa0
>    kfree+0x11c/0x440
>    cpufreq_dbs_governor_exit+0xa8/0xac
>    cpufreq_exit_governor+0x44/0x90
>    cpufreq_set_policy+0x29c/0x570
>    store_scaling_governor+0x110/0x154
>    store+0xb0/0xe0
>    sysfs_kf_write+0x58/0x84
>    kernfs_fop_write_iter+0x12c/0x1c0
>    new_sync_write+0xf0/0x18c
>    vfs_write+0x1cc/0x220
>    ksys_write+0x74/0x100
>    __arm64_sys_write+0x28/0x3c
>    invoke_syscall.constprop.0+0x58/0xf0
>    do_el0_svc+0x70/0x170
>    el0_svc+0x54/0x190
>    el0t_64_sync_handler+0xa4/0x130
>    el0t_64_sync+0x1a0/0x1a4
>   irq event stamp: 189006
>   hardirqs last  enabled at (189005): [<ffff8000080849d0>] finish_task_switch.isra.0+0xe0/0x2c0
>   hardirqs last disabled at (189006): [<ffff8000090667a4>] el1_dbg+0x24/0xa0
>   softirqs last  enabled at (188966): [<ffff8000080106d0>] __do_softirq+0x4b0/0x6a0
>   softirqs last disabled at (188957): [<ffff80000804a618>] __irq_exit_rcu+0x108/0x1a4
> 
> [ rjw: Because can be freed by the gov_attr_set_put() in
>   cpufreq_dbs_governor_exit() now, it is also necessary to put the
>   invocation of the governor ->exit() callback into the new
>   cpufreq_dbs_data_release() function. ]
> 
> Fixes: c4435630361d ("cpufreq: governor: New sysfs show/store callbacks for governor tunables")
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> Hi,
> 
> The original upstream patch has the Fixes tag, but I have no idea why it
> wasn't picked up by the 5.15 stable kernel. So resend it to the linux stable.
> The original upstream patch can apply to the 5.15.y kernel cleanly.

applies but has build error:

/home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_governor.c: In function ‘cpufreq_dbs_data_release’:
/home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_governor.c:393:49: error: implicit declaration of function ‘to_gov_attr_set’ [-Werror=implicit-function-declaration]
  393 |         struct dbs_data *dbs_data = to_dbs_data(to_gov_attr_set(kobj));
      |                                                 ^~~~~~~~~~~~~~~
/home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_governor.c:393:49: warning: passing argument 1 of ‘to_dbs_data’ makes pointer from integer without a cast [-Wint-conversion]
  393 |         struct dbs_data *dbs_data = to_dbs_data(to_gov_attr_set(kobj));
      |                                                 ^~~~~~~~~~~~~~~~~~~~~
      |                                                 |
      |                                                 int
In file included from /home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_governor.c:20:
/home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_governor.h:49:65: note: expected ‘struct gov_attr_set *’ but argument is of type ‘int’
   49 | static inline struct dbs_data *to_dbs_data(struct gov_attr_set *attr_set)
      |                                            ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~
cc1: some warnings being treated as errors


5.15.y first with:
ae2650865127 ("cpufreq: Move to_gov_attr_set() to cpufreq.h")

then
a85ee6401a47 ("cpufreq: governor: Use kobject release() method to free dbs_data")

compiled clean


Regards,
--Tom
