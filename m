Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450533F4C99
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 16:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhHWOrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 10:47:04 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61468 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230246AbhHWOrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 10:47:03 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17NEbY1F006594;
        Mon, 23 Aug 2021 14:46:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=DkkyZaihbyiLy4WR0Le4Y+0/zzST54wKvw7fCWRB1cI=;
 b=Pzis4/nFlYGiztwPKh4f1ohrsFl1f+biHp6vi60avtMyoH0eBNLOE3A156+HACc8YHGL
 q+EwmcAXiXjpMJMNhWxuXBI/NGMyfNqEhMnceuac6HmUrCSnQg9jTHNp4kzO5kD+mjut
 YrSPoLzRpdTj+v63hUPiE5X2iBMLlS86RBVP1gIf4risF2KOklpKEU9kjF0HNQSUYpvv
 R67Wnruo+VOhBI1PVt58giKHyWXg+bYEYvyn4r0r/YwhGlJpui9lTiHFSKqjt4OP1u5F
 eUZGYzTV28x6BVpWziIExlQfr0yDisCY5OuDdpPj641f2Y92s9T+BR/Wwe0q7BHwl4jT XA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=DkkyZaihbyiLy4WR0Le4Y+0/zzST54wKvw7fCWRB1cI=;
 b=h9t5Iw8c7CDx6d3s56gdKT2oxrh7a8FjQ7xik/1ThCIkNMeHd4TGRU06dSLL3kIWkkgT
 BNHC3HI3CqS1//ce2FUkRkVHrBHfBSe5Y7XeLObeLk1TmdebM0/lIr/6ZQrqLXe6Tfpo
 OsKjkx1Tl2mPC5H9AXXbVNsYkH+EwcwvSol9PSUJrbXhco5mkIo6GkxEZg+Gx+Ph+dFi
 as7vHOr9MwkOOooLosMPrsW1Wbd3y0z6VU2eAaXkH1VXznH6GJehEN0h5OEqg4OTEt/C
 P9GJRjq2riad+jxLjhlVZup4RyGLKrNao2bohUnKOAL0xFmK51A5sTFdXJ+TQd6LSPGc JA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aktrtsuka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 14:46:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17NEjBR8077675;
        Mon, 23 Aug 2021 14:46:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3020.oracle.com with ESMTP id 3ajsa3ffdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 14:46:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIO7C/2xbc2gwD3HzO6r/POaldMZl7zyEe56pY8+nmYc9C+vpcMAgJIcGrqNkJQ9WWsXujjgYhJyGqktKsdzl2BizfI0956xvrpXhsPtR0csFgtmNagFzEmL6I8SNVLdVuFRe0KPftgjCwOxOu9eL7+l7toqfUlA0KTcept67/OiI4pUybfm2NWvfZdsoUtPshuSuM1rT3mGwSgtj8oWaKYh0a0rcEtPOzVaQx/bpDxbsCIKmYe70mF5s8whZrEmjV9sUNEJLJPqWds/9otkBt9a0KP1NpmnTcLjNlZmQxXnSoRppPFSG6voLvTtelezviEXrf6m6tFO3O0pymqR9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkkyZaihbyiLy4WR0Le4Y+0/zzST54wKvw7fCWRB1cI=;
 b=oaMC6c1hYMR2dsAslrYv/3hVRdtg6uExnOUOwNiAASzjfoi9Iv5yOLgZUWHC4ZTfVdb6M0Rab0QQD+jls4+L5VNIMMwCOHnCE340RdKsrjzNzBiDrQhPOfl7yd2zpGFgZXdCF4jiLKIPE82d3XCl0Br//eSfR7GR0V/9X0oVJZrQVxrSuENRkV6k/4a2jZxGzAZzlPcPu4uqhm6xgGmqcFDkQ4dAhlxX3xS6rn9zyoxpJjRtFkWuDWHJOXG6++AUVlikGkCn76cYfyX/EkB3W24wptUUQliAsYo22JiVfb3duiQBKDWVrmdTEmZq8gzNIa8DoTVMgpoJ2u0+2JqZgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkkyZaihbyiLy4WR0Le4Y+0/zzST54wKvw7fCWRB1cI=;
 b=dBJl+EqAFjXsigURp7e1DCb4OHlHC4CqV9mOxDc3xjdtbX4Cbsx5T8BZ9EhCPJf9gZdUfAp9jSDqWE+jKfl/PoGfjrfOdqxzgoYuMQEuzKqL+07aS4Qnvv92bIE+j2SVlmpB7D5WT8CV5DaXsklHHhfhwB4LjjwPj+i5wNi8G0c=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5484.namprd10.prod.outlook.com (2603:10b6:510:e1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 14:46:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 14:46:14 +0000
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kate Hsuan <hpa@redhat.com>
Subject: Re: [PATCH] libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and
 870 SSDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmu4gr11.fsf@ca-mkp.ca.oracle.com>
References: <20210823095220.30157-1-hdegoede@redhat.com>
Date:   Mon, 23 Aug 2021 10:46:10 -0400
In-Reply-To: <20210823095220.30157-1-hdegoede@redhat.com> (Hans de Goede's
        message of "Mon, 23 Aug 2021 11:52:20 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0070.namprd05.prod.outlook.com
 (2603:10b6:803:41::47) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0070.namprd05.prod.outlook.com (2603:10b6:803:41::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Mon, 23 Aug 2021 14:46:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a69722c9-82cc-4949-26b7-08d96644c1a8
X-MS-TrafficTypeDiagnostic: PH0PR10MB5484:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB548423CFE0164F7892BAD7BF8EC49@PH0PR10MB5484.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k7Tf1490IUwxcF+NWT4p7JeqPR2NSpa7PyCXHZHrjIw5BjgqFrfIIWSdnpf4mLjJIS+iI3m5CAd4lSYRMgjTWDQm8nQhUk1a2OwG1USp3/y/oIAKZ2SmlKxaTGbsbHd+B4uvbIfbcvaI82in1pSBr0wzuH7yuXbZCNRGUbDLb8qo3uS8h083te7XJGBIXvwFEUmIVrRuHplo1W3zZimo6hVdG7R/AITeqSM/2MfdcN05ORVkr+le82Ib0GZJM1Vj4zQ/mENmEq7ijGsj+mIxi33+Kv7lCi2cC1mVffH4PptJ1Pb4/BBZeBNIzNu5j2bmAbUue5x2zVM/cZynprQJZmL7tbriNMQtL3qkM15ikIwO1I458DIO+K3OZrJOREMPORmh0jjt0x1hWtfmYo+xUQwPdYfmvutsIhP0tbaNkiNr0G6kxsaWam0tHk65/YG47Zbs2K6rKK3t0uSYG3fz6uLhqgyxH/6G7zUrTmRUCyWkMCiJEPH5bypJIqwjdSIlAzZGRFs4mH6leds+66IkGLc+HnmB8kyffAY63RHmVvME3A+GVKdRTbrOCcLZPyMMT88yd9XNUwT9DDIa6RyV/d0C5FfeBtY4n56ifUuFOf7dSI3cNxnbfzAuo6SJtP58UyGhVd76Fp5+fr1fMmLFwWbkfyVIv6r/Fh0hbDmNj3kZrQSk6IInnAWbF6Uq00Q/DuZ3cNF7qd4BK3KJwyFvlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(376002)(346002)(136003)(66476007)(66556008)(66946007)(6916009)(4326008)(38350700002)(38100700002)(54906003)(478600001)(8936002)(55016002)(86362001)(52116002)(7696005)(2906002)(36916002)(8676002)(26005)(956004)(186003)(316002)(4744005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FUD+pLhnLIXBq+hRY3dJ8e7jmrGm5nl8eUxboTEE5avcDfeetutPqt47ZriB?=
 =?us-ascii?Q?uHfu39Iv8SyGLf/odUjFApaVOBxcW1ZrakbygFHhmABQW+Bj0jWY8x12j5aa?=
 =?us-ascii?Q?4WK9ueYbUVwbOlTHJ6ZgV8DDGsG+4s5ILvNTdtK3WDJjXuHweQGUH1E5/gbF?=
 =?us-ascii?Q?6Ga1RzMrSE3xDemWvnwZfvLcwREWnOrUe5UmIs5qfAws33PjAadXADevACzg?=
 =?us-ascii?Q?APcyhwT5s2ccL2qLsuNu5bzVTmjGFhlvHjT7xhBHraDprvKj5HvXJm4rt/ow?=
 =?us-ascii?Q?4jrXWamyJVtldWDjpjT8e4OLcVTrTsPidplmwFf9zBvX68mP67FMull9Pf4c?=
 =?us-ascii?Q?kuMF4qKz275fHFTxRn5bNSD1YQhT30ImbH+jCbZ03ZXxQir09RIhmVtJwVGX?=
 =?us-ascii?Q?og7jRfTl4yQKkpLV/cJxsFtZGg3n1QMGWskrIu+T3nAedZ/xR20biKmhVsBb?=
 =?us-ascii?Q?JddHdt0OW5WX0w1/ULBC9aROyQSxELiMhbc67olvLlIan7O386tConhzfM6g?=
 =?us-ascii?Q?N+8iCmZMFDfFSFVg7r82bsqWIwuH49si/DHL0gE1xZOxiXln86L8KHBCCClE?=
 =?us-ascii?Q?JC8EbMdWgBiUf/GqiCFbUDEchPAXbP/5IkEEmTeWsvA5/zkukVxL0cwDR8FH?=
 =?us-ascii?Q?PWS1TXLup6cczrbZoIxQFjN4ynGvX8h1f3u9Vpr3xYIwFm22sj862K6Dj8kg?=
 =?us-ascii?Q?1Yk6PmRFAndZ+2hZbFjmAVVhlxglHHmUIQ1bczvJIyBe/GXaTBGedV8zZ66Z?=
 =?us-ascii?Q?6+x8CcpBZ1u16cayg47+VOrxMKiaPctSEUi32pxr9kqSn6IdlwCnSQkxv+7C?=
 =?us-ascii?Q?GOp3uByYreKQMPTIeQwywMIHs8ZbzlVAVeuAo5FiAYRPccoIn6ffx/gjyXdi?=
 =?us-ascii?Q?pDmZHRXWtMYfmZV5tGKd7/qSy88i9XJwzLNQtmpuoRfw9OPK775ZJ6SMsiUZ?=
 =?us-ascii?Q?Y7vFuZoSEpzD+59uD0oxbYKlEuCiBFdSmQhWH6hUwgfc17+0bNgkxyG2YNX8?=
 =?us-ascii?Q?8+eRhPNAVXHqOQkR+KL22AY4fw7dNix4wYS290FiFyf+Y9xeXDfXXo7EWWQ1?=
 =?us-ascii?Q?TeFrUPVUqF8G8zLpfdbae3C/ZByMpK/sUIzvsZQGQNpRqPfY8opnB0rgdoSM?=
 =?us-ascii?Q?p+qDMzcr5Z0Z6jpG9NQIt+qKDk6NoPJdutF2Uc8YSOPKFooZZaS8hIZHGunp?=
 =?us-ascii?Q?gFVGKjO4p0rNAtbbZxQblViNBY8w+4/6NSCr9zf7h33RMC6MIzHxKlrFRvxX?=
 =?us-ascii?Q?NmgRKZVcC7jvCrGydSBaebLPkePKfKNvskU87ztwLVpxQNvEYkDeyoMIncXR?=
 =?us-ascii?Q?maBcsyYngsLKe8xgLeqFVw/d?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a69722c9-82cc-4949-26b7-08d96644c1a8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 14:46:14.3552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KdRwCPpm/clXknyR1ZXSIDBYox1CR2u6fgjSXtxjS+bZD7qJIz9xubN/1QP3xagWB+wzVx/c6AtrGYUePldzOwTqJHTEXO8nQskv+zOwSUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5484
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108230102
X-Proofpoint-GUID: JE5ErvknJgGH58QpVIzV3K8fbvy5_0d-
X-Proofpoint-ORIG-GUID: JE5ErvknJgGH58QpVIzV3K8fbvy5_0d-
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hans,

> But there is a large number of users which is still reporting issues
> with the Samsung 860 and 870 SSDs combined with Intel, ASmedia or
> Marvell SATA controllers and all reporters also report these problems
> going away when disabling queued trims.

I originally tested queued trim with 860 drives and never had an issue
on my systems. But no objections wrt. turning it off.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
