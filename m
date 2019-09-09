Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC487ADF96
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 21:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbfIITn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 15:43:26 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32802 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730465AbfIITn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 15:43:26 -0400
Received: by mail-pg1-f195.google.com with SMTP id n190so8419430pgn.0;
        Mon, 09 Sep 2019 12:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BwjnaJdx1SiBo+TheuZxiJ5csvHPGuBQdHlcmoRVupA=;
        b=RO9JUHGH08g7kphsZqDsJiwVexYWyk0Jl3UEv0gh5DgcTSsYMxIAWs5cxW1cde3LEj
         7QE626YKytXLOJkDYGfb8VH0dYih5MMCL9A/vr85PFy/vWwiD6DtpBFPUQXats7XPrFJ
         ATWTbzmmx1MKfhSL6E7x5mklV7nvQLDiujZ8KOpM719kj080ffPE6P9KWbyexo9KmuJP
         FuEG6lpgePaAxgTLC9+q5V39cdWmgS5hAFzmDChoOTSOyn4Tdoeuu9kJENXweBqoGTcE
         rtXIDp36aBSjIv9bGC6Iq0I+aucrMsWcg9B/01DUElP0OqkFq58oUvjLTlWOHs3TXeap
         4uTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=BwjnaJdx1SiBo+TheuZxiJ5csvHPGuBQdHlcmoRVupA=;
        b=ii/5ZHbdoZN2wp20FaHFtd7Ug8PV+/MDUISZ9HiauD/YOqj1F2izeWaNCdaUdFMzl2
         TTexPFJzulsc8/LbVRMUaC3aTb+5sWSaUhZ39nw6dFywqNDGMosTuf0SGKeHc4+9BG/F
         gPOXKJ9mD9EOhLG3uF9jHq8f+Gagj1JGcdBM2AvKWx55zYHtxCWqRj9dsGHlrNdsCN8V
         ymbB2ng5QsOuTPa50q/Wmny22G4bWk4qtjnqUgA8YCLTpo9HjHNAviZ8ie34ayGfD1sz
         4JryQ7jUs0etXPIOUY7WpsPw/quIZGPPa0xxm9MShvc5aADvhdyBoMDwfsaoo9NB0srV
         T01g==
X-Gm-Message-State: APjAAAX1Z5f2AaWd2FmgsO6JU2p2pAlGqeLrO4YmfFWx3o11tOEvAdh5
        hMTHa/UHTDbffSigaOrMntKys/O+
X-Google-Smtp-Source: APXvYqxGUMv+2lJQK0/VGme9C7n17h0qJIAIz8Qvo5PPCOUgfrC4v6Ewqz4ZYEKgAklxZTAsgW6gVQ==
X-Received: by 2002:a63:ee08:: with SMTP id e8mr23811185pgi.70.1568058204822;
        Mon, 09 Sep 2019 12:43:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o19sm355690pjr.23.2019.09.09.12.43.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 12:43:24 -0700 (PDT)
Date:   Mon, 9 Sep 2019 12:43:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/26] 4.9.192-stable review
Message-ID: <20190909194323.GE22633@roeck-us.net>
References: <20190908121057.216802689@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190908121057.216802689@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 08, 2019 at 01:41:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.192 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
