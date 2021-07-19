Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F6D3CEFA3
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 01:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354484AbhGSWTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 18:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359382AbhGSVUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 17:20:49 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701CBC0613BB;
        Mon, 19 Jul 2021 14:52:54 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id j4so3953570pgk.5;
        Mon, 19 Jul 2021 14:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=1pnGBLC+KDij1XcgXXZsWLjcMhsXMbFu9w83Bq0l4VI=;
        b=HH0el+jekR10ZOms5PRos59UbP76pLZERIOkFh2it7G05fSFn4cA+k9511we6eFcGV
         As4Bgd/N277uPBW/6dY5ouCervJp8MS9XT/+z1uPza6cd9+T8max3fcUqPN6981i8V/x
         uUR7ckwJmxYX3fxn0QNB6m+xyHZYHD6SE9ERL5BtjlFlXQA4ezzycPicVTW63hL3oU6J
         0fOKtmyZFIShzB1lEBWQt5RWAkHrvCGm6kTyZHCRfHI0vy3RPyD9v6dQ3x/3KzoEuIHZ
         QTQ69SPtE68tws0FJBZT4HxKWWvATAOQpejzSPYfsrexE0VjRsd6Ux9cAcXEbsRfXNvC
         F5KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=1pnGBLC+KDij1XcgXXZsWLjcMhsXMbFu9w83Bq0l4VI=;
        b=p0sg3ZvtDobVeeNooNxqs1cl7Meq++wQ+sRMSagkGSwqWDP+0NjEt+bmtDNQ/KDDzw
         cXEroJIi8Q2ZwCTpj97b8v9xp7AdfIhTDLmMdmlt6uyfnZmliC/vh7GCaHwAQ3SIrQQB
         dSh816mU1yJ0dwCR76LMWdFbeC+5YIsvdj7FoTXqrVdFJaWtYQOCkye8GY5GmCp96xcW
         Dryexb7gygRRsNsbMS8P/a31MmV8o+gQr8Wz8c57eRCrNiPSt5pmgrdv8V71B9/WfaoD
         kszIFJUM0Rfv+afLsOOLCjIjJHmobzicgAIQbAxhdqpzpt65rHrhmrbU20tQTgQFLTMb
         rX0w==
X-Gm-Message-State: AOAM5329ex38L+fOclyls+ZProLR5QrYpf7BHEF7rjQmks6g12rL9mQY
        /OJcPL5ZFBN1i3bTVDbS4NHlAijp5u5ktZBsrRs7Hg==
X-Google-Smtp-Source: ABdhPJz5YIjlCn2lVsFe1IMKNiFhWIE3eWNSzrbzyw73YIUkBCvHlyC9I+TDN9L34oBEMrscs3YYHw==
X-Received: by 2002:aa7:864c:0:b029:34d:afdd:e70e with SMTP id a12-20020aa7864c0000b029034dafdde70emr3263248pfo.9.1626731573323;
        Mon, 19 Jul 2021 14:52:53 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id l6sm23463268pgh.34.2021.07.19.14.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 14:52:52 -0700 (PDT)
Message-ID: <60f5f434.1c69fb81.e5f47.694c@mx.google.com>
Date:   Mon, 19 Jul 2021 14:52:52 -0700 (PDT)
X-Google-Original-Date: Mon, 19 Jul 2021 21:52:46 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210719183557.768945788@linuxfoundation.org>
Subject: RE: [PATCH 5.12 000/289] 5.12.19-rc2 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 20:36:26 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.19 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:35:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.19-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.19-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

