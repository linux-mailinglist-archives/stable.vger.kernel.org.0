Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268A3502D8F
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 18:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348085AbiDOQRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 12:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355758AbiDOQRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 12:17:12 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2D41D0C1
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:39 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FG1FUS001455
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=tdBePY1+PoIZ4Bn2f/i/Ab3ZBiFEh7OEEa4MEd19rSg=;
 b=q87dV0xXs0UqvSIcXC/bIauBirqYeE28QypFgza9gbwjg53XAn0AgZ/O5VYf/FLUUsKL
 iZs9rv/eFL5B0uTcRBKyCODU//dx4wjuVPNp/d4fC2aiWPxp6mmqND8qzXxEvktEbfBQ
 omdamSKH7fLTjNe/6jytN2+MPKAUYEij3XucbqSAoqbG5oiIYsgdygpaB/pccI8Eu3Ta
 Rk0gKeTHJKa76yaZB57N/ojU3kfAjdN314FKI6a50aGSpLmQoOUP/eV9v8p4bK6J7SQP
 NvmOvwzSdWc6CWtdZI/i6qFCPFxzUk2zShuPJoLzaRsHK4lDD9Rnw7fmxWpr2VogM5IS xQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fc0jec5h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSQfPS78raO+y00vLdjGlZabQLPBb+U7dZ3jZMD8AZH4V4/4n40TCk51jF9rvAnDIsrD5xxytNl7AYdTsZhM98vTLE1eSJUVEzGUVPMNMF4bJjBSe8m6XGv+dmrYzW1LZemMfQHz9Gi6uh39unEsho0iE1IL9E+v2ItKMO6SWRBwuUBNjRqLcCBqpqSoqOslSyLkt//zyQn/R2BbV8vjjaTHeKVRQ3OmsIvak5hMIUJZavohtA3/3I5JEY9qJLUC9UtbKc6eSt9Eyxq8gx94c2WX318Txrxlg0pLeLk6cZ2hEk8XlMBmveAXIL5oamdVfYajGT0Zx7ACTWs1v5USdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdBePY1+PoIZ4Bn2f/i/Ab3ZBiFEh7OEEa4MEd19rSg=;
 b=kt8dQHDzSg7erA9JOpyjcDfGftOd0F1epZtOkIaipHgrRFZn0WP1txyg2lUstVNea+wOfQ4jFCqixD7AzFrpKLpeu89K1Hefis6ickE+pVVSHn3w2uZTT50R4A8js1HfvWyatdgkCOTGGpVc8D5V46mBRMyoSs2EaA40AcVyIUtInlsf6K3Gan1ImMHMPLiZlCvtYDLtti7Tw6yZCbVGb9QK7nJKngjYRACplIDcOqtmcYnX3d2dh5Zs42I+m0uim42E6J6gqWESH007Y9NoSxJk2k1FzhBZEc8w+m2zFYof1tVeuBzrpIX08hsHI1nIs6yrj0PJyQCunfmN5oOuYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3626.namprd11.prod.outlook.com (2603:10b6:5:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 16:14:37 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 16:14:37 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15 0/8] ax25: fixes for CVE-2022-1199/CVE-2022-1204/CVE-2022-1205
Date:   Fri, 15 Apr 2022 19:14:14 +0300
Message-Id: <20220415161422.1016735-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0009.eurprd02.prod.outlook.com
 (2603:10a6:803:14::22) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6287cd44-9a42-4735-c755-08da1efb0972
X-MS-TrafficTypeDiagnostic: DM6PR11MB3626:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB3626C9ADD7205021E4E46A54FEEE9@DM6PR11MB3626.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7VM1wlpCsjJHMwChjLqje3J//+KbdBhZZsO4c8JTWG3OHs7SqQs5SPMOD8hdZ7iDj+tCJGk1xxKwUabjGJE4Teygnj0dkfgqG1UD3Ykyb4QtDRz4tP0WZ1yOV8XX48T9rRGIDAfqBgIz2TRWnbKZ6Z8FALlWjO3UEPjpMZ6ImVWNRrOVAKF/zQ5lvBy9N8/HpAjY8J3Eq7cwyIQEAzJA4T+r5FmUm8BEXaFWKH3r3bSMywQj3zBvefhnXfV+OTglvSBsTNSXWa7eLqkYx0uR8SYYcKvRk5hlt798hI5KqJ4ZuBChls/39NBu/40JPpjQTr+EOnm+OFLtfNeh7w0aPX0hwM7iwGafxIZ1qxrmrsQ0hC03ktRTXKBz3VigGWH/9SWsUvb8WFMwev2p1N5Bwo+6F3rFPxM5553Nh82aiiQyeULkQEnDbkWPtzTl0my5lhN5UOSNL6yqYuokqNC3tVMPLp1oiMUIA1PxwF6OlrUhwVfZy0JUqSO6hhs16XwKb1BvnsR65gH0phLL6FFQJws5ubZOX+ojZUdNwl99exIFzMqjW9HOQlWcI8RI0RWsECesEWB9BetPEuDcCv8nfSUNeLsdYS+HylL1VxeRVUW+kmhfe+HTkopqaWJzilyt2Do38hi18K7Lvhgx1U0H6/XUtmJiAcx/mVhjryLs1l7KhJhPOt/ZyXLV4kki4KoInRF6XRQVL9Fcm/56rkqR0AGb/2TebsOFO+5+3G23R7WeLi+MKAE1USvFHSRqNvIzAaHDIXtOD46tEsPSpPZUFNCfDCuORWe0cCjOrKYUW2RSbQmpm6TIxP8h26pP8C/b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(8936002)(38350700002)(1076003)(6506007)(26005)(186003)(2616005)(6916009)(52116002)(6666004)(508600001)(6486002)(6512007)(966005)(316002)(66556008)(66476007)(66946007)(8676002)(83380400001)(36756003)(2906002)(44832011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CRqNF4Vd1ZXeVGFRKxYfVeXY2YwmPv+QmBguyRl4KzlAPaTNjRzh6Pi96PS9?=
 =?us-ascii?Q?GVA6Ulj21tv3RD58iVBDCeXLNrJeNbc7fgmLeNxZhXlBpO8neEEQFksyCzMK?=
 =?us-ascii?Q?Lypwe6Y28ZxmPyA6iDJz8QDu+7iuijsJQu6GsVEQZMRuvoxOYGbtgA9yJQ9N?=
 =?us-ascii?Q?3lI1nzm23e9NvdG0glXbGmQEzRV1Ex/43qcdMV4TtK6vLxqpOT3E7lma2X7i?=
 =?us-ascii?Q?LFjk4cRBkdg3zjgvLCALnpW8rjyNxrpHWpjm6+toDDl+KVmBYQdIyHwpxOid?=
 =?us-ascii?Q?A0JCjcAu7K1BzHw8gDZvAlO0o2XhnS3IS3feMmI7ppa9Yrmqnr60yL0H9Ecq?=
 =?us-ascii?Q?/F1w1ivV3g327lAmWCVYmRt/gNRW3cPpzE2ZRQi3vp5Vf2QQuDu3m1EzmXoU?=
 =?us-ascii?Q?QbCmqZmDc39ZZSBUD/dCZLJSpWTCK5GKTXJOeeV81B0ybaSHD+xZ7DTYpcC3?=
 =?us-ascii?Q?I7D/bUd0g7Q4xls+nTo08PqDmOembNRb6vuCaup4wgB8YB60pqpseMz7MKZf?=
 =?us-ascii?Q?EmYWtF7D6tDfeW+pqUz/MnnjtezhhMbx4y+AJC+SyiQnH+QWaZtF7H4V/vVp?=
 =?us-ascii?Q?Z8fghAmggtVicQsYZFu8Vou68qQFK67SaOTa0d8MB+EQE2AiYcgyExfzOHsV?=
 =?us-ascii?Q?ML1ASwOrpDk98/3weHOOZ8xOO1zSt8WtbaU1LB2UU1DVFlnjM8RteRZ2K54S?=
 =?us-ascii?Q?UeOwQhCQIL6p817NiTWkXNo3ROD+O2eAm5YBa2gnIYWeq9ujhe3zW9trwkNI?=
 =?us-ascii?Q?/VYEOIiu9Rm2wnOGk2mduh4QnXy8dCB5xqe3eJs7ZkcUSzTTOHPmlpywnN79?=
 =?us-ascii?Q?07NNeZQhRWzKb38zEWDMXWsA1DNoSSIHgiK71HX5KtwNMMJY6QpfxYHBhiIp?=
 =?us-ascii?Q?qq/JnrV1f2MIpWubbQO+GwmFdwbowWZ3/uLa+OpaQiySCzutTi8/rfuolJtL?=
 =?us-ascii?Q?Cy6Ix05p/1gJmcJ+C2hR0AQxwAtn+AqmTcFE1cQegyfaHPqI+Ns6+dLv19cj?=
 =?us-ascii?Q?Ce7wTmlW1Mvsuh8YGwNHgxismZOGHn96huH6GGHxOVCCPJHJr9kKJnTU9JeU?=
 =?us-ascii?Q?lakusiLIy1jnnzdp1lNvCDcB+F2wZFoX2LMsi8slBfPdxmYhJ0aVcA51TAK4?=
 =?us-ascii?Q?KUr6B83OoMAvdTNKC6cF1W+Y8SQNrusT/L6S0QaQs9KRmyMQjk0nVLYgAxin?=
 =?us-ascii?Q?lj5lfgLaJCKu+GH4XnkrQqEuvTgNO6RAF2DjE8lFVcOKUYC5+Ggp9yevqeA7?=
 =?us-ascii?Q?A64839vHacXvYMb/IyudVT6dIyRqmmJn++5sjfh6VcAY6+SUgNH9pYs2HE2t?=
 =?us-ascii?Q?Y8m7qF/fJk+cdog3TgJR+lK4mvsZROTlZq+ui0087t9PMsLYaRw9fMjsY9FC?=
 =?us-ascii?Q?/jPnueVRCAM0bTlhmfv9rNxjvb8JpHSQKQyxE4gym3c2xO/+OliTPPa6ksPs?=
 =?us-ascii?Q?fmjOa++Jkyxbb7lr0x1ftiojOmLMmFH6dSknUDFyjtsViPKE8Rc8kpygh+ht?=
 =?us-ascii?Q?JwhqbV4ck1lH5H5aKEor24Wx8RH+7/Vxvz9HNZSn0+9Pg3UEefyWTrt1ufMz?=
 =?us-ascii?Q?xEU4J/6cQkXG/JtlNxe7AaRqFUKEhTU9rK0aCImuC0u+losiDwdGt3C0foWH?=
 =?us-ascii?Q?st8POQdlOC9ybe9DJu7TOO+WcVfDlzdUXwKNKaXiBkBcO0JepIQ6D2LEKQAr?=
 =?us-ascii?Q?xDGVs9WGHxOA4mRvPa7uL51XBRgRkQi1ZyAyaaIARRUAIMOWnYM84oMyR9jX?=
 =?us-ascii?Q?Va5VHlJyXW9A3eCzG43L2c2Jx55upes=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6287cd44-9a42-4735-c755-08da1efb0972
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 16:14:37.2675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TxzuhPN10N0WAbOe0wI/0wVruDZVE7omRdQaxQNIozYUnlgIETYr4qAWKpNKQJ2kdC6H7RrSTVAvFNxVB94VgB3YAjahZLu3q9fR+cCVl+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3626
X-Proofpoint-ORIG-GUID: xA0owWextHMfwVuKxFnBr_aM5h2KLDyo
X-Proofpoint-GUID: xA0owWextHMfwVuKxFnBr_aM5h2KLDyo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=426
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150092
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CVE-2022-1199
--------------
Reference: https://www.openwall.com/lists/oss-security/2022/04/02/5

Upstream fixes:
[1] https://github.com/torvalds/linux/commit/4e0f718daf97d47cf7dec122da1be970f145c809
[2] https://github.com/torvalds/linux/commit/7ec02f5ac8a5be5a3f20611731243dc5e1d9ba10
[3] https://github.com/torvalds/linux/commit/71171ac8eb34ce7fe6b3267dce27c313ab3cb3ac

Commits [1] and [3] are already present in 5.15-stable, this patchset includes
the backport for [2].

CVE-2022-1204
-------------
Reference: https://www.openwall.com/lists/oss-security/2022/04/02/2

Upstream fixes:
https://github.com/torvalds/linux/commit/d01ffb9eee4af165d83b08dd73ebdf9fe94a519b
https://github.com/torvalds/linux/commit/87563a043cef044fed5db7967a75741cc16ad2b1
https://github.com/torvalds/linux/commit/feef318c855a361a1eccd880f33e88c460eb63b4
https://github.com/torvalds/linux/commit/9fd75b66b8f68498454d685dc4ba13192ae069b0
https://github.com/torvalds/linux/commit/5352a761308397a0e6250fdc629bb3f615b94747

CVE-2022-1205
-------------
Reference: https://www.openwall.com/lists/oss-security/2022/04/02/4

Upstream fixes:
https://github.com/torvalds/linux/commit/fc6d01ff9ef03b66d4a3a23b46fc3c3d8cf92009
https://github.com/torvalds/linux/commit/82e31755e55fbcea6a9dfaae5fe4860ade17cbc0

Minor contextual adjustments were done for all backports and also
dev_put_track()/dev_hold_track() calls were replaced with dev_put()/dev_hold().

Duoming Zhou (8):
  ax25: add refcount in ax25_dev to avoid UAF bugs
  ax25: fix reference count leaks of ax25_dev
  ax25: fix UAF bugs of net_device caused by rebinding operation
  ax25: Fix refcount leaks caused by ax25_cb_del()
  ax25: fix UAF bug in ax25_send_control()
  ax25: fix NPD bug in ax25_disconnect
  ax25: Fix NULL pointer dereferences in ax25 timers
  ax25: Fix UAF bugs in ax25 timers

 include/net/ax25.h    | 12 ++++++++++++
 net/ax25/af_ax25.c    | 38 ++++++++++++++++++++++++++++++--------
 net/ax25/ax25_dev.c   | 28 +++++++++++++++++++++++-----
 net/ax25/ax25_route.c | 13 +++++++++++--
 net/ax25/ax25_subr.c  | 20 ++++++++++++++------
 5 files changed, 90 insertions(+), 21 deletions(-)

-- 
2.25.1

