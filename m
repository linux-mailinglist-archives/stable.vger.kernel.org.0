Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853A443887F
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhJXLRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231151AbhJXLRm (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:17:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43D5D60FE8;
        Sun, 24 Oct 2021 11:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635074121;
        bh=m7vFkEYE0JEs5YL7MWoUDIOujKHdxfUiy1aHCUFfrOg=;
        h=Subject:To:From:Date:From;
        b=Lm7o6rw8ZrSVZgzZ1yxEEAxGl5XH97KCdkeRrbSniQKb+BuHjINijOecj79VEeBIJ
         XRr2CslGajzR2WbUon870CzbHOlc/XQyaGaYB4g5Q8wAB3zZ/z4oJCGmXbNoSPYIif
         UGNPlQjLJsC2pTJGDjIwVFXexVWDhpiGZi4qxgw0=
Subject: patch "Documentation:devicetree:bindings:iio:dac: Fix val" added to char-misc-next
To:     mihail.chindris@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, ardeleanalex@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:15:05 +0200
Message-ID: <1635074105784@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Documentation:devicetree:bindings:iio:dac: Fix val

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 8fc4f038fa832ec3543907fdcbe1334e1b0a8950 Mon Sep 17 00:00:00 2001
From: Mihail Chindris <mihail.chindris@analog.com>
Date: Thu, 7 Oct 2021 08:00:36 +0000
Subject: Documentation:devicetree:bindings:iio:dac: Fix val

A correct value for output-range-microvolts is -5 to 5 Volts
not -5 to 5 milivolts

Fixes: e904cc899293f ("dt-bindings: iio: dac: AD5766 yaml documentation")
Signed-off-by: Mihail Chindris <mihail.chindris@analog.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Link: https://lore.kernel.org/r/20211007080035.2531-6-mihail.chindris@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 Documentation/devicetree/bindings/iio/dac/adi,ad5766.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/iio/dac/adi,ad5766.yaml b/Documentation/devicetree/bindings/iio/dac/adi,ad5766.yaml
index d5c54813ce87..a8f7720d1e3e 100644
--- a/Documentation/devicetree/bindings/iio/dac/adi,ad5766.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/adi,ad5766.yaml
@@ -54,7 +54,7 @@ examples:
 
           ad5766@0 {
               compatible = "adi,ad5766";
-              output-range-microvolts = <(-5000) 5000>;
+              output-range-microvolts = <(-5000000) 5000000>;
               reg = <0>;
               spi-cpol;
               spi-max-frequency = <1000000>;
-- 
2.33.1


