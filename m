Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEFB36505A
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 04:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhDTCaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 22:30:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49356 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhDTCaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 22:30:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13K2TTgQ183334;
        Tue, 20 Apr 2021 02:29:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=RMnHZsyOKfXw/RMyVWW82qLTIUGOx+1D3aTvdbwiyyM=;
 b=zyNCiCj3v/5NJCX20J1tHuXIUOrvnLLoNISoZKP/ZJA7PQgZA6W0UC/S7S5XDGt6fdpq
 x1JXIV+YdRNilTRhN3Kuu8Dg/cRGwcR11By/d0df+TElTHM6mptcuyni4bjiKiwJAbLC
 E5dyh3RT7/80BHI3N+dYK+LhuaQFjdLYvZ4ZW6gTTc1C2zt7loFuw/jo0y6H7+efrxfu
 UylvmDL2V+Mq2Jz0MMWCWbAACFXcx03Icyb62Z3T3fDqX3QeL2IONu3xiQ3XBUFblrG6
 sU9263InqwAP15DrZGB1lfrruVmyZagmQ6PFwmHq3ln+p9CMpD8C9aTxytOsg7UAZ8UA yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38022xvyqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 02:29:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13K2OlCX044732;
        Tue, 20 Apr 2021 02:29:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3030.oracle.com with ESMTP id 3809kx9x43-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 02:29:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LT5XHs65JEXyeJg0m84+8G9dPWJ0aJH4eCdKRL1hrfvhPOu1L7aG0aVqdZqQCUxfMRzs15A6QbDF52szh0bQY0z5niyHXzez2jeaM5Uj2n4AitAQNJf50C+nVYOMZuh9JHEvh6CR4pN50LXS4ba7qiIIAPVbtVKDiW0z982tTKCoPozkF61cFa3FZvbrpQ9HfdfyDxcQv7NqGjF90IHdPbaiUJ4sSLqLE5+r+QJnaqZtua0irNTl7RjwToQQpOSubpLyxZI9C06yVyE6bXSua25FTWlS3vNlfG8z4va5k1SyFdOnBEdoWHw+hWJ4Uz5QgBrxNXJ0mJx0kF+AgMJJqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMnHZsyOKfXw/RMyVWW82qLTIUGOx+1D3aTvdbwiyyM=;
 b=XAaaFozeM2KmbOOWdkjIw7cQroMD4yLcybv3nKLJOCqC1T26E81eiP8h6eqQGbjnrg8oi8y1asFdxqnJ6a1GrYMukOo8d7Zo7ZV8QV6LQ6svvldN5dIS8jFAbiqmRfm8Xp6CZ38SxRQ5y4W9jadDXeD2uKfzUd0j20EreXecsWq+PXSPqr0gq6Aviv5njbLqPmWhHpD8ZadWdIHEPpNLDlqD1PPiQZRvOXWYtQYuNLEptaGwF/ko5NoCjbQxwDYqB25pgOtZO9ii3fyLnT2lWCGhikZLQX97ZoKaZi878MnLLoNd7t4RKiG6MS26LK+q7tQMuNTE3fu6DeI6ZJwXaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMnHZsyOKfXw/RMyVWW82qLTIUGOx+1D3aTvdbwiyyM=;
 b=CZJyCGAkM6ZSjZhCj7Y2g++innwXXANiIxYkvUC4sEXu7GyabGpWQttfbAg/3KLYbSawfrIlHPK9Ak6lUvT1RzmCYcB/NanZ1nDG8WetD+N629D23QeIBXBsZZXgtXZY2QvW6HiiHp25C3kLr6okDty1XXkiCGyagziGt2C8VU8=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.23; Tue, 20 Apr
 2021 02:29:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 02:29:21 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        linux@yadro.com, Aleksandr Volkov <a.y.volkov@yadro.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>, stable@vger.kernel.org,
        Quinn Tran <qutran@marvell.com>,
        Aleksandr Miloserdov <a.miloserdov@yadro.com>
Subject: Re: [PATCH] scsi: qla2xxx: Reserve extra IRQ vectors
Date:   Mon, 19 Apr 2021 22:29:12 -0400
Message-Id: <161888563603.11594.6677274787479126125.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412165740.39318-1-r.bolshakov@yadro.com>
References: <20210412165740.39318-1-r.bolshakov@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:806:a7::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0006.namprd10.prod.outlook.com (2603:10b6:806:a7::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 02:29:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 434c15b2-acb2-4dec-e463-08d903a41ab2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4536:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45367B85EB70B67740FAE0308E489@PH0PR10MB4536.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rqB4zSbzw2t1zk+HAwERaSsWEYJ2LhOW3+O3mnh3IAeXfh4YQSBtkquyNqrzqfIZN9wNmc02fsAL/5gPi/37pT4qZkguAaZN8eWCmU1/QT1Q8lXGvpBg+Dp5adgSsGOo9MMucoBJkrFa33TWHAB2JLUxYWlh6UBR7PCvJOOXJQg8zNWWpHwIisytLxDyDNVPMcJrT6qXcgVGjaSFpdOX9bN56r0Bpa0/bC5BG12mIQCjjzhDqRfeVhDzoe4MOfgfhumNI91Xd8RSw8mR1lmKHlVa9kAkMUYXWKcWYiBxXIqZwcOdyDHoleEcFzOs5L0oz4JPBGsqwgV5XE0A/ghvzFjPNUmuwDbn48jBrrvC/aUg7AD06j2eLNx4D/4PdnkFyekFVcexerQSpTrQxfMSFamTOD9DsHcxdJtmFcOlXdPl7+zs0lLItADX74VjFsdz8i5lGTM0XiJSWymibXG0W4Gr10mYZCwxkHsbhiYcO26FbrflEXvQ3TcWtV75v3c/dmMDIoliD+OaXHAyli+27BIQRbLKOt2dL82P+nRcI7SHS88vikrBMFK9+A4PhyqxkBMRpmYobin9l68jqaqtkd0bFNdQtpAN7RdKeTfTa0stCvmeTbJxir5R9y2VLaA1n7gcoMgQdfSxOvYja1W+FsBYMhVPNeUgyrRGT8mwqEGdNiUHL9NlV+T/ITIixVbNCYxC9SkO+CsSweIxRVf/jvbyAfVl2+uQJI6IC4lfp14=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(366004)(396003)(376002)(2906002)(7416002)(38100700002)(66476007)(52116002)(86362001)(54906003)(5660300002)(38350700002)(36756003)(8936002)(966005)(16526019)(26005)(4744005)(66556008)(2616005)(316002)(103116003)(186003)(4326008)(956004)(83380400001)(7696005)(66946007)(6486002)(478600001)(6666004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TFhtRUhjaGhDL1lsNS9kR1BkMjdMSWluazdtK3AvZzFvSm1WdS96TE02a1BX?=
 =?utf-8?B?bUpnYTlCQ3FIMkluU0hVU2dVeFFkLzdCYkkrNkI2Q3pscjZib2UwSTF0Q2VT?=
 =?utf-8?B?dzgyWkdNOFpnRU1ETllEdlF6cUU3bDRac05jOSs5aUY4djI1K3ExRDN3V3kv?=
 =?utf-8?B?VXBnb2ZnQlc1OU1Mako3WVRsMDVIN1dJeW4yYXJmL3R4U3hNUUU3RW5oaGFS?=
 =?utf-8?B?QUJtZU1Wb0Q3cFRvTkMyWWNZVlIzWHA1UmF0WUM2QThGeDZ1ZDgyZlpuRmha?=
 =?utf-8?B?UWJzN3ZBWjlEOVdRZUJXMzBTTzN4REtoSWNrbmI4bWE2ajhOUkxDSWZkR3dz?=
 =?utf-8?B?N09GTUxmY3RFT3FtSDhYSGhUTUg3QkpESVprZWlRN015OEJMZmtqTVNKeFZh?=
 =?utf-8?B?aTJXRStoajNuQVhFYVJoYmxUT2IwbGhuSDVidXFYQXdER2d3OU5rUXhiOFlD?=
 =?utf-8?B?VG9Rb0o4ekRWWEJYdEdBT2dMRHF6cmxrSFJoZHg0UjJrSTd2azN6ZVhBSFN6?=
 =?utf-8?B?T3FYbFp0NWxGZVRTQzAzMERxT3VIenhRQmxMN2tPdENSVWNLODhsQzcxNlNT?=
 =?utf-8?B?WkhTWTJ0U0lvdUgrL1J1MUNWZlp1Rk1IeEVIVEw4cSt3SDNLUmttcE00ZUJP?=
 =?utf-8?B?cHNRV3V0dDA3UVk4YzFmV0ZzWmZNMFZzK2Nra0tHNURQQVVFMXhOa2huYzJq?=
 =?utf-8?B?MUU3RitObWZwejIyWlFJRnJ6eENhQm55bVBSVmtjR3ROelhIVWwxWURra0Yz?=
 =?utf-8?B?V3N3MjlnUHZMS3NiWElQd016QUxrWTRzbUZPSjRDT3VsZnZWamgvdWtGdlRH?=
 =?utf-8?B?aXcxRzdpOFR1YkxjMVJDK3VoUmNVNE5YUmdGdkhQcWU2SU1nVWZuYXFrTWph?=
 =?utf-8?B?SkdLNlRkZFp6SUI2Z08vOHA2TnFQdndBcXhHNFpNTG1Ua252dlM2SjdHTXlt?=
 =?utf-8?B?NDRTRjNwbHI0dHZxL3dTbWs0aWJCU0hNM1hwMVJGNk5qdDVQNjlzY01ZbXNj?=
 =?utf-8?B?UmNVRm1vRkUwQ1phUFZGTk0zNS9BSDZac095cGRoT2lMK3FaVjliS0V2dlB4?=
 =?utf-8?B?czYwS1NqUGxZcG0yUFFwdUlxL1AvRisyTTZlVjZycnpEMUh6cVZWNVRDaXVo?=
 =?utf-8?B?bDhxSUZESTJRbi9UaEFSOUJ1cG54V0ZPNys2c3AyQzB2VXZoZU1pbURsQk5F?=
 =?utf-8?B?VXAwTW5hL3IzMjVpN3hpSWY0Zlh0YklCSjEyK0V2SGJkdGpvcTVmR3A2YmNo?=
 =?utf-8?B?TmZ2aTlNdFFXVDRyK3JwK2pWT0ZFQnhESUNwajdkdE5sSUp4Q2JKditYbzI1?=
 =?utf-8?B?QUdCcEZJWE9MK2FqR29jS0tIZXBaREFYdGUvcSt2QmVvSCtiY0FjY0RnMmV6?=
 =?utf-8?B?bkNYQTU1MWxCOC9YdVJuZHoyaEJuTjlHbXpYc3N6TE1CcS9FRkE3ZXlVanlW?=
 =?utf-8?B?b093SzdEb1lPZ3lWTHNBYk4zZlpad3BGQkFQaWhwUkcxdll3Z0pheFRBRTVx?=
 =?utf-8?B?WkhsZTJkaHNEdzJXZUFXVlJDbVhzbE9KUzlHcDc2c0hndlBWSGVBMFE1NlI2?=
 =?utf-8?B?dWRzZTQxNHFpQ08waUx6b1hKbHFCaWx5KzlxRndvRldkV3N4dkxONjZYNVRL?=
 =?utf-8?B?NHBPa3p6b2RYOVo4MEJFUWJkdkUwVEM3bGtJd3VtOFNmUSszSVVzRW9rckJQ?=
 =?utf-8?B?ZWVYelZtQXAybDE0ZExld3MycjRJMGgrTll1ZjVtUFUza3prK3Z4S1lxZHE5?=
 =?utf-8?Q?iNx8C2qPLvTTUBnUr2lo7JXFvqibCygEA2GU2vt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 434c15b2-acb2-4dec-e463-08d903a41ab2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 02:29:20.9008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8Zmp3Npa2R9QBxJI8zEOIvC4XtqtHyf3278LoOdCB79opt+fuIh2O+YSYAQnbgFIogz5AAcgfAcmRU7X6BS0iGGn6VEDgZ4KYBjsdafgu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200014
X-Proofpoint-ORIG-GUID: lBRWkAUzY1BkWnppZL2v1U5fW4uaatkO
X-Proofpoint-GUID: lBRWkAUzY1BkWnppZL2v1U5fW4uaatkO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200015
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Apr 2021 19:57:40 +0300, Roman Bolshakov wrote:

> Commit a6dcfe08487e ("scsi: qla2xxx: Limit interrupt vectors to number
> of CPUs") lowers the number of allocated MSI-X vectors to the number of
> CPUs.
> 
> That breaks vector allocation assumptions in qla83xx_iospace_config(),
> qla24xx_enable_msix() and qla2x00_iospace_config(). Either of the
> functions computes maximum number of qpairs as:
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Reserve extra IRQ vectors
      https://git.kernel.org/mkp/scsi/c/f02d4086a8f3

-- 
Martin K. Petersen	Oracle Linux Engineering
