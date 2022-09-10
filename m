Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C075B4768
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 17:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIJP7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 11:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiIJP7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 11:59:08 -0400
Received: from GBR01-CWL-obe.outbound.protection.outlook.com (mail-cwlgbr01on2126.outbound.protection.outlook.com [40.107.11.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8618B402D1
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 08:59:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlvlVuA9VyclvYsWYrihUmXbIjofQESqdWUvIrdRSV9yfOM5895sYiUP5vSANAWOXaHrDRL+LRM2V2+Fd66pgLq+2XbrATERBaCIT6udZ5zAaX04h0rr93CrIlrbNNLqlBlCVSUF8gg4EB270ex7rZJQydESnDq3OGXireJ20yOkGylrAKYEjK1nz9gPf5xjkDyxbS/7DaqdtCq4IOa6WZqOq5CavnaZhQUMkRWdyRy7ax5d6MBYjuXvgNd3lxOXRJP8D2sNWNj7G1NqHsiuFMA5L5k5q7t7qTOx6zTsh8SA2H2/up6hyU7/hyMr2cwiaB1U2mwgOXzVwHjvUm5wdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQR2LTEtHvl4/e2tquW2mogfyx8XwEwEkXLLMMr7x2s=;
 b=WRWYSO5Zsddhi9qUA/sG6cr2gdRaiejmcuJ0DxueIVJ+B5nwbDeaZ+HIczwI9UrY9AUbpdY25oXRErP1iuGF58DW8eWMMxm/vPkOKYlOGL3SW0Rm1jkvqzHmUkDLjVzAVxiCwYxh8NnxwFjtTvlAd/h9f6J9DEZw3oBj6GiovkVQ2x3wlw2FgekMKLmjnKYdeTBY+asEvgSuw9UoOOziX5cFfNNCs363CL39SeE7mvFQnvZTo+W006If6rL84zVsoR74K+mSv45rDP5PVgjR+F6UUNbYmRffB+V4Lb75cDd3bNmkaf3xD0y/eZVeEsnTZsr80j70yChntF5RolxUYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bywater.xyz; dmarc=pass action=none header.from=bywater.xyz;
 dkim=pass header.d=bywater.xyz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bywater.xyz;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQR2LTEtHvl4/e2tquW2mogfyx8XwEwEkXLLMMr7x2s=;
 b=k4kKSsgp40ofLdWTdqU5Dax/UIJL0t3DGIH8zd6NpYmncSGgqgDIQLFp1usHHBmSGeKyX37vnnII2DQyDRATBWPaVLgWMwVMnReiED7hLhDzGjfl2VFydBCWH15a9wwqZ4AgCK4GecC8U6yLyPfMOXqGcrbH/ruUHaCyrhX47u25jh6tJsDTJpjLC3G2VYtAMDxG8dIqC7izkygYclaeVUdHBm8DxI+E1mmwCA1AAFRB3TJvfu/aL7kzz7nqSizRpCGDBq7ws6fOV0nD1ZqzHyMINiGR7P987nKqD9vrxFTQLHBBEY4IiCjMCiN3Fra/00x0sBXkC8y5r65+3epGxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bywater.xyz;
Received: from LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1f2::7)
 by LO4P123MB6466.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:29a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Sat, 10 Sep
 2022 15:59:04 +0000
Received: from LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
 ([fe80::e11b:26a4:86c2:f2f5]) by LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
 ([fe80::e11b:26a4:86c2:f2f5%8]) with mapi id 15.20.5612.022; Sat, 10 Sep 2022
 15:59:04 +0000
From:   joseph@bywater.xyz
To:     joseph@intrigued.uk
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Paul Moore <paul@paul-moore.com>,
        =?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 05/50] landlock: Fix file reparenting without explicit LANDLOCK_ACCESS_FS_REFER
Date:   Sat, 10 Sep 2022 16:58:08 +0100
Message-Id: <20220910155853.78392-5-joseph@bywater.xyz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220910155853.78392-1-joseph@bywater.xyz>
References: <20220910155853.78392-1-joseph@bywater.xyz>
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=15510; i=joseph@bywater.xyz; h=from:subject; bh=kgvaq4IVEHbobuY1Psxg5hFTvSA/qRQ7oRx8EjVXA30=; b=owEBbQGS/pANAwAKAXxHkY8fXCH/AcsmYgBjHLQETfL3lXuaTKbUnDrzGvEUlD3nGWgaq0S2y91a wdFdyD+JATMEAAEKAB0WIQRiG5oO6weufXC5rRB8R5GPH1wh/wUCYxy0BAAKCRB8R5GPH1wh/3N0B/ 9IYc5jSN7Z0pu3TS1+opOPfjG2dbagT729zHMMCM3n0J4AM4OrYHXUzklsiapF6VKs1wMRY73SSoKz WU1ByLkRud6WXgM1r8NPjuxPU0QgDafeQUVhsg4fQ1/ht+aVRBGUSl6rPLgGHAYr9r3IPtIeNdG/OH XBsd41SpNVO9tErelJMs06L/YA6OoASwfMhv74TUcR3IRl9gz4hoCjh7zR21pjKCuRK8MCl7nHf84u kV+cBNAoa9Z58bbnct0NA0f2+6k5y4zucXTtTawy3Co79TumfYKt0/a5y0Z26+z3dmppxTCVJ08P1h /HyBftoBqYdy1o9RnVyfWBY8sXtg2i
X-Developer-Key: i=joseph@bywater.xyz; a=openpgp; fpr=621B9A0EEB07AE7D70B9AD107C47918F1F5C21FF
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0093.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::8) To LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1f2::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO4P123MB4995:EE_|LO4P123MB6466:EE_
X-MS-Office365-Filtering-Correlation-Id: d2af8a02-161e-407e-3298-08da93456290
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: datxsL3GiSHZJy4TsCiNqtpcGz7ogB3cZz6KeMpZ8A2mJlb+0oXP9+GxSWi7Dq1LeLlPQHcG3hLM4ahyC299nHmNz4+BWn5ZjX0YpQn5d3xlCANhHm21530xZkJCukkoxkZQbbOrNBJa9iXAqy6tgLpOJr1gYi6ZkfCndalttUt4txko/+khY/eDdGc3n4MBM4+gdfYWbT+QN7SaA8HmupTx4KKNahDwaN+xRQ/USnUFwG+3zP5esrgsFONwDW3sEE+EGxXtCkss6WGQ3SeT4VvYWoriEPl4Sa+kelhfLsgbptbBivymmUS3eEfNevP84ebh7DpPM1aKxp21Sdd4JYE2ffT47x7sOWpy5o8s+HLO+CCpsutQg652V3vnh5bGNI23WRNPt/lfY0GCfz+Acu2Ql73oIaxtM3t+l2Kkz9psmWdKJQln0596yh/5AH5nJ7SdEQ0x10GLzybM2Pj0TP9Rk/Yz1PmKowa092F7ZXBrGZk2s3P5CrvmDpAPLco3oj6oAQ0nnQH70FVCNsv4zhe1Vv79F3TnLclvc39C4ZhaW+E5pA/m4krv1DeMOfAPGRpkd6Y82iMgTyMFAL98q5TNVh2cwuoIubBDjkTzI+rknIYh5IXgX/8z7MlhdN8a8Gh6yPSGrMRVXkiAalAtJv8BTLYuF+19Z4PStmleoVupONoGxdJIPSKHmTnsqefGUxFGP30OgFsypJ5SDk4L3ZS5L9FJimW2s+Ck95vVJHSgQFrX70r/43k9PkVc21jIEIGFIsN/YyVEzPbxZg4uRG1baWT8+2zdcDeAHEKAJXs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(346002)(396003)(39830400003)(376002)(83380400001)(30864003)(66574015)(54906003)(966005)(316002)(6486002)(478600001)(36756003)(2616005)(2906002)(6512007)(9686003)(1076003)(6506007)(186003)(52116002)(86362001)(38100700002)(8676002)(4326008)(45080400002)(5660300002)(66946007)(66556008)(66476007)(8936002)(41300700001)(34206002)(4720100020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VndiczZ0TTJTMmgxSENRS1ozRFVVS0EzaUZnSEQ4TjBHampmQ1ByUkhzNkFQ?=
 =?utf-8?B?N3ZvUE4yV0tYU1V6N0dmeWJtWWYrY2I2K1hBYlhGU21jUWgyZ0pVekdnZ1Ny?=
 =?utf-8?B?eDIvT1BNQ2dNUzYvTjRiRTNYR1VBQVlqclN4UFgwZDZYMzlrNGd4VGpwRFMy?=
 =?utf-8?B?WWtEc2Rwak1la2cwVHV5MGE2b01aNUlSNSt5QnEvcjRaRnhMcFVaYzhhb0dJ?=
 =?utf-8?B?RTI4OThpcVlRaWV1aDBsREdQd2IrcE1vamlxclFVUG1vaXJsTlZIRFZBZFF4?=
 =?utf-8?B?S3BZaGpaMEpOKzVYUlRzNUNPY1J4Y3BWdW5DTEdSMVkxeHdqUFJwZC9veDBZ?=
 =?utf-8?B?cUVrRzNlcmRJM2ZwNFlubXBRd3VmdkV4YVIyakhsMHJjQXZVRjV5L1NNSXBo?=
 =?utf-8?B?Vkt5ZUxETXlHellDVmZOZDFtMFRTTGVRREJ4cE5YcUhGYXVEQ2FSUE5mMW1M?=
 =?utf-8?B?ZzRPbFJONlozRFlLYWlHSU1oSEFXVnQ3bnJyQ1h0N2F0dld4Z2xvdG1SczZT?=
 =?utf-8?B?bnVFUTMxTzc1a0kvUWNFNmJXNFFta2M5QmlMeG5Yb3dhTDY1cXhFUnkrRyty?=
 =?utf-8?B?bTlXWE1qRDRPWWxHK05aMHdNWlB2TFFmeXQ3M3JpNzdGZlZ3THpYQ0UzRmdu?=
 =?utf-8?B?YmdFb0Y2dEg0ZEp6THUwMmF0RkRHbHFDbWJtdFovQjR5MEprTGVxSk5IYi8w?=
 =?utf-8?B?bGtheXlLSWpNeFVKYmFFRmhkWnNRb3lucVBEVk1FQXRJMWRmWjFpa1hMbGo5?=
 =?utf-8?B?Y1ZQbW4veXpSNmlSaFBEM2F5MXVuSWRxSm9qSjJCY0wrdFFXUndGcWlvMUNy?=
 =?utf-8?B?REpqYTRvQlZiQ201dmIvV3RHNlkvOEI2aW90UHY3NW81TGsxUldVMlFNOCtT?=
 =?utf-8?B?SUtVYmkzSWZWN2RYb042cWloMTZzSmVmbEFoUVdsWS9ibFc3Q2NzeTdGRllx?=
 =?utf-8?B?blNjc29ULzFEZVpRcGtVYWdJYUdMc2FtSmF1MDhmc1k0bytZc1RmclJxdkZx?=
 =?utf-8?B?RXRDUExkQTU5a3BuM1pmRVNuSUt0akFuVitCWFBmK2wyRFEvOS9Da04yOVMr?=
 =?utf-8?B?SHVDbXh3cWxoV2F3d3Q0c3dRNkgrSXpRbUtudEZqTFVxRWhFRFdVZDR0d3NP?=
 =?utf-8?B?R3FHWEZSS3J5NTVranhBdnphV284M2xzMGc5MGhJUDlQSGE3VXNRTkEvZ2Mw?=
 =?utf-8?B?Vm1jZ21lT0dNTVhzQlVwclBWOGg4Zk9heVV3Y21GbThPL0hRUDBmYVhLS0Y1?=
 =?utf-8?B?dUg3MFNhd1VSaWN6TmtYU28wVGZhS0QxYlZSWS8wTzJMcXRmbVU2ekxzRE1S?=
 =?utf-8?B?STUrdHl3QnFuNDlQSGRET21vTnlMeG4zOEpla1MzV1I0M1hjMDF4SmIxUDgw?=
 =?utf-8?B?ZW1haWF2NnhLZ3BwUnFSV3luSlQxblVYK2owdUtKdzlvd3A0dmlFZGc2QlI0?=
 =?utf-8?B?MGo4VExZWWFObllsM1lsTnlERGJZNXI0ZUdGRGJsTUM0OGtNR29JNGRqV05q?=
 =?utf-8?B?NU9JOVdnWHZ1b2pIYldDS3lFT2dOdXlJN01YU3FyaSsvWU5TN3FtWllkc1lY?=
 =?utf-8?B?Qk80MWpSTHYrVGpzRTB2eVFValZFM1I5V1owTU9aUVUyUUkzeS9TL3VBbERl?=
 =?utf-8?B?ZDNaRXlCK1lWbXl6YVA1U1d0bnA3OTlLM0N2U2dqZDVSQTBUV1AxSXhNb2J1?=
 =?utf-8?B?dG91b213TC83RWs5ZW1kNkJSOXZtRlBiMFhXS3ZEL090UHJjSEZzQllWdmw2?=
 =?utf-8?B?OXdrWmpwaUE5eWhKUXovdzAyRkpFdlF6akdnRGo4eXp0T3UvdVRvQlJPQWhq?=
 =?utf-8?B?NmNYRXU5RXNDVzJHQWtIMnEyQlpuTEt3OGlmZzZIbSt0b1FJVjNXMXBpYnU2?=
 =?utf-8?B?VTFXL0llbVd0N1dyb1NJU01XT1RWOTEremtmNzNEWWdsRExQQVI5QjFpbCt6?=
 =?utf-8?B?a2dobTJZVzlSSkZHaU0zT29vdzVjZmVwNWQ5MU5YTDVHNTE3dkhFbXh6cHAx?=
 =?utf-8?B?T0dWTWw1K0dFQjRjWVdzcEpKTW13RUJBQzIzdmM5eXIvM1lqL0c3RW5JQVli?=
 =?utf-8?B?QmVDT3IzazhrY2l6eXYrNnVYZTNleG96cWZwQW43WEJzS2pLUzl1U3JiS1BD?=
 =?utf-8?B?YitaY1BvMWdBc2k4T0twR251UFpiSHI4eXdlcXJDUENPWERsd3I2UXZjaVda?=
 =?utf-8?Q?La3U1yUbWM9mQXV5i/KF5Dk4wAqv78P2KqIU3LKBgvwN?=
X-OriginatorOrg: bywater.xyz
X-MS-Exchange-CrossTenant-Network-Message-Id: d2af8a02-161e-407e-3298-08da93456290
X-MS-Exchange-CrossTenant-AuthSource: LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2022 15:59:04.3240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 42dcc6dd-439a-483c-99c4-86bd4e2f0f10
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wWXlx7JnqD7wLsWfEO+e5Vx61vMQzt1akIxrRcIuoRqaLeT5o8IGBD3hnjNy4/ww1XRlMYGZuyM+Og7Yc0vs7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO4P123MB6466
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mickaël Salaün <mic@digikod.net>

This change fixes a mis-handling of the LANDLOCK_ACCESS_FS_REFER right
when multiple rulesets/domains are stacked. The expected behaviour was
that an additional ruleset can only restrict the set of permitted
operations, but in this particular case, it was potentially possible to
re-gain the LANDLOCK_ACCESS_FS_REFER right.

With the introduction of LANDLOCK_ACCESS_FS_REFER, we added the first
globally denied-by-default access right.  Indeed, this lifted an initial
Landlock limitation to rename and link files, which was initially always
denied when the source or the destination were different directories.

This led to an inconsistent backward compatibility behavior which was
only taken into account if no domain layer were using the new
LANDLOCK_ACCESS_FS_REFER right. However, when restricting a thread with
a new ruleset handling LANDLOCK_ACCESS_FS_REFER, all inherited parent
rulesets/layers not explicitly handling LANDLOCK_ACCESS_FS_REFER would
behave as if they were handling this access right and with all their
rules allowing it. This means that renaming and linking files could
became allowed by these parent layers, but all the other required
accesses must also be granted: all layers must allow file removal or
creation, and renaming and linking operations cannot lead to privilege
escalation according to the Landlock policy.  See detailed explanation
in commit b91c3e4ea756 ("landlock: Add support for file reparenting with
LANDLOCK_ACCESS_FS_REFER").

To say it another way, this bug may lift the renaming and linking
limitations of the initial Landlock version, and a same ruleset can
enforce different restrictions depending on previous or next enforced
ruleset (i.e. inconsistent behavior). The LANDLOCK_ACCESS_FS_REFER right
cannot give access to data not already allowed, but this doesn't follow
the contract of the first Landlock ABI. This fix puts back the
limitation for sandboxes that didn't opt-in for this additional right.

For instance, if a first ruleset allows LANDLOCK_ACCESS_FS_MAKE_REG on
/dst and LANDLOCK_ACCESS_FS_REMOVE_FILE on /src, renaming /src/file to
/dst/file is denied. However, without this fix, stacking a new ruleset
which allows LANDLOCK_ACCESS_FS_REFER on / would now permit the
sandboxed thread to rename /src/file to /dst/file .

This change fixes the (absolute) rule access rights, which now always
forbid LANDLOCK_ACCESS_FS_REFER except when it is explicitly allowed
when creating a rule.

Making all domain handle LANDLOCK_ACCESS_FS_REFER was an initial
approach but there is two downsides:
* it makes the code more complex because we still want to check that a
  rule allowing LANDLOCK_ACCESS_FS_REFER is legitimate according to the
  ruleset's handled access rights (i.e. ABI v1 != ABI v2);
* it would not allow to identify if the user created a ruleset
  explicitly handling LANDLOCK_ACCESS_FS_REFER or not, which will be an
  issue to audit Landlock.

Instead, this change adds an ACCESS_INITIALLY_DENIED list of
denied-by-default rights, which (only) contains
LANDLOCK_ACCESS_FS_REFER.  All domains are treated as if they are also
handling this list, but without modifying their fs_access_masks field.

A side effect is that the errno code returned by rename(2) or link(2)
*may* be changed from EXDEV to EACCES according to the enforced
restrictions.  Indeed, we now have the mechanic to identify if an access
is denied because of a required right (e.g. LANDLOCK_ACCESS_FS_MAKE_REG,
LANDLOCK_ACCESS_FS_REMOVE_FILE) or if it is denied because of missing
LANDLOCK_ACCESS_FS_REFER rights.  This may result in different errno
codes than for the initial Landlock version, but this approach is more
consistent and better for rename/link compatibility reasons, and it
wasn't possible before (hence no backport to ABI v1).  The
layout1.rename_file test reflects this change.

Add 4 layout1.refer_denied_by_default* test suites to check that the
behavior of a ruleset not handling LANDLOCK_ACCESS_FS_REFER (ABI v1) is
unchanged even if another layer handles LANDLOCK_ACCESS_FS_REFER (i.e.
ABI v1 precedence).  Make sure rule's absolute access rights are correct
by testing with and without a matching path.  Add test_rename() and
test_exchange() helpers.

Extend layout1.inval tests to check that a denied-by-default access
right is not necessarily part of a domain's handled access rights.

Test coverage for security/landlock is 95.3% of 599 lines according to
gcc/gcov-11.

Fixes: b91c3e4ea756 ("landlock: Add support for file reparenting with LANDLOCK_ACCESS_FS_REFER")
Reviewed-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20220831203840.1370732-1-mic@digikod.net
Cc: stable@vger.kernel.org
[mic: Constify and slightly simplify test helpers]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
---
 security/landlock/fs.c                     |  48 ++++---
 tools/testing/selftests/landlock/fs_test.c | 155 +++++++++++++++++++--
 2 files changed, 170 insertions(+), 33 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index ec5a6247cd3e..a9dbd99d9ee7 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -149,6 +149,16 @@ static struct landlock_object *get_inode_object(struct inode *const inode)
 	LANDLOCK_ACCESS_FS_READ_FILE)
 /* clang-format on */
 
+/*
+ * All access rights that are denied by default whether they are handled or not
+ * by a ruleset/layer.  This must be ORed with all ruleset->fs_access_masks[]
+ * entries when we need to get the absolute handled access masks.
+ */
+/* clang-format off */
+#define ACCESS_INITIALLY_DENIED ( \
+	LANDLOCK_ACCESS_FS_REFER)
+/* clang-format on */
+
 /*
  * @path: Should have been checked by get_path_from_fd().
  */
@@ -167,7 +177,9 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 		return -EINVAL;
 
 	/* Transforms relative access rights to absolute ones. */
-	access_rights |= LANDLOCK_MASK_ACCESS_FS & ~ruleset->fs_access_masks[0];
+	access_rights |=
+		LANDLOCK_MASK_ACCESS_FS &
+		~(ruleset->fs_access_masks[0] | ACCESS_INITIALLY_DENIED);
 	object = get_inode_object(d_backing_inode(path->dentry));
 	if (IS_ERR(object))
 		return PTR_ERR(object);
@@ -277,23 +289,12 @@ static inline bool is_nouser_or_private(const struct dentry *dentry)
 static inline access_mask_t
 get_handled_accesses(const struct landlock_ruleset *const domain)
 {
-	access_mask_t access_dom = 0;
-	unsigned long access_bit;
-
-	for (access_bit = 0; access_bit < LANDLOCK_NUM_ACCESS_FS;
-	     access_bit++) {
-		size_t layer_level;
+	access_mask_t access_dom = ACCESS_INITIALLY_DENIED;
+	size_t layer_level;
 
-		for (layer_level = 0; layer_level < domain->num_layers;
-		     layer_level++) {
-			if (domain->fs_access_masks[layer_level] &
-			    BIT_ULL(access_bit)) {
-				access_dom |= BIT_ULL(access_bit);
-				break;
-			}
-		}
-	}
-	return access_dom;
+	for (layer_level = 0; layer_level < domain->num_layers; layer_level++)
+		access_dom |= domain->fs_access_masks[layer_level];
+	return access_dom & LANDLOCK_MASK_ACCESS_FS;
 }
 
 static inline access_mask_t
@@ -316,8 +317,13 @@ init_layer_masks(const struct landlock_ruleset *const domain,
 
 		for_each_set_bit(access_bit, &access_req,
 				 ARRAY_SIZE(*layer_masks)) {
-			if (domain->fs_access_masks[layer_level] &
-			    BIT_ULL(access_bit)) {
+			/*
+			 * Artificially handles all initially denied by default
+			 * access rights.
+			 */
+			if (BIT_ULL(access_bit) &
+			    (domain->fs_access_masks[layer_level] |
+			     ACCESS_INITIALLY_DENIED)) {
 				(*layer_masks)[access_bit] |=
 					BIT_ULL(layer_level);
 				handled_accesses |= BIT_ULL(access_bit);
@@ -857,10 +863,6 @@ static int current_check_refer_path(struct dentry *const old_dentry,
 					      NULL, NULL);
 	}
 
-	/* Backward compatibility: no reparenting support. */
-	if (!(get_handled_accesses(dom) & LANDLOCK_ACCESS_FS_REFER))
-		return -EXDEV;
-
 	access_request_parent1 |= LANDLOCK_ACCESS_FS_REFER;
 	access_request_parent2 |= LANDLOCK_ACCESS_FS_REFER;
 
diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 21a2ce8fa739..45de42a027c5 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -4,7 +4,7 @@
  *
  * Copyright © 2017-2020 Mickaël Salaün <mic@digikod.net>
  * Copyright © 2020 ANSSI
- * Copyright © 2020-2021 Microsoft Corporation
+ * Copyright © 2020-2022 Microsoft Corporation
  */
 
 #define _GNU_SOURCE
@@ -371,6 +371,13 @@ TEST_F_FORK(layout1, inval)
 	ASSERT_EQ(EINVAL, errno);
 	path_beneath.allowed_access &= ~LANDLOCK_ACCESS_FS_EXECUTE;
 
+	/* Tests with denied-by-default access right. */
+	path_beneath.allowed_access |= LANDLOCK_ACCESS_FS_REFER;
+	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
+					&path_beneath, 0));
+	ASSERT_EQ(EINVAL, errno);
+	path_beneath.allowed_access &= ~LANDLOCK_ACCESS_FS_REFER;
+
 	/* Test with unknown (64-bits) value. */
 	path_beneath.allowed_access |= (1ULL << 60);
 	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
@@ -1826,6 +1833,20 @@ TEST_F_FORK(layout1, link)
 	ASSERT_EQ(0, link(file1_s1d3, file2_s1d3));
 }
 
+static int test_rename(const char *const oldpath, const char *const newpath)
+{
+	if (rename(oldpath, newpath))
+		return errno;
+	return 0;
+}
+
+static int test_exchange(const char *const oldpath, const char *const newpath)
+{
+	if (renameat2(AT_FDCWD, oldpath, AT_FDCWD, newpath, RENAME_EXCHANGE))
+		return errno;
+	return 0;
+}
+
 TEST_F_FORK(layout1, rename_file)
 {
 	const struct rule rules[] = {
@@ -1867,10 +1888,10 @@ TEST_F_FORK(layout1, rename_file)
 	 * to a different directory (which allows file removal).
 	 */
 	ASSERT_EQ(-1, rename(file1_s2d1, file1_s1d3));
-	ASSERT_EQ(EXDEV, errno);
+	ASSERT_EQ(EACCES, errno);
 	ASSERT_EQ(-1, renameat2(AT_FDCWD, file1_s2d1, AT_FDCWD, file1_s1d3,
 				RENAME_EXCHANGE));
-	ASSERT_EQ(EXDEV, errno);
+	ASSERT_EQ(EACCES, errno);
 	ASSERT_EQ(-1, renameat2(AT_FDCWD, dir_s2d2, AT_FDCWD, file1_s1d3,
 				RENAME_EXCHANGE));
 	ASSERT_EQ(EXDEV, errno);
@@ -1894,7 +1915,7 @@ TEST_F_FORK(layout1, rename_file)
 	ASSERT_EQ(EXDEV, errno);
 	ASSERT_EQ(0, unlink(file1_s1d3));
 	ASSERT_EQ(-1, rename(file1_s2d1, file1_s1d3));
-	ASSERT_EQ(EXDEV, errno);
+	ASSERT_EQ(EACCES, errno);
 
 	/* Exchanges and renames files with same parent. */
 	ASSERT_EQ(0, renameat2(AT_FDCWD, file2_s2d3, AT_FDCWD, file1_s2d3,
@@ -2014,6 +2035,115 @@ TEST_F_FORK(layout1, reparent_refer)
 	ASSERT_EQ(0, rename(dir_s1d3, dir_s2d3));
 }
 
+/* Checks renames beneath dir_s1d1. */
+static void refer_denied_by_default(struct __test_metadata *const _metadata,
+				    const struct rule layer1[],
+				    const int layer1_err,
+				    const struct rule layer2[])
+{
+	int ruleset_fd;
+
+	ASSERT_EQ(0, unlink(file1_s1d2));
+
+	ruleset_fd = create_ruleset(_metadata, layer1[0].access, layer1);
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/*
+	 * If the first layer handles LANDLOCK_ACCESS_FS_REFER (according to
+	 * layer1_err), then it allows some different-parent renames and links.
+	 */
+	ASSERT_EQ(layer1_err, test_rename(file1_s1d1, file1_s1d2));
+	if (layer1_err == 0)
+		ASSERT_EQ(layer1_err, test_rename(file1_s1d2, file1_s1d1));
+	ASSERT_EQ(layer1_err, test_exchange(file2_s1d1, file2_s1d2));
+	ASSERT_EQ(layer1_err, test_exchange(file2_s1d2, file2_s1d1));
+
+	ruleset_fd = create_ruleset(_metadata, layer2[0].access, layer2);
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/*
+	 * Now, either the first or the second layer does not handle
+	 * LANDLOCK_ACCESS_FS_REFER, which means that any different-parent
+	 * renames and links are denied, thus making the layer handling
+	 * LANDLOCK_ACCESS_FS_REFER null and void.
+	 */
+	ASSERT_EQ(EXDEV, test_rename(file1_s1d1, file1_s1d2));
+	ASSERT_EQ(EXDEV, test_exchange(file2_s1d1, file2_s1d2));
+	ASSERT_EQ(EXDEV, test_exchange(file2_s1d2, file2_s1d1));
+}
+
+const struct rule layer_dir_s1d1_refer[] = {
+	{
+		.path = dir_s1d1,
+		.access = LANDLOCK_ACCESS_FS_REFER,
+	},
+	{},
+};
+
+const struct rule layer_dir_s1d1_execute[] = {
+	{
+		/* Matches a parent directory. */
+		.path = dir_s1d1,
+		.access = LANDLOCK_ACCESS_FS_EXECUTE,
+	},
+	{},
+};
+
+const struct rule layer_dir_s2d1_execute[] = {
+	{
+		/* Does not match a parent directory. */
+		.path = dir_s2d1,
+		.access = LANDLOCK_ACCESS_FS_EXECUTE,
+	},
+	{},
+};
+
+/*
+ * Tests precedence over renames: denied by default for different parent
+ * directories, *with* a rule matching a parent directory, but not directly
+ * denying access (with MAKE_REG nor REMOVE).
+ */
+TEST_F_FORK(layout1, refer_denied_by_default1)
+{
+	refer_denied_by_default(_metadata, layer_dir_s1d1_refer, 0,
+				layer_dir_s1d1_execute);
+}
+
+/*
+ * Same test but this time turning around the ABI version order: the first
+ * layer does not handle LANDLOCK_ACCESS_FS_REFER.
+ */
+TEST_F_FORK(layout1, refer_denied_by_default2)
+{
+	refer_denied_by_default(_metadata, layer_dir_s1d1_execute, EXDEV,
+				layer_dir_s1d1_refer);
+}
+
+/*
+ * Tests precedence over renames: denied by default for different parent
+ * directories, *without* a rule matching a parent directory, but not directly
+ * denying access (with MAKE_REG nor REMOVE).
+ */
+TEST_F_FORK(layout1, refer_denied_by_default3)
+{
+	refer_denied_by_default(_metadata, layer_dir_s1d1_refer, 0,
+				layer_dir_s2d1_execute);
+}
+
+/*
+ * Same test but this time turning around the ABI version order: the first
+ * layer does not handle LANDLOCK_ACCESS_FS_REFER.
+ */
+TEST_F_FORK(layout1, refer_denied_by_default4)
+{
+	refer_denied_by_default(_metadata, layer_dir_s2d1_execute, EXDEV,
+				layer_dir_s1d1_refer);
+}
+
 TEST_F_FORK(layout1, reparent_link)
 {
 	const struct rule layer1[] = {
@@ -2336,11 +2466,12 @@ TEST_F_FORK(layout1, reparent_exdev_layers_rename1)
 	ASSERT_EQ(EXDEV, errno);
 
 	/*
-	 * However, moving the file2_s1d3 file below dir_s2d3 is allowed
-	 * because it cannot inherit MAKE_REG nor MAKE_DIR rights (which are
-	 * dedicated to directories).
+	 * Moving the file2_s1d3 file below dir_s2d3 is denied because the
+	 * second layer does not handle REFER, which is always denied by
+	 * default.
 	 */
-	ASSERT_EQ(0, rename(file2_s1d3, file1_s2d3));
+	ASSERT_EQ(-1, rename(file2_s1d3, file1_s2d3));
+	ASSERT_EQ(EXDEV, errno);
 }
 
 TEST_F_FORK(layout1, reparent_exdev_layers_rename2)
@@ -2373,8 +2504,12 @@ TEST_F_FORK(layout1, reparent_exdev_layers_rename2)
 	ASSERT_EQ(EACCES, errno);
 	ASSERT_EQ(-1, rename(file1_s1d1, file1_s2d3));
 	ASSERT_EQ(EXDEV, errno);
-	/* Modify layout! */
-	ASSERT_EQ(0, rename(file2_s1d2, file1_s2d3));
+	/*
+	 * Modifying the layout is now denied because the second layer does not
+	 * handle REFER, which is always denied by default.
+	 */
+	ASSERT_EQ(-1, rename(file2_s1d2, file1_s2d3));
+	ASSERT_EQ(EXDEV, errno);
 
 	/* Without REFER source, EACCES wins over EXDEV. */
 	ASSERT_EQ(-1, rename(dir_s1d1, file1_s2d2));
-- 
2.34.1

