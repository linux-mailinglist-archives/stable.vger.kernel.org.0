Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4711B2285E3
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 18:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgGUQic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 12:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728042AbgGUQib (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 12:38:31 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586BDC061794;
        Tue, 21 Jul 2020 09:38:31 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id m22so12171051pgv.9;
        Tue, 21 Jul 2020 09:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3zclBSwIH8/ORQuSs/LBiK3MDBn+SGJt2o1o71dDmMs=;
        b=mfmtE3X/e/QHM0eJ99PhJ4ioRBRM47x1pKhHZJiPaSJQYNYevkHkz/V6d1+Jgu92vE
         NP+bdAtBE/7h89QnBLZczz5dk9z+fIKuoCDVO+WNvED6sPx986JQQDEmvIkV3gPQB8C3
         HjlLvX8VT6kfwHVP/7pFk2FuqcK3sOEkSva9L2hNT4scZIaS24M0kI0yVcbTVdH875oR
         JR/HlMfEo5pbl0cRs28haeVVBMZP9uOCAA34VNON46GWX2CfTWXLAsqSPUcsbSxz/UKP
         n2DHkh2NfJxLR6WzyNkEJVK9B6efHygB3lr4aZ/ltfHq2W5UqBhud1zBMPl8yNAmhPG/
         9rwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=3zclBSwIH8/ORQuSs/LBiK3MDBn+SGJt2o1o71dDmMs=;
        b=fB6Y6L4/+nzogYm7X4qdT1OtDIqykoNYVTc+7wCqTXMjkYgD8W+NIrWOlI8VmhXDvL
         w8IB87oI/ulUwWI9mLQaTRb1Jcrb9xKs/D8MYPNpb+iZdNzJrQDsW9surK2mAAw4EcQG
         kvwYDEUcSR0Bkyw191/HfedRsTexAH3bnYjwe4ys/WLRzEXXEoaB62f+iSx2HAO4CUrJ
         nE3VBxo7n0icweN8MHhtn7pnmDKcV43QyFTL+naKGlNE8ObZnJsmxgF+kfvQpwTFttsg
         YlHTrkb5r4MyW4xigDzOTxZ0C03FtxI2DiQyAAUqxjFwfZMrkCiNs7Eg8Q1Jj6OiMcyy
         PiyA==
X-Gm-Message-State: AOAM531+ZG6RFfh4AelNY+lSPE7NYJa9wKJYr2O8BLUmFW//AUQRatqI
        F9fYIDDEf3+Ak+U1Ough54w=
X-Google-Smtp-Source: ABdhPJw1P36bnr2V1Rj+sIOYl3oUWY3Bcgw/DhWVjPbqd3R6gcM51bhnBUY9DJgj7zX8NRiGMq3Cug==
X-Received: by 2002:a62:8489:: with SMTP id k131mr25373166pfd.4.1595349510919;
        Tue, 21 Jul 2020 09:38:30 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d37sm18355646pgd.18.2020.07.21.09.38.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Jul 2020 09:38:30 -0700 (PDT)
Date:   Tue, 21 Jul 2020 09:38:29 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/243] 5.7.10-rc2 review
Message-ID: <20200721163829.GF239562@roeck-us.net>
References: <20200720191523.845282610@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720191523.845282610@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 09:16:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.10 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jul 2020 19:14:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
