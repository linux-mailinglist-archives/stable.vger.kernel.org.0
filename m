Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28A62CFADB
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 10:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgLEJeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 04:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbgLEJdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Dec 2020 04:33:24 -0500
X-Greylist: delayed 402 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 05 Dec 2020 01:08:33 PST
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C9BC0613D1
        for <stable@vger.kernel.org>; Sat,  5 Dec 2020 01:08:33 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id BBDC0100BA619;
        Sat,  5 Dec 2020 10:00:25 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 6E779814A; Sat,  5 Dec 2020 10:00:27 +0100 (CET)
Date:   Sat, 5 Dec 2020 10:00:27 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, kdasu.kdev@gmail.com,
        Stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] spi: bcm-qspi: Fix use-after-free on
 unbind" failed to apply to 5.4-stable tree
Message-ID: <20201205090027.GA29065@wunner.de>
References: <160612300715987@kroah.com>
 <20201124134123.ie5jvzygygayajo5@debian>
 <X71Lv314xaqrtn9B@kroah.com>
 <CADVatmMFEYRSKcq4mkZqs0feVPSWX9miG49ffbCR0utLtFSgfA@mail.gmail.com>
 <CADVatmNVjKBAZPh2voCHaFdAaU3pz2fs0sdL58eLSD4d-W8LQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <CADVatmNVjKBAZPh2voCHaFdAaU3pz2fs0sdL58eLSD4d-W8LQg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 24, 2020 at 07:28:44PM +0000, Sudip Mukherjee wrote:
> On Tue, Nov 24, 2020 at 6:53 PM Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> > On Tue, Nov 24, 2020 at 6:06 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > On Tue, Nov 24, 2020 at 01:41:23PM +0000, Sudip Mukherjee wrote:
> > > > On Mon, Nov 23, 2020 at 10:16:47AM +0100, gregkh@linuxfoundation.org wrote:
> > > > > The patch below does not apply to the 5.4-stable tree.
> > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > tree, then please email the backport, including the original git commit
> > > > > id to <stable@vger.kernel.org>.
> > > >
> > > > Here is the backport for all the stable tree from v4.9.y to v5.4.y.
> >
> > I was modifying one of my script which pulls in the stablerc and
> > stable-queue and I have completely messed up today  :(
> > Please drop this from v4.14.y. It will fail to build there. I had been
> > working on the version for v4.14.y and v4.9.y, but I will keep it
> > aside for today.
> > Really sorry for the confusion.
> 
> v4.19.y also. :(
> I have rechecked and only v5.4.y is ok.

Sudip's patch for 4.19 is actually correct, but it depends on commit
5e844cc37a5c ("spi: Introduce device-managed SPI controller allocation").
If that commit is cherry-picked to 4.19 (applies cleanly), Sudip's patch
compiles without errors.

I'm attaching Sudip's patch for re-application, barring any objections
against applying 5e844cc37a5c to older stable kernels.

I had tried to make the patch dependency explicit by including the following
tag in the commit message:

Cc: <stable@vger.kernel.org> # v4.9+: 123456789abc: spi: Introduce device-managed SPI controller allocation

I didn't know the SHA-1 hash the commit would get, so I used 123456789abc
as a placeholder.  (Both 5e844cc37a5c and the $subject patch were part of
the same series.)  Sorry for the confusion.

Thanks,

Lukas

--uAKRQypu60I7Lcqm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-spi-bcm-qspi-Fix-use-after-free-on-unbind.patch"

From 230cfe3365d13ae6144c7fd0321a9f10fa9fc7f4 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Wed, 11 Nov 2020 20:07:40 +0100
Subject: [PATCH] spi: bcm-qspi: Fix use-after-free on unbind

commit 63c5395bb7a9777a33f0e7b5906f2c0170a23692 upstream

bcm_qspi_remove() calls spi_unregister_master() even though
bcm_qspi_probe() calls devm_spi_register_master().  The spi_master is
therefore unregistered and freed twice on unbind.

Moreover, since commit 0392727c261b ("spi: bcm-qspi: Handle clock probe
deferral"), bcm_qspi_probe() leaks the spi_master allocation if the call
to devm_clk_get_optional() fails.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound and also
avoids the spi_master leak on probe.

While at it, fix an ordering issue in bcm_qspi_remove() wherein
spi_unregister_master() is called after uninitializing the hardware,
disabling the clock and freeing an IRQ data structure.  The correct
order is to call spi_unregister_master() *before* those teardown steps
because bus accesses may still be ongoing until that function returns.

Fixes: fa236a7ef240 ("spi: bcm-qspi: Add Broadcom MSPI driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.9+: 123456789abc: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.9+
Cc: Kamal Dasu <kdasu.kdev@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/5e31a9a59fd1c0d0b795b2fe219f25e5ee855f9d.1605121038.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/spi/spi-bcm-qspi.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index d0afe0b1599f..8a4be34bccfd 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1213,7 +1213,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	if (!of_match_node(bcm_qspi_of_match, dev->of_node))
 		return -ENODEV;
 
-	master = spi_alloc_master(dev, sizeof(struct bcm_qspi));
+	master = devm_spi_alloc_master(dev, sizeof(struct bcm_qspi));
 	if (!master) {
 		dev_err(dev, "error allocating spi_master\n");
 		return -ENOMEM;
@@ -1252,21 +1252,17 @@ int bcm_qspi_probe(struct platform_device *pdev,
 
 	if (res) {
 		qspi->base[MSPI]  = devm_ioremap_resource(dev, res);
-		if (IS_ERR(qspi->base[MSPI])) {
-			ret = PTR_ERR(qspi->base[MSPI]);
-			goto qspi_resource_err;
-		}
+		if (IS_ERR(qspi->base[MSPI]))
+			return PTR_ERR(qspi->base[MSPI]);
 	} else {
-		goto qspi_resource_err;
+		return 0;
 	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "bspi");
 	if (res) {
 		qspi->base[BSPI]  = devm_ioremap_resource(dev, res);
-		if (IS_ERR(qspi->base[BSPI])) {
-			ret = PTR_ERR(qspi->base[BSPI]);
-			goto qspi_resource_err;
-		}
+		if (IS_ERR(qspi->base[BSPI]))
+			return PTR_ERR(qspi->base[BSPI]);
 		qspi->bspi_mode = true;
 	} else {
 		qspi->bspi_mode = false;
@@ -1277,18 +1273,14 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cs_reg");
 	if (res) {
 		qspi->base[CHIP_SELECT]  = devm_ioremap_resource(dev, res);
-		if (IS_ERR(qspi->base[CHIP_SELECT])) {
-			ret = PTR_ERR(qspi->base[CHIP_SELECT]);
-			goto qspi_resource_err;
-		}
+		if (IS_ERR(qspi->base[CHIP_SELECT]))
+			return PTR_ERR(qspi->base[CHIP_SELECT]);
 	}
 
 	qspi->dev_ids = kcalloc(num_irqs, sizeof(struct bcm_qspi_dev_id),
 				GFP_KERNEL);
-	if (!qspi->dev_ids) {
-		ret = -ENOMEM;
-		goto qspi_resource_err;
-	}
+	if (!qspi->dev_ids)
+		return -ENOMEM;
 
 	for (val = 0; val < num_irqs; val++) {
 		irq = -1;
@@ -1357,7 +1349,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	qspi->xfer_mode.addrlen = -1;
 	qspi->xfer_mode.hp = -1;
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret < 0) {
 		dev_err(dev, "can't register master\n");
 		goto qspi_reg_err;
@@ -1370,8 +1362,6 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	clk_disable_unprepare(qspi->clk);
 qspi_probe_err:
 	kfree(qspi->dev_ids);
-qspi_resource_err:
-	spi_master_put(master);
 	return ret;
 }
 /* probe function to be called by SoC specific platform driver probe */
@@ -1381,10 +1371,10 @@ int bcm_qspi_remove(struct platform_device *pdev)
 {
 	struct bcm_qspi *qspi = platform_get_drvdata(pdev);
 
+	spi_unregister_master(qspi->master);
 	bcm_qspi_hw_uninit(qspi);
 	clk_disable_unprepare(qspi->clk);
 	kfree(qspi->dev_ids);
-	spi_unregister_master(qspi->master);
 
 	return 0;
 }
-- 
2.11.0


--uAKRQypu60I7Lcqm--
