Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD5D1F5BC4
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 21:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgFJTIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 15:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgFJTIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 15:08:51 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAC6C03E96B;
        Wed, 10 Jun 2020 12:08:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id s23so1512201pfh.7;
        Wed, 10 Jun 2020 12:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O+/sY0ahH0guDy6eEmLPq9HOtVtyXzyq95W3WR0fZbo=;
        b=vMALjPIhE/xTClpS7dVi2ruHfnamlTHbEX0Qkssbx0e+4WpGQmb9Qf11wQm/IgVal8
         t2tmTmcxm2F6gYf9U44Bw429mK00bCNKifBMymswLmu8D5P4kDY8NzKCwMQqkIlqfvUE
         9NIQBatOFIi+50IAkOSKCTZI6CbruqL6zgQ+lFSFYWlBFtTLxQ5vy3lMJZgjsxT19TmB
         a4hT4CAT61owZRzHiKX1IFVwgNl4/tT7T1u68w7FnIXAreYSqtvPDNJAtzz01yK6HIQU
         vxYilC8ULO9YtALYWIongSSQqJd+2iSi/eal41LGb8DNTiDo8YGE1Pw69vIS9hrca77b
         QW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=O+/sY0ahH0guDy6eEmLPq9HOtVtyXzyq95W3WR0fZbo=;
        b=LjfGffw3318nr3y67izLJbrOTrr/KMmukrREzZdzmoeqjQlG8oHZX8CqWyk0iBN4f/
         sZpU1GxTw5YPmW99HlbSk5c9eXiScskLQgi27CgFLNjlHE8LfRpDH6K3rLAauoft8cyG
         gSewPjU2A/XzLeYx5U9Lt7XwpQ5x7pug8HRMKn2LCMo/uXOVT1UL/XixHQ0IRlCbyj1T
         iWHKPMWhs2FGfmPKhJCGgiJGEUi+piyODgyMowkr4euGRgtTCS8mnRajI7vvW7H/x48/
         51xYo/U5E+GqgcoDhYZEmuUTMqM/vOzK0V+W17XoZ8Yil4mS2qp89MxuRVpfB91byjjH
         HoZw==
X-Gm-Message-State: AOAM531F2RQTRPDwB0BgDsJZERpKwMiztj2m9yK/GKd325ebE8ZQntp3
        lVIxM9wGJzEUeTdkkKzd+0M=
X-Google-Smtp-Source: ABdhPJx5FXJBYL6f9Aeg5Ig2NA9b6lsbxmjTjJQ3uewQgk4WiTmEg0mSHsr6rNHeXYVRwioZgPGhbA==
X-Received: by 2002:a63:140a:: with SMTP id u10mr1787861pgl.238.1591816129169;
        Wed, 10 Jun 2020 12:08:49 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c9sm652472pfr.72.2020.06.10.12.08.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 12:08:48 -0700 (PDT)
Date:   Wed, 10 Jun 2020 12:08:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH 3.16 00/61] 3.16.85-rc1 review
Message-ID: <20200610190847.GA232340@roeck-us.net>
References: <lsq.1591725831.850867383@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 07:03:51PM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.85 release.
> There are 61 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Jun 11 18:03:51 UTC 2020.
> Anything received after that time might be too late.
> 

Build results:
	total: 135 pass: 135 fail: 0
Qemu test results:
	total: 229 pass: 229 fail: 0

Guenter
