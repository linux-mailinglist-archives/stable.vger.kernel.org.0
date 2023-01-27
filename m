Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9268E67EFDE
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 21:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbjA0Uma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 15:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbjA0UmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 15:42:15 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FAD7E057;
        Fri, 27 Jan 2023 12:41:41 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RESdgh015334;
        Fri, 27 Jan 2023 20:40:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=liGK6Cfe7R3hLz9yjT29KaP2fem8h5ZkQP1LS4op+YU=;
 b=ErOQ9zRN8d7hfZZcExpxmb1WoISrg8+ubjegON400f4inBbJFdp9klpmOn8KnTo13D0i
 1A65MuHB3Y3+E1adpHvZeKXL9CYtPqZd52F4b7UpSSEooLjHJu4LmzS7e+6HruHCzajO
 +zTMjIn+TG+x4ing8YvT+kjCpuqv6XmxpJWo09iYJDdxcGWae4B7F+/p2736J64jXvN3
 8qXzVwnrnA2ySrrBXctZ2e7RPH8A40KOM2dCdfxDLQkCEajOt04tXyaGCNnezuaT+b25
 lXE7EA4ptGI4H9/k1amuHT6rnQeEaT0HW3QqxKba9xeOfEz6Ay9gw0iGpCcEdyGtDqwi 3A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybnr1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:40:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RKF0Z1023959;
        Fri, 27 Jan 2023 20:40:35 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86ga2t27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:40:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOcoxBSQc38kKpiUYE1we/MDFlg3oS7cJHm5s8qj4XLFc6HgfaRjr21z31bEDJLxLsnwFzptjzylvO0j23T1nR4hPUwoBr/kaT+46d3GJbLD/QBbVx5a8ljE0KUEj4Dgr9//6O714+/uTAwxX7eGJJUeS4STMhSkxqvazFNse3+vgGGluTCrxMobOZrcGxkm7ZRq4W7poYUDzM6fnrT6wJ0yriEoqeaFm7Llgf+7qRzjHxuxIcSwTQSqhvdfm3xvd0sFDNi5yUKSsr7KKtTTV7c5Qozl4Gl1LaiZNrJ4fDNBxSqZj+3gdwqTEIlofTbRc29uT+/2JPRydoJOMzKelw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=liGK6Cfe7R3hLz9yjT29KaP2fem8h5ZkQP1LS4op+YU=;
 b=aO45Mk67lnQPQytFNjXHgxI/UcUvPZRCz9b956d1uLL6PXVwX1/rYPNFFHd3LdabO0cVmT+9P1fZIF8kV+PV/SsaCo+vebkBNbo6blN43mD/F8PZD8sxocydH26NgygnWzGlQqgQFjmeWOqWN1+sTa+eBpwKT5ORwMi3fZDXBrNkc2uyGQ6mOaC2NtRiWiSX+mYQO2fGYHQu8sDC+J9kSPo2jyNi/LY9cojB+gvQZPuYpJYU28AOluhcn6MyGwHAuuXGi8R5qVuAeemrp06wr9vCGQ1Z/NMQeAb5+thsD6etFzCo044ixChKVaiWAeYJmyyXjbZvV75TFwfCinuu6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liGK6Cfe7R3hLz9yjT29KaP2fem8h5ZkQP1LS4op+YU=;
 b=kstOfY6dfHNEnu1+uEpscaKJu9OGzUT4zeBiGjjDz0QEc8A72CMz6uPfYf5djNMiRh3xTgVt/y0+3jNytyCY4Qra/qX/XSaLHesWBcx7ycbngN6Zzb+aOsBR5c4XykgInXhMXugT4ERPjI/wciJsWcgFOGbbOE4YXAm3xXG32aA=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH3PR10MB7459.namprd10.prod.outlook.com (2603:10b6:610:160::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.10; Fri, 27 Jan
 2023 20:40:33 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 20:40:33 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.15 fix build id for arm64 5/5] sh: define RUNTIME_DISCARD_EXIT
Date:   Fri, 27 Jan 2023 13:40:11 -0700
Message-Id: <4ce08524259cc3f1a0eff588aeb5ce6b7105630c.1674851705.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674851705.git.tom.saeger@oracle.com>
References: <cover.1674851705.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0133.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::18) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH3PR10MB7459:EE_
X-MS-Office365-Filtering-Correlation-Id: 8027853c-addd-4f7a-343b-08db00a6bc4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZATkecuSFfUYCSkI/Ocxt962awQBtv0bEHlfjztacLWa7RcovOo76fYgGOoWhyv7vwo24cZqrnh0gCGHngfa9AxkdTXAcRQGCumW0XupuD4nBl0GhuiNeGClUER30ymD8J22hfj4OUccbfM6/gzKux6JjnpFy8amu6OBmz+p6ikEGrAp+GewXqmFtytEDR677i+MU9b8NQFIv8axxL1L0TTLV6xYVgfWQLFNUDtatLjQ6OT03J8Df7vuPqpcrgmlBV1Xq9pIj0qwSZjNoPKNeThQMEXFnYjHw5CsnQxOw6Rh4BuWwp1YuBEskkMUMWYyX7/X4AsmgnhVNK6ZvTEWzker2ER6AL0jtIME9Qm3md0WQc4rlHoWWtC/qvQvrtHsiChCys0qDJbjLj3kQTOX9h29qDKSbiVfas5Bb2PvozaUvhYMfoUuW7IONqtb2aNuIaDEd1xjd3EGht3qQjgOQKWj1nocb5ipS5fmihgmQ7gI66nq1Ek7U7uiD3VF6JUbbWd52lkBHqdME01bkIwWjfBZt5Z84h5UyqKWpE8vNOe0J52GvQnW79VzfCy6EWbgO2LC4B3tqBOk0Wd+HbKbr1ZrCkVfip0kLg/PQR+t107CkzpS49LD+7zjQsJCnCI5/VsirDFKKCy/DGYq5F8w/ZNoOZkqmbAbSIhGVS0w32mbTD0XNQ31QIn6WqepeJZp5QG4OkPCBDYNZOK5rBnI4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199018)(36756003)(44832011)(2906002)(54906003)(6666004)(6486002)(478600001)(966005)(8936002)(6512007)(6506007)(316002)(2616005)(186003)(38100700002)(7416002)(5660300002)(86362001)(4326008)(66946007)(66476007)(8676002)(66556008)(6916009)(41300700001)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jP/gY6lFI7vn4Q90srVjlTE/9QzZ12urOvlXLfg8aqZQxj8d4OLqNTzGqNd5?=
 =?us-ascii?Q?Zy8iHypb2O+8lV+aL3xFkopiLGa9Ksw6Bpgbw22fuB7O4fas7gLRSiE7/pBw?=
 =?us-ascii?Q?+clYlZ4P/dx+bVPdHdDPsR0Ia0/ZqzNd9LHsG/DLlrOJq+EBena1KdVrLlYp?=
 =?us-ascii?Q?EdI5igLixyXXBdEzkJ8e7hSW+iUudXsuWIHvHYP49YtVUNWMQHq4jtWm7tCU?=
 =?us-ascii?Q?vKh33mgGW+EZWzu1AAxgWR5fG/IYnS8uqNVh1KObR1ttdySJ4RSogZXkdXPi?=
 =?us-ascii?Q?w2Y6wmjCjXShyVtL0RkNDv/WYfPyqH5X/RFBnkHz10GjkTwpxHz3nzZpMwgx?=
 =?us-ascii?Q?MixucM8dMjTEfknI1mjL9TnVehGMvU1kw1jiQHb/vURpM74U8WOzdyhXxXAp?=
 =?us-ascii?Q?O160TW9qmsXk1pAEuV9jDZx04L0K1hluMa17XG8Y2spvZkKKGxFU4an6QL/+?=
 =?us-ascii?Q?vsu15oP/7xmJrzU0lIl56PJqhMPHhCzfOMmtvUbO3yxSXKynbegO8cRWC4eS?=
 =?us-ascii?Q?1A1DwMPpy0VRFvLII83ViIarxFFExpV9nmpRRy7RthYK16XS1IWOITRuRmYo?=
 =?us-ascii?Q?74o2LaqeUeL5URX4Pc3dhrE9NB+nqJD9msS46/tnpTrvrRszZ2xSpiipXD0a?=
 =?us-ascii?Q?kMDCIwe8Siq8jqA7vNmXj3MW6+oWqQhdLx2ELWsqg1tzi02Z5Pg/Ha8jCft2?=
 =?us-ascii?Q?miXNbxC2idpp6yejCMGsHr7NQdDcm0Cfo8ut79qNywuQ7522HQ5ZZsJOjfsO?=
 =?us-ascii?Q?AESYuMnTYXL+vMzB2BAijUnzOHvKQcefqjz6QOB99hzUcLDqpaEAP+iWzlYO?=
 =?us-ascii?Q?0PX/1wNdtSUMio2jNlzltq8KcqvpTO8umCeZqPnYXhXEkMiUx7leI1rHldZz?=
 =?us-ascii?Q?2UyR0xruxniPPkvP5pQ7eGfKi7a8kOGQWmD4nUiYFSQkLMjFK4Bd4s0ok+mq?=
 =?us-ascii?Q?01lV3/WCaeKMUQfRYayJ6cPPo3WHR9jgGGTgJzxHVXKIyKSN+a215FOGf201?=
 =?us-ascii?Q?4ZwUR8wm1WpMcuzxYtmFxgo6y3JGFcu7HIpG4gcYJVPixqmQ3W08pnulWh3i?=
 =?us-ascii?Q?3p8tXQRCMnGtZASA9cjYn9RoU42sRnBAttP2/ON21Gl/yC00IQ9kX2x333ei?=
 =?us-ascii?Q?eDncSXaI9Dd8Oc9h8KDDp25+Qlji9UsfSqIt92ibm1cCPGCsJNT+Mlo7FMSc?=
 =?us-ascii?Q?Ejiiqs2CgUDxMvHrbH0RtxkBn6wv9fm1UrUafIu9ztVJYFC+It/zIMNbWxvD?=
 =?us-ascii?Q?FpiTDp0W2VPAStpXVNaAb3lALhmYHOyBI0DhGE8dccrjf3dKISSG7fuswTgp?=
 =?us-ascii?Q?LPyPPZN+MEMZMTl7Qb5aU906s0lxB6VLee4kyzYo9vrOuHiHI+1HgK93zHSD?=
 =?us-ascii?Q?jOXPVQaT26wi5RHMl+X9/ooEALtI1zmKztUQGHdLzmKz6ExcoD+2N0trcZ9q?=
 =?us-ascii?Q?0uB2QsmzMbiUQk2tn/ENzBc3lv0JgioAIgEe0mAeA853ubTx0Zen/hyY9okr?=
 =?us-ascii?Q?Z2bDNOR0ago3fTM+W5Kyy1nIsfe+y9t8zxi5rBm/VOx1aGpy39X+QRAqmDuf?=
 =?us-ascii?Q?J3Yn8aZqWGn7RHXBnu9/b0/QsxjJeEKGeoT6ECV7oJA1CBQkY2K512fQfTuI?=
 =?us-ascii?Q?y4FpBmWC3hTJhizhLg0e0Gc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?8dCGPcR6fE5Vr9fnkntK3PdEff5XVKF8BeHiSnNVaxVqSdvdDS9I/Y/wCY0N?=
 =?us-ascii?Q?Y1yptyUAjOfHZOaIzj2TYsuEr1HJG2IAyUuMULqB2qFgKYu+A+59mLYFgOmR?=
 =?us-ascii?Q?/Ks+j5hf3h4gYnkeZ/pP0Jkam43g48mXsMWsVzdxHil8BvSNp/ZUndN2Mkum?=
 =?us-ascii?Q?MzVV7J5V2IrYnAcl8LMRrU4oKiBXde9NBeOPl46NIdm+A2d/vni3yBg9+wZT?=
 =?us-ascii?Q?x9Eqxgo7FBO04oPrdAN+mhjiwWmuT8an1kNZ0FQ5bGkyynKTnnsyrrNE6xKE?=
 =?us-ascii?Q?b3r4K8OSm05tQ+3yiChVpo07Oz7jDQXvXmTjWT6Y2tzv4ZWPZnWdM9slvFWo?=
 =?us-ascii?Q?bjhWczwirLVplP/K6VKcx0ac4L4m7Emkwb4SZA++0fc55FvTKxN2Jh6zM2C0?=
 =?us-ascii?Q?FdddVHmJa7kEjNzssuy7b6Sqo725orbBZXb8dgVK/Vm3uhvdHkbXr6C2e7dx?=
 =?us-ascii?Q?/NGZz7sLBrJ0GIrx1IqZ6vHay1J6Z7TucULetUVP/c+OEUNvdvIfgeHCvBy+?=
 =?us-ascii?Q?biDF801ylIqSjqW0dIaLqiQgWagr4dt8ecDsGfb4amxXedaThEt4na22gBdN?=
 =?us-ascii?Q?unu3LBWF9Gsmq0AbxmCRkMmFDA1DPKkAHfZiRipuRhGN3sMbDGOm0wibbUuB?=
 =?us-ascii?Q?UPoGVBd0fu0+SzxIDohpLTohE8Q1SMVq3DkIi9XTvQd0lCjrHoXP8B0tBBEo?=
 =?us-ascii?Q?Qncy0QMjyJHZblm1JoQxxsblBfoUO5T2HZVvHMoyODqMOkb5gTGzWRNZ2qw0?=
 =?us-ascii?Q?qZfdozavg8m4KgJ4slMUJuhO97/uTjTjPhpxrLpoW8gbspwSP64Olk0SOu0I?=
 =?us-ascii?Q?Ro8lTWSGyxtuxkOD84g27mIbLflWeWgRevX/qbeIoV5dXq0rQtXALSIcnxBe?=
 =?us-ascii?Q?v7E5RA4hyOweldzUo4oQz+A6ew119m8E9rVFdeMWfuakzzxWhXz8DCdIlxUo?=
 =?us-ascii?Q?Eo+RuuGNMNmHEhAUg1++M1vSofl6SMeErXrllePG698+hr81HOApKuUmQkfd?=
 =?us-ascii?Q?l6p2tK/cIq22tipFw6KqZeO3tvc+slS7AdUPAygr+Dy1LTwcnhdn99k2A64M?=
 =?us-ascii?Q?jgengB9Lr8H9530296R+7qmod5uXcg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8027853c-addd-4f7a-343b-08db00a6bc4e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:40:32.8901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZnEfEfaUuc/qzzY4iZH/ENxuYvNuwX+17brD02SLJkseuntcxRorQWr2vhN5dXMbAxK41GEFDTk+orfCUbm6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7459
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301270190
X-Proofpoint-GUID: GE7wxkUCBFyTRi-k1DANxRl9w-uA6Mfl
X-Proofpoint-ORIG-GUID: GE7wxkUCBFyTRi-k1DANxRl9w-uA6Mfl
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

sh vmlinux fails to link with GNU ld < 2.40 (likely < 2.36) since
commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv").

This is similar to fixes for powerpc and s390:
commit 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT").
commit a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error
with GNU ld < 2.36").

  $ sh4-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2

  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu- microdev_defconfig
  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu-

  `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
  defined in discarded section `.exit.text' of crypto/algboss.o
  `.exit.text' referenced in section `__bug_table' of
  drivers/char/hw_random/core.o: defined in discarded section
  `.exit.text' of drivers/char/hw_random/core.o
  make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make[1]: *** [Makefile:1252: vmlinux] Error 2

arch/sh/kernel/vmlinux.lds.S keeps EXIT_TEXT:

	/*
	 * .exit.text is discarded at runtime, not link time, to deal with
	 * references from __bug_table
	 */
	.exit.text : AT(ADDR(.exit.text)) { EXIT_TEXT }

However, EXIT_TEXT is thrown away by
DISCARD(include/asm-generic/vmlinux.lds.h) because
sh does not define RUNTIME_DISCARD_EXIT.

GNU ld 2.40 does not have this issue and builds fine.
This corresponds with Masahiro's comments in a494398bde27:
"Nathan [Chancellor] also found that binutils
commit 21401fc7bf67 ("Duplicate output sections in scripts") cured this
issue, so we cannot reproduce it with binutils 2.36+, but it is better
to not rely on it."

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Link: https://lore.kernel.org/all/20230123194218.47ssfzhrpnv3xfez@oracle.com/
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/sh/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 3161b9ccd2a5..791c06b9a54a 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -4,6 +4,8 @@
  * Written by Niibe Yutaka and Paul Mundt
  */
 OUTPUT_ARCH(sh)
+#define RUNTIME_DISCARD_EXIT
+
 #include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/vmlinux.lds.h>
-- 
2.39.1

