Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719192C6B11
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 18:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732669AbgK0R4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 12:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732645AbgK0R4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 12:56:43 -0500
Received: from mx3.securetransport.de (mx3.securetransport.de [IPv6:2a01:4f8:c0c:92be::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC9BC0613D1
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 09:56:43 -0800 (PST)
Received: from mail.dh-electronics.com (business-24-134-97-169.pool2.vodafone-ip.de [24.134.97.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx3.securetransport.de (Postfix) with ESMTPSA id 6C6665DD13;
        Fri, 27 Nov 2020 18:56:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dh-electronics.com;
        s=dhelectronicscom; t=1606499793;
        bh=VD+4caXbgtqd/IKA+GMdY+bZDuxEofHAbSYWkIRQz4w=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=KJm89EtiqLW/PMFyAa5UFTAeAKL764bSaJpmba3nHmwOnKpnP4Ds+Kp/+6ODCMd6t
         3D4bejB4gmJlJNQy0K47QjHyEvnVEyA26HTRmCVUmoB8V1v1/679ymq8C58fag2BeQ
         WqzU8srhbVF9qDyEbwtadVoHJwpz1X9NVsKouyY/XPCn5fNYdFcIbxiQ3ux2rmvnJh
         3hkTKxB/ayXTTp0F8jULWH8c2pXW9epnZPnfS7NOouCyq6slqgQ75eq2f92Op7LgO7
         3BsNLMKWWlCIAP8htXtRKy7yJ2jXTrvJCWNMpbjSZYdDRJwFW2/DGxs8J2Ya9BEShy
         MOILkL9SwAFWA==
Received: from DHPWEX01.DH-ELECTRONICS.ORG (2001:470:76a7:2::30) by
 DHPWEX01.DH-ELECTRONICS.ORG (2001:470:76a7:2::30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.659.4;
 Fri, 27 Nov 2020 18:56:24 +0100
Received: from DHPWEX01.DH-ELECTRONICS.ORG ([fe80::6ced:fa7f:9a9c:e579]) by
 DHPWEX01.DH-ELECTRONICS.ORG ([fe80::6ced:fa7f:9a9c:e579%6]) with mapi id
 15.02.0659.008; Fri, 27 Nov 2020 18:56:24 +0100
X-secureTransport-forwarded: yes
From:   Christoph Niedermaier <cniedermaier@dh-electronics.com>
Complaints-To: abuse@cubewerk.de
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Missing fixes commit on linux-4.19.y
Thread-Topic: Missing fixes commit on linux-4.19.y
Thread-Index: AdbExCWIB6Z0M2MSQfq9plHp14n48v//9LYA///OO1A=
Date:   Fri, 27 Nov 2020 17:56:24 +0000
Message-ID: <87296404bad145d2a84173edcfd5a231@dh-electronics.com>
References: <86287ab712444551b3740703a8092aa8@dh-electronics.com>
 <X8EIikqJig6iNCOD@kroah.com>
In-Reply-To: <X8EIikqJig6iNCOD@kroah.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.3.50]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg KH [mailto:gregkh@linuxfoundation.org]
Sent: Friday, November 27, 2020 3:09 PM

Hello Greg,

>> Is it possible to apply the following commit on the branch linux-4.19.y?
>> de9f8eea5a44 ("drm/atomic_helper: Stop modesets on unregistered connecto=
rs harder")
>>
>> This commit is applied to the other LTS kernels, but is missing on
>> linux-4.19.y.
>=20
> I see it showing up in the 4.20 release, so of course anything newer
> than that will work, what other trees do you see this applied in?

I think it's only the 4.19 tree that misses this patch, because it fixes
"drm/atomic_helper: Disallow new modesets on unregistered connectors"
and=20
"drm/atomic_helper: Allow DPMS On<->Off changes for unregistered connectors=
"
If I am right this two commits aren't on 4.14 / 4.9 / 4.4

>> Without this patch my i.MX6ULL SoM doesn't initialize
>> the display correctly after booting.
>=20
> It does not apply cleanly to the 4.19.y tree, can you provide a working
> backport so that we could apply it?

A working backport is below.

Best regards,
Christoph

---------------------------------------------------------------------------=
-----
From aa35780af151795af2dbb764ae99064926b972e1 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Tue, 16 Oct 2018 16:39:46 -0400
Subject: [PATCH] drm/atomic_helper: Stop modesets on unregistered connector=
s
 harder
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Unfortunately, it appears our fix in:
commit b5d29843d8ef ("drm/atomic_helper: Allow DPMS On<->Off changes
for unregistered connectors")

Which attempted to work around the problems introduced by:
commit 4d80273976bf ("drm/atomic_helper: Disallow new modesets on
unregistered connectors")

Is still not the right solution, as modesets can still be triggered
outside of drm_atomic_set_crtc_for_connector().

So in order to fix this, while still being careful that we don't break
modesets that a driver may perform before being registered with
userspace, we replace connector->registered with a tristate member,
connector->registration_state. This allows us to keep track of whether
or not a connector is still initializing and hasn't been exposed to
userspace, is currently registered and exposed to userspace, or has been
legitimately removed from the system after having once been present.

Using this info, we can prevent userspace from performing new modesets
on unregistered connectors while still allowing the driver to perform
modesets on unregistered connectors before the driver has finished being
registered.

Changes since v1:
- Fix WARN_ON() in drm_connector_cleanup() that CI caught with this
  patchset in igt@drv_module_reload@basic-reload-inject and
  igt@drv_module_reload@basic-reload by checking if the connector is
  registered instead of unregistered, as calling drm_connector_cleanup()
  on a connector that hasn't been registered with userspace yet should
  stay valid.
- Remove unregistered_connector_check(), and just go back to what we
  were doing before in commit 4d80273976bf ("drm/atomic_helper: Disallow
  new modesets on unregistered connectors") except replacing
  READ_ONCE(connector->registered) with drm_connector_is_unregistered().
  This gets rid of the behavior of allowing DPMS On<->Off, but that should
  be fine as it's more consistent with the UAPI we had before - danvet
- s/drm_connector_unregistered/drm_connector_is_unregistered/ - danvet
- Update documentation, fix some typos.

Fixes: b5d29843d8ef ("drm/atomic_helper: Allow DPMS On<->Off changes for un=
registered connectors")
Cc: Ville Syrj=E4l=E4 <ville.syrjala@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: stable@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20181016203946.9601-1-l=
yude@redhat.com
---
 drivers/gpu/drm/drm_atomic.c        | 21 -----------
 drivers/gpu/drm/drm_atomic_helper.c | 21 ++++++++++-
 drivers/gpu/drm/drm_connector.c     | 11 +++---
 drivers/gpu/drm/i915/intel_dp_mst.c |  8 ++---
 include/drm/drm_connector.h         | 71 +++++++++++++++++++++++++++++++++=
++--
 5 files changed, 99 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index 1a4b44923aec..281cf9cbb44c 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1702,27 +1702,6 @@ drm_atomic_set_crtc_for_connector(struct drm_connect=
or_state *conn_state,
 	struct drm_connector *connector =3D conn_state->connector;
 	struct drm_crtc_state *crtc_state;
=20
-	/*
-	 * For compatibility with legacy users, we want to make sure that
-	 * we allow DPMS On<->Off modesets on unregistered connectors, since
-	 * legacy modesetting users will not be expecting these to fail. We do
-	 * not however, want to allow legacy users to assign a connector
-	 * that's been unregistered from sysfs to another CRTC, since doing
-	 * this with a now non-existent connector could potentially leave us
-	 * in an invalid state.
-	 *
-	 * Since the connector can be unregistered at any point during an
-	 * atomic check or commit, this is racy. But that's OK: all we care
-	 * about is ensuring that userspace can't use this connector for new
-	 * configurations after it's been notified that the connector is no
-	 * longer present.
-	 */
-	if (!READ_ONCE(connector->registered) && crtc) {
-		DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] is not registered\n",
-				 connector->base.id, connector->name);
-		return -EINVAL;
-	}
-
 	if (conn_state->crtc =3D=3D crtc)
 		return 0;
=20
diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atom=
ic_helper.c
index c22062cc9992..d24a15484e31 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -307,6 +307,26 @@ update_connector_routing(struct drm_atomic_state *stat=
e,
 		return 0;
 	}
=20
+	crtc_state =3D drm_atomic_get_new_crtc_state(state,
+						   new_connector_state->crtc);
+	/*
+	 * For compatibility with legacy users, we want to make sure that
+	 * we allow DPMS On->Off modesets on unregistered connectors. Modesets
+	 * which would result in anything else must be considered invalid, to
+	 * avoid turning on new displays on dead connectors.
+	 *
+	 * Since the connector can be unregistered at any point during an
+	 * atomic check or commit, this is racy. But that's OK: all we care
+	 * about is ensuring that userspace can't do anything but shut off the
+	 * display on a connector that was destroyed after its been notified,
+	 * not before.
+	 */
+	if (drm_connector_is_unregistered(connector) && crtc_state->active) {
+		DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] is not registered\n",
+				 connector->base.id, connector->name);
+		return -EINVAL;
+	}
+
 	funcs =3D connector->helper_private;
=20
 	if (funcs->atomic_best_encoder)
@@ -351,7 +371,6 @@ update_connector_routing(struct drm_atomic_state *state=
,
=20
 	set_best_encoder(state, new_connector_state, new_encoder);
=20
-	crtc_state =3D drm_atomic_get_new_crtc_state(state, new_connector_state->=
crtc);
 	crtc_state->connectors_changed =3D true;
=20
 	DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] using [ENCODER:%d:%s] on [CRTC:%d:%s]=
\n",
diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connecto=
r.c
index 6011d769d50b..7bb68ca4aa0b 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -375,7 +375,8 @@ void drm_connector_cleanup(struct drm_connector *connec=
tor)
 	/* The connector should have been removed from userspace long before
 	 * it is finally destroyed.
 	 */
-	if (WARN_ON(connector->registered))
+	if (WARN_ON(connector->registration_state =3D=3D
+		    DRM_CONNECTOR_REGISTERED))
 		drm_connector_unregister(connector);
=20
 	if (connector->tile_group) {
@@ -432,7 +433,7 @@ int drm_connector_register(struct drm_connector *connec=
tor)
 		return 0;
=20
 	mutex_lock(&connector->mutex);
-	if (connector->registered)
+	if (connector->registration_state !=3D DRM_CONNECTOR_INITIALIZING)
 		goto unlock;
=20
 	ret =3D drm_sysfs_connector_add(connector);
@@ -452,7 +453,7 @@ int drm_connector_register(struct drm_connector *connec=
tor)
=20
 	drm_mode_object_register(connector->dev, &connector->base);
=20
-	connector->registered =3D true;
+	connector->registration_state =3D DRM_CONNECTOR_REGISTERED;
 	goto unlock;
=20
 err_debugfs:
@@ -474,7 +475,7 @@ EXPORT_SYMBOL(drm_connector_register);
 void drm_connector_unregister(struct drm_connector *connector)
 {
 	mutex_lock(&connector->mutex);
-	if (!connector->registered) {
+	if (connector->registration_state !=3D DRM_CONNECTOR_REGISTERED) {
 		mutex_unlock(&connector->mutex);
 		return;
 	}
@@ -485,7 +486,7 @@ void drm_connector_unregister(struct drm_connector *con=
nector)
 	drm_sysfs_connector_remove(connector);
 	drm_debugfs_connector_remove(connector);
=20
-	connector->registered =3D false;
+	connector->registration_state =3D DRM_CONNECTOR_UNREGISTERED;
 	mutex_unlock(&connector->mutex);
 }
 EXPORT_SYMBOL(drm_connector_unregister);
diff --git a/drivers/gpu/drm/i915/intel_dp_mst.c b/drivers/gpu/drm/i915/int=
el_dp_mst.c
index c7d52c66ff29..8a19cfcfc4f1 100644
--- a/drivers/gpu/drm/i915/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/intel_dp_mst.c
@@ -77,7 +77,7 @@ static bool intel_dp_mst_compute_config(struct intel_enco=
der *encoder,
 	pipe_config->pbn =3D mst_pbn;
=20
 	/* Zombie connectors can't have VCPI slots */
-	if (READ_ONCE(connector->registered)) {
+	if (!drm_connector_is_unregistered(connector)) {
 		slots =3D drm_dp_atomic_find_vcpi_slots(state,
 						      &intel_dp->mst_mgr,
 						      port,
@@ -317,7 +317,7 @@ static int intel_dp_mst_get_ddc_modes(struct drm_connec=
tor *connector)
 	struct edid *edid;
 	int ret;
=20
-	if (!READ_ONCE(connector->registered))
+	if (drm_connector_is_unregistered(connector))
 		return intel_connector_update_modes(connector, NULL);
=20
 	edid =3D drm_dp_mst_get_edid(connector, &intel_dp->mst_mgr, intel_connect=
or->port);
@@ -333,7 +333,7 @@ intel_dp_mst_detect(struct drm_connector *connector, bo=
ol force)
 	struct intel_connector *intel_connector =3D to_intel_connector(connector)=
;
 	struct intel_dp *intel_dp =3D intel_connector->mst_port;
=20
-	if (!READ_ONCE(connector->registered))
+	if (drm_connector_is_unregistered(connector))
 		return connector_status_disconnected;
 	return drm_dp_mst_detect_port(connector, &intel_dp->mst_mgr,
 				      intel_connector->port);
@@ -376,7 +376,7 @@ intel_dp_mst_mode_valid(struct drm_connector *connector=
,
 	int bpp =3D 24; /* MST uses fixed bpp */
 	int max_rate, mode_rate, max_lanes, max_link_clock;
=20
-	if (!READ_ONCE(connector->registered))
+	if (drm_connector_is_unregistered(connector))
 		return MODE_ERROR;
=20
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index 97ea41dc678f..e5f641cdab5a 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -81,6 +81,53 @@ enum drm_connector_status {
 	connector_status_unknown =3D 3,
 };
=20
+/**
+ * enum drm_connector_registration_status - userspace registration status =
for
+ * a &drm_connector
+ *
+ * This enum is used to track the status of initializing a connector and
+ * registering it with userspace, so that DRM can prevent bogus modesets o=
n
+ * connectors that no longer exist.
+ */
+enum drm_connector_registration_state {
+	/**
+	 * @DRM_CONNECTOR_INITIALIZING: The connector has just been created,
+	 * but has yet to be exposed to userspace. There should be no
+	 * additional restrictions to how the state of this connector may be
+	 * modified.
+	 */
+	DRM_CONNECTOR_INITIALIZING =3D 0,
+
+	/**
+	 * @DRM_CONNECTOR_REGISTERED: The connector has been fully initialized
+	 * and registered with sysfs, as such it has been exposed to
+	 * userspace. There should be no additional restrictions to how the
+	 * state of this connector may be modified.
+	 */
+	DRM_CONNECTOR_REGISTERED =3D 1,
+
+	/**
+	 * @DRM_CONNECTOR_UNREGISTERED: The connector has either been exposed
+	 * to userspace and has since been unregistered and removed from
+	 * userspace, or the connector was unregistered before it had a chance
+	 * to be exposed to userspace (e.g. still in the
+	 * @DRM_CONNECTOR_INITIALIZING state). When a connector is
+	 * unregistered, there are additional restrictions to how its state
+	 * may be modified:
+	 *
+	 * - An unregistered connector may only have its DPMS changed from
+	 *   On->Off. Once DPMS is changed to Off, it may not be switched back
+	 *   to On.
+	 * - Modesets are not allowed on unregistered connectors, unless they
+	 *   would result in disabling its assigned CRTCs. This means
+	 *   disabling a CRTC on an unregistered connector is OK, but enabling
+	 *   one is not.
+	 * - Removing a CRTC from an unregistered connector is OK, but new
+	 *   CRTCs may never be assigned to an unregistered connector.
+	 */
+	DRM_CONNECTOR_UNREGISTERED =3D 2,
+};
+
 enum subpixel_order {
 	SubPixelUnknown =3D 0,
 	SubPixelHorizontalRGB,
@@ -852,10 +899,12 @@ struct drm_connector {
 	bool ycbcr_420_allowed;
=20
 	/**
-	 * @registered: Is this connector exposed (registered) with userspace?
+	 * @registration_state: Is this connector initializing, exposed
+	 * (registered) with userspace, or unregistered?
+	 *
 	 * Protected by @mutex.
 	 */
-	bool registered;
+	enum drm_connector_registration_state registration_state;
=20
 	/**
 	 * @modes:
@@ -1165,6 +1214,24 @@ static inline void drm_connector_unreference(struct =
drm_connector *connector)
 	drm_connector_put(connector);
 }
=20
+/**
+ * drm_connector_is_unregistered - has the connector been unregistered fro=
m
+ * userspace?
+ * @connector: DRM connector
+ *
+ * Checks whether or not @connector has been unregistered from userspace.
+ *
+ * Returns:
+ * True if the connector was unregistered, false if the connector is
+ * registered or has not yet been registered with userspace.
+ */
+static inline bool
+drm_connector_is_unregistered(struct drm_connector *connector)
+{
+	return READ_ONCE(connector->registration_state) =3D=3D
+		DRM_CONNECTOR_UNREGISTERED;
+}
+
 const char *drm_get_connector_status_name(enum drm_connector_status status=
);
 const char *drm_get_subpixel_order_name(enum subpixel_order order);
 const char *drm_get_dpms_name(int val);
--=20
2.11.0
