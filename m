Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315AB43C6C1
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 11:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241266AbhJ0Jtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 05:49:42 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:45784 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbhJ0Jtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 05:49:41 -0400
Received: by mail-wr1-f54.google.com with SMTP id o14so3019497wra.12;
        Wed, 27 Oct 2021 02:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OFu06dK+pr0CiCz8sOgcK79FrtlXeRSMwN2V1c19Y+g=;
        b=PVekN6iOoXgZF0K9+CAc42vb4oTIIJR5LYCBa38gd5Z68NVsXm13ni+VM/3Wo+ldmB
         HD7p2gxb766IZM7gHbvIq0KC4WGSVmfmdv1pQwzZCprbjdzDYicLPjXgSmrym3K37+XP
         0UOlpJDfdAMrM8nRMJ1D4au5487jrjQOpSWrM7+Pk1HtPFqovUgzMsMhzq/4gB49bgZV
         T2hDGICrpKarKQMXyLuCMW75vUTI8cT1eSuQqjBfwUOebwqSa3ArvTUTp5pGrGPcS4Wz
         ajcGmBvbRBfh2UCdPx0mXubCp6iLP3mw1ObnrjWp5dukWrgHQXhssb96KEnuLJQJoEfi
         nKNg==
X-Gm-Message-State: AOAM5303xyf4Z/bJ56V0iVOzzcNoFfDPMB1HLY+eeFOnfAFQeP+dM2bX
        H2SRhl5FcVOqi0Thx+//5DV60AlfLXA=
X-Google-Smtp-Source: ABdhPJwnwnvVmMMBHLZ9z8B7mrpO+Zjk/N650wkrIJV7BDv209YQktd8CepVv/XntNMIpr0kXmBYLg==
X-Received: by 2002:a5d:6d8e:: with SMTP id l14mr38980717wrs.304.1635328035591;
        Wed, 27 Oct 2021 02:47:15 -0700 (PDT)
Received: from rocinante ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id t12sm3051361wmq.44.2021.10.27.02.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 02:47:15 -0700 (PDT)
Date:   Wed, 27 Oct 2021 11:47:14 +0200
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Robin McCorkell <robin@mccorkell.me.uk>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Limit REBAR quirk to just Sapphire RX 5600 XT
 Pulse
Message-ID: <YXkgIjURbhdWo4YX@rocinante>
References: <20211026212835.GA167500@bhelgaas>
 <20211026214513.25986-1-robin@mccorkell.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211026214513.25986-1-robin@mccorkell.me.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+CC adding Bjorn as the PCI sub-system maintainer]

Hi Robin,

Thank you for sending the patch over!

> A particular RX 5600 device requires a hack in the rebar logic, but the
> current branch is too general and catches other devices too, breaking
> them. This patch changes the branch to be more selective on the
> particular revision.
> 
> This patch fixes intermittent freezes on other RX 5600 devices where the
> hack is unnecessary. Credit to all contributors in the linked issue on
> the AMD bug tracker.
> 
> See also: https://gitlab.freedesktop.org/drm/amd/-/issues/1707
[...]

The commit message could be improved a little bit so that it's more in
preferred imperative tone describing what precisely is broken and how it
fixes the problem for Sapphire RX 5600 XT and other ATI cards.  Also,
consistent capitalisation of "REBAR" between the subject and the commit
message would be a plus.

There is also no need to add "this patch" - we also know that this is this
very patch, especially since this isn't a series that comprises of multiple
other patches.

Also, sine this is a v2, it would be nice to include a small changelog,
even if the change is trivial, with helps as people don't have to go and
read other e-mail threads to find out what was changed and why.

> Reported-by: Simon May <@Socob on gitlab.freedesktop.com>
> Tested-by: Kain Centeno <@kaincenteno on gitlab.freedesktop.com>
> Tested-by: Tobias Jakobi <@tobiasjakobi on gitlab.freedesktop.com>
> Suggested-by: lijo lazar <@lijo on gitlab.freedesktop.com>

The above would be "gitlab.freedesktop.org", I believe.  Having said that,
I am not sure if we can accept username handles to some remote Git hosting
platform in lieu of proper, so to speak, e-mail addresses.

[...]
>  	/* Sapphire RX 5600 XT Pulse has an invalid cap dword for BAR 0 */
>  	if (pdev->vendor == PCI_VENDOR_ID_ATI && pdev->device == 0x731f &&
> -	    bar == 0 && cap == 0x7000)
> +	    pdev->revision == 0xC1 && bar == 0 && cap == 0x7000)

A small nitpick: lowercase hexadecimal values to match how it's been used
in other places.

	Krzysztof
