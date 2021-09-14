Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5031F40B676
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhINSE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhINSE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 14:04:28 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3B4C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:03:10 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id c42-20020a05683034aa00b0051f4b99c40cso19766562otu.0
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tb4qHHViIoRDbO0ceCggoUCybSg3vUZsAfJ5wkxGsf8=;
        b=mrV8/HUKmUxptB/Lz2m9itpBmKkmMPPgpbcgPWD8RU30/O9RsOIuQYXutCxsqcEmvb
         8KXWCKRDIaceYsQmbL9KKoqJxBQQpbLKLdLcXm4YjML5hV1SS1wYKHSLNefTAY0cz2kK
         oTEE0zGgyBCG3itaN2Bm/V5srBOH/IVKUg6Y4NE8qCtSUo8mgMW78XXehr3woSwJAhzP
         dDLunnQvVJAK66v54Wb2dPRu1A2mCeZCy2KCc/tvhhtrKAC3MoSuZE94YSKrMCx1xbaa
         oeOWS9rQg7ZuJwkT82MtoDejT/1+SpkfMuLzN/qPS4O1V8B7+6B3rgItpTAjSPa6k9rV
         GZjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=tb4qHHViIoRDbO0ceCggoUCybSg3vUZsAfJ5wkxGsf8=;
        b=vI9oD/7JDJZvZNoYEpfTYYriw6FSFDrnpGzzJUnL57ereEFh8Geg40YqvKCh5yqvgG
         6wC3go1vDA/KQN35Co5lpc2IA3GmvaW0205GlJdezORIzBoKwG+F2C2u8DGSp/lD4JOY
         yIsfsx4DM1c3MpolAS0zBDQHifoX/kz6k6zq+Li/j70OsGRlNn3lPqKsmujjXDQkI9F0
         eLSgzHqjtMVOCkVFQlGBXX8DcENcYBRmT0zb8apWko8O/mKs4NtAQsFJSQm8GJrDR5q0
         /chmDxq/dHpb8H+/MXLax0nQOzY1UWRP03DPfm1JxRGEm5QdvaI+t/XHnc6JDzljNFk2
         g2bA==
X-Gm-Message-State: AOAM532VfmEfsELD7WwmZsavKZWeReYjlMhOK8Bbq94jH2S7DnkZmNxe
        miABLkrIG/ZDlszD92NIOZs=
X-Google-Smtp-Source: ABdhPJwwJwuLdhTRTfjQGtChViG+89tRH0wpbIWo0KVUuCO2PhqySfq4XzvvVt7kujiGzTtoN3lE+A==
X-Received: by 2002:a05:6830:25d5:: with SMTP id d21mr16043049otu.105.1631642590157;
        Tue, 14 Sep 2021 11:03:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a6sm2766643oto.36.2021.09.14.11.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 11:03:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 14 Sep 2021 11:03:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: ppc crashes in v4.14.y-queue and v4.19.y-queue
Message-ID: <20210914180307.GA567043@roeck-us.net>
References: <87cbd9ce-161e-7c15-fbf4-66abd2540bed@roeck-us.net>
 <YUDKnfT6RJJDXs94@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUDKnfT6RJJDXs94@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 06:15:25PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 14, 2021 at 09:03:38AM -0700, Guenter Roeck wrote:
> > Hi,
> > 
> > I see the following crashes in v4.14.y-queue and v4.19.y-queue.
> > Please let me know if I need to bisect.
> > 
[ ... ]

> 
> Bisection would be great to track this down if at all possible.
> 
Attached. Reverting the offending patch fixes the problem in both v4.14.y-queue
and v4.19.y-queue.

Guenter

---
# bad: [d73a5c7790019b70d9454ee9797c223198ad8ff0] Linux 4.14.247-rc1
# good: [f96eb53cbd76415edfba99c2cfa88567a885a428] Linux 4.14.246
git bisect start 'HEAD' 'v4.14.246'
# bad: [33a419b7cde2a3b8a0932319b6d54914717797f0] block: nbd: add sanity check for first_minor
git bisect bad 33a419b7cde2a3b8a0932319b6d54914717797f0
# good: [69f55eceb19466d9b20f926dbd16a4a0ad22ddbb] Revert "btrfs: compression: don't try to compress if we don't have enough pages"
git bisect good 69f55eceb19466d9b20f926dbd16a4a0ad22ddbb
# good: [f749b828e2bd070a33c3e8a1eda0e5e2de15ae81] power: supply: max17042_battery: fix typo in MAx17042_TOFF
git bisect good f749b828e2bd070a33c3e8a1eda0e5e2de15ae81
# good: [adccd339c64fbcd7098cf58a57acc3b7db3488d5] crypto: qat - fix naming for init/shutdown VF to PF notifications
git bisect good adccd339c64fbcd7098cf58a57acc3b7db3488d5
# good: [fe223807816e23234dc25460fabbe8957fec14e4] m68k: emu: Fix invalid free in nfeth_cleanup()
git bisect good fe223807816e23234dc25460fabbe8957fec14e4
# good: [17c695dab8970f9c7396bb7ccb25cc204b685f0b] spi: spi-pic32: Fix issue with uninitialized dma_slave_config
git bisect good 17c695dab8970f9c7396bb7ccb25cc204b685f0b
# good: [e2ff046bc5c21120d29085f33d3c56e3cf024ec3] clocksource/drivers/sh_cmt: Fix wrong setting if don't request IRQ for clock source channel
git bisect good e2ff046bc5c21120d29085f33d3c56e3cf024ec3
# first bad commit: [33a419b7cde2a3b8a0932319b6d54914717797f0] block: nbd: add sanity check for first_minor
