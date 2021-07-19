Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE103CD8D1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243374AbhGSOZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:25:42 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:34617 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243449AbhGSOYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 10:24:05 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jul 2021 10:24:04 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626706717;
    s=strato-dkim-0002; d=xenosoft.de;
    h=In-Reply-To:Date:Message-ID:Cc:From:References:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=sx2vrmfDvvvj7kJR3fj66Sk4qrh4YEKWZtRTH9rRFxQ=;
    b=dqE00bhMucVYMm/1AbSatNBGCh1d9RKDr3QHUbrzOO2qu2yVz4632Dksf2anx3Wk7W
    aBLpUdVeZYrz+7ufC6IdD1sXEf1fEOlp0f0gxXrfVYqwzrlqjRlCKOgPljT/aceaW2Xd
    QohWGhRHhff0NM5QeRf1ZUgiiiYBNm0tS+ZwDh6KCJoz+KzKIwMfvbQHFmLAt9coWUEV
    SYeVRWCILoW2C5uLpW1jPZAwE4QuaDN7YH1sjCHoIPN1lR7SKx42QAQc0HRDeTQf3bzi
    PSOHNVSHQLsUb9Un3STZUv2RYVq9gdwXsz1ZTkMIB6F+EeixZvPqP5RybFw2etVSDSIU
    4iTw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhQJ/n7Igzyv3xSK1rTi/pQ6tTwxQ=="
X-RZG-CLASS-ID: mo00
Received: from Christians-iMac.fritz.box
    by smtp.strato.de (RZmta 47.28.1 AUTH)
    with ESMTPSA id j0889bx6JEwaTi3
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 19 Jul 2021 16:58:36 +0200 (CEST)
Subject: FAILED: patch "[PATCH] drm/radeon/ni_dpm: Fix booting bug" failed to
 apply to 5.13-stable tree
To:     Stan Johnson <userm57@yahoo.com>
References: <b1f812d2-5600-28d6-59fa-a060b2feecf4.ref@yahoo.com>
 <b1f812d2-5600-28d6-59fa-a060b2feecf4@yahoo.com>
 <3473a47e-6eed-b06e-f23d-11dd96fff16f@xenosoft.de>
 <51f4531c-fc97-4176-616f-fd972834bdae@yahoo.com>
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Cc:     stable@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Debian PowerPC <debian-powerpc@lists.debian.org>,
        Alex Deucher <alexander.deucher@amd.com>, gustavoars@kernel.org
Message-ID: <b7e99e02-c2ed-1d11-4f7d-5b0bc9ac8043@xenosoft.de>
Date:   Mon, 19 Jul 2021 16:58:35 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <51f4531c-fc97-4176-616f-fd972834bdae@yahoo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19 July 2021 at 04:32 pm, Stan Johnson wrote:
> On 7/18/21 10:23 PM, Christian Zigotzky wrote:
>> Hello Stan,
>>
>> We had the same issue during the 5.14 merge window. Please look in the
>> following thread:
>>
>> https://forum.hyperion-entertainment.com/viewtopic.php?p=53511#p53511
>>
>> There is a patch available. Please try it.
>>
>> Thanks,
>> Christian
>> ...
> Hello Christian,
>
> Thanks. There were some errors applying the patch, so it wasn't fully
> applied (see below). Of course, I'm using 5.13.2, not 5.14, so maybe
> that's expected.
>
> The patched 5.13.2 kernel still results in a blank screen while trying
> to run wdm. On this attempt, wdm has died (oddly the screen remains
> blank; it should display a text login after X dies). The Xorg.0.log
> looks reasonable enough.
>
> I tried disabling wdm, then rebooted, logged in at the console and ran
> "startx". The screen goes blank, X is running, startx is running:
>
> johnson   1392  0.0  0.2   2572  1452 tty1     S+   08:06   0:00 /bin/sh
> /usr/bin/startx
> johnson   1414  0.0  0.4   4904  2096 tty1     S+   08:06   0:00 xinit
> /etc/X11/xinit/xinitrc -- /etc/X11/xinit/xserverrc :0 vt1 -keeptty -auth
> /tmp/serverauth.dJ7lSnzjjo
> johnson   1415  1.0  8.2 128436 41924 tty1     Sl   08:06   0:04
> /usr/lib/xorg/Xorg -nolisten tcp :0 vt1 -keeptty -auth
> /tmp/serverauth.dJ7lSnzjjo
>
> I had to use "kill -KILL" to kill the startx, xinit and Xorg processes.
> After those were killed, the screen was still blank, and even though
> nothing was running, the load average was still around 1.00 several
> minutes later, so something is still taking CPU time:
>
> $ uptime
>   08:25:15 up 20 min,  2 users,  load average: 1.00, 1.00, 0.84
>
> I can attempt a git bisect, though that will take some time.
>
> -Stan
>
> ----------
> $ patch -p1
> <../v3-drm-radeon-Fix-NULL-dereference-when-updating-memory-stats.patch
> patching file drivers/gpu/drm/radeon/radeon_object.c
> Hunk #2 FAILED at 76.
> Hunk #3 FAILED at 727.
> 2 out of 3 hunks FAILED -- saving rejects to file
> drivers/gpu/drm/radeon/radeon_object.c.rej
> patching file drivers/gpu/drm/radeon/radeon_object.h
> patching file drivers/gpu/drm/radeon/radeon_ttm.c
> Hunk #1 FAILED at 199.
> Hunk #2 succeeded at 227 (offset 11 lines).
> Hunk #3 succeeded at 275 (offset 11 lines).
> Hunk #4 succeeded at 697 (offset 12 lines).
> 1 out of 4 hunks FAILED -- saving rejects to file
> drivers/gpu/drm/radeon/radeon_ttm.c.rej
> johnson@mac-server:/data/software/working/linux-5.13.2$ cat
> drivers/gpu/drm/radeon/radeon_ttm.c.rej
> --- drivers/gpu/drm/radeon/radeon_ttm.c
> +++ drivers/gpu/drm/radeon/radeon_ttm.c
> @@ -199,7 +199,7 @@ static int radeon_bo_move(struct ttm_buffer_object
> *bo, bool evict,
>   	struct ttm_resource *old_mem = bo->resource;
>   	struct radeon_device *rdev;
>   	struct radeon_bo *rbo;
> -	int r;
> +	int r, old_type;
>
>   	if (new_mem->mem_type == TTM_PL_TT) {
>   		r = radeon_ttm_tt_bind(bo->bdev, bo->ttm, new_mem);
>
> ---------
Hello Stan,

Greg has the same issue with patching the kernel 5.13 [1]. We have to 
wait for a solution.

- Christian

[1]

The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

 >From 293774413a3f519c826d4eb5313ef02e20515700 Mon Sep 17 00:00:00 2001
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date: Sun, 9 May 2021 17:49:26 -0500
Subject: [PATCH] drm/radeon/ni_dpm: Fix booting bug

Create new structure NISLANDS_SMC_SWSTATE_SINGLE, as initialState.levels
and ACPIState.levels are never actually used as flexible arrays. Those
arrays can be used as simple objects of type
NISLANDS_SMC_HW_PERFORMANCE_LEVEL, instead.

Currently, the code fails because flexible array _levels_ in
struct NISLANDS_SMC_SWSTATE doesn't allow for code that access
the first element of initialState.levels and ACPIState.levels
arrays:

drivers/gpu/drm/radeon/ni_dpm.c:
1690 table->initialState.levels[0].mclk.vMPLL_AD_FUNC_CNTL =
1691 cpu_to_be32(ni_pi->clock_registers.mpll_ad_func_cntl);
...
1903:   table->ACPIState.levels[0].mclk.vMPLL_AD_FUNC_CNTL = 
cpu_to_be32(mpll_ad_func_cntl);
1904:   table->ACPIState.levels[0].mclk.vMPLL_AD_FUNC_CNTL_2 = 
cpu_to_be32(mpll_ad_func_cntl_2);

because such element cannot exist without previously allocating
any dynamic memory for it (which never actually happens).

That's why struct NISLANDS_SMC_SWSTATE should only be used as type
for object driverState and new struct SISLANDS_SMC_SWSTATE_SINGLE is
created as type for objects initialState, ACPIState and ULVState.

Also, with the change from one-element array to flexible-array member
in commit 434fb1e7444a ("drm/radeon/nislands_smc.h: Replace one-element
array with flexible-array member in struct NISLANDS_SMC_SWSTATE"), the
size of dpmLevels in struct NISLANDS_SMC_STATETABLE should be fixed to
be NISLANDS_MAX_SMC_PERFORMANCE_LEVELS_PER_SWSTATE instead of
NISLANDS_MAX_SMC_PERFORMANCE_LEVELS_PER_SWSTATE - 1.

Bug: 
https://lore.kernel.org/dri-devel/3eedbe78-1fbd-4763-a7f3-ac5665e76a4a@xenosoft.de/
Fixes: 434fb1e7444a ("drm/radeon/nislands_smc.h: Replace one-element 
array with flexible-array member in struct NISLANDS_SMC_SWSTATE")
Cc: stable@vger.kernel.org
Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Tested-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Link: 
https://lore.kernel.org/dri-devel/9bb5fcbd-daf5-1669-b3e7-b8624b3c36f9@xenosoft.de/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/radeon/ni_dpm.c 
b/drivers/gpu/drm/radeon/ni_dpm.c
index dd5ef6493723..769f666335ac 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -1687,102 +1687,102 @@ static int 
ni_populate_smc_initial_state(struct radeon_device *rdev,
      u32 reg;
      int ret;

-    table->initialState.levels[0].mclk.vMPLL_AD_FUNC_CNTL =
+    table->initialState.level.mclk.vMPLL_AD_FUNC_CNTL =
          cpu_to_be32(ni_pi->clock_registers.mpll_ad_func_cntl);
-    table->initialState.levels[0].mclk.vMPLL_AD_FUNC_CNTL_2 =
+    table->initialState.level.mclk.vMPLL_AD_FUNC_CNTL_2 =
          cpu_to_be32(ni_pi->clock_registers.mpll_ad_func_cntl_2);
-    table->initialState.levels[0].mclk.vMPLL_DQ_FUNC_CNTL =
+    table->initialState.level.mclk.vMPLL_DQ_FUNC_CNTL =
          cpu_to_be32(ni_pi->clock_registers.mpll_dq_func_cntl);
-    table->initialState.levels[0].mclk.vMPLL_DQ_FUNC_CNTL_2 =
+    table->initialState.level.mclk.vMPLL_DQ_FUNC_CNTL_2 =
          cpu_to_be32(ni_pi->clock_registers.mpll_dq_func_cntl_2);
-    table->initialState.levels[0].mclk.vMCLK_PWRMGT_CNTL =
+    table->initialState.level.mclk.vMCLK_PWRMGT_CNTL =
          cpu_to_be32(ni_pi->clock_registers.mclk_pwrmgt_cntl);
-    table->initialState.levels[0].mclk.vDLL_CNTL =
+    table->initialState.level.mclk.vDLL_CNTL =
          cpu_to_be32(ni_pi->clock_registers.dll_cntl);
-    table->initialState.levels[0].mclk.vMPLL_SS =
+    table->initialState.level.mclk.vMPLL_SS =
          cpu_to_be32(ni_pi->clock_registers.mpll_ss1);
-    table->initialState.levels[0].mclk.vMPLL_SS2 =
+    table->initialState.level.mclk.vMPLL_SS2 =
          cpu_to_be32(ni_pi->clock_registers.mpll_ss2);
-    table->initialState.levels[0].mclk.mclk_value =
+    table->initialState.level.mclk.mclk_value =
          cpu_to_be32(initial_state->performance_levels[0].mclk);

-    table->initialState.levels[0].sclk.vCG_SPLL_FUNC_CNTL =
+    table->initialState.level.sclk.vCG_SPLL_FUNC_CNTL =
          cpu_to_be32(ni_pi->clock_registers.cg_spll_func_cntl);
-    table->initialState.levels[0].sclk.vCG_SPLL_FUNC_CNTL_2 =
+    table->initialState.level.sclk.vCG_SPLL_FUNC_CNTL_2 =
          cpu_to_be32(ni_pi->clock_registers.cg_spll_func_cntl_2);
-    table->initialState.levels[0].sclk.vCG_SPLL_FUNC_CNTL_3 =
+    table->initialState.level.sclk.vCG_SPLL_FUNC_CNTL_3 =
          cpu_to_be32(ni_pi->clock_registers.cg_spll_func_cntl_3);
-    table->initialState.levels[0].sclk.vCG_SPLL_FUNC_CNTL_4 =
+    table->initialState.level.sclk.vCG_SPLL_FUNC_CNTL_4 =
          cpu_to_be32(ni_pi->clock_registers.cg_spll_func_cntl_4);
-    table->initialState.levels[0].sclk.vCG_SPLL_SPREAD_SPECTRUM =
+    table->initialState.level.sclk.vCG_SPLL_SPREAD_SPECTRUM =
cpu_to_be32(ni_pi->clock_registers.cg_spll_spread_spectrum);
- table->initialState.levels[0].sclk.vCG_SPLL_SPREAD_SPECTRUM_2 =
+    table->initialState.level.sclk.vCG_SPLL_SPREAD_SPECTRUM_2 =
cpu_to_be32(ni_pi->clock_registers.cg_spll_spread_spectrum_2);
-    table->initialState.levels[0].sclk.sclk_value =
+    table->initialState.level.sclk.sclk_value =
          cpu_to_be32(initial_state->performance_levels[0].sclk);
-    table->initialState.levels[0].arbRefreshState =
+    table->initialState.level.arbRefreshState =
          NISLANDS_INITIAL_STATE_ARB_INDEX;

-    table->initialState.levels[0].ACIndex = 0;
+    table->initialState.level.ACIndex = 0;

      ret = ni_populate_voltage_value(rdev, &eg_pi->vddc_voltage_table,
                      initial_state->performance_levels[0].vddc,
-                    &table->initialState.levels[0].vddc);
+                    &table->initialState.level.vddc);
      if (!ret) {
          u16 std_vddc;

          ret = ni_get_std_voltage_value(rdev,
- &table->initialState.levels[0].vddc,
+                           &table->initialState.level.vddc,
                             &std_vddc);
          if (!ret)
              ni_populate_std_voltage_value(rdev, std_vddc,
- table->initialState.levels[0].vddc.index,
- &table->initialState.levels[0].std_vddc);
+ table->initialState.level.vddc.index,
+ &table->initialState.level.std_vddc);
      }

      if (eg_pi->vddci_control)
          ni_populate_voltage_value(rdev,
                        &eg_pi->vddci_voltage_table,
initial_state->performance_levels[0].vddci,
-                      &table->initialState.levels[0].vddci);
+                      &table->initialState.level.vddci);

-    ni_populate_initial_mvdd_value(rdev, 
&table->initialState.levels[0].mvdd);
+    ni_populate_initial_mvdd_value(rdev, &table->initialState.level.mvdd);

      reg = CG_R(0xffff) | CG_L(0);
-    table->initialState.levels[0].aT = cpu_to_be32(reg);
+    table->initialState.level.aT = cpu_to_be32(reg);

-    table->initialState.levels[0].bSP = cpu_to_be32(pi->dsp);
+    table->initialState.level.bSP = cpu_to_be32(pi->dsp);

      if (pi->boot_in_gen2)
-        table->initialState.levels[0].gen2PCIE = 1;
+        table->initialState.level.gen2PCIE = 1;
      else
-        table->initialState.levels[0].gen2PCIE = 0;
+        table->initialState.level.gen2PCIE = 0;

      if (pi->mem_gddr5) {
-        table->initialState.levels[0].strobeMode =
+        table->initialState.level.strobeMode =
              cypress_get_strobe_mode_settings(rdev,
  initial_state->performance_levels[0].mclk);

          if (initial_state->performance_levels[0].mclk > 
pi->mclk_edc_enable_threshold)
-            table->initialState.levels[0].mcFlags = 
NISLANDS_SMC_MC_EDC_RD_FLAG | NISLANDS_SMC_MC_EDC_WR_FLAG;
+            table->initialState.level.mcFlags = 
NISLANDS_SMC_MC_EDC_RD_FLAG | NISLANDS_SMC_MC_EDC_WR_FLAG;
          else
-            table->initialState.levels[0].mcFlags =  0;
+            table->initialState.level.mcFlags =  0;
      }

      table->initialState.levelCount = 1;

      table->initialState.flags |= PPSMC_SWSTATE_FLAG_DC;

-    table->initialState.levels[0].dpm2.MaxPS = 0;
-    table->initialState.levels[0].dpm2.NearTDPDec = 0;
-    table->initialState.levels[0].dpm2.AboveSafeInc = 0;
-    table->initialState.levels[0].dpm2.BelowSafeInc = 0;
+    table->initialState.level.dpm2.MaxPS = 0;
+    table->initialState.level.dpm2.NearTDPDec = 0;
+    table->initialState.level.dpm2.AboveSafeInc = 0;
+    table->initialState.level.dpm2.BelowSafeInc = 0;

      reg = MIN_POWER_MASK | MAX_POWER_MASK;
-    table->initialState.levels[0].SQPowerThrottle = cpu_to_be32(reg);
+    table->initialState.level.SQPowerThrottle = cpu_to_be32(reg);

      reg = MAX_POWER_DELTA_MASK | STI_SIZE_MASK | LTI_RATIO_MASK;
-    table->initialState.levels[0].SQPowerThrottle_2 = cpu_to_be32(reg);
+    table->initialState.level.SQPowerThrottle_2 = cpu_to_be32(reg);

      return 0;
  }
@@ -1813,43 +1813,43 @@ static int ni_populate_smc_acpi_state(struct 
radeon_device *rdev,
      if (pi->acpi_vddc) {
          ret = ni_populate_voltage_value(rdev,
                          &eg_pi->vddc_voltage_table,
-                        pi->acpi_vddc, &table->ACPIState.levels[0].vddc);
+                        pi->acpi_vddc, &table->ACPIState.level.vddc);
          if (!ret) {
              u16 std_vddc;

              ret = ni_get_std_voltage_value(rdev,
- &table->ACPIState.levels[0].vddc, &std_vddc);
+                               &table->ACPIState.level.vddc, &std_vddc);
              if (!ret)
                  ni_populate_std_voltage_value(rdev, std_vddc,
- table->ACPIState.levels[0].vddc.index,
- &table->ACPIState.levels[0].std_vddc);
+ table->ACPIState.level.vddc.index,
+ &table->ACPIState.level.std_vddc);
          }

          if (pi->pcie_gen2) {
              if (pi->acpi_pcie_gen2)
-                table->ACPIState.levels[0].gen2PCIE = 1;
+                table->ACPIState.level.gen2PCIE = 1;
              else
-                table->ACPIState.levels[0].gen2PCIE = 0;
+                table->ACPIState.level.gen2PCIE = 0;
          } else {
-            table->ACPIState.levels[0].gen2PCIE = 0;
+            table->ACPIState.level.gen2PCIE = 0;
          }
      } else {
          ret = ni_populate_voltage_value(rdev,
                          &eg_pi->vddc_voltage_table,
                          pi->min_vddc_in_table,
-                        &table->ACPIState.levels[0].vddc);
+                        &table->ACPIState.level.vddc);
          if (!ret) {
              u16 std_vddc;

              ret = ni_get_std_voltage_value(rdev,
- &table->ACPIState.levels[0].vddc,
+                               &table->ACPIState.level.vddc,
                                 &std_vddc);
              if (!ret)
                  ni_populate_std_voltage_value(rdev, std_vddc,
- table->ACPIState.levels[0].vddc.index,
- &table->ACPIState.levels[0].std_vddc);
+ table->ACPIState.level.vddc.index,
+ &table->ACPIState.level.std_vddc);
          }
-        table->ACPIState.levels[0].gen2PCIE = 0;
+        table->ACPIState.level.gen2PCIE = 0;
      }

      if (eg_pi->acpi_vddci) {
@@ -1857,7 +1857,7 @@ static int ni_populate_smc_acpi_state(struct 
radeon_device *rdev,
              ni_populate_voltage_value(rdev,
                            &eg_pi->vddci_voltage_table,
                            eg_pi->acpi_vddci,
- &table->ACPIState.levels[0].vddci);
+                          &table->ACPIState.level.vddci);
      }


@@ -1900,37 +1900,37 @@ static int ni_populate_smc_acpi_state(struct 
radeon_device *rdev,
      spll_func_cntl_2 &= ~SCLK_MUX_SEL_MASK;
      spll_func_cntl_2 |= SCLK_MUX_SEL(4);

-    table->ACPIState.levels[0].mclk.vMPLL_AD_FUNC_CNTL = 
cpu_to_be32(mpll_ad_func_cntl);
-    table->ACPIState.levels[0].mclk.vMPLL_AD_FUNC_CNTL_2 = 
cpu_to_be32(mpll_ad_func_cntl_2);
-    table->ACPIState.levels[0].mclk.vMPLL_DQ_FUNC_CNTL = 
cpu_to_be32(mpll_dq_func_cntl);
-    table->ACPIState.levels[0].mclk.vMPLL_DQ_FUNC_CNTL_2 = 
cpu_to_be32(mpll_dq_func_cntl_2);
-    table->ACPIState.levels[0].mclk.vMCLK_PWRMGT_CNTL = 
cpu_to_be32(mclk_pwrmgt_cntl);
-    table->ACPIState.levels[0].mclk.vDLL_CNTL = cpu_to_be32(dll_cntl);
+    table->ACPIState.level.mclk.vMPLL_AD_FUNC_CNTL = 
cpu_to_be32(mpll_ad_func_cntl);
+    table->ACPIState.level.mclk.vMPLL_AD_FUNC_CNTL_2 = 
cpu_to_be32(mpll_ad_func_cntl_2);
+    table->ACPIState.level.mclk.vMPLL_DQ_FUNC_CNTL = 
cpu_to_be32(mpll_dq_func_cntl);
+    table->ACPIState.level.mclk.vMPLL_DQ_FUNC_CNTL_2 = 
cpu_to_be32(mpll_dq_func_cntl_2);
+    table->ACPIState.level.mclk.vMCLK_PWRMGT_CNTL = 
cpu_to_be32(mclk_pwrmgt_cntl);
+    table->ACPIState.level.mclk.vDLL_CNTL = cpu_to_be32(dll_cntl);

-    table->ACPIState.levels[0].mclk.mclk_value = 0;
+    table->ACPIState.level.mclk.mclk_value = 0;

-    table->ACPIState.levels[0].sclk.vCG_SPLL_FUNC_CNTL = 
cpu_to_be32(spll_func_cntl);
-    table->ACPIState.levels[0].sclk.vCG_SPLL_FUNC_CNTL_2 = 
cpu_to_be32(spll_func_cntl_2);
-    table->ACPIState.levels[0].sclk.vCG_SPLL_FUNC_CNTL_3 = 
cpu_to_be32(spll_func_cntl_3);
-    table->ACPIState.levels[0].sclk.vCG_SPLL_FUNC_CNTL_4 = 
cpu_to_be32(spll_func_cntl_4);
+    table->ACPIState.level.sclk.vCG_SPLL_FUNC_CNTL = 
cpu_to_be32(spll_func_cntl);
+    table->ACPIState.level.sclk.vCG_SPLL_FUNC_CNTL_2 = 
cpu_to_be32(spll_func_cntl_2);
+    table->ACPIState.level.sclk.vCG_SPLL_FUNC_CNTL_3 = 
cpu_to_be32(spll_func_cntl_3);
+    table->ACPIState.level.sclk.vCG_SPLL_FUNC_CNTL_4 = 
cpu_to_be32(spll_func_cntl_4);

-    table->ACPIState.levels[0].sclk.sclk_value = 0;
+    table->ACPIState.level.sclk.sclk_value = 0;

-    ni_populate_mvdd_value(rdev, 0, &table->ACPIState.levels[0].mvdd);
+    ni_populate_mvdd_value(rdev, 0, &table->ACPIState.level.mvdd);

      if (eg_pi->dynamic_ac_timing)
-        table->ACPIState.levels[0].ACIndex = 1;
+        table->ACPIState.level.ACIndex = 1;

-    table->ACPIState.levels[0].dpm2.MaxPS = 0;
-    table->ACPIState.levels[0].dpm2.NearTDPDec = 0;
-    table->ACPIState.levels[0].dpm2.AboveSafeInc = 0;
-    table->ACPIState.levels[0].dpm2.BelowSafeInc = 0;
+    table->ACPIState.level.dpm2.MaxPS = 0;
+    table->ACPIState.level.dpm2.NearTDPDec = 0;
+    table->ACPIState.level.dpm2.AboveSafeInc = 0;
+    table->ACPIState.level.dpm2.BelowSafeInc = 0;

      reg = MIN_POWER_MASK | MAX_POWER_MASK;
-    table->ACPIState.levels[0].SQPowerThrottle = cpu_to_be32(reg);
+    table->ACPIState.level.SQPowerThrottle = cpu_to_be32(reg);

      reg = MAX_POWER_DELTA_MASK | STI_SIZE_MASK | LTI_RATIO_MASK;
-    table->ACPIState.levels[0].SQPowerThrottle_2 = cpu_to_be32(reg);
+    table->ACPIState.level.SQPowerThrottle_2 = cpu_to_be32(reg);

      return 0;
  }
@@ -1980,7 +1980,9 @@ static int ni_init_smc_table(struct radeon_device 
*rdev)
      if (ret)
          return ret;

-    table->driverState = table->initialState;
+    table->driverState.flags = table->initialState.flags;
+    table->driverState.levelCount = table->initialState.levelCount;
+    table->driverState.levels[0] = table->initialState.level;

      table->ULVState = table->initialState;

diff --git a/drivers/gpu/drm/radeon/nislands_smc.h 
b/drivers/gpu/drm/radeon/nislands_smc.h
index 7395cb6b3cac..42f3bab0f9ee 100644
--- a/drivers/gpu/drm/radeon/nislands_smc.h
+++ b/drivers/gpu/drm/radeon/nislands_smc.h
@@ -143,6 +143,14 @@ struct NISLANDS_SMC_SWSTATE

  typedef struct NISLANDS_SMC_SWSTATE NISLANDS_SMC_SWSTATE;

+struct NISLANDS_SMC_SWSTATE_SINGLE {
+    uint8_t                             flags;
+    uint8_t                             levelCount;
+    uint8_t                             padding2;
+    uint8_t                             padding3;
+    NISLANDS_SMC_HW_PERFORMANCE_LEVEL   level;
+};
+
  #define NISLANDS_SMC_VOLTAGEMASK_VDDC  0
  #define NISLANDS_SMC_VOLTAGEMASK_MVDD  1
  #define NISLANDS_SMC_VOLTAGEMASK_VDDCI 2
@@ -160,19 +168,19 @@ typedef struct NISLANDS_SMC_VOLTAGEMASKTABLE 
NISLANDS_SMC_VOLTAGEMASKTABLE;

  struct NISLANDS_SMC_STATETABLE
  {
-    uint8_t                             thermalProtectType;
-    uint8_t                             systemFlags;
-    uint8_t                             maxVDDCIndexInPPTable;
-    uint8_t                             extraFlags;
-    uint8_t highSMIO[NISLANDS_MAX_NO_VREG_STEPS];
-    uint32_t lowSMIO[NISLANDS_MAX_NO_VREG_STEPS];
-    NISLANDS_SMC_VOLTAGEMASKTABLE       voltageMaskTable;
-    PP_NIslands_DPM2Parameters          dpm2Params;
-    NISLANDS_SMC_SWSTATE                initialState;
-    NISLANDS_SMC_SWSTATE                ACPIState;
-    NISLANDS_SMC_SWSTATE                ULVState;
-    NISLANDS_SMC_SWSTATE                driverState;
-    NISLANDS_SMC_HW_PERFORMANCE_LEVEL 
dpmLevels[NISLANDS_MAX_SMC_PERFORMANCE_LEVELS_PER_SWSTATE - 1];
+    uint8_t                             thermalProtectType;
+    uint8_t                             systemFlags;
+    uint8_t                             maxVDDCIndexInPPTable;
+    uint8_t                             extraFlags;
+    uint8_t highSMIO[NISLANDS_MAX_NO_VREG_STEPS];
+    uint32_t lowSMIO[NISLANDS_MAX_NO_VREG_STEPS];
+    NISLANDS_SMC_VOLTAGEMASKTABLE       voltageMaskTable;
+    PP_NIslands_DPM2Parameters          dpm2Params;
+    struct NISLANDS_SMC_SWSTATE_SINGLE  initialState;
+    struct NISLANDS_SMC_SWSTATE_SINGLE  ACPIState;
+    struct NISLANDS_SMC_SWSTATE_SINGLE  ULVState;
+    NISLANDS_SMC_SWSTATE                driverState;
+    NISLANDS_SMC_HW_PERFORMANCE_LEVEL 
dpmLevels[NISLANDS_MAX_SMC_PERFORMANCE_LEVELS_PER_SWSTATE];
  };

  typedef struct NISLANDS_SMC_STATETABLE NISLANDS_SMC_STATETABLE;
