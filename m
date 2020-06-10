Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DFA1F5BC6
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 21:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgFJTJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 15:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgFJTJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 15:09:12 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97BBC03E96B;
        Wed, 10 Jun 2020 12:09:12 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id e9so1380866pgo.9;
        Wed, 10 Jun 2020 12:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=STXgbJ6+lNZxIKWpG3GBIQG0Jzv5hhU0d5jqY2zTxOU=;
        b=BojmPfGyP/4GdfljA3emqJI69Lq/br4/oDmjlCylNCSuJVrbgJ7PLC39b82/oECu8F
         oPxTuNPFsKfLy26kJiBewsZvX5yWvJxBzPaosMHiEYxYVdvM3ngWbx66AB/0AFkyF9qO
         GgRDMWiMeqH2BlDnG7tglMlgMw5mAk2YFjhkmpVWMzI9yD2tg3y4tZvwhxLGS6NuYQ26
         S5ROTaHK2YNQGqH4kOLLco12CEtxvKD1H1rd8Ytxlh+rmFN+SIt8kmQGKZynDwoZUE2y
         Ume4jgXI8VjwHsNFlZ4bO148fUksJWA6LPdfUwgr13a3FG9LfeKVREp0In5aXVFwIM27
         tCYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=STXgbJ6+lNZxIKWpG3GBIQG0Jzv5hhU0d5jqY2zTxOU=;
        b=GGufC8RBH7UDdyoaXXSA5L/Yt7BYNeWKdkQbL34r47BG0O64sP1gubdDC+2ZMcZVim
         y8bLAJ9C9zWHLOlIaji4FVb4JytDZpx884j3swBJK5Sdn74s+3nLbJkuY4T8SexONwUZ
         8PEgJtIAhg+Eyp3Y7vAveI+8Wzvtxek/OT6+zF7AO2VR+vD8JnXji/EXdF1pfhGyfNpx
         rilHsmdEtTqAiYexwf/tp/V1GUR3aOTN8eMJpI7BYA3jyGcXdA8iSOcmIjfcb2sSAvPU
         YyC342rmKC1m9ztMUdoOG0Ek8z/j4rMoijCiMG4mvl67lBROiDSwMo21bBtmkK4hYB+H
         cWxA==
X-Gm-Message-State: AOAM530SWaF4evBaB6af9td/ruzw2DN4c/3yZ9jFq1R46xFftruLwIEf
        pPiH8L+w+NTOPRrxMsT3SvU=
X-Google-Smtp-Source: ABdhPJyGrg392f7DNO7k7Mg6ZJDd2BZ/5cLY7PrAGmXpipvza4+7az8ReBQBtWe6yQUVddzgyKsZkg==
X-Received: by 2002:a65:66d5:: with SMTP id c21mr3668428pgw.155.1591816152528;
        Wed, 10 Jun 2020 12:09:12 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w206sm669779pfc.28.2020.06.10.12.09.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 12:09:11 -0700 (PDT)
Date:   Wed, 10 Jun 2020 12:09:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/36] 4.4.227-rc2 review
Message-ID: <20200610190910.GB232340@roeck-us.net>
References: <20200609190211.793882726@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609190211.793882726@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 09:18:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.227 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 19:02:00 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 169 pass: 169 fail: 0
Qemu test results:
	total: 331 pass: 331 fail: 0

Guenter
