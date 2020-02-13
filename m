Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F86915B88B
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 05:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgBMEY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 23:24:58 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:51193 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729358AbgBMEY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 23:24:57 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 545D4F42;
        Wed, 12 Feb 2020 23:24:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 12 Feb 2020 23:24:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KmhayC
        RDuftOR1aWaKbNa4WfsJQSVZ+wFxrdx4t2RgM=; b=AnMJzoamNVqvAZFFReB9JL
        VQW3mLhsvY/E/uy7T36Bo7ysvSdKug5cWXAu9e995gp1SiWNa/tE78y9XB2LaCDd
        BddX5cOHvH1885j18ocBSJWJH19csIf+fbWvlCbibP3pKuyJCr40fIRRMjyI50Ao
        reUNqVJ5FhKVKq1rQo8gfnTVBuEMdFb3yASFaxqnPilt6XdCP3dyoRpdFVXyk67/
        6R5FoLhy9r6Dm66zmg8Lpx3JNZUYZocYOcDUywVJsvZtpnK5qkEDpv//H9f9oTTg
        tJ1yh2dT0SwQe/auszAf420flCeA2cL1vLpEy9/Akv7fXp/v8+dlDT4ZxpuBfIAw
        ==
X-ME-Sender: <xms:l89EXrEcUdOYUO-QMbe02qU4HLpEW1FCQWHZDZ95z0s1qclhWQe83Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrieejgdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedvtdelrdefjedrleejrd
    duleegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:l89EXg7wGbkYVgpB9_rDTwtes0DuC_RLa1YyI8z0JxTxAdkuU7W6FQ>
    <xmx:l89EXk6GR8Y-yQZJjLili89hApP64PhE_yRs6-OS9opCEEClsK1i7Q>
    <xmx:l89EXiCo3jyVlUPH6F7A3MyCX2C1zbq0_aRUHJPkPnYii6XYxG5iYQ>
    <xmx:l89EXu0gaxWre9f2IDrxn8SFu6uMkmODYANMlzCinsaCcQ3jSZT6Sw>
Received: from localhost (unknown [209.37.97.194])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9F79630600DC;
        Wed, 12 Feb 2020 23:24:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] pinctrl: qcom: Don't lock around irq_set_irq_wake()" failed to apply to 4.4-stable tree
To:     swboyd@chromium.org, bjorn.andersson@linaro.org,
        dianders@chromium.org, ilina@codeaurora.org,
        linus.walleij@linaro.org, masneyb@onstation.org,
        mkshah@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Feb 2020 20:24:54 -0800
Message-ID: <1581567894125165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1d44616e7549d0154c1224a3eee3c407029294dc Mon Sep 17 00:00:00 2001
From: Stephen Boyd <swboyd@chromium.org>
Date: Tue, 21 Jan 2020 10:09:50 -0800
Subject: [PATCH] pinctrl: qcom: Don't lock around irq_set_irq_wake()

We don't need to hold the local pinctrl lock here to set irq wake on the
summary irq line. Doing so only leads to lockdep warnings instead of
protecting us from anything. Remove the locking.

 WARNING: possible circular locking dependency detected
 5.4.11 #2 Tainted: G        W
 ------------------------------------------------------
 cat/3083 is trying to acquire lock:
 ffffff81f4fa58c0 (&irq_desc_lock_class){-.-.}, at: __irq_get_desc_lock+0x64/0x94

 but task is already holding lock:
 ffffff81f4880c18 (&pctrl->lock){-.-.}, at: msm_gpio_irq_set_wake+0x48/0x7c

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (&pctrl->lock){-.-.}:
        _raw_spin_lock_irqsave+0x64/0x80
        msm_gpio_irq_ack+0x68/0xf4
        __irq_do_set_handler+0xe0/0x180
        __irq_set_handler+0x60/0x9c
        irq_domain_set_info+0x90/0xb4
        gpiochip_hierarchy_irq_domain_alloc+0x110/0x200
        __irq_domain_alloc_irqs+0x130/0x29c
        irq_create_fwspec_mapping+0x1f0/0x300
        irq_create_of_mapping+0x70/0x98
        of_irq_get+0xa4/0xd4
        spi_drv_probe+0x4c/0xb0
        really_probe+0x138/0x3f0
        driver_probe_device+0x70/0x140
        __device_attach_driver+0x9c/0x110
        bus_for_each_drv+0x88/0xd0
        __device_attach+0xb0/0x160
        device_initial_probe+0x20/0x2c
        bus_probe_device+0x34/0x94
        device_add+0x35c/0x3f0
        spi_add_device+0xbc/0x194
        of_register_spi_devices+0x2c8/0x408
        spi_register_controller+0x57c/0x6fc
        spi_geni_probe+0x260/0x328
        platform_drv_probe+0x90/0xb0
        really_probe+0x138/0x3f0
        driver_probe_device+0x70/0x140
        device_driver_attach+0x4c/0x6c
        __driver_attach+0xcc/0x154
        bus_for_each_dev+0x84/0xcc
        driver_attach+0x2c/0x38
        bus_add_driver+0x108/0x1fc
        driver_register+0x64/0xf8
        __platform_driver_register+0x4c/0x58
        spi_geni_driver_init+0x1c/0x24
        do_one_initcall+0x1a4/0x3e8
        do_initcall_level+0xb4/0xcc
        do_basic_setup+0x30/0x48
        kernel_init_freeable+0x124/0x1a8
        kernel_init+0x14/0x100
        ret_from_fork+0x10/0x18

 -> #0 (&irq_desc_lock_class){-.-.}:
        __lock_acquire+0xeb4/0x2388
        lock_acquire+0x1cc/0x210
        _raw_spin_lock_irqsave+0x64/0x80
        __irq_get_desc_lock+0x64/0x94
        irq_set_irq_wake+0x40/0x144
        msm_gpio_irq_set_wake+0x5c/0x7c
        set_irq_wake_real+0x40/0x5c
        irq_set_irq_wake+0x70/0x144
        cros_ec_rtc_suspend+0x38/0x4c
        platform_pm_suspend+0x34/0x60
        dpm_run_callback+0x64/0xcc
        __device_suspend+0x310/0x41c
        dpm_suspend+0xf8/0x298
        dpm_suspend_start+0x84/0xb4
        suspend_devices_and_enter+0xbc/0x620
        pm_suspend+0x210/0x348
        state_store+0xb0/0x108
        kobj_attr_store+0x14/0x24
        sysfs_kf_write+0x4c/0x64
        kernfs_fop_write+0x15c/0x1fc
        __vfs_write+0x54/0x18c
        vfs_write+0xe4/0x1a4
        ksys_write+0x7c/0xe4
        __arm64_sys_write+0x20/0x2c
        el0_svc_common+0xa8/0x160
        el0_svc_handler+0x7c/0x98
        el0_svc+0x8/0xc

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&pctrl->lock);
                                lock(&irq_desc_lock_class);
                                lock(&pctrl->lock);
   lock(&irq_desc_lock_class);

  *** DEADLOCK ***

 7 locks held by cat/3083:
  #0: ffffff81f06d1420 (sb_writers#7){.+.+}, at: vfs_write+0xd0/0x1a4
  #1: ffffff81c8935680 (&of->mutex){+.+.}, at: kernfs_fop_write+0x12c/0x1fc
  #2: ffffff81f4c322f0 (kn->count#337){.+.+}, at: kernfs_fop_write+0x134/0x1fc
  #3: ffffffe89a641d60 (system_transition_mutex){+.+.}, at: pm_suspend+0x108/0x348
  #4: ffffff81f190e970 (&dev->mutex){....}, at: __device_suspend+0x168/0x41c
  #5: ffffff81f183d8c0 (lock_class){-.-.}, at: __irq_get_desc_lock+0x64/0x94
  #6: ffffff81f4880c18 (&pctrl->lock){-.-.}, at: msm_gpio_irq_set_wake+0x48/0x7c

 stack backtrace:
 CPU: 4 PID: 3083 Comm: cat Tainted: G        W         5.4.11 #2
 Hardware name: Google Cheza (rev3+) (DT)
 Call trace:
  dump_backtrace+0x0/0x174
  show_stack+0x20/0x2c
  dump_stack+0xc8/0x124
  print_circular_bug+0x2ac/0x2c4
  check_noncircular+0x1a0/0x1a8
  __lock_acquire+0xeb4/0x2388
  lock_acquire+0x1cc/0x210
  _raw_spin_lock_irqsave+0x64/0x80
  __irq_get_desc_lock+0x64/0x94
  irq_set_irq_wake+0x40/0x144
  msm_gpio_irq_set_wake+0x5c/0x7c
  set_irq_wake_real+0x40/0x5c
  irq_set_irq_wake+0x70/0x144
  cros_ec_rtc_suspend+0x38/0x4c
  platform_pm_suspend+0x34/0x60
  dpm_run_callback+0x64/0xcc
  __device_suspend+0x310/0x41c
  dpm_suspend+0xf8/0x298
  dpm_suspend_start+0x84/0xb4
  suspend_devices_and_enter+0xbc/0x620
  pm_suspend+0x210/0x348
  state_store+0xb0/0x108
  kobj_attr_store+0x14/0x24
  sysfs_kf_write+0x4c/0x64
  kernfs_fop_write+0x15c/0x1fc
  __vfs_write+0x54/0x18c
  vfs_write+0xe4/0x1a4
  ksys_write+0x7c/0xe4
  __arm64_sys_write+0x20/0x2c
  el0_svc_common+0xa8/0x160
  el0_svc_handler+0x7c/0x98
  el0_svc+0x8/0xc

Fixes: 6aced33f4974 ("pinctrl: msm: drop wake_irqs bitmap")
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Brian Masney <masneyb@onstation.org>
Cc: Lina Iyer <ilina@codeaurora.org>
Cc: Maulik Shah <mkshah@codeaurora.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20200121180950.36959-1-swboyd@chromium.org
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 5d6f9f61ce02..9a8daa256a32 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -960,7 +960,6 @@ static int msm_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
-	unsigned long flags;
 
 	/*
 	 * While they may not wake up when the TLMM is powered off,
@@ -971,12 +970,8 @@ static int msm_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 	if (d->parent_data)
 		irq_chip_set_wake_parent(d, on);
 
-	raw_spin_lock_irqsave(&pctrl->lock, flags);
-
 	irq_set_irq_wake(pctrl->irq, on);
 
-	raw_spin_unlock_irqrestore(&pctrl->lock, flags);
-
 	return 0;
 }
 

