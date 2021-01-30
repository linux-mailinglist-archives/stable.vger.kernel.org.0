Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6873D309664
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 16:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhA3Ptg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 10:49:36 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:55527 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232285AbhA3Pri (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 10:47:38 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6773D1944FE3;
        Sat, 30 Jan 2021 10:22:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 30 Jan 2021 10:22:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=14/0fz
        pY6xw03EurHqCEtPhU2rcykU56RulFECV/mu4=; b=mLxSHpDyJ5rDalLU2seH08
        UrUZMDLu/CacRS3g6+w+TR3CqiUhCWjucaPacyhr7huGuISj0E6uKywE7jgaznjf
        s/RLdz+heG95w2eZ2h0CzsclQHwltAzSKQILuID0518Wl2cl4TaUndMLHO4oJIcu
        8+62yM79+FRqqhi0LEdAebNJ8e7XWd24imHvJn6h6Amm12hBH58d/7yHsko8PLPI
        dKbJY6HNUMcoqAA39bfHnqJ1LkXmBtiDrWYlHOg+JlWq5udROtkkut8p0lLglQpy
        J7xtRJYmploJTmAkljHIFt/kOp0r0BHvwz1twjyZTfDfRXNlnDtaZp3Mze2Bj2pw
        ==
X-ME-Sender: <xms:mHkVYJ4Gut7CdV5_mLbBInYpKOgVYWM3ZWPKuAC7oHmpsgBwMcrS1Q>
    <xme:mHkVYG7hxFxi3MIDjggKDuScOuXu3-jvTFwTk0mVdOxoU-fomTm3NnsslEZrJceiK
    _E_cBH2e9cn0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeggdejjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:mHkVYAcoJY9_PGpGyn5g3JyekA1EB4ZKW7BS-JWDxHYh5pkXjefSKg>
    <xmx:mHkVYCLBH5KGgFvtU_B2XzTbDFwPPCBrTAbbtPPK9UJ3DzO465vSbw>
    <xmx:mHkVYNKLpYInkChbwnATwrNCzFhTE5BGMl4SIswW0sCQusKZihvPAw>
    <xmx:mHkVYLgOTbLem8GbUA_66TiEzQLUqxsz_uyyxn6GtKyJszdRL3U30g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F123124005A;
        Sat, 30 Jan 2021 10:21:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] ACPI: thermal: Do not call acpi_thermal_check() directly" failed to apply to 4.4-stable tree
To:     rafael.j.wysocki@intel.com, bigeasy@linutronix.de,
        stable@vger.kernel.org, stephen.berman@gmx.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Jan 2021 16:21:53 +0100
Message-ID: <161202011360145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 81b704d3e4674e09781d331df73d76675d5ad8cb Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Thu, 14 Jan 2021 19:34:22 +0100
Subject: [PATCH] ACPI: thermal: Do not call acpi_thermal_check() directly

Calling acpi_thermal_check() from acpi_thermal_notify() directly
is problematic if _TMP triggers Notify () on the thermal zone for
which it has been evaluated (which happens on some systems), because
it causes a new acpi_thermal_notify() invocation to be queued up
every time and if that takes place too often, an indefinite number of
pending work items may accumulate in kacpi_notify_wq over time.

Besides, it is not really useful to queue up a new invocation of
acpi_thermal_check() if one of them is pending already.

For these reasons, rework acpi_thermal_notify() to queue up a thermal
check instead of calling acpi_thermal_check() directly and only allow
one thermal check to be pending at a time.  Moreover, only allow one
acpi_thermal_check_fn() instance at a time to run
thermal_zone_device_update() for one thermal zone and make it return
early if it sees other instances running for the same thermal zone.

While at it, fold acpi_thermal_check() into acpi_thermal_check_fn(),
as it is only called from there after the other changes made here.

[This issue appears to have been exposed by commit 6d25be5782e4
 ("sched/core, workqueues: Distangle worker accounting from rq
 lock"), but it is unclear why it was not visible earlier.]

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208877
Reported-by: Stephen Berman <stephen.berman@gmx.net>
Diagnosed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Stephen Berman <stephen.berman@gmx.net>
Cc: All applicable <stable@vger.kernel.org>

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 12c0ece746f0..859b1de31ddc 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -174,6 +174,8 @@ struct acpi_thermal {
 	struct thermal_zone_device *thermal_zone;
 	int kelvin_offset;	/* in millidegrees */
 	struct work_struct thermal_check_work;
+	struct mutex thermal_check_lock;
+	refcount_t thermal_check_count;
 };
 
 /* --------------------------------------------------------------------------
@@ -495,14 +497,6 @@ static int acpi_thermal_get_trip_points(struct acpi_thermal *tz)
 	return 0;
 }
 
-static void acpi_thermal_check(void *data)
-{
-	struct acpi_thermal *tz = data;
-
-	thermal_zone_device_update(tz->thermal_zone,
-				   THERMAL_EVENT_UNSPECIFIED);
-}
-
 /* sys I/F for generic thermal sysfs support */
 
 static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
@@ -900,6 +894,12 @@ static void acpi_thermal_unregister_thermal_zone(struct acpi_thermal *tz)
                                  Driver Interface
    -------------------------------------------------------------------------- */
 
+static void acpi_queue_thermal_check(struct acpi_thermal *tz)
+{
+	if (!work_pending(&tz->thermal_check_work))
+		queue_work(acpi_thermal_pm_queue, &tz->thermal_check_work);
+}
+
 static void acpi_thermal_notify(struct acpi_device *device, u32 event)
 {
 	struct acpi_thermal *tz = acpi_driver_data(device);
@@ -910,17 +910,17 @@ static void acpi_thermal_notify(struct acpi_device *device, u32 event)
 
 	switch (event) {
 	case ACPI_THERMAL_NOTIFY_TEMPERATURE:
-		acpi_thermal_check(tz);
+		acpi_queue_thermal_check(tz);
 		break;
 	case ACPI_THERMAL_NOTIFY_THRESHOLDS:
 		acpi_thermal_trips_update(tz, ACPI_TRIPS_REFRESH_THRESHOLDS);
-		acpi_thermal_check(tz);
+		acpi_queue_thermal_check(tz);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  dev_name(&device->dev), event, 0);
 		break;
 	case ACPI_THERMAL_NOTIFY_DEVICES:
 		acpi_thermal_trips_update(tz, ACPI_TRIPS_REFRESH_DEVICES);
-		acpi_thermal_check(tz);
+		acpi_queue_thermal_check(tz);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  dev_name(&device->dev), event, 0);
 		break;
@@ -1020,7 +1020,25 @@ static void acpi_thermal_check_fn(struct work_struct *work)
 {
 	struct acpi_thermal *tz = container_of(work, struct acpi_thermal,
 					       thermal_check_work);
-	acpi_thermal_check(tz);
+
+	/*
+	 * In general, it is not sufficient to check the pending bit, because
+	 * subsequent instances of this function may be queued after one of them
+	 * has started running (e.g. if _TMP sleeps).  Avoid bailing out if just
+	 * one of them is running, though, because it may have done the actual
+	 * check some time ago, so allow at least one of them to block on the
+	 * mutex while another one is running the update.
+	 */
+	if (!refcount_dec_not_one(&tz->thermal_check_count))
+		return;
+
+	mutex_lock(&tz->thermal_check_lock);
+
+	thermal_zone_device_update(tz->thermal_zone, THERMAL_EVENT_UNSPECIFIED);
+
+	refcount_inc(&tz->thermal_check_count);
+
+	mutex_unlock(&tz->thermal_check_lock);
 }
 
 static int acpi_thermal_add(struct acpi_device *device)
@@ -1052,6 +1070,8 @@ static int acpi_thermal_add(struct acpi_device *device)
 	if (result)
 		goto free_memory;
 
+	refcount_set(&tz->thermal_check_count, 3);
+	mutex_init(&tz->thermal_check_lock);
 	INIT_WORK(&tz->thermal_check_work, acpi_thermal_check_fn);
 
 	pr_info(PREFIX "%s [%s] (%ld C)\n", acpi_device_name(device),
@@ -1117,7 +1137,7 @@ static int acpi_thermal_resume(struct device *dev)
 		tz->state.active |= tz->trips.active[i].flags.enabled;
 	}
 
-	queue_work(acpi_thermal_pm_queue, &tz->thermal_check_work);
+	acpi_queue_thermal_check(tz);
 
 	return AE_OK;
 }

