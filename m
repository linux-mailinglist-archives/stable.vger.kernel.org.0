Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0080313A9D
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 18:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhBHRPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 12:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbhBHRPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 12:15:36 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95331C06178B;
        Mon,  8 Feb 2021 09:14:56 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id y199so14350665oia.4;
        Mon, 08 Feb 2021 09:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tdNQuG29PrVAD/P4A7v+E0Ow0aOjizgrN8jm4+KxLm4=;
        b=OubHbYszbmHplJphHSIoRLbq/5IpSQVdzuJuRg7kYpA+CFvVdhBKsO2AlNrtK/S6Ol
         41cwXQzzU0Dx7h5MvF0VcrZvcflRRmhPPoY7RXtGnLYt89cJtYG8SG+DoVub9xqo6OcJ
         wSQMhmRQtPNEzYi1Ef6kPoPmL8DZyONBw5aXCBqwXyRD+odE/vlQ8Btz4sx8wQMOoEIi
         9/ftcR07hlC8qjCCAezVYkeyihadp/P4heUTYfpikErTE39nVaN6HiJ5fMe+mzCBlzSZ
         /WNTf05MdLed1zyMJOJ41undeOCraoF2Yy4R/Tu/mU38WW7l/9ZJoVCuB42+/RE6vsWU
         6pLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=tdNQuG29PrVAD/P4A7v+E0Ow0aOjizgrN8jm4+KxLm4=;
        b=s4sHOks+gyn7LWTLpbbjKS6bBSZ6wSAHE5k5vQV86ghi+ByUPY6PSWFRtWXlrgI9bc
         fHBQdkqRStx24GuGdHkrQTJX7sbXl860lvnO/jGDi4Byn0uHyBUQB1Ux5SdEAgkFTlMG
         A20I1NOvff3H82iYxeoa/r6cgVsi/DhStZ8EVVx2XGMyxBM1lFre/h+BA+v9OU+uuJvZ
         hyASyPMDbmEJJrfQ67Tm7Zg/tGnOTRWG92PuN37enzdYF+Zd/rGCwRrDh9tVFS1VDcmM
         KADfCFI69te5SmI3DeIGDIs0R+iDBLaUf06p+VkaQfjDp5nePMV1OxiXENkKv5Pwebl7
         3HMA==
X-Gm-Message-State: AOAM532hoYeXbP0v6XmIafaJu6AC3AnvcmVht+8u2vMj5iJf57zrAP4u
        e8+R8NMD37u0EEvMGYBs0s0=
X-Google-Smtp-Source: ABdhPJwLhc15uaXOeCalZs3ss6npgZ7B/U1OQxOwZ7cxgtDDaXNbeYPaLDp+HdpX+B6CUDR7xVwSGg==
X-Received: by 2002:a54:4098:: with SMTP id i24mr11363229oii.39.1612804496089;
        Mon, 08 Feb 2021 09:14:56 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a1sm3155044oti.21.2021.02.08.09.14.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Feb 2021 09:14:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 8 Feb 2021 09:14:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net, jslaby@suse.cz,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com
Subject: Re: Linux 4.4.256
Message-ID: <20210208171453.GA174128@roeck-us.net>
References: <1612534196241236@kroah.com>
 <20210205205658.GA136925@roeck-us.net>
 <YB6S612pwLbQJf4u@kroah.com>
 <20210206131113.GB7312@1wt.eu>
 <20210206132239.GC7312@1wt.eu>
 <e173809f-505d-64a8-1547-37e0f6243f4c@roeck-us.net>
 <YB7cU7SCyBOHFJGS@kroah.com>
 <20210206184926.GA19587@roeck-us.net>
 <YB+jVD6r4vlzuZO0@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YB+jVD6r4vlzuZO0@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 07, 2021 at 09:22:44AM +0100, Greg Kroah-Hartman wrote:
[ ... ]
> > There are lots (35) of "KERNEL_VERSION(4, 5, 0)" in chromeos-4.4.
> > That should not matter with the clamped LINUX_VERSION_CODE, but
> > I'd prefer to clamp KERNEL_VERSION as well just to be sure. On
> > top of that, some of the vendor code we carry along does check
> > SUBVERSION, but that is probably more of an academic concern.
> 
> Ah, the internal checks, I think the other patch by Sasha will let that
> get bigger and should work for you as well.  Can you try it out?
> 
Quite frankly I like the "complete" fix much better, but then I dislike
deviating from stable releases even more. I'll use Sasha's version.

Thanks,
Guenter
