Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419803E3DF7
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 04:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhHICgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 22:36:14 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:33308
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232718AbhHICgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 22:36:14 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 435853F230
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 02:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628476547;
        bh=lbp24WZDvZ8wou3EVuVNRz6r480AfYW9RAU7qE28NkY=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=pMdvmsitCqIK71scf2z6BSDdfcafF1kffHRHGz9pGj+Dm/zdtN0US/lJC2nTswPPX
         UgTSfZ5MJZQFZFnE1C5IlUwzip2/AYh0fD+D/Bt/ELVgucNj87Ct3M079F5xYtwN1J
         KVRDwB64KdcNgdjky9wE8x3l3VN4Rvjs9b/n/pHV1uj5p5hyDaGPtu00OviJyaP8Dq
         Tf21FZgj9NIExrHL1HkFqXS0H+gjEnQywwj4DXhDUAcM4hMwZ/LHFL2lgXgR2Ykewa
         rqDA07kwW0kZrOAxJzB5VEF9ZN0aWCaYQmvjfkHobHYmI5jk3NOUgbvi1N6PvtSXrn
         TGu5Sr6qCVGMQ==
Received: by mail-ed1-f69.google.com with SMTP id d6-20020a50f6860000b02903bc068b7717so8176545edn.11
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 19:35:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lbp24WZDvZ8wou3EVuVNRz6r480AfYW9RAU7qE28NkY=;
        b=CoQmC8xoj12w9/vlDLKlvS2cNrrtcQw1NGWx3hpP6hX0DAeNzqQ5F2jon/18iE41g4
         r3L+SsW1GrtGO48qaQeARlMIPlWe8o3Yy5ANWlQMrzDAIbcs56z8j0dGVS/yjRAHua+D
         iMW69KLryZU/wHKmeWw2xitGq7qKdzX+G+wytS8eNmS+nSbOlHvnrMvk42SzVimvaZlp
         YTsHSKzho/cjdcMdp8Uf2bcTeHHUiyFcUiTzLGFPDe75/cwW92s8LHSOp3TQi17hovHD
         Lprcg87BILkNmpzJ7cjcAjl+nWSUtMfqrlrU0D3G7VZIgn3AoTg0NBIE6RutdT3kCLCA
         3a7g==
X-Gm-Message-State: AOAM530+dw9g3SO+931kt8Kw/jX9FQKYalMKTc6KuEnzxGSLA+FAWTZb
        x8Wy9NnTj5OKt+dTXNEfTDHhzJBzEa2EytgXjAHrSsjp7PKWEkfGoT7y5im/aF9GCCb+41ZBa6m
        p28InBFk/FdwXC5tBnTNqSrE040LaXED0ILNpfqb08kItyXymwQ==
X-Received: by 2002:a17:906:4e52:: with SMTP id g18mr20966337ejw.432.1628476546937;
        Sun, 08 Aug 2021 19:35:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxK6frny6dvcjfqI5TaciZS9ZEXrrOJKYE3ziypiECMFfTxXKuNTutiShduYqrJelrKgL9lo4h9Ze8QHEywbIg=
X-Received: by 2002:a17:906:4e52:: with SMTP id g18mr20966312ejw.432.1628476546611;
 Sun, 08 Aug 2021 19:35:46 -0700 (PDT)
MIME-Version: 1.0
References: <a9cd03da-b816-eed3-7e77-d539924cbe88@roeck-us.net>
In-Reply-To: <a9cd03da-b816-eed3-7e77-d539924cbe88@roeck-us.net>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Mon, 9 Aug 2021 10:35:34 +0800
Message-ID: <CAAd53p4r5_Hvnt-v0imb1Q6fQaMmRvw-skRdrTAh-GmgegBCdg@mail.gmail.com>
Subject: Re: regression: Bluetooth interface broken on systems with Mediatek CPU
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     regressions@lists.linux.dev, stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 7, 2021 at 6:22 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> [ Greg asked me to submit a report to regressions@, so here it is. ]
>
> The following error was observed on Chromebooks with MT8183 CPU
> (ASUS Chromebook Detachable CM3, HP Chromebook 11a, and others):
>
> [  224.735198] Bluetooth: qca_setup() hci0: setting up ROME/QCA6390
> [  225.205024] Bluetooth: qca_read_soc_version() hci0: QCA Product ID   :0x00000008
> [  225.205040] Bluetooth: qca_read_soc_version() hci0: QCA SOC Version  :0x00000044
> [  225.205045] Bluetooth: qca_read_soc_version() hci0: QCA ROM Version  :0x00000302
> [  225.205049] Bluetooth: qca_read_soc_version() hci0: QCA Patch Version:0x000003e8
> [  225.205055] Bluetooth: qca_uart_setup() hci0: QCA controller version 0x00440302
> [  225.205061] Bluetooth: qca_download_firmware() hci0: QCA Downloading qca/rampatch_00440302.bin
> [  227.252653] Bluetooth: hci_cmd_timeout() hci0: command 0xfc00 tx timeout
> ...
> [  223.604971] Bluetooth: qca_recv() hci0: Frame reassembly failed (-84)
> [  223.605027] Bluetooth: qca_recv() hci0: Frame reassembly failed (-84)
> (repeated several times)
> ...
>
> The Bluetooth interface on those Chromebooks can not be enabled.
>
> Bisect suggests that upstream commit 0ea9fd001a14 ("Bluetooth: Shutdown
> controller after workqueues are flushed or cancelled") introduced the problem.
> Reverting it fixes the problem.
>
> The problem was also reported at [1] on a Mediatek Pumpkin board.
>
> As of this writing, the problem is still present in the upstream kernel
> as well as in all stable releases which include commit 0ea9fd001a14.

Thanks. Can you please test the following patch:

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 2560ed2f144d4..131e69a9a66a0 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1757,6 +1757,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
                        cancel_delayed_work_sync(&adv_instance->rpa_expired_cb);
        }

+       if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+           test_bit(HCI_UP, &hdev->flags)) {
+               /* Execute vendor specific shutdown routine */
+               if (hdev->shutdown)
+                       hdev->shutdown(hdev);
+       }
+
        /* Avoid potential lockdep warnings from the *_flush() calls by
         * ensuring the workqueue is empty up front.
         */
@@ -1798,14 +1806,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
                clear_bit(HCI_INIT, &hdev->flags);
        }

-       if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
-           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
-           test_bit(HCI_UP, &hdev->flags)) {
-               /* Execute vendor specific shutdown routine */
-               if (hdev->shutdown)
-                       hdev->shutdown(hdev);
-       }
-
        /* flush cmd  work */
        flush_work(&hdev->cmd_work);


>
> Thanks,
> Guenter
>
> ---
> [1] https://lkml.org/lkml/2021/7/28/569
