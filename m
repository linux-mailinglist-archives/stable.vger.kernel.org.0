Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CD02285E1
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 18:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbgGUQiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 12:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728042AbgGUQiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 12:38:09 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BB2C061794;
        Tue, 21 Jul 2020 09:38:09 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x72so10998115pfc.6;
        Tue, 21 Jul 2020 09:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eu10JA5OLvwplrNmV/SXDOuEoK36a/cnU1OAIE1ulVg=;
        b=s01eLfpEg46mAJ0+8Jx435jbuv+VsLHMmsW6VtMVMV1al6nwy729Y9CG1LERJ3Wzk8
         cpWiOd4UB9VmN7ihqup7/BS19/Tx/ccHf/MbUb/vWJUDNSesx5fe4xmU/yEOZJq1vWZ1
         GaeB4CAAfuhvPEJU9Gdw150a48EsSwhXma+Urrnbblcg+jvj98nyMcWCfTlj9CWDjDJX
         KTBanhJRpzqSxvuWUozqJPYDzhHtu6R0PnUio2jr+iNxYGrcyWbNCDQNxGFcviQgxIWs
         5niWWZ87QeXWsI+3Ac+CyjodCz0fwo9pTnzzkEM467M9Pa6WGvGSEO7Y5d8lylvru0tr
         atXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=eu10JA5OLvwplrNmV/SXDOuEoK36a/cnU1OAIE1ulVg=;
        b=O0WLV+7+tQDEZdjEp5d0eUrWPYIs06CROMRh5WRHxGdtDYMetnNGz9G/eeh2K+OcHb
         aWD37tAbOwghw3gERXozv/IH2QFo11dwOYrB6tnAoQLFBR4ZMoE/gczClG+Unync0Igv
         PWNTSm/czUUwGjcz/lh5oLQTejUdoqh+piIhV77ofd0fMApo1KOmAThXJ+sw8pp1PYrb
         KxH5EKIzx6JJ7gb++E/nvgVTuNBp68uX9rDiOA+yKcrn/ZRQe/g2SgN8erEIcyNCNQ6d
         3gQyps7yFfzJlscc1kjAMFsdrGO5JDMwG+KX4mqO+bVEFqoCr+TCRYQlIm+U612jZnVL
         b7Dw==
X-Gm-Message-State: AOAM5308ki6WDbFb2V4/VSH0IDAZsEeQAOL1xxS2dSCpvtAQplmLPZop
        7hKTJ5zF9OvoCpZuoSHa8E45nzsc
X-Google-Smtp-Source: ABdhPJyrzWPB0V13F5vI6Kyxost9DS1GEIdpPrFAb9ZfXBvb82EBYpGJzfZCUGsInKWrM46PaJg7zQ==
X-Received: by 2002:a63:f90f:: with SMTP id h15mr22855754pgi.53.1595349488783;
        Tue, 21 Jul 2020 09:38:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q6sm20838407pfg.76.2020.07.21.09.38.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Jul 2020 09:38:08 -0700 (PDT)
Date:   Tue, 21 Jul 2020 09:38:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/215] 5.4.53-rc1 review
Message-ID: <20200721163807.GE239562@roeck-us.net>
References: <20200720152820.122442056@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 05:34:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.53 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Guenter
