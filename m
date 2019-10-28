Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07671E740E
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 15:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390363AbfJ1Ow4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 10:52:56 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43586 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390361AbfJ1Ow4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 10:52:56 -0400
Received: by mail-pf1-f193.google.com with SMTP id 3so7016454pfb.10;
        Mon, 28 Oct 2019 07:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hJ3NnUhgeGpA6iL5DgRtc520b7QzKyB4NdjCDsOvlOY=;
        b=tza1DbXUmkKbz6sneXrcuHWFs5cGJ+0+40e0nCSJ1YpgZDkWhqhG8mJvWBVeogbyBY
         y/nlqLj/s9CYi38J+sEEGAoVTe6sTl82CRKOceRb4Ncol+88KnAjGNiAUoyoypvu8Wgy
         nOD3d/bOvX+MABGm6d+LAoTvrlKn/3AaxrVKBPeScVuzks/41kEhouHFYrOmlroK1XhA
         7MjDj7OnuGYQnUqh2TXZbOTxZNxZs9i761a5ZK4ieJcknmJRpYQXU/LisJwGEt/Iq2LP
         juoUPkmZutYDy9aoZ0w7e7idRyepeyCpUWyIvpW90To7eYx0CBnkHLWeSRAYTn4Jo5cA
         s+Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hJ3NnUhgeGpA6iL5DgRtc520b7QzKyB4NdjCDsOvlOY=;
        b=arG7jPgsPnkdev38pPUZjoslMo+t3BZHNAbnxQLPG/PGBWnq72+DfjZLUg9BM3Ny5B
         YOpPMApp3CT/FWHErsGlDuvftk7cEQoHWf6OPYe20P5K39WM95m5iRgrbl3NoBV7VnlD
         9pzWTVneCL1gC3u0oPwuUamTgpd35ZfBpulAxg07ozuYEB0lHcHlqz3Sj3SewZMtEo+F
         67MJOAp3/29NUR81IGzwXsO+mGzpm/BYwhdRAVZsYU2YH9ZMhzarcHQMNJM1UN1vFH+a
         OgakSMRcTT1Lh/pxhcBotcLKGdNPgZdImP5LNAkDPN4ZGI23YZWpYXe4elxwBWg1hl9m
         YTgA==
X-Gm-Message-State: APjAAAUBa8bes9ov52qtRlSywwet4FSWnyAzr4td0da4rNlryr7n+oj8
        N3u3kSszymzPq2HrBZ0gc6I=
X-Google-Smtp-Source: APXvYqwd6dMQeHwCwo7wMQl5znC9PZhATfaGmpDVhyJIbohQ2JWULeV2s+auIG97RUdBT5Wa53p1JQ==
X-Received: by 2002:a17:90a:9306:: with SMTP id p6mr481418pjo.68.1572274374961;
        Mon, 28 Oct 2019 07:52:54 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n3sm10402700pff.102.2019.10.28.07.52.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Oct 2019 07:52:54 -0700 (PDT)
Date:   Mon, 28 Oct 2019 07:52:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/93] 4.19.81-stable review
Message-ID: <20191028145252.GA23544@roeck-us.net>
References: <20191027203251.029297948@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 10:00:12PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.81 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
