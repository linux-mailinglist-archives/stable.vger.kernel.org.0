Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F79587471
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 01:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbiHAXd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 19:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiHAXd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 19:33:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF4119C36;
        Mon,  1 Aug 2022 16:33:26 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271MEMHQ003892;
        Mon, 1 Aug 2022 23:33:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=dlfhydAEJ6K1V5drjwdKYHCfISUhZgOyKWiSr0t8Bgg=;
 b=qwmtfdJZ8feRQCZw00H9hRoi8o+jyaSQ4larZnwYez/3n0shcQIe49lph6FqL3CFJs6e
 C7v/Fw2W3ehwsDRcHlRzVADl0fgkqc+OcORGjWj6eUyixggPAotzZSitBKnZ5/RHgQwI
 6UTRt1UfmJqVVy1awlu+oT8rHA0yFiwUdT2oOLIagkZfBwTxyglMgWav49T4npO7vlqD
 912krKjswOzqfWfTRO2ZbF85Y2ywnEFsiJGlZuiBYwOUEwUjYykfBBlz2CY6G/Vlb6T2
 0XXNt/KFMHXIz6zlhBbiUNsjrYlaJbBofnJqPef36GXDWQ1KHoqHWm2lK31lCmT0shCG iw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvh9n3cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 23:33:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271Mp5vs000979;
        Mon, 1 Aug 2022 23:33:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hp57qntfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 23:33:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRa3LSgpoUTSm9NViBNqsuq0x6bZThI8AAzhem96kUX1tVi8I/yDsgmkVSUqIFdfpwPFhEgutq2u18rPksm/Ux1JYs8NkskevJI9I69pEhlV9cJJ0WoDGW41uwsHV1txjVyIJVsMnAsqixe8O+KvWuahjEZIOzpKV0tpjjRSNuIE0RpsK+tcLnM1UjirhimrmVsXNkgmi3+6WloxwLM5eQhrt8ZLWMJzBanlZgrTVNLcDIeZpkbDDMl7MwLY2QeobRQSzhSkAz4bqQH9vIPuAp+5o5vfWQu7HStE30sRGbHSVw/rz/qHzwlBHMOR88Z68PA103O7DqFmESxKY99GdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlfhydAEJ6K1V5drjwdKYHCfISUhZgOyKWiSr0t8Bgg=;
 b=PUH+NgdrLYUKl2cX9UuYPx6+atFbB9ueQWSyr3TyAH64W4KbbivOPioLpDEAn4qDDJEfoijbyYOasRJ3yIyFN763XgJGXvjtQw2kDjMGf/YUKoZMW/OU+8O5Nt2DNZDtwaM+QEyU0OL/IETdawzbiDSx1NpaZgn+MkgYutWLb58rYqZPZmJXj/L/3+buS4HAJdNUQwjdAn7ia5aRgyNSqHRqBJfUItCteWhHV4G2ac8hcnPsTMsJ7g1iBNRd+CoQ9Sxm1yU56TeJbGkLKTjk1yvKzzuXQnWGEJDHbBL+U/4cd8WDCJfkn2q9wcBheZWkPh8br+hmUW1fqGSqeDlrPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlfhydAEJ6K1V5drjwdKYHCfISUhZgOyKWiSr0t8Bgg=;
 b=YtXUXIxYvIxh4j46TtzdGuRNWnWKvsxCWnXDIxjhVIsbrcDqGXB+ODpolS4lvYZh0WHU8eBM1QsqZ7BatZHlZHkTogeK4tqKodEMWfPPfi+ZCq2rpYedOSe2121tDgWKmQyDrR8ItT5hJ0WnX8jAQ/3wEQ9j84pOufGmlfCoZKI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BY5PR10MB4369.namprd10.prod.outlook.com (2603:10b6:a03:204::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Mon, 1 Aug
 2022 23:33:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 23:33:10 +0000
To:     <peter.wang@mediatek.com>
Cc:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v5] ufs: core: correct ufshcd_shutdown flow
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7x34k0o.fsf@ca-mkp.ca.oracle.com>
References: <20220727030526.31022-1-peter.wang@mediatek.com>
Date:   Mon, 01 Aug 2022 19:33:05 -0400
In-Reply-To: <20220727030526.31022-1-peter.wang@mediatek.com> (peter wang's
        message of "Wed, 27 Jul 2022 11:05:26 +0800")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ad0c0cd-ef82-4029-3839-08da74163237
X-MS-TrafficTypeDiagnostic: BY5PR10MB4369:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KHj5lsNwDCy0abJSbKJZvK0gKK/i+gXKiLeyqxXv63X3h7MFQQsgFo7XA2T/uU2hZVTlbRDgGyAPzc9hOsYGFsMz3bUpVnZaQUaB5pR6VO6sGQBMFmNdZHFG+4QSLz8xXC3IVeR3WDDDglhUmeEwpzOWscQRPx0MnjIOiXvotQAYoTQ/xe5DPuGp05pYZ8CFRHVC8SQJGoCoPiqS9h20U/Z2Sw/gWfTW7Nyh1LtLRIiED+pdhsmT5sH5nx5z9dmVst0av02LSOT1vDLSNG+KdoOpM3mwDTElmHUO7PA1UUO4Uree90rbWWzyVDkb97DlsJ9UftPKS/vR3dJogY4DQCfprlU6oLf9ZaHUr5H9aq4AwmxqyTPzUAfBcZ/G9nbafEMl+ezEMi3NqrNZK/OtRlbiErQ5IIs/ds2nLzg+GLqwzg13kRoq/Z9jqEBUR3Q+JNF3F4zTn+Uwh6GV1T35efeh0ayaFoHUgSZLP3ZQ2o6x0PjWqfbt3fySMZbicG+ODYdj7IctQ8z5qbnr43RsQvIiSnEHwl8Ck6XrVB94qeUXRN9pLdXAqzFFJzC/rz6SkTg2Cr7+QLEB3t1H1K7WFooKkSnCxHXHpex2WBCPlPL5glckbF6kdxKcerpfWYAiUG9Szwzyz8b5JFmmDCzewoPbeMr42E4pIHOQKyPxu2cxrwGMJSRSZVq89oCIaQHNC8NijiM1RxOAt4aPR1SCYDPBjEUz5T8hKC+6BFSFf5tfAwk8pvf4EEA9xinWwPNzo3rRPpCr2XGHu0T8p/7uwYcJ/pdyGlh4/IsSEaxnlI0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(136003)(366004)(346002)(39860400002)(41300700001)(38350700002)(8676002)(38100700002)(558084003)(478600001)(6486002)(4326008)(66946007)(316002)(6916009)(66476007)(66556008)(6666004)(36916002)(86362001)(26005)(52116002)(6512007)(54906003)(7416002)(6506007)(186003)(2906002)(5660300002)(83380400001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?69QVIvKF3XreLH4V7ebqAiF543KeYFWzbnD0nYO9G5R6eZoBQcw92mK9Dm8R?=
 =?us-ascii?Q?dMQJYpS7fY/wg1x8AqLZhpeGtUkVu4pp4BfTrFQzijBLIwdGy62Y/YYeXB+F?=
 =?us-ascii?Q?E8ZCKin6xTiTz5IJUvRkHe8dLgBJcM/OMf4eG0MpEnE2T+p7M6YGxecnj47e?=
 =?us-ascii?Q?xsiuY9XetwEFsiXZ4exikuZBdtYDI3iHAPrzAx4WjekItlXg0Yxx4cllZN0X?=
 =?us-ascii?Q?Qse0P/o6Zn1Faehseqgm5Xkb+uOY0tsYwyzb/FyMqVOtA4R52iIxQQQKqEDX?=
 =?us-ascii?Q?3p+QfMmji7DG/ITGIN7eWIbu7sIDWUkz4ZrC4eyXPuXsJZSaT1eLQEBNoLi/?=
 =?us-ascii?Q?WTgZEMMrQvE/FHB82GiYNIkZJENC3WGUPPskeDOPwCJVPk3/W6oznb+xGxWn?=
 =?us-ascii?Q?0eiB9EUoe2pZmG2y2yaW9Ei1Qh3GhR8G0yQQfNhlg7iulxyMlZxYuFgjEDz/?=
 =?us-ascii?Q?+TQnV5RUSWDC6pO2nxWrQmdxKgkodmablGr7jYC0WRbB9UJ+sHHzfkSm4SyW?=
 =?us-ascii?Q?ACDHsngouGgnfIyheXvCoKvGCmoGJK2kAdiXH4k3Ey1zzKgkQgGO9HZ1FI6v?=
 =?us-ascii?Q?eOHAekXINq+2/EIJZGqj62lspktz1zITpUpMh4Wb6T71+6epqfXHsg+YCNCk?=
 =?us-ascii?Q?3XYifPVnvbpA5wAxGuro4relnH3FDtQMcyU4PvGX3mgMlmvi4DXPfmC+ApWq?=
 =?us-ascii?Q?v4Q9aXQ3zN6vrhDc2RtaWpFZYg0dTnSpFu1cpm37GbiXPxIcoHgGdsfQtiCw?=
 =?us-ascii?Q?jCS7/W3ExeuD9cqZfMkPf6rtetoPjLFuO2pUEqjSfbm9XC+iSAAPcsi2AE04?=
 =?us-ascii?Q?7oTDlTXz7IwcG7xf7+wK7r2mGijGhXnS6Js4GymeehP2/YcFN+f3zEDLlwoZ?=
 =?us-ascii?Q?XBIKB2BALK5Yu2T4/NSkHDc3ZS6jzIOcYgZxlXvBG1YCpSX9r9AobvHV7cOU?=
 =?us-ascii?Q?L/sc+ifCIKCKEhxRHHneYQku2b+2uYF9zEYHu/7dOGU4DiWyv2OtVElXg9aJ?=
 =?us-ascii?Q?iTpDw78V50YXcrV4Bgm7p0hSQWlNc5cNXGfT9Vv8gHNSbg2dUBWvOAjCAmAr?=
 =?us-ascii?Q?TiWXD1t+0kd3fVdWK7PlqPKDgGGpnxNaAOJBIKK/BPwBQe9kVLpkN3yNZo1U?=
 =?us-ascii?Q?h/CDdtlUCSojJ6geTmjXtiXnvNqanLPVVHMFIWZChEBYg2iA9Km8lUQTOqBT?=
 =?us-ascii?Q?2jRZdeWqxDGGgCnfoYc7PjB6xDTZLUxqE2QwSSpLw7uBwvb64Ruhqa2U+T7E?=
 =?us-ascii?Q?f3REOldbwyROe3zIbp7f0LMwvEnFAvDiZxabGbjunkYU4b25C0qPF494kgFU?=
 =?us-ascii?Q?j0ZXs7IfTGyc8KucG2Zkey0hbCwr5s35+DPBdeydcqw4R1evprNcjGIyUojd?=
 =?us-ascii?Q?HkaOu5FITKzvK3fB4p/VjkM19Mag9ro2E8PbUmEDV8YHurEp4JSSU4p00Dy5?=
 =?us-ascii?Q?Qxjk8HgMCafmrtZ2WP8bEwwawVrx0psO0v3tpdcyna+p2RlYBBFjSmr8T6Ft?=
 =?us-ascii?Q?fSUD+Kpw+5HrgLjMRoRC9sokZpLlF+gZ4StoploLAMhY71H87G+64urazoz0?=
 =?us-ascii?Q?pBKk9aWAEt3VuUzFl7yZBkekREY+MqDlFLyVdFkk8GGtd3V6nGRhqoiUd1Sf?=
 =?us-ascii?Q?CQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad0c0cd-ef82-4029-3839-08da74163237
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 23:33:10.8334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8cXwzwZDpaUHmZadq13QLnYgyg5h8fHYjvUraV6pqTPMSqISgYOCBiSgnCfMQ0jmxFp7QEWH4fIHEqhLeGL9qKQryGS10fcL1g0R8EP4Vxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4369
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_11,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010117
X-Proofpoint-ORIG-GUID: DXCVGTKNjAT09KnVXYHhxH1Zpk4xXT5c
X-Proofpoint-GUID: DXCVGTKNjAT09KnVXYHhxH1Zpk4xXT5c
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> After ufshcd_wl_shutdown set device power off and link off,
> ufshcd_shutdown could turn off clock/power.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
