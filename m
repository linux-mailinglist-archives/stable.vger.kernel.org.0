Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DB53F4413
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 06:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhHWEO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 00:14:28 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:51788 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229462AbhHWEO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 00:14:27 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17N3uo1Y016841
        for <stable@vger.kernel.org>; Sun, 22 Aug 2021 21:13:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=date : from : to :
 subject : message-id : content-type : mime-version; s=PPS06212021;
 bh=DNir2iwBS+XLP0tFkrxIN70Lgin9G5PY07l8rr64/2E=;
 b=QjmQz9e7LOxahDupc39/PTD5dQ8eTO14uYb6qsXFA7+drypvA54ioTctsOjpbFPw8FNj
 YSZ2XOX3rGDp9vg7d9n4PBpa6+J5bHUFFaiJNtzhmgvOuB3fN07kul1i35LMVYC9FY+r
 ccKY2nFi2UzPRdz5MVuVyWKBcTbmL/AunqsSh+gXksYU/OxQcZT2aBTENevrAJnZufS5
 YtnKCBlbSh5EYu/MZ0VS43PL8X7bpVHWdpmqpzDal6Jxas8JczjVvkKQJvL6oYlYBKh4
 +TiLsB27215odIIThSQdCkPUGZ8/Ya6hjSeB4QLRo2lMcNnDV1uucAHPAgqsrVpHFGOH lg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0064b401.pphosted.com with ESMTP id 3akxy784d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Sun, 22 Aug 2021 21:13:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PyndcXWZOL4TWZvZvIWUPr3SlPo/bkigevHXzrd9bpmFM1i8TmH/boMxHho8CDIn+mM65M4FqE42av0nmZDeQf4JYizjpiIoeBkMfKzHv8U3Pl3tr2oN+3EZt0Oy0npsMl/bBXpfGTGabvFBxJsWCZ6Y7It0cKLxPl4FEWcuk8ok5OhKRCsaSjuZp/sbSCzCGPEDD5Bk76tgM5bMJ+rpwVyFJJTLxkJ+oHCz/Lpdaah8P3/K/jNKcVFFZvb3nVVbXdUmMfflP12qA7jMxxd4FFuBG9Pq+/FPNIKAjFknumN+INFdcRw8lzHyPMncn17jbOZuH6PkdQZWKGgEyCrqpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNir2iwBS+XLP0tFkrxIN70Lgin9G5PY07l8rr64/2E=;
 b=n0UmeOnyUgqZ8juN0r9Qlm78mxgvSWn/OhquvRf8Det3pL29RahWl2zUUMdqZOA0yNbNO+73F7QNNUWIDicJcZnbM78gtBioavMBncyYgPVb51QbCM+kMIFWcJtXJMEdYtpOgmQNYbZIs9wE8KT7GqCe5iOmZdNlxqX9euVvI0MzRLIHSTPThV+niVVoh/yT3EvlpwNO2p1Cf6s7OA6Pg2NfyH1jIpQ7pW2LqcyM3rKXf6M5gq99fhsKc/fvtSwFtOj90bTGO951TMndKPVUkwG8eoEJbD7jutlPLt+R0jKQsOOh2YZYBvQXpBSgPWUbJq3pr0S9ElaKA7vS7a1HZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB4545.namprd11.prod.outlook.com (2603:10b6:5:2ae::14)
 by DM6PR11MB3132.namprd11.prod.outlook.com (2603:10b6:5:69::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Mon, 23 Aug
 2021 04:13:44 +0000
Received: from DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::6812:a5c2:8fcf:52d9]) by DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::6812:a5c2:8fcf:52d9%8]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 04:13:44 +0000
Date:   Mon, 23 Aug 2021 00:13:40 -0400
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     stable@vger.kernel.org
Subject: TIPC fix 7387a72c5f8 needed for v5.10.x and v5.13.x
Message-ID: <20210823041340.GD144129@windriver.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: YTOPR0101CA0017.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::30) To DM6PR11MB4545.namprd11.prod.outlook.com
 (2603:10b6:5:2ae::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from windriver.com (128.224.252.2) by YTOPR0101CA0017.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 04:13:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c131515-cad9-40b6-2cdb-08d965ec659f
X-MS-TrafficTypeDiagnostic: DM6PR11MB3132:
X-Microsoft-Antispam-PRVS: <DM6PR11MB3132D167C58210ABFCF2C90783C49@DM6PR11MB3132.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FgqHGP9gtmduS3rcJrA6rtXCMQ+khapyenbAxzb/6UfW+j5ujvtQf6lBzuJoXeKpSaCHf/UYb0mZs1irT5dkqhE+EMYUkf0IW+UFhzKHVHSBGqE/yuIHklX0Oj0S1wfd2VaQYHQDrCb8E/0gn8rofjhLW4WM4yZ7MLFFD9M4PqYyFUpyYunn7OSOJnGprMeblALnJNpygjAYyPXTJkxLqFIlW6gvo6NCpHkBiix+bmtxtYCsFt0gTbVhdgoG80eezbVqgfH3tSAWHhHKBLYsv7t5hJDUJwALakzrNNJUHIlnRH0Ve8IJWsv5x4FCohfVv5uUdGznU3g0+6/Pw5XHnavuCA8uzh+bgt+sMisPLnIbsWA0qxVe3jQGo/DiNwv8SXAPW0dwmpuG0aFSM4rx3nL6JOQGnwNRQ20KhvmJXN49juZHkKe47gCAL8gQBHWgphAD8azUAVQAU1jYsrfXrkqfRDUVZtBF1r8vsHJIX4Am1qvCq4itXfbRci5UO9lNw5ELigdL7BdHWeZAgDTmZgwKcoddZCW8OHdYrBNAF83IaGrnyyE6BkE5m4iwXVVadR7DtC0cYc55hJTf7v4lLYH4EoCs92IjXyjnmAyq0AxG2E6R6b6ndj7U2ZoVQOceA50z1yjQv9DjJ9WuRl9+lBjNX6/IwSmmoFMs6Z9emyU1YnKTDg3khY0YlyqSun7Ef9qEXEU9uAE8xztg7IFU9F/M7fnBY+VIoI4Oh89tli6FJI9K8ZcgntHMJ9MOJf4T6OvSgGJ1ltjRt9/LXqyf+ob9fR6eI+DbHa8EY1j+QR5EM9kPxwocBgfhgBVvixEI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4545.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39840400004)(366004)(316002)(26005)(52116002)(1076003)(478600001)(966005)(4744005)(8936002)(8886007)(86362001)(36756003)(2616005)(956004)(7696005)(186003)(5660300002)(66556008)(6916009)(8676002)(66476007)(55016002)(66946007)(44832011)(38350700002)(2906002)(38100700002)(33656002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e9aOW/n1SMDi9fX/+5D7pOfMzu3sBsimdXyDm3VN0RoUmv89f4E7yzf8eWqy?=
 =?us-ascii?Q?ErDlqfXlWrK27uUASf9pAquYL7mKSn6q0pRJf2tlceUFoQkD7kMXRqOjt8E7?=
 =?us-ascii?Q?pwDSeiiOEAcEK1AUHrguovasSBD0/0fb/HILv9U4GL/2iS7ish+GLY8kguT1?=
 =?us-ascii?Q?1DeY1oO7ukDMpKR4JLzZyztJQgC9/PCOcm+I+Z87f48f7qLyo+4SOThvvabp?=
 =?us-ascii?Q?dVix2eZS9l0nvyQlZY+g7KKkNGbUIDExsZJzYZ2llCuCUeIG4teVA1Uq1nwM?=
 =?us-ascii?Q?c5x14L/aeVTEHiALNd6Rk1IMaze4hX0BA272laYdP13pySt8NbI9KsbaEohR?=
 =?us-ascii?Q?yi1J6H5rd8lRJtL50+cm1Km2b6tEFekKcwkLE2MjdSscraM0AioWqKbPPpFF?=
 =?us-ascii?Q?VX4BmuLpcCdlVNiX4giEDaoIL6xAuuYa1CraSTJdTF/uI3D+3u2jDfqAwqxo?=
 =?us-ascii?Q?Mv3DzyKAw5onfSnOQXdg/Le3+NV1GviU7chaSS2eTMGsscKOWaGykhPr0IRZ?=
 =?us-ascii?Q?8Q2UReOZaL6iLv6xw8zctRjFybVTWlaoigqBbAzUzjPR8qO+8F19SnSI9nk4?=
 =?us-ascii?Q?Shg8lMbOfOHlm0IwzYNrfhci/dKGIWbzo0wpbbBLMsWvL7OBUQLKgp0ZAwSY?=
 =?us-ascii?Q?Fdm+jgsML7Ypb0qkdxMFHGM5UJ7jBIDDcgAQNLYyl9O9vdjVnX5wYdwJ0ogp?=
 =?us-ascii?Q?C+ls3bewIWyY3jN9uwRzAJNn/Lqa5NeDw0BaxyULsMm22zja/oN2wWYT6PB4?=
 =?us-ascii?Q?KsShbT8sUqfiFpODRhPdgR4FWIwxGI4RMVZuhdCKCkj3N9WYlj9ozc2k9Qgb?=
 =?us-ascii?Q?3wwl5VB4CLjAjqSWAboJmpg6vup9R3y3Oxw2vC82TJlEBOTgfSBLXjberXZH?=
 =?us-ascii?Q?NefWK7lFbqFfZS2IzGVed+Awvx/rmEXSqhTsneHRN+pVmnmqwUoMWiJo22Qi?=
 =?us-ascii?Q?3/Gjb9NdqRyW+ATm6S7GbhRWU/YV77P9hUbvQm84V4lbFSd5O7fO/cBpRGDd?=
 =?us-ascii?Q?M4QK2XmtN6TAICr1XnPxYu4xgzt8h/Fvj00JhTi+h7LfdPNM7Npp4Cw3gxLr?=
 =?us-ascii?Q?68Ex4UmKUz8mH6WMa/sqmFZ6Af1Z/3yu+V5M8Cy4+OS4RK1UaitM5lRtWkZK?=
 =?us-ascii?Q?TcQGWpehKMgo7TGMYLfy10QNq7hMbDyAwC0sLCXuXQDqijIh/tyZunl2+JA3?=
 =?us-ascii?Q?H0ee7JZ7JIuZiEHF/rNeR+YrXUC6wzVGnPYl3OWL3Hht2jlDydZ6n3iF3DyC?=
 =?us-ascii?Q?ZPahiB+ezbIcqgXrJNQsEHNhA+JZ7wKFWNXiInG4HJ+PgMAEIUTkM99/jTvC?=
 =?us-ascii?Q?EniKQBJmi1+Nnu+aRAL3VwnD?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c131515-cad9-40b6-2cdb-08d965ec659f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4545.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 04:13:44.2702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2c6sPh8rjsCjtzNNe4KFrBN1XvGYFPuR/2ZDn+r+SODqBl6prUHxgcjT3Dhso9bhLagjnSpcQEOnLMlu0xnHyL9H524QiRhRUpAj2DjCZck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3132
X-Proofpoint-ORIG-GUID: vIo-SssLhLRfWsWVyDaHm8tBLQIHODi0
X-Proofpoint-GUID: vIo-SssLhLRfWsWVyDaHm8tBLQIHODi0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-23_01,2021-08-20_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1011 mlxlogscore=284
 spamscore=0 mlxscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108230025
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A bad "Fixes" SHA in mainline 7387a72c5f8 references a non-public
SHA, instead of referencing f8dd60de1948 -- see:

https://lore.kernel.org/lkml/20210817075644.0b5123d2@canb.auug.org.au/

This matters to -stable since the broken commit is here:

stable-queue$git grep -l f8dd60de1948
releases/5.10.56/tipc-fix-implicit-connect-for-syn.patch
releases/5.13.8/tipc-fix-implicit-connect-for-syn.patch

and hence those releases will need mainline 7387a72c5f8 applied but
I suspect automatic Fixes: parsing won't "see" it.

Thanks,
Paul.

