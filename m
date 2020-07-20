Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55484225E8F
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgGTMaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:30:22 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:54917 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727989AbgGTMaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:30:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 673C81940ECC;
        Mon, 20 Jul 2020 08:30:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:30:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Rpng1R
        v+lhUoejB4dA6EOyu/3TVX12zRbvmBvwcrs6g=; b=mAuuU9DO8+O20Ueyg/Ajeh
        5A2MZPGxLfvGneLb5/iLASjvhvzOnCx5Lzp+Aohh/WraSnMQkAv7pcRoCngVjKEV
        8720m5FTUfPSc79UWFMT39HR8Q/E6nb7gbMDC9gQ2vds/KYXyKUgKuFtCHmur54g
        4uMiFfD38YDtvpjQABg8aelVTBWyeajCFm0XdELzh9AI4qGHRq9oJhDjr+5NOlmd
        NmWAfCm+GKDxx3VgIxKXbHYFUs/NxqSYaEZCpcLWLW12S8bjpq4DjWGTbmYFmclk
        6d/7rapQ/WI2/7fl7R7J/4ZZcHJnZjpbQ99EwPrSjNwHQIpJyUlMPWLE/3Kh6V3w
        ==
X-ME-Sender: <xms:W44VX_NM5KkJIYUZ5gl_fq0Mt6pLOR3KQYpZgsISS7valWmO-2N4GA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:W44VX58xUWXY8NlC6ufGHdzJuHTyhMNqKcA--Qk8XVpl4WGAzd-NuQ>
    <xmx:W44VX-RSG65jNEISJkbde5bdYtcHDzlJhxvQMfHmWpLFWQp4I8QPJQ>
    <xmx:W44VXzuPLhXwDsaciIcc0Mgk9G-q7uuHVLNFRsNkNCvhAeZl9As2Nw>
    <xmx:XI4VX3loQimmkO_38SEZFzMyWaRVmc9DIPKzge8XkCoN8E89oU8iGg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7A1393280069;
        Mon, 20 Jul 2020 08:30:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Move cec_notifier to" failed to apply to 5.4-stable tree
To:     maarten.lankhorst@linux.intel.com, daniel.vetter@ffwll.ch,
        jani.nikula@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:30:30 +0200
Message-ID: <1595248230231200@kroah.com>
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

From 6647e6cdba753e71170be7da2acfead7154f56d8 Mon Sep 17 00:00:00 2001
From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Date: Wed, 12 Feb 2020 14:54:45 +0100
Subject: [PATCH] drm/i915: Move cec_notifier to
 intel_hdmi_connector_unregister, v2.

This fixes the following KASAN splash on module reload:
[  145.136327] ==================================================================
[  145.136502] BUG: KASAN: use-after-free in intel_hdmi_destroy+0x74/0x80 [i915]
[  145.136514] Read of size 8 at addr ffff888216641830 by task kworker/1:1/134

[  145.136535] CPU: 1 PID: 134 Comm: kworker/1:1 Tainted: G     U          T 5.5.0-rc7-valkyria+ #5783
[  145.136539] Hardware name: GIGABYTE GB-BKi3A-7100/MFLP3AP-00, BIOS F1 07/27/2016
[  145.136546] Workqueue: events drm_connector_free_work_fn
[  145.136551] Call Trace:
[  145.136560]  dump_stack+0xa1/0xe0
[  145.136571]  print_address_description.constprop.0+0x1e/0x210
[  145.136639]  ? intel_hdmi_destroy+0x74/0x80 [i915]
[  145.136703]  ? intel_hdmi_destroy+0x74/0x80 [i915]
[  145.136710]  __kasan_report.cold+0x1b/0x37
[  145.136790]  ? intel_hdmi_destroy+0x74/0x80 [i915]
[  145.136863]  ? intel_hdmi_destroy+0x74/0x80 [i915]
[  145.136870]  kasan_report+0x27/0x30
[  145.136881]  __asan_report_load8_noabort+0x1c/0x20
[  145.136946]  intel_hdmi_destroy+0x74/0x80 [i915]
[  145.136954]  drm_connector_free_work_fn+0xd1/0x100
[  145.136967]  process_one_work+0x86e/0x1610
[  145.136987]  ? pwq_dec_nr_in_flight+0x2f0/0x2f0
[  145.137004]  ? move_linked_works+0x128/0x2c0
[  145.137021]  worker_thread+0x63e/0xc90
[  145.137048]  kthread+0x2f6/0x3f0
[  145.137054]  ? calculate_sigpending+0x81/0xa0
[  145.137059]  ? process_one_work+0x1610/0x1610
[  145.137064]  ? kthread_bind+0x40/0x40
[  145.137075]  ret_from_fork+0x24/0x30

[  145.137111] Allocated by task 0:
[  145.137119] (stack is not available)

[  145.137137] Freed by task 5053:
[  145.137147]  save_stack+0x28/0x90
[  145.137152]  __kasan_slab_free+0x136/0x180
[  145.137157]  kasan_slab_free+0x26/0x30
[  145.137161]  kfree+0xe6/0x350
[  145.137242]  intel_ddi_encoder_destroy+0x60/0x80 [i915]
[  145.137252]  drm_mode_config_cleanup+0x11d/0x8f0
[  145.137329]  intel_modeset_driver_remove+0x1f5/0x350 [i915]
[  145.137403]  i915_driver_remove+0xc4/0x130 [i915]
[  145.137482]  i915_pci_remove+0x3e/0x90 [i915]
[  145.137489]  pci_device_remove+0x108/0x2d0
[  145.137494]  device_release_driver_internal+0x1e6/0x4a0
[  145.137499]  driver_detach+0xcb/0x198
[  145.137503]  bus_remove_driver+0xde/0x204
[  145.137508]  driver_unregister+0x6d/0xa0
[  145.137513]  pci_unregister_driver+0x2e/0x230
[  145.137576]  i915_exit+0x1f/0x26 [i915]
[  145.137157]  kasan_slab_free+0x26/0x30
[  145.137161]  kfree+0xe6/0x350
[  145.137242]  intel_ddi_encoder_destroy+0x60/0x80 [i915]
[  145.137252]  drm_mode_config_cleanup+0x11d/0x8f0
[  145.137329]  intel_modeset_driver_remove+0x1f5/0x350 [i915]
[  145.137403]  i915_driver_remove+0xc4/0x130 [i915]
[  145.137482]  i915_pci_remove+0x3e/0x90 [i915]
[  145.137489]  pci_device_remove+0x108/0x2d0
[  145.137494]  device_release_driver_internal+0x1e6/0x4a0
[  145.137499]  driver_detach+0xcb/0x198
[  145.137503]  bus_remove_driver+0xde/0x204
[  145.137508]  driver_unregister+0x6d/0xa0
[  145.137513]  pci_unregister_driver+0x2e/0x230
[  145.137576]  i915_exit+0x1f/0x26 [i915]
[  145.137581]  __x64_sys_delete_module+0x35b/0x470
[  145.137586]  do_syscall_64+0x99/0x4e0
[  145.137591]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

[  145.137606] The buggy address belongs to the object at ffff888216640000
                which belongs to the cache kmalloc-8k of size 8192
[  145.137618] The buggy address is located 6192 bytes inside of
                8192-byte region [ffff888216640000, ffff888216642000)
[  145.137630] The buggy address belongs to the page:
[  145.137640] page:ffffea0008599000 refcount:1 mapcount:0 mapping:ffff888107c02a80 index:0xffff888216644000 compound_mapcount: 0
[  145.137647] raw: 0200000000010200 0000000000000000 0000000100000001 ffff888107c02a80
[  145.137652] raw: ffff888216644000 0000000080020001 00000001ffffffff 0000000000000000
[  145.137656] page dumped because: kasan: bad access detected

[  145.137668] Memory state around the buggy address:
[  145.137678]  ffff888216641700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  145.137687]  ffff888216641780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  145.137697] >ffff888216641800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  145.137706]                                      ^
[  145.137715]  ffff888216641880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  145.137724]  ffff888216641900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  145.137733] ==================================================================
[  145.137742] Disabling lock debugging due to kernel taint

Changes since v1:
- Add fixes tags.
- Use early unregister.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Fixes: 9c229127aee2 ("drm/i915: hdmi: add CEC notifier to intel_hdmi")
Cc: <stable@vger.kernel.org> # v4.19+
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20200212135445.1469133-1-maarten.lankhorst@linux.intel.com
(cherry picked from commit a581483b1e5466d28fc50ff623fba31cea2cccb6)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
index 010f37240710..95b6d9457910 100644
--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -2867,19 +2867,13 @@ intel_hdmi_connector_register(struct drm_connector *connector)
 	return ret;
 }
 
-static void intel_hdmi_destroy(struct drm_connector *connector)
+static void intel_hdmi_connector_unregister(struct drm_connector *connector)
 {
 	struct cec_notifier *n = intel_attached_hdmi(to_intel_connector(connector))->cec_notifier;
 
 	cec_notifier_conn_unregister(n);
 
-	intel_connector_destroy(connector);
-}
-
-static void intel_hdmi_connector_unregister(struct drm_connector *connector)
-{
 	intel_hdmi_remove_i2c_symlink(connector);
-
 	intel_connector_unregister(connector);
 }
 
@@ -2891,7 +2885,7 @@ static const struct drm_connector_funcs intel_hdmi_connector_funcs = {
 	.atomic_set_property = intel_digital_connector_atomic_set_property,
 	.late_register = intel_hdmi_connector_register,
 	.early_unregister = intel_hdmi_connector_unregister,
-	.destroy = intel_hdmi_destroy,
+	.destroy = intel_connector_destroy,
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 	.atomic_duplicate_state = intel_digital_connector_duplicate_state,
 };

