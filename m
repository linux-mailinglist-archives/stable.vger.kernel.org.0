Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15BC44BBDD
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 07:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhKJHBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 02:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhKJHBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 02:01:05 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79A4C061764;
        Tue,  9 Nov 2021 22:58:18 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id n8so2229407plf.4;
        Tue, 09 Nov 2021 22:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3nIlP+4Avq8rKCDMi3ovNknd9j+nbAxJQ0DNHaQvwrQ=;
        b=dYzWMdXfPlA3oUNjJ27Z2BN8Gx9l146tZH/0so9eAUAEL7rP3ZRlY1qvxVpj+nV8//
         acpv7D++7gQMTXRtthyMpS8PSShO4FCs86v4fF/XlBds3NM7JvTFSgxN/Dn/IdE8odKe
         /fGgmcxzoyDSCVMSUK9ExTtwLaR8BpP0suEmwKvPb0rHVTcPYEWdZzrP70tEx5GcUCqR
         w2sfYuZk41xWVLI1MVLQqTcR/1mQCf6zfifPJsIU/VKwowrERubcv3IFwM1vXypKTeUg
         Y5Kgkh2lvvbwvo+x2m3BO5YtAGxsblKJeeem6yc2BawyfYCbgAfwouLZOKqkopbwCFH8
         yW3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3nIlP+4Avq8rKCDMi3ovNknd9j+nbAxJQ0DNHaQvwrQ=;
        b=N62CvXNdLKoFap9wvFg9k+/+d0hcV/LO4xFBV99xNhiiEQNX7lvdhRhJgdY6uEDcmH
         GfMJcu243wjarQR9aykdeUwAg8BMPezl5ALMP8PgP5b9Dw/CgcoVnfAO7Ehst9lBVywy
         de9LO8uyQ7giqWbpgcqfwuYKKYy1TbzF2Vvs+hgw/eggUCJVI1sxHzzPdBv+69/kSzLf
         GCwydSv2YqcWD5jGEqEsFbx+lk7I5AS5Z2pkGVQXQlkPlpHybN/CI8sl0jbfMLF1Ahp0
         qPIVIEwiokkwBHIbJnOcRfCWMXU9Wy7oR4WhrKA3zJPnBjtDBcp29FOiLIopR4ZOSrK1
         5Dwg==
X-Gm-Message-State: AOAM533rQqR3eTe84JSvPyOs2lSfPVbYaheVZmVIps7+NLzV05goOiJT
        2m18gPKelPWbBBqok9ociu4=
X-Google-Smtp-Source: ABdhPJz3V2FQFnoMM+y/cXaYI1LVmE+KRc5tk1dhN8ML8NFrxykG4zS+2lCvvnzrN8jArK+C8LcqAA==
X-Received: by 2002:a17:90a:2ec8:: with SMTP id h8mr12717133pjs.168.1636527498343;
        Tue, 09 Nov 2021 22:58:18 -0800 (PST)
Received: from google.com ([2620:15c:202:201:b345:ee3a:151d:b1d1])
        by smtp.gmail.com with ESMTPSA id w3sm18870607pfd.195.2021.11.09.22.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 22:58:17 -0800 (PST)
Date:   Tue, 9 Nov 2021 22:58:15 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Input: iforce - fix control-message timeout
Message-ID: <YYtth0DYJ7/3kXTF@google.com>
References: <20211025115501.5190-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025115501.5190-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 01:55:01PM +0200, Johan Hovold wrote:
> USB control-message timeouts are specified in milliseconds and should
> specifically not vary with CONFIG_HZ.
> 
> Fixes: 487358627825 ("Input: iforce - use DMA-safe buffer when getting IDs from USB")
> Cc: stable@vger.kernel.org      # 5.3
> Signed-off-by: Johan Hovold <johan@kernel.org>

Applied, thank you.

-- 
Dmitry
