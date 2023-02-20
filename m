Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A6669D28B
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjBTSIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbjBTSIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:08:01 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E203183E6;
        Mon, 20 Feb 2023 10:07:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjkrR0LqX/RFUvnntRQUZ9AD11GVJ2ChF2Y6CH/MT7vGOLlg3NatqIoDM2LIKtz/PHV/hfWQ/fPo9/9wfu/LrwBeoKBephrvHWL2gx8Hh/AMb1ZfpTmQYqh0pvm75Db55eXbXUelM5vwafyNDy9UB0MjgLFD/s4zCufyTeLtNzwwCpEk/Pt3ijy+KtOu5/0i9ZLH9QjWz+xCHMa42QK4HFtbvTlqR8QBO3N0MunfkC3frN81M0jX+UJacoQGpgNCH9yMOWr5R99Kd7w7Ru3EB6BOpJ7mKwxdtwEQAn1DwArevMQdywUacUrnCmNwfJT0fG90BsU0PBpnm7Hs5y/zRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOnd9cKmpqZZvJbhfYFVvKZqk4ZSa6keNIXe6DQCFSk=;
 b=Jyo+n1zFcr/ljY65PVnaKCskfYVFy6ZLbigGNfYiHQ0rM66XvTw3hA30SKrH+QIu5g+zP3Td09ayTfqoJP4agD8FBXY41dEkmINxWDMrNkBPXKpdxbSYTW6rWkmNba7Y0RE9qgr1XGum7Pw6eEDnwXRiHoorC+tHsF7q34N4B81B9dU2iV2E1Ajs7NVEmHDrRsYOiJ4X1/3cD9ESc7wPqSfZa7tnU/Ovbfmz7jMYICyEvuTkM1uUHjJPT8oFcFfNPGjzBMqTSYP1wUkBMqlm+iZT5SFTaf7VuB8nX3rqXC2CNQdDarz3dPxdRyTTaur88jsKBhhlBfMG617jatDMkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmx.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOnd9cKmpqZZvJbhfYFVvKZqk4ZSa6keNIXe6DQCFSk=;
 b=3JZvzskpSelsgpPt2Jdl236DgSY05gZRSRbFPvodTDlru31KBv2vTnNgsUGsgshxfwC27uPSpbALTFtP70vOFsjWnro9lpQQsE+SZ2FRO81seNeFpim3XgOxU1kwOU0OC/i5TbdZJxsQ5vP7Q4AEKrHqjEYs0x9od+EbXfm4I8I=
Received: from DS7PR03CA0207.namprd03.prod.outlook.com (2603:10b6:5:3b6::32)
 by DM4PR12MB6494.namprd12.prod.outlook.com (2603:10b6:8:ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Mon, 20 Feb
 2023 18:07:55 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::47) by DS7PR03CA0207.outlook.office365.com
 (2603:10b6:5:3b6::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:07:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.19 via Frontend Transport; Mon, 20 Feb 2023 18:07:55 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:07:54 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] tpm: disable hwrng for fTPM on some AMD designs
Date:   Mon, 20 Feb 2023 12:07:28 -0600
Message-ID: <20230220180729.23862-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT010:EE_|DM4PR12MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: 96d1667b-3395-4090-467b-08db136d645a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /EeycqYAO9tsh+Hng0Lvqmwzvdi2vNqM8VthoDA73eVyXPsYl1UPVm8YyuHZnt4mykEP8UUixY3mbCjAUUi+ZwMS7Jxefxk6j+t9VvOddZVtOus2aUMVGYiAoz9RDCd+liii/Tcpj7Y1zHKdujLUd954Gu6I6HJ7Zu7/9GdwY9uzz8b6A6N3YOpGNBwkkkwbbxICH7gPyg7CmO7kS51yhIeUO8W4aBdPFHhHdBdlrT12v57+T1mAP/8Y6Y8BZUPBIOwelQ5cieqsA+J2la83M/wtHZTlwlwptnS4k/cQTtXRVZkGDfm6KAdqxAggiQveKKaRWCJzID678NQSKLfJgjAAPxzyBbzMniRPLZkTvEondFNCovPoeu7goYBtKjZh52u6UEpNtlC6CIB0REnQi/shdWYs1qIKYwik/3SWZ93frq9YxHzPr1bqG3rsow9k0Kw/cYnbEi30KYnsbicmu/frzgbnqXVPOY5CREfE4iskTkLKj78YwI5Z+Oqh5YtGdEw7gbGISwEhuQxTMTn8gSTj8O4LzqagBxXFEWrc511OhAgYmdHj7eztGSDZSw9KVNouFR2dSb9Kbxx4GN45fFc0UYj91HQLqwVMN9eUiC7jSpxiwol5Hl00mJXX0T5Bm1RfifAP7D8Y3vGbV5kNo/eApwT5puHkw+3wDWjFy0lZ2iminsYYNVsyGufUZnkSylIYSHfND+E/e8aTEAPujFQDGQ1aLG1y93mw97pLK4gaDw1vnl5ESyvpRh9/MfByKBPL+ntEnrKHvBnlsSb9cA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199018)(40470700004)(36840700001)(46966006)(70206006)(186003)(82310400005)(70586007)(26005)(110136005)(54906003)(16526019)(86362001)(316002)(7696005)(2906002)(40460700003)(8676002)(4326008)(966005)(83380400001)(2616005)(41300700001)(7416002)(5660300002)(336012)(36860700001)(44832011)(8936002)(40480700001)(478600001)(426003)(356005)(81166007)(47076005)(82740400003)(6666004)(1076003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:07:55.8276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d1667b-3395-4090-467b-08db136d645a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6494
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

AMD has issued an advisory indicating that having fTPM enabled in
BIOS can cause "stuttering" in the OS.  This issue has been fixed
in newer versions of the fTPM firmware, but it's up to system
designers to decide whether to distribute it.

This issue has existed for a while, but is more prevalent starting
with kernel 6.1 because commit b006c439d58db ("hwrng: core - start
hwrng kthread also for untrusted sources") started to use the fTPM
for hwrng by default. However, all uses of /dev/hwrng result in
unacceptable stuttering.

So, simply disable registration of the defective hwrng when detecting
these faulty fTPM versions.  As this is caused by faulty firmware, it
is plausible that such a problem could also be reproduced by other TPM
interactions, but this hasn't been shown by any user's testing or reports.

It is hypothesized to be triggered more frequently by the use of the RNG
because userspace software will fetch random numbers regularly.

Intentionally continue to register other TPM functionality so that users
that rely upon PCR measurements or any storage of data will still have
access to it.  If it's found later that another TPM functionality is
exacerbating this problem a module parameter it can be turned off entirely
and a module parameter can be introduced to allow users who rely upon
fTPM functionality to turn it on even though this problem is present.

Link: https://www.amd.com/en/support/kb/faq/pa-410
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216989
Link: https://lore.kernel.org/all/20230209153120.261904-1-Jason@zx2c4.com/
Fixes: b006c439d58d ("hwrng: core - start hwrng kthread also for untrusted sources")
Cc: stable@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Co-developed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v1->v2:
 * Minor style from Jarkko's feedback
 * Move comment above function
 * Explain further in commit message
---
 drivers/char/tpm/tpm-chip.c | 61 ++++++++++++++++++++++++++++++-
 drivers/char/tpm/tpm.h      | 73 +++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 741d8f3e8fb3..1b066d7a6e21 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -512,6 +512,64 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
 	return 0;
 }
 
+/*
+ * Some AMD fTPM versions may cause stutter
+ * https://www.amd.com/en/support/kb/faq/pa-410
+ *
+ * Fixes are available in two series of fTPM firmware:
+ * 6.x.y.z series: 6.0.18.6 +
+ * 3.x.y.z series: 3.57.y.5 +
+ */
+static bool tpm_amd_is_rng_defective(struct tpm_chip *chip)
+{
+	u32 val1, val2;
+	u64 version;
+	int ret;
+
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+		return false;
+
+	ret = tpm_request_locality(chip);
+	if (ret)
+		return false;
+
+	ret = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, &val1, NULL);
+	if (ret)
+		goto release;
+	if (val1 != 0x414D4400U /* AMD */) {
+		ret = -ENODEV;
+		goto release;
+	}
+	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_1, &val1, NULL);
+	if (ret)
+		goto release;
+	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_2, &val2, NULL);
+	if (ret)
+		goto release;
+
+release:
+	tpm_relinquish_locality(chip);
+
+	if (ret)
+		return false;
+
+	version = ((u64)val1 << 32) | val2;
+	if ((version >> 48) == 6) {
+		if (version >= 0x0006000000180006ULL)
+			return false;
+	} else if ((version >> 48) == 3) {
+		if (version >= 0x0003005700000005ULL)
+			return false;
+	} else
+		return false;
+
+	dev_warn(&chip->dev,
+		 "AMD fTPM version 0x%llx causes system stutter; hwrng disabled\n",
+		 version);
+
+	return true;
+}
+
 static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
 	struct tpm_chip *chip = container_of(rng, struct tpm_chip, hwrng);
@@ -521,7 +579,8 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 
 static int tpm_add_hwrng(struct tpm_chip *chip)
 {
-	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip))
+	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip) ||
+	    tpm_amd_is_rng_defective(chip))
 		return 0;
 
 	snprintf(chip->hwrng_name, sizeof(chip->hwrng_name),
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 24ee4e1cc452..830014a26609 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -150,6 +150,79 @@ enum tpm_sub_capabilities {
 	TPM_CAP_PROP_TIS_DURATION = 0x120,
 };
 
+enum tpm2_pt_props {
+	TPM2_PT_NONE = 0x00000000,
+	TPM2_PT_GROUP = 0x00000100,
+	TPM2_PT_FIXED = TPM2_PT_GROUP * 1,
+	TPM2_PT_FAMILY_INDICATOR = TPM2_PT_FIXED + 0,
+	TPM2_PT_LEVEL = TPM2_PT_FIXED + 1,
+	TPM2_PT_REVISION = TPM2_PT_FIXED + 2,
+	TPM2_PT_DAY_OF_YEAR = TPM2_PT_FIXED + 3,
+	TPM2_PT_YEAR = TPM2_PT_FIXED + 4,
+	TPM2_PT_MANUFACTURER = TPM2_PT_FIXED + 5,
+	TPM2_PT_VENDOR_STRING_1 = TPM2_PT_FIXED + 6,
+	TPM2_PT_VENDOR_STRING_2 = TPM2_PT_FIXED + 7,
+	TPM2_PT_VENDOR_STRING_3 = TPM2_PT_FIXED + 8,
+	TPM2_PT_VENDOR_STRING_4 = TPM2_PT_FIXED + 9,
+	TPM2_PT_VENDOR_TPM_TYPE = TPM2_PT_FIXED + 10,
+	TPM2_PT_FIRMWARE_VERSION_1 = TPM2_PT_FIXED + 11,
+	TPM2_PT_FIRMWARE_VERSION_2 = TPM2_PT_FIXED + 12,
+	TPM2_PT_INPUT_BUFFER = TPM2_PT_FIXED + 13,
+	TPM2_PT_HR_TRANSIENT_MIN = TPM2_PT_FIXED + 14,
+	TPM2_PT_HR_PERSISTENT_MIN = TPM2_PT_FIXED + 15,
+	TPM2_PT_HR_LOADED_MIN = TPM2_PT_FIXED + 16,
+	TPM2_PT_ACTIVE_SESSIONS_MAX = TPM2_PT_FIXED + 17,
+	TPM2_PT_PCR_COUNT = TPM2_PT_FIXED + 18,
+	TPM2_PT_PCR_SELECT_MIN = TPM2_PT_FIXED + 19,
+	TPM2_PT_CONTEXT_GAP_MAX = TPM2_PT_FIXED + 20,
+	TPM2_PT_NV_COUNTERS_MAX = TPM2_PT_FIXED + 22,
+	TPM2_PT_NV_INDEX_MAX = TPM2_PT_FIXED + 23,
+	TPM2_PT_MEMORY = TPM2_PT_FIXED + 24,
+	TPM2_PT_CLOCK_UPDATE = TPM2_PT_FIXED + 25,
+	TPM2_PT_CONTEXT_HASH = TPM2_PT_FIXED + 26,
+	TPM2_PT_CONTEXT_SYM = TPM2_PT_FIXED + 27,
+	TPM2_PT_CONTEXT_SYM_SIZE = TPM2_PT_FIXED + 28,
+	TPM2_PT_ORDERLY_COUNT = TPM2_PT_FIXED + 29,
+	TPM2_PT_MAX_COMMAND_SIZE = TPM2_PT_FIXED + 30,
+	TPM2_PT_MAX_RESPONSE_SIZE = TPM2_PT_FIXED + 31,
+	TPM2_PT_MAX_DIGEST = TPM2_PT_FIXED + 32,
+	TPM2_PT_MAX_OBJECT_CONTEXT = TPM2_PT_FIXED + 33,
+	TPM2_PT_MAX_SESSION_CONTEXT = TPM2_PT_FIXED + 34,
+	TPM2_PT_PS_FAMILY_INDICATOR = TPM2_PT_FIXED + 35,
+	TPM2_PT_PS_LEVEL = TPM2_PT_FIXED + 36,
+	TPM2_PT_PS_REVISION = TPM2_PT_FIXED + 37,
+	TPM2_PT_PS_DAY_OF_YEAR = TPM2_PT_FIXED + 38,
+	TPM2_PT_PS_YEAR = TPM2_PT_FIXED + 39,
+	TPM2_PT_SPLIT_MAX = TPM2_PT_FIXED + 40,
+	TPM2_PT_TOTAL_COMMANDS = TPM2_PT_FIXED + 41,
+	TPM2_PT_LIBRARY_COMMANDS = TPM2_PT_FIXED + 42,
+	TPM2_PT_VENDOR_COMMANDS = TPM2_PT_FIXED + 43,
+	TPM2_PT_NV_BUFFER_MAX = TPM2_PT_FIXED + 44,
+	TPM2_PT_MODES = TPM2_PT_FIXED + 45,
+	TPM2_PT_MAX_CAP_BUFFER = TPM2_PT_FIXED + 46,
+	TPM2_PT_VAR = TPM2_PT_GROUP * 2,
+	TPM2_PT_PERMANENT = TPM2_PT_VAR + 0,
+	TPM2_PT_STARTUP_CLEAR = TPM2_PT_VAR + 1,
+	TPM2_PT_HR_NV_INDEX = TPM2_PT_VAR + 2,
+	TPM2_PT_HR_LOADED = TPM2_PT_VAR + 3,
+	TPM2_PT_HR_LOADED_AVAIL = TPM2_PT_VAR + 4,
+	TPM2_PT_HR_ACTIVE = TPM2_PT_VAR + 5,
+	TPM2_PT_HR_ACTIVE_AVAIL = TPM2_PT_VAR + 6,
+	TPM2_PT_HR_TRANSIENT_AVAIL = TPM2_PT_VAR + 7,
+	TPM2_PT_HR_PERSISTENT = TPM2_PT_VAR + 8,
+	TPM2_PT_HR_PERSISTENT_AVAIL = TPM2_PT_VAR + 9,
+	TPM2_PT_NV_COUNTERS = TPM2_PT_VAR + 10,
+	TPM2_PT_NV_COUNTERS_AVAIL = TPM2_PT_VAR + 11,
+	TPM2_PT_ALGORITHM_SET = TPM2_PT_VAR + 12,
+	TPM2_PT_LOADED_CURVES = TPM2_PT_VAR + 13,
+	TPM2_PT_LOCKOUT_COUNTER = TPM2_PT_VAR + 14,
+	TPM2_PT_MAX_AUTH_FAIL = TPM2_PT_VAR + 15,
+	TPM2_PT_LOCKOUT_INTERVAL = TPM2_PT_VAR + 16,
+	TPM2_PT_LOCKOUT_RECOVERY = TPM2_PT_VAR + 17,
+	TPM2_PT_NV_WRITE_RECOVERY = TPM2_PT_VAR + 18,
+	TPM2_PT_AUDIT_COUNTER_0 = TPM2_PT_VAR + 19,
+	TPM2_PT_AUDIT_COUNTER_1 = TPM2_PT_VAR + 20,
+};
 
 /* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
  * bytes, but 128 is still a relatively large number of random bytes and
-- 
2.34.1

