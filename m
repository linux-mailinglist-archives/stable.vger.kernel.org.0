Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354B9274A06
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 22:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgIVUTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 16:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIVUTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 16:19:46 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA56CC0613D0;
        Tue, 22 Sep 2020 13:19:45 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id 185so22437470oie.11;
        Tue, 22 Sep 2020 13:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cU/mqRwfS+hHHjS1iyHpDuR0Mxkm7cO5mWCSouzpmbc=;
        b=sE3T0v1fU6UhCVKyPuKKBoMCEivsNMZ/8QGAfiBNS3/XrvPqCnRqcHhvozrvOx4Tma
         eVGALTBmhk1rJarrcdMGLUOuOjLQ6kK9ZHEiVFMBIKGHWiu7zPgNOpRRG6w333bYlXnu
         L6JRtVaH501E/Y7jWMe/adaglnp3Kd5aQsj+q0OeRYtqoNiiLKtTc/xzeJJgg7w3Qnqh
         eWyLsz6PTDrVnNKIcbe1GOlcTFsb4nduXVd/gKSKFrT8jTht4Bn5nFnEBhLgpV4adTR5
         fNyTtILl3BZyNleJPU5RNa6TOfRR68i1Jte/upwHPjhTVaUUAWIWoOIf72rOLtnXOw5R
         m3Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=cU/mqRwfS+hHHjS1iyHpDuR0Mxkm7cO5mWCSouzpmbc=;
        b=bTutenuYgTbsI67hvaDwON0VL1koQuKwdRVFWViznDBxK7oSPd9ilnjvP55Ddl6mVo
         GJ1VLJEod7KKdli2WvohOSJFpedJnaBlOqL5kWdQYBxBWeFq/HPDMNNYAxKIuAC5MKmv
         GqRE/dcIViiP0MUHPigYp4vEVbCiEiIOLy8f6Kfm9q1WsDQ9IPEmCWgCdG2rs18aWiv9
         23+KB6ylqGgJWPYDK4j/bENN3ot3wKWlZm50KPKCZBAact1Xscow1eKv7FccuZS/nwsQ
         z0EzxmIlx9pjoyY1oV3vKYha6APctewOkYizP3pX//ONtPxyremQ6KYRY3OEFQto3bP3
         xGdg==
X-Gm-Message-State: AOAM530C1R7WVKllZgcc77wuwHQnjWPIVq0rLvTPJdl9V4b47wjXCZ95
        kAr40sHgD+k4OIttlQI1Psc=
X-Google-Smtp-Source: ABdhPJyhxIQI3Kou0tWa6voX7hZh/lnusZzzc2SXWzK1Xc+4DDMwQ5iXrkR4snm5qM4Wx+fog2tw1w==
X-Received: by 2002:aca:f5cb:: with SMTP id t194mr3521763oih.144.1600805985324;
        Tue, 22 Sep 2020 13:19:45 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w25sm1886353oth.22.2020.09.22.13.19.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Sep 2020 13:19:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 22 Sep 2020 13:19:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/118] 5.8.11-rc1 review
Message-ID: <20200922201943.GF127538@roeck-us.net>
References: <20200921162036.324813383@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 06:26:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.11 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
