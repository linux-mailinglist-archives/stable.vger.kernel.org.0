Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017DA484C2D
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 02:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbiAEBib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 20:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbiAEBi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 20:38:29 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647DDC061761;
        Tue,  4 Jan 2022 17:38:29 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id s21-20020a05683004d500b0058f585672efso44578503otd.3;
        Tue, 04 Jan 2022 17:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kUyABkq9/qYVEJb0lbNqZwMe7iEYAWc1hkErURx3Yq8=;
        b=MmBEbztCT8PULxQlAOzMqgMUVXbT7ZRnORivHo5UAWnt5r02fr1gvwnDTDg29bQg3g
         bQX8KS2lT/Z6lCUc0RwRPt4S/Fs6pIODPtEC0FCyolZ3iweV7iCNCoxl6eYuS+Jm+Bcu
         BKMpCJhpLDDLCOvOwZddsn0KxL4LQcbBoAcwVEuzCDYlUBkeiFrNDoxjCwPyWcNpEX3w
         g/jhC/caxDy7rweTncbe6Bn/BsC3zD02SCzHx0ItrzsienPbqbnyA9rWcCDmdzqk6jlz
         GaB8Yoey0T28lIHkEgEBNs9JUBZC52sBEDRrxWHHvGQhmSiEN7mrGafKCS3PDHwykvPE
         PWfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=kUyABkq9/qYVEJb0lbNqZwMe7iEYAWc1hkErURx3Yq8=;
        b=VxF/2Iyp8eg9LQdzBdxYsTKGuy/X7SmBA86TKa9tlhcSPi79AAbliQC9T8y5qeeKFJ
         5LX6o5ya+EEFACNS+v1QcTlvowYt9EW0pG7EgCoifovHQzFU3fDBbTitsNSuMayEjoMI
         iiiOLi4goRS2yDNkjrsOeQCaOIAPHr/a9tYd75vj3y7uVOIz45rmC8lMLsZiDGHHrmEA
         qE1wPJXRTOj0zUI73+0tYbuQzlGZR4dlh6A8Ie03lLSxvXcehj8mNsPSgwGnRMc3YfQ/
         CTpv0B/JOVftenZkm3MnhNmsvjM3Dy1kGSJREv6uja87/uV64q6uQPuVs53qiCIkMK/h
         PnLg==
X-Gm-Message-State: AOAM533tIfNbS9Ilp8Ut1aCPE0CsoQNmG+H54dWNMge2sql/swQTMahv
        9/adrbUTVzxup4a5uB4K2mT7+T9o+lI=
X-Google-Smtp-Source: ABdhPJx9LeXNRFlyW/ULRFQ0tqIGUKUc3vQQBY+gCkpZngCkZb2Y4rgDCQSSTJZvBhzIvokD08+iaQ==
X-Received: by 2002:a05:6830:2b25:: with SMTP id l37mr38018390otv.298.1641346708535;
        Tue, 04 Jan 2022 17:38:28 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w10sm8673211ott.46.2022.01.04.17.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 17:38:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 4 Jan 2022 17:38:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/47] 5.10.90-rc2 review
Message-ID: <20220105013826.GA2893211@roeck-us.net>
References: <20220104073841.681360658@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104073841.681360658@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 04, 2022 at 08:41:05AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.90 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
