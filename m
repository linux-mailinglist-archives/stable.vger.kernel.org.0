Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B0A16F9FA
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 09:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgBZIvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 03:51:01 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46705 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726082AbgBZIvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 03:51:00 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 592E621E56;
        Wed, 26 Feb 2020 03:50:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 26 Feb 2020 03:50:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6x+AUJ
        C3SUnIydYQbcuJgCYJ3RVRSKd6z4i/l4RqJfc=; b=dh2h1wua0C3tJNrFoG5+hL
        eRTBNmDp9g7Q9GDyKNvMtZZb310i+EYSWCptEaie4weHpIJj9gFC7DkqEIdEuViJ
        kuPqi0JOYOgfP6WNeBV6dkJHa+xgR5aJD1Zw8hsUvKRm5Pc9EiSWjUNia5KpiUXY
        C+Ng3x4KIkDaX3DkxLiAh6vmdMSWvDJsOKztJLWoFqkkoOYIB/SSY1SCCvLljM+R
        7xxxMC0wdoKKsnV+QK1/FHsu8pCirMowkFPzQTSSpg9Zg4pMsfK2+6snB2S+svDm
        iMezgmJSO55PQQTdOudrvL13fDWwqg1XejxrPL0wMhfHEW6tB4MvygWkAlrKb2aQ
        ==
X-ME-Sender: <xms:cjFWXnpTeR1UYZPUcP1V2VZD2aWh1axJ8uwQEpjhi9ktR1feF68e-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:cjFWXiT1lW1Izd7mX_CcMsJYQE7o1rzE2NxN1EgY4PfocTyczmnMgg>
    <xmx:cjFWXoensvnrCCZrQLTUORau-bcPpp1aA4zxaTnDN8AhRoiqBpnTTg>
    <xmx:cjFWXoT5n_34nIYxT1LmEg0439hXxnEvt23pa02UKfwh9u-lViLxwA>
    <xmx:czFWXjFK5zx6IGS5Mo2dWpKoTBeu1E5MsTU3_kubUxS0ttI3eECoNg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D0D4C3060F09;
        Wed, 26 Feb 2020 03:50:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] xhci: Fix memory leak when caching protocol extended" failed to apply to 4.14-stable tree
To:     mathias.nyman@linux.intel.com, VenkateswaraRao.Sajja@amd.com,
        gregkh@linuxfoundation.org, m.szyprowski@samsung.com,
        pmenzel@molgen.mpg.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Feb 2020 09:50:55 +0100
Message-ID: <15827070558936@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cf0ee7c60c89641f6e4d1d3c7867fe32b9e30300 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Tue, 11 Feb 2020 17:01:58 +0200
Subject: [PATCH] xhci: Fix memory leak when caching protocol extended
 capability PSI tables - take 2

xhci driver assumed that xHC controllers have at most one custom
supported speed table (PSI) for all usb 3.x ports.
Memory was allocated for one PSI table under the xhci hub structure.

Turns out this is not the case, some controllers have a separate
"supported protocol capability" entry with a PSI table for each port.
This means each usb3 roothub port can in theory support different custom
speeds.

To solve this, cache all supported protocol capabilities with their PSI
tables in an array, and add pointers to the xhci port structure so that
every port points to its capability entry in the array.

When creating the SuperSpeedPlus USB Device Capability BOS descriptor
for the xhci USB 3.1 roothub we for now will use only data from the
first USB 3.1 capable protocol capability entry in the array.
This could be improved later, this patch focuses resolving
the memory leak.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reported-by: Sajja Venkateswara Rao <VenkateswaraRao.Sajja@amd.com>
Fixes: 47189098f8be ("xhci: parse xhci protocol speed ID list for usb 3.1 usage")
Cc: stable <stable@vger.kernel.org> # v4.4+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20200211150158.14475-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 7a3a29e5e9d2..af92b2576fe9 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -55,6 +55,7 @@ static u8 usb_bos_descriptor [] = {
 static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
 				     u16 wLength)
 {
+	struct xhci_port_cap *port_cap = NULL;
 	int i, ssa_count;
 	u32 temp;
 	u16 desc_size, ssp_cap_size, ssa_size = 0;
@@ -64,16 +65,24 @@ static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
 	ssp_cap_size = sizeof(usb_bos_descriptor) - desc_size;
 
 	/* does xhci support USB 3.1 Enhanced SuperSpeed */
-	if (xhci->usb3_rhub.min_rev >= 0x01) {
+	for (i = 0; i < xhci->num_port_caps; i++) {
+		if (xhci->port_caps[i].maj_rev == 0x03 &&
+		    xhci->port_caps[i].min_rev >= 0x01) {
+			usb3_1 = true;
+			port_cap = &xhci->port_caps[i];
+			break;
+		}
+	}
+
+	if (usb3_1) {
 		/* does xhci provide a PSI table for SSA speed attributes? */
-		if (xhci->usb3_rhub.psi_count) {
+		if (port_cap->psi_count) {
 			/* two SSA entries for each unique PSI ID, RX and TX */
-			ssa_count = xhci->usb3_rhub.psi_uid_count * 2;
+			ssa_count = port_cap->psi_uid_count * 2;
 			ssa_size = ssa_count * sizeof(u32);
 			ssp_cap_size -= 16; /* skip copying the default SSA */
 		}
 		desc_size += ssp_cap_size;
-		usb3_1 = true;
 	}
 	memcpy(buf, &usb_bos_descriptor, min(desc_size, wLength));
 
@@ -99,7 +108,7 @@ static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
 	}
 
 	/* If PSI table exists, add the custom speed attributes from it */
-	if (usb3_1 && xhci->usb3_rhub.psi_count) {
+	if (usb3_1 && port_cap->psi_count) {
 		u32 ssp_cap_base, bm_attrib, psi, psi_mant, psi_exp;
 		int offset;
 
@@ -111,7 +120,7 @@ static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
 
 		/* attribute count SSAC bits 4:0 and ID count SSIC bits 8:5 */
 		bm_attrib = (ssa_count - 1) & 0x1f;
-		bm_attrib |= (xhci->usb3_rhub.psi_uid_count - 1) << 5;
+		bm_attrib |= (port_cap->psi_uid_count - 1) << 5;
 		put_unaligned_le32(bm_attrib, &buf[ssp_cap_base + 4]);
 
 		if (wLength < desc_size + ssa_size)
@@ -124,8 +133,8 @@ static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
 		 * USB 3.1 requires two SSA entries (RX and TX) for every link
 		 */
 		offset = desc_size;
-		for (i = 0; i < xhci->usb3_rhub.psi_count; i++) {
-			psi = xhci->usb3_rhub.psi[i];
+		for (i = 0; i < port_cap->psi_count; i++) {
+			psi = port_cap->psi[i];
 			psi &= ~USB_SSP_SUBLINK_SPEED_RSVD;
 			psi_exp = XHCI_EXT_PORT_PSIE(psi);
 			psi_mant = XHCI_EXT_PORT_PSIM(psi);
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 0e2701649369..884c601bfa15 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1915,17 +1915,17 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci->usb3_rhub.num_ports = 0;
 	xhci->num_active_eps = 0;
 	kfree(xhci->usb2_rhub.ports);
-	kfree(xhci->usb2_rhub.psi);
 	kfree(xhci->usb3_rhub.ports);
-	kfree(xhci->usb3_rhub.psi);
 	kfree(xhci->hw_ports);
 	kfree(xhci->rh_bw);
 	kfree(xhci->ext_caps);
+	for (i = 0; i < xhci->num_port_caps; i++)
+		kfree(xhci->port_caps[i].psi);
+	kfree(xhci->port_caps);
+	xhci->num_port_caps = 0;
 
 	xhci->usb2_rhub.ports = NULL;
-	xhci->usb2_rhub.psi = NULL;
 	xhci->usb3_rhub.ports = NULL;
-	xhci->usb3_rhub.psi = NULL;
 	xhci->hw_ports = NULL;
 	xhci->rh_bw = NULL;
 	xhci->ext_caps = NULL;
@@ -2126,6 +2126,7 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
 	u8 major_revision, minor_revision;
 	struct xhci_hub *rhub;
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
+	struct xhci_port_cap *port_cap;
 
 	temp = readl(addr);
 	major_revision = XHCI_EXT_PORT_MAJOR(temp);
@@ -2160,31 +2161,39 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
 		/* WTF? "Valid values are ‘1’ to MaxPorts" */
 		return;
 
-	rhub->psi_count = XHCI_EXT_PORT_PSIC(temp);
-	if (rhub->psi_count) {
-		rhub->psi = kcalloc_node(rhub->psi_count, sizeof(*rhub->psi),
-				    GFP_KERNEL, dev_to_node(dev));
-		if (!rhub->psi)
-			rhub->psi_count = 0;
+	port_cap = &xhci->port_caps[xhci->num_port_caps++];
+	if (xhci->num_port_caps > max_caps)
+		return;
+
+	port_cap->maj_rev = major_revision;
+	port_cap->min_rev = minor_revision;
+	port_cap->psi_count = XHCI_EXT_PORT_PSIC(temp);
+
+	if (port_cap->psi_count) {
+		port_cap->psi = kcalloc_node(port_cap->psi_count,
+					     sizeof(*port_cap->psi),
+					     GFP_KERNEL, dev_to_node(dev));
+		if (!port_cap->psi)
+			port_cap->psi_count = 0;
 
-		rhub->psi_uid_count++;
-		for (i = 0; i < rhub->psi_count; i++) {
-			rhub->psi[i] = readl(addr + 4 + i);
+		port_cap->psi_uid_count++;
+		for (i = 0; i < port_cap->psi_count; i++) {
+			port_cap->psi[i] = readl(addr + 4 + i);
 
 			/* count unique ID values, two consecutive entries can
 			 * have the same ID if link is assymetric
 			 */
-			if (i && (XHCI_EXT_PORT_PSIV(rhub->psi[i]) !=
-				  XHCI_EXT_PORT_PSIV(rhub->psi[i - 1])))
-				rhub->psi_uid_count++;
+			if (i && (XHCI_EXT_PORT_PSIV(port_cap->psi[i]) !=
+				  XHCI_EXT_PORT_PSIV(port_cap->psi[i - 1])))
+				port_cap->psi_uid_count++;
 
 			xhci_dbg(xhci, "PSIV:%d PSIE:%d PLT:%d PFD:%d LP:%d PSIM:%d\n",
-				  XHCI_EXT_PORT_PSIV(rhub->psi[i]),
-				  XHCI_EXT_PORT_PSIE(rhub->psi[i]),
-				  XHCI_EXT_PORT_PLT(rhub->psi[i]),
-				  XHCI_EXT_PORT_PFD(rhub->psi[i]),
-				  XHCI_EXT_PORT_LP(rhub->psi[i]),
-				  XHCI_EXT_PORT_PSIM(rhub->psi[i]));
+				  XHCI_EXT_PORT_PSIV(port_cap->psi[i]),
+				  XHCI_EXT_PORT_PSIE(port_cap->psi[i]),
+				  XHCI_EXT_PORT_PLT(port_cap->psi[i]),
+				  XHCI_EXT_PORT_PFD(port_cap->psi[i]),
+				  XHCI_EXT_PORT_LP(port_cap->psi[i]),
+				  XHCI_EXT_PORT_PSIM(port_cap->psi[i]));
 		}
 	}
 	/* cache usb2 port capabilities */
@@ -2219,6 +2228,7 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
 			continue;
 		}
 		hw_port->rhub = rhub;
+		hw_port->port_cap = port_cap;
 		rhub->num_ports++;
 	}
 	/* FIXME: Should we disable ports not in the Extended Capabilities? */
@@ -2309,6 +2319,11 @@ static int xhci_setup_port_arrays(struct xhci_hcd *xhci, gfp_t flags)
 	if (!xhci->ext_caps)
 		return -ENOMEM;
 
+	xhci->port_caps = kcalloc_node(cap_count, sizeof(*xhci->port_caps),
+				flags, dev_to_node(dev));
+	if (!xhci->port_caps)
+		return -ENOMEM;
+
 	offset = cap_start;
 
 	while (offset) {
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 13d8838cd552..3ecee10fdcdc 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1702,12 +1702,20 @@ struct xhci_bus_state {
  * Intel Lynx Point LP xHCI host.
  */
 #define	XHCI_MAX_REXIT_TIMEOUT_MS	20
+struct xhci_port_cap {
+	u32			*psi;	/* array of protocol speed ID entries */
+	u8			psi_count;
+	u8			psi_uid_count;
+	u8			maj_rev;
+	u8			min_rev;
+};
 
 struct xhci_port {
 	__le32 __iomem		*addr;
 	int			hw_portnum;
 	int			hcd_portnum;
 	struct xhci_hub		*rhub;
+	struct xhci_port_cap	*port_cap;
 };
 
 struct xhci_hub {
@@ -1719,9 +1727,6 @@ struct xhci_hub {
 	/* supported prococol extended capabiliy values */
 	u8			maj_rev;
 	u8			min_rev;
-	u32			*psi;	/* array of protocol speed ID entries */
-	u8			psi_count;
-	u8			psi_uid_count;
 };
 
 /* There is one xhci_hcd structure per controller */
@@ -1880,6 +1885,9 @@ struct xhci_hcd {
 	/* cached usb2 extened protocol capabilites */
 	u32                     *ext_caps;
 	unsigned int            num_ext_caps;
+	/* cached extended protocol port capabilities */
+	struct xhci_port_cap	*port_caps;
+	unsigned int		num_port_caps;
 	/* Compliance Mode Recovery Data */
 	struct timer_list	comp_mode_recovery_timer;
 	u32			port_status_u0;

