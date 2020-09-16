Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2826026CC20
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 22:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIPUj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 16:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgIPRGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 13:06:48 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BF7C0698D0;
        Wed, 16 Sep 2020 10:06:39 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id u25so7356511otq.6;
        Wed, 16 Sep 2020 10:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SF9voxU64z1pyZcrMFE+ap4wxWaAPRKw46Uhy3wwL6s=;
        b=fatBCrZhVMhXB5v+8znmZjQTUMq+BYZoYOIrpoMyY1dkNPxplhcP4hgu06GowR97dJ
         aP6fVNwlGqyk2Ln0FIrlgHAlETGSQHA+Vmh+laESxYS8I1lVzbIGFTV4IMkt0oi09iBC
         zNx5LupI+BL5vHwu6iMgB2zboFrt10GIT9i3CopOrqK9Hde4WHS4rcll6b6JKa5/tUHX
         lfjG+hpZG222eEik70CAQ+v6vnt4WI9k2ae1yqjR6Y2uiylNaio45gjq1Y8obp7HpS4Z
         qxIFOy73ZcLy6rqbMUVuVOBIbjyQ2QyvaYWq/3g2Wf4p3JZZGJI+fRU3o/dC555FH+De
         xxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=SF9voxU64z1pyZcrMFE+ap4wxWaAPRKw46Uhy3wwL6s=;
        b=nDVOO3PEy+DzWjC/y1pWz8H2RopYuuSu2f3ohsvLgmVHpBwIHIOUgq6Z+7ENH979JM
         kmp7ofkly6n+S7CTrsQtD15tqWq2mmEGP+NtXu1l+mvkxZJ7IV/YPkQV2KC629ancHwn
         vnyq4CQHL61rUMhTzavnxVfbIRz9PjQ4BgTlRmIyhalctmgolOu5vrTAXlIv8JdxrMfS
         aMFa8cZDNJtfHgF6QC6iwHKrj63lRVmuynzSy5iUzi7zVJ1h8TYoTntz42VG2SLRRqI+
         39ZoDK2o1PBd6ToFAcL1FR0f9tQBIxxUGbjF4UPwLisI+RsD3omFDsdaMUQ4yYsiKOri
         58Ng==
X-Gm-Message-State: AOAM530dOy/Zs1RF7BR4hpXwI7LJY0w372143EjmmZjTJuQSEdbUxFSJ
        lqAY0L3p4e4mCndu0M/YCUJrwr3W0Vs=
X-Google-Smtp-Source: ABdhPJyBEVI4n4fE1Xk6ru73Cr/hJKqwDOaacxkYkAQZ6wTW86rG3kmtgV6zCrcZZZ0Lv2+OrCDtwQ==
X-Received: by 2002:a05:6830:1be7:: with SMTP id k7mr17284343otb.162.1600275999375;
        Wed, 16 Sep 2020 10:06:39 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 34sm8636012otg.23.2020.09.16.10.06.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Sep 2020 10:06:39 -0700 (PDT)
Date:   Wed, 16 Sep 2020 10:06:37 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/177] 5.8.10-rc1 review
Message-ID: <20200916170637.GC93678@roeck-us.net>
References: <20200915140653.610388773@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 04:11:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.10 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
