Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1829A5A6445
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 15:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiH3NBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 09:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiH3NA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 09:00:59 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B219F4F6BA
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 06:00:57 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-3376851fe13so271061807b3.6
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 06:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=A7MakhZ4lagvLSUYUfMCY18xYJSTqBfpS1ydR3HER94=;
        b=A7YNkWv19TT0zR14p3cleBvLcpVZjNA9QvWj12RupK93rK1OBTjjxELQDkZjEY/f5Q
         Wt3DEFCAxOmQlW1K71sFk0ZlEjQ+7ecyvDn8oh6wNelXpmlAgyKrrIvw5C1F3Yat9snG
         0BWDTjWl7MCqksY7KCBCwpD0JS9+dgX5I9VODuj0EkNQbQ5w3PiNNkMDdNcU7aY4M2H6
         RRF4nGdxnX/q2utALTPgXXy1Q5eHtVioeK3L+xwIcPFz3wofyQt9oIidgl3VE0X2eHxs
         F34JjbU5BRkL8174k2WRVlNAn/UK8Dde0SVSFOd4KZriUjiIVjQSchBxPwqv5f0dBHly
         ZiNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=A7MakhZ4lagvLSUYUfMCY18xYJSTqBfpS1ydR3HER94=;
        b=V5BhmmuxuzzFaJRvrqrn9JxY79YUZr+V3uTiU7UbW0uIDcuIWdng7b1lY0wFmYMGSk
         ZJSC4b6g30TDjVh42+Og3GwQwFLha7kBIWBm7zLzphxBpzzl3aNBYa4CmubAsiEQ45vA
         9wZqp+V9xgRiH58Pn7CLPw6ic+HLhXzB5aZI5Lt8JtTBB/vMnfCYbwNQhkVyD04+EAhy
         UkC04SNzdmf8nMPhENuA5gs5+Cn9L4WQ9d8KjIqXLzJMv7+wc8sTS6pPWQzZ3p/V6jT/
         zsldBjt65IkULzAPXtRuIAzZpAVkjlcE7mZJXKQoEThDEaHqwjmD6uu08p5q4OA/pHxs
         a4tA==
X-Gm-Message-State: ACgBeo3/3MtSl+hECZSwwkgAciwAPJuKiI2xaV5KvW26T7f8y58wc3tT
        pbvsvDWwEk56j5Dcy6142i91sbpWDVx3eVg8ghN56Q==
X-Google-Smtp-Source: AA6agR7kfNtgB8/YhvK9NrKiM/BQ2IYq/e+P6HRwvlgSCiU1W4U0t6/7Twlyk3OcHhea1K1EGG9ncNc3LdUH9iZvdTk=
X-Received: by 2002:a0d:c244:0:b0:33b:9697:36be with SMTP id
 e65-20020a0dc244000000b0033b969736bemr14221238ywd.373.1661864456342; Tue, 30
 Aug 2022 06:00:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAPTxkvQJHAxYOSmXCro7Cf1uR4y202HTrYLVPCY0JNGc30Y0aA@mail.gmail.com>
 <CAPTxkvQXXeawY-LmmfVsM76MCUOQHRRQN=Sim7Fza0s0aAY6Rw@mail.gmail.com> <Yw2mylTWhMxTSSHY@kroah.com>
In-Reply-To: <Yw2mylTWhMxTSSHY@kroah.com>
From:   Lucas Wei <lucaswei@google.com>
Date:   Tue, 30 Aug 2022 21:00:40 +0800
Message-ID: <CAPTxkvTXTcbxsGY_oPQp53p-HYu6WizabyJ8L1B74s86G=o7Bg@mail.gmail.com>
Subject: Re: Request to cherry-pick into v5.15: arm64: errata: Add Cortex-A510
 to the repeat tlbi list
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Will Deacon <willdeacon@google.com>,
        Robin Peng <robinpeng@google.com>,
        Aaron Ding <aaronding@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

For v5.19, I can cherry-pick this patch directly from commit
39fdb65f52e9 ("arm64:
errata: Add Cortex-A510 to the repeat tlbi list") to linux-5.19.y
without conflicts.
For v5.15, below is my working backport based on linux-5.15.y.

Please let me know if anything can be refined or needs to be changed.
Thanks for your help and review!
----
From d4722275e4d7b686dc79363159e141b71f62f7d4 Mon Sep 17 00:00:00 2001
From: James Morse <james.morse@arm.com>
Date: Mon, 4 Jul 2022 16:57:32 +0100
Subject: [PATCH] arm64: errata: Add Cortex-A510 to the repeat tlbi list

Cortex-A510 is affected by an erratum where in rare circumstances the
CPUs may not handle a race between a break-before-make sequence on one
CPU, and another CPU accessing the same page. This could allow a store
to a page that has been unmapped.

Work around this by adding the affected CPUs to the list that needs
TLB sequences to be done twice.

Signed-off-by: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20220704155732.21216-1-james.morse@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Lucas Wei <lucaswei@google.com>
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 17 +++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |  8 +++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/silicon-errata.rst
b/Documentation/arm64/silicon-errata.rst
index 7c1750bcc5bd..46644736e583 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -92,6 +92,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A77      | #1508412        |
ARM64_ERRATUM_1508412       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2441009        |
ARM64_ERRATUM_2441009       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1188873,1418040|
ARM64_ERRATUM_1418040       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1349291        | N/A
             |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 69e7e293f72e..9d80c783142f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -666,6 +666,23 @@ config ARM64_ERRATUM_1508412

    If unsure, say Y.

+config ARM64_ERRATUM_2441009
+ bool "Cortex-A510: Completion of affected memory accesses might not
be guaranteed by completion of a TLBI"
+ default y
+ select ARM64_WORKAROUND_REPEAT_TLBI
+ help
+   This option adds a workaround for ARM Cortex-A510 erratum #2441009.
+
+   Under very rare circumstances, affected Cortex-A510 CPUs
+   may not handle a race between a break-before-make sequence on one
+   CPU, and another CPU accessing the same page. This could allow a
+   store to a page that has been unmapped.
+
+   Work around this by adding the affected CPUs to the list that needs
+   TLB sequences to be done twice.
+
+   If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
  bool "Cavium erratum 22375, 24313"
  default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index c67c19d70159..e1be45fc7f5b 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -211,6 +211,12 @@ static const struct arm64_cpu_capabilities
arm64_repeat_tlbi_list[] = {
  /* Kryo4xx Gold (rcpe to rfpe) => (r0p0 to r3p0) */
  ERRATA_MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xe),
  },
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_2441009
+ {
+ /* Cortex-A510 r0p0 -> r1p1. Fixed in r1p2 */
+ ERRATA_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1),
+ },
 #endif
  {},
 };
@@ -427,7 +433,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_REPEAT_TLBI
  {
- .desc = "Qualcomm erratum 1009, or ARM erratum 1286807",
+ .desc = "Qualcomm erratum 1009, or ARM erratum 1286807, 2441009",
  .capability = ARM64_WORKAROUND_REPEAT_TLBI,
  .type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
  .matches = cpucap_multi_entry_cap_matches,
--


On Tue, Aug 30, 2022 at 1:57 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Aug 30, 2022 at 10:31:35AM +0800, Lucas Wei wrote:
> > Dear Linux stable kernel maintainers,
> >
> > I would like to apply the below patch into kernel v5.15-stable.
> >  - subject:arm64: errata: Add Cortex-A510 to the repeat tlbi list
> >  - Upstream Commit ID: 39fdb65f52e9a53d32a6ba719f96669fd300ae78
> >  - Targeted LTS release: v5.15
> >
> > This patch is an errata of #2441009. Since v5.15 is still in its LTS
> > lifecycle, I think it fits the rule of "New device IDs and quirks are
> > also accepted" and I want to request to apply this patch to kernel
> > v5.15.
>
> You also need it in 5.19.y, right?  And you never want someone to
> upgrade from an older kernel to a newer one and have a regression.
>
> This commit does not cleanly cherry-pick, I need a working backport in
> order to apply it.  As I'm sure you already have a working and tested
> backport of it (otherwise you wouldn't have asked for it), can you
> please send it to us so that it can be applied?
>
> Same for 5.19.y too.
>
> thanks,
>
> greg k-h



-- 

Lucas Wei
Embedded Software Engineer
lucaswei@google.com
0287260408
