Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739E223DEA6
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 19:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgHFR2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 13:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729716AbgHFRBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 13:01:23 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96066C00215C;
        Thu,  6 Aug 2020 09:00:10 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id g19so37061742ejc.9;
        Thu, 06 Aug 2020 09:00:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SBTEh2IqzApKPGLI0KaDJEQ6Ul4GdQLwfypsWEkduQY=;
        b=sWjQn00opEh3ysIjn9yrPdAgeXjcTwuT3o3t+i2zi0JErjCRanMTXP8fROnEfry+1L
         Gk/hwXzq47+3x95GBseIKNxOkYYjuJnhdnCqVO6mt19wQMYUCkFU9BqEZP3CjitmJtTT
         0Cfb+o4flyogFkMcTqzg22VcOsRU3k5G21fD1D/NQC0jFydcYdPgeqgHWHkJ0zzGb9BS
         XfqLowVMxF0M3BHl0pIlFOIgCT08E33Xik6CJLT9M2u++R+R/QUtikuyd3jWspZV6Gp0
         0p62Yc067oGjj24xI583NYwBbv+S9TCTPXi64M9qzdv7Xd2ThvJo0ty2pMf6L/RHUZvX
         ZpSQ==
X-Gm-Message-State: AOAM532GnkCcsu3tTenh8v9iKLjMNJhQ1DvLRfLnvWFaWK04hk0PK8DB
        wPE5Fn8hZe2rj6YlmaHwGDuamBWk4cI=
X-Google-Smtp-Source: ABdhPJzYCjbGWFMLwI24xTvZK2FCGeO8yRGXSjriQhaEyChLhcMZZcy8l1jLyxcGio03Lm1BK6EgYg==
X-Received: by 2002:a2e:b175:: with SMTP id a21mr3732433ljm.385.1596714135558;
        Thu, 06 Aug 2020 04:42:15 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id r1sm2553077lff.55.2020.08.06.04.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 04:42:14 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1k3eHp-0002pY-QG; Thu, 06 Aug 2020 13:42:17 +0200
Date:   Thu, 6 Aug 2020 13:42:17 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Patrick Riphagen <ppriphagen@gmail.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        patrick.riphagen@xsens.com, stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: ftdi_sio: add IDs for Xsens Mti USB
 converter
Message-ID: <20200806114217.GQ3634@localhost>
References: <20200806090234.4130-1-patrick.riphagen@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806090234.4130-1-patrick.riphagen@xsens.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 06, 2020 at 11:02:34AM +0200, Patrick Riphagen wrote:
> The device added has an FTDI chip inside.
> The device is used to connect Xsens USB Motion Trackers.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Patrick Riphagen <patrick.riphagen@xsens.com>
> ---

Almost there; would you mind resending with an added From: line before
the commit message so that the authorship matches the SoB?

Also, whenever you update a patch, please add a version number in the
Subject line (e.g. "[PATCH v2]: USB: serial: ...") so we can keep track
of which version is the latest one. You should also include a short
changelog here under the "---" line so we know what changed.

Thanks,
Johan
