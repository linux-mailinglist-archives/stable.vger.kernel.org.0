Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B4F402986
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 15:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344579AbhIGNUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 09:20:02 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:4232 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243976AbhIGNUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 09:20:00 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 187CCRLA018662;
        Tue, 7 Sep 2021 13:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=2YbFSjcbRqT0Ms5AKp8sZrUgbuitXDunjq0Gt/WMmeM=;
 b=hn/ygy8Rn8GPU4z9PJxxrjyPDO3X5Tcm4+FB9WR729htTMnk62yyZ0re0TWXDSHD+6Ka
 2VmMd7OhWWj4sLk5vyATWNsegIVZRyDYRa79Bm3tPExTgUg6GtRo3W9NhzX/qT6EB+qE
 IbOGfvwr6MAMx0rPlDRMO5YU6/8VDiQpyDc4XaJKs7V6S+390bg301vLv9RtFZFWPALN
 ++DDad3qhyPELrdSXT567xoXjeVDPuxCHKFSFOxd5zWIyP+sVVCA1fAQsn9n/mmZIQjQ
 5WoUW+yNgb5+1s68swNtD2c2JP47IkpYR2WYvczMN/Vdu+5oaMKrrtQGwzeyZOg3jHqL sg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0064b401.pphosted.com with ESMTP id 3awjhygq68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 13:18:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gb3M95oh5/kQuOBBAL5uEVNXmFdVPoyhlyJ7sS1v4ieN269OtqzB4JZ5QEyJuzvYMgWLR9WXl2lCVdfW/iPnp8YQ53ub1hxZABLdLGyZcKRdOpUKQ0F5EfLNkUzZxYMdB0/ssmrIbOKywSq7bsIDn/a2rNv8mSDQXhXXaLrIwkO/NqCPV7I78LjfCZBQPCI2SznNPXZ4SFdLttliY2NZalsMlAhlJxp4y2nTlv0nF91DG7wTNWOje6cl7PPQXg+dQDNAxM2yJ4L6pcLXGvfrNnQ0bj9Ub4/0UePtllP3cUnOlW1EceVNGXcf93iMCoe8gL3ibr7JhZ5tc6faHySWng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=2YbFSjcbRqT0Ms5AKp8sZrUgbuitXDunjq0Gt/WMmeM=;
 b=XOtE4cpVKXGzXGoHykuS3APGdbH1b5YcS28jj8kVoxAe1OosfuM0p2U/XfIaMX65PO6QytpCIbPN233hX3+oddpK6zd5+4ouByhZn48IBlR6TM3FiZnunN7GD8Jd74dKSXC3YQrXpAr/07Wc9oWpEzKJOZIQraiLfKR9yO6YnrRCKn45GLqhwHLk39b/sr1RueNWzc5AwlaPj4353+8i3+AYadEJsqq4h0+wto+u9AHo1jNtEyRESZOKcnsZJPyXVv3cWOR12QOZ5YPACKp5eO8uKCLQZt5iPPijK99B8dP+CmUHzHOVxaLYfvST6jkeUODSAa48lm+mzNZgrl0xGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3114.namprd11.prod.outlook.com (2603:10b6:5:6d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Tue, 7 Sep
 2021 13:18:35 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%6]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 13:18:35 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 5.4 0/4] bpf: backport fixes for CVE-2021-34556/CVE-2021-35477
Date:   Tue,  7 Sep 2021 16:16:57 +0300
Message-Id: <20210907131701.1910024-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0181.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::29) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0181.eurprd07.prod.outlook.com (2603:10a6:802:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.6 via Frontend Transport; Tue, 7 Sep 2021 13:18:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b5eb538-d4fd-468a-601f-08d97201ff2a
X-MS-TrafficTypeDiagnostic: DM6PR11MB3114:
X-Microsoft-Antispam-PRVS: <DM6PR11MB3114F44BEC41E3C62887D3F1FED39@DM6PR11MB3114.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kNMyjyA/Y9OjIP4RjTLMWC1z+wkHyXyC2ibi/mpJ6cgAjp+BCo0QPPtHY6Ftd+UiMz/fnxLFA8AAE2p7CPrd06+2htmeQWnD8BqlWhfB/SQxsy4KPVOO8eu2/WN0Hbw6gdkw039lAQV3K0jKEAXJsw825aK4x1EeWedFO09ycQL7o2Nkr1VqShBhBs0qCPmhx/axTeMiK2yWrW2GgiGTkgojHi7/htwaHZGx8AgTXxbr3ib2iasKDCzNE5KeiAq0WCVqQHjgGzG3ZUC/wJaZgLpoE6JptWxSYn8JCqv6sTzFrIoa6cp3I530Guve80pHrmOn+8HBS7irfUOMkXDrvkoZjk3G/mBMJ7A7cMNapIgHxNJ+vsXE36mqT9mWPN3//U0xvJv+FpIA2tG4KC75ph2Z1WH07tBiXBK1aFCwXe3Ok6VyTgcNzmnJUbEohsYjednGC20NxtjGGuzBsB3FwftCFH+03shfuKfhYJozfkR27H4extzy/0ELb0bM+XO/NOEZ6AYCwzXVScJUWSBViytHGt31cToE3/EpURsqxxE8UiBVXXWa4fNc/4XHxdUTM/HCPKhLXhpFqVMgfHTtUyGzHUMYyHDu6xH0LC3K1rHHOaQZmqr5Z5AJ9bjZi72canrlZ4YILwkgKqnxNzt3ZKsSN+w7LcJhEjov4jKzBBJ5ENRzGgrVfBANaquoUfdxq2fdF1ro4F2QCWtLBU6jXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(136003)(376002)(39850400004)(8936002)(83380400001)(38100700002)(6916009)(186003)(4326008)(36756003)(38350700002)(86362001)(2906002)(956004)(26005)(6666004)(2616005)(8676002)(66476007)(1076003)(66556008)(44832011)(6506007)(6512007)(52116002)(6486002)(478600001)(66946007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9cZBZf1kw2eOLl2lSB203P2vQrPBWk17wrUTJwN6PZ4nB9TJR9cdbkvYhlUO?=
 =?us-ascii?Q?Kx1kVIKxFyf/uitR22f3LIees9Tf0NumcdGoo4X4UP31i4ZxBabP+4wwmd0S?=
 =?us-ascii?Q?fU4l96Y2VgEhXYKDQSdu7+taS8O/5DxiU3vNMY/CqH16Ti4JFmluDIo1Nbwt?=
 =?us-ascii?Q?WOttwLSfV+RpBUdZ8vbNwimI0aX71T8QGCW7IFgKcsZdhirovF646aggvPAm?=
 =?us-ascii?Q?fDRRCNuZzvPt3/fAdcuHPFQzmk/PriJV91In4D/4qRSvJ+0DRGFLowm/Swsc?=
 =?us-ascii?Q?vbYu1DzgEiEBYk1NwEPYMkAXWoipyfbmujHziakzMCPpEumNdskdEfioYTlF?=
 =?us-ascii?Q?oaioGPSxdw8THEpVbmeSW3gLG1YW6nos6/UbA8HoUa77dOWeb+hVUgumyFXA?=
 =?us-ascii?Q?vzg322d2MBHJndqPIhbzRi999RBmmdwGJOODBwiDL/pF5knNUB2sjZsid2Ns?=
 =?us-ascii?Q?kV41m00x8yW2yyHWqjyaOofBCWXjwz8mOCfcO9mnqzfi6ibFlw4kDCXL8uM3?=
 =?us-ascii?Q?y9wbdes1PNbckIkYrqBkhyvjBFX95nTWo5bhimABnaYAJMDtF59MGT6WvhJE?=
 =?us-ascii?Q?cC9LkqEIEiaMdvWL3UcWf1BbOPhOMwDSKYPnYf1697EnrXX/OnYfDMdxUrCz?=
 =?us-ascii?Q?LFZcmXcy//UlQxbiT7MQskPpbMOKNVRJOG+BGY9hMYYPr33rEAXPpC1TtOEw?=
 =?us-ascii?Q?I8xZMWG0qgIRO5W7qY7eQCIf8y8dqp5hOeohy/Pj5yj8Gp9O2U5w6e8qN1r8?=
 =?us-ascii?Q?iYA0kCaorivyxSTBl+SuLsNBvmUfpxAufqpLL0KWug4/mtl03OST6Tle9W09?=
 =?us-ascii?Q?EYcvH2aLvsVvwcpDk4JjeYNExex/3eGbLr33TO5bYwp5B3TpQww5+1bZyM4a?=
 =?us-ascii?Q?vEEjJZMwkR8zyA5wzm6U6he4ee/dbvScjXBa4dkcKOvTIZhMVdQE7hEG4dMj?=
 =?us-ascii?Q?t5alzM1NkTBOhrYBdrinfffrgu383jxuqnBv384OumAngJpaidEVn2qKGWCI?=
 =?us-ascii?Q?2gk/9QJWMJzk2j5Acr2gQuMRXXOl2olHUQRMNXXNG8azf0s6mrihGmVSJNeZ?=
 =?us-ascii?Q?rXHMDI+x+BHIFRrUqYFZw/AMT2Y80akvUi7gWtNaBLpKvns0LiFGLdAbn+yY?=
 =?us-ascii?Q?WzCJeTn7q8pWPtgekyo5DxLNJ1E3DMtD5dE6rO61zQuBAihm+toMCFtLAwta?=
 =?us-ascii?Q?fL5yFcMPE0GGFHezHDgDk0hzDstiRRJ0DUXfSUzcO/5Eg1ooo8UoGjC9Wys4?=
 =?us-ascii?Q?VqD/P5nBEVaUJYtsnxo2fwVqQkUCfpPRRbBEAD0rUHsQIn5i7Lk5LbxaQ7fP?=
 =?us-ascii?Q?z6cAr8mpdBqTOTB9rUocIGpb?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5eb538-d4fd-468a-601f-08d97201ff2a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 13:18:35.6612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9UuDU/WTxHU90S3jnXBg59NKPdazI7l2u7vprmHJI2tuLwvUDpSEBM2lQQG71XM7YT16klU8HwNyiipP+GL11KrKr0ffkSwpjmFMGg0d0O0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3114
X-Proofpoint-GUID: DO4lkmoCcsllStUrgR50U2bRqPyMoVjV
X-Proofpoint-ORIG-GUID: DO4lkmoCcsllStUrgR50U2bRqPyMoVjV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-07_04,2021-09-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 mlxlogscore=909
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070088
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With this patchseries all bpf verifier selftests pass (tested in qemu for x86_64):
root@intel-x86-64:~# ./test_verifier
...
#1057/p XDP pkt read, pkt_meta' <= pkt_data, bad access 1 OK
#1058/p XDP pkt read, pkt_meta' <= pkt_data, bad access 2 OK
#1059/p XDP pkt read, pkt_data <= pkt_meta', good access OK
#1060/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 OK
#1061/p XDP pkt read, pkt_data <= pkt_meta', bad access 2 OK
Summary: 1571 PASSED, 0 SKIPPED, 0 FAILED

Daniel Borkmann (3):
  bpf: Introduce BPF nospec instruction for mitigating Spectre v4
  bpf: Fix leakage due to insufficient speculative store bypass
    mitigation
  bpf: Fix pointer arithmetic mask tightening under state pruning

Lorenz Bauer (1):
  bpf: verifier: Allocate idmap scratch in verifier env

 arch/arm/net/bpf_jit_32.c         |   3 +
 arch/arm64/net/bpf_jit_comp.c     |  13 +++
 arch/mips/net/ebpf_jit.c          |   3 +
 arch/powerpc/net/bpf_jit_comp64.c |   6 ++
 arch/riscv/net/bpf_jit_comp.c     |   4 +
 arch/s390/net/bpf_jit_comp.c      |   5 +
 arch/sparc/net/bpf_jit_comp_64.c  |   3 +
 arch/x86/net/bpf_jit_comp.c       |   7 ++
 arch/x86/net/bpf_jit_comp32.c     |   6 ++
 include/linux/bpf_verifier.h      |  11 ++-
 include/linux/filter.h            |  15 +++
 kernel/bpf/core.c                 |  18 +++-
 kernel/bpf/disasm.c               |  16 ++--
 kernel/bpf/verifier.c             | 152 ++++++++++++------------------
 14 files changed, 161 insertions(+), 101 deletions(-)

-- 
2.25.1

