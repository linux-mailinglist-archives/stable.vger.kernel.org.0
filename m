Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F5CA909F
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733022AbfIDSKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390155AbfIDSKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:10:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E1BB206B8;
        Wed,  4 Sep 2019 18:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620646;
        bh=JWpqTs1Xkr5FESLr1COBDjSNLrRS6N11lbXarHZ6rhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NvULdSTsfzTnNl6rVglRbcBXCYcWuLJIXdKuORN8Zksmck878Lf3fytLkXpCaSP4
         OGBPrRrS1CBjnUolbR+F9bDSU1sK7MuFNuKOQWMtny7c0sMam1yldKmWjdRqKu8eAm
         Rmr/GSBJ7Ue1q14gdPK8a0j2zxDc4Nh5AbL2PUzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adrian Vladu <avladu@cloudbasesolutions.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Alessandro Pilotti <apilotti@cloudbasesolutions.com>
Subject: [PATCH 5.2 041/143] tools: hv: fixed Python pep8/flake8 warnings for lsvmbus
Date:   Wed,  4 Sep 2019 19:53:04 +0200
Message-Id: <20190904175315.665275348@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5912e791f3018de0a007c8cfa9cb38c97d3e5f5c ]

Fixed pep8/flake8 python style code for lsvmbus tool.

The TAB indentation was on purpose ignored (pep8 rule W191) to make
sure the code is complying with the Linux code guideline.
The following command doe not show any warnings now:
pep8 --ignore=W191 lsvmbus
flake8 --ignore=W191 lsvmbus

Signed-off-by: Adrian Vladu <avladu@cloudbasesolutions.com>

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Alessandro Pilotti <apilotti@cloudbasesolutions.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/hv/lsvmbus | 75 +++++++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 33 deletions(-)

diff --git a/tools/hv/lsvmbus b/tools/hv/lsvmbus
index 55e7374bade0d..099f2c44dbed2 100644
--- a/tools/hv/lsvmbus
+++ b/tools/hv/lsvmbus
@@ -4,10 +4,10 @@
 import os
 from optparse import OptionParser
 
+help_msg = "print verbose messages. Try -vv, -vvv for  more verbose messages"
 parser = OptionParser()
-parser.add_option("-v", "--verbose", dest="verbose",
-		   help="print verbose messages. Try -vv, -vvv for \
-			more verbose messages", action="count")
+parser.add_option(
+	"-v", "--verbose", dest="verbose", help=help_msg, action="count")
 
 (options, args) = parser.parse_args()
 
@@ -21,27 +21,28 @@ if not os.path.isdir(vmbus_sys_path):
 	exit(-1)
 
 vmbus_dev_dict = {
-	'{0e0b6031-5213-4934-818b-38d90ced39db}' : '[Operating system shutdown]',
-	'{9527e630-d0ae-497b-adce-e80ab0175caf}' : '[Time Synchronization]',
-	'{57164f39-9115-4e78-ab55-382f3bd5422d}' : '[Heartbeat]',
-	'{a9a0f4e7-5a45-4d96-b827-8a841e8c03e6}' : '[Data Exchange]',
-	'{35fa2e29-ea23-4236-96ae-3a6ebacba440}' : '[Backup (volume checkpoint)]',
-	'{34d14be3-dee4-41c8-9ae7-6b174977c192}' : '[Guest services]',
-	'{525074dc-8985-46e2-8057-a307dc18a502}' : '[Dynamic Memory]',
-	'{cfa8b69e-5b4a-4cc0-b98b-8ba1a1f3f95a}' : 'Synthetic mouse',
-	'{f912ad6d-2b17-48ea-bd65-f927a61c7684}' : 'Synthetic keyboard',
-	'{da0a7802-e377-4aac-8e77-0558eb1073f8}' : 'Synthetic framebuffer adapter',
-	'{f8615163-df3e-46c5-913f-f2d2f965ed0e}' : 'Synthetic network adapter',
-	'{32412632-86cb-44a2-9b5c-50d1417354f5}' : 'Synthetic IDE Controller',
-	'{ba6163d9-04a1-4d29-b605-72e2ffb1dc7f}' : 'Synthetic SCSI Controller',
-	'{2f9bcc4a-0069-4af3-b76b-6fd0be528cda}' : 'Synthetic fiber channel adapter',
-	'{8c2eaf3d-32a7-4b09-ab99-bd1f1c86b501}' : 'Synthetic RDMA adapter',
-	'{44c4f61d-4444-4400-9d52-802e27ede19f}' : 'PCI Express pass-through',
-	'{276aacf4-ac15-426c-98dd-7521ad3f01fe}' : '[Reserved system device]',
-	'{f8e65716-3cb3-4a06-9a60-1889c5cccab5}' : '[Reserved system device]',
-	'{3375baf4-9e15-4b30-b765-67acb10d607b}' : '[Reserved system device]',
+	'{0e0b6031-5213-4934-818b-38d90ced39db}': '[Operating system shutdown]',
+	'{9527e630-d0ae-497b-adce-e80ab0175caf}': '[Time Synchronization]',
+	'{57164f39-9115-4e78-ab55-382f3bd5422d}': '[Heartbeat]',
+	'{a9a0f4e7-5a45-4d96-b827-8a841e8c03e6}': '[Data Exchange]',
+	'{35fa2e29-ea23-4236-96ae-3a6ebacba440}': '[Backup (volume checkpoint)]',
+	'{34d14be3-dee4-41c8-9ae7-6b174977c192}': '[Guest services]',
+	'{525074dc-8985-46e2-8057-a307dc18a502}': '[Dynamic Memory]',
+	'{cfa8b69e-5b4a-4cc0-b98b-8ba1a1f3f95a}': 'Synthetic mouse',
+	'{f912ad6d-2b17-48ea-bd65-f927a61c7684}': 'Synthetic keyboard',
+	'{da0a7802-e377-4aac-8e77-0558eb1073f8}': 'Synthetic framebuffer adapter',
+	'{f8615163-df3e-46c5-913f-f2d2f965ed0e}': 'Synthetic network adapter',
+	'{32412632-86cb-44a2-9b5c-50d1417354f5}': 'Synthetic IDE Controller',
+	'{ba6163d9-04a1-4d29-b605-72e2ffb1dc7f}': 'Synthetic SCSI Controller',
+	'{2f9bcc4a-0069-4af3-b76b-6fd0be528cda}': 'Synthetic fiber channel adapter',
+	'{8c2eaf3d-32a7-4b09-ab99-bd1f1c86b501}': 'Synthetic RDMA adapter',
+	'{44c4f61d-4444-4400-9d52-802e27ede19f}': 'PCI Express pass-through',
+	'{276aacf4-ac15-426c-98dd-7521ad3f01fe}': '[Reserved system device]',
+	'{f8e65716-3cb3-4a06-9a60-1889c5cccab5}': '[Reserved system device]',
+	'{3375baf4-9e15-4b30-b765-67acb10d607b}': '[Reserved system device]',
 }
 
+
 def get_vmbus_dev_attr(dev_name, attr):
 	try:
 		f = open('%s/%s/%s' % (vmbus_sys_path, dev_name, attr), 'r')
@@ -52,6 +53,7 @@ def get_vmbus_dev_attr(dev_name, attr):
 
 	return lines
 
+
 class VMBus_Dev:
 	pass
 
@@ -66,12 +68,13 @@ for f in os.listdir(vmbus_sys_path):
 
 	chn_vp_mapping = get_vmbus_dev_attr(f, 'channel_vp_mapping')
 	chn_vp_mapping = [c.strip() for c in chn_vp_mapping]
-	chn_vp_mapping = sorted(chn_vp_mapping,
-		key = lambda c : int(c.split(':')[0]))
+	chn_vp_mapping = sorted(
+		chn_vp_mapping, key=lambda c: int(c.split(':')[0]))
 
-	chn_vp_mapping = ['\tRel_ID=%s, target_cpu=%s' %
-				(c.split(':')[0], c.split(':')[1])
-					for c in chn_vp_mapping]
+	chn_vp_mapping = [
+		'\tRel_ID=%s, target_cpu=%s' %
+		(c.split(':')[0], c.split(':')[1]) for c in chn_vp_mapping
+	]
 	d = VMBus_Dev()
 	d.sysfs_path = '%s/%s' % (vmbus_sys_path, f)
 	d.vmbus_id = vmbus_id
@@ -85,7 +88,7 @@ for f in os.listdir(vmbus_sys_path):
 	vmbus_dev_list.append(d)
 
 
-vmbus_dev_list  = sorted(vmbus_dev_list, key = lambda d : int(d.vmbus_id))
+vmbus_dev_list = sorted(vmbus_dev_list, key=lambda d: int(d.vmbus_id))
 
 format0 = '%2s: %s'
 format1 = '%2s: Class_ID = %s - %s\n%s'
@@ -95,9 +98,15 @@ for d in vmbus_dev_list:
 	if verbose == 0:
 		print(('VMBUS ID ' + format0) % (d.vmbus_id, d.dev_desc))
 	elif verbose == 1:
-		print (('VMBUS ID ' + format1) %	\
-			(d.vmbus_id, d.class_id, d.dev_desc, d.chn_vp_mapping))
+		print(
+			('VMBUS ID ' + format1) %
+			(d.vmbus_id, d.class_id, d.dev_desc, d.chn_vp_mapping)
+		)
 	else:
-		print (('VMBUS ID ' + format2) % \
-			(d.vmbus_id, d.class_id, d.dev_desc, \
-			d.device_id, d.sysfs_path, d.chn_vp_mapping))
+		print(
+			('VMBUS ID ' + format2) %
+			(
+				d.vmbus_id, d.class_id, d.dev_desc,
+				d.device_id, d.sysfs_path, d.chn_vp_mapping
+			)
+		)
-- 
2.20.1



