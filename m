Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67403A1D12
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhFISuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 14:50:18 -0400
Received: from mail-oo1-f42.google.com ([209.85.161.42]:35715 "EHLO
        mail-oo1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhFISuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 14:50:18 -0400
Received: by mail-oo1-f42.google.com with SMTP id s20-20020a4ae9940000b02902072d5df239so6147385ood.2;
        Wed, 09 Jun 2021 11:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IZx127GlI20GyKP96HyFJU7aq/mdY4bw2Bbp6MlrfXI=;
        b=C8FK4GRJqvqwkhdnJ6B2hU+8mDa0laOOQ6z3cclF2Hegiq6ZJH1qDc0t3vLnq2DHJo
         BgybA0SqLLUaR/B//58DUh65Wy7K8BjbIiaO5U9GY/RmmpjLjW/bjeimcymGqcQNm04Y
         1rvv8NOqJ6zNE5qwgQwDTDnHOZfdBl/+18f3cnWinW1sUbhriLSTPe2MG0IY5Dfo8lKx
         WrG4GyF0BlIQ3JtmcSWJ9S2Y/O/GxUTPE7fHZJ5AgLB3vhYZZnAms4cJGOiqejJrEil+
         Xw1joUrurNUQEvzw/bsR+P/2MjhfzF3m9pnLkj4xbJQ9c2S/DiOu7AR14nSHh69hqSRK
         wd/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=IZx127GlI20GyKP96HyFJU7aq/mdY4bw2Bbp6MlrfXI=;
        b=pHRoPV/Y9NBHEt94Qq/NCT3bmntnCUL+MnRV+L6eKPPDyXFuvRkojfnGJVnWCBlztf
         ZtDrboofmV25Gdx8lO8ZWfdHf3okTiNB1heG6NCEHrjzzxEkcJaH1aFutSIfW2zCzdHJ
         MVo1VCmtZhVBk2zQZRU9guzNGXz2PB0+N0rCIyszU0k/0i8wO4CpOXqkLD9lrIwWeA/I
         u4zTdBIRuwSw7biWyskUt1O/ayNA6+6e/iblZIPAiDtyqSlRIMM/Rt3a5hKQQPbdPkLV
         R3wL/WPGsd1vsTBg//vv7ocKrFt21evV7n57f/qrP8LHFW9K01NfuedrKpyKR7vM4/04
         aSwg==
X-Gm-Message-State: AOAM532titMsgkS7jm2hMKxEBfDBFFHMG60eShhB/GTJTYFIS5jlBabL
        XMpR8TSSAlGQlSIjsnLgKSM=
X-Google-Smtp-Source: ABdhPJyVa9gFRveBzQ76a9VFkDSKKbT4ApVQIK3KETF7LLqIt/Im8fnS2Vm9HAmst14qPvlUbVCnxg==
X-Received: by 2002:a4a:d41a:: with SMTP id n26mr1129188oos.66.1623264443164;
        Wed, 09 Jun 2021 11:47:23 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l128sm121886oif.16.2021.06.09.11.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:47:22 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 9 Jun 2021 11:47:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/23] 4.4.272-rc1 review
Message-ID: <20210609184721.GA2531680@roeck-us.net>
References: <20210608175926.524658689@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608175926.524658689@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 08:26:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.272 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 326 pass: 326 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
