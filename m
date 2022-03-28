Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A32D4E9941
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 16:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbiC1OWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 10:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243755AbiC1OWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 10:22:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70C05DE65;
        Mon, 28 Mar 2022 07:20:29 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22SCtobh023952;
        Mon, 28 Mar 2022 14:20:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=A8Nvn0ddLbQOOP4jsW+HlVq3QzerNa+RKyjHHqZI7io=;
 b=LZRaFEUt9cL8mqWC3ZGAVgIVMj4Mn/8jQQudi8DtIcSHhWniqWy6UjOimtiLrs/PuTyB
 qI96R3b1ZC+HiElyw//DvgoKIl8p7IDgnqB9FPT9C/wIlzpJqhMMsKK9EdAQkpHChC8u
 Q/BlxnLp8SVQ7WArD5/ru1SVio8akX7wRDfw1Yzhl/nc02pQjxP946ij5r6eVi6SZfnm
 DRdZ6zAgEiqN/TYMuvyV08+/q44tddksbRliODIy/BxPe6XRrAVWkJGjmVAXqHI39oRR
 JdZccK0dPBNU5u71iBAFiw/EfPE1tcEYyRkqhcjsP1jyzqoERyMWKh2dFqpTxxf6XX1W Bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1s8ckn62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 14:20:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22SEFxvx144355;
        Mon, 28 Mar 2022 14:20:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3020.oracle.com with ESMTP id 3f1v9fcbnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 14:20:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdoQoU3g7eJ+1rDDPwsKZMEiZx/0yE51+aFxOL7nq13rKm0FMC47FsIwzjiwyZL7xuh88aekyQ9m7ZEQlvM6sxIb0ubVLc8yLo5Qkn9BA7QWcU3P7rYrYgpJrlsv8c/DD0hqZoppi8TmvwR9trLtWh/L9BAVDL6+DG9vbTniLSN7LbwnJV0Cudv6k0R6LKeeT2Z7zdG0GZHYdmrFmwit2leRIQOuUgYyh3qV0IdpSim99RKg/h/xKhLz3FPb83t3h30ZUx/IA0D3jSvhYyTq8FLHkkefrhQYh5no7YY4bnnVagMG3RmgAjNm48MHoL2IPneRrcS4LLE7XaEr1oujxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8Nvn0ddLbQOOP4jsW+HlVq3QzerNa+RKyjHHqZI7io=;
 b=iwrPoFiILm8oZf4BgPP0x03ieF+ckPQRQUQHoNMYbVaz13mURaa6Q/mJkoF2m4+yiWFr3gJksWys3i5F1iAUDCY9awwaMPBIOw1F6A9UYgIUvVcF7tLcTdLJt8lkTqS9hFKt8vpsFoppOF1RCaLwQMQpKgYsidupJU4qGLs5ByxD5XMeLzpK5IE4hJDJWp1wUHJSJwnzb7ygBeSEQxbmMLeBiRf+pyXOmpzybrJcesNdJBXMQoR8kFobVzjZ3Z5AR1IBxGN5/Z1TULjkowDrVPpaCvMDJjsuexjLLnJKgWb2A939jPvqKw2Jt3mBgIHbEBIcjneAngngW6cPnROH7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8Nvn0ddLbQOOP4jsW+HlVq3QzerNa+RKyjHHqZI7io=;
 b=F3ijiATifVsWSz0qU1KVj9xmNB9eTPcKBIIkg5wWxWKQuedwpLcyr7dhum52u982pnoWRckEQXX4v6GLKALN3SjuTel7Etd1mrNwUrU7hkrhnpksDPs9ZHP4GTZCP7Z/+WnxXpeqU2uHhzs/OSJfmtZ0AHxGG5xPG/vG07QeOsU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB3356.namprd10.prod.outlook.com
 (2603:10b6:5:1a9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Mon, 28 Mar
 2022 14:20:07 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d4e7:ee60:f060:e20c]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d4e7:ee60:f060:e20c%7]) with mapi id 15.20.5081.025; Mon, 28 Mar 2022
 14:20:07 +0000
Date:   Mon, 28 Mar 2022 17:19:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     vaibhav.sr@gmail.com, mgreer@animalcreek.com, johan@kernel.org,
        elder@kernel.org, gregkh@linuxfoundation.org,
        greybus-dev@lists.linaro.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] greybus: audio_codec: fix three missing initializers for
 data
Message-ID: <20220328141944.GT3293@kadam>
References: <20220327060120.4316-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327060120.4316-1-xiam0nd.tong@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0008.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::20)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa59d02b-d04d-4f4d-5848-08da10c60f19
X-MS-TrafficTypeDiagnostic: DM6PR10MB3356:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3356E0094E938BA0CB6386FE8E1D9@DM6PR10MB3356.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QcHaukMkGkuF9M054fIgvZQO01JSgHX7xqTfQa6vYBiRqeeBX2jxpXo+k8Tbtd3secRrwmNl1yX6CD3jdK8G/jdy6jgaCElVgVXRxGnbn5kbu8/U9mxshnWUZ9+CAd/bfPCvKXfH1j2CvP93oIil3qPoATz3T/rVketnrMhU7Hjptviv9XRriEvks5ZncSodH8F+qmm+IS6XyYiIPwR/PA0f/4Ka1HuAJoTtEfom02LeqXKo5E7vFcpFi4wwBb4qsjqBEqy3L6tRh1eD+9G2IvGHknJHdIHhvz/EWnFB3sc25gX9MD7r6+TmcxVtHeEz1/xmTVp/dnhiZ87JzEOz608nSt3vOUZAUqQtkhlf1iZpxa/hGCHhohG4evGJdMe9dHOjHhSoEdeGRSapPqd/RH5mdAB5+JCnhGquCSUVocYYibRoS/Vb8fW791m/wEQ20WkuvIIZPyiH32bsBmx8Wwb1yp+bLc8ywx8dQ32Mpv1Bq/EZjRx678FjCVUOEnefz145CEj5Kb3t30Sj/Rl6vvlW9jMIM8FdSrUj2Kr+10M2HQxbELkuB95Ue+AYIxAkkqT0/11r41rhovccM5253P0qWzeZrXfbemqppWe2Km9CRg5RTmcPcjAcPPcfVGt87+vfoppZomQlQz6tIxW0b+sFPT1L3BDLkPZsGwePkOermz86Ix5glMQ/3zneoi9aq80yhJQuveUZvqySP6fm5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6506007)(8676002)(52116002)(508600001)(66946007)(9686003)(33716001)(7416002)(6666004)(2906002)(6486002)(8936002)(86362001)(66556008)(6916009)(316002)(4326008)(6512007)(66476007)(26005)(44832011)(38350700002)(33656002)(5660300002)(83380400001)(1076003)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o+jL+ATETEmUv+zyjgZmUBzihSetiRQFDWbMhAuGsqr4ovxSkSe6OhvBL4js?=
 =?us-ascii?Q?dG1vb4VcAE+xfDdtrw/YU1cksJLsMM5ns6Bm5WwTZE0EG/31XC66g+iQsCkb?=
 =?us-ascii?Q?vYocLlr79n/Xe+UI+hM0Z3veNfY9nXUc+3EzBWEPlZHBE8jkZVZFu/TAAFYy?=
 =?us-ascii?Q?fQSQqlijPUHacXnm9sVdZKrJjaeifGgnFwpOiksraI83RAJBHs4p1ugZwFfo?=
 =?us-ascii?Q?Aj1P9b0ISnriILLUn08FbIxlMNOm13IONBZ2t0/89Ie7LjtydPKA62pdPkZ6?=
 =?us-ascii?Q?3mt4/BIJd84JiDnR8wiVe1NYdbLN/iGxsp+nwgAO5Bvjf+NiJNHRKpAALnNu?=
 =?us-ascii?Q?5XP4SvsasvhujkBUsOdt1fKkSONG8Nsh6pbcIAmTo00UVMu7sKilnZqTE0E1?=
 =?us-ascii?Q?QmoddaiXIyhCQRIsF7My2ZEUi016R/m9JWjtOBGbRqDKLG/LIzggbIEqGNKQ?=
 =?us-ascii?Q?/vO+wHKmiGNkXiIHjWZBSa+c7Ttai0KMKgRXNjsztZ07Rbfhr0BPSI8Dw4B7?=
 =?us-ascii?Q?+8REme3wuSn+9entbhHmq9o7+h6XhsaYsJUfoyNfLzpX6w3hGnbI7z9VQgFp?=
 =?us-ascii?Q?29K8OPdak2SanwDDo2900ziJ6A/WESa0O02Sc5oJ9lKp1bIOPoaOVl3WpLL5?=
 =?us-ascii?Q?CwWZn51Re+E18/++amdKs7QMQCFnyak0FcqZ5Xu/ty97xXnaUf65+kT/sCIq?=
 =?us-ascii?Q?Xyhv5+3aDODfkboRiph5O6EW2EAAJNEhieUwXCeF2yedGSHCXWPN9gxYfX3w?=
 =?us-ascii?Q?5NwDw/iYPOn6x4Cb2mFkuQVTT9FykhUf5HUhdgjVr+h8BvdwKkJycDiAscVD?=
 =?us-ascii?Q?fV4OSM3O8jqxoW/7Gjrj4MhgzKAv6c6za5VM+put7IQzUdw8uUIlncxvyexh?=
 =?us-ascii?Q?uB90ZWZC4JP/8a+tqYQwY+vWYprxiWbfQ9WhKiE+HU/kKWtI9dEIukSSSVtJ?=
 =?us-ascii?Q?maYoMTowiMiFRLxYi/00IfK4DU0trPfVZe6XAWn8Ftde9ap6iG4BAq5b4sup?=
 =?us-ascii?Q?wI7FUN5n54WWGpefH3m4GHemi18gGjPlVcE+tBSj/lCupjDUasLpVYRhxOhj?=
 =?us-ascii?Q?gfiKCrQx0YmtInKiMIAU4vfCuMRnjZH1nUnngf+5+l8S3NHF6XXMBLHglGA4?=
 =?us-ascii?Q?7MoYHMZIrBiCSbR4LHaH8VWiEji8BBC/akxbyQOYnizW3nCrXIU8L1fnzOQX?=
 =?us-ascii?Q?wz5f5GGO++hlIvMGLgUDHav0kg5pvAypD42ckGkUzYRosYgf/4RcUc8Hcfbn?=
 =?us-ascii?Q?ABkZQCOTWbh2EvpRkoietONdSUTYffs16s8dFVjxE37axwZFMbiieMs6BFBs?=
 =?us-ascii?Q?XNDbeemLWMLyqISFi/MsKdsEcDrQBqDvMjsjYM4SkFGLpFr2R0EOA/XGLINT?=
 =?us-ascii?Q?x9ig+4rZhiVtN15oEmpQuIiQZ/IdEyX7BmKDuLWNWXXy+pnnnm13XvDKoo9n?=
 =?us-ascii?Q?b00saWS7fIZqDPOsSjcKTEla17dbURJcx2vdOu9KCxbn+6MEGouflHKC+wKC?=
 =?us-ascii?Q?ZjWaxEigwkFs8sj0kD0eoxd/fUzVvmk5LFnv7zN+/tHiI/lR73fjuN1foFTF?=
 =?us-ascii?Q?roAkgfkHVc7281mIxG/TI8ipL/AW5m8JiCl0Ofx+HrnErOj6+Ao9ySdHm93c?=
 =?us-ascii?Q?sxeyAw/OwZIAH/ggT90IA4wl/MT+Syxfh6Zn9KpWFcGnloFd7rfKKwtrOpb3?=
 =?us-ascii?Q?6ViMjyKmt3n0EDq6UAyVamiwJfeOfJgDqJ6uFf/K6XwPKJuWr23uiYPpzEFe?=
 =?us-ascii?Q?yVQIE//DvX50/GF3AUU+GatN8ZHWm1o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa59d02b-d04d-4f4d-5848-08da10c60f19
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 14:20:07.1578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fTbhYxOmXEcgcDqg6u/H3L+sbrDCLeAqCeGWHwIwtwJddRG7HDJp/ODupb9vjHvv5Uw+2j0c7MQK6ivbKCdFRp4u0gSDXL/wQ1aGH6DmosA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3356
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10299 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=825 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203280083
X-Proofpoint-GUID: Ink2SV03XbyVRUfO8FimkmTytCMQl12A
X-Proofpoint-ORIG-GUID: Ink2SV03XbyVRUfO8FimkmTytCMQl12A
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 27, 2022 at 02:01:20PM +0800, Xiaomeng Tong wrote:
> These three bugs are here:
> 	struct gbaudio_data_connection *data;
> 
> If the list '&codec->module_list' is empty then the 'data' will
> keep unchanged.

All three of these functions check for if the codec->module_list is
empty at the start of the function so these are not real bugs.

Smatch is supposed to be able to figure this out, but apparently that
code is broken so Smatch still prints a warning.  :(

Apparently GCC does not print a warning for this.  Even when I delete
the check for list_empty() then GCC does not print a warning.  GCC often
assumes that we enter loops one time.  I haven't looked at that, but I
have noticed it in reviewing Smatch vs GCC warnings.

Generally we do not apply static checker work arounds.

I do not have a problem with this particular work around, but it needs
an updated commit message which says it is just to silence static
checker warnings and not to fix bugs.  Remove the Fixes tag.  Don't CC
stable.

regards,
dan carpenter

