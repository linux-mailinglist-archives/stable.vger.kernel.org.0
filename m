Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F7B516EF8
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 13:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350642AbiEBLnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 07:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiEBLnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 07:43:19 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7302B165A0
        for <stable@vger.kernel.org>; Mon,  2 May 2022 04:39:50 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242B1Vo8012304;
        Mon, 2 May 2022 11:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=qTRPnvwLd7T4i4bIc4d37Y/ZiU5xEXXJs/iJnhDpsMg=;
 b=rRqeFyTko2dFSkUT4bSriwQ/3rDiaBz3LTc+qWawNr18bxt5br+Y+4mnWwL+RjALAeNW
 9Ja7T8RsFyMtRdeJt3HDWAxba0JxnTV5mcRa4CKQ+GD/kRRmEX798bWgEZv1hvr6HU1r
 iSsJcxXj6AW6gV0Dg8RLweSazKbIdeBXRCz08To7oWEXEs6UPfxaLmAYL3WaoMvEjRzZ
 LJZcfVJpz2vDj0L/IoizuiFezmXcSeQpKrObGFG91YAQJlTsap6jIS6fT//PEPj1NzQN
 CNwDPEkzRnyjoUY5HeZuz6bacN5cC9TXceckW1tynDQRzga7rr3POx1WpiqlaYfGfw58 GQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3frtb0hc83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 11:39:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXV18AydyeENQ5fmAv57e50qJAJDTF9J+FBPJbYjM1Ahw6VOrmrFAiHBXzvFOiY7gUOZL3UMZwqtRPL8//wlujqAFk43DBXinGdeXGY0ZlM+Q1KVkpZU/PAnj9nOo0EuIeP1wBx7xibXaJG1sQYMT0017Tm4Dkag7ggPzOHTwvIfwVrXxVKBHpIga07m3qGf0tXgWtQe5mwocZhVTLL9OjTooW9PZkxM9V7n+XPw3PTo05i/QrgTWEGjDWWR5TyfXRNo4dc02d5GE2CpKRZtJY66B2MGFDTBmgl0ur1MFX1VyiU8zNhcCPb/dTatLCqmfKojIqDl0aOoSdjGLlbLvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qTRPnvwLd7T4i4bIc4d37Y/ZiU5xEXXJs/iJnhDpsMg=;
 b=Y5bqhRNreSqRsyuxwzaavIs7R5un6eowDMoWu6MPjdyqldZOFAb8/K82gYQJN7DZETRsB2qK1IwBLIMHsJL5UoYp0EuHMGKf1Oz06two1LMN/dqDPH/qr8dX66alM04I54ad7yfXd9zeWg1YpT0SzPWwpia875MjGY+SsiMYDyTrqgbU36RXPsT/OXDS5C+WpzftSmc7DXl6NtFCjSpV5mMOeX6E1qFb+udmjmJskX5eohGKHNIoKh8Pntg9yiAbxhd34m6IZ3mgPWpfT47UygvB/0zjO1UncUCSNIOMc2Kif2oSEQ2dLGyCgphKvCDnKieAfbLbghjRxc0XFRIDkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MW3PR11MB4683.namprd11.prod.outlook.com (2603:10b6:303:5c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 2 May
 2022 11:39:20 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%7]) with mapi id 15.20.5186.028; Mon, 2 May 2022
 11:39:20 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hillf Danton <hdanton@sina.com>,
        syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com,
        Emil Velikov <emil.velikov@collabora.com>,
        Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Anholt <eric@anholt.net>, Sam Ravnborg <sam@ravnborg.org>,
        Rob Clark <robdclark@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 1/1] drm/vgem: Close use-after-free race in vgem_gem_create
Date:   Mon,  2 May 2022 14:38:57 +0300
Message-Id: <20220502113857.2126299-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:803:50::39) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ad413c0-2e53-4be1-46d8-08da2c30653e
X-MS-TrafficTypeDiagnostic: MW3PR11MB4683:EE_
X-Microsoft-Antispam-PRVS: <MW3PR11MB468339A3BA12B9BC941F07B2FEC19@MW3PR11MB4683.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DxXQe3va9ZJtErIfnvATlPcTmwK5eIINaEv5dogYdcc1/7vfukCLxeBnDYUOB/202B9Bskf5pYsti2bEYtw+goxETJqTE2KLbqTpqmzOZg0CRZES2Jj5ecZ7OsMyorc81VAKnBPVW9oq99svfhXJWqIuYoFwsusq9zXBwBN5uj2uWf3zXLsn/v0z402/Ni50bPsek6ecnEZG4wNxT4FLu48ZEiDkKQ+iv/gvRQv6mMsun0Kyz/L38+LBactjIWqVnhV7SHnsNt7anDA4Obpbx5ozDPhQWuGI50lsZNFnv0EAg9eJK3Kg84psHRPXB5OLQk/8QGYwMfT/uwWG7AfROjNhIiwwhjM817DlsSZJCxElWg2W5daG/cv3/UPxgaXBeaM6L5Lf5N3ARf/fT97dKFzPFSCiFz+Dpp3IVqaHrCucw/pM2f7HoMRcsE2ZHZdo3isjE4hdVvExxvZvwJIhPIFaJnPm7C4EGNB+tVo0ArTrOtLEuOmxufx2RBXvF7ke+lBWAM1GSa4ZsXUP80Xw2T/kD9FFsNp6hjeAc9+IEgwuUxuSSzZ4UhOhaspUIipySjC3aEi4bt6lCdUpOOmck0MnMDEH5tBr+NGVsL+5nHwfGEx0y/7awN+0xoUkO0oe6AlbBOnGjDHW8K4QkG5v03p+Fe1cCCTwAiQ30vonk4kiMFSnxRgM2cu3cOG+hY62STkOeoElhqpphFN6zJl4Qrdj4Rge582aVLBsOsrR46ROSV7kuiEi0rRlsXPZETqCMVd/eCmPgFh6QOC/Ped3PXJc7m+mnwqk8NwpH/Wrby4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(966005)(6486002)(86362001)(52116002)(6512007)(6506007)(2906002)(508600001)(26005)(44832011)(7416002)(8936002)(5660300002)(186003)(2616005)(38100700002)(38350700002)(83380400001)(1076003)(107886003)(316002)(36756003)(6916009)(66476007)(66556008)(54906003)(66946007)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FnLIoTX6G0OBjucUp4v4nY9lWO9IpOcJd0Ia8MWDxJ2I1G/63h8WZmlB7Qmw?=
 =?us-ascii?Q?C/+tQY6f918vX2yQ82FaUMovwpij7YtrwBIP5LrtDTMwJoFbml74amcPTxRo?=
 =?us-ascii?Q?+EgvSD/0oKjUUqtWrseBfGQ5r3zVCMbMJoY14KeUWPSqcltZCaBGdJpEpVNs?=
 =?us-ascii?Q?EPFfQ6Rypt+t+7Q1jpTMAegvt536qbBzVw1vfltY2+yfaUhtCXoDOPfaIZvx?=
 =?us-ascii?Q?MtCEIk6RPEms7CxhQYWIrdZIcrdSYtPNmB+d7Hx1S3KpfZHnclIAAE5uNMeU?=
 =?us-ascii?Q?iPUwUbCQm3UtJZJYkoJmL5VY4AwlpKHujw/2Y28MGAsVCsSx+SuagMc79A3M?=
 =?us-ascii?Q?r7vq8g2QTSv7B1EiNV9uFgFhYYDhFI0vK9poFI2yiVXs278pL+0wTWkrQ9iT?=
 =?us-ascii?Q?Drp0RH1wMn2zdKh2w9LSWzi+4udrDmH52jVt5lCEAvigeZYX2JoDmp/Sdd04?=
 =?us-ascii?Q?9AMtUFziLCZC8GJcAGDqeCoh9MgTDIGOGKSRiiDkafgMyUIlMJg7KjZ+6A4j?=
 =?us-ascii?Q?7QUmQe+5AWDdF6i71gP+F7qemGFpbUu5bOQzTR58tDep2bS4Nbg8cdpz6wBw?=
 =?us-ascii?Q?ix8ckz1O6JR0EUb2knxWGjEUf9eIXEm+JvzxKolhs1aNw9do0F5zvoj4+4sn?=
 =?us-ascii?Q?Sw3d1nQR/lvmWmfcUgE7xn/CH5AAr0gI7E/rG87O7JTUVjmQa1WF7aLj4hVC?=
 =?us-ascii?Q?FB7bOlqDIwxsLLEA+BpHuzDnvpYvAPtQF4PWoSI8jrTP6vtMHhsKMN4BlTKj?=
 =?us-ascii?Q?25cI1kpvEr3QIOaCptTqF3hN9ZQ0Jwdwi3VJ3E8A3cqwqYmNBVDWhfNe3ZPm?=
 =?us-ascii?Q?warCEt+94GYLxAke5qU3UShA3Te65SKiQgfWzTA0wBMC1Vj4ilgv4qPWRKh9?=
 =?us-ascii?Q?9ebrdEcsu5lR6SJUdBD02rXTTKtHzFwkQw9lRf+gjoaSpsE8reR8xImvhQHw?=
 =?us-ascii?Q?qO4TeZciov0PVhkMBcPaYHYynmgZHDvhH29/V/DosOYYLGB/iKsjwWTXKh3f?=
 =?us-ascii?Q?pgNUkH4pjGyPNc0+QiYTAOqwsGb48ejQRgEdAt3NWESuEn2WQrAyr7lBvW0I?=
 =?us-ascii?Q?Np+PeuRh0MSSBfwSBGjyV0DElMyaXwMxkrN9sWoU6G05+nKn1MABO3Okz9p0?=
 =?us-ascii?Q?IfT4/mCz42Qnsh2DbaHHO/iEgJVcc/lJX5uZJV7NX9PiGiwLmuHlT/XNgspy?=
 =?us-ascii?Q?vrJ2NVT2/FKMv2UUFZudur5fDx50Sdf9Y0jbWUo9nOjBm99pXlGWFUvNFnwB?=
 =?us-ascii?Q?xv5FNy1DEsjssos9mPcA0sGIREnfS968d+dQA0becZXbKs9C0sFef5tV8Xwm?=
 =?us-ascii?Q?Tl/2sSM/rb2TS3NTHlJed5YjqnBC/qzoYHynarHiTZPa+1mL0mgVY+CMjLpo?=
 =?us-ascii?Q?8FE32X86o1V/SMgFAL0UmZPwNyYQXJ7cLbNL7mhfzR7uZO0l1Vn9RmHEEI7d?=
 =?us-ascii?Q?h3ageD+yZuU/Mj9FJyTD/i+0TUL8+HYNuPwcptYn+zZVRYi82MDefweNyuW1?=
 =?us-ascii?Q?SV5/SOQ6Y+5Qyx6FGcLTBe0zd+iZgpby64ox6Qhco5hkflQVcHMfpCAyBfLY?=
 =?us-ascii?Q?289xCvCcimTYSnwuc0HY00e9B7t6tXGS0ucpJ2jd1LqU32tTFNkzBbih82bV?=
 =?us-ascii?Q?NByqYY/kVWRvKgeQPNuAUdUfuYOVyspP0K9KWluqufGB+fKe9ZolspoRMLmz?=
 =?us-ascii?Q?cfxFJZYzmsBHDZ75Dy9dCfKXdAhIssM5a3VQ5Pwk/zOlOU3hYOKW+GPzjl0N?=
 =?us-ascii?Q?qxZFqC4mwbT/vEBWKjixguxNbgHt+xU=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad413c0-2e53-4be1-46d8-08da2c30653e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 11:39:20.5147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mTBtqjwOX4V1/amThCd1xcQENBMLPXAtibnd7vlpmLV08O3IoCK+evhyBCcmj6IDOTnxJ042XLO1HS2lnI4RrQHB6+ZDICupA2OPSijZtvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4683
X-Proofpoint-GUID: p-o3_RGEZQfq0ogdGCrrKQ51qNBZfP1r
X-Proofpoint-ORIG-GUID: p-o3_RGEZQfq0ogdGCrrKQ51qNBZfP1r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_03,2022-05-02_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 adultscore=0 clxscore=1011
 mlxscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205020091
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 4b848f20eda5974020f043ca14bacf7a7e634fc8 upstream.

There's two references floating around here (for the object reference,
not the handle_count reference, that's a different thing):

- The temporary reference held by vgem_gem_create, acquired by
  creating the object and released by calling
  drm_gem_object_put_unlocked.

- The reference held by the object handle, created by
  drm_gem_handle_create. This one generally outlives the function,
  except if a 2nd thread races with a GEM_CLOSE ioctl call.

So usually everything is correct, except in that race case, where the
access to gem_object->size could be looking at freed data already.
Which again isn't a real problem (userspace shot its feet off already
with the race, we could return garbage), but maybe someone can exploit
this as an information leak.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hillf Danton <hdanton@sina.com>
Reported-by: syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Eric Anholt <eric@anholt.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rob Clark <robdclark@chromium.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200202132133.1891846-1-daniel.vetter@ffwll.ch
[OP: backport to 4.19: adjusted DRM_DEBUG() -> DRM_DEBUG_DRIVER()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
This is the fix for CVE-2022-1419.

The testcase from [1] adjusted to run in a while(1); loop generates the
following KASAN trace currently:
root@intel-x86-64:~# ./poc
[   37.663495] ==================================================================
[   37.664441] BUG: KASAN: use-after-free in vgem_gem_dumb_create+0x22c/0x240
[   37.665266] Read of size 8 at addr ffff88810b27b380 by task poc/5993
[   37.666047] 
[   37.666257] CPU: 1 PID: 5993 Comm: poc Not tainted 4.19.241 #7
[   37.666937] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[   37.668034] Call Trace:
[   37.668360]  dump_stack+0x188/0x1ff
[   37.668804]  ? vgem_gem_dumb_create+0x22c/0x240
[   37.669376]  print_address_description.cold+0x7c/0x212
[   37.670004]  ? vgem_gem_dumb_create+0x22c/0x240
[   37.670553]  kasan_report.cold+0x88/0x2af
[   37.671059]  vgem_gem_dumb_create+0x22c/0x240
[   37.671602]  drm_mode_create_dumb+0x27e/0x310
[   37.672153]  drm_ioctl_kernel+0x1f1/0x2a0
[   37.672647]  ? drm_mode_create_dumb+0x310/0x310
[   37.673199]  ? drm_setversion+0x880/0x880
[   37.673695]  ? __might_fault+0x192/0x1d0
[   37.674173]  drm_ioctl+0x4e4/0x9a0
[   37.674631]  ? drm_mode_create_dumb+0x310/0x310
[   37.675199]  ? drm_version+0x3d0/0x3d0
[   37.675659]  ? pud_val+0xf0/0xf0
[   37.676084]  ? find_held_lock+0x2d/0x110
[   37.676557]  ? __fget+0x341/0x500
[   37.676975]  ? drm_version+0x3d0/0x3d0
[   37.677443]  do_vfs_ioctl+0xcdb/0x12e0
[   37.677907]  ? check_preemption_disabled+0x41/0x280
[   37.678508]  ? ioctl_preallocate+0x200/0x200
[   37.679021]  ? __fget+0x368/0x500
[   37.679420]  ? ksys_dup3+0x3c0/0x3c0
[   37.679859]  ? syscall_trace_enter+0x3b8/0xd50
[   37.680387]  ? syscall_get_arguments.part.0+0x10/0x10
[   37.680980]  ksys_ioctl+0x9b/0xc0
[   37.681375]  __x64_sys_ioctl+0x6f/0xb0
[   37.681826]  do_syscall_64+0xf0/0x180
[   37.682275]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   37.682876] RIP: 0033:0x7fb3d3c0ac87

With the fix applied, the testcase is OK.

[1] https://www.openwall.com/lists/oss-security/2022/04/21/1

 drivers/gpu/drm/vgem/vgem_drv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_drv.c
index 1c1a435d354b..56ed771032c2 100644
--- a/drivers/gpu/drm/vgem/vgem_drv.c
+++ b/drivers/gpu/drm/vgem/vgem_drv.c
@@ -189,9 +189,10 @@ static struct drm_gem_object *vgem_gem_create(struct drm_device *dev,
 		return ERR_CAST(obj);
 
 	ret = drm_gem_handle_create(file, &obj->base, handle);
-	drm_gem_object_put_unlocked(&obj->base);
-	if (ret)
+	if (ret) {
+		drm_gem_object_put_unlocked(&obj->base);
 		return ERR_PTR(ret);
+	}
 
 	return &obj->base;
 }
@@ -214,7 +215,9 @@ static int vgem_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
 	args->size = gem_object->size;
 	args->pitch = pitch;
 
-	DRM_DEBUG_DRIVER("Created object of size %lld\n", size);
+	drm_gem_object_put_unlocked(gem_object);
+
+	DRM_DEBUG_DRIVER("Created object of size %llu\n", args->size);
 
 	return 0;
 }
-- 
2.36.0

