Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC73FAA821
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732835AbfIEQSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:18:02 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40821 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732776AbfIEQSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:18:01 -0400
Received: by mail-pl1-f193.google.com with SMTP id y10so1520479pll.7
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 09:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=mukYH+OPB5B2Q8cIXti1kEopT3yxftlik4aW1yItWl0=;
        b=Kl4bnPESFCY769er88olLvIMydPIt7MSvRLFnbrMUBFJe2XGXC8oNJ+eB44CxUq8Z8
         icVfI4Z7Zv2fzyYYpmgSfOeLpo80hrioId35SGiSFn9P8y2EAYTnu2zhJFWW2+ZCCuVB
         Acsg/wxujlaWpromsOPO/XEkL8skQ8K6nxVzl/UgdDGnWguc6yvHxK/Wv797MeTMZZKg
         uTS6IS/ihZs3WKvkhpct4BSG3iQljiRqCPgkcGGvlkMO9io8/jgOGOyYiaq1v5JzqePy
         StJEuicwLxbARj/KoZGqt30jsFFl3ji38xfmmhdmOvICWnSF2ih5SFi0lKIRKtupViAc
         aAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mukYH+OPB5B2Q8cIXti1kEopT3yxftlik4aW1yItWl0=;
        b=QkIFB/hgRK3oDHOBLa5FYjCITYYEYORyFEUocrXc5IGJitV6bwdvIcUNLD5y1SsG4e
         G1QTZ4KbNu4tyVOw1j29fpsKpILM9yjxNdTQjKPQBddCWsiEZoIKX08XhpgYSwRdJKhn
         fJ/R65VOxTDr9uJPmH5maxdtrC48QLi+l0XvqaovB7R3UlYKyYxAM9HNWyxvJ7Ymri5e
         WqKctYGI3j9wNE1FwojgMIC8saz/c4OVNdNK2kG4Rj7pI9PmKiXYe3qTtSYSpuNQ+iO8
         8Zi+Zwbh5TSd79IFZNS3p6rEB3Suf/eqIfvJ2Z97mu0CtR8IZKC31Hlqc4MLOTpKmewp
         CjCw==
X-Gm-Message-State: APjAAAWMqowKuqTKu5nExFXen7IAuYvXjS43OhQ3vThSiZybZ02tFeA6
        OM82wxGIWsq4LQUlnFQnypKtEWh/v9c=
X-Google-Smtp-Source: APXvYqzStzXxTWL+1VFEsqINN1zYVOMyUuv7eD3n8K9EXYt6eOChXB640bT4MB9P7QjeXftsWyVKSw==
X-Received: by 2002:a17:902:b583:: with SMTP id a3mr4258322pls.52.1567700281066;
        Thu, 05 Sep 2019 09:18:01 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m129sm6324005pga.39.2019.09.05.09.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 09:18:00 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [BACKPORT 4.14.y 00/18] Backport candidate from TI 4.14 product kernel 
Date:   Thu,  5 Sep 2019 10:17:41 -0600
Message-Id: <20190905161759.28036-1-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These patches are backport candidates picked out of TI's 4.14.y tree [1],
with most of them already found in the 4.19.y stable tree.

The set apply and compiles cleanly on 4.14.141.

Thanks,
Mathieu


[1]. http://git.ti.com/gitweb/?p=ti-linux-kernel/ti-linux-kernel.git;a=shortlog;h=refs/heads/ti-linux-4.14.y

Andrew F. Davis (1):
  ASoC: tlv320aic31xx: Handle inverted BCLK in non-DSP modes

Arvind Yadav (1):
  ASoC: davinci-mcasp: Handle return value of devm_kasprintf

Christophe Jaillet (1):
  ASoC: davinci-mcasp: Fix an error handling path in
    'davinci_mcasp_probe()'

Claudio Foellmi (1):
  i2c: omap: Trigger bus recovery in lockup case

Dan Carpenter (1):
  misc: pci_endpoint_test: Prevent some integer overflows

Gustavo A. R. Silva (1):
  ASoC: tlv320dac31xx: mark expected switch fall-through

Keerthy (2):
  mfd: palmas: Assign the right powerhold mask for tps65917
  PCI: dra7xx: Add shutdown handler to cleanly turn off clocks

Kishon Vijay Abraham I (1):
  misc: pci_endpoint_test: Fix BUG_ON error during pci_disable_msi()

Niklas Cassel (1):
  PCI: designware-ep: Fix find_first_zero_bit() usage

Roger Quadros (1):
  usb: dwc3: Allow disabling of metastability workaround

Roman Yeryomin (1):
  mtd: spi-nor: enable 4B opcodes for mx66l51235l

Sudeep Holla (1):
  mailbox: reset txdone_method TXDONE_BY_POLL if client knows_txdone

Takashi Iwai (1):
  ASoC: davinci: Kill BUG_ON() usage

Tony Lindgren (1):
  drm/omap: panel-dsi-cm: fix driver

Vignesh R (2):
  PCI: dra7xx: Fix legacy INTD IRQ handling
  mtd: spi-nor: cadence-quadspi: add a delay in write sequence

Zumeng Chen (1):
  cpufreq: ti-cpufreq: add missing of_node_put()

 .../devicetree/bindings/usb/dwc3.txt          |  2 +
 drivers/cpufreq/ti-cpufreq.c                  |  1 +
 .../gpu/drm/omapdrm/displays/panel-dsi-cm.c   | 56 +++++++++++++++++--
 drivers/i2c/busses/i2c-omap.c                 | 25 ++++++++-
 drivers/mailbox/mailbox.c                     |  4 +-
 drivers/mailbox/pcc.c                         |  4 +-
 drivers/mfd/palmas.c                          | 10 +++-
 drivers/misc/pci_endpoint_test.c              | 17 ++++++
 drivers/mtd/spi-nor/cadence-quadspi.c         | 27 ++++++++-
 drivers/mtd/spi-nor/spi-nor.c                 |  2 +-
 drivers/pci/dwc/pci-dra7xx.c                  | 20 ++++++-
 drivers/pci/dwc/pcie-designware-ep.c          | 34 ++++++++---
 drivers/pci/dwc/pcie-designware.h             |  8 ++-
 drivers/usb/dwc3/core.c                       |  3 +
 drivers/usb/dwc3/core.h                       |  3 +
 drivers/usb/dwc3/gadget.c                     |  6 +-
 include/linux/mfd/palmas.h                    |  3 +
 sound/soc/codecs/tlv320aic31xx.c              | 30 ++++++----
 sound/soc/davinci/davinci-mcasp.c             | 21 ++++++-
 19 files changed, 235 insertions(+), 41 deletions(-)

-- 
2.17.1

