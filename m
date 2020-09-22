Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAB22749FC
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 22:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgIVUS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 16:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgIVUS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 16:18:27 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9509C061755;
        Tue, 22 Sep 2020 13:18:26 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id y5so16837815otg.5;
        Tue, 22 Sep 2020 13:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+EPaxp21KBtPNzbXhUZIZeIcPQJYiT1NTDwfRJjXHzs=;
        b=j7txIjn06Qm8n5+BJVdRQzQ+6jItF43dpr5fmOmXMWtL/vwOymAi0+koJUe5yHMlfA
         xJYNQc4Vc2UxsOLyPu2VnqzxchVScjEVM9gFH3G3k1K2r1wSKYhXpzBkdI8nyZs/rpxT
         9GF1uNHkU/PwWocG+i2CUnIPniKDo/i+xlez7SeU5/ijQFXVsZxW/f9ZGaplMW7nzvVQ
         0BpNdNZ1xBjgEzfMckew15DKQ3xM0ny9lrInMG79AZP9aEdAYz49pHKHVUoeJx5tokTp
         znEkvWKz4tTQrVu3RVk6W3Q91uI7ivnD69jjiNcwmXrEfisXD6ik+tHYPv3zsLYB6S5H
         mpGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+EPaxp21KBtPNzbXhUZIZeIcPQJYiT1NTDwfRJjXHzs=;
        b=S0plVgmpD0k05WVoZYuKakSgniKZ+QIQLVJQgJUv7ram6cACysflN68Ywi4yoVy+5x
         CjJkyn4cjEDUSny+J4M7ezKJvCgUfpze89Tvw2wXJAWkrpGq0b+rvBqQChvrPREhnKZe
         pZigJSZDl5C+fWoY9rB2/qjZasSwVjE6njkZH4EDeWdgeimL8THQ36EiAxo1WvcxiBeS
         kDd64qsl/jQvRhONmTLNTEiNnaDezserLNCe03RKqTa8AV9YPOAsLmR808vwJ8WKxBDy
         s+OciVhvWjM293mQuEHxKM2dbSUKhQooxDtp8JeIYgdTfT8jnkDsUPNngdwtBWajN0pc
         sM3Q==
X-Gm-Message-State: AOAM530MwyUKfko8s8+8Xyj1DPtimOnrFZ0Td2+8xBrxuuh9EX6UBVJY
        EpiqUMU0YZSizWwcZeug3O4=
X-Google-Smtp-Source: ABdhPJw7j3NjevuVN1gdhUbc11UmjwNpB+tUbkFV1k260+ZaQpSGNxjDXsPvtyVrUVAFkcocb0UXYw==
X-Received: by 2002:a9d:5d2:: with SMTP id 76mr3600163otd.99.1600805906055;
        Tue, 22 Sep 2020 13:18:26 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m187sm7710249oia.39.2020.09.22.13.18.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Sep 2020 13:18:25 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 22 Sep 2020 13:18:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/94] 4.14.199-rc1 review
Message-ID: <20200922201824.GC127538@roeck-us.net>
References: <20200921162035.541285330@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 06:26:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.199 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
