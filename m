Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E3F1018D8
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfKSGJz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 19 Nov 2019 01:09:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52456 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbfKSF1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 00:27:39 -0500
Received: from mail-pl1-f197.google.com ([209.85.214.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1iWw36-0006ax-S7
        for stable@vger.kernel.org; Tue, 19 Nov 2019 05:27:37 +0000
Received: by mail-pl1-f197.google.com with SMTP id u9so12499245plq.1
        for <stable@vger.kernel.org>; Mon, 18 Nov 2019 21:27:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=q9JpcXkRXz6uJnywj52lO/S/Hv/ltfL2Wdo08p44ofk=;
        b=rkCWAjfnWKJCo60DwGr2o0slZrmxHLe6LhT2OJHr2m//n2GuMvQ/Vkfo2Rga/OYoE0
         Ofzqm7RX16INekeq/Jt0uvoNcXHh3TKsSlqQWQJcoHYBQlciE9pvs3V2ZJYvBSzC5RZ4
         kdSj4Rly7RBpxXKhqPExr8cLaaT9+RyHogy6VoKvl+UIJhrebPRPZszWPKtJZeh39E5/
         nrmS7bkCLDCwzUY79Y0sR8Zt1hh9VgHR3ilO0QajcNLOJz6+icmyjnHl6V3BEhMWN880
         nh6U6C+N8FNIINrTCMBez9DOdZEGnJiquZt+RvxX8jKa3V5fhJ5xMIvPLSPZTAb4nQw/
         IjwA==
X-Gm-Message-State: APjAAAX7Jf6+l2PX/1U4IZ08oUkeqvY/2L0oMD3Q5A7J3t/73NMv6Cf/
        Gvbahu9G11lO+j2+QZnrrtuma+wpRlr27ZNqQo8/zhPNrDgI3k8H/Br0+TuXupyrCGvarS/kC4p
        mlSVivk4yxCzN8rL6f3so6PdHUQuxXqJsDA==
X-Received: by 2002:a63:f1c:: with SMTP id e28mr3381259pgl.67.1574141255475;
        Mon, 18 Nov 2019 21:27:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqzd1RY1xmVatZaENKvaVBAXnp4evumvlPiKvt4uZAMudFnBBaATbz4rRZDV6pHBYv0wLRsZEg==
X-Received: by 2002:a63:f1c:: with SMTP id e28mr3381236pgl.67.1574141255114;
        Mon, 18 Nov 2019 21:27:35 -0800 (PST)
Received: from 2001-b011-380f-3c42-d02c-da56-2d00-ce2a.dynamic-ip6.hinet.net (2001-b011-380f-3c42-d02c-da56-2d00-ce2a.dynamic-ip6.hinet.net. [2001:b011:380f:3c42:d02c:da56:2d00:ce2a])
        by smtp.gmail.com with ESMTPSA id 23sm21769525pgw.8.2019.11.18.21.27.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 21:27:34 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: Patch "x86/quirks: Disable HPET on Intel Coffe Lake platforms"
 has been added to the 4.4-stable tree
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <1574092522185210@kroah.com>
Date:   Tue, 19 Nov 2019 13:27:31 +0800
Cc:     20190516090651.1396-1-harry.pan@intel.com,
        20191016103816.30650-1-kai.heng.feng@canonical.com,
        feng.tang@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <8B3CE6F5-0DD0-4F03-B86B-5AAA883F2569@canonical.com>
References: <1574092522185210@kroah.com>
To:     gregkh@linuxfoundation.org
X-Mailer: Apple Mail (2.3601.0.10)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

> On Nov 18, 2019, at 23:55, <gregkh@linuxfoundation.org> <gregkh@linuxfoundation.org> wrote:
> 
> 
> This is a note to let you know that I've just added the patch titled
> 
>    x86/quirks: Disable HPET on Intel Coffe Lake platforms
> 
> to the 4.4-stable tree which can be found at:
>    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>     x86-quirks-disable-hpet-on-intel-coffe-lake-platforms.patch
> and it can be found in the queue-4.4 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

This patch depends on commit c8c4076723da ("x86/timer: Skip PIT initialization on modern chipsets").
Otherwise the system may freeze at boot. So please also include that commit.

Kai-Heng

> 
> 
> From fc5db58539b49351e76f19817ed1102bf7c712d0 Mon Sep 17 00:00:00 2001
> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Date: Wed, 16 Oct 2019 18:38:16 +0800
> Subject: x86/quirks: Disable HPET on Intel Coffe Lake platforms
> 
> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> 
> commit fc5db58539b49351e76f19817ed1102bf7c712d0 upstream.
> 
> Some Coffee Lake platforms have a skewed HPET timer once the SoCs entered
> PC10, which in consequence marks TSC as unstable because HPET is used as
> watchdog clocksource for TSC.
> 
> Harry Pan tried to work around it in the clocksource watchdog code [1]
> thereby creating a circular dependency between HPET and TSC. This also
> ignores the fact, that HPET is not only unsuitable as watchdog clocksource
> on these systems, it becomes unusable in general.
> 
> Disable HPET on affected platforms.
> 
> Suggested-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203183
> Link: https://lore.kernel.org/lkml/20190516090651.1396-1-harry.pan@intel.com/ [1]
> Link: https://lkml.kernel.org/r/20191016103816.30650-1-kai.heng.feng@canonical.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
> arch/x86/kernel/early-quirks.c |    2 ++
> 1 file changed, 2 insertions(+)
> 
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -699,6 +699,8 @@ static struct chipset early_qrk[] __init
> 	 */
> 	{ PCI_VENDOR_ID_INTEL, 0x0f00,
> 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> +	{ PCI_VENDOR_ID_INTEL, 0x3ec4,
> +		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> 	{ PCI_VENDOR_ID_BROADCOM, 0x4331,
> 	  PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_airport_reset},
> 	{}
> 
> 
> Patches currently in stable-queue which might be from kai.heng.feng@canonical.com are
> 
> queue-4.4/x86-quirks-disable-hpet-on-intel-coffe-lake-platforms.patch

