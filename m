Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B534B1C265D
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 16:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgEBO4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 10:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgEBO4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 May 2020 10:56:48 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A50C061A0C;
        Sat,  2 May 2020 07:56:48 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x15so3075045pfa.1;
        Sat, 02 May 2020 07:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RcBQxL7OPCcW96H9lJXi2triKVwXh3GmzyE91OaNwW4=;
        b=X61JjyykazDtmW9Ti2d6bb3szOH1yUTSbBk5iEIlOp9pCC68GJSJ+BpYe+zjd26BgY
         2gavkiyi+k/3CLp3iwLd3l5UIR8kCjefqIYk5JjqQ/Jo7OnY9HG/FATlbY+qU0+cDwyL
         sY/SSFDPXnpkBp0EiXCUJclwWKbkJV+XqlLvA4U4iNfYVrm29jYjdVCULD3KX1P2p/Up
         NOMaLjvTJ6sDIO+RHVCBVyNiGiaBBqxaie7nUPgBr25lSWtpSdIuvNz763AjDz2QTllW
         AN4M2J5984bANJm+OyUBjds58frUsM5M0gS24Ix6xt+YefsOb7/joiO/ngpSJEPsuLuH
         3+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=RcBQxL7OPCcW96H9lJXi2triKVwXh3GmzyE91OaNwW4=;
        b=EV4v54dwbrm4rys00Afk2Z2WBmWjMGgwJgdwmj5SUj8n1AdfneLgVxrQBrN4vss6I7
         ZyfviEC5rflNYWjMt8so93TUGNItWUz9scBCmxeyBhOix9X3YyrkuLxAvK+oqStHN/b+
         ZFEGsefdxiuF4ZtbnVjnOhQrmekEfRPI7dE2IC4ExQ7AO+Hoq6Fqu9qoV1MuJPvZg/8L
         JEe6HDDwE1qmS8V4nzd+eBrtePWjbi6WXT0LNIqpzE8PVRlA/wrX5xvWEZyTHzS78ZRX
         Ip81IBaPttVDNxpveG5ZN6zWxem3h3scNxAJXGlvAdvdlQRjl6CrjZ095sh/w0FMH4Af
         yAKA==
X-Gm-Message-State: AGi0PuYndstKtej7InKSkjOHH1dzE2xi5u+TE5dDxR77Q3uWGc2D0/LA
        oAYLELHs8spG76iCeYB0tgU=
X-Google-Smtp-Source: APiQypJBcuBVqh0hB4VCHc6FtIx3cg+i27okWGXQQ+BLqSynwg7ECk1OT6w3BeTUAedXp/6PBn3N4g==
X-Received: by 2002:a63:fc0a:: with SMTP id j10mr8146328pgi.54.1588431407766;
        Sat, 02 May 2020 07:56:47 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k12sm4298747pgj.33.2020.05.02.07.56.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 02 May 2020 07:56:47 -0700 (PDT)
Date:   Sat, 2 May 2020 07:56:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/47] 4.19.120-rc2 review
Message-ID: <20200502145646.GD189389@roeck-us.net>
References: <20200502064235.767298413@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502064235.767298413@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 02, 2020 at 08:48:14AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.120 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 04 May 2020 06:40:34 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Guenter
