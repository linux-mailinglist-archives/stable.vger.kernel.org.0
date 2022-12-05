Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD0D6433B8
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbiLETi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234632AbiLETin (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:38:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA54C1098
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:35:38 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B5JNipv032635;
        Mon, 5 Dec 2022 19:33:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=8LXYu/IbZy0vWaLKB9HpO+UCCvtss5gIj78uLUMt3OI=;
 b=SmMA4QKlQZz42+DXXmSVnAiFNvwG3/1SGj28dJ4rLbGhqvZxxH4G1uQp8xMxx+7ArIOg
 VEY0+g+i+MfgVsUqJOyvsMB08OhAEiFA5DztL9WZFGuL9OiyiPh2py54pChknWuIzweG
 KbHaI/hDZjZuG7GAmKGPpPINEKc3u6WAcGRf/O1wC3iB8ArGrABx/6miVbTojoRubSl8
 F+csP5Zie9cdbBaO9FM+K0xahoTvybKjkCUbHEl8rOttUMiM9L7WZGhyMUXl5piR6aBC
 S+o1GR8u8WgiePe7LWPGpakvl6tJnHX0WCsFu3Rf4NBh96IxOhge8KPzBMlO2vwQi5bK SQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ybgmy29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 19:33:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B5HoSMX018801;
        Mon, 5 Dec 2022 19:33:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m8u9ydx0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 19:33:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMoTogh3C0ptPDfEm1cOxMTlUXgINMFI7ND4DbdD/toTXJyV9G4AaoOTTekW4RvbDBLkCtOHxrdB2s9lEbfRJbA0P2MDW1r9hKJvWoxvbcBFaFqM4lqbWmW57jH/EQ/7gykmusJrjhWrSdP58QpND3OTAYHphbknmnQPy4104ocOvTHaVtlufLoTKmUvAE2Z7+mTTbeqiq61PYWADT2+dOHb4zTdiysgbkG//KtsaGi2+89edBnjubsd8maFJUsXiVKmvCHYSt3K0HWsOEPrr3hkjbNEiTWkK+XGJ/9lIw7+lYxMCjHAKHN8litGqHbGHFg88GyEX7sOvsDCOkJ6AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8LXYu/IbZy0vWaLKB9HpO+UCCvtss5gIj78uLUMt3OI=;
 b=QB4I+UnCNQT1wQsbGdu5zl6mw4+JYfcmG27L3HvXec3P7jTkSoUbL2fwWDKXHtTHoCEltYIGtomqOLHUIDlCp0aBeIappu9PXQFBu/oFkTZorW/27gTaVsN5p1YJ1wD7/BbfwNSYnFnR0Ij90JPfaKgTZVWzeEFPLE3pHgknp4jCDUgmwKwpDlLNh1Qe1zYjqbbJfAmDeAnApWzBnrmn17HXxDXwpATL9u8ES5ytNQLv+dYhVcX9QZzNmHwHnkA4j2H3dXwWznCNKooxEDeDQCjrRR+CkTCIfHxOSh6wLAuLGZLP2hzfp2H9wUdQIwy0oFDSZA8BOHd8B80qBkX6+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8LXYu/IbZy0vWaLKB9HpO+UCCvtss5gIj78uLUMt3OI=;
 b=UzhoTTZclGfI5GS1ABNlWwtBH0SBB5EKsP5QFYdeL7rLAzk5R5Tu384itrgMPx/Y5YeUCFg2+HQRKeNUqf53bvp20P7Bcnt1Topts9is5hqmkDkIfq+q8FKKeswl814DXbilvvlg4myNiqJYww8mPkavtEC/7NmEDdrev5O2684=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 19:33:13 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 19:33:13 +0000
Date:   Mon, 5 Dec 2022 11:33:08 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, almasrymina@google.com,
        axelrasmussen@google.com, david@redhat.com,
        harperchen1110@gmail.com, nadav.amit@gmail.com,
        naoya.horiguchi@linux.dev, peterx@redhat.com, riel@surriel.com,
        stable@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] madvise: use zap_page_range_single for
 madvise dontneed" failed to apply to 6.0-stable tree
Message-ID: <Y45HdPmy9CcPiCDz@monkey>
References: <1670066568575@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670066568575@kroah.com>
X-ClientProxiedBy: MW4PR04CA0210.namprd04.prod.outlook.com
 (2603:10b6:303:86::35) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|PH0PR10MB4421:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cd7c913-01e1-43dd-09e2-08dad6f78b6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tNDAmdg83myu/X5mV5HnqZPkc1BliwFJ5T+VqBqOYIhGEnyQvg0TTSVvQ/dwdB74sM98aZ8qd5UGskm3dvU7C3/X2wImEUxI5tAe5R16Hj0hCfa7KbZHXVISeEkNxfXTMM5Xb8eEoAH2K6FNAucQOb9S4uicGisgXhEjewhCKU9BD1QPj9wHtlowkVVii1ccmCKlUSkUeT8rPlfnvcSEUjM01hmFbndvL33v57VGS/KoVwvR7T90dt3M1E7vUGvaH1OIUEEKt1nxkUBOVIi0VvbkQXKuYKx4cT1P0mjLk/5UP3OX+DRQ1gxS3TMA6LBy2VNnbnOswu2qlIAbwotfF99PQIN73LL+OVoHPLssgImct57053Jfnc8AZvhpMmo0ZaG52n6gqquDE74qpL+FDca4gDRz2Sxk8aIorjKvGre1CBeJKrpoLqXUWz5R27vHqKcmH4fHgPO4hTC/f9VQb1Iq+NddtplWIO2Z2mwck/4p1Ln204d0HRDwUNkwqsZS+HORqHMD5YqT/qnEmG9Jx0XJrjDDFTqSiozWnqo5/NRsLg5flacYpkkhJMZiMOJUg3uzlApId5VvbMQ8rgfP1qubbWx0wMJ8kMdA4lIeGCabk6ucyZCwqptOcaY2pZj7k6fa4ctX8o2CgVFLTPX8SLdHicFfy4BF5JhNBbdDdOroLScHGrW6ILXoSzXrZw4cnHNNxdJnFlNuYaQQqaYLPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199015)(83380400001)(41300700001)(186003)(2906002)(8936002)(7416002)(33716001)(86362001)(5660300002)(38100700002)(44832011)(6506007)(316002)(6512007)(6486002)(26005)(966005)(9686003)(6666004)(478600001)(53546011)(6916009)(8676002)(66476007)(4326008)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Exp7n2iIErrsi0zuJRaY7QHj3Zy8qxuGFq3xaiwj9bmiHF9tH2laVYBBTzQV?=
 =?us-ascii?Q?8S5lLaE4uePUbhIq3XumwT418QxaZBKLfmRPDfS4A6P04vvKg0hwYgIl3zJy?=
 =?us-ascii?Q?XOXXcdfEvUMaA/WNJ4QQETCfJS/MkcTyCHteF3pfYMx6fLAZjnzzvkHvbLF7?=
 =?us-ascii?Q?P+gJqvP8aF/qaKxXrDKNu1JKdSERdSIQo8hVHeIa5Uf6SzNqC/fKSWGDooaT?=
 =?us-ascii?Q?Kc0VhhFzSZPhQdiStb9/N7kkJzucIbhS1RyY0jrM78u21MdJpMidrnZxGW6z?=
 =?us-ascii?Q?AwkUSZ73ABQQxlgKynmVP0YxbShWBuOPyoHxGiqAw7zaeGJdAHQZ4RK/O67i?=
 =?us-ascii?Q?nmQamHwkRi8fuFZAo49NEuEc76V3MqBCY5uVb+a02rCnHu6AaTK/yJAruPbn?=
 =?us-ascii?Q?T2Xy4v2wc0LdldEzUtFszvS3KWaKv0gbXC1tr+2seKVPSzp/TVje0X6g4OIo?=
 =?us-ascii?Q?pTGGdobbE8MLaiwz9ds8ffeSfJ0CordPZXi91DMl9p58D7Qsih22Pg/m3ssz?=
 =?us-ascii?Q?CyM1Qhmvj+bk7VSEf5IGvKjbZ5+r6wpBPg78JD2JKs9qkxm1djAlVrz0Rkci?=
 =?us-ascii?Q?FZyKBA5US4xlNiHex4tA927x7Zbmp4koOK8Rwbn7s2u8UXcB7pXVFLD8WbKH?=
 =?us-ascii?Q?XiIXCVzqJxgc6CI1cyeJwrLKQn24x1EMyM+beKPUjSJiGqAqlbtd3afrx0PQ?=
 =?us-ascii?Q?sQ6STBjytNgvrVE1GVWWPRpPLRN9l1NwYkAGOJylH0kuB2fG6hXObQBqW1tr?=
 =?us-ascii?Q?idPzfLIIKRqMtmlrjm75tIABqevQO9BnbSeKUf8szJkPdN1SzDNpqwDPKg+S?=
 =?us-ascii?Q?57U5Duz3JscPDTDkT4PoRby5VkrJ7VvJWr/2Udcl6xFQ1B7lZlStBm+Bh/jG?=
 =?us-ascii?Q?ptsRnyGdweEk0G7cN7JxEyay1P7d9EGk/UONYnvS5aOdDjNBUxk3s4jHwDPb?=
 =?us-ascii?Q?gaapzTUdoLPl4yP6MaNX3ZAbCe+Xg0ObfczyS0o3trkZIqESYkkeYmJAPN+C?=
 =?us-ascii?Q?JCk8NJkmxAtC99379+VYxA5Exkb7/F841erHcfZ76MNtMdTXhfjuM+l4gu2A?=
 =?us-ascii?Q?lE4fEQM0O/KjfeB4iYxOqdBHy4wLpGvWgCerUNrsjaHSsJ+7x2TyzbnuN1XN?=
 =?us-ascii?Q?i5IQvvGMqViOW9bnFw4uQJ1vxoO4aSC6Y/HXKbYA7YBDhd4ELNXl08/Tmtft?=
 =?us-ascii?Q?BT0R3b4sAy5Wdj8C0BrR0vawC3QZhxrgGPUGanO9C8/MN6Hy9xL3Ox8ZK8Xa?=
 =?us-ascii?Q?Gr9xl4c4k8dy/cPNWMRsPNFKiP37jQEu5DAPmnH6XwxpYle6SINEfDjiTWy5?=
 =?us-ascii?Q?mzezvzTWYCZsy1P6qyKgT3CfMqJ7rzzRPN61A+vWVsiuQ29VdLg0h12RUojs?=
 =?us-ascii?Q?JH4cu5n+D1s4qGEi3dfBIP8oUewnnziJwS5tX3MOM8DK3cGpP6e70xy7MLTn?=
 =?us-ascii?Q?pBqj/D5ONnjP3WtKpN0deNouwE7FNzM1N0bmexzqmzAxBF5CdYQHgDYK7uyV?=
 =?us-ascii?Q?dMIXdsGESlEO1Ng1cZjuZgxkrFJIEBgK8OHZ5tjQ1sHxbwLhqIELUArm8jEV?=
 =?us-ascii?Q?EezLzBHMs865LNjhO9uj/zQBgDu1WzXT1xTzWcWKWZUWkzZByuQbzjTHzQoG?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?j9edqwIJ9U6ziSa/6TjbitTyxQ5c8UeCWwCCa8U2nxq1npG4D76oTtoJv/9B?=
 =?us-ascii?Q?GeKmyWz0awX3c16apvrGvMD18f0r0VSHI9hkodKFVHRJGMLT2MPINBk3/uU1?=
 =?us-ascii?Q?GgrzoLsdFs2B+kJUbVw6oFFCQjFrxvoMOPHXh5aAItoB7dR+aGyraGZGUQa0?=
 =?us-ascii?Q?CardLHD7h8nHnccgFla25H+rTpyNTgaxvIbg27tHocpZ62IW49ReJX+YnKJ6?=
 =?us-ascii?Q?kmVm3gx7o5DyICSGOf66VKWxWRSXHnKjmXjWUeSpPZlBKMAnpd++l5UtDldf?=
 =?us-ascii?Q?C32x6IH89ch7b0v3/yocsCMjp97tDR1Sb+cRTVlXvc88+sZtN9uE67LLvmZR?=
 =?us-ascii?Q?uTrUDfw+6QIsRo+J9QcYAA14i3UlfUJj6QO3e53pS/H5Ue/cpPR1oi1pgyCq?=
 =?us-ascii?Q?e9NaW6yV5xO8d8civh/2PD7ZcoaReWMh+/bxG7r/pUsuz9gpcEwbM//AGGLm?=
 =?us-ascii?Q?GCESKEMdyS5krRSvtoBt6IJ1eMoRR1ZXPaRaR1cR8F93YHYau0lEitiMxNXE?=
 =?us-ascii?Q?v3UUt1poWiP4jJl8AUENIbvPyKxGJ50u8Ox3dn4Whjxx11RIPBDkDc3JpBXE?=
 =?us-ascii?Q?b18bL5qb3dl44SVHP73PXe8UkHQvuglDjhK4VZnBXV+lN7GVMv0iM8fhFG+y?=
 =?us-ascii?Q?9SkvVOMgjkPG8NH5f1z4ROafvE4IWKRr5ERv8b1uyEq0W75xG97M8NsOOESc?=
 =?us-ascii?Q?9Bnv02X/5NGRf9W/h4jQ+D9wUw/DKIMzpSXAqZvcR9GPl3Wk6MmciHb/7FwP?=
 =?us-ascii?Q?YMwXEOVhATdTQ/BhXW92WXt1I9ZWERsK+UYiWVP+ykS+BszKjMa4x6fNzINe?=
 =?us-ascii?Q?ybg28Pa2+haQ0W/4KT2MC/P85EsjgsrV7QPOHIU4L4YlmJ7b2ALEGWTBuhwO?=
 =?us-ascii?Q?1xGYFNwoopJhfOeLY5JHfn0bCUHdfQcKRxH/0YAPc22EfRN64sw1+GNnKqsW?=
 =?us-ascii?Q?xAUirqc0UuLlQlg+L7jCe40kfwj8tIbB0N805AtDoGLfKdvmxbA/LdlbSF9J?=
 =?us-ascii?Q?AzLz+HepbbcyZr0D6kTu/ACxF7Ujn3b81iA3MT20iAjmOL7UQnJnsj/9ck5i?=
 =?us-ascii?Q?oxM3c6SgEqTBS9481M2M0z44OzlRmWD5XYkBFbA0ubw72PwHeI68usryOKJO?=
 =?us-ascii?Q?KMw6APgkKyrwY022c5f+QOv6lUeEJa0EXQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd7c913-01e1-43dd-09e2-08dad6f78b6d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 19:33:13.2206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n6CZOy+pNsF0IJj32jZdYGfngNKVfiTo7jf1f9IEvEiLOmuklkPf/FZ6q4BgIzvOOdUwS2FjyhrTrUWlkG0YlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212050163
X-Proofpoint-ORIG-GUID: KlvBZ_xA1p9dfrv4KrFp0rk8J3gTpgQw
X-Proofpoint-GUID: KlvBZ_xA1p9dfrv4KrFp0rk8J3gTpgQw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/03/22 12:22, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.0-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.


From 28909a3b8a9ffe2ba7c38903fd725a045fcb755c Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Mon, 14 Nov 2022 15:55:05 -0800
Subject: [PATCH 1/2] madvise: use zap_page_range_single for madvise dontneed

commit 21b85b09527c28e242db55c1b751f7f7549b830c upstream.

This series addresses the issue first reported in [1], and fully described
in patch 2.  Patches 1 and 2 address the user visible issue and are tagged
for stable backports.

While exploring solutions to this issue, related problems with mmu
notification calls were discovered.  This is addressed in the patch
"hugetlb: remove duplicate mmu notifications:".  Since there are no user
visible effects, this third is not tagged for stable backports.

Previous discussions suggested further cleanup by removing the
routine zap_page_range.  This is possible because zap_page_range_single
is now exported, and all callers of zap_page_range pass ranges entirely
within a single vma.  This work will be done in a later patch so as not
to distract from this bug fix.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/

This patch (of 2):

Expose the routine zap_page_range_single to zap a range within a single
vma.  The madvise routine madvise_dontneed_single_vma can use this routine
as it explicitly operates on a single vma.  Also, update the mmu
notification range in zap_page_range_single to take hugetlb pmd sharing
into account.  This is required as MADV_DONTNEED supports hugetlb vmas.

Link: https://lkml.kernel.org/r/20221114235507.294320-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20221114235507.294320-2-mike.kravetz@oracle.com
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 include/linux/mm.h | 27 +++++++++++++++++++--------
 mm/madvise.c       |  6 +++---
 mm/memory.c        | 23 +++++++++++------------
 3 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 21f8b27bd9fd..7368a99e4e55 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1778,6 +1778,23 @@ extern void pagefault_out_of_memory(void);
 
 extern void show_free_areas(unsigned int flags, nodemask_t *nodemask);
 
+/*
+ * Parameter block passed down to zap_pte_range in exceptional cases.
+ */
+struct zap_details {
+	struct folio *single_folio;	/* Locked folio to be unmapped */
+	bool even_cows;			/* Zap COWed private pages too? */
+	zap_flags_t zap_flags;		/* Extra flags for zapping */
+};
+
+/*
+ * Whether to drop the pte markers, for example, the uffd-wp information for
+ * file-backed memory.  This should only be specified when we will completely
+ * drop the page in the mm, either by truncation or unmapping of the vma.  By
+ * default, the flag is not set.
+ */
+#define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
+
 #ifdef CONFIG_MMU
 extern bool can_do_mlock(void);
 #else
@@ -1795,6 +1812,8 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
 void zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		    unsigned long size);
+void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+			   unsigned long size, struct zap_details *details);
 void unmap_vmas(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long start, unsigned long end);
 
@@ -3386,12 +3405,4 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
 }
 #endif
 
-/*
- * Whether to drop the pte markers, for example, the uffd-wp information for
- * file-backed memory.  This should only be specified when we will completely
- * drop the page in the mm, either by truncation or unmapping of the vma.  By
- * default, the flag is not set.
- */
-#define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
-
 #endif /* _LINUX_MM_H */
diff --git a/mm/madvise.c b/mm/madvise.c
index 98ed17a4471a..b2831b57aef8 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -770,8 +770,8 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
  * data it wants to keep.  Be sure to free swap resources too.  The
- * zap_page_range call sets things up for shrink_active_list to actually free
- * these pages later if no one else has touched them in the meantime,
+ * zap_page_range_single call sets things up for shrink_active_list to actually
+ * free these pages later if no one else has touched them in the meantime,
  * although we could add these pages to a global reuse list for
  * shrink_active_list to pick up before reclaiming other pages.
  *
@@ -788,7 +788,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
 static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
-	zap_page_range(vma, start, end - start);
+	zap_page_range_single(vma, start, end - start, NULL);
 	return 0;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index de0dbe09b013..68d5b3dcec2e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1341,15 +1341,6 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 	return ret;
 }
 
-/*
- * Parameter block passed down to zap_pte_range in exceptional cases.
- */
-struct zap_details {
-	struct folio *single_folio;	/* Locked folio to be unmapped */
-	bool even_cows;			/* Zap COWed private pages too? */
-	zap_flags_t zap_flags;		/* Extra flags for zapping */
-};
-
 /* Whether we should zap all COWed (private) pages too */
 static inline bool should_zap_cows(struct zap_details *details)
 {
@@ -1769,19 +1760,27 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
  *
  * The range must fit into one VMA.
  */
-static void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *details)
 {
+	const unsigned long end = address + size;
 	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
 
 	lru_add_drain();
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				address, address + size);
+				address, end);
+	if (is_vm_hugetlb_page(vma))
+		adjust_range_if_pmd_sharing_possible(vma, &range.start,
+						     &range.end);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 	update_hiwater_rss(vma->vm_mm);
 	mmu_notifier_invalidate_range_start(&range);
-	unmap_single_vma(&tlb, vma, address, range.end, details);
+	/*
+	 * unmap 'address-end' not 'range.start-range.end' as range
+	 * could have been expanded for hugetlb pmd sharing.
+	 */
+	unmap_single_vma(&tlb, vma, address, end, details);
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 }
-- 
2.38.1

