Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E063E18CC
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 17:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242611AbhHEPyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 11:54:45 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:2698 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235472AbhHEPyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 11:54:44 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 175DxKEo010741;
        Thu, 5 Aug 2021 08:54:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=nB5ZhNFsOGKwn9pCRszEj1tFcgM5Djg6QhZY5ZLVbwk=;
 b=DeizE5TEuwJ1sNsNNrA7e6YVjmRw1jcD1KGH2bcp4EW6wMndX4w4GKVy1UPS6XS914tJ
 YTqAc3goN2ZHRvqRqUPSZqQCe6QjaaJejcl/52IF+88sX5u8Bk7MMCZS77m3RbkLdzm1
 uoSIVpk2EiHdVexQ7gD9govY7OT7np5PdXuGJggScbFUoRIyhVzd4Re/CJpX6anijXqN
 FmAOCrRyyznJ4QGWHb65ig0ra9T2uSBSd6hkYHA2MnSBAQFzYxo5AjY6XnCTDbat1pj0
 baWO5gqt4OpopcRNUmpXlz2HL/YJvlTuPWVNyxAskVbk/2vjwYo/5GjZK+maGAUzSht+ rw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a800vrrb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 08:54:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkI2JfG8ju8F8C17vHjhO7IbL+QW5NZrN5ASyAfBs14yZiCUYEyGGGFtYQwmIWwkTIXuwsM5wT3ID5sNaddwrlQzNtZ5125VQ0Nty46jQ+eobeTiFgV+u/lVVhf04EQUaQAshVx6BqCBKMH5izLDTBkPlVDVT9Cyj2jMmetKMOfQQheLCscL01NWXKoYo56HYIshMwZ6aj71pKdevv4dOtjkvfMAArWp3qu2P1imM6dBxqPHKPQ3wH4MPOXS2+4BLo57btOZBX32AVFVDwYGM5hRx5s2DY+Bq3ygGEiWoIFKJ0VeCOgIEAd2WYawzA/eF4ZmJHGYYNJ2gByWb+ly9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nB5ZhNFsOGKwn9pCRszEj1tFcgM5Djg6QhZY5ZLVbwk=;
 b=IKZmXh9dVwNr3lWGhopaXR+cjYkIqWG+QHj2JksgImo2bpcFfRIHReiCXkK0ASd1HiE9VwPPMsrKctt7mzIhchxi0MzSGfc0VZ8pebZJg3WzT3Mns5HCLg1jt6ZYup9nt3UJPIkydub/X+BW7wabyeBsI3b4ZUK/wKoh96rFpbjWJnQRls/jVACunfnxTnG56egaR4uQ+YQH+wz24v8ZycXphFECNNw8R1RgzrIWLgpZLA5Ygai7p4GL4W/0SeoSQtKA6HAr34nLQV59S2jqu0L0vazmFjtjAuROrNcZ4jhn8Rx64zhnpvJxzOChGv3jDklHbDAa/9z63uT2M5TwLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1722.namprd11.prod.outlook.com (2603:10b6:3:f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.15; Thu, 5 Aug 2021 15:54:01 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:54:01 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, benedict.schlueter@rub.de,
        piotras@gmail.com
Subject: [PATCH 5.4 0/6] bpf: backport fixes for CVE-2021-33624
Date:   Thu,  5 Aug 2021 18:53:37 +0300
Message-Id: <20210805155343.3618696-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0002.eurprd05.prod.outlook.com
 (2603:10a6:800:92::12) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0501CA0002.eurprd05.prod.outlook.com (2603:10a6:800:92::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 15:53:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba6285fc-8a43-46b1-49fc-08d958293e70
X-MS-TrafficTypeDiagnostic: DM5PR11MB1722:
X-Microsoft-Antispam-PRVS: <DM5PR11MB1722E22B1D9A05B5DA7C947AFEF29@DM5PR11MB1722.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lY48jZP2vjVDQ/loFW4jgZlKm3VBl2LdF9MzmuZ+hAFQIK6D/eDwx0aEFTrQJdJkhJi3bKnZU3BHXeBKLFs2eeEBM3UmsIGhiktKsfMEOaxmdBx19k1osB2zy6qxO0oVrD1SIhGiYImS3+14Ix0AwNaG8MQPEQJA81Y9YtdQlENwZRkO8peW8pRkl/Z/HbauaxOz/gYZbOH486CHC4m/sOpjLbypfzVqWsv1wh/B8BEa2qKns/vbhdDE870TdKppjxBJTAC0RpB0nxElJ8HgmpYoEAr4+xreXh27iBwgg7KXrEDknVCoBSEj/hqYOO0VY4rA6/NMn+WU8SdAFC12P+q4UiGBfoiF6v86XpCD49Vwzfr5JRf7Z0Mq72/o/Hu1ygil6SpR/4eiqOvRUTVctd3dzvR2iZQdNz430RcTNQshzd9WsX5R7vSeST7u1kjlJNMveYW+wfVIcaVAX5Z/Z+ra4D2xS4VRAgGDFZIzYb0EvRZyO2ZBld6Zou/LmQOhq9mxKR6xqfBMqp8rq3PX/E/FPsOaVlH0qWYRFhfYDE5LPUFk/ukvJIPspuRwRO/0MIGCC88sBvj6HXzBcSuH/Lp0KMt/jMJrikp2771uLXkfxgHo6g3TX/mGM1/NpBkVIQXJrXQjTbKsJsAUs2zyp9P5kJ+mUOO45OJcz8UjmbrQFV1upEFcOO6meJmZATZQRQTpBer7qgCl3J05A15XwIUYK/+QxZmbae1HE7Gb9gxKmktJL2TRQpDknipqrUnkus1ZqGdGH2uRMXWyXowE6IubSHoidtjH0LXNlc68wyU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(366004)(346002)(136003)(478600001)(6506007)(6486002)(956004)(36756003)(966005)(2616005)(186003)(38100700002)(1076003)(8676002)(5660300002)(38350700002)(316002)(6512007)(8936002)(6666004)(2906002)(52116002)(83380400001)(66946007)(44832011)(26005)(4326008)(6916009)(66476007)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L7LuHHwXzbETkFsyc/JqTvTYWJbKe3qgIjQ98QvQz8pBKiiJ2oOE42MnLbQU?=
 =?us-ascii?Q?u6NYCZORdRFQGaDdhFPVx/vul/tt7ZnaE4qOtw11SDCTmtBe/4YrA40g7VWp?=
 =?us-ascii?Q?SlUcizmrkHd/Un3GzGHyfR03yJoTejX57aoXbhhDuVVpgWujGs3tM4i14Ot1?=
 =?us-ascii?Q?zXKE6oSQFiUaa+kUalEXQadG2YmkkAb4R3A2VPEwNVIJN67GRRWMlHkCGtFg?=
 =?us-ascii?Q?rCwD+G5mEr1fiLer6XwbvNGV1863EINwMbtvZHIHZ+NQNxs14C3h/DJWQi/Y?=
 =?us-ascii?Q?MNQw1hfru0v21flEOH4XXY3Axf+5Sg2BmG/2wM1t8Fjl4QNYzgOLLan3A02F?=
 =?us-ascii?Q?16wO6UrAQ94xsKhQQ8SG8HVZTYq6w0VKe/jrhpoOoMnQ4RxLEsnvOHrb/Joj?=
 =?us-ascii?Q?DIHpHt+Os/X4AWdbPA000m0IXjl7M5S7faedeK165y1xVCP8/GWwC4AdMAK6?=
 =?us-ascii?Q?P02L1x1zlB3rZpGrQjmNjBuGmXuQP7ezjRA0zOjSbm1R2zueDkU2xCFPzK+p?=
 =?us-ascii?Q?qJ6jemNt+er/krUnoS6tBVpkjMhJyUUoOq0A4eBKK1LaDkkh4YRk4jfw5hBe?=
 =?us-ascii?Q?9d2l1k8JWtTlhu2metZBcqX0qs1Q4/eyScCWTYjK3uUmpypRmd8Cunrz/q2Y?=
 =?us-ascii?Q?O2ZBm95brWmXnfH/fRD5BfwPXmbq7DS38eAos5c9i4iDvz4qrElm5CptfBVJ?=
 =?us-ascii?Q?bq1cGn3ydIfBxmEqk+4sJt574reGpJKsM26V/XZl0jmIiJWafWdDLOC6k+Rj?=
 =?us-ascii?Q?wJekzQhEBuB7PkjrZlUX/NgPw5F3x4nd35kJPsh/BI3F5+qvjCYWSXaK7m9h?=
 =?us-ascii?Q?wLDUVJ1NqoEth0hQc7IAcIms5kit7ahVfL74NCqywlu3CFR9op6lGNN2hs+A?=
 =?us-ascii?Q?wZYEs2qyGHFJt3PCLjkn/fvjDMTxyujWo1p8txyRIqzg1tR+1rcHAxjmi21W?=
 =?us-ascii?Q?u4N8sgfOadRd0BGQaCgDmcFrXUoThtxZoAnQOwi5INgfNdWdjSZICpGfrOev?=
 =?us-ascii?Q?NhGWJDJaI/ohToxZk66v7034KYkriKnRznKCshhZlzW3glCQAottC82PRMkR?=
 =?us-ascii?Q?dJK9k859ynuUAd9bgL1GaYUyy3lKhW9H47ezKFRjQAM9NZFoSH3UGAIIZShx?=
 =?us-ascii?Q?y5OFLfg/t0tDoaTX4jd2PM2qVlEMFE+4EgqtReRU6z1SmvBwNoKMa/2NDAVN?=
 =?us-ascii?Q?1p12/E+s2oMEgnXVYKaSPU1BtXF242YYyimMbfZMJ7oZSlI672TTtWVWOlZP?=
 =?us-ascii?Q?RJXsxGJh07eLVVXyFmJJV8BYMIhXS1iIkKIHrwRfK5Msdkl2R0F7n4iOcW/C?=
 =?us-ascii?Q?pR61heDzgMLyk2SyKGpkoTKo?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba6285fc-8a43-46b1-49fc-08d958293e70
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 15:54:01.4991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4JiSZ6k7+VnGEf5q+ALxETcy5zoi5pHVLtUhoiOj6jdvV9GBqvv4vmBEZkvZX0o3VEuOYGRnXc2AZbemzv5aBerJwiZWo097swQ3qLW6xZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1722
X-Proofpoint-ORIG-GUID: zZAfSoH1X0ahZkyOLUPDmqrt7EGLNEnD
X-Proofpoint-GUID: zZAfSoH1X0ahZkyOLUPDmqrt7EGLNEnD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-05_05,2021-08-05_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=773
 spamscore=0 mlxscore=0 clxscore=1011 phishscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108050097
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

NOTE: the fixes were manually adjusted to apply to 5.4, so copying bpf@ to see
if there are any concerns.

With this patchseries (applied on top of [1], which was not merged yet), all
bpf verifier selftests pass:
root@intel-x86-64:~# ./test_verifier
...
#1056/p XDP pkt read, pkt_meta' <= pkt_data, good access OK
#1057/p XDP pkt read, pkt_meta' <= pkt_data, bad access 1 OK
#1058/p XDP pkt read, pkt_meta' <= pkt_data, bad access 2 OK
#1059/p XDP pkt read, pkt_data <= pkt_meta', good access OK
#1060/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 OK
#1061/p XDP pkt read, pkt_data <= pkt_meta', bad access 2 OK
Summary: 1571 PASSED, 0 SKIPPED, 0 FAILED

[1] https://lore.kernel.org/stable/20210804172001.3909228-2-ovidiu.panait@windriver.com/T/#u

Daniel Borkmann (4):
  bpf: Inherit expanded/patched seen count from old aux data
  bpf: Do not mark insn as seen under speculative path verification
  bpf: Fix leakage under speculation on mispredicted branches
  bpf, selftests: Adjust few selftest outcomes wrt unreachable code

John Fastabend (2):
  bpf: Test_verifier, add alu32 bounds tracking tests
  bpf, selftests: Add a verifier test for assigning 32bit reg states to
    64bit ones

 kernel/bpf/verifier.c                         | 65 +++++++++++++++++--
 tools/testing/selftests/bpf/test_verifier.c   |  2 +-
 tools/testing/selftests/bpf/verifier/bounds.c | 65 +++++++++++++++++++
 .../selftests/bpf/verifier/dead_code.c        |  2 +
 tools/testing/selftests/bpf/verifier/jmp32.c  | 22 +++++++
 tools/testing/selftests/bpf/verifier/jset.c   | 10 +--
 tools/testing/selftests/bpf/verifier/unpriv.c |  2 +
 .../selftests/bpf/verifier/value_ptr_arith.c  |  7 +-
 8 files changed, 160 insertions(+), 15 deletions(-)

-- 
2.25.1

