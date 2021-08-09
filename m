Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9513E456C
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 14:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbhHIMND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 08:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbhHIMND (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 08:13:03 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1003C0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 05:12:42 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id dk2so8783109qvb.3
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 05:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3O4sNg9lZ+RPsPEbPeTqhty2VenuMzMUdATYBIYMPSM=;
        b=XNTaf9kZPJjnaMNbzGwJaEi5zLEKec8dJ6Nyjir56RVuRdFezKMBvTVDOFjgF2zm6L
         JOwX+/DgvByL82JJPO5tOhJOhPvSuxuHc/hMfUHn4SlUKYf6Ql45AoBsxVURG5mkHVNE
         nFzuRMNIAlEoJasCU+Xv8tXA3AS+1lTHhx2AP7U12cqnS+cPWkPz9rL5sss1g9P/bsVj
         NIZMf732mkhnisX42mnQ/KcSBkIpNcnTH2361SELP8YjbEDGiUdwwoBsh25KU0C/77LG
         677FTS1LWftKjrqK6IXHgU696Bmanbw2cDz52CMTX/09JR5kqqbQVOpKS1MGxrbvKCeF
         4+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3O4sNg9lZ+RPsPEbPeTqhty2VenuMzMUdATYBIYMPSM=;
        b=ooL3OFu6ZSPWNHGYEeic4fRegCZPkQKnbFlJSROUA3whfByhQRqlv+gSDqPJPen/de
         I2v9fTyEtsa28KPJIgJUnsi2wYk3n+/M1zjivNKYaTvtW5azw0ZeFxExnOe84P6T+bIE
         jepu46WcS2ClRvCA36ZBgejZp6gM1ewljJ+Lp/HSFQJYK7Oq+rv+Q224FNR5687NXa47
         hd7R8cGQ8X4UdYxyIu7br86GcNPDVk+ojeDhiPYzOgj85fZpo2Wx+o2nd7pIjgYKk/OU
         fNPhtQbG7ofJNGnsiJmCGQJMdly/Xzw5Ff2NX3O6NSJyNjQeyPXe4OFrGb9CX/dOfRMq
         ygIQ==
X-Gm-Message-State: AOAM531uIF4vjyEKVWs/mdGanbFrdR10nIw8UolX9VeE7hzkGaqQ0gtO
        7Nufz4DvgFxLmRifNVLvkCU=
X-Google-Smtp-Source: ABdhPJxU0CCJPmso9N/zZleWZy/90uaT//VoYhnRpy03eIwFRX0gMFBpt3Vfj06jfQ8sTSJHtEZ/Tg==
X-Received: by 2002:ad4:4442:: with SMTP id l2mr23211998qvt.2.1628511162107;
        Mon, 09 Aug 2021 05:12:42 -0700 (PDT)
Received: from mua.localhost ([2600:1700:e380:2c20::47])
        by smtp.gmail.com with ESMTPSA id y2sm8957497qkd.38.2021.08.09.05.12.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 05:12:41 -0700 (PDT)
Subject: Re: Patch "Revert "ACPI: resources: Add checks for ACPI IRQ
 override"" has been added to the 5.13-stable tree
From:   PGNet Dev <pgnet.dev@gmail.com>
To:     gregkh@linuxfoundation.org, hui.wang@canonical.com,
        rafael.j.wysocki@intel.com
References: <16277146132219@kroah.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Message-ID: <e9810931-b21c-195f-26cb-75b46aa9eb9a@gmail.com>
Date:   Mon, 9 Aug 2021 08:15:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <16277146132219@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/31/21 2:56 AM, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>      Revert "ACPI: resources: Add checks for ACPI IRQ override"
> 
> to the 5.13-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>       revert-acpi-resources-add-checks-for-acpi-irq-override.patch
> and it can be found in the queue-5.13 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
>  From e0eef3690dc66b3ecc6e0f1267f332403eb22bea Mon Sep 17 00:00:00 2001
> From: Hui Wang <hui.wang@canonical.com>
> Date: Wed, 28 Jul 2021 23:19:58 +0800
> Subject: Revert "ACPI: resources: Add checks for ACPI IRQ override"
> 
> From: Hui Wang <hui.wang@canonical.com>
> 
> commit e0eef3690dc66b3ecc6e0f1267f332403eb22bea upstream.

Confirming that this^ revert resolves the reported non-boot regression

System does boot cleanly; but, then REboots @ 60 seconds.

It's a known bug, with fix already in 5.13.9/stable:

  Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"
  https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.13.y&id=02db470b866fd06d8951

, causing TCO watchdog auto-reboot @ 60 secs.

Although particularly nasty on servers with /boot on RAID, breaking arrays if watchdog boots before arrays correctly assembled, iiuc, it's UN-related

With interim workaround

  edit /etc/modprobe.d/blacklist.conf

+	blacklist iTCO_wdt
+	blacklist iTCO_vendor_support

for this second issue in place, 5.13.8 boots & appears stable.
