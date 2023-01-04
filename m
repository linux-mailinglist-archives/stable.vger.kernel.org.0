Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69DC65D73C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjADP2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjADP2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:28:14 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2113.outbound.protection.outlook.com [40.107.7.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3606C140DC
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:28:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTcnLUjhWO1pZCVvIukg13Kgc+6Oxd1b9oZIhiNyJ4oBKKZT5aXSoKK7L6p9G3OW0NH7fUjaXx3vQjbatJmdfhZKwyiIUL0ROagKdr4idpHIxA4GVfKpgnHW62hDRdc0poAVBHvymVqhVXSlHtpy7e5wZ1/0664kJTn3F5mFVCO2z6nE4g0uS72jCp4h6RAYysSyd7/VmMwwp8VtoOCXEQ8bIkqohae5/lQJYn/4yxQ1zaEqUQ/m7DiA9e30eDLhjlS2PT9da0azKFKlH2gSDOn55ZzFTBZmB8fK2cNJm/JE2ygJGrMSvxPlHRDOEKEck5p7WgeETajZAzGEyial9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1897Eno8qALtvonhuTx+JywmoLEQ1xA5drYVsRA3cV4=;
 b=OOjQKeG0lGIeZGIf9apGoF5NDkTAf3QHsXuKyAwFbKnRH0K3gU3jih4TYIhQl0qwctkbfRen003mh+NRRLsFvIXyLNfzsYJM+sD+xuGlUjkvKzYKxqNS0O7RXyt3wtUeSipdyGRrk1L0F58xFDiowF7rSd1wLddvna4HdUvOTDt1H9YzqRD4HL4AVZUxcmZ3cKQXjCHcxU3FWlMkL1fOx5+C7jkoC4lqN4al6oB8cgPrMSqBFWGk0vP4SZI0w4wKF1LoY6H6KmWcjlM7xxZTskLxndN1ajCDJjthvdkNpClWusjEc//MbKnMZFzKIjgpPGUH6+IU1VKWTjnHXAm06A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=concurrent-rt.com; dmarc=pass action=none
 header.from=concurrent-rt.com; dkim=pass header.d=concurrent-rt.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bksv.onmicrosoft.com;
 s=selector2-bksv-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1897Eno8qALtvonhuTx+JywmoLEQ1xA5drYVsRA3cV4=;
 b=Vh78dL30lejzRi5XhM/lTrmxGIV8tlgSFGcsaMXyBu0qFqCkkSJwfkQCOwgqYsBGo0D4EQBbLZKu/3auB7UGttCz1w9iSQ/DMyE7g4IK2rfpn7wiuI4l21K+v8qbN26axLMj6/BPYUk7Otvei6gRleMCu8fvRexfMsZk3gxT6HLjq6kCrfxlFyLyQswVZRb+infFFYS+8XeYArLL/54aMmxV23ciBqubML4S+HAMh0RWSlf2piIl10KOLr8peXv1VkSmjQNibZBEQ3KbtX3YhRYYeE2n8xuX8Ml6xFdIb2lwFdZV9tGRvdntttRVbuTCtSqQ8Il9X+BIaAYe7FObnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=concurrent-rt.com;
Received: from DB8PR09MB3580.eurprd09.prod.outlook.com (2603:10a6:10:119::23)
 by AM0PR09MB4401.eurprd09.prod.outlook.com (2603:10a6:20b:164::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 15:28:10 +0000
Received: from DB8PR09MB3580.eurprd09.prod.outlook.com
 ([fe80::927c:30ce:b92f:5860]) by DB8PR09MB3580.eurprd09.prod.outlook.com
 ([fe80::927c:30ce:b92f:5860%9]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 15:28:10 +0000
Date:   Wed, 4 Jan 2023 10:28:04 -0500
From:   Joe Korty <joe.korty@concurrent-rt.com>
To:     gregkh@linuxfoundation.org
Cc:     daniel.lezcano@kernel.org, maz@kernel.org, stable@vger.kernel.org
Subject: Re: EXTERNAL: FAILED: patch "[PATCH]
 clocksource/drivers/arm_arch_timer: Fix XGene-1 TVAL register" failed to
 apply to 6.1-stable tree
Message-ID: <20230104152804.GA14637@zipoli.concurrent-rt.com>
Reply-To: Joe Korty <joe.korty@concurrent-rt.com>
References: <1672836650222222@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1672836650222222@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: BN9P222CA0012.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:408:10c::17) To DB8PR09MB3580.eurprd09.prod.outlook.com
 (2603:10a6:10:119::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR09MB3580:EE_|AM0PR09MB4401:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fdf1974-590b-4287-48f6-08daee684946
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: unPGEkerqRERCUjyXPfah0VnYtZKKCbt/OU4Zfau8K96GagVfFe43BSm13DJ65SsgM2bjZWnhMfVJ2kEaqH+8GavWAMfFzJoVyOiWxjgjFSUsgUO+19rmDJDYxXEZ5jgPQIcdzvOyIyzgiL7BQpZvRPVinFHeYYX/YTs8XrkXtbF+C+STp7BJwExktq4YjSe/8/WoNjsNK6FtUbA3IOhrodYuCuPtzZItEVNrEI8mHpeXxuAb5jTuut10OASqahNq+rYRouWyrDG/VfE5ClY//pQFsG6MRm9IT6+NQ7a/sCLYVknLsUhdiupSoVGB52BMcn6R4FF+SAssY1ZDWjPk5f0quQtpT4d/aiDZ7o2fKqJiZkDjy2ltiJb1QK+vfKqBVs0frdKIUKZgjzh67QYhGBvW1uLZz3e68MlJoRF757h1vjM6ixziuIiPxVUMfP2nV4ctynjeLSc5o387baxgs7g0kDwtcgg2NAC8dUdPuhhIY1St2fKS+G2t5ifNTdOHQkzRuGB0otV5yC5VN94IFltDJfvFj75L0zfczOeEocCrHB2Vp+xwdc38K+2cUmR+XoG7Te3zy5i6+QjMi6/CTGNqeG0QgI72OGoMe7UZ59tS/pWBJwZzeCvKJmIPqBKDsPrSUyAuayBWaEXPiVpzI9GThNEGYvuSDF2CY4OJW9kmYfY7DLQDd8wKhsVNB/o+1aObJsSADMapEUE18hqivv+j9nGlGuPsX3IiMrvcTs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR09MB3580.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(451199015)(6506007)(41300700001)(38100700002)(6916009)(38350700002)(316002)(33656002)(45080400002)(6512007)(186003)(26005)(52116002)(86362001)(8676002)(966005)(4326008)(53546011)(6486002)(66476007)(66946007)(66556008)(478600001)(3450700001)(2906002)(44832011)(1076003)(6666004)(5660300002)(83380400001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TzUi3fyyVr0elKu0Vf4n24QcJ7Mnu2JFiYc4o2Ipo8sEvJGedZ2sW7b5lqP3?=
 =?us-ascii?Q?ECqNhx/r8L+TsKmuaounx5WvtnIkID3y1oap/C1/qe30Q0ezS4CQg0q2HDw/?=
 =?us-ascii?Q?k4k9XxnvVslpS6kd6OYse5iqGqhFH7DVuo5f+zrme5h995ZOTtcLPJq7BfZO?=
 =?us-ascii?Q?l0c7NbC+fp6I/yo0M0itr55wjK76b6BZYztwuDoaOwCUAj8em0rZ2NMJ9NLM?=
 =?us-ascii?Q?3bbKNSbuvtDv/Rsy16O3Tu4HlrqrWd0dPOpD6r6CNu8c3aGkR4lAf9haAtX0?=
 =?us-ascii?Q?dd3kaQVz0N7GG171aZUPuD2Bde5dgiiu1ODMLVxnrzaMOvewoZ495lIt2Ovf?=
 =?us-ascii?Q?+gD82sOpvhsQhH3aAca/JeKoZM7vVQzDa23kINqhDPU0uZ24/aHaLEdNEa+Z?=
 =?us-ascii?Q?vftjBNNvHJOcO7ouTZrRAOQYuT2BKpTIPjvnFkbEB+rTOlVW/oUlM5J08Zkx?=
 =?us-ascii?Q?ekwVbG6adCHTa8m3nFTVB45JnANuhJm+uGW1untTIo/Z2HcHoRd9b4z8Um2q?=
 =?us-ascii?Q?W5rIFulWF7VnxbzreKQ8DTJrOKW9PvYXsbMKliWnKvzk92288gexkvqXSctq?=
 =?us-ascii?Q?KTu85wfSjKjtXZht+Fw8HfRw08/piqYX4b0hoHGTpKTBHQRGHjrO8Zs/Zw/R?=
 =?us-ascii?Q?BAk+3xdFQKDdEbKBrMfOqvg6ka9aeNTZbtAKhvZIWwDZ+9zKmGITHcS08C2R?=
 =?us-ascii?Q?qtT9CUcgRxsCm/HVLxm/GaFBSjPKW/ppl53rRd41wWjlvVYPbdp84B+VImxE?=
 =?us-ascii?Q?rJmTkdktzO3dCwQFxyeyB5pDktRov32Aiev7CgROq8nf7MkdjtijmzQxd5F/?=
 =?us-ascii?Q?bVOGqV5B7Ri+55vrHuWIARUq3G6BPaI4XwoRT+ZYiY1u+GR1Eg+HQAV5VS/f?=
 =?us-ascii?Q?W6CRAALar2MITp8HU7TNbJKPMrajf1wPQaRiZcp+PziwZkWAUTDSX2YZSyo4?=
 =?us-ascii?Q?swPZbfGs4sfZvRJ1947d6u3C0M6HOnnfPzD43kVG45TCmkdrTD7zx3jWxZMq?=
 =?us-ascii?Q?XAX9yziWK7nwgLHb+CvFBDZXq2yybhjZJwlqCXPOT2aD7Azx3Tc+pxNcpypE?=
 =?us-ascii?Q?s+dUW5OadxSkr3lj3H9Z4kzbaG9impzYxRdCpR6xSjxsYp9NOcOlDZXxMZZ8?=
 =?us-ascii?Q?sFK2236L/XsEThitM1lGYcs5C88NaayRubWqU1xkC4lCMI2O4YDuDoeu/20B?=
 =?us-ascii?Q?2as8tPPwBVYpMsj1YG0vrSb/2rA4VVZe8n2PE+/rNexlp9oDpz/FQAn5YrlL?=
 =?us-ascii?Q?sT6xePsZ/kHIHGz1/QfNiV/qZOjo/iou4AJCWawN9TT6slB8QeS7x/AIHmAk?=
 =?us-ascii?Q?eEgo1xFVzPm66MgE9RYKD7+gdPbWSso+OQbtzMCCD6SsaBDy+nIh1lwkYaqs?=
 =?us-ascii?Q?FSzQHdShwsli5WtUh3J9J6/7YeTNu90UWzucByp2LNDBvE4YvxHiG49nsUji?=
 =?us-ascii?Q?qNG3CZkMklwAX+HpOpqmStMrhxLkYX0UDW1EbDK3RtXKjRS7382srrRdZtWA?=
 =?us-ascii?Q?6eh/aIjS0T8iZqZl9GaG8GzXGPzqapKAJZorbrIldTTozQKxbcvg0472HEOa?=
 =?us-ascii?Q?v3SL5tAUi+EtHy91LnJ0/+cNojcJwsGroNKgozeDG6lkNXIetv4jvrmpALNq?=
 =?us-ascii?Q?6g=3D=3D?=
X-OriginatorOrg: concurrent-rt.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fdf1974-590b-4287-48f6-08daee684946
X-MS-Exchange-CrossTenant-AuthSource: DB8PR09MB3580.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 15:28:10.2836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6cce74a3-3975-45e0-9893-b072988b30b6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nGAJ9SQvgY7sN4vnFMhncG5WPPIcF+A3Q7eJah+iq1nLmuK/x0ialzGDNMImuQA+3u6cliKb87i7i1qbDoTNBpzR2tNf4PbDa2LP76hZrnY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR09MB4401
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 01:50:50PM +0100, gregkh@linuxfoundation.org wrote:
> CAUTION! External Email. Do not click links or open attachments unless you recognize the sender and are sure the content is safe.
> If you think this is a phishing email, please report it by using the "Phish Alert Report" button in Outlook.
> 
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> 45ae272a948a ("clocksource/drivers/arm_arch_timer: Fix XGene-1 TVAL register math error")
> 
> thanks,
> greg k-h


Hi Greg,
The patch is already present in linux-6.1.y.
Ref: 839a973988a94 ("clocksource/drivers/arm_arch_timer: Fix XGene-1 TVAL register math error")
Regards,
Joe


> 
> ------------------ original commit in Linus's tree ------------------
> 
> >From 45ae272a948a03a7d55748bf52d2f47d3b4e1d5a Mon Sep 17 00:00:00 2001
> From: Joe Korty <joe.korty@concurrent-rt.com>
> Date: Mon, 21 Nov 2022 14:53:43 +0000
> Subject: [PATCH] clocksource/drivers/arm_arch_timer: Fix XGene-1 TVAL register
>  math error
> 
> The TVAL register is 32 bit signed.  Thus only the lower 31 bits are
> available to specify when an interrupt is to occur at some time in the
> near future.  Attempting to specify a larger interval with TVAL results
> in a negative time delta which means the timer fires immediately upon
> being programmed, rather than firing at that expected future time.
> 
> The solution is for Linux to declare that TVAL is a 31 bit register rather
> than give its true size of 32 bits.  This prevents Linux from programming
> TVAL with a too-large value.  Note that, prior to 5.16, this little trick
> was the standard way to handle TVAL in Linux, so there is nothing new
> happening here on that front.
> 
> The softlockup detector hides the issue, because it keeps generating
> short timer deadlines that are within the scope of the broken timer.
> 
> Disable it, and you start using NO_HZ with much longer timer deadlines,
> which turns into an interrupt flood:
> 
>  11: 1124855130  949168462  758009394   76417474  104782230   30210281
>          310890 1734323687     GICv2  29 Level     arch_timer
> 
> And "much longer" isn't that long: it takes less than 43s to underflow
> TVAL at 50MHz (the frequency of the counter on XGene-1).
> 
> Some comments on the v1 version of this patch by Marc Zyngier:
> 
>   XGene implements CVAL (a 64bit comparator) in terms of TVAL (a countdown
>   register) instead of the other way around. TVAL being a 32bit register,
>   the width of the counter should equally be 32.  However, TVAL is a
>   *signed* value, and keeps counting down in the negative range once the
>   timer fires.
> 
>   It means that any TVAL value with bit 31 set will fire immediately,
>   as it cannot be distinguished from an already expired timer. Reducing
>   the timer range back to a paltry 31 bits papers over the issue.
> 
>   Another problem cannot be fixed though, which is that the timer interrupt
>   *must* be handled within the negative countdown period, or the interrupt
>   will be lost (TVAL will rollover to a positive value, indicative of a
>   new timer deadline).
> 
> Cc: stable@vger.kernel.org # 5.16+
> Fixes: 012f18850452 ("clocksource/drivers/arm_arch_timer: Work around broken CVAL implementations")
> Signed-off-by: Joe Korty <joe.korty@concurrent-rt.com>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> [maz: revamped the commit message]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20221024165422.GA51107@zipoli.concurrent-rt.com
> Link: https://lore.kernel.org/r/20221121145343.896018-1-maz@kernel.org
> Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 9c3420a0d19d..e2920da18ea1 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -806,6 +806,9 @@ static u64 __arch_timer_check_delta(void)
>                 /*
>                  * XGene-1 implements CVAL in terms of TVAL, meaning
>                  * that the maximum timer range is 32bit. Shame on them.
> +                *
> +                * Note that TVAL is signed, thus has only 31 of its
> +                * 32 bits to express magnitude.
>                  */
>                 MIDR_ALL_VERSIONS(MIDR_CPU_MODEL(ARM_CPU_IMP_APM,
>                                                  APM_CPU_PART_POTENZA)),
> @@ -813,8 +816,8 @@ static u64 __arch_timer_check_delta(void)
>         };
> 
>         if (is_midr_in_range_list(read_cpuid_id(), broken_cval_midrs)) {
> -               pr_warn_once("Broken CNTx_CVAL_EL1, limiting width to 32bits");
> -               return CLOCKSOURCE_MASK(32);
> +               pr_warn_once("Broken CNTx_CVAL_EL1, using 32 bit TVAL instead.\n");
> +               return CLOCKSOURCE_MASK(31);
>         }
>  #endif
>         return CLOCKSOURCE_MASK(arch_counter_get_width());
> 
