Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECC41BE01A
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 16:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgD2OFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 10:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726974AbgD2OFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 10:05:19 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D92C03C1AD;
        Wed, 29 Apr 2020 07:05:19 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s8so1076581pgq.1;
        Wed, 29 Apr 2020 07:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DEEpUHKbo7+1Jkg/OAyp8ExogsjgJ/bJ72CGCkCrCE0=;
        b=hojnsxk5cbkCgTm3gD/55r9/8hJ28O0FLE/vFz2iLSLJ1H6ogulPbjhhpOtaOEMjbI
         Z3DUJmzXjAXxDJZJHDtgNkeYWB9cB/TWbrmolOa6Uaa4pi1+vGCcM/1xJMwmaoi/zicT
         d/SNu6msOZ3t3Df/Vv9JliwzM2JwZiEscGBa1wqr1SpUXfUA/6fROgKPJKyXT0Tsez1a
         M7aBNa+NSNFihQy5P/Aej5FyOqrod64RFEY/EQblc3jemlA1y38hnu5YOdEv9dPb0ejE
         0pPf/TUmbdC6qNiaJhm6kBIzjw8JfSh4b6FM5DE1EZ5FT6ffuquIdW+R/SB+OsrdfVJq
         wccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=DEEpUHKbo7+1Jkg/OAyp8ExogsjgJ/bJ72CGCkCrCE0=;
        b=SyoeRrZsDbhxAbYChXkP3hIKBBO3X9fEiShfJYkaqTafA/ngvecu1H+x/A2h4/U1tQ
         ugAMd6O/glVpa0bFjLts/zOliFfRcQmSWhy4lpUTVKNEwJXNqU6MqOUN6S9HwoLkg40L
         eehxlAbJYtLsFvpu+XoAvNm2prkNLudyAGT00Lts/uTIthEHaHqUHO/xoeTZZFXGDXNC
         aMUK62tVkzeuvMCHnNJ7ayX21EwHHC6hYFKRFwV6r6um4DzyQOk0QTDY9ZX7GqU5+86J
         JydNTrI8g+OJdxW5BaQvRSMkwP1qVV2Ea1LiN4ULss6pz5pDI+xowNi0DNKkjX/CgsSJ
         BJMQ==
X-Gm-Message-State: AGi0PubafkG8DaRGM3m+VXT4fZCnIXXbG+GbNKw2it+I1sHl3vpAQn4N
        mPWYpAeFHVB3ipVW5Hwzvr0=
X-Google-Smtp-Source: APiQypIRAYOyUORLHBZdVDtC1XhW4R0C2iplDIjrREc+muriFRYeclTHLM4vfvRbYJPILxgxAJeLhA==
X-Received: by 2002:a63:ac57:: with SMTP id z23mr14791709pgn.423.1588169119086;
        Wed, 29 Apr 2020 07:05:19 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a2sm1214038pfg.106.2020.04.29.07.05.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Apr 2020 07:05:18 -0700 (PDT)
Date:   Wed, 29 Apr 2020 07:05:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/168] 5.4.36-rc1 review
Message-ID: <20200429140517.GB8469@roeck-us.net>
References: <20200428182231.704304409@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 28, 2020 at 08:22:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.36 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Apr 2020 18:21:07 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Guenter
