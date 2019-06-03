Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6753292A
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 09:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfFCHNG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 3 Jun 2019 03:13:06 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:48228 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfFCHNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 03:13:06 -0400
Received: from nat-ies.mentorg.com ([192.94.31.2] helo=svr-ies-mbx-02.mgc.mentorg.com)
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hXh8l-0005Oz-CL from Carsten_Schmid@mentor.com ; Mon, 03 Jun 2019 00:12:19 -0700
Received: from SVR-IES-MBX-03.mgc.mentorg.com (139.181.222.3) by
 svr-ies-mbx-02.mgc.mentorg.com (139.181.222.2) with Microsoft SMTP Server
 (TLS) id 15.0.1320.4; Mon, 3 Jun 2019 08:12:15 +0100
Received: from SVR-IES-MBX-03.mgc.mentorg.com ([fe80::1072:fb6e:87f1:ed17]) by
 SVR-IES-MBX-03.mgc.mentorg.com ([fe80::1072:fb6e:87f1:ed17%22]) with mapi id
 15.00.1320.000; Mon, 3 Jun 2019 08:12:15 +0100
From:   "Schmid, Carsten" <Carsten_Schmid@mentor.com>
To:     Sasha Levin <sashal@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: AW: [PATCH 3/5] usb: xhci: avoid null pointer deref when bos field is
 NULL
Thread-Topic: [PATCH 3/5] usb: xhci: avoid null pointer deref when bos field
 is NULL
Thread-Index: AQHVEJHzdFut9W6npEKrmFpS3QjO6qaCDxyAgAeGlFA=
Date:   Mon, 3 Jun 2019 07:12:15 +0000
Message-ID: <99dc43dda4cc4877b87da9f7bd7711c0@SVR-IES-MBX-03.mgc.mentorg.com>
References: <1558524841-25397-4-git-send-email-mathias.nyman@linux.intel.com>
 <20190529131455.C7A8C217D4@mail.kernel.org>
In-Reply-To: <20190529131455.C7A8C217D4@mail.kernel.org>
Accept-Language: de-DE, en-IE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [137.202.0.90]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

i was OOO last week.
Let me check why the patch doesn't apply in the older kernel series.
I originally developed it on a 4.14.86 and ported it to 5.1.

Shouldn't be a big problem, its a "one line mover" only.

BR
Carsten


> -----Ursprüngliche Nachricht-----
> Von: Sasha Levin [mailto:sashal@kernel.org]
> Gesendet: Mittwoch, 29. Mai 2019 15:15
> An: Sasha Levin <sashal@kernel.org>; Mathias Nyman
> <mathias.nyman@linux.intel.com>; Schmid, Carsten
> <Carsten_Schmid@mentor.com>; gregkh@linuxfoundation.org
> Cc: linux-usb@vger.kernel.org; Stable <stable@vger.kernel.org>;
> stable@vger.kernel.org
> Betreff: Re: [PATCH 3/5] usb: xhci: avoid null pointer deref when bos field is
> NULL
> 
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.1.4, v5.0.18, v4.19.45, v4.14.121,
> v4.9.178, v4.4.180, v3.18.140.
> 
> v5.1.4: Build OK!
> v5.0.18: Build OK!
> v4.19.45: Build OK!
> v4.14.121: Failed to apply! Possible dependencies:
>     01451ad47e272 ("powerpc/powermac: Use setup_timer() helper")
>     38986ffa6a748 ("xhci: use port structures instead of port arrays in xhci.c
> functions")
>     83ad1e6a1dc04 ("powerpc/oprofile: Use setup_timer() helper")
>     8d6b1bf20f61c ("powerpc/6xx: Use setup_timer() helper")
>     b1fc2839d2f92 ("drm/msm: Implement preemption for A5XX targets")
>     b9eaf18722221 ("treewide: init_timer() -> setup_timer()")
>     cd414f3d93168 ("drm/msm: Move memptrs to msm_gpu")
>     e629cfa36ea08 ("MIPS: Lasat: Use setup_timer() helper")
>     e99e88a9d2b06 ("treewide: setup_timer() -> timer_setup()")
>     eec874ce5ff1f ("drm/msm/adreno: load gpu at probe/bind time")
>     f7de15450e906 ("drm/msm: Add per-instance submit queues")
>     f97decac5f4c2 ("drm/msm: Support multiple ringbuffers")
> 
> v4.9.178: Failed to apply! Possible dependencies:
>     01451ad47e272 ("powerpc/powermac: Use setup_timer() helper")
>     38986ffa6a748 ("xhci: use port structures instead of port arrays in xhci.c
> functions")
>     53460c53b7619 ("[media] au0828: Add timer to restart TS stream if no data
> arrives on bulk endpoint")
>     7c96f59e0cafe ("[media] s5p-mfc: Fix initialization of internal structures")
>     83ad1e6a1dc04 ("powerpc/oprofile: Use setup_timer() helper")
>     8d6b1bf20f61c ("powerpc/6xx: Use setup_timer() helper")
>     b9eaf18722221 ("treewide: init_timer() -> setup_timer()")
>     cf43e6be865a5 ("block: add scalable completion tracking of requests")
>     e629cfa36ea08 ("MIPS: Lasat: Use setup_timer() helper")
>     e806402130c9c ("block: split out request-only flags into a new namespace")
>     e99e88a9d2b06 ("treewide: setup_timer() -> timer_setup()")
> 
> v4.4.180: Failed to apply! Possible dependencies:
>     01451ad47e272 ("powerpc/powermac: Use setup_timer() helper")
>     37f895d7e85e7 ("NFC: pn533: Fix socket deadlock")
>     38986ffa6a748 ("xhci: use port structures instead of port arrays in xhci.c
> functions")
>     53460c53b7619 ("[media] au0828: Add timer to restart TS stream if no data
> arrives on bulk endpoint")
>     7c96f59e0cafe ("[media] s5p-mfc: Fix initialization of internal structures")
>     80c1bce9aa315 ("[media] au0828: Refactoring for start_urb_transfer()")
>     83ad1e6a1dc04 ("powerpc/oprofile: Use setup_timer() helper")
>     8d6b1bf20f61c ("powerpc/6xx: Use setup_timer() helper")
>     9815c7cf22dac ("NFC: pn533: Separate physical layer from the core
> implementation")
>     b9eaf18722221 ("treewide: init_timer() -> setup_timer()")
>     e629cfa36ea08 ("MIPS: Lasat: Use setup_timer() helper")
>     e997ebbe46fe4 ("NFC: pn533: Send ATR_REQ only if
> NFC_PROTO_NFC_DEP bit is set")
>     e99e88a9d2b06 ("treewide: setup_timer() -> timer_setup()")
> 
> v3.18.140: Failed to apply! Possible dependencies:
>     0a5942c8e1480 ("NFC: Add ACPI support for NXP PN544")
>     34ac49664149d ("NFC: nci: remove current SLEEP mode management")
>     3590ebc040c9e ("NFC: logging neatening")
>     3682f49f32051 ("NFC: netlink: Add new netlink command
> NFC_CMD_ACTIVATE_TARGET")
>     37f895d7e85e7 ("NFC: pn533: Fix socket deadlock")
>     38986ffa6a748 ("xhci: use port structures instead of port arrays in xhci.c
> functions")
>     53460c53b7619 ("[media] au0828: Add timer to restart TS stream if no data
> arrives on bulk endpoint")
>     5df848f37b1d2 ("NFC: pn533: fix error return code")
>     7c96f59e0cafe ("[media] s5p-mfc: Fix initialization of internal structures")
>     80c1bce9aa315 ("[media] au0828: Refactoring for start_urb_transfer()")
>     9295b5b569fc4 ("NFC: nci: Add support for different
> NCI_DEACTIVATE_TYPE")
>     96d4581f0b371 ("NFC: netlink: Add mode parameter to deactivate_target
> functions")
>     9815c7cf22dac ("NFC: pn533: Separate physical layer from the core
> implementation")
>     b9eaf18722221 ("treewide: init_timer() -> setup_timer()")
>     d7979e130ebb0 ("NFC: NCI: Signal deactivation in Target mode")
>     e997ebbe46fe4 ("NFC: pn533: Send ATR_REQ only if
> NFC_PROTO_NFC_DEP bit is set")
>     e99e88a9d2b06 ("treewide: setup_timer() -> timer_setup()")
> 
> 
> How should we proceed with this patch?
> 
> --
> Thanks,
> Sasha
