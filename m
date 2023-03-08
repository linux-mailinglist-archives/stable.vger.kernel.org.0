Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351736B0E79
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCHQUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCHQUg (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Mar 2023 11:20:36 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2226B6911;
        Wed,  8 Mar 2023 08:20:33 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328ENndp001169;
        Wed, 8 Mar 2023 16:19:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=OJUrYSp8esHZ5oTiUuyKwdfNx0K/Jr4mWIZTpZb0tiA=;
 b=bEDhal87l2LCOvCg605z6fuqw5x5BdrmVWOpnBG0SYQp/JOsxrOvA147X57jK6DyOSHb
 DtJ6dZhxOyPHK3Gu5BSxWId2hJea272m5oPkV8vMvkGcHzqgephrB/HyI/B/FCFQlaH/
 mvWdKkCkQwxGJ9RTqhreYvbeVIDOVA2/aOYpqIQiWrB+uksWVRWUGznha36tpoSinj3m
 3lWQCcwOOLkfRjxhsAXQrwA6EZDf514Iic+Vm6S2dhD1GY71Fl91wc4bOMm7bI4siauN
 6VeD823Aw/znlB7WGDFAvWN4nT/IbgVnLiiUZ8c+OEdY4kt07LFN+blq774uLVFy8j2b WA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41810esx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 16:19:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328F2Zsd020781;
        Wed, 8 Mar 2023 16:19:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fu86rx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 16:19:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+Crriv09tfTdTaHnBmHe5QBN/G6AGgf4NCeQD1x/Vulb3C5G9lt76DKZXcMvauE+yrY8wQ0N8KM8y1EhUxsPPWdO1Dx/BlRamR26c5YhvXqlJNmxE9oexQiaRkC8UkbsFUklrejOXGWHI0IN5uaBCEYgyX5quEk6dlYjAiowjq6VRqCjQJz5LSCBJF5cfM46gvIR/JlyJZ9r8P7oFFs6dzX/EV6sa76GUXs2qR0bsPWmn1ukt/26tXjteZm2qMj8WSuq0+nrH2auUqcS2MV0nMpj0eNX2XmzVzRgS9BR3XE3nuiRr1RuaplMch7gbu1+dbKY1IvhKdEw6vlUA1dyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJUrYSp8esHZ5oTiUuyKwdfNx0K/Jr4mWIZTpZb0tiA=;
 b=JOwYQ3EWmlJvdJcrE0cwbItLPnxGCZgfjudFupjyH6d4JFLfon0an/snRoOdUXb5XBsic/xI++5Zs5zcM6VCLsUONklQNaH11EgzmBx/xo1W/0/Fc8IZdU7nb11ZbV3vda+UQkpVY3poL9YwiTjZI/1ZT58ZMQxNKGv+V59XsHnzpQcnoUSbn2oh2lBwd+tuuZE0wkvgZQJlzYb64JLtdYTcBwIYxT6GSKa/RM5Ukgo5eXq10GvRPNWhhyfvPnJ3ExrlIUUbsfKt/JotrJUT0Qu7D2KaouiMfyHrtfTrXzWqbVZWwWejshzX8mn56m1oXW70bA0pV3GxN1Y4zvmH6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJUrYSp8esHZ5oTiUuyKwdfNx0K/Jr4mWIZTpZb0tiA=;
 b=M2uVKMQE035MPghreFGs47JtrZ2yeJ5iGJtc/SkaXyQ7XFRGFn2RyBPSnfRMG/sgl15KWkWLgYsIPjstuKUjqfxAQctsp9r5BdlRd1IVvEuW8aUvXJPYC7cLN935B/hJKMgc8D7wF5RFmXotgjWb64aAR5wEUjqlkBbDOQ1j7Uo=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SA2PR10MB4555.namprd10.prod.outlook.com (2603:10b6:806:115::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 16:19:38 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319%7]) with mapi id 15.20.6156.028; Wed, 8 Mar 2023
 16:19:37 +0000
Date:   Wed, 8 Mar 2023 11:19:27 -0500
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com,
        Matthew Wilcox <willy@infradead.org>, heng.su@intel.com,
        lkp@intel.com, Stable@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm/ksm: Fix race with ksm_exit() in VMA iteration
Message-ID: <20230308161927.lb4npblk2q4vkxmg@revolver>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        David Hildenbrand <david@redhat.com>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com,
        Matthew Wilcox <willy@infradead.org>, heng.su@intel.com,
        lkp@intel.com, Stable@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
References: <20230307205951.2465275-1-Liam.Howlett@oracle.com>
 <d6670aa7-37ee-85aa-1053-96284a2f6720@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6670aa7-37ee-85aa-1053-96284a2f6720@redhat.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT3PR01CA0034.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::12) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SA2PR10MB4555:EE_
X-MS-Office365-Filtering-Correlation-Id: fb01bd8f-8759-4ecc-ee11-08db1ff0e93f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FxyW3hEfV4LopDBMsvWNfyziNDVrfsSxi6LVei79c3tzcWdP27C5J2FhoH0j6qCNt0ziFI0qWcPQYeLTq3tRUrcrzk4GLDEpg4LIgt2dxts/MOOYUFRwJZ+WfxTTy4OPWQLZNmlE2VIthm16KiZKiwDkC7MqzTzX/7aL7QjLiZfoxtde/7LmyUOm8k2W0a9P680/sBGkzT6VO+Pv7HdTqKdQ9k6Kdhx87+lUlna9q1SnUEOd0YdWKbfjFlZu6tfqqhMejJkhunANfwUcpQXIWN1WSEVzu9NHTVpcgarAjocGdGM/6Xqcd+2IN4eyTIFKpoIPGUt85vvYRg+TcbMRS9ON1gaKVjRofqw8T9Igj53v+aROGtq0IorEAIcZ/BVTCBxvlYlPy40UblXFUfvm7S+3BQCwCdclyMCD5RW9LGOicFfKAp0fDCCqdBnUrdjadiXls9Ql8RuazvzxYdvUaewa3UzOZwXILMGXh7Q4SAgI1Sm7Id8P0IvMZOtRrpaDiZ171rh8uou0mkTFL0xuLJYypmi2y00Np8gjjslzbRzkpWyRGOVdmN1irNVxo/Lgju3K26eUW+ViZWM5ugV3emmZ1cPV8XJHWxboZNFStV8f9rN0yXYfTvPrGLOb9vcmDAU0XHbjIT0XXhHkdxts+AdQfq0RLH5swKR4ZxrrJDLYF6z/mt32Xz33uCn/PwU6iOc5km2PbRDj/i0FvKPFuVHejAun/M/2JF+7hZ+iapQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199018)(83380400001)(478600001)(186003)(54906003)(38100700002)(66556008)(9686003)(66476007)(66946007)(4326008)(8676002)(6916009)(26005)(6512007)(2906002)(6506007)(1076003)(53546011)(6666004)(33716001)(5660300002)(7416002)(316002)(6486002)(966005)(41300700001)(8936002)(86362001)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N/4T87khbcsSGTTIrtbcvzOTZ8po6OVaJlCpQqEIo/HJknxRL3wdLXWrrO+Z?=
 =?us-ascii?Q?f1d5H3qNwlV1dC4nX+J3ud8UUl5DGhhcq5DKaXYmlYYgGsow0holsRbIr1Sh?=
 =?us-ascii?Q?ghpUKR17ePhsVPfjoxRSVWSzhlDXgJrJCIbU/F/LmwKgP7YhDNuVphMYEFhe?=
 =?us-ascii?Q?wG9rrAoW9QIcTC6mGoDjyYSSeGcJ5sSQRsfMfP50CKCelM6AKxqYA9XodAd0?=
 =?us-ascii?Q?d7nmOrqc5AJb1j99/Wgpq/GvFMf34jv7xQyY5IV3b7EZi9LR4ry6TtOHausF?=
 =?us-ascii?Q?reiVyergVOvqRQtc7QbyN/f8SZUWAjvEgeShBzMpgmF1FbpNQ6DVkhfpHuh6?=
 =?us-ascii?Q?PJzV/YfOQWYDWj5bfwRWwjCNJDDHwioyPl1wEARJ8bqqrTP1sHLgOlsVF9zH?=
 =?us-ascii?Q?XjOGCUNeHOFNqOxip1C0I/Kx/KV8LcAhDmhWdihANI4Tbyi4E0Me/Q6IOb8m?=
 =?us-ascii?Q?V4zJfyJrCcGJ3lPNgzFhdMpg4rcHVu+0ouBWSIg/TLD/iaN3y44gp2Epw5fE?=
 =?us-ascii?Q?fBBoBzwik74nifEKmJeq76viFQVuBVNCjPArmvDrE03zjey/C8hyigcBrNzo?=
 =?us-ascii?Q?4MFJqkStx0uh3pAFB/ZMSE63ADVL8hiE4Km75DoUthONsquTZICpw5Q500py?=
 =?us-ascii?Q?wFbq3O7ZRVYCtUsf8FcyiPVcduDAO5EXrNMUIVht89Kg2/4mzAitDlxDI3YT?=
 =?us-ascii?Q?NOLLxB95YJFtdvgs6olSNS6zAfPpKa643xFsTXQ9n8Oe+V71GjcrRZ4WFyvM?=
 =?us-ascii?Q?MlMRxIHeGg1pyHL7hQRJ6Ma+aPySOBM6/rwiNSpCjZQRbw4K/ZRJoJLtUh1b?=
 =?us-ascii?Q?YJt5xFyYWVidfKmvWpMAYYltACQqBfOhg4Y5PsvToPVz4h9AdyPlOWIR/MNw?=
 =?us-ascii?Q?J/ftJ+y+wh7l0M49URmDddOU2Td3AlPUeIJ/jS+hP9zNttbmwBUR/ASoTzBD?=
 =?us-ascii?Q?OKpvj3AVGg+utVPbOfKJfJ4pxcXiJJx1Ao7Dh7D4o/QSv8gOF03Y/o8cRE7q?=
 =?us-ascii?Q?iTmxPXJccMXjNWGR259svN23sDukGAixRrcXYupsNyUuXw81Wd5AVm+1FOdO?=
 =?us-ascii?Q?oWH8FL9Cv0JEeBzewY39Xt9Mbvthcw/vySEgkufu0U8a7cMm4Aws8Xr3PW6G?=
 =?us-ascii?Q?TPg0OMiGyPO4oGvrEuGehf057aTCwWwVkg5Zj3c46U1m1NRqyYdFuhsNd9+p?=
 =?us-ascii?Q?2hEmsd/vuzQXXhjks44KFe5uWHDdc9irtDEHSQS+92J9fdakYFZ53Atc+NIZ?=
 =?us-ascii?Q?q+s94jMrWj+gUOp5Lj8F3Ln3fh9PtqZTbIQPOi1MfUwODMxBn5epXr6S1baw?=
 =?us-ascii?Q?hHWfYgwkKACU7ojwPuIQNGA9krmpYwjq1z4NQnI7RFN1cOJDfsCakbOuVq2B?=
 =?us-ascii?Q?D7fiwsSuWdjWk7ppinz1q502Y3vx0nLyHDpghPah8yZWAgJpOPHfYgnBWcxs?=
 =?us-ascii?Q?ImqJU8c4RvgZkOAnbzUohnk2um6hm+PYPGkcUDT1HU4Aqz0C/HqLNf/wL4W5?=
 =?us-ascii?Q?4GSI+yvpvNa9t8IrIqFI3N6foCEqLzF5sE4bgzHGnU8SkXQMae6hcK3Bnn97?=
 =?us-ascii?Q?LfzpduTcpttMvTUpXTj0Qcar+fxWAMn/4wkUO1HrjP0Y1dQvTFGpYEByoqlw?=
 =?us-ascii?Q?fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?n67nCsdg27YiGowCyg5DzSGbtCfcYVG4FgflnRvcBZdppI+LnA+/yAjrQdPT?=
 =?us-ascii?Q?VoZJpuv1vOUpeMHzLZazWNGB6zWiXHddIL/08J7AXu5s9iLmp1l3J3FJ5n5y?=
 =?us-ascii?Q?OJ95SiDss/2mB/be4JME2X2N5hhpd4GBqedqqUBH6exRk3g5ayBZZAvPF4+h?=
 =?us-ascii?Q?Qn2+0qeLKoL5/0vTqOUNUox2YDYp9FyEu1K/S2nA9qXslA8t7cF0AL6NLxLD?=
 =?us-ascii?Q?GytnwBloN/9V43a4W4OEqAttb8ozwaveXDCsyUE958t/dxgtgtvo8mCdFS/D?=
 =?us-ascii?Q?jelvfJoo1RBAyzLeKd9Gkmq5CVTWmqdMMg/iolV53wlgHgVfo/U/+IsDCAFp?=
 =?us-ascii?Q?ExXI7E43SR2ABqhHUHTQ5q4OKYMDag28ML3NMGhkxsuaqCq3uIhEElZNmR/0?=
 =?us-ascii?Q?zkZd8R6LFBwkGunkNRA+6Z8w0hQd2ws7Er0MyyWYwJeP0cQtXpwzlm55VRPH?=
 =?us-ascii?Q?vtph3COcTqKOr5hR3zoM+WBOoNd5d8sAkmQGR1wcyr9UiPWq3CHxI4sz/AuJ?=
 =?us-ascii?Q?SS/kBpctNhrC8f6HpfxGyWbYH/gUaO29G5ZDeWFgARfB8q/HegpnbTfSwx6V?=
 =?us-ascii?Q?vVesRFqrNuPwb2l30QcnjbYqncG6C1vYcf0pEEm+lWaddup+EiZ4xBgQ9ewh?=
 =?us-ascii?Q?0jrwvg6hAxler7psJUU1q+EruwV9jAWLNFrp3W0V4JN/wpwIMROUMaoWsgs1?=
 =?us-ascii?Q?gUE1yizKe+i5Gc5z7P1FRa9tRe9nQ+XlF8nszvVk0EB1FrLeKI4EgKpBUG4X?=
 =?us-ascii?Q?j94BcY2Du4UTcUA4oCOvRaCeVhrquetkJkzd8KBjc68BASxw68mQPabwUQ8/?=
 =?us-ascii?Q?kpvsJnoBmVquKu+TktcQG/sWeYKMo5IdJpx1bQe9NNOXud7RsF0wZjjglP7+?=
 =?us-ascii?Q?JSy2e6xTbQHIOwB69Q8lRle5R40dCPh2jTlmjK2hXo4oVDpYGeC4GtB6FYeS?=
 =?us-ascii?Q?8g91w+aMNC7L/UtT0K8QlTIqldWb3aqOBj8DfK+8ALqVSQK221fT764IT9WB?=
 =?us-ascii?Q?rrDUK6j3DU2aM/v58SkdphDjtKb7kwf3XE8qxDmhUMp02FRZKWIgpykXZhIB?=
 =?us-ascii?Q?iESt6yspHos62F8dkw3cYXRDeih02Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb01bd8f-8759-4ecc-ee11-08db1ff0e93f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 16:19:37.2387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBvQk8GXQG+DRMFaHsA1vUP/du8rbiekdmogOMQnWndlHUq3+nlL127EHaUasvqzkf4nt2wUZ4Wah93wg1VWHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_10,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080139
X-Proofpoint-ORIG-GUID: h1t3D3-4-a09GsJoObDYY0dQV9T7HDgq
X-Proofpoint-GUID: h1t3D3-4-a09GsJoObDYY0dQV9T7HDgq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* David Hildenbrand <david@redhat.com> [230308 04:41]:
> On 07.03.23 21:59, Liam R. Howlett wrote:
> > ksm_exit() may remove the mm from the ksm_scan between the unlocking of
> > the ksm_mmlist and the start of the VMA iteration.  This results in the
> > mmap_read_lock() not being taken and a report from lockdep that the mm
> > isn't locked in the maple tree code.
> 
> I'm confused.

Thanks for looking at this.  My explanation is incorrect.

>The code does
> 
> mmap_read_lock(mm);
> ...
> for_each_vma(vmi, vma) {
> mmap_read_unlock(mm);
> 
> How can we not take the mmap_read_lock() ? Or am I staring at the wrong
> mmap_read_lock() ?

That's the right one.  The mmap lock is taken, but the one we are
checking is not the correct one.  Let me try again.

Checking the mm struct against the one in the vmi confirms they are the
same, so lockdep is telling us the lock we took doesn't match what it
expected.  I verified that the lock is the same before the
'for_each_vma()' call by inserting a BUG_ON() which is never triggered
with the reproducer.

ksm_test_exit() uses the mm->mm_users atomic to detect an mm exit.  This
is usually done in mmget(), mmput(), and friends.

__ksm_exit() and unmerge_and_remove_all_rmap_items() handle freeing by
use of the mm->mm_count atomic. This is usually via mmgrab() and mmdrop().

mmput() will call __mmput() if mm_users is decremented to zero.
__mmput() calls mmdrop() after the ksm_exit() and then continue with
teardown.

So, I believe what is happening is that the external lock flag is being
cleared from the maple tree (the one lockdep checks) before we call the
iterator.

task 1					task 2
unmerge_and_remove_all_rmap_items()
 spin_lock(&ksm_mmlist_lock);
 ksm_scan.mm_slot is set
 spin_unlock(&ksm_mmlist_lock);

=======================================================================
	At this point mm->mm_users is 0, but mm_count is not as it will
	be decremented at the end of __mmput().
=======================================================================

					__mmput()
 					 ksm_exit()
					  __ksm_exit()
					   spin_lock(&ksm_mmlist_lock); 
					   mm_slot is set
					   spin_unlock(&ksm_mmlist_lock)
					   mm_slot == ksm_scan.mm_slot
					   mmap_write_lock();
					   mmap_write_unlock();
					   return
					 exit_mmap()
					   ...
					   mmap_write_lock();
					   __mt_destory()
					     Free all maple tree nodes
					     mt->flags = 0;
					   mmap_write_unlock();
					   ...

 mmap_read_lock()
 for_each_vma()
   lockdep checks *internal* spinlock


This was fine before the change as the previous for loop would not have
checked the locking and would have hit the ksm_test_exit() test before
any problem arose.

Now we are getting a lockdep warning because the maple tree flag for the
external lock is cleared.

How about this as the start to the commit message:

The VMA iterator may trigger a lockdep warning if the mm is in the
process of being cleaned up before obtaining the mmap_read_lock().

> 
> > 
> > Fix the race by checking if this mm has been removed before iterating
> > the VMAs. __ksm_exit() uses the mmap lock to synchronize the freeing of
> > an mm, so it is safe to keep iterating over the VMAs when it is going to
> > be freed.
> > 
> > This change will slow down the mm exit during the race condition, but
> > will speed up the non-race scenarios iteration over the VMA list, which
> > should be much more common.
> 
> Would leaving the existing check in help to just stop scanning faster in
> that case?

Yes.  But why?  We would stop the scanning faster in the race condition
case, but slow the normal case down.

This check was here to ensure that the mm isn't being torn down while
it's iterating over the loop.  Hugh (Cc'ed) added this in 2009, but the
fundamental problem he specifies in his commit message in 9ba692948008
("ksm: fix oom deadlock") is that exit_mmap() does not take the
mmap_lock() - which is no longer the case.  We are safe to iterate the
VMAs with the mmap_read_lock() as the mmap_write_lock() is taken during
tear down of the VMA tree today.

> 
> > 
> > Reported-by: Pengfei Xu <pengfei.xu@intel.com>
> > Link: https://lore.kernel.org/lkml/ZAdUUhSbaa6fHS36@xpf.sh.intel.com/
> > Reported-by: syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?id=64a3e95957cd3deab99df7cd7b5a9475af92c93e
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: heng.su@intel.com
> > Cc: lkp@intel.com
> > Cc: <Stable@vger.kernel.org>
> > Fixes: a5f18ba07276 ("mm/ksm: use vma iterators instead of vma linked list")
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > ---
> >   mm/ksm.c | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 525c3306e78b..723ddbe6ea97 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -1044,9 +1044,10 @@ static int unmerge_and_remove_all_rmap_items(void)
> >   		mm = mm_slot->slot.mm;
> >   		mmap_read_lock(mm);
> 
> Better add a comment:
> 
> /*
>  * Don't iterate any VMAs if we might be racing against ksm_exit(),
>  * just exit early.
>  */
> 
> > +		if (ksm_test_exit(mm))
> > +			goto mm_exiting;
> > +
> >   		for_each_vma(vmi, vma) {
> > -			if (ksm_test_exit(mm))
> > -				break;
> >   			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
> >   				continue;
> >   			err = unmerge_ksm_pages(vma,
> > @@ -1055,6 +1056,7 @@ static int unmerge_and_remove_all_rmap_items(void)
> >   				goto error;
> >   		}
> > +mm_exiting:
> >   		remove_trailing_rmap_items(&mm_slot->rmap_list);
> >   		mmap_read_unlock(mm);
> 
> 
> 
> -- 
> Thanks,
> 
> David / dhildenb
> 
