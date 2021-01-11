Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB702F2263
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 23:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbhAKWEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 17:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbhAKWEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 17:04:09 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3C6C061786;
        Mon, 11 Jan 2021 14:03:28 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id 9so238301oiq.3;
        Mon, 11 Jan 2021 14:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4pnAUu4MoWOWC8B526NUcSdK5Bv3Jv4STD3FiBRZNko=;
        b=ZAdmY9NPZXL/ECXlxSJ2c8FFpNtjaCFLqMAKCkEmkltVV8schM/n9EZYDoWLKlMDtt
         UecdLrjjCpJev2jxRovNPe6rSWncB7TqNUeDCluzeo7y/MIcW2zE9MXjVjQzfzTCSkkS
         1eWO6Dg7ckcWW3xVe3MS1RMgDBHZSj+QlqCHqpsh48Bxd9/nup/Xye/mOuihB3R62ZUo
         PeSv8LJE8gdJ7j5LanzKERrFATUxUw6bdFz4vy1T9MK29hSLmWk5b9pxOruAimP30EVb
         VQ2RuQilL/zUkMW3LVimOvhdIoDsZn219LV0yOmeeGdi3taqcGY0loNSPihCJCSKFQ7Q
         TqLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4pnAUu4MoWOWC8B526NUcSdK5Bv3Jv4STD3FiBRZNko=;
        b=eB5xvwE5SAULgga0Fbw6vgVyDBeVeiYcmb1H5P4e6UNFvbLRPUXi5Q+DpjMIZklvOs
         2rLuZzaDMV4aHFelhhBUnSJD/m6/4Fdd/wVdfwhd3y4g3a8pPNjceOOPxApbyt/+0y05
         ktjppgGNAQ4BLtiGbFuYT06LD2fvur2QV55Lq1F6Ut2FpqHmhxoFnz2SQU4sa+HpHjfs
         bzzkylrirGd40KDvwbzMVyncld3bDfQUfZlLvY8ja0ErUsEfBqNAOZNSzVIPScyo7i2u
         7lV+o6xbwN+Cauk87MvAM8qXIMk/eGbahw+q7fS5HqO6X4lRlZ8+VUj0os1GfBnBY+l7
         Sd5A==
X-Gm-Message-State: AOAM532pTP4sckuFlgcCNQuDjiNofeHXhxPh2rU7AYbRQgLuvfu1FG5/
        DoJniktlp9Jo7hen+AR6qf8=
X-Google-Smtp-Source: ABdhPJzbtZ/T0PKwNqkqEyPo0xB2G3hNodTikJ9l7qoKWKGX0T8rPAjQWNhZm7qjBvmZzNijkNO8Bg==
X-Received: by 2002:aca:bc54:: with SMTP id m81mr414334oif.27.1610402608399;
        Mon, 11 Jan 2021 14:03:28 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z3sm176111ooj.26.2021.01.11.14.03.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 14:03:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Jan 2021 14:03:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/144] 5.10.7-rc2 review
Message-ID: <20210111220326.GF56906@roeck-us.net>
References: <20210111161510.602817176@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111161510.602817176@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 05:15:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.7 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 16:14:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
