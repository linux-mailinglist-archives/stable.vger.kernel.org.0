Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38E6125899
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 01:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfLSAgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 19:36:54 -0500
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:48690 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLSAgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 19:36:51 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id xBJ0aYfM008093; Thu, 19 Dec 2019 09:36:34 +0900
X-Iguazu-Qid: 34tKGlJZZqk6vL4KLA
X-Iguazu-QSIG: v=2; s=0; t=1576715794; q=34tKGlJZZqk6vL4KLA; m=SwoY/TSCZoTPn4z9YK3xPmEM2rXSGc3P6PU8pEkguk4=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1511) id xBJ0aXjQ029406;
        Thu, 19 Dec 2019 09:36:33 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id xBJ0aXh7020534;
        Thu, 19 Dec 2019 09:36:33 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id xBJ0aWCm015498;
        Thu, 19 Dec 2019 09:36:32 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     linux-serial@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nobuhiro1.iwamatsu@toshiba.co.jp,
        shrirang.bagul@canonical.com, stable@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH] serdev: Don't claim unsupported serial devices
References: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp>
        <096046b6-324a-8496-8599-ed7e5ffc6e3c@redhat.com>
Date:   Thu, 19 Dec 2019 09:37:23 +0900
In-Reply-To: <096046b6-324a-8496-8599-ed7e5ffc6e3c@redhat.com> (Hans de
        Goede's message of "Wed, 18 Dec 2019 11:05:40 +0100")
X-TSB-HOP: ON
Message-ID: <87eex1noak.fsf@kokedama.swc.toshiba.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> writes:

> Hi,
>
> On 18-12-2019 07:56, Punit Agrawal wrote:
>> Serdev sub-system claims all serial devices that are not already
>> enumerated. As a result, no device node is created for serial port on
>> certain boards such as the Apollo Lake based UP2. This has the
>> unintended consequence of not being able to raise the login prompt via
>> serial connection.
>>
>> Introduce a blacklist to reject devices that should not be treated as
>> a serdev device. Add the Intel HS UART peripheral ids to the blacklist
>> to bring back serial port on SoCs carrying them.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Johan Hovold <johan@kernel.org>
>> Cc: Hans de Goede <hdegoede@redhat.com>
>
> Thank you for addressing this long standing issue.

I am surprised there hasn't been more people complaining! Maybe even on
x86 mainline isn't that widely used on development boards.

> The basic approach here looks good to me, once the minor
> comments from other reviewers are addressed you can add my:
>
> Acked-by: Hans de Goede <hdegoede@redhat.com>

Thanks!

[...]

