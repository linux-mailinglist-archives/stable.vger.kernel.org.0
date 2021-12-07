Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CA646BD22
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 15:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237480AbhLGOEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 09:04:23 -0500
Received: from mail-eopbgr140135.outbound.protection.outlook.com ([40.107.14.135]:2567
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232984AbhLGOEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 09:04:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BcZDSlsdVDSSK2PnIhaXK4c1mle1Z7akvqgKiJHGW5zECbIDHheFytITsMfMkXJZ9lRjh2qjK9p0G04irSGIsxYTl5QXG3um0JiJUqQZAaq86EMdsQWz3XRrLPuhrKtLocjHd4XlmzvUGEw7TTH40UtZ63QgcLRR7IhmJmBGzuIZRQXe2vWLkUZzaqJSQOGurZp+B0RElM9yNJu6kd8+nAZW3lLYJGSdU7mkuo3F3Sa7wwwiZjIqJwovcfMoUjci3AKri98CGelDGHPJtUMZz8xSXBsQVjxwFMsO7z+aNvfrnYTUwVF9QORNgoVxa9k3n4Ug8euHKItTUBZaoqbn4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YoRutHOgFeyu2hRNxMuS4EjdfpjKrdz4aRctXQqfzQ=;
 b=mKzzeNHwC/WcOdECZpwj1AX/tmEAE2auR/h+NYReh2KZmw0rD1PH3PcjlOkgYD4VYpijaWgGZydUizsXh3m8wJrCZzI4gUZKEFqlfkDbNp7flIWzhU/Z+9pQdIdScsSVhqFAJ8Fp8a4gXMQQR7kESlyrLMlbxzAGKni+mc1GpEkfRBKMvzyWhgikgMgVGGcKEiipDkzL5MHO5CJBRrn2CuvcYZAJHJgrL93tV6rd7yL/sdOjIZdAAdV94tiLPSDD+Iw8BM23Nl/qUgEooYPeG/rZ8CJyunY+aFtWJ7Q/SK7TIzwgLXci0eWDO4uLao/3rnnwUA4uGGpMEQDFcSmk1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.2.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nokia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nokia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YoRutHOgFeyu2hRNxMuS4EjdfpjKrdz4aRctXQqfzQ=;
 b=cXE8xx4+TL1j2SgspMmRdVhsIg99AtNOBItjqTmxVoPth0CQt/GHBKM5tLxZqjdTCLpVP3nJGeDAk+ygVxBXIAS/r7NyMb/IWL+QJCkm3fREo8eih5r8/vz/w5B0VDvxBzoX+wviDd6l9BBdNGnxdZ8t4Pgz47FqHbIFvv2OmPk=
Received: from AS9PR06CA0233.eurprd06.prod.outlook.com (2603:10a6:20b:45e::14)
 by DB8PR07MB6346.eurprd07.prod.outlook.com (2603:10a6:10:13f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.7; Tue, 7 Dec
 2021 14:00:44 +0000
Received: from VE1EUR03FT058.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:45e:cafe::2) by AS9PR06CA0233.outlook.office365.com
 (2603:10a6:20b:45e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11 via Frontend
 Transport; Tue, 7 Dec 2021 14:00:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.2.17)
 smtp.mailfrom=nokia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia.com designates
 131.228.2.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=131.228.2.17; helo=fihe3nok0735.emea.nsn-net.net;
Received: from fihe3nok0735.emea.nsn-net.net (131.228.2.17) by
 VE1EUR03FT058.mail.protection.outlook.com (10.152.19.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.13 via Frontend Transport; Tue, 7 Dec 2021 14:00:44 +0000
Received: from ulegcparamis.emea.nsn-net.net (ulegcparamis.emea.nsn-net.net [10.151.74.146])
        by fihe3nok0735.emea.nsn-net.net (GMO) with ESMTP id 1B7E0fo7003086;
        Tue, 7 Dec 2021 14:00:41 GMT
From:   Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     linux-nfs@vger.kernel.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] nfsd: Fix nsfd startup race (again)
Date:   Tue,  7 Dec 2021 15:00:39 +0100
Message-Id: <20211207140039.11392-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.10.2
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 6ea0bc78-ba21-413e-faa5-08d9b989f660
X-MS-TrafficTypeDiagnostic: DB8PR07MB6346:EE_
X-Microsoft-Antispam-PRVS: <DB8PR07MB6346B5A13282967F645A157B886E9@DB8PR07MB6346.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:428;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l1VJSunnSz+9ZuDAZipdCKIpChaWzCbivoadL+MiD6pS4hGxE0o0pRcubGs1XEjeLj4dWAm7WCRMA3PlJpNR9ApcY40S8gTDw6c8qnLvlh57aMbs1vsfYtjqo/1p17MPvDu0POFXka4/+lrJiLG4P1YJ0D1Uec8n6jUeIYJaGyJZaJuWg981CiEgqhhnVO4wIQ//8MMgQLCJASlnuGKCSag34RxSI5MwcY1616j5ccbCjbyTk39NiMaIFf2FkiO9w5BCdEEyB+VAGoEX//d3xN//uSYgvit3sT0nm4sRsZCEvWKZotQKZSQ15fZ7gExuHhAsfNQmL1M4BQd9BEsaDKMphGeYr+UgMEM/2W0HULQtfH2thUX1KxgqecNVNDy2BWFJdJ99m5AAAyuPmEfitowImksaJKZQMqw+Mu1XP5aro0zLkEvPkwlbkjY8LB9gRdxIBoF9vjZFbtJHVWYWLq11LF7zo1VTr6T3gP2KhTptHqj2do1gYT7ZiotzVsbLoNQ6wYmGuJJBWGxKuSm9d5i37QDUIlzBzZx+cU9US82IQmf0bzVsz2VZ+D7NleSkNAKXFicsb6RjpOfIr5obJXf5LwmfHA5y/Pb9csJtC57vk1lWKRY6SAJO+p2cSATczJkSDN50FpvboWFM2VSf2i+hRV++YurqZ/fA04d/DcQ+d5MQGhZ0iTTfVD14mtOZS6KDKZQQNry1Q6vffRRpopNJmSHlQBuWV75UF7n76lAHD8l9Yi83hDMWrYaLWOn9dr/GXjLXbNR2d8n2ZibnfeB06+tnvQGKxZs6kaRMTrA=
X-Forefront-Antispam-Report: CIP:131.228.2.17;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fihe3nok0735.emea.nsn-net.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(316002)(336012)(5660300002)(40460700001)(82310400004)(70206006)(70586007)(508600001)(2616005)(86362001)(8936002)(6916009)(26005)(2906002)(81166007)(186003)(36860700001)(54906003)(82960400001)(356005)(4326008)(8676002)(47076005)(83380400001)(36756003)(1076003)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 14:00:44.4063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea0bc78-ba21-413e-faa5-08d9b989f660
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.2.17];Helo=[fihe3nok0735.emea.nsn-net.net]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR07MB6346
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Commit bd5ae9288d64 ("nfsd: register pernet ops last, unregister first")
has re-opened rpc_pipefs_event() race against nfsd_net_id registration
(register_pernet_subsys()) which has been fixed by commit bb7ffbf29e76
("nfsd: fix nsfd startup race triggering BUG_ON").

Restore the order of register_pernet_subsys() vs register_cld_notifier().
Add WARN_ON() to prevent a future regression.

Crash info:
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000012
CPU: 8 PID: 345 Comm: mount Not tainted 5.4.144-... #1
pc : rpc_pipefs_event+0x54/0x120 [nfsd]
lr : rpc_pipefs_event+0x48/0x120 [nfsd]
Call trace:
 rpc_pipefs_event+0x54/0x120 [nfsd]
 blocking_notifier_call_chain
 rpc_fill_super
 get_tree_keyed
 rpc_fs_get_tree
 vfs_get_tree
 do_mount
 ksys_mount
 __arm64_sys_mount
 el0_svc_handler
 el0_svc

Fixes: bd5ae9288d64 ("nfsd: register pernet ops last, unregister first")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 fs/nfsd/nfs4recover.c |  1 +
 fs/nfsd/nfsctl.c      | 14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 6fedc49..4d829cf 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -2156,6 +2156,7 @@ static struct notifier_block nfsd4_cld_block = {
 int
 register_cld_notifier(void)
 {
+	WARN_ON(!nfsd_net_id);
 	return rpc_pipefs_notifier_register(&nfsd4_cld_block);
 }
 
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index af8531c..51a49e0 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1521,12 +1521,9 @@ static int __init init_nfsd(void)
 	int retval;
 	printk(KERN_INFO "Installing knfsd (copyright (C) 1996 okir@monad.swb.de).\n");
 
-	retval = register_cld_notifier();
-	if (retval)
-		return retval;
 	retval = nfsd4_init_slabs();
 	if (retval)
-		goto out_unregister_notifier;
+		return retval;
 	retval = nfsd4_init_pnfs();
 	if (retval)
 		goto out_free_slabs;
@@ -1545,9 +1542,14 @@ static int __init init_nfsd(void)
 		goto out_free_exports;
 	retval = register_pernet_subsys(&nfsd_net_ops);
 	if (retval < 0)
+		goto out_free_filesystem;
+	retval = register_cld_notifier();
+	if (retval)
 		goto out_free_all;
 	return 0;
 out_free_all:
+	unregister_pernet_subsys(&nfsd_net_ops);
+out_free_filesystem:
 	unregister_filesystem(&nfsd_fs_type);
 out_free_exports:
 	remove_proc_entry("fs/nfs/exports", NULL);
@@ -1561,13 +1563,12 @@ static int __init init_nfsd(void)
 	nfsd4_exit_pnfs();
 out_free_slabs:
 	nfsd4_free_slabs();
-out_unregister_notifier:
-	unregister_cld_notifier();
 	return retval;
 }
 
 static void __exit exit_nfsd(void)
 {
+	unregister_cld_notifier();
 	unregister_pernet_subsys(&nfsd_net_ops);
 	nfsd_drc_slab_free();
 	remove_proc_entry("fs/nfs/exports", NULL);
@@ -1577,7 +1578,6 @@ static void __exit exit_nfsd(void)
 	nfsd4_free_slabs();
 	nfsd4_exit_pnfs();
 	unregister_filesystem(&nfsd_fs_type);
-	unregister_cld_notifier();
 }
 
 MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");
-- 
2.10.2

