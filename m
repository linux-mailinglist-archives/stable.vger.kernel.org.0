Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9384E73D71
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389680AbfGXURD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:17:03 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41621 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403869AbfGXTuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 15:50:40 -0400
Received: by mail-pl1-f194.google.com with SMTP id m9so22305302pls.8
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 12:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZiS4PVJdcBLmc+EYS5e2UtVsrajNWnABPfKSnbxUUWE=;
        b=JSCLNoOTRmBImRv/GQp82cRAhKzxYLY6eM7G1SCEaLqJNUKFetrvXnOIT1C3axrrLA
         okgoAGMPP5MNQoGP/FmGcK/HORz/CzUwB21EwRyomvOIb3GEopbMLxptRnGe4QuXzrnY
         ErpnH1D5RcxLfbI923kAx+00OdT9rSrt5fzf8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZiS4PVJdcBLmc+EYS5e2UtVsrajNWnABPfKSnbxUUWE=;
        b=C8xt4OfH2f/W3IhQF03l+7yaiDLuG5juQ/CCR6BEXhkCTBs1Yob/k8OhdXZJzJtilU
         msf/6Kx4Fo1JxNB4o0B0GBDdCm7z2ZUqnxvqntxHcRuoXPxZODCWr/jOAka0gtcnnpCb
         rmmbXEwqNjEL2N4+824ibi/xIOtJyZOkKDcDQC6DJCoGNCxoc0IDwdEaybU/fqBE6dqD
         skyoSf0Nou/zsSsEivLFk6LCUy2xgrH27dWTTH6cqZUPqKpWv/1HPL5CNmglrHnq2IwL
         eJhmWqQd6+F2sfeAy9G0QH8X9jzPh/oe84vaRxilkrAdxCE4voXdXpq4tXUNkgfNiSJu
         dh0A==
X-Gm-Message-State: APjAAAWEauY/W/+BOuPOoccy7qqhXhjgEoWhmF+ocmnTjDgPA5xOwFeJ
        zX296nm8FaSUHE3u/itTCju7mg==
X-Google-Smtp-Source: APXvYqylEdirCrmQb8nQ/YoDobsHGQHkafXJiR/HRUcSgdyvESCuzkLThZErLZWwsp/leXFInnRyVw==
X-Received: by 2002:a17:902:a03:: with SMTP id 3mr86200661plo.302.1563997839413;
        Wed, 24 Jul 2019 12:50:39 -0700 (PDT)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id y11sm51127550pfb.119.2019.07.24.12.50.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 12:50:38 -0700 (PDT)
Date:   Wed, 24 Jul 2019 12:50:36 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org
Subject: Re: [PATCH 5.3] mwifiex: fix 802.11n/WPA detection
Message-ID: <20190724195035.GA241329@google.com>
References: <20190724194634.205718-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724194634.205718-1-briannorris@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 12:46:34PM -0700, Brian Norris wrote:
> Fixes: 63d7ef36103d ("mwifiex: Don't abort on small, spec-compliant vendor IEs")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

To add to this: unfortunately, the above went out to -stable earlier
this week. So a prompt merging would be appreciated, pending review of
course.

Sorry for the breakage.

/me goes to add another (embarrasingly missing) test case to our WiFi
test suite.

Brian
