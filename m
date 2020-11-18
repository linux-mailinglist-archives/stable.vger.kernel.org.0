Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704C52B8227
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 17:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgKRQqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 11:46:17 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:55915 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726092AbgKRQqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 11:46:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605717973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=cmcIjFIbtvBBScGlkST5GqjI2+Ov1HAFOGsHJN5t9ek=;
        b=HPpXqrEWZl2ewX+VGjV5BMu7fuZjuaag4G0mrLsTTA+erGDRER8kP4GYTJfdg1rtWjNxqQ
        rMskjRDbVGSJNjtT4yWOdGm0boZel86Yrm+TXFjByfEbEIMDWMIWa/uK8FuFg9FVpIpu+C
        zx40IMs942whvEXMMaFmKwGuHIme7cc=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2056.outbound.protection.outlook.com [104.47.12.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-10-9P5Okzf1OR-hCFi2-Oiu1A-1; Wed, 18 Nov 2020 17:46:11 +0100
X-MC-Unique: 9P5Okzf1OR-hCFi2-Oiu1A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdubxSO7qT0+THCv4ExFzupCD8u0PUTzZ2Gk/hRh0T4ggz4KGE/uoRHMCL+7rTpX3Gq6EQInZPgAgpQqYf86H3TDwH+7LqguDsPzTWV7b2ruH1RiAQakekKJdPGfTIaaux+SWmk/Cvi35G3ef6lHmHMjY7Y98YqGQEV1jt6DgZX0T6H1AjP2A3LtkTfuZ53VKgvBenJ4tgl44Y+98w9purrVt7AXesAw8Ve7JPagEbOWcptrC8kSCe269kdLwv7n1/ngG+Uigz4SK/KNDhChiXkqtCKPO4nAwUaOVTz09tI6lh7tGjy3gapLCug56BDeZKohV2+2ozprxKMKf4rKSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmcIjFIbtvBBScGlkST5GqjI2+Ov1HAFOGsHJN5t9ek=;
 b=h3UkUDe8CzTsr7xzs5CRxaR6h8IE0DUmepPbFwnXCIiYBPAoNukdnA5x2pvBa8PS0r374etGp9v9e9WGVuXBOZorZGLKYF1HtWUwotDMQ295TmcZsyN2LKFrR98nq3lqGSawXfBjlullgWvyE5f2dyw02Pf3idYB15ZSTt1DbtTcxZ4Dldra8ODep5kv/FzwNL7nNqj60QfOqyY3dodpvzfD/ZjytGu7G9Yl9ghCNWTfXLy1YbuAVm9bVfXhRHEe7F0pXDhKDVCv4hLDxmuOmDKoeXlSiEFK+9jT5OWozXdLYGLS19bbwwDM7timb69wVkPU8S/aKRCTc+emai7Kzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB5643.eurprd04.prod.outlook.com (2603:10a6:10:aa::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.25; Wed, 18 Nov 2020 16:46:11 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 16:46:11 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, xni@redhat.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        neilb@suse.de, colyli@suse.de, stable@vger.kernel.org
Subject: [PATCH v4 0/2] md/cluster bugs fix
Date:   Thu, 19 Nov 2020 00:45:52 +0800
Message-Id: <1605717954-20173-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.135.93]
X-ClientProxiedBy: HK2PR04CA0078.apcprd04.prod.outlook.com
 (2603:1096:202:15::22) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.135.93) by HK2PR04CA0078.apcprd04.prod.outlook.com (2603:1096:202:15::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Wed, 18 Nov 2020 16:46:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ce2df2f-501f-453b-ac4a-08d88be17436
X-MS-TrafficTypeDiagnostic: DB8PR04MB5643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB564395D68F46AB0FF66A871297E10@DB8PR04MB5643.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1gx3y6xo595VHbzQBChbHBDeioUl3wiXs2TEkGh796FRWvKGCsP+IFNVjPLbeim/nfoAc+BCOrHzCVNX6lplEqjAPyyHoULcUUnkvuhbWcktZRTKEeBHbWav1S6h02SXa1z7NmuArPo+auwhHSIKgh+uEycRipJwm/0KYg+eCLWO+duqnLFw1Y75YGSsBYu3sgwNO6m8GU8CJz8PQ06dF7JipvuPpgbbAuOpZeDkT8DF/FER3aAfenS1eXPmUDA7mntc/eBZBv/X2/QOwrO2bb//EB47EL0QkInGemvaL3/ZFnl6F9pf+xWv/sfFQwTZ8Q4VdMuVfG6Ol55GjvNmSB09KyAHmdLoCQjwoCUMlq4+RItZnZ1UOGQanWaX+sfv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(136003)(346002)(376002)(6512007)(8676002)(6666004)(66556008)(66946007)(4326008)(16526019)(316002)(2906002)(478600001)(2616005)(5660300002)(956004)(66476007)(52116002)(186003)(8936002)(8886007)(86362001)(36756003)(83380400001)(26005)(6506007)(6486002)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3PpzJPmvdsrq4PBrVYbauXVahuRRhiTsnXLc3iZWN+HKgdAKXRKd0lyo8WAxRWiX4SJzfbYcFyx4Uc8jOD0xq5sEPSghuI9GBAtB2lo2brduDbasOMLfUpeomybhEih/DE2qiYg3freoyXYWRlklbQQF/+flb0bCGfvBfDb3FrKoqd3PP9Gm/t9p/7DuQQPDRuj5UlwznmsLhJBEh77Ym/SVS9AnVhIbFM98Vo5cFYPY79EFq8g2+vYHNOFRPYSJ1WdeWHV1S19xUVhBDYpAz+3lFsTQWe2EM6l+U5SdLY6QmewzpPv3Y+QHsXxq+xlXZQmdyGg2MYYu7vMb8eutP8I0xGViEAQvNQVoyH7xG3yY3jq5y/a0OPrSn1dBf7F0gKV+O4+ih0H05WG6rfVvVll7vg5rtsu9UqaU5ncaf6oacA3PePgJ2/796JRsT2u6wnsuk9LTYZK8qJ0ObLkZMAprBVlKHCXOT5ITKCkluS5xU1zKiHZtt47n7khGJrcbyWqq3SHkcxuHMHVI7x4q050r0QTwDhniqxLaoJR69EE9GQyxnAUGfzQUZjifkusFXRhztp4sxyyDdgNA3mcPW3Ou/Cb6dUdGEz3lVUcD6noQ55yBlnrTUfwY9RnR6JbYAJliFVEBmApXNboyEHSbXg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ce2df2f-501f-453b-ac4a-08d88be17436
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 16:46:10.9616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YwMQERir/J4mERv+8D7nTEfdeBYJjK8VxNAKl/LyUPPYzMQZyExW1g5W1ZT+ur0e7fFKO7/xBF2/pYVXQQhmfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5643
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello List,

There are two patches to fix md-cluster bugs.

The 2 different bugs can use same test script to trigger:

```
ssh root@node2 "mdadm -S --scan"
mdadm -S --scan
for i in {g,h,i};do dd if=/dev/zero of=/dev/sd$i oflag=direct bs=1M \
count=20; done

echo "mdadm create array"
mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh \
--bitmap-chunk=1M
echo "set up array on node2"
ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"

sleep 5

mkfs.xfs /dev/md0
mdadm --manage --add /dev/md0 /dev/sdi
mdadm --wait /dev/md0
mdadm --grow --raid-devices=3 /dev/md0

mdadm /dev/md0 --fail /dev/sdg
mdadm /dev/md0 --remove /dev/sdg
mdadm --grow --raid-devices=2 /dev/md0
```

For detail, please check each patch commit log.

-------
v4:
- revise subject & commit log on both patches
- no change for code
v3:
- patch 1/2
  - no change
- patch 2/2
  - use Xiao's solution to fix
  - revise commit log for the "How to fix" part
v2:
- patch 1/2
  - change patch subject
  - add test result in commit log
  - no change for code
- patch 2/2
  - add test result in commit log
  - add error handling of remove_disk in hot_remove_disk
  - add error handling of lock_comm in all caller
  - remove 5s timeout fix in receive side (for process_metadata_update)
v1:
- create patch
-------
Zhao Heming (2):
  md/cluster: block reshape with remote resync job
  md/cluster: fix deadlock when node is doing resync job

 drivers/md/md-cluster.c | 69 +++++++++++++++++++++++------------------
 drivers/md/md.c         | 14 ++++++---
 2 files changed, 49 insertions(+), 34 deletions(-)

-- 
2.27.0

