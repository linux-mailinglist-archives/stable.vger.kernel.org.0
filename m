Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAA61B4E6F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 22:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgDVUgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 16:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgDVUgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 16:36:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A469C03C1A9;
        Wed, 22 Apr 2020 13:36:46 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a32so1432847pje.5;
        Wed, 22 Apr 2020 13:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Tp5JKfaToqqIW2zkMiFvVRjM2kIU4R3S3MSpUkg5j24=;
        b=SG47h4RL/PKOXwdGjP1taBzeygt5h58CbVzd8RMpLvfiZ5Dcd2V2YSUURkbFaY1AN+
         yLw06X68RZrGm2aIsuos4Ab3DYf2Ei7lUYr4VB/BVGaotoGzZ5i2Lm5IltivIBD6tQ8x
         sPs46y98yg1DQlAc4+wu1sqFZ+NRWbTUg51l5wWpT3jQsMpAWm685wRAQUtfKwSfzb5o
         ixGUl0iES2Ll+w0B1qK0mesi4bqmI7V7k356TYXjYj9XcFSJKLmQRahRSv/nYvVwL6Yl
         yasnOk3bSMRZIvgIYiMJ3nNe9U4pPiK1IQnTQZipwGZG/F8PerZwzIAKVLIrePjUPSeS
         i/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Tp5JKfaToqqIW2zkMiFvVRjM2kIU4R3S3MSpUkg5j24=;
        b=BteT+Gzb7Y98XRIY/HSoGvVnkAUOepRBlaFpc36YUTePhyOnsacCursI11aB5OJZBS
         CbK8+oCWxpnCT8EZDvY7sFNiYRuaxeDVJTh2fEc0hOch40OBXGPkWF6UBS3hY7JoT2Qd
         Fzf14JyK6XB6CdPvEYzIN/HlIGY75SfLXZPUKOkNcb/79DSUChn28xMtACl3ZX4ebWHA
         cjrOGrgQrOMao1/wtzdQKH9gYADntp3dVTE1Q31a9ugME1itTOr8l6GUb9Ef7p5bPXxB
         L6J61NtXr/dMI2H8Wfx9ryJV28eI3hAVBhKj5YlWW1vYL7zVgH7L1D/NJqbb8zq0vmri
         1Oeg==
X-Gm-Message-State: AGi0PuZkqCrcLZdGd8he3vyvrts17CF8AG9AU0VYH27kKNfo37rUchXj
        BdMs/7ZE8aLOguK3p5cT6KI=
X-Google-Smtp-Source: APiQypKq+hfANmGmbx55N1emufW6FlXjLARkgnSpkFyuz1/tUQ6Z1zIsBwIKH36yAS/ptE+h5j6Ayw==
X-Received: by 2002:a17:902:aa09:: with SMTP id be9mr434867plb.341.1587587805903;
        Wed, 22 Apr 2020 13:36:45 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d203sm368313pfd.79.2020.04.22.13.36.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Apr 2020 13:36:45 -0700 (PDT)
Date:   Wed, 22 Apr 2020 13:36:44 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/166] 5.6.7-rc1 review
Message-ID: <20200422203644.GD52250@roeck-us.net>
References: <20200422095047.669225321@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 11:55:27AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.7 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Guenter
