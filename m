Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015E7573D00
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 21:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiGMTLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 15:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiGMTLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 15:11:45 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67F11EEEA
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 12:11:44 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o8so7082194wms.2
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 12:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UMLD4QFGn0nGSz/zdsubDnPZvRiSIbff4bVPrsMQz3c=;
        b=BLWep+tUV3HQG82H7hg+n8XnCAocFUD8Ckl1jLQqJGLV9RR9OvOZ9a+Uchtr9siDPa
         irE/FqKWNbC42Hb8wwJqy4I9C9Wq29ksF64dpMCoNm2msXy7ur2qfPnZgRUF2RtA4FQu
         AZBbbmG5YJE/CKO+Alym+bBo9JDxtNgDZudBnhfrDlNQBP3QiNdbP22g3yZBfT126n7N
         QmNAn+Q5B+cg9JyhXPXLmuIsu84/IK3+VhMuRAUMywJZ5BrJxLxVM8qLSVgYV7W4MpFq
         8wEMxyGc+2vzM0iGMOMbmxwkAQuNTC6Wrt8AI2mDOAkUfbs46AEia3+HUYDiXUQqOACE
         Kbag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UMLD4QFGn0nGSz/zdsubDnPZvRiSIbff4bVPrsMQz3c=;
        b=fZsNnUo7rXtMxbgT9onm5pY7BW3c1XzadTHBE4x6sW+hVxjp2n6Knuk0LDhTs58Ctb
         1xtACwplfXJck1JYFfdl3k+uatHm33DJPdCnRaygNNNyjDlnlKf8kH/Q6PTgClIu6/yq
         5FgGuwFkGmBwDQ02M0nvl7mvIBIs/UWoaW5G/7QCRVg7ECgQUjr1CkjaESDlcgCLZlhy
         pYmZ5oxpBPDzzwcd4gUfAnHQrEruFAsy38PMReHqjYX8ca7353m40JgvwN8JidaisNq8
         N51zcf34IEMp+kyi17ovL0kuWREDfgIinuFd/XqFQy5kXDkaZUqJ7bWBP/Iu//2ZmPEN
         ep9w==
X-Gm-Message-State: AJIora8nC/763IcG/W+WV+PGqORWgeJdm4V3lmywGUX8hU0sRGhv/41g
        fYuekHWoBiQWXkqvU68XdA+vViiQiRE=
X-Google-Smtp-Source: AGRyM1sP3SmCNg6G6w4Rg8PXNPl5lUdGE3xVNnqRDWAA4mqIm/BsUuvwTVGc4IBSAEmlI85ZrbNUFQ==
X-Received: by 2002:a7b:cb82:0:b0:39e:f9cf:12b7 with SMTP id m2-20020a7bcb82000000b0039ef9cf12b7mr11282254wmi.135.1657739503076;
        Wed, 13 Jul 2022 12:11:43 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id b13-20020a056000054d00b0021d7d251c76sm11580808wrf.46.2022.07.13.12.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 12:11:42 -0700 (PDT)
Date:   Wed, 13 Jul 2022 20:11:40 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mathias.nyman@linux.intel.com, quic_pkondeti@quicinc.com,
        s.shtylyov@omp.ru, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] xhci: make xhci_handshake timeout for
 xhci_reset() adjustable" failed to apply to 4.14-stable tree
Message-ID: <Ys8Y7NBN9FaWUSrc@debian>
References: <164871736680140@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pDbxQ2/0ejjFEjMy"
Content-Disposition: inline
In-Reply-To: <164871736680140@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pDbxQ2/0ejjFEjMy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Thu, Mar 31, 2022 at 11:02:46AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport along with 72ae194704da ("xhci: bail out early if
driver can't accress host in resume") to make the backporting little
easier.

--
Regards
Sudip

--pDbxQ2/0ejjFEjMy
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-xhci-bail-out-early-if-driver-can-t-accress-host-in-.patch"

From e941a8647912ffb1f8239eeeb7893eb2ddccfbf4 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Thu, 12 Mar 2020 16:45:09 +0200
Subject: [PATCH 1/2] xhci: bail out early if driver can't accress host in
 resume

commit 72ae194704da212e2ec312ab182a96799d070755 upstream.

Bail out early if the xHC host needs to be reset at resume
but driver can't access xHC PCI registers.

If xhci driver already fails to reset the controller then there
is no point in attempting to free, re-initialize, re-allocate and
re-start the host. If failure to access the host is detected later,
failing the resume, xhci interrupts will be double freed
when remove is called.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200312144517.1593-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/usb/host/xhci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 9724888196e3b..6bcf1412b2072 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1111,8 +1111,10 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 
 		xhci_dbg(xhci, "Stop HCD\n");
 		xhci_halt(xhci);
-		xhci_reset(xhci);
+		retval = xhci_reset(xhci);
 		spin_unlock_irq(&xhci->lock);
+		if (retval)
+			return retval;
 		xhci_cleanup_msix(xhci);
 
 		xhci_dbg(xhci, "// Disabling event ring interrupts\n");
-- 
2.30.2


--pDbxQ2/0ejjFEjMy
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-xhci-make-xhci_handshake-timeout-for-xhci_reset-adju.patch"

From 4c176116d6a518d45e0de765b80e98332c98b6b5 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Thu, 3 Mar 2022 13:08:55 +0200
Subject: [PATCH 2/2] xhci: make xhci_handshake timeout for xhci_reset()
 adjustable

commit 14073ce951b5919da450022c050772902f24f054 upstream.

xhci_reset() timeout was increased from 250ms to 10 seconds in order to
give Renesas 720201 xHC enough time to get ready in probe.

xhci_reset() is called with interrupts disabled in other places, and
waiting for 10 seconds there is not acceptable.

Add a timeout parameter to xhci_reset(), and adjust it back to 250ms
when called from xhci_stop() or xhci_shutdown() where interrupts are
disabled, and successful reset isn't that critical.
This solves issues when deactivating host mode on platforms like SM8450.

For now don't change the timeout if xHC is reset in xhci_resume().
No issues are reported for it, and we need the reset to succeed.
Locking around that reset needs to be revisited later.

Additionally change the signed integer timeout parameter in
xhci_handshake() to a u64 to match the timeout value we pass to
readl_poll_timeout_atomic()

Fixes: 22ceac191211 ("xhci: Increase reset timeout for Renesas 720201 host.")
Cc: stable@vger.kernel.org
Reported-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reported-by: Pavan Kondeti <quic_pkondeti@quicinc.com>
Tested-by: Pavan Kondeti <quic_pkondeti@quicinc.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220303110903.1662404-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/usb/host/xhci-hub.c |  2 +-
 drivers/usb/host/xhci-mem.c |  2 +-
 drivers/usb/host/xhci.c     | 20 +++++++++-----------
 drivers/usb/host/xhci.h     |  7 +++++--
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index ad82d10d9cf5f..b2083dcf3bd2a 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -683,7 +683,7 @@ static int xhci_exit_test_mode(struct xhci_hcd *xhci)
 	}
 	pm_runtime_allow(xhci_to_hcd(xhci)->self.controller);
 	xhci->test_mode = 0;
-	return xhci_reset(xhci);
+	return xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 }
 
 void xhci_set_link_state(struct xhci_hcd *xhci, __le32 __iomem **port_array,
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 5fd1e95f5400f..e930e2777c875 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2574,7 +2574,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 
 fail:
 	xhci_halt(xhci);
-	xhci_reset(xhci);
+	xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 	xhci_mem_cleanup(xhci);
 	return -ENOMEM;
 }
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6bcf1412b2072..3da9cd3791c64 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -76,7 +76,7 @@ static bool td_on_ring(struct xhci_td *td, struct xhci_ring *ring)
  * handshake done).  There are two failure modes:  "usec" have passed (major
  * hardware flakeout), or the register reads as all-ones (hardware removed).
  */
-int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, int usec)
+int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, u64 timeout_us)
 {
 	u32	result;
 	int	ret;
@@ -84,7 +84,7 @@ int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, int usec)
 	ret = readl_poll_timeout_atomic(ptr, result,
 					(result & mask) == done ||
 					result == U32_MAX,
-					1, usec);
+					1, timeout_us);
 	if (result == U32_MAX)		/* card removed */
 		return -ENODEV;
 
@@ -173,7 +173,7 @@ int xhci_start(struct xhci_hcd *xhci)
  * Transactions will be terminated immediately, and operational registers
  * will be set to their defaults.
  */
-int xhci_reset(struct xhci_hcd *xhci)
+int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us)
 {
 	u32 command;
 	u32 state;
@@ -206,8 +206,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 	if (xhci->quirks & XHCI_INTEL_HOST)
 		udelay(1000);
 
-	ret = xhci_handshake(&xhci->op_regs->command,
-			CMD_RESET, 0, 10 * 1000 * 1000);
+	ret = xhci_handshake(&xhci->op_regs->command, CMD_RESET, 0, timeout_us);
 	if (ret)
 		return ret;
 
@@ -220,8 +219,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 	 * xHCI cannot write to any doorbells or operational registers other
 	 * than status until the "Controller Not Ready" flag is cleared.
 	 */
-	ret = xhci_handshake(&xhci->op_regs->status,
-			STS_CNR, 0, 10 * 1000 * 1000);
+	ret = xhci_handshake(&xhci->op_regs->status, STS_CNR, 0, timeout_us);
 
 	for (i = 0; i < 2; i++) {
 		xhci->bus_state[i].port_c_suspend = 0;
@@ -675,7 +673,7 @@ static void xhci_stop(struct usb_hcd *hcd)
 	xhci->xhc_state |= XHCI_STATE_HALTED;
 	xhci->cmd_ring_state = CMD_RING_STATE_STOPPED;
 	xhci_halt(xhci);
-	xhci_reset(xhci);
+	xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
@@ -739,7 +737,7 @@ void xhci_shutdown(struct usb_hcd *hcd)
 	xhci_halt(xhci);
 	/* Workaround for spurious wakeups at shutdown with HSW */
 	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
-		xhci_reset(xhci);
+		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
@@ -1111,7 +1109,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 
 		xhci_dbg(xhci, "Stop HCD\n");
 		xhci_halt(xhci);
-		retval = xhci_reset(xhci);
+		retval = xhci_reset(xhci, XHCI_RESET_LONG_USEC);
 		spin_unlock_irq(&xhci->lock);
 		if (retval)
 			return retval;
@@ -4990,7 +4988,7 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 
 	xhci_dbg(xhci, "Resetting HCD\n");
 	/* Reset the internal HC memory state and registers. */
-	retval = xhci_reset(xhci);
+	retval = xhci_reset(xhci, XHCI_RESET_LONG_USEC);
 	if (retval)
 		return retval;
 	xhci_dbg(xhci, "Reset complete\n");
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 300506de0c7a1..59167d4f98d00 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -236,6 +236,9 @@ struct xhci_op_regs {
 #define CMD_ETE		(1 << 14)
 /* bits 15:31 are reserved (and should be preserved on writes). */
 
+#define XHCI_RESET_LONG_USEC		(10 * 1000 * 1000)
+#define XHCI_RESET_SHORT_USEC		(250 * 1000)
+
 /* IMAN - Interrupt Management Register */
 #define IMAN_IE		(1 << 1)
 #define IMAN_IP		(1 << 0)
@@ -2016,11 +2019,11 @@ void xhci_free_command(struct xhci_hcd *xhci,
 
 /* xHCI host controller glue */
 typedef void (*xhci_get_quirks_t)(struct device *, struct xhci_hcd *);
-int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, int usec);
+int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, u64 timeout_us);
 void xhci_quiesce(struct xhci_hcd *xhci);
 int xhci_halt(struct xhci_hcd *xhci);
 int xhci_start(struct xhci_hcd *xhci);
-int xhci_reset(struct xhci_hcd *xhci);
+int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us);
 int xhci_run(struct usb_hcd *hcd);
 int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
 void xhci_shutdown(struct usb_hcd *hcd);
-- 
2.30.2


--pDbxQ2/0ejjFEjMy--
