Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DF62114CF
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 23:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgGAVNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 17:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgGAVNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 17:13:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E782C08C5DB
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 14:13:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e192so27370009ybf.17
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 14:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1693jLPCRTZKv04e3tT1L2R/SD/azULEZvoSLa7Hf7o=;
        b=X4N13e+9sePnsNX3KaC3ifEpq8r8prYY7zHclzCR5upKpuH+zMAIp0a3v81FRPNLSQ
         G/oEf3GoGKzfnImMohbfzdfak484FP/LerO7QfZnV6oiJy5RkPeJ4JGyaWW4d/KoT+og
         xaCTxxyLWdrK4Iy5oj1E4JZQLNCwWwFK+QmJ/rHwp8YgFpakYgrdyJcDKvQ7Hhutimdk
         veAa42QeTkaDOUzn9UlIWlC4KV+uT51zeVpLjn2F2l8a/oToAXzSKFN4laYPXVsvB7KO
         IWeEQJElTFTPPbn1R8LGZw8Vc3cSYrMYEomRY+SMbjXzjp+LawK0qruJeF/TCA8JmuqR
         92mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1693jLPCRTZKv04e3tT1L2R/SD/azULEZvoSLa7Hf7o=;
        b=mmwN3oixwrL/OUygo3zUbwFdWmT6NFSZwlsYQJ6DqXeMbYKOSrV0KurD0uVMHrINht
         sPjU5qTyqMCfLdgQzttC5amhhcnUyCrm5517KnprHY20q79Pco2XvPP6IB1qd+7DPTIi
         15EmwPKRElMxZaCWuiNbQ22qeQCyw7wJZvhWt/uJdNub3/7S+24h7fCHB1kcJd3YCtiD
         gdehLSl94ZjJRImz2IKbNNtZGddwrfs0rv7KcG8SXl3HDFf7t8fq8Aoyn+5huIOl88D/
         KDGIo5IC3rbPY1ZqTUtNZXBmgb+J5y+Oh+h7/6imVG5VsjVjY9cWh/31p6Il7/Zbdkiz
         BDyg==
X-Gm-Message-State: AOAM531ZFwwv6fKMQL4vpNHCmOVcAGYjhwHndiRKmS6bnuvvwquS+/mJ
        4CaYueyk5LHllmt+4vLf+t7HRZV9v4zFVNuQOD0f
X-Google-Smtp-Source: ABdhPJz8wsHLEwNJYlVtw6qZZkh7AGzr6LYq5q8mwTBXuA/WiMwNXf+RKMjvBio06uTM33Rt9QsVW8X11w5NfovFi+WJ
X-Received: by 2002:a25:c7d3:: with SMTP id w202mr29331301ybe.84.1593638022312;
 Wed, 01 Jul 2020 14:13:42 -0700 (PDT)
Date:   Wed,  1 Jul 2020 14:13:36 -0700
Message-Id: <20200701211337.3027448-1-danielwinkler@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH v2 0/1] Revert "serial: 8250: Fix max baud limit in generic
 8250 port"
From:   Daniel Winkler <danielwinkler@google.com>
To:     linux-serial@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Cc:     BlueZ <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        stable@vger.kernel.org, abhishekpandit@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        Aaron Sierra <asierra@xes-inc.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, Lukas Wunner <lukas@wunner.de>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This change regresses the QCA6174A-3 bluetooth chip, preventing
firmware from being properly loaded. Without this change, the
chip works as intended.

The device is the Kukui Chromebook using the Mediatek chipset
and the 8250_mtk uart. Initial controller baudrate is 115200
and operating speed is 3000000. Our entire suite of bluetooth
tests now fail on this platform due to an apparent failure to
sync its firmware on initialization.

The driver is in the cros tree at drivers/bluetooth/hci_qca.c
and uses the serdev interface. Specifically, this is the
QCA_ROME chipset.


Daniel Winkler (1):
  Revert "serial: 8250: Fix max baud limit in generic 8250 port"

 drivers/tty/serial/8250/8250_port.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

-- 
2.27.0.212.ge8ba1cc988-goog

