Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABD6626589
	for <lists+stable@lfdr.de>; Sat, 12 Nov 2022 00:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbiKKX3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 18:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbiKKX3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 18:29:09 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C863F83390;
        Fri, 11 Nov 2022 15:29:08 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABMsfch026818;
        Fri, 11 Nov 2022 23:26:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=yMaCSqYvWytoN8TaHtwTo11mGnaLkaG6R+PtD0saZ8w=;
 b=gRGtLKLOa52hi65esLrCv1kYmsI5eAWTNHSBuO/07aAqAUA676ErgTg14T7TqSEQWMSp
 X/MyOS/T4MGTGlwWOqWdF286ovDrcXy7hg1XkQ/qciz9BhiaP4FAX+wVRsd25zOcSOdV
 Rf9MCitMmE4aX1YzRzvLYanQc8MPcTtCfoco+lQ0bitqGB0ItyXQr2FZk43H/U7g+KIf
 IVtB1RB88qctHukpb9A7gjf6YW8FUzv6JIba6ggZKZgmc+FH54OSoY+7xwdqAfpYXfrB
 4bTftjhlvy0K41GwBVOSe0LzxZ83QhpIUNxQvWpw8QV42DhvsgQSXZBlBE/NzhGfP0pm lA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksyktg16u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 23:26:51 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABKH5c6031687;
        Fri, 11 Nov 2022 23:26:51 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctrccd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 23:26:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7U2n5YyvsvGDQJJmtiOgm3Ynv4mW1nDwbSggAssCIu2XcC65aEfni8hXleCFRazTJaro6cmWQ+vHKl+7VUaZsFdMpF4msVLEvyD0iK8GztwyXlgRHvX/kDnI7YMwESSoQCxVpg9nqBAonQaxmT/bII5+SW63NB9AbEmsKZoj6LnSPWn7wmK5omO6n/4YnBi8BvungTecqbJQLQ0C5bXJZOe7grI2tYXAwWBbca/EIv2cxSU0WqUvzu2EHri4kfQGxsKzdZuKVPvtDFWEKlQTWRoebE36CfR4wcEQ42Su7WfQMrbWfSdmoLWvf7lYxrmr9yzT90boAKyYfZ00172Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMaCSqYvWytoN8TaHtwTo11mGnaLkaG6R+PtD0saZ8w=;
 b=KkUJm8l6+jlB33H2ZKwYKcTCyQhE5UPXtNUCLhkUgmTl1kwUoAgIr2g/Kgq2LJRANeWTRXokpjRO+gTTtkISiPbIMH6RkWr1QDAV7qYdHc4Pe0NtnlwXq2qi3QAwR//QFtPAYapkiLgLrOHwxojspBfQ8ElRx75lwh4/SH/g//8k30MhshqKVwiwH459bEcXaIDaZxyG02lD27h/Bgmk7TTbk5SCWYjyDynifyD/ONh7W9UbmlPaMGxJRElpISxmNmaoYQcmjLlTy3dOcFotzATtBihGmFvrlpVyWuH3mG2rvfjnn5B+IldE3jSvh4RVDLoW79H6hz23MS2WuC/JCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMaCSqYvWytoN8TaHtwTo11mGnaLkaG6R+PtD0saZ8w=;
 b=MGRY7E3MIjiJkTM3W0UI9sdO+GgmjwpabCzLF2glBu8odjs+iCUyQlgmnFkozkTXFrJxKZvQhU1DCXg1Jq3+qk/xCnlW2YFhEUBAQaY0qvO1iASu5Uey2Nnxf91bsJQ5X+t6JhJ/WKLzDGPf30ViQ5wLHG0reVQfwEHP2dUXNcs=
Received: from DM6PR10MB4201.namprd10.prod.outlook.com (2603:10b6:5:216::10)
 by DM6PR10MB4139.namprd10.prod.outlook.com (2603:10b6:5:21d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Fri, 11 Nov
 2022 23:26:49 +0000
Received: from DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::4786:1191:c631:99da]) by DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::4786:1191:c631:99da%4]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 23:26:49 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v9 2/3] hugetlb: remove duplicate mmu notifications
Date:   Fri, 11 Nov 2022 15:26:27 -0800
Message-Id: <20221111232628.290160-3-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221111232628.290160-1-mike.kravetz@oracle.com>
References: <20221111232628.290160-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0045.namprd16.prod.outlook.com
 (2603:10b6:907:1::22) To DM6PR10MB4201.namprd10.prod.outlook.com
 (2603:10b6:5:216::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4201:EE_|DM6PR10MB4139:EE_
X-MS-Office365-Filtering-Correlation-Id: 0790d17b-91be-4e6a-4b84-08dac43c34cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EjringiJj0J5oVjntOnCNYKWSOfQWnw3e3FOE5p8vVHR8JtectRbW2j6ulUdqFyHNrYvJK2Ar7ojV1/7GyxbtaVoP7A/cnlTr15xZ8ZB7uEOXvFLgySXNhYsYvtIirQCZ7N3LuOmceZeqMoc9rSv8em+c89PS0o2+uq3rRq21bkc2fchaQCrLJaxfDgp97I3mn7Woks3x6epxtg7sxjhh6lYgpaHu2U9J/L721usrgvQVcbgR94Q1Sg5t+HpsRL4aBFUFUvfMz1luk3bPStU4ChHX8XgTGu2L6xZkq4HFjR+liBuiwAASXB/areGXFNAAC3aFr1Gdn/e/0wxBlHbaZwJkoYUbbJxdXg5/Qz950VlwcOh3S8/oGkkYLTJFRC3gcEWxWJE+iZ0zFpguzu7TYjAeL4x5h03+X62ZDWO0PwKfERwbOSXO0WnAIOfqarlZbMBQGkJrrJBh5fSCx7vQ6oftbOUwa7jybuOwh0UWejqyR19I5pg4YzL2FdRPC3QTuRdyc95aqjOLUq4Smib1/Ithm6q4EzxWqbh4NyKdyfEA6sSIs9jwb98PEV1XvtEmLy9uN1HnhU4bPtrWZtUkDzcP81y7jaXOh+YP/n9FZTwvhmBFPQ9Geo9t/lkdPrCej4OYdMeRdd4wR5n7i0O1tAeksLvUbA/Qp7uj1m8DutXcTd6mq5FgvBp3Fe4H6fsHZ8Lapm7QxCsKjOBQykqMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4201.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(39860400002)(396003)(366004)(451199015)(66946007)(8676002)(66476007)(66556008)(316002)(44832011)(4326008)(38100700002)(83380400001)(15650500001)(2906002)(41300700001)(86362001)(26005)(6512007)(5660300002)(186003)(7416002)(1076003)(2616005)(8936002)(36756003)(6506007)(6486002)(478600001)(54906003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dbay4Bhlx6Dtl1C646H2kLvtlxjay8i3Yv2zrLoWv/mfyVaWYM7731JMTwSh?=
 =?us-ascii?Q?TxVVmIbfwhymKj8jmPRJ1SHu9RjgNqWLzKKdlu0CWwTtmrMZyBZ7DUIwkVZG?=
 =?us-ascii?Q?ZtGH7VFONrTlgydDndJjL4GuHgjnrydr6yh4pE32930R/dSFmIMpcjNZ7J+Q?=
 =?us-ascii?Q?Sw/9Gp1tyXmSY5MnfIYtdZ+4CFj753jHshIqDM4ZqPtggsWnjWy+RjJMl9uC?=
 =?us-ascii?Q?+k1c35vcnelmu5emEBSVhtRKkOl6U2cXKceRjtCKdaOTU26MGMRAK/veiEeF?=
 =?us-ascii?Q?bdNvdaHYQ2be/poSKNLptGfX5sgsJyx1WnQHp4q8CHU0UDrmaOlAUXcsoEDw?=
 =?us-ascii?Q?ynJIaaCUh5QgG3gdlew3kp2vdtJVrf9EKvPi4y9uRApDxiIDpYvvEvUd2L9j?=
 =?us-ascii?Q?gkVc+7sXrv308EHi7EUqQ2p395S+ZEtHQO8S7ivieufbp+lcwjKFfT1GrK1T?=
 =?us-ascii?Q?RJ1v5twkVKlPOGGZG2nbV2amym+DrBz12zTRmGkiYWuSE6pdsSgFgpYD3F6K?=
 =?us-ascii?Q?AkP7ZeUIIssZBHwnpOhsQ0hbCGYBrit5NEkrZIvRDIpLgHg5jNsCpUqHAJ5k?=
 =?us-ascii?Q?ErvhuFuYFaHkczI5rXRjurornt4r+AEOOngjg5Bx8PwtTWkL/N1zkUwxIlz4?=
 =?us-ascii?Q?EAgHafmrcvw9/WAVjlAUPq0bgsvdYoP/DuAl2qCkSywbc/2FtPoJdvn+2ACg?=
 =?us-ascii?Q?TBNn6OFNqqXi3iVLN6VBuxr6EdpP92d7NY3fmSlef0cR5ehFW7o6VxPc4tCg?=
 =?us-ascii?Q?WNxX9D2VIKNmZaJY+ZJCnQWv0V5UrJj1BROuEK2GD0XZOCzonW5e1xtd6zVG?=
 =?us-ascii?Q?Nt0lnV3YdrQ7tRhlixdbNU1N8AEhWBAsSk66e1BvneWkuuX6YqQ8gHyHmyjp?=
 =?us-ascii?Q?Jw+iuSZTUFcKCV0WYuKWwW8Hz6T+GWrqgNwGJOJNc70g9LcTMsOrKgegblkb?=
 =?us-ascii?Q?RF4AmOMS19HQniO6WCCeO00tKF/9cPMSC5hBkvdNU5dLaO8jh7ai86FuhpXv?=
 =?us-ascii?Q?B9ZoqMuB1+V3dyqKDA3bOSzGRNDHE5Mz6sIuKuXmR9lQz8RBtxlFblIbUEmO?=
 =?us-ascii?Q?4DaArqdzzBiiNlKbGj/T5riDvRlusdrsnnHuM2R5ZxTcuUlYHWyJQzmzRh2X?=
 =?us-ascii?Q?DXlDFT4tqxyz8DniYf/zXPurLpuX3FlrMS9+NCjQZ43aCWJbq+cbx6WsAbaK?=
 =?us-ascii?Q?JDYF2BqWRmvZu8ihTXlsk8Wj+vuXeciYVa6VUn9LYYlkQ5jQJ4hbZG19LHML?=
 =?us-ascii?Q?q4sLNqeqXXTAmCz7+o0TYs5lMjhd1H/YOi0C+evx2W5E1rIFMrW27IlPvjei?=
 =?us-ascii?Q?Uv7+/WNnywnKNewLKM8ysrIrthR4Cp0fHOquFDjKv6ziFNEyu4y+i4GqbwB/?=
 =?us-ascii?Q?sGJmx/Z9Qr6GiakQjK+lcu2artCztgT0oRbNF7+KFQdfBZWOb0MuObAc1rI/?=
 =?us-ascii?Q?nqU5i6NhbYG3EFFA4AvC2Ndy/cALKGejsc2lAqJXB0dr5pBGngTmLeNnLjC5?=
 =?us-ascii?Q?QTR5II8Lca+z70UGI7Cb4sUeB0QhUfqsrYX95XtDo9rEimm5xQ+qTMAfvjZ/?=
 =?us-ascii?Q?mdWabVEGiLGm39x7VMe4fxNNe2Z6ZFld6QYA/abdFIlF5kKpeszIqD0wZIdS?=
 =?us-ascii?Q?xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?2jnLygPb1MKuSgxf3AUQsc4WTDTTpN1DKyX/J8rsBVZbV700idQDc1Y+NKAM?=
 =?us-ascii?Q?3S9tESOsydesEwBHMH5SDbirKzW1r758uSmd2ZvIK53OF02qs2HYN1oxn6xv?=
 =?us-ascii?Q?4gO7vF3BYaget6VVLsRNjDjJOVl/XCB3PM8z18LGvqt9y2IewvRnA9CzcLUE?=
 =?us-ascii?Q?m1Vb5l2GGpde/BNsMPiqx0iSWcketlkLaqQnfv6GDW+VsEAaJa+jUjlBba7b?=
 =?us-ascii?Q?hEUWW9sBOtEErwlfkEUYiuuefMV5T+EYo+9hCy7nYNW2KJIkf5MbgPpqlGlk?=
 =?us-ascii?Q?nWwD9LYBYB6QbWLd2sf43V1OaJy4wDgmJaz5ngHqvlNFoweWuLJ/XnZtA3u6?=
 =?us-ascii?Q?I3cDwPzish9RYo36Ny4q4PhRcGj4Xc8E6DJ9CHGXbgIZPfQl6IjPhCLTJExv?=
 =?us-ascii?Q?LdRtYtKBz0115c9M/nIVjiHgnAeGdYuHLzw//U8VDXYS0AnADlCQ9F6M/oA4?=
 =?us-ascii?Q?OxZd6LgSGCrmkr/Xb8NVK2KwCmOCxQym7WGbUgq0weRXaIkWCSNXfF/i6v9X?=
 =?us-ascii?Q?XIHMSqtPhZJs/o/mroIh5RpJx6BEraNk2irGJbz8on4l5NZ+I7nQBf3JA32F?=
 =?us-ascii?Q?0yhPQ6cVeBZtDBflrxhv2DyrrVsTjJEv1TYOVL5mOTPluhfnzwleC2G1heWL?=
 =?us-ascii?Q?Oo/6xAaf6NLISgnlwcU5E9QOigt3sCVyZSMZijTgODYR4BoKjQUA2LsciCFh?=
 =?us-ascii?Q?RivlSmZwrvmXm2T7Ds3TtiGch0zI4ByJ1cTdDxpEbcwf2JllzxSfyV7gMdya?=
 =?us-ascii?Q?SZLvi7eAjtR3JSKfPHig8rZzxf9/boeTwc+N7E1LNiv2PZj9cVo1/MbVSazC?=
 =?us-ascii?Q?TYzOsIllvB+XVKQCV4RwntYEoqrP4kqVBgrlOEfT2oMDkDrwuyEEbj9/cRze?=
 =?us-ascii?Q?0tyI4LS7V1K9FQdOvd3jvbXkkb6Bn9KgyLgoyV/SulXvUPbAWvIgXPJ9KPz9?=
 =?us-ascii?Q?FGLzTr88KH1VtlJRH1VG+yvGtrghwEv344mBfm1ce48/Vm7KHt3cwFRShSgQ?=
 =?us-ascii?Q?B1Xh+J1aHjxrd7GTFLpn2rV/bwXypr5lFdYhbeZP/6DvtOv8YPTkd0Mtyt6D?=
 =?us-ascii?Q?2wu24okwZbFmewWB8jodsjskDPvyslc+i+ju+WXwL81uaU4GyCS+DJuUKjpK?=
 =?us-ascii?Q?fagG9cVWjzu+sPvCrjoPNafDxc/i071GFo4QJahNf+iKiYVo5YJQmv4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0790d17b-91be-4e6a-4b84-08dac43c34cb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4201.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 23:26:49.0416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xTYDyrlOru6XS1HO1LVwku/irFYJLtib4a+owjDaDMTSfpWEltQIMzASSxwuppmwFvdVHe03YcZyJ+ywdq/1+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_11,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110159
X-Proofpoint-ORIG-GUID: jdR9Nyf0C7udlYk92x5vnY_g-DZSolVQ
X-Proofpoint-GUID: jdR9Nyf0C7udlYk92x5vnY_g-DZSolVQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The common hugetlb unmap routine __unmap_hugepage_range performs mmu
notification calls.  However, in the case where __unmap_hugepage_range
is called via __unmap_hugepage_range_final, mmu notification calls are
performed earlier in other calling routines.

Remove mmu notification calls from __unmap_hugepage_range.  Add
notification calls to the only other caller: unmap_hugepage_range.
unmap_hugepage_range is called for truncation and hole punch, so
change notification type from UNMAP to CLEAR as this is more appropriate.

Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: <stable@vger.kernel.org>
---
 mm/hugetlb.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9d765364231e..205c67c6787a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5074,7 +5074,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	struct mmu_notifier_range range;
 	unsigned long last_addr_mask;
 	bool force_flush = false;
 
@@ -5089,13 +5088,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 	tlb_change_page_size(tlb, sz);
 	tlb_start_vma(tlb, vma);
 
-	/*
-	 * If sharing possible, alert mmu notifiers of worst case.
-	 */
-	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, start,
-				end);
-	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
-	mmu_notifier_invalidate_range_start(&range);
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
@@ -5180,7 +5172,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 		if (ref_page)
 			break;
 	}
-	mmu_notifier_invalidate_range_end(&range);
 	tlb_end_vma(tlb, vma);
 
 	/*
@@ -5208,6 +5199,7 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 
+	/* mmu notification performed in caller */
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
 	/*
@@ -5227,10 +5219,18 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
 			  zap_flags_t zap_flags)
 {
+	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
 
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
+				start, end);
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	mmu_notifier_invalidate_range_start(&range);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
+
 	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags);
+
+	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 }
 
-- 
2.37.3

