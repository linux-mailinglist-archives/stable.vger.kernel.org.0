Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB78322167
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 22:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhBVV3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 16:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhBVV3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 16:29:37 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C5AC06174A;
        Mon, 22 Feb 2021 13:28:57 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id q186so15498886oig.12;
        Mon, 22 Feb 2021 13:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aQBvl0+wXZwGXAKmTjLqXckmi/r4IsAjAYtNcwuIvR4=;
        b=vDLdf241TL4qNeZd4kXovrEWF1oRpTlaF1HtdicB1zNSlcpxEO3zu4OcOUTv73OunE
         OvwAKLrj13duev+S+qz8F8cAjchysHsom2o160IBQgAhKbdkufvF6BrOiX2TK16Mtdbz
         mjhBVpJPGXP0konKKTtEkVDAM94UedPvDQcMvTtoltDjAw7raxgDdW7LvQMx05kPW8Ls
         YThLYy16p04PoIBZ581MqRuX6rpeZ8+os3KzbSCS7dJorSwjrzyjs/h/RmoQXDToK5a4
         zliRijEaqvFUMcV+OZLKFZTdTI8sthvtXdHeu5ziHbC70IF5hMVSlQJLwJP9V/9qO1U9
         joAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=aQBvl0+wXZwGXAKmTjLqXckmi/r4IsAjAYtNcwuIvR4=;
        b=Gqu8IX2IWhG5ix3AWdgKPXCHKUNPPuo8nA1h9UNW6KLFnJkpfP33IUET3UUmPfB6c3
         3L/SidslNQOe2ZhjeXXmQJesNiiKahU8OaQN3lG1h6YvS0ssVtmzd2j6WopiGMO61bWj
         Q67MMM5eMocECTa+1sj4WYa12JZPSaONVPpJVyGA7/LuuxNZkzUFslh7B7SXSDyuhhUJ
         Qd+NOTBkF8IpArwfiqpnT6+54oOecoiHEJdQApw8BQxfQ+ZrgphWmUXBH5XOTpEGsfYQ
         Kin0B3uQ7JNQ4yr35+tGqfcad9PJCZsrPqKKBdSdBEeI22gs1PhPLQYlYtdgPrr9QyND
         Fpcg==
X-Gm-Message-State: AOAM530U44sfTcWaRI2eQj1feoqAFaRNAeEdR7ZjHIoFlO8zsKlWua2y
        XrMVIwUMDrheERBu7HynI2o=
X-Google-Smtp-Source: ABdhPJzZW6RJXAnM/h1zjhKEC4hcAq55RUeLPw8FoQ2hiJkdVZPKssSo2EwLSJbZt/mWNMyDpDMgGA==
X-Received: by 2002:aca:ac56:: with SMTP id v83mr13767429oie.16.1614029337160;
        Mon, 22 Feb 2021 13:28:57 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y27sm3965113oix.37.2021.02.22.13.28.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Feb 2021 13:28:56 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Feb 2021 13:28:55 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/29] 5.10.18-rc1 review
Message-ID: <20210222212855.GF98612@roeck-us.net>
References: <20210222121019.444399883@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 01:12:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.18 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
