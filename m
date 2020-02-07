Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74AA7155403
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 09:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgBGIx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 03:53:58 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54249 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726417AbgBGIx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 03:53:58 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 635CA21F40;
        Fri,  7 Feb 2020 03:53:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 07 Feb 2020 03:53:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=py/p1V
        4Yj3vPaIkGuA2J5B2DBLymOrvnQo1+1XLEYkQ=; b=er3nqAxVzgJvoB6yfLcGOM
        wIiTA1NvmDllcGzQKyPmyDTp6EBT5PWYghQVVIt6IGqJgQedPHwmKWDfCgS8J/xX
        MLYYYn54fwJUPtQX9Ma5pb5GaPJWj2WftjhzhGza9eoAXjcLlPi06xG0BQpYEdF4
        pbF74TIPvks5jD16+GGkiB5hXv6xzMxFIh8G5T9LzhaycHuCKMbm4iyan0MzAzPM
        yr5u3beP/RRd/HLS+qDbLE3BpRh9LGR95ivZOmdcQEHqy6mWgKP5UiHAhCiB/VBO
        kIU0mndon7oHAnftBI078rUtEJjNzPuNfOvXmeDzH8wqRZ3xL3BpLiAyLtpJzQVg
        ==
X-ME-Sender: <xms:pSU9XhbOqomQBCtU0AYU2_pO1VzLWoocw8SPjSyn6_oqnqpSub0z8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheeggdduvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehsuhhsvgdrtghomhdpkhgvrhhnvghlrdhorhhgnecukfhppe
    ekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:pSU9Xj7N-FdaIukFxr3qzm_2fL2LbSNG2al2fTspAjS6-tlgWjUm5A>
    <xmx:pSU9Xq9aUUbvLqYiTr6DoNU-HYCQRV4njGDu41nC0n204raEb7sJHg>
    <xmx:pSU9XoncRdz0Px0Go1odh4kytHb6DO223C195HoDwSBxaOHbM-rpCA>
    <xmx:pSU9XnJMg367kXT1qhn47S0LL7PMPETtloLsJQEcv62Se-HkLPiKKA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 040BF30606E9;
        Fri,  7 Feb 2020 03:53:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] ASoC: SOF: core: release resources on errors in" failed to apply to 5.4-stable tree
To:     pierre-louis.bossart@linux.intel.com, broonie@kernel.org,
        kai.vehmanen@linux.intel.com, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Feb 2020 09:53:47 +0100
Message-ID: <15810656279576@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 410e5e55c9c1c9c0d452ac5b9adb37b933a7747e Mon Sep 17 00:00:00 2001
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Date: Fri, 24 Jan 2020 15:36:21 -0600
Subject: [PATCH] ASoC: SOF: core: release resources on errors in
 probe_continue

The initial intent of releasing resources in the .remove does not work
well with HDaudio codecs. If the probe_continue() fails in a work
queue, e.g. due to missing firmware or authentication issues, we don't
release any resources, and as a result the kernel oopses during
suspend operations.

The suggested fix is to release all resources during errors in
probe_continue(), and use fw_state to track resource allocation
state, so that .remove does not attempt to release the same
hardware resources twice. PM operations are also modified so that
no action is done if DSP resources have been freed due to
an error at probe.

Reported-by: Takashi Iwai <tiwai@suse.de>
Co-developed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Bugzilla:  http://bugzilla.suse.com/show_bug.cgi?id=1161246
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20200124213625.30186-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index f517ab448a1d..34cefbaf2d2a 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -244,7 +244,6 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 
 	return 0;
 
-#if !IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE)
 fw_trace_err:
 	snd_sof_free_trace(sdev);
 fw_run_err:
@@ -255,22 +254,10 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 	snd_sof_free_debug(sdev);
 dbg_err:
 	snd_sof_remove(sdev);
-#else
 
-	/*
-	 * when the probe_continue is handled in a work queue, the
-	 * probe does not fail so we don't release resources here.
-	 * They will be released with an explicit call to
-	 * snd_sof_device_remove() when the PCI/ACPI device is removed
-	 */
-
-fw_trace_err:
-fw_run_err:
-fw_load_err:
-ipc_err:
-dbg_err:
-
-#endif
+	/* all resources freed, update state to match */
+	sdev->fw_state = SOF_FW_BOOT_NOT_STARTED;
+	sdev->first_boot = true;
 
 	return ret;
 }
@@ -353,10 +340,12 @@ int snd_sof_device_remove(struct device *dev)
 	if (IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE))
 		cancel_work_sync(&sdev->probe_work);
 
-	snd_sof_fw_unload(sdev);
-	snd_sof_ipc_free(sdev);
-	snd_sof_free_debug(sdev);
-	snd_sof_free_trace(sdev);
+	if (sdev->fw_state > SOF_FW_BOOT_NOT_STARTED) {
+		snd_sof_fw_unload(sdev);
+		snd_sof_ipc_free(sdev);
+		snd_sof_free_debug(sdev);
+		snd_sof_free_trace(sdev);
+	}
 
 	/*
 	 * Unregister machine driver. This will unbind the snd_card which
@@ -364,13 +353,15 @@ int snd_sof_device_remove(struct device *dev)
 	 * before freeing the snd_card.
 	 */
 	snd_sof_machine_unregister(sdev, pdata);
+
 	/*
 	 * Unregistering the machine driver results in unloading the topology.
 	 * Some widgets, ex: scheduler, attempt to power down the core they are
 	 * scheduled on, when they are unloaded. Therefore, the DSP must be
 	 * removed only after the topology has been unloaded.
 	 */
-	snd_sof_remove(sdev);
+	if (sdev->fw_state > SOF_FW_BOOT_NOT_STARTED)
+		snd_sof_remove(sdev);
 
 	/* release firmware */
 	release_firmware(pdata->fw);
diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index 84290bbeebdd..a0cde053b61a 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -56,6 +56,10 @@ static int sof_resume(struct device *dev, bool runtime_resume)
 	if (!sof_ops(sdev)->resume || !sof_ops(sdev)->runtime_resume)
 		return 0;
 
+	/* DSP was never successfully started, nothing to resume */
+	if (sdev->first_boot)
+		return 0;
+
 	/*
 	 * if the runtime_resume flag is set, call the runtime_resume routine
 	 * or else call the system resume routine

