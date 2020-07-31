Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4912D233CD8
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 03:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730937AbgGaBWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 21:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728262AbgGaBWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 21:22:34 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D82C061574
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 18:22:33 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id h16so1498985oti.7
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 18:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=BV/kORjcopPgwHWRrwQx561HSkshWVBc8LLhW+e1JPY=;
        b=G0rithKdtSvUh/AwTii7Bg7uhY0p7O6VDaeH0pS6EJtV759h32ypTe7n2LmxSf9NH5
         o47Kv79aaU73fKqpaV5gjNv2sKSKkRB/HjgoZi3zsbkDzlwdaodHxIFrGp/vcBDo2Op6
         JIVQks6SdhW/lBu3T3+JsVrVxafNFcxUQl2kikBEINmsmsGQfgWxyfkj/RihcjekEMc9
         1UPJ6LrIRXojujoVMkqpIAw8Qol/aAtfLBs0ooC17+vR0UU4xeHfMVT+03IZTCDJKkxz
         TVDTwGWACU2Ko0k6kskEhxoxkT+ZJdimTWN7m1XXAkpqlAHfLexprY6QAJSY3xyJsES3
         5QSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=BV/kORjcopPgwHWRrwQx561HSkshWVBc8LLhW+e1JPY=;
        b=Zb3GCY8YeufYIGRnbT/XpzA+rADy0hnHIEM+Gy43OBzGjny2j7rONNbNOOXwdh2ISN
         ofhvJKQcB+evTJphv/0tQ9iK9gW7Gy5PJAnBpP88L0U+SrBbNuoBmBE0IHhwWf8/2hix
         hOrIebL8dnhKJAlVVdcQrk23Q7HPxktifDxJsp5JquLUwg8nzkGBz5qGxKLqhc1j5jyP
         p4feRgZLgeASIEw4eZTDtc7QubNTvQhe7XU7YADWUJLS/cR59LtNn/4/NDUqV2p50V4k
         RLmKPx8xriOGwegvDG2cIBnLXkMW9DV1S8ZCWa2at7ULU21kOQreSO8utWKrYsyTBDIb
         IToQ==
X-Gm-Message-State: AOAM532nQNTJqsP3bP9O0+A0az1bPHMiNCRf/081IRwN45/dOU46VgmF
        HhPFWsJ0VlvHpvWRrNbYKjiMgYEmF94nWwTPtQuIwq9Ed5Q=
X-Google-Smtp-Source: ABdhPJxo1vYOHUxk3uKK7bJs1OzciZA7CdqYCQiLYaEK/PM5VFvIencItK3YMFznL56+CCXFC1YF3jzRA/IjgoKcjs0=
X-Received: by 2002:a9d:7684:: with SMTP id j4mr1171865otl.266.1596158553041;
 Thu, 30 Jul 2020 18:22:33 -0700 (PDT)
MIME-Version: 1.0
From:   Robert Hancock <hancockrwd@gmail.com>
Date:   Thu, 30 Jul 2020 19:22:22 -0600
Message-ID: <CADLC3L20-OaNXhNQ-uW29XPQv0uus8zwLcv=vk-YGL=0P3sdeA@mail.gmail.com>
Subject: Nominate "PCI/ASPM: Disable ASPM on ASMedia ASM1083/1085 PCIe-to-PCI
 bridge" for stable
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I would like to nominate the following commit, now in mainline, for
stable. This fixes an issue exposed by commit 66ff14e59e8a ("PCI/ASPM:
Allow ASPM on links to PCIe-to-PCI/PCI-X Bridges") and so should go
into all stable branches which that was backported to (which appears
to be all of the currently maintained releases).

commit b361663c5a40c8bc758b7f7f2239f7a192180e7c
Author: Robert Hancock <hancockrwd@gmail.com>
Date:   Tue Jul 21 20:18:03 2020 -0600

    PCI/ASPM: Disable ASPM on ASMedia ASM1083/1085 PCIe-to-PCI bridge

    Recently ASPM handling was changed to allow ASPM on PCIe-to-PCI/PCI-X
    bridges.  Unfortunately the ASMedia ASM1083/1085 PCIe to PCI bridge device
    doesn't seem to function properly with ASPM enabled.  On an Asus PRIME
    H270-PRO motherboard, it causes errors like these:

      pcieport 0000:00:1c.0: AER: PCIe Bus Error: severity=Corrected,
type=Data Link Layer, (Transmitter ID)
      pcieport 0000:00:1c.0: AER:   device [8086:a292] error
status/mask=00003000/00002000
      pcieport 0000:00:1c.0: AER:    [12] Timeout
      pcieport 0000:00:1c.0: AER: Corrected error received: 0000:00:1c.0
      pcieport 0000:00:1c.0: AER: can't find device of ID00e0

    In addition to flooding the kernel log, this also causes the machine to
    wake up immediately after suspend is initiated.

    The device advertises ASPM L0s and L1 support in the Link Capabilities
    register, but the ASMedia web page for ASM1083 [1] claims "No PCIe ASPM
    support".

    Windows 10 (build 2004) enables L0s, but it also logs correctable PCIe
    errors.

    Add a quirk to disable ASPM for this device.

    [1] https://www.asmedia.com.tw/eng/e_show_products.php?cate_index=169&item=114

    [bhelgaas: commit log]
    Fixes: 66ff14e59e8a ("PCI/ASPM: Allow ASPM on links to
PCIe-to-PCI/PCI-X Bridges")
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208667
    Link: https://lore.kernel.org/r/20200722021803.17958-1-hancockrwd@gmail.com
    Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
