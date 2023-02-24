Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE0A6A1F47
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 17:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjBXQEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 11:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBXQED (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 11:04:03 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264A29E;
        Fri, 24 Feb 2023 08:04:02 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id s22so18387149lfi.9;
        Fri, 24 Feb 2023 08:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zUsFaxZ6j31tQ8GVF2ii1eUsK/sstnQuHS5gc+jVWyw=;
        b=LNQCaUq2KXehrY/BYX8UXFPX/2tc4T9jQ8WkFsvXkArN50oOs6mOtLOk+xq4uFVjk+
         wfifE32s/dVhJL9KsaItOllHjUc1tdvcOkKC4nSiKkerXQVYYdlerEuW6FUNiDNx1zK9
         a23n9LL8PL9BFg8oZr+Y8wAvp+0h1hjHvOsb6D5YZFkeqaAXTmP4Sjnb7al4jSRi5c2R
         YpRRN+g2Dc1JCjMqtHRF3R4W5q8Kt2Gdi41W0mJJFo6H9/n51DAQHgt7TKbev+IkPDXp
         YYLNzt52s/I4erxVLeWbLG/OG4VKnamAwlhi/eP17Rv4YbgjheWvjO54KeieVeyugP6L
         Yo4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zUsFaxZ6j31tQ8GVF2ii1eUsK/sstnQuHS5gc+jVWyw=;
        b=7LaI51dQFtjBxIEWDr1NScjot+6D9c5+AJ6oE8BeXOcIsdQbOvIU/v+6ahhi27u1k1
         VU6Pf0LI6Mns3UM8xEJAhON+G12BnC+Nw1vnYNHvzxAJgqqPyEdq2ZNqprXgUCNJQzZH
         WZIk+HtOUcXbjANYdgrVJzqeiAmkIkP9wNdorLTUPdTp6pNDyoWCVr/47izy8OpaKXHB
         888CDzJY/bw3n6PSAV8/CbYm+rcjdA0vATchZgVgKS17SuC7WlMhqcdiMkCPfV6Ws70a
         q3X9p57EVGCUmQQbXDYaT2fUmbGuUtAouv5dYRsbEEcJZdQRh0Bp8VxtjDhql3y15/dX
         aN3g==
X-Gm-Message-State: AO0yUKV8dw8J/cNfFVDLYxuswmYDa/HxKkyojV2+tKK8+aEANf8mWTXW
        guR8uOZZMtXQV5Hci71nMlm/Y7yMAwuHInlbJt+fqD15tsbQAA==
X-Google-Smtp-Source: AK7set8JUQLzyvNLcmcO9y3sD/z1oTCHWOTCeWHqdLAOSY64D7Dd6rP+vuw5hCCOoGpHQvCGuiwLmvHp3JCTGCZiAWA=
X-Received: by 2002:ac2:5926:0:b0:4db:1326:79b4 with SMTP id
 v6-20020ac25926000000b004db132679b4mr5134333lfi.2.1677254640206; Fri, 24 Feb
 2023 08:04:00 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab3:6fc4:0:b0:21f:d305:475 with HTTP; Fri, 24 Feb 2023
 08:03:59 -0800 (PST)
In-Reply-To: <CAOzgRdZro5t=CtKEwH0RQ6nqYvbd08-kNCnGpo3+NncgfRtFJw@mail.gmail.com>
References: <20230116142216.1141605-3-mathias.nyman@linux.intel.com>
 <20230223162617.31845-1-youling257@gmail.com> <b924a240-e03a-af6c-29ea-390c84cde5d5@linux.intel.com>
 <CAOzgRdZro5t=CtKEwH0RQ6nqYvbd08-kNCnGpo3+NncgfRtFJw@mail.gmail.com>
From:   youling 257 <youling257@gmail.com>
Date:   Sat, 25 Feb 2023 00:03:59 +0800
Message-ID: <CAOzgRdYsAdQ6MC033xp0URsvbcJ8RR=zTHCj9TcWjPsbMXqayQ@mail.gmail.com>
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

By the way, i used this patch on linux kernel has been a year,
https://lore.kernel.org/all/6908aa69-469b-8f92-8e19-60685f524f9c@synopsys.com/

2023-02-24 23:58 GMT+08:00, youling 257 <youling257@gmail.com>:
> February 17, when i used linux 6.2-rc8, happen "Abort failed to stop
> command ring: -110", google search history February 17 search "Abort
> failed to stop command ring: -110" and "Usbreset No such device
> found".
>
> Date: Fri, 17 Feb 2023 23:59:29 +0800
> Subject: [PATCH] Revert "usb: xhci: Check endpoint is valid before
> dereferencing it"
> This reverts commit e8fb5bc76eb86437ab87002d4a36d6da02165654.
>
> a week never see usb not work.
> may be revert it fix my problem.
>
> 2023-02-24 18:29 GMT+08:00, Mathias Nyman <mathias.nyman@linux.intel.com>:
>> On 23.2.2023 18.26, youling257 wrote:
>>> I used type-c 20Gbps USB3.2 GEN2x2 PCIe Expansion Card, may be this
>>> patch
>>> cause USB3.2 GEN2x2 PCIe Expansion Card not work.
>>>
>>> [    0.285088] xhci_hcd 0000:09:00.0: hcc params 0x0200ef80 hci version
>>> 0x110 quirks 0x0000000000800010
>>> [    0.285334] usb usb7: We don't know the algorithms for LPM for this
>>> host, disabling LPM.
>>> [    0.285347] xhci_hcd 0000:09:00.0: xHCI Host Controller
>>> [    0.285407] hub 7-0:1.0: USB hub found
>>> [    0.285415] hub 7-0:1.0: 4 ports detected
>>> [    0.285783] xhci_hcd 0000:09:00.0: new USB bus registered, assigned
>>> bus
>>> number 8
>>> [    0.285787] xhci_hcd 0000:09:00.0: Host supports USB 3.2 Enhanced
>>> SuperSpeed
>>> [    0.285889] hub 4-0:1.0: USB hub found
>>> [    0.285901] hub 4-0:1.0: 1 port detected
>>> [    0.285988] usb usb8: We don't know the algorithms for LPM for this
>>> host, disabling LPM.
>>> [ 3277.156054] xhci_hcd 0000:09:00.0: Abort failed to stop command ring:
>>> -110
>>> [ 3277.156091] xhci_hcd 0000:09:00.0: xHCI host controller not
>>> responding,
>>> assume dead
>>> [ 3277.156103] xhci_hcd 0000:09:00.0: HC died; cleaning up
>>>
>>> may be this patch cause "xhci_hcd 0000:09:00.0: HC died; cleaning up"
>>> problem.
>>
>> Unlikely, this patch only touches code called after HC already died.
>>
>> Does reverting this patch fix the issue?
>>
>> Thanks
>> Mathias
>>
>
