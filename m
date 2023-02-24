Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B57B6A1F14
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 16:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjBXP6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 10:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBXP6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 10:58:44 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2F524485;
        Fri, 24 Feb 2023 07:58:43 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id a10so14702565ljq.1;
        Fri, 24 Feb 2023 07:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eX7abL+E0lFb3OHJctr/9hccQWhUNw01DTib1nvsqfE=;
        b=QHeotlzocxMBfJ9BU2qUWxodkCgPKbDgGgjUYVzzR7rwfx3l0vEW7R1uiJl43pVjqP
         /R6RkRK8iAosid8SijzvJ30wtv4KmXzlSKbszU+a+1Dc37wo7bv2Fc7uUSycCQ1Tb3Aj
         tm6ERGwk9rjhsEWc+IA45W2TzpttAu6J9w5qWAotB1L3N3BARnpCnmt7Nbt1Fk2YhEb4
         ruXUTE+vvWJRiPb2KAi3n1VMv0OHVjxo7UopqFpqYXVdahJW335j8QEMVNbGaLIK1I7m
         2QlPrNYSFZm36oXrgbgI36B4ZpJUUdbah6wT/+rPsYstGt2P6CmfK2uBYH2ts9Cav8Xi
         i32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eX7abL+E0lFb3OHJctr/9hccQWhUNw01DTib1nvsqfE=;
        b=zdCvRSXRYYgqS8+V0R0MX96B2c/XM4eCGOyWnLxHZSj43nic4iEzYNt/Qle4/nOKWu
         yRavELsZllJ34mc5Plla1816ELjrxF0l2t+zNLdfVl/RsFSmUYyJVf4di6W1axyNwh7S
         hqxx0HkKjVFujQ6CYO5GBViFH8kje2BS0+AfhCqdugjfa+Y2b+0LpyDfpTUNcXUOkkDV
         EIgiRlfoTA9ow9y2dwAcNklz6wrKNgfX1UuCbPv12yRgjL8fCXSWoWAGjJpTeyWB43L0
         MVplgC7VlnGX2PLbAwyoUZXz8FOUH/6J7GmOKbYpWNF96uLjdZIhp8Fs6XdUwsAyWhLt
         ik2g==
X-Gm-Message-State: AO0yUKUOQ739E/x57bbu1KUPSY/23jvwOBpnPaTPjV2QPl728y5utTM1
        qV/LjbuvhMn2AnEsg9oXTj+Fru8qQLkwbHokYupF9FnFuEwqIA==
X-Google-Smtp-Source: AK7set98Z8vNiS+bGoqjsZgp2WZBlqqAhNJG/NFge43gTTQuxPMD20kcvRtJucXTp1JoMtIEnBqaVTS+Zf4ahHkeZbg=
X-Received: by 2002:a2e:be9b:0:b0:293:4ba5:f626 with SMTP id
 a27-20020a2ebe9b000000b002934ba5f626mr88841ljr.2.1677254321047; Fri, 24 Feb
 2023 07:58:41 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab3:6fc4:0:b0:21f:d305:475 with HTTP; Fri, 24 Feb 2023
 07:58:40 -0800 (PST)
In-Reply-To: <b924a240-e03a-af6c-29ea-390c84cde5d5@linux.intel.com>
References: <20230116142216.1141605-3-mathias.nyman@linux.intel.com>
 <20230223162617.31845-1-youling257@gmail.com> <b924a240-e03a-af6c-29ea-390c84cde5d5@linux.intel.com>
From:   youling 257 <youling257@gmail.com>
Date:   Fri, 24 Feb 2023 23:58:40 +0800
Message-ID: <CAOzgRdZro5t=CtKEwH0RQ6nqYvbd08-kNCnGpo3+NncgfRtFJw@mail.gmail.com>
Subject: Re: [PATCH 2/7] usb: xhci: Check endpoint is valid before
 dereferencing it
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     gregkh@linuxfoundation.org, hhhuuu@google.com,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

February 17, when i used linux 6.2-rc8, happen "Abort failed to stop
command ring: -110", google search history February 17 search "Abort
failed to stop command ring: -110" and "Usbreset No such device
found".

Date: Fri, 17 Feb 2023 23:59:29 +0800
Subject: [PATCH] Revert "usb: xhci: Check endpoint is valid before
dereferencing it"
This reverts commit e8fb5bc76eb86437ab87002d4a36d6da02165654.

a week never see usb not work.
may be revert it fix my problem.

2023-02-24 18:29 GMT+08:00, Mathias Nyman <mathias.nyman@linux.intel.com>:
> On 23.2.2023 18.26, youling257 wrote:
>> I used type-c 20Gbps USB3.2 GEN2x2 PCIe Expansion Card, may be this patch
>> cause USB3.2 GEN2x2 PCIe Expansion Card not work.
>>
>> [    0.285088] xhci_hcd 0000:09:00.0: hcc params 0x0200ef80 hci version
>> 0x110 quirks 0x0000000000800010
>> [    0.285334] usb usb7: We don't know the algorithms for LPM for this
>> host, disabling LPM.
>> [    0.285347] xhci_hcd 0000:09:00.0: xHCI Host Controller
>> [    0.285407] hub 7-0:1.0: USB hub found
>> [    0.285415] hub 7-0:1.0: 4 ports detected
>> [    0.285783] xhci_hcd 0000:09:00.0: new USB bus registered, assigned bus
>> number 8
>> [    0.285787] xhci_hcd 0000:09:00.0: Host supports USB 3.2 Enhanced
>> SuperSpeed
>> [    0.285889] hub 4-0:1.0: USB hub found
>> [    0.285901] hub 4-0:1.0: 1 port detected
>> [    0.285988] usb usb8: We don't know the algorithms for LPM for this
>> host, disabling LPM.
>> [ 3277.156054] xhci_hcd 0000:09:00.0: Abort failed to stop command ring:
>> -110
>> [ 3277.156091] xhci_hcd 0000:09:00.0: xHCI host controller not responding,
>> assume dead
>> [ 3277.156103] xhci_hcd 0000:09:00.0: HC died; cleaning up
>>
>> may be this patch cause "xhci_hcd 0000:09:00.0: HC died; cleaning up"
>> problem.
>
> Unlikely, this patch only touches code called after HC already died.
>
> Does reverting this patch fix the issue?
>
> Thanks
> Mathias
>
