Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90D04FAB13
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 00:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiDIWrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 18:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiDIWrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 18:47:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12olkn2024.outbound.protection.outlook.com [40.92.22.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC6922475C;
        Sat,  9 Apr 2022 15:45:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DquxnYX9siIWHDr/xDYEN2bx2LoEou5XhWH0C/jw6JNIu56sZ/4cCxI2W3fa+q6rmyzYMoan6llrDxAp8V3yILkbfL8pO247U4MQw6IqfMymIoITtBknUVZJVjuARiNneKzFQZd+eSAfMDEMe9Vzdh1brrW6t0ynDwWOpxCERPbUmvMGaUQAsKh8IwXQ0BUu8mF9oG7AJUst1/jY8p09cz7P+bHsvLq4ydpSHYuEMYpugFrwl9tWR3+C4RLru1fyCD6mt5PRN3Lpeoe56hm1lSFjcG9tCTpeeAARKvYMmsNl6hDGG2VfUPfXmksmEy2721zdptUiWXOvu2eeAh+dxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iyy/BOXv5yg/C7ssSVFuz8r1FqS/uuZxbpPzJ8zmlXQ=;
 b=Qlgwo7vty6Onz/NMkDW23hHQmLLpX1NX0/I5fDZ4X1eE2uahu9oaQuz7LdSGWnO+NeL9RpHPZhCkS1pooz17PxvSoNw72xQRYUwKVlP3+EyvTQV8rkQIsS5Azl4io7/W2UsmiRJZT96C35/9iNYpeXAoXiu09OAtKWqOOTxG0bdyt9zyrheZUr7+I1CLQxLzEbXg3rIed1xqKba2Yhnn4HJJSNci+qGv2CJt1gNUMhb3/4QrmO+mA3OopN5OY7/T9Us5oB2XEWWukD9mMQW3YGGJL9/Gl+7K5KkU0302QwTJWOGOsTS/h0wDhtRSf1f5UvFSysY4df2YohibA8HTfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyy/BOXv5yg/C7ssSVFuz8r1FqS/uuZxbpPzJ8zmlXQ=;
 b=ErxOCprKDuKxMaeAHRYyVrgpLrdvpnaJblAkOt1DUZLajvLzNXj0MjQFF/81WUv4vsrVV0q3Dv1sz5qpk+8TWlk0BfWX+RDgxUOguLp8J5B7SZc+/Bn2ByRBSkz3PUwq2+rm628b5+pWBWVxUssdIX+S6svHRYScXOrEH12csFjdKGa9SqPzQ5hqLJv6eFzYvS4+0TDimqhwNnWgXz04F/MHYwjFHtk0uzFYB1k9FLGMac5yKwCFWSrLJfF6XRlsqWpFWjEDpdGbv1p+Z9LbRCyGkWbCZ82rw5TFTRoKRnTTTosFVJsqPLX/odty/D2DQcThGwe29Vp4dBCbIiIbRw==
Received: from CO6PR03MB6241.namprd03.prod.outlook.com (2603:10b6:303:13b::6)
 by MN2PR03MB5293.namprd03.prod.outlook.com (2603:10b6:208:1ec::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.28; Sat, 9 Apr
 2022 22:44:59 +0000
Received: from CO6PR03MB6241.namprd03.prod.outlook.com
 ([fe80::98cd:da57:6117:c992]) by CO6PR03MB6241.namprd03.prod.outlook.com
 ([fe80::98cd:da57:6117:c992%6]) with mapi id 15.20.5144.028; Sat, 9 Apr 2022
 22:44:59 +0000
From:   Tao Jin <tao-j@outlook.com>
To:     Takashi Iwai <tiwai@suse.com>
Cc:     Tao Jin <tao-j@outlook.com>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek: add quirk for Lenovo Thinkpad X12 speakers
Date:   Sat,  9 Apr 2022 18:44:24 -0400
Message-ID: <CO6PR03MB6241CD73310B37858FE64C85E1E89@CO6PR03MB6241.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [ICOZYkYu0rTz0KlrLcSv1G4xFuUCsMjw]
X-ClientProxiedBy: BL1PR13CA0394.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::9) To CO6PR03MB6241.namprd03.prod.outlook.com
 (2603:10b6:303:13b::6)
X-Microsoft-Original-Message-ID: <20220409224424.5799-1-tao-j@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e9035a1-7931-4bbd-a83e-08da1a7a9379
X-MS-Exchange-SLBlob-MailProps: CaK+F7me6CmnDvzDWcGIx3iUI0Ph/HzgjFKSm6FW9MK6Y9hSoT9A6xvrKwwmv5fl7UURPKv7a2iaYHQgsablZuIPqmXdG06w8F/cugNb1CJplgvgQfVHDLckdViqVIUEXn9U3hHnF4JjuOPFe3oHC5jJ3mc/zBgt6uc+ALS+1NfJyuRFXNHdKl5XHBqAcMWmybOm1UEwFZW96vICkOxO0xA/HNbM8ezDUN3ElJblV7l9EFExmRfNC7SH7tT4Cn3B2Un8kj95RNbKxEG1B9Ay86+kEDQcADqVVdeq3ymJ58+6VykbF5kL8jvkkSM7scjeamZ+MfTNELMICIzp3YWvnGhEVyOM0QF0GQGvKtMYJ+0jKy7aouba+bjHsPemhByvy8lMk/APs4eUo5YeVrChu+QLfgjxbJm2gAKGHw464NxwSpguP1gMRKKcJTX3x07AOgYA6FvVfgnqf3zsA8Q0sZOwuz41xOArLUPfMNbpWqAgp4KUhkNXVtoB4QpZICsVgtaAm1qA30wwSSlbhGi73/3jF664fEUkufxtlZHnFXDxVmlYRoK3v31e5tGOe+VhNwGxHXpopGMT4dwyp+54ggIQO/IVYoVPbcO/sWlknEInaqQfkqANrnpt7+pyAeE7/FTZMbwrCNgYMIC/lkuJZwgPvsEOHcHRyZcD8adDyrC34dIMgatDzJl3R6zjFk3At+XA6mnqMVRMkW4pUw7z+ESk/g/SwrL+Ijvzg7JKdBwJRxkjRyFjDQ==
X-MS-TrafficTypeDiagnostic: MN2PR03MB5293:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7+zw4isalb0CDZ+W50eRFgp9Ws53gmi4etwB+T8jhB98122yJJkCB+5FOQou8StBogPnwPr3F4frsu+8RZrqAPRZ/T4mU98rEBL61vuxM7ERJzZ+0zmkR4/8axUi1PFtUZ5JjJVT8LFjGBzWEIeN30A0LudQ2lSK6ji5ZXyLc7gBmQBBHRf2VocoTlAovS5QSIkr1RUIHKcmRZPEN/kq6aErLQLZSbpr/bjpS+EZ+hjG3jAmEXNiJNhmsgscKqxVq54MZOImwU5gV+f/DYu9cm13ol4P3BOHdTSXq0n1zCN1VyHQ8SGbd17ilVtwbaTnqHxOaedBRD4WiB5xj6x4DzA5Y5PzHNsFqUTo+cgefCKEX4yy9feV+gWvwyiOOovoB/wzV1Pu4vbC+R1RHTuxMrhCYG7obvtO1wPUQB5vKIBNcdKHeu72G+Fs0+uwTpTM47iwzlYNdnX3zUYNs5MTBQ7+qrbMMEicPuvPippe+Q2rxs2/1Omex06lED9lfZIu+Pi1nyLNqumrHDqA8Ih2OTry1SU9A9rdYpYf+PstWb+gvD51LuoV1njyJQhxdfINCu922aQBoifnDRSSDJfYGw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9tFugCo49xt4cDEFMPrAR1SVEUqrPrqCpw8pa+IaIMOJHiW40UD/nKV70gsG?=
 =?us-ascii?Q?iqwKH0Xi5VHGcshQaBCsou29hUdQWpt0Q8nE0EjOCBi0YueZg8SPtCn0xZYP?=
 =?us-ascii?Q?9xQvNNge8qFux2VI4XPc+TEb/fJHfnO4tKcpguscA6P+PBqvEYXwVpS04yYp?=
 =?us-ascii?Q?hnd6UpM9uh9hYi7eGhuuqlsBQC0lHpu9DlC5cKc7tH3gOhBMnlpes2s93VJn?=
 =?us-ascii?Q?erO7502xKc+/6yS1wSTmRVb4rYiS0pghujUtgazaQOA29f7kgSYM0sLXS1qv?=
 =?us-ascii?Q?ITHHnjGZ5RiCaNKZWubGax1HUJeNY3d0XMGlFf/UamCoIY4q7kyj8tBdPcfm?=
 =?us-ascii?Q?wUcpKyaUP2ARV00la1si3GUfn2oAV2Yd5+8++IUsNfO/cij1h+inHprXiUCA?=
 =?us-ascii?Q?1uQU/DxWF7LRYSfkGHC2ijW9Iqq+T4bWDwTXF98F0ZNKlQVRlki4FtcnAZII?=
 =?us-ascii?Q?HcE9wG7dWuwLPOBJyKGFM7DWl2bl6NgY+YdT9SufCBHl/9hhLbvJgNHoObdT?=
 =?us-ascii?Q?op+oM49fw+EiARzk6U97pdETJva2hG3tF9xmFu34X/TmeJFe5XYxSj+wCTAZ?=
 =?us-ascii?Q?+0SAiQJ3p7nKCSPLKi3Nwc8rBldkGEoD2aCM1EOeZAJY2Ct1ydXk2nszsUma?=
 =?us-ascii?Q?vKSrgErsWnYeBzDuN73XY2RDkk7uMCNCc2dnVdl3Axc2eumFZmQgMDb7w43q?=
 =?us-ascii?Q?dmKm3QNdGbjcLiNcy9Ik91OwtSFk0edidxH/VDPboQxnSWFx260KcppfGFli?=
 =?us-ascii?Q?JNfgP2tCWO8bKuQT0hdagQFgamYBWCR+EYu0/iEwui0wpbftbSdDjEvbKcv6?=
 =?us-ascii?Q?fH7NREiz+NKuRyPMp0JKJlyMST9MzTHVxYjtl7l3OO6mHOI0P8IWNAeK2Jn8?=
 =?us-ascii?Q?rz77KfDDZdmrDPJecRHiIxj5Tjzxm0x4DzzRjUUMgrCk0Mu4ixgxv8YdySdP?=
 =?us-ascii?Q?ZTgKy3NqOWHEGrduXzLkvhqi8UHpM27JuqRDlSWSsdPIWignkOfqONPEju16?=
 =?us-ascii?Q?CYhVNolIkJcM5XjVXNmEvpqGfmG/6EG1oy04PRwoTO+4HuAZrAkLK3WD0/ek?=
 =?us-ascii?Q?sqO/NwNkvtWexhXs9hqIJqwRVLTnKSJ0I3poltSk7UWC97nVTxOWfEaf1uZf?=
 =?us-ascii?Q?We/DN5dQo4XG+o4rZ+xx7fu6DGx89powhz1jc+R4wYaJd2h6/q13VCxBSXXB?=
 =?us-ascii?Q?FytSOGbcF7LosLoDmFr3wIl9yZjyOE4CE8gXyq7BeHaGDVBCtp9LcwIL43aP?=
 =?us-ascii?Q?qmfM+4oXA2bqG0tA1zs/kfGGNtzLoeLR83bBZHbTZtG30cD5qXniDkU31213?=
 =?us-ascii?Q?EDgHQJP6rPmI47pm5EvVKyuDshBI/8cWrkqNuim0sZ9Ny814YlHYEk7xf79l?=
 =?us-ascii?Q?Ci8ENop/ZfWF04ODuUpjv7MNbyuNtypPQNnJOfvKOfRzNYhXZq2WNzG071+L?=
 =?us-ascii?Q?gfApl9Rri2E=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9035a1-7931-4bbd-a83e-08da1a7a9379
X-MS-Exchange-CrossTenant-AuthSource: CO6PR03MB6241.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2022 22:44:59.2027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB5293
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For this specific device on Lenovo Thinkpad X12 tablet, the verbs were 
dumped by qemu running a guest OS that init this codec properly. 
After studying the dump, it turns out that 
the same quirk used by the other Lenovo devices can be reused. 

The patch was tested working against the mainline kernel. 

Cc: <stable@vger.kernel.org>
Signed-off-by: Tao Jin <tao-j@outlook.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 75ff7e8..a5d6f8a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9207,6 +9207,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x505d, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x505f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x5062, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
+	SND_PCI_QUIRK(0x17aa, 0x508b, "Thinkpad X12 Gen 1", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x5109, "Thinkpad", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x511e, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
-- 
2.35.1

