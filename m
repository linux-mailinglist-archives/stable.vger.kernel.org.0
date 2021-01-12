Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3BA2F2EA1
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 13:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732107AbhALMFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:05:38 -0500
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:22275 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732104AbhALMFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 07:05:37 -0500
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2021 07:05:36 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1610453136;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=GVEOGe6HOBcUN3W05uXHIu3680KaoPV1ahJI63NieNI=;
  b=KrL9ZJPROTAml40g9AfZETaTVG3RcoutlYYcPZan4MwyqXPz5yj5F8Kp
   eicmr2tXGtOKpJ/MENvZNFtf51/zWn9j11nuENBpU4zXxPuMvEvnsIm3X
   Ce5wcuKf4NS3tlB2MoFOY308a4tbkMiysjO1MYcm8pvnKsBdJ1GDtJUkM
   8=;
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: oJ+WmsQtwSEea3wZ3PHvu1LgnixfhLWSBP/az/mcrIwRUeu8d4x6Bg48rmra/2bpEQbLwrBa7s
 4IteRKJoStDgtjYjAsnTLaO7v7u1Z+zgoiI3sSBYIogIFHVJUEk+pwrwHGBJGr+XmonZ1PRb7M
 4jDePZqsGzPfbY/JA8YNOUIogw8n6RPPa6Ps5UhG97qsksL+2Q4crzIf85oJ25zcGZ24rImJrT
 zcOYlmoNeokBEV8TqxCRZTOC4sM77pa5unETVJ888vMJpb/89x6HrCu+jVJWS8WMoRRyVmCEAc
 0bI=
X-SBRS: 5.2
X-MesageID: 34948028
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.79,341,1602561600"; 
   d="scan'208";a="34948028"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cha5r0oLiV1yOpam4G/YSwOqNyddN8H6bZgywWLIMb789GHRs1rhAgKkxM5PwenpTe/pp4D0YUDNQLv2SGstUzPOrKyX4V8Q7AC1uZFz5raZ7q3Dd45ER5vufWNwj39i+n3S/2DQwDxhNrd9v3ytSCxrkr4svcmVUWY/p2gw53w+YB11GZdrjpnOIVYPiHADgI4brNtQi9cAau7QqhAiIjbylftGArxniMvitEZd208ydBaLlT4VJbS9m7j6RtcP1LEbuDG0hjNOtjzPzLobHpGUElsbKSsIdo2eR76MeWkaguJ9nVmCciXZLE3/J9oxXRbzhrdTJoMUGA7BBMjQyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExJaXQE/thjDWVx76HSE5KvzYwprp3LimsMovnDmkqA=;
 b=c0Goza1eqEpGebqcs7P3nVRdC083p7drmpOp5Tryt4EA+t2RW7VAuCovTDDsFxQCfXfpqwh3dZ7GTyB95KrV7TS4Yh2pFdCdlRDPp3KVuCewKAtuvnXE/5oQo4Xl/Xsov+zMe+jmkNOsWPVSH6SKPEFIPFmn4wiRMql6On5ZThPak8lJSLDxi4xYtMHkTN6WZ57pAN6SSvJhLVYVkflMoLm+UtGSD3kOLdRYCIzBVknJ9fs2ROGNEvKD9tD9nyyG2Xv6GbUkAxh3E4on9xRpfR0LmGahJbacAvy4vA6jacne0tBaOLkkIUYQEG0d8nZhMG2FEMKokgoWgYRxDFgXeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExJaXQE/thjDWVx76HSE5KvzYwprp3LimsMovnDmkqA=;
 b=WkFcRfhr8fhvvbXIO9Z0GPCg/n8QOvlgCBDyot0UTkdib4TPfYjAIOEydHGxry+PvPSeLG+1wNlx5u/673eTdK8+Fm47pnXg6waqH/Mesinm2gzsov52yxond5MnQ8wKppXKfK6H7qVvS2dmFEyBtBbcrbcesqum79IX8QdJq+g=
From:   Roger Pau Monne <roger.pau@citrix.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Roger Pau Monne <roger.pau@citrix.com>, <stable@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Paul Durrant <paul.durrant@citrix.com>, <amc96@cam.ac.uk>,
        <andrew.cooper3@citrix.com>, <xen-devel@lists.xenproject.org>
Subject: [PATCH v2] xen/privcmd: allow fetching resource sizes
Date:   Tue, 12 Jan 2021 12:53:58 +0100
Message-ID: <20210112115358.23346-1-roger.pau@citrix.com>
X-Mailer: git-send-email 2.29.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR3PR09CA0017.eurprd09.prod.outlook.com
 (2603:10a6:102:b7::22) To DS7PR03MB5608.namprd03.prod.outlook.com
 (2603:10b6:5:2c9::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8cd1e1a-8dcd-422c-b965-08d8b6f179a4
X-MS-TrafficTypeDiagnostic: DM6PR03MB4604:
X-LD-Processed: 335836de-42ef-43a2-b145-348c2ee9ca5b,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR03MB4604FD074DA5653BEF217E458FAA0@DM6PR03MB4604.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkEI7WyUVPS8gn+DGPs4ZNtkzsiiYp4WF9zJA5LdFmTJ8i5CD5rbhRxhI1AMbA8nTyKZ/QxXH0C5LHmVWe1PCr/F9pOiX+usSGhIhBVE67HtQdmgLCnE4+jk/ijwBzyl2rm2yfwieUdwnDNBxMiTEY1yqnDNG5wjYxEPI9UVdWTz7Lb+ftGaRrUwe6EJXPx36VqyCMF9pF6vxOxGUyIq6Wx8vaBq6RBWQzftT41oFLaKtN4R6KdKAvhsFUcCCE1wED1G9/ZKxIdng40xgVxUPwZhCw+zwC0/TBBToQuvQbDuxRXkdw9N6dnOX8jpSrn6v7GK4aBbQ4qTErTfu2LDkYAaUxVaMIaHi9LApsdeqagPqWpkW3M3LAFo92iYjVp8B7xq/etgitHkBiPOwOMp7AGgr+0ijcOZ23Haq9B0gFXp7L7DRMpq4a1X+WN9SOP4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR03MB5608.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(478600001)(26005)(2616005)(186003)(956004)(1076003)(5660300002)(54906003)(2906002)(6486002)(316002)(8676002)(16526019)(83380400001)(66946007)(6666004)(8936002)(86362001)(6916009)(36756003)(66476007)(4326008)(6496006)(66556008)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MGRrdlh0TmttaEZKSVdkWDdmaU0xZFBYOFdXc05GMnBvaEd2enVnRjFoNjVS?=
 =?utf-8?B?V1dJa3lyY05YWFg0endNZUxaL1c4NGFsVW5OZDVQQjVKZTlvOUhHYmxFUVB6?=
 =?utf-8?B?L0JyWEVmWlNiSlRncVd4WGQya2N2WDBHUWlFNTBwRHk2SDl3ZVVudkdXWFhH?=
 =?utf-8?B?NEpEQ3lUM1J4TEZaOWRkWVBqR3FQRVVSMi8xQmV3c3ZqRFJLcVBXK1NtZjJ1?=
 =?utf-8?B?bGhnWGV2cFgrTGQ3UGdlYy9FS2pEMFJHZ2tTbXFrdWlTajI2VzA0cHlITVlm?=
 =?utf-8?B?Q3RVWlFKWXF1UE5sb1lqYXJEOTNkOC9VM2dKbmx3OUROWnk1eWZoeFlDTE5y?=
 =?utf-8?B?dHNEeFY1L0MzUlRrcmhaOVFteWtBb2JCb0pTcUIxaHhNaUtzck8zWUpWOE14?=
 =?utf-8?B?aVV2NGh5Sm5xcUhmV0FPZTJNc3NPeWpad0ExZUErWU5iUldXcTBrUms5Wnlz?=
 =?utf-8?B?NHFlVjF2SHdNNUQzM2laN09JS0x1VW1nM3JnQkJKd2FCa0tyY1hUc0ZGL09x?=
 =?utf-8?B?NW9Pd2c4OTh3QTgyWXRkQ3V5OFR5T2lVV2JqTUpZemlqNDJybHdsWFZJYTcw?=
 =?utf-8?B?TjM1NWJoZ1hadTNRSFNsZjQ5eFJoQnl6NTAzdkxBNGVINXhaMzN0V0pHZkQr?=
 =?utf-8?B?TzJQb2RpcVJxOGduTHVJcmlvNHhZVXUwTnpQTllZcnRFQmg2TGtVamJja0h3?=
 =?utf-8?B?S2JPdktldVFGSXZ2VXFHSVBVNldxUFR1dUE2b1pZZk9wN0YxR0FjaDQ2RDVu?=
 =?utf-8?B?QlRGSUI5Rjk4enhpSFNnWjkya0MxcnhKVlhESXFLNlM0ZFI3a1NFZzBvdHJE?=
 =?utf-8?B?cy85M0pwbjdKb3h6NmhlMjIrWU9xcThnMTU1Q3BRLzJ5ZmllUUlvaTl0Vk51?=
 =?utf-8?B?dTFYWTYxTlVYNklJUmVMWTlPSjgzTkIzZTBjTE91R3J2MVNRY25rRk1OVlVE?=
 =?utf-8?B?d1QvWnpHQTBxb2JOU2VFNzc1OERZRWg1aDNQYkgzcHhvdlFRTXJTLzRjMVNs?=
 =?utf-8?B?ZUNlMEcwUUhrcDBLRFdmSFI1ZjYrWUJCRlNsSVkzckE2a3g5SHhvNXlSY3M3?=
 =?utf-8?B?YnJYd0l5UlR6RTZyNVFZT0RaVW9idk5xWGY2WU82OGdkNTFRM1BhSW5pYjZV?=
 =?utf-8?B?MTlsMDhOVTVYVVlxZVNJVmlDNFpvSXluSS94RXgrbUYvNmR1NTBNUVFpR2g3?=
 =?utf-8?B?R1F3Rk1NR3dnOXBWVWo3b1NvZ1pjRmppbXkxb0tmcDdrQndUU1RzZ0pSWHVz?=
 =?utf-8?B?MytidnpUQytNSFdBNlZkeG9HVXgyRWkrQmdDWmNwRVR2bUhWenlvbnFzWGtG?=
 =?utf-8?Q?fIY5pguhibR2JIH61KfZet4MNEfXU1G+uL?=
X-MS-Exchange-CrossTenant-AuthSource: DS7PR03MB5608.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 11:59:11.6370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-Network-Message-Id: d8cd1e1a-8dcd-422c-b965-08d8b6f179a4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IoBsu6DA4x7D7n0GE/0rCilqq8ybEhClL4/W6FAJzyz/0OCm3pnJWyYlJt/iQwlOqtQx2OJiSVH3pmbloInc+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB4604
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Allow issuing an IOCTL_PRIVCMD_MMAP_RESOURCE ioctl with num = 0 and
addr = 0 in order to fetch the size of a specific resource.

Add a shortcut to the default map resource path, since fetching the
size requires no address to be passed in, and thus no VMA to setup.

This is missing from the initial implementation, and causes issues
when mapping resources that don't have fixed or known sizes.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: stable@vger.kernel.org # >= 4.18
---
NB: fetching the size of a resource shouldn't trigger an hypercall
preemption, and hence I've dropped the preempt indications.
---
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Paul Durrant <paul.durrant@citrix.com>
Cc: amc96@cam.ac.uk
Cc: andrew.cooper3@citrix.com
Cc: xen-devel@lists.xenproject.org
---
Changes since v1:
 - Remove Fixes tag, add backport.
 - Make sure both addr and num are set or unset.
---
 drivers/xen/privcmd.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index b0c73c58f987..720a7b7abd46 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -717,14 +717,15 @@ static long privcmd_ioctl_restrict(struct file *file, void __user *udata)
 	return 0;
 }
 
-static long privcmd_ioctl_mmap_resource(struct file *file, void __user *udata)
+static long privcmd_ioctl_mmap_resource(struct file *file,
+				struct privcmd_mmap_resource __user *udata)
 {
 	struct privcmd_data *data = file->private_data;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct privcmd_mmap_resource kdata;
 	xen_pfn_t *pfns = NULL;
-	struct xen_mem_acquire_resource xdata;
+	struct xen_mem_acquire_resource xdata = { };
 	int rc;
 
 	if (copy_from_user(&kdata, udata, sizeof(kdata)))
@@ -734,6 +735,22 @@ static long privcmd_ioctl_mmap_resource(struct file *file, void __user *udata)
 	if (data->domid != DOMID_INVALID && data->domid != kdata.dom)
 		return -EPERM;
 
+	/* Both fields must be set or unset */
+	if (!!kdata.addr != !!kdata.num)
+		return -EINVAL;
+
+	xdata.domid = kdata.dom;
+	xdata.type = kdata.type;
+	xdata.id = kdata.id;
+
+	if (!kdata.addr && !kdata.num) {
+		/* Query the size of the resource. */
+		rc = HYPERVISOR_memory_op(XENMEM_acquire_resource, &xdata);
+		if (rc)
+			return rc;
+		return __put_user(xdata.nr_frames, &udata->num);
+	}
+
 	mmap_write_lock(mm);
 
 	vma = find_vma(mm, kdata.addr);
@@ -768,10 +785,6 @@ static long privcmd_ioctl_mmap_resource(struct file *file, void __user *udata)
 	} else
 		vma->vm_private_data = PRIV_VMA_LOCKED;
 
-	memset(&xdata, 0, sizeof(xdata));
-	xdata.domid = kdata.dom;
-	xdata.type = kdata.type;
-	xdata.id = kdata.id;
 	xdata.frame = kdata.idx;
 	xdata.nr_frames = kdata.num;
 	set_xen_guest_handle(xdata.frame_list, pfns);
-- 
2.29.2

