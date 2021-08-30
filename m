Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02CF3FBE88
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 23:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbhH3Vvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 17:51:39 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:35562 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238651AbhH3Vvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 17:51:38 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17ULTRJk028663;
        Mon, 30 Aug 2021 21:50:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Hrex4PC1LQg4AsLp0HQLoNArCjOpXv4T0B/GwwtKFss=;
 b=lvTy0Te0FthIL+4YyXGjHWXux5r6f63kaT6ni8FoneYegU6UaiLq/zPQ1H1EZ+2GD+HC
 pIcR3XsxIMeIHMpl7/CmU0fN63UM4k2GAsTuRAMI4FCq9gYqwAVt+k0Vxd9IbLVTVc0e
 9JI205iUmce/99pi0qQpuVl/qr5JUFT7fmpntrPwSja/BAJBqLrDPlu7IVu+1nkLSZXd
 AdW6J9UbQCzBHA/mLiPCpwFCxiJvQGJzvBFx3cAXiXh3bsY1WgyxwHHz2TWkIcgA1Uq1
 Ey0ZkFuB7ud6We2xKc/MtUrjJwRZNDXMiWGVcgYSoMg/Qr7YKDzpJ6PgzQjq9yrYsFSO Jg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Hrex4PC1LQg4AsLp0HQLoNArCjOpXv4T0B/GwwtKFss=;
 b=K8AAu9k1Y20A4/aqoeOizy3MqQhMdbLcmnC9f5Ijaj8nS1lfdp+lnp0CDmvA2qYAhasj
 Zba6i8dXZ+wSbKuNN92OIhS4hKEU8X2tE5IxplZsbbVjBhCQ2bvA3zITVaCxS36Cq6ad
 WThBFVCFBa2UI9Wybist577cwTt76Qz/3SZU4Ar4qGjOJQ48W/NbIjvozS/88O3wa6hT
 irosfQd5S9pga4zed3gDaYiiFFj9gy4izmIRveMaH3sHhoNcWkURK9PBAEZMtCM6aCbO
 gniCN5HZeTOA2RWhEgWpZ4CPmOpiU4N6TZ7BWj4fl1DgLl76rk2/yb6u42YCAyIbXN/4 Ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3arc1a2rnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Aug 2021 21:50:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17ULjhPa166226;
        Mon, 30 Aug 2021 21:50:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3030.oracle.com with ESMTP id 3aqb6cnf5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Aug 2021 21:50:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9cX9X2WXQHhqrG0BUTBO4+5adKF8pxo56OGj9C+LvxDuKxsi7KCP5wwQjlD6C7gOGQtWAdA4NbDIr82TeCcsjd73lL8pzDs8SsdwWsk+YqtZh4qN78Ez13VxfYKX5oco46Wvt3cEs58sDnWQTffTSWrCD4NW0tBycgYuGRbVlkvd/+hTJ0nyFhoUnQIuXJZFuhsqViW7GgWK7NJtVcutbOeq8ZSQ3pF/fsg0dA8aZ4hKAAG84LqJwYe/pProf6BSaF3DNp0OC2mbccuV6kqunZ/LY60b/7NlLHvv8wwO0U7ka+4Dmd18xUgCttnKkVdxyUAJsGvWig/D0dmiBjCpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hrex4PC1LQg4AsLp0HQLoNArCjOpXv4T0B/GwwtKFss=;
 b=dR/DKZNBYYMs6Toz7gxghF3jEg08BlAwclLUTmH1uz5+CVrqmLaRoSHR5j+zDVHsfftYweOGFNvemduP/Oas2iAnGytB8ynKBEs9EA8iw78ez/XfqfQBIiN7dNcFRRsU2FZ4OlkyxXNDokbTfYUCTrjMZp6SWw8iaKCeRFwXATZ2kzdQZnR+RLnI5lczBVdTsNl2VzHUBhwNt7Ap3/+t6n8I0FRwp91B8xIfPPosgbU6+Q/J/yLaUKuMoL9Pz9IwDQ3txgmSKt1RbBfkkLpXD9AWHsME2/GixGCC+n4y/4JQiw6HUvoNKAwMi1kJ8b8qbiW10SjZ4QmyTiYle36HJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hrex4PC1LQg4AsLp0HQLoNArCjOpXv4T0B/GwwtKFss=;
 b=E413ixAyLbDgi6IJveDIU+TGcBkZ+BCCSXVFfUXRcayLr4lnC3RFg9Gps+23Iio/kWTDxFossLILuu7G851HWHAHkhgIDh9tsSnN92bfardAfuyvFX2DkyOT6dc0QCrcTpYae0zopA6MfK/NRNJEoqoSPxxA6hg3aZVjNI092dw=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB3350.namprd10.prod.outlook.com (2603:10b6:a03:152::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Mon, 30 Aug
 2021 21:50:29 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a%7]) with mapi id 15.20.4415.023; Mon, 30 Aug 2021
 21:50:29 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Cc:     Mina Almasry <almasrymina@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Shakeel Butt <shakeelb@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Guillaume Morin <guillaume@morinfr.org>, stable@vger.kernel.org
Subject: [PATCH] hugetlb: fix hugetlb cgroup refcounting during vma split
Date:   Mon, 30 Aug 2021 14:50:15 -0700
Message-Id: <20210830215015.155224-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0307.namprd04.prod.outlook.com
 (2603:10b6:303:82::12) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from monkey.oracle.com (50.38.35.18) by MW4PR04CA0307.namprd04.prod.outlook.com (2603:10b6:303:82::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend Transport; Mon, 30 Aug 2021 21:50:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7bfc96a-67bf-41c5-4ec1-08d96c002ea6
X-MS-TrafficTypeDiagnostic: BYAPR10MB3350:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB335048321C1D949A51C7A092E2CB9@BYAPR10MB3350.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RtPr6qkg6tOGrXCir67DjY7uXyHoiyOYzraQSbmUzPCyCvUpgVyu8bzqDc91MJlNrJDUUWV7xPuEHKUC51566R2hI9jPPcESTO1AdLqnHyP/BgVrB/dMRShKq1fDsa3boH789FV8H6VObcrnrXqMs/CwVy+Cxd1Ueq6Ea+nRgWXOz7E64nAq3LUfZvrWC3Vbvf2/nxbAJfUXVmAhzgN3J62FphsAHwKbT5bjOEk/KBPWdTeJK/bWSM9PTA7MKsQvPW0ae6gkbb/tbtcFNfCZUt1gZCVHNs1nM1WmQCeEzY74D7lJYErBZ70Bxdh2XWxTIBIHTeo4ZHD6GFBAQ4FRspEsoH987uJ/6vkUeHJ4YRU1EscuiWaT1bGdsKHwetavR7WzupywFmQokGKJQFEhwK7+nV74fklvya5vNZsYXxdB1Nl7/9Yp0CY3iBoFq8Tz6cQQi6U6PqiDIYMR1Rboaj/ie/COsmkoJHlrHxulnIOM9KDhCuVcIOoHr9uGX/sJirNRsWNM9G0EnRVS1ssj+49wARjRhRaforaqYxiSFflW7xxQpvWjRl39hdz27IMIRbFZ/oKKI1uyW4mUuMi5Z06K9WOffLCObtTi+eBTjWCn99tcPEzX6x0vKiGBdP+966d1Ji/rdWXgk7oJ4E4ZP5OKrh7SV6hOa5Qywn8VvY5RKkbFcYceoieQEQ5Un7EZZNn3TMz3otpTErX+4k6lTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39860400002)(4326008)(316002)(1076003)(478600001)(2616005)(66946007)(36756003)(66556008)(956004)(66476007)(186003)(26005)(8676002)(83380400001)(52116002)(7416002)(6486002)(2906002)(7696005)(38350700002)(86362001)(38100700002)(44832011)(8936002)(5660300002)(54906003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cuuewYG4fFRUEMjfG6lhAqDDL6d4LZ6fqKekM2AI0LXDtQSe22qlLTd6ydzb?=
 =?us-ascii?Q?eJ/mtch6qStasqA9vSgDrWAgNpjjupiedz0YSgMCHiuk0WHTsrzWeqnYwFw3?=
 =?us-ascii?Q?mtEiiSthBA0jorelAa+vS+wDGGDNyf/mYu6QRDwXn7nnRlRd/Xk42H+8Hv0u?=
 =?us-ascii?Q?ETg85KaGzb8FV5nCLNDA3vs/B1Ejzz0Bti0xvdZVCwTI/zxGu3qcO5DmIuCV?=
 =?us-ascii?Q?XumMMb3TLtKP/5IrkC5XKlY1hh8FFogc9n0G9+Wuj5lbW0cqQd4kYEFOAJ2G?=
 =?us-ascii?Q?5sM6JTxYy9+TBR3dX2+Zr0ptUSR+dW8Xo4SeMHsEtFB0B6jVcXg73Mk2y907?=
 =?us-ascii?Q?WYxdyA7hqRro+d/KdG+v4ccAxdPuk5CY2l5S5I7J8tEz0KmHjUPx+PHRYhVj?=
 =?us-ascii?Q?gvyaNAkXzLCiA5VRGmtl9r/E7CEyBQF+YNxF8w+4UVNZA3Z2aqrn252bN21i?=
 =?us-ascii?Q?BEVy+evkmOpeDaIodKbM05hEkJWMSCWQLwkjUR2vT8+TWOiDPVs+XFdGRvxB?=
 =?us-ascii?Q?JbwjaILdwzjcwgKKwrnRLFlZExShu3HnANKYbLAblQsq/p8ypursEAzw3b8C?=
 =?us-ascii?Q?0EjUwUKrLRnj8CQZkD6YfvjHLb9mvZ1ec59sNLCp+ucJpFFQazp4WYprhtSX?=
 =?us-ascii?Q?B9oD1joiWxR7TrlvzNbkfK17AN8MNLZexTv4k2qLBvRKmpiz7ZV/j0DNlRL4?=
 =?us-ascii?Q?9HrGwYQ4UIyM/XIkxvLTkZhlxRnRF4/UrTXLResLfQG7aD+BLOdW52FsYQ7o?=
 =?us-ascii?Q?FgNVofdCLe/dJokRnerNPSwxOflc7i4qayRmxGFsMPLZwGWW7beWBBMczwG8?=
 =?us-ascii?Q?ifM0UGgVlQoMUFhOvnCDdhW+NX0tLwS8BInHRBg8CEIFOtdO00OT2hwvMEd2?=
 =?us-ascii?Q?uuD7O61/aVd+0He/h64X2IarGkY/vICKsML+JpleNfuukHW2JiRWzCDyyg6z?=
 =?us-ascii?Q?RvBS+UwUMio0K4bFzrnxSDJdgCHpxASi9EoMHzWYiIkTdM+sZw6LTDqK4OPM?=
 =?us-ascii?Q?AliT8BfcJiZLM70qpf1nA3tQT1ovYsey4xlayiKJKZI/QLipr9wQqHXhhfCx?=
 =?us-ascii?Q?qjz+m7EpnCnS8lDn3OcL0pnxXf7FFc+jJzpKUdv+eqMBpBXS5AySjsMnkdNy?=
 =?us-ascii?Q?dQAGWWspBqZiTt5dkBNa7aJInHfjQc3OdzcSP5UVF6hQ7hXAumXCN7X56+lG?=
 =?us-ascii?Q?Lh27yGgi8vWb0i1ijXOy/SNq23HoTDhxARFUQBzqHLkPmssJJ/plO8ZPxX1T?=
 =?us-ascii?Q?Pa9NmjAf/NLBMBHvb0p7DbQsteD19PvrULDwDo44cJYwHf8llbVoox3xYUSY?=
 =?us-ascii?Q?K5lSm9uWrUfE56KxEgJcYUTQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7bfc96a-67bf-41c5-4ec1-08d96c002ea6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 21:50:29.0695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iag2DJi6c6pk0NDvaVS9oC0iv45je/abHnA6TsCX+9c+kNJJmKAzWNs2DkV8M1fPddM0NZUbH3IvDU/31QVLTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3350
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10092 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108300137
X-Proofpoint-GUID: 8x4lcfSt15GALUU9vO6XD9pp5Gi_8PnC
X-Proofpoint-ORIG-GUID: 8x4lcfSt15GALUU9vO6XD9pp5Gi_8PnC
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Guillaume Morin reported hitting the following WARNING followed
by GPF or NULL pointer deference either in cgroups_destroy or in
the kill_css path.:

percpu ref (css_release) <= 0 (-1) after switching to atomic
WARNING: CPU: 23 PID: 130 at lib/percpu-refcount.c:196 percpu_ref_switch_to_atomic_rcu+0x127/0x130
CPU: 23 PID: 130 Comm: ksoftirqd/23 Kdump: loaded Tainted: G           O      5.10.60 #1
RIP: 0010:percpu_ref_switch_to_atomic_rcu+0x127/0x130
Call Trace:
 rcu_core+0x30f/0x530
 rcu_core_si+0xe/0x10
 __do_softirq+0x103/0x2a2
 ? sort_range+0x30/0x30
 run_ksoftirqd+0x2b/0x40
 smpboot_thread_fn+0x11a/0x170
 kthread+0x10a/0x140
 ? kthread_create_worker_on_cpu+0x70/0x70
 ret_from_fork+0x22/0x30

Upon further examination, it was discovered that the css structure
was associated with hugetlb reservations.

For private hugetlb mappings the vma points to a reserve map that
contains a pointer to the css.  At mmap time, reservations are set up
and a reference to the css is taken.  This reference is dropped in the
vma close operation; hugetlb_vm_op_close.  However, if a vma is split
no additional reference to the css is taken yet hugetlb_vm_op_close will
be called twice for the split vma resulting in an underflow.

Fix by taking another reference in hugetlb_vm_op_open.  Note that the
reference is only taken for the owner of the reserve map.  In the more
common fork case, the pointer to the reserve map is cleared for
non-owning vmas.

Fixes: e9fe92ae0cd2 ("hugetlb_cgroup: add reservation accounting for
private mappings")
Reported-by: Guillaume Morin <guillaume@morinfr.org>
Suggested-by: Guillaume Morin <guillaume@morinfr.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/hugetlb_cgroup.h | 12 ++++++++++++
 mm/hugetlb.c                   |  4 +++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index 0b8d1fdda3a1..c137396129db 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -121,6 +121,13 @@ static inline void hugetlb_cgroup_put_rsvd_cgroup(struct hugetlb_cgroup *h_cg)
 	css_put(&h_cg->css);
 }
 
+static inline void resv_map_dup_hugetlb_cgroup_uncharge_info(
+						struct resv_map *resv_map)
+{
+	if (resv_map->css)
+		css_get(resv_map->css);
+}
+
 extern int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					struct hugetlb_cgroup **ptr);
 extern int hugetlb_cgroup_charge_cgroup_rsvd(int idx, unsigned long nr_pages,
@@ -199,6 +206,11 @@ static inline void hugetlb_cgroup_put_rsvd_cgroup(struct hugetlb_cgroup *h_cg)
 {
 }
 
+static inline void resv_map_dup_hugetlb_cgroup_uncharge_info(
+						struct resv_map *resv_map)
+{
+}
+
 static inline int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					       struct hugetlb_cgroup **ptr)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8ea35ba6699f..6c583ef079e3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4033,8 +4033,10 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
 	 * after this open call completes.  It is therefore safe to take a
 	 * new reference here without additional locking.
 	 */
-	if (resv && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+	if (resv && is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
+		resv_map_dup_hugetlb_cgroup_uncharge_info(resv);
 		kref_get(&resv->refs);
+	}
 }
 
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
-- 
2.31.1

