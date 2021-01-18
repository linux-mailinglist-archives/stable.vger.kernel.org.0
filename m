Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EC32FA2A2
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392722AbhARONj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:13:39 -0500
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:16387 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404667AbhAROLJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 09:11:09 -0500
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jan 2021 09:11:08 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1610979068;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=4+llK+Jo5SdFv0XsnDX/o3KrtrkiKMwH4a1jjot82Qg=;
  b=Aygvf7NyMEjlqp0qGAMgcq7UkdzJGC941Yz3LxQ1r2PRxmzT6bg0vqKw
   CFBZGbnmluq1uqbLBLkMk9jJYijT+Xff3u78eWpfgO5K4GHKcWzKqcUzP
   b/BT+XqfjIOasl5+jIeIMJXhiE1Ej5kHYQfyDWbBE2PimLwbg799gaRnn
   Y=;
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: IzLX3GaHMFf8heL747YE/TV+XH623qA5ryDCOEddOclXG48N4T8FJhh4BulF+3oIeaw5gD7A1G
 dv8Dz0ahvLLP99yTUrixhPTo4/G4aRUlYPTTLhavObVIv1NwhdhKSxl0DlDY48fdnnbRbMGsCH
 5irbhO+Sn2Ys3RychPh0V8RN4woEIbG/N//TFNhR0vf9tpZKUkATHcu5L0m+wnQ6C3cbtjGyq0
 VCr3mhOvjEVxsn/FevFmvC4HNI8FdZ1bXFZnaJHLn5lNJTOkNTxEdveAc8/U/AS0eOu8T6YyiL
 Si8=
X-SBRS: 5.2
X-MesageID: 36598221
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.79,356,1602561600"; 
   d="scan'208";a="36598221"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqYaj/Tt+z0kFeAVtyMl4KaoZ6L0KxtQTG8ILQrSz2qbpCK3sOXlXYrjOJBoIKHJNswO2zlDsbk8s4DIOXXDgaEx9o1NWZLaQd7P4b/LGya3mK7NLgV/xA0/Y42YBeDbd3srCdWyidufWmjK+6zyRWfEogQKmSOdMUPS8YKaOHbl/nY+7fXT0Jl8XCOjMFsPR7zZ7Lv2Lb+mzCWa2b63c4q22OmXxFhNtYv3yRRmpVX4jC/v7cW6aNAjfOPgaiplezI8OLLEO9cKB+6ttmRQ1zul6BfS7eVjRgFvVdHpr/09qA5GfVOKY+qh6jqlN+XtN94d9zayF1oAgCyj3hUJ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VESoAKX4LWhpj4B/ROAWTl3XXCjTxLczp/u1C6ghlWE=;
 b=bs1WYXFQMt57p0gz0N/Kwhql15hE+nRCvLLkOBrGc71SA96GY4GCjdbXcW/iICBjeXvNd9rtQ9kkLPWC1CnUv7pnouWOhVUeFzCnbTU1b1ozhECBrfF3u8dI9m3aC3vt+LT2SChtcYCggW83ivJp6OfVdgFCZY3fqcUZnuGZTMIyGBRSvm1MK+GdfyvvZb7/ieAK0AgKqDvlK3j+lg/yz4kUYhj7JhUvbrjcnWiyft3j2MZ4sIMhywft4buLXQo0lkP2LEGPzGYosYP1sk0YiGJiPsxavPMaMxWmnO9epq5g05rbcUDfKXDP25Fkc6kFDzAnKuoFCrM3S827a4GdkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VESoAKX4LWhpj4B/ROAWTl3XXCjTxLczp/u1C6ghlWE=;
 b=cbDZ2rny7sgF1RZmr+LvIfmB0rU++44La6JR2XdgTbX65/GLLjXX0N+gcXAOZFvWdPheDy42GuOPHL6QoaduDApxC9JsCwZMImhIe2r7tWSnC7quMcD3VVxB4UM68tAfVW9LpEAhUPs3sCcTtSaGNe2AC/HIDKlRmQgvgr7Im5U=
From:   Roger Pau Monne <roger.pau@citrix.com>
To:     <stable@vger.kernel.org>
CC:     Roger Pau Monne <roger.pau@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>
Subject: [PATCH for <= 5.4] xen/privcmd: allow fetching resource sizes
Date:   Mon, 18 Jan 2021 15:04:26 +0100
Message-ID: <20210118140426.80458-1-roger.pau@citrix.com>
X-Mailer: git-send-email 2.29.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS8PR04CA0001.eurprd04.prod.outlook.com
 (2603:10a6:20b:310::6) To DS7PR03MB5608.namprd03.prod.outlook.com
 (2603:10b6:5:2c9::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e8ef517-78e3-4954-ad09-08d8bbb9fe4f
X-MS-TrafficTypeDiagnostic: DM6PR03MB3948:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR03MB3948CC3A614539EB8E16D4238FA40@DM6PR03MB3948.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FCOHH0lo74iWpgMaeLdCOeOWlhcFSvoAAzJHlczGbdstIIkMQrkJ4dFBvLV3vgQmDCH5hlWquhOQRKH8WrxyBnKc6s+FxS8eLy0CEf+Ktq22pE+b+kNYdIB/EPgwoKksLcunkn5udwwQxiOnlewU1EFuj9vu4ZrJ/eH/etXXfdlqkgKBx3yKyWEISLSuVVb+Uxbg96pIuqkDoZCT2R7zhC7Nyl/J8HL8OCVJ9URsaUdkEeMsJ9bkEgY/RjcYpsNe55vgLI3S93kZKK74Q18r0YXxQP/8Ld+wBJvTb7SOrsQ4Zf2EKcSgWrudumZH4uhP/NxOl/VKf0a1gzWentnrj8SytdQjegkd3e9lf84qqvPkvDyikWCU1kTA9F9vmjTxuhohbMNe7cBetb5UXABfOpr8UrNnwfqREMhohYyFvFXrdRxv3RQUNHf+RQ6KIBC4QwI+p0B46vOyjz6k21o8Ij7QUwpxn05eUZaxzJamVrF01jrym41u1DOA/vfl6eGLUwzK29kiiZy7/0kLMxshx/nCqEhfKdbPutkAYUVOpqccDxYtXL2ElP4Mmb+G8BYHhZZTHSVlt2NAQWXbwToiYQQTblLpo3uK4Ex/MLObrK0jmL3QDg/l47DSQB8qpslLqZokm9Pbpc4rpePq853waw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR03MB5608.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(6486002)(5660300002)(8936002)(66946007)(1076003)(83380400001)(2906002)(186003)(26005)(6666004)(6916009)(16526019)(2616005)(966005)(8676002)(86362001)(956004)(316002)(54906003)(4326008)(478600001)(36756003)(6496006)(66476007)(66556008)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ajQrRlhGelJrbGtCQVI5cWE1VUtPVVk0YWxRMTdUSnRpRjVOT25ndTRvQUR0?=
 =?utf-8?B?d09OLzdTU1FaWFJGU1UwSTJCS08rWmkyRnZDejZxM0lKcnhCaEY0Q0xPaC91?=
 =?utf-8?B?MEhNZ04zOUtpTTF4akxmaFRtM29tVXVrN0JCejlZSDdvOEJhWHl3QzI4TEJX?=
 =?utf-8?B?ajB5cTlWcU56K3BIYWFTU25pdEpxTEJsSTc2alJiMjhnQWtpUWYra0IrMVJT?=
 =?utf-8?B?ZzVGWGsySkhDRWlQTTFzUHRRUUFhM3JtUFl3SHFTM3YvZjdmc1gwTnQ1YTlV?=
 =?utf-8?B?Y1B6QlltUi9ubWRXbWEwVTAxT29IOFQvWUVrRG1PTmZ5ZE1CalVKSkU2cGxB?=
 =?utf-8?B?T3l1alc4dGlzSlVxUDNQZEkxdzI5aXlNRlVVNnMzMk1jcEdhd0xmTVl4N2Yw?=
 =?utf-8?B?U0ZaNjBEM01RdHN1YTg5eFRMTmZ4cmxYdU81aXBWU082bWJzSmcwWE9uOUJF?=
 =?utf-8?B?UUg2TFUyeDlYYVZMR0hTNnNZdjZtOXJ3NFd0aVIwOVZZdEkvNFBHZ1FXME1j?=
 =?utf-8?B?Q3luOU9hT0ZuTDJJZmRQTUZMSTJFN3orT3hoRzFwcTFsczZ1ZjZyRDVrTWdL?=
 =?utf-8?B?aGZncWh1c0FBMUJWQjZZSHZScFMwK05ibXRWU0E4WEMyakpYTjF2MDZHVm4x?=
 =?utf-8?B?WXVLS0lHTGo1dWZkQktmVFA5Tjc5OW1jbHV1OUcya21mZmJsSE1qR0FBQ0l0?=
 =?utf-8?B?REhQcVpON0VqbExhQnQxQ0pCWXE2Vk5WNGhnU3ZNb0daMlk1dUdaU1QrNy96?=
 =?utf-8?B?NTBSRHFqV1lrN1dyY1o3WGtBajdFZnpvaUE2b2Z6M0xGM2psVDh6dStnTUp5?=
 =?utf-8?B?Nm02K2FaMDhlQVVIbE0weE5xS1hoQnovUTR4dUxoVGdkSHRPcFYyU2E0RTZZ?=
 =?utf-8?B?SkxiTEt2NGM1Nm1CeW1sczhCS0xXMEZ5VmU4V1NVY0lSMkVmME12aVkrM3la?=
 =?utf-8?B?YTUvZFBIUUlYWDRSTDVaY21TL002dkR6QmRCaWlqM1dpaXY3ZGs2MnFITjd0?=
 =?utf-8?B?a3JjeERRNVdzQ0NLK1ovUldsZzN5VEdDWGZvTFlJZGEyZGp0eXJUMSsyWTZ4?=
 =?utf-8?B?UUg2NldpNklHdDJ1T2xjQXVDb09jb0FLZTJINXNmbmhJU0hXSjZ0eHB2bUdq?=
 =?utf-8?B?cXUyS2xDZ3VpdWo1QnZZV1cwb1lzQUN2VFd1OGl3SjhjVDZ0akxON0FsNHFm?=
 =?utf-8?B?K3ZIYitmcjJLNDZtc3NkUTU2RDlIcXRaVGFKdzNiSFNJSThpdldja0t6WTlK?=
 =?utf-8?B?WTRQc3JUeVdybnkvMWJnaFdVYVJQbVFmaGNRSHhhdkxCcW5sUVJDZDI3TlF1?=
 =?utf-8?Q?Jc21Kz/L03t2oOJMFqJ3LtkrndPADu72Su?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e8ef517-78e3-4954-ad09-08d8bbb9fe4f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR03MB5608.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 14:04:38.5422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +4U9ICRBDTzGJeyBbPJ8CUEEH2AVIU/R9PXCx7ROz5swNgVh7C/Z0qr527Rp3wQfF7H19t/TtpluGrIRz1otrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3948
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ef3a575baf53571dc405ee4028e26f50856898e7 upstream

Allow issuing an IOCTL_PRIVCMD_MMAP_RESOURCE ioctl with num = 0 and
addr = 0 in order to fetch the size of a specific resource.

Add a shortcut to the default map resource path, since fetching the
size requires no address to be passed in, and thus no VMA to setup.

This is missing from the initial implementation, and causes issues
when mapping resources that don't have fixed or known sizes.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: stable@vger.kernel.org # >= 4.18
Link: https://lore.kernel.org/r/20210112115358.23346-1-roger.pau@citrix.com
Signed-off-by: Juergen Gross <jgross@suse.com>
---
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: xen-devel@lists.xenproject.org
---
 drivers/xen/privcmd.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 7e6e682104dc..a8486432be05 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -743,14 +743,15 @@ static int remap_pfn_fn(pte_t *ptep, pgtable_t token, unsigned long addr,
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
@@ -760,6 +761,22 @@ static long privcmd_ioctl_mmap_resource(struct file *file, void __user *udata)
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
 	down_write(&mm->mmap_sem);
 
 	vma = find_vma(mm, kdata.addr);
@@ -793,10 +810,6 @@ static long privcmd_ioctl_mmap_resource(struct file *file, void __user *udata)
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

