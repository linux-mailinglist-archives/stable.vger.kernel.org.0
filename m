Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAFE6B292B
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 16:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjCIPwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 10:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjCIPwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 10:52:09 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F562F5A92
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 07:52:08 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329FKGLZ016221;
        Thu, 9 Mar 2023 15:51:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=H/gePaQDHgx2URS0VEwLwhlVqcNMjfyyvjLddKnH/2o=;
 b=Y1MwiLpoqHtEfr6Om4JTVmq3+0nUIFD33vKaXMbuuIcMHID4/3E2AMA3z2NI1YkM5eSH
 BB0N+lcnMJfnlRw9hZC3Xh+FrGsKs3EO/Gd7vvaJTKqY0LdnQiXp3zb9fWf7AW0zSI35
 pBg+HY1Z5ophblQjh+YhsX9cfAp1ITP/tu78mSh/02vNf/SbRkl5auUOB1bEsJ3zhzHa
 uXfdMISHXsnVnkzZWTZKG1ifuBolqXj13OdHV9U28brW6BH7DuWPow47Xn9kVT/YGXa7
 4JjO7LeoK6NHDdtMQTGxO+AFgmunT8EjAs/Y1c+ei3/Lm2NMhe9lVBqIJmOoQAXJrltS cw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p417ck11u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 15:51:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329EeQmx026602;
        Thu, 9 Mar 2023 15:51:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g9vchgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 15:51:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NP+wBb9WA3hiCqXrpp/dDtEwhTFYIyk+12+crv5VfxFshlz1zSHckaITnJ+JVsCFWCHu40+rNvSxxn3tzYtp0SfIzdRQzrqylJsK4Xss3p+iqOqOCbW/YYI0qwhOsfy3vnLDjMg01vzTOIRg1eTjNBGSJMCqUIndEThIjNZL/5yQ7pJx6trD/8yiYFAhHwiBnEuziwJ7nm1F1wPGBe5pngY3NQxFQ8rUBykzQVar9HqWGSMvN6P0Ifx7n/en7lNfh9Texux/34h25uobIFsGpVAHEK2kR2vrgqgLWULpO7boIIyCBeeTBMimMFXrrBkEHX4cFP5rtetM6RZSKX5bXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/gePaQDHgx2URS0VEwLwhlVqcNMjfyyvjLddKnH/2o=;
 b=Vo+A2XNoY3bewyHtiyXag2F9EVqVJ+MLjQbuzaRSVw1PZbDge5mbT9WplwWmRVl2hy9G2IkBVER6hUrjQ6fbNPcfvhEyyrvMqvkKhAEn4WMJhiI6afPWzzApRwv0I5s8YnavEXqa3H+GOiUQSTzfq20EAhlrlg7SF0HfUKa2yoCjM0ZjCimbEm8/PHV+sOuZHEnkaRhXQNDeaVlDs4xrMRcqZGZk1kWJpJ6GSVKsx01lQExR7h/bNy2zorvTJ8r0BzdYB1jjywEexgVfQBw4m9twju/APsl8VwUd5hBSfZZNBhcYY8AJ5uEtd6OCrNIV4T6REWzaAMYq80K5XCKA3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/gePaQDHgx2URS0VEwLwhlVqcNMjfyyvjLddKnH/2o=;
 b=wMj5M+cYy+hjDf5WL2V9lsH9v7as6+omBJ+YhHcy2PdJZ0vumjcYULfsLnKdPMYFvt70a+u43gCA9pYjJNFIV5YVCicfgB9B0KQnLOHv0zvVeV3DELZQ3dO9zORTPcZOWmW+chZbZyMyLcqxSmgm2jh5f2yajafJIJxV3AxCf8k=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5820.namprd10.prod.outlook.com (2603:10b6:510:146::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 15:51:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 15:51:42 +0000
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Martin Wilck <mwilck@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Subject: Re: Please apply commit 06e472acf964 ("scsi: mpt3sas: Remove usage
 of dma_get_required_mask() API") to stable series
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pm9hgbzw.fsf@ca-mkp.ca.oracle.com>
References: <ZAMUx8rG8xukulTu@eldamar.lan>
        <yq1356hnzd2.fsf@ca-mkp.ca.oracle.com> <ZAi4k/09acWV0wRZ@eldamar.lan>
        <yq1wn3rgj7a.fsf@ca-mkp.ca.oracle.com> <ZAmqt45uu1YoEnaD@eldamar.lan>
Date:   Thu, 09 Mar 2023 10:51:35 -0500
In-Reply-To: <ZAmqt45uu1YoEnaD@eldamar.lan> (Salvatore Bonaccorso's message of
        "Thu, 9 Mar 2023 10:45:27 +0100")
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0178.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: 77534548-11fe-4012-0f89-08db20b62d7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0jkA1YGDvWIGT+ilnXl7LsHlHwIY0jdHLFPwV/pMhVmE4dC75ubkQBd8nMsQHMc/WZmMMgmroyw0+5yjiJCSbPgNBPoakDT+XKAcScK/4Uox0lw4ljPdGo31Mps8S+dqPfWCQ29wtS1n5OSr9zKvYwOmZbAZFQEJuI6/0fC80Cw+ayCLTJDBFZny3u/vq/82JIdY2EEh/IqF/FtoLsu8XNK/RkuMy1wage1/lSnBRur1IBvYeKxrVw7L82QjbsOuedTwdBnw3pu2mWeFAX8tnQRy1mwRShsYeyB5ojn61PhhMU7zOBJ584NxJJvvinPyHyHHlbE6PvXRcl7At7oheOA6l9WcYybzBKgeHxLLZvhNT95pCkFExKZWAVU6jGRAYWdbhtnOrhuFQNepbtjOoD1+sWKfY+h+wrrotOYK2LjzD1KGMp1AV8jhOBOYWL1PAHuIIGOcNaLUMeXg8tiKD+EiPTW4kND2ND5sftWWQhcR1nRMpOZ5ne27pv15wuS95i9sYLZ87a0u8TQi4bsBBkVODnfR4atOeq3DVk9HyXRebT3GuNSxwYIVxB1zE03cRusS+pZPyr0g9svBmNP2qW/FS1eKngTewuG7lI7q31m3OXpy3GOH9f6LnI5waf47QxoO+G+WVV0ak3SAPPwg6D+32UqruDBdBDhopOKRLPo0Xsx+XFFHVvq7OvPWnQhz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199018)(4744005)(5660300002)(83380400001)(186003)(36916002)(26005)(6666004)(6486002)(6506007)(6512007)(478600001)(6916009)(8676002)(4326008)(66476007)(66946007)(8936002)(41300700001)(86362001)(54906003)(66556008)(316002)(38100700002)(2906002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8w9wfWY1bTgXNKGoMf+fTzf6/KPLxPc8Qg1CEmDeeS+aU3kfsRYhLIEWdm5U?=
 =?us-ascii?Q?v+fXmFMuITsEKhEoK9i6mz8NfwV4vEvTcxydvRl4SQ7n2J0ooYsCyqGPoiz4?=
 =?us-ascii?Q?wyar6NUmQQRk/O4Pa5e7utN8WZCg05ie4+YSjSWhpIPQInFggjgipxc2D6hs?=
 =?us-ascii?Q?k821QA4XoQftjG1cOCTKDLC36FpT1PaZT5Ci6NzQBFJwb07c7oGdsn7tYf2T?=
 =?us-ascii?Q?IMTRz0Dm6U9vxchaGlZlJiFsiequqn7GuFUJhA1ApsTFNz5VFVwjym/HHPKW?=
 =?us-ascii?Q?RoFE0lMcFOdjVFktG0t3XjfnBwQ5Ix5ypNdBjquo5Lcto2PoyleetQWXqhes?=
 =?us-ascii?Q?i1M0ppaf8cl5zc2rkuOd4iyyj93hLlw7CEMGeN36hDxCjhiNXmvLfoHaOv1Q?=
 =?us-ascii?Q?D51tb7wskPlqM+h2SIkDY3lb9yDbubru5EcHJVz9rto0gUrNqBprNGOTbSNy?=
 =?us-ascii?Q?657vrpKfiQK4cqWt3scVmTxQO3pHJ2oOIQ2upW7EBUjPGctJeQ5RuS49yPIU?=
 =?us-ascii?Q?143vOVbzWjdUI4xTfIM+4WMNJfg5L7b5D98FBAcSqm3e5MPFm7PGvqnxvr+s?=
 =?us-ascii?Q?0RiCgFQjHJ//AeLieO7T/nuMToNSmCgDXAAL90l7yBnmaEBcWJtL95juQUu5?=
 =?us-ascii?Q?XJq6uGOGHxi0Tj6AOYsG25St6rULZmSLMwjjBz6iCVHftv3mEUvrCqQDep+i?=
 =?us-ascii?Q?AgOWHky7E5M0IT3N+rjCKApqrrAOOyhLD7E2FZF3bX0bTcepAKmAnrJClbdN?=
 =?us-ascii?Q?CHGiH3I/EwrcNR+FSR7vnxp0hOoe8q6ew8H8jyRh2hk4XquCAWwr0P3DIqhO?=
 =?us-ascii?Q?9qxQJ3YPfZZsEUJpyxwmTY6amVA/rWL3kxpszVzfgZQGsPpU2/KY0LKeyTmZ?=
 =?us-ascii?Q?3YW9xjGO6R5dQgILhsPVDmOcSVQaojbBfndmNshkeCN4i8zx5ciclZAjRya8?=
 =?us-ascii?Q?hbIGmo8yl6witlNDKb+CIdCQzHcoa+xCHmqcPvrzTST82yXh1W6MVxEXJuMo?=
 =?us-ascii?Q?Z02B8cH+oYNuIMHEL00nWbKliSiMts7gGoqcnIIMT4PCcL454/+2dOTm3Io0?=
 =?us-ascii?Q?GqBUY4e0pm/m+Tvqp/kPdQUPcLxhKs1A4oS1M+phvjPkDJGmgA8MeJw1J0qm?=
 =?us-ascii?Q?9ChT0dgfa4T4rzR1seNFjo3QFzmdAaZFqN7+lK/oT6R0L0vHpyB1pyk637Ip?=
 =?us-ascii?Q?pmpvBSxkxbIUoCKIJlzZTX5WNEbInAJnP6+3Cmz/TGKovIUGHdWHbSJbZZsK?=
 =?us-ascii?Q?VeSDUe9X2kTlb44YV1socftpcOx6vhojlpxolmvnEWqYi/4E9XTNsbomzL+d?=
 =?us-ascii?Q?iPl2abqfJbG0TR+xOntA+4M9lLpf7KtVxVE5XzYK9Fru86xo1S2QNzp/h06x?=
 =?us-ascii?Q?DXZzIPJe34aiPc9WJFFjAhP+nGwUp0h7tIkS/Zu9Edzhga4ffo7q9rXlZ2T1?=
 =?us-ascii?Q?FMmYpMnUlUF6DNZH0QfH24js0KxBJNGuWnquPqNsIbGhDJr3BletfKAahgLw?=
 =?us-ascii?Q?BZQ/pYJPbzVi1jjtgarhUGBwLhd96o/8DWop2E+ycdbAQoQW11sdViVcnyoc?=
 =?us-ascii?Q?a72D+bMYkm3qOj2O4N9eZ/6q3xzQnqV9F3wSnQ2+rcKw5+aib+iqRzkJywjD?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ozezKcqN99Lk4ZiDFkzKmO6YkBl4GT3D5WEgPNqd8PG5vf3O/H8p9jbFBVUX?=
 =?us-ascii?Q?UuF1740GKYLorynJwO3rnTQohy6nSjJEoCTMUjEm/Le1AVCq4vv8eoAkwWpH?=
 =?us-ascii?Q?dGwtdB0I2/EXGwGyVZb54SzGv/wk5YdQGWcKOSaWbbyNiFKHNkOtx7d+CMsw?=
 =?us-ascii?Q?ba0TzOiMXOEZ9au9NOxhZY9zV5cXguihy2KTS34hMxQs39ORv9cL3kSUdBrt?=
 =?us-ascii?Q?X1at6kseWuWFiMBgN2Pd5TEPEInh/fF9Us1uSgknFnhJvMx2fbuz2s0qt56p?=
 =?us-ascii?Q?AKhdA76iXUMW7IA+V8m2WBrUIAvdhBkgSRgK2CI97Cb8KXQmVJg4wZJqkxSF?=
 =?us-ascii?Q?6EEPClbmxkHqIxykiOAAoDkby8TLUq2CREL143nMy4+2bKXsQfFJ2T+E5Pio?=
 =?us-ascii?Q?7Ubd3lQr0uun8oBG9SIvlj1vDRYM2oGpGkuPoj4DHVuig8KInem0Qq0e4KE6?=
 =?us-ascii?Q?GnUjxQmyvDv0nFXf1hNl+JSznEBQ7eERO9okx55Np0t8v0sIHeH7g06ohoU/?=
 =?us-ascii?Q?/mSCsaLn1u1KIdEgOAM5MVkkVXHowY/LZ6mHRKp7vLz/8vEHkxC8zDu98gzQ?=
 =?us-ascii?Q?OSmKzmlDvELeqzS+d4MAN8zv6ql06JxkDcFy5s26GfKVkdhF/jHoLPS4Srju?=
 =?us-ascii?Q?6E3rx2F9/12l+GgKb/QwF+pf51hQkold/2Cb1wSIevGrWqTrb769IDcq7nGI?=
 =?us-ascii?Q?+UaUYZpL34p8rDpGcsd/O1EwKyp3e7lJpVi628qjDV8ymf6Oxt0LUWoT3axz?=
 =?us-ascii?Q?7okfbnJM87TIZG7U6sxsWOfn1WdqO31/45wy0+N/k/wwEvPUVZkknE3kCLTC?=
 =?us-ascii?Q?MENvhe6UyvpNXRLS25iTKiQSa8i5ODoMVHjIGNszHqGjFMpuPcpkG1wIGeHS?=
 =?us-ascii?Q?/s4k4vFgzhE/XtBupN1X7d7woZR0fxIRSTgZdeLXWm2mBXXAiQV3c+TL6/4N?=
 =?us-ascii?Q?V1GjytUfpNTXql/oCIpjOZ0PApewYdlfZUskg+DfbEPhuBBzkm2njE37C+Ev?=
 =?us-ascii?Q?Esiv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77534548-11fe-4012-0f89-08db20b62d7a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 15:51:42.3730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l9Ni15ioHJlVpXfPuSvD9P/S474ePlI1wpBo/larq8YgND2IY8VXLJUYQcLA0HAqotMd4lrF7cx5iJsQWItaVGGHwsnOyTJivSKAamoHG20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5820
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_08,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090125
X-Proofpoint-GUID: JcG9mhapDNARjEX8YJ8zbZBoRGFkqx8B
X-Proofpoint-ORIG-GUID: JcG9mhapDNARjEX8YJ8zbZBoRGFkqx8B
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Salvatore,

>> At a quick glance your mbox looks fine. Best way to validate would be
>> to compare the resulting _base_config_dma_addressing() function
>> between your tree and upstream. I don't believe we have had
>> additional changes here so there should be no delta.

> Yes, the resulting _base_config_dma_addressing() function is the same
> after applying the series of commits.

That looks good to me.

-- 
Martin K. Petersen	Oracle Linux Engineering
