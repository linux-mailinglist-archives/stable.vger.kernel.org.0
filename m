Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8889130E6B
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 09:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgAFIJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 03:09:13 -0500
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:57884 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgAFIJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 03:09:13 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 006895dt010192; Mon, 6 Jan 2020 17:09:05 +0900
X-Iguazu-Qid: 2wHHRLdPLmlO4ZZEmL
X-Iguazu-QSIG: v=2; s=0; t=1578298144; q=2wHHRLdPLmlO4ZZEmL; m=na7Qt1q5QT+sQHFFGMvgay8Mnd4k6nbEiyuYSfioJ2o=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1111) id 0068944t029769;
        Mon, 6 Jan 2020 17:09:04 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 006894g3026034;
        Mon, 6 Jan 2020 17:09:04 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 006893QK011403;
        Mon, 6 Jan 2020 17:09:03 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     Sasha Levin <sashal@kernel.org>
Cc:     <linux-serial@vger.kernel.org>, <stable@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] serdev: Don't claim unsupported ACPI serial devices
References: <20191219100345.911093-1-punit1.agrawal@toshiba.co.jp>
        <20191225235531.D7BB320882@mail.kernel.org>
Date:   Mon, 06 Jan 2020 17:10:15 +0900
In-Reply-To: <20191225235531.D7BB320882@mail.kernel.org> (Sasha Levin's
        message of "Wed, 25 Dec 2019 23:55:31 +0000")
X-TSB-HOP: ON
Message-ID: <87o8vhatug.fsf@kokedama.swc.toshiba.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.4.5, v5.3.18, v4.19.90, v4.14.159, v4.9.206, v4.4.206.
>
> v5.4.5: Failed to apply! Possible dependencies:
>     33364d63c75d ("serdev: Add ACPI devices by ResourceSource field")
>
> v5.3.18: Failed to apply! Possible dependencies:
>     33364d63c75d ("serdev: Add ACPI devices by ResourceSource field")
>
> v4.19.90: Failed to apply! Possible dependencies:
>     33364d63c75d ("serdev: Add ACPI devices by ResourceSource field")
>
> v4.14.159: Failed to apply! Possible dependencies:
>     33364d63c75d ("serdev: Add ACPI devices by ResourceSource field")
>     53c7626356c7 ("serdev: Add ACPI support")
>
> v4.9.206: Failed to apply! Possible dependencies:
>     0634c2958927 ("of: Add function for generating a DT modalias with a newline")
>     0a847634849c ("[media] lirc_serial: use precision ktime rather than guessing")
>     53c7626356c7 ("serdev: Add ACPI support")
>     a6f6ad4173b3 ("lirc_serial: make checkpatch happy")
>     b66db53f8d85 ("[media] lirc_serial: port to rc-core")
>     cd6484e1830b ("serdev: Introduce new bus for serial attached devices")
>     fa5dc29c1fcc ("[media] lirc_serial: move out of staging and rename to serial_ir")
>
> v4.4.206: Failed to apply! Possible dependencies:
>     0634c2958927 ("of: Add function for generating a DT modalias with a newline")
>     0a847634849c ("[media] lirc_serial: use precision ktime rather than guessing")
>     49fc9361db78 ("[media] add maintainer for stih-cec driver")
>     53c7626356c7 ("serdev: Add ACPI support")
>     8459503295d9 ("[media] staging: media: lirc: Replace timeval with ktime_t in lirc_serial.c")
>     a6f6ad4173b3 ("lirc_serial: make checkpatch happy")
>     b66db53f8d85 ("[media] lirc_serial: port to rc-core")
>     cd6484e1830b ("serdev: Introduce new bus for serial attached devices")
>     fa5dc29c1fcc ("[media] lirc_serial: move out of staging and rename to serial_ir")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

The patch only makes sense in kernels that have ACPI support enabled for
serdev devices, i.e., v4.15+. In the applicable kernels, it has a
dependency on 33364d63c75d ("serdev: Add ACPI devices by ResourceSource
field") as detected by the bot.

The patch does not need to be backported any further back.

Likely due to the holidays, Greg's not yet picked up the patch for
upstream. I'll nudge him for feedback.

Thanks,
Punit
