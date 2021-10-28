Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA5243E8D4
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 21:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhJ1TMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 15:12:05 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:45888 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230293AbhJ1TME (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Oct 2021 15:12:04 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SETjC3019753
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 12:09:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=Gqg8FFqmsFbjTbgxzKaSJcr8ijaumuSTEhq6OoTYYxE=;
 b=PCI0iY+sHAnwbdeLmWeFZR5tfqhptwMHkEYNpKlflZGaIPgWYnmxcAZx4WwAWN14sa1B
 rWn2hJIhgZEUiii5mNNxsgMAxnEql+WZXB4H0D4NT6dGFCpgu9CJu2d0z4Ei7zN5tqg8
 0I2D+6BIADV1/Khkv7NtES1hyBKMTaP5kpYaXd4B641lqMRwxFZ7xqW8aCErNWi5YmTW
 SpIQ4IvVO45VKG2bfP8PW5fsFJzi3esa+MX2u3eFnc7CPIfhmImStK1AssjWFZFlLxXS
 R3DlIA0H8Av6bQjY6pl1M5+ney4Hrn9Xqf3dFxnRxefoIqSW593RYwU7pBKcTJ4CDTc0 Qw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by mx0a-0064b401.pphosted.com with ESMTP id 3by9r1h56p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 12:09:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeWXR/z6J08/2XdldYPrv3Aaxk1UyyYY0jPpWyckeWEuaq2xXPl0PBriV1vE3ugmMXXax7/xOWwVG2akndAVwHK4n0BbHUkJgViJlHSs9uBQSspOprxu0eViPE5W3tOppyn5P37atZDrzcRw4G2H3vR1hqjy71295gkjbmZEPLp0wepMaATyHQpKOw3gXkIjpZTCu9kcMMUbX1EUg/eUoTvpkopnnK77sXwYV/YfkeTV/gVZRn3ExuYz/uN6nIVXWT+efVuAQQ05Rfo9go6JFOvZcmPCQvOeLgwMK9ekuxL226+zTqY3PelMNVMsOC42hBwHRjyhtwycusjDNs6HAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gqg8FFqmsFbjTbgxzKaSJcr8ijaumuSTEhq6OoTYYxE=;
 b=E7a7iagWHUKJPtjml/++MX+K6p/anKA6vmxgoyZ3wLMv9HO5S45d/G+ZtL+DFSmenZdt/gyQEd0FvXscp3tVQkjXc3O4mPR9ivKXuG48JcKbx9W5TGABjKryQTdihdrHj8yScVog0dQeJ2HDRCKX/BBy79EDl1LVpI/ek76vEojmgZqwxKIAR5pBAmw0h7jddujw43/M1+iGNTRzC5eqrLosI8kGVE/Bf/66m4oJBf4xQm/0grFJ3PcCPVMQkUyspDk+URIuP4M0tIkC6bKW0WF/deyyIPIPL39EE54sU/uwwm8tZ/BuGENABrWls33hpcUJzxQFYhPP4oWETYhKOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3210.namprd11.prod.outlook.com (2603:10b6:5:e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Thu, 28 Oct 2021 19:09:32 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%6]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 19:09:32 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 0/3] ipv4/ipv6: backport fixes for CVE-2021-20322
Date:   Thu, 28 Oct 2021 22:08:58 +0300
Message-Id: <20211028190901.1839515-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0902CA0029.eurprd09.prod.outlook.com
 (2603:10a6:802:1::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0902CA0029.eurprd09.prod.outlook.com (2603:10a6:802:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 19:09:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a821084d-5623-4fec-1f75-08d99a467916
X-MS-TrafficTypeDiagnostic: DM6PR11MB3210:
X-Microsoft-Antispam-PRVS: <DM6PR11MB32104EB23DCCA362340F1ECAFE869@DM6PR11MB3210.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:473;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XghTJDAEhpxcZHBlHeBkDA5suW4tQJRq+DRjKhPYEWuJVgNratjzGD/suXto/bu5D+tJ9Oz33BiaW8g8cgG2U3qpjngYLnXddlMn8wpsq68ZIDo59M/31xQ8qxNDO8uNVc2eF05UI/kZdSzTLG3moSID/xll9misZdiajSoKuTjhu27me9bder7l7RPYKsjYblPVFOL1R1U4t+ksKNUpy6xs/ySDn1XnYXJaRZz3GsMnSbJQ+hQTEl8qCKfQYU3Uf1KnPGk99REXkgvdl81OzR5hDw9a5MLXljfrrBtT/BcOUOuHg03QzcXMlUJXkMuwfwoNjwZMnvm/huVTbJ/F/62Em/yHojDnCxZ4jpL/CenS69rw2GDkHeoS2o+Dt9FoQcFgBYPJxv4p0qtanUvHJmoF7y1eSVNZ6Gy+0MGsDrOhcWV0r65BobsbywXJ6iToS/MvI5gvGo4WowRURjs26QcbjU9WvV2l+jsGA86alHp9No+WVsWDGVi91KIaS5eDqsMeQk5+z/c5A2SP6lZmLJ/sidPp+oIj4yx23FFbRQxBKurgRWcafSRWk4al7cSOsoy8T0LNUPOeshmYS0GFP+LNaUp5yrYMqwqRGYPU9TRNzE9ResVV4OmxVG0TCARwf/nIkkQ/VyyyQIbLJ3lXzD/jb9/NsaR0g2aorW9Ayf9CXMfXPR0ddds5v41sheLvDl2zNEnDja4wYHpVbk2vE+VOd1RyxPfi0iNr4hu95VOzAp0ZdUQgFN+WM8SmeE/1Bl6/u0an8KoWowudmd7PXYGDl4uz59k4LD9JprF7CMeAF8dEm8KYDYE6G+akpXR/1vep8kXwN8cjIZcrvbMDuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(66476007)(4744005)(83380400001)(86362001)(8936002)(6506007)(66556008)(36756003)(38350700002)(38100700002)(316002)(6512007)(1076003)(2616005)(52116002)(66946007)(186003)(956004)(6486002)(26005)(6666004)(6916009)(44832011)(8676002)(5660300002)(966005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UfLJ/2T4OqvsdhDhg5tSzOx51RsNRn+NpnLMM4qd1oWs929qHoxbyF9v1IBr?=
 =?us-ascii?Q?VMkVgnoQpX6AaaxGPA0pl0TtW89ZvVPB4S9xg19eoWo9dX8g17sQ7A2g0/Mm?=
 =?us-ascii?Q?SUVpxCClMReQylJDi8vt14m6Qc9xaYQrWygEKv9gzfjBJSgIJh6qBn8X6s6+?=
 =?us-ascii?Q?GbiWwKM/p7DmVnkCu8bnYptoHoo6/qrShswiilqk21dwDLx4LXwQTgt8c8IS?=
 =?us-ascii?Q?Fgt07Aq12nA20rK0ozYtjjodwti90PQmVx9NnYoUBrdXKvRFmSDQfeMeftWd?=
 =?us-ascii?Q?69qDh6YbcBrKrpnMa3xn2lvYB7uBRz+mUXfcpYgffSXYT6t3pB8aHYY6LCVn?=
 =?us-ascii?Q?44Ef2GGNmBTBnh98JCeyzOgCtQV0GdFgmO3U5bQIxsFEOwSZIOFnuk6yRhSE?=
 =?us-ascii?Q?UpeJrQxNDpRsIpdt7qEFs30nj2zo19LMo2AVZqxlX9wNIVARbzYq8gQUgkml?=
 =?us-ascii?Q?pT+wa8JtU3gpWWMWhTR9DFdEjBsiKxOpomPVu2gVACDGwZ314PjRP/KWgDvN?=
 =?us-ascii?Q?mTlKO6YDequm4u+sk12H/Cc/fs7Bfb2w3e31gR26TBkkTzIVAHrQYZl6Uymd?=
 =?us-ascii?Q?1SiqvqEXImAXKaDxkvhCDwf7JpWY/bJg0WQ2U/CsLyvpDTB7Uiw52rIMzhqe?=
 =?us-ascii?Q?x0xvddCnmZumZvPi0/AtSc7PHaSTkwMNX6eEfGmcLl0kGV7AIwRe7ucT5WTO?=
 =?us-ascii?Q?eQgFeZuNibQU/E/tC7mYFEV/azh6ZargSgiVq6o0B8shsbjmPmzdlUvYv/Pj?=
 =?us-ascii?Q?WGt1MQcAEn0n6zzqFKvo+Dm9mHNiho6ZMVvSk+1nlb00NtRqGYxg5t9D0ZEo?=
 =?us-ascii?Q?+fqrWErT+zIbvwCIaLaSZ2Cv9XGyolQgXvrQmIu29TySYdYL9+QSRGwCwLQn?=
 =?us-ascii?Q?9kXDj/Hnf7DAvzvKeetqjmaHGj5MJbMpRCYdrpnwHVMbzyj3hjpMpxa4XxAh?=
 =?us-ascii?Q?nVqGnB173MF7JKVig1iy/NsgZBPnS1TpfdUr8x3Bn4a1tkktNBB1ObtE4Lhv?=
 =?us-ascii?Q?uIVM1RNK7Dij3M+i+sJAgfI5UFcyx/CDnmzZ38yqBXj0j5UjUa1nH2TbBoel?=
 =?us-ascii?Q?VGxqGw60xeXjNEjgK4TSb85VvdKvkBWs1zcsz5O+zP8dZ67WhyGxPRoYaKZ5?=
 =?us-ascii?Q?Gd0Bxj4VkvueOesY13vVh78gqQTslDT9vPM83kCj9ZqxHaqXaB1Z+ITrNgh4?=
 =?us-ascii?Q?0SA/CCLU/pJQ+cJ0YDN7OOUwC1XVDYrrsGIXptd/An0/HVJhAyg+7i2gX2b2?=
 =?us-ascii?Q?7HYfl4aQv5U4iTWvuux1Yg47KOEZ+3Usb0I0dPMRciitxEvMY5eIRooqQuLF?=
 =?us-ascii?Q?tOHQJxIY7PeeXSCwfHHxAIHonTm0dfpcUF5b4nv2fZP8nV5hFByugjLCKbcj?=
 =?us-ascii?Q?vC5TcbG03lhWW7ABz951GQKbwQ4Hs2VxzBNuDFCMfxwIqQFEdGcI1mI0nAHq?=
 =?us-ascii?Q?ELR6nUrOKAPRHO4kFN0Au3Q+DbtVOqgD+bf98RQDi3yNg2kGtPE8kjlRiyP3?=
 =?us-ascii?Q?xVQnyjy27rg8iHMgSGaDFh3gD1F5gmiuhsqqHwh5QB1rbGwRi00kTIYtYPKN?=
 =?us-ascii?Q?yUAxbh15s0dd7dltDGs+sHznplmu+Pc7ABfpcPixls85gNaeNTnmzAbDxj/N?=
 =?us-ascii?Q?V3Qjx+wyQ+ak9HBpNlb6ShGEWfJZ0AS7Q/Pc5PY4vOchptbyXNBV8tbCzro+?=
 =?us-ascii?Q?Yg1AM9A7tvjg1IBsUVi61NA2kk8=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a821084d-5623-4fec-1f75-08d99a467916
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 19:09:32.3499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJXYzkwLT+pmY1rsXb+U0zdL2nQi57x+9WChekRoFlN5uhcrJSNBzhaCCY+ZoHS+IBHdE02l97RyMXvpYiFDXpOMRSWMqlRb1ELmx8klbBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3210
X-Proofpoint-GUID: J78-WEt4vY-l_iDHhOfCZADMJzAW4Ee-
X-Proofpoint-ORIG-GUID: J78-WEt4vY-l_iDHhOfCZADMJzAW4Ee-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_05,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=453 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110280101
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commits are needed to fix CVE-2021-20322:
ipv4:
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6457378fe796815c973f631a1904e147d6ee33b1
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=67d6d681e15b578c1725bad8ad079e05d1c48a8e

ipv6:
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4785305c05b25a242e5314cc821f54ade4c18810
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a00df2caffed3883c341d5685f830434312e4a43

Commit [2] is already present in 4.19 stable, so backport the
remaining three fixes with minor context adjustments.

Eric Dumazet (3):
  ipv4: use siphash instead of Jenkins in fnhe_hashfun()
  ipv6: use siphash in rt6_exception_hash()
  ipv6: make exception cache less predictible

 net/ipv4/route.c | 12 ++++++------
 net/ipv6/route.c | 25 ++++++++++++++++++-------
 2 files changed, 24 insertions(+), 13 deletions(-)

-- 
2.25.1

