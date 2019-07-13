Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1569B67BF3
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 22:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfGMUm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 16:42:26 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46823 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbfGMUmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 16:42:23 -0400
Received: by mail-lj1-f194.google.com with SMTP id v24so12516012ljg.13
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 13:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CBzLom4tHppdt8DRCfwaeSYQ0/243oHzWemzH2okXPU=;
        b=ZqKaTXZXSYSMiKlFHQWoafVOu+q6ZDnwt9605aN/LXlIXZdh2IWGEkgV7I3yGjVoUI
         YHg5OaCIfN/8OJ1gzsa12opibzg7ITN/jLMRPdy4WYSQC8K7ZUiD/FkRAmHtq7Zovsmy
         Zqk7QN3odknVmaXxxtCTlPmzvtZ/CKJQqpjlg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CBzLom4tHppdt8DRCfwaeSYQ0/243oHzWemzH2okXPU=;
        b=GL3S67oGtur/4W2i9rFAXJjoBp309/ZZwjdKw4LkH2zMJcEngMYRnSFfdqC5KaxZG1
         EFAHNYAAB6udJx0vcl55jjDH3nRDTEaCz90ExeitgKLpmAmrT/WcCvHXAC94wE1xQcP8
         KufgiQH/gBmHiMaXEGBkICQEmOA3xUQx6mBtmQrDcKijEzc2l/jFmej2BKMSEwpJqgwV
         RVOFLQKfyKUb8/96AFHv9STn4aRxyOhWWUWJ2Txgqc4Y79Y1pzUIdxvUixfYkloEnY7j
         fCLyzaQPQIVC2rDHRnxLJy2Wrx4zkVWrskuTa7k78eWn/Oei1O3EEUtdqg8ENlTMGmgb
         IF8w==
X-Gm-Message-State: APjAAAW0yDk0HtLySzKmadFCc/47k+RPtoQdQq7JeRHGtApnJtNcM57l
        B+6LenE1nbX+poa35os8dsfBkw==
X-Google-Smtp-Source: APXvYqxufQ2IsrzZK01WY6PdL0Oo61/AwZTGVPocchwV5K5Yie3XbNFCgm+NeT9JsvXikS8P61twsA==
X-Received: by 2002:a05:651c:92:: with SMTP id 18mr782879ljq.35.1563050541671;
        Sat, 13 Jul 2019 13:42:21 -0700 (PDT)
Received: from luke-XPS-13 ([213.146.33.133])
        by smtp.gmail.com with ESMTPSA id d7sm1597793lfa.86.2019.07.13.13.42.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 13 Jul 2019 13:42:21 -0700 (PDT)
Date:   Sat, 13 Jul 2019 13:42:19 -0700
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/138] 5.1.18-stable review
Message-ID: <20190713204219.GC14762@luke-XPS-13>
References: <20190712121628.731888964@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 02:17:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.18 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on x86_64. No dmesg regressions.

Thanks, 

Luke
