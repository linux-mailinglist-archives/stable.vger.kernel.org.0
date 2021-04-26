Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB75C36BAB8
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 22:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236419AbhDZUcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 16:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235996AbhDZUcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 16:32:15 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85679C061574;
        Mon, 26 Apr 2021 13:31:33 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id k128so30597260wmk.4;
        Mon, 26 Apr 2021 13:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yrkMIFTTF7Sx59P8sjJJQ3KD41MDwlg4vL7mJ7AwJ7I=;
        b=e4R6GMolxsmj+YDnoWMcMCx8/GGe2bUqjnhIccdSlLc6qpRNd+qpK+yqTL39Q6XoRe
         eHjpvyY32e1G+g3zx/uVXiwWbbCV1d9TTvovJbH1ypfmVuOriyxYW1rwzAE7LoCiMy0C
         OH0PkRWsg093O7Nyt50teq9Sq7lY6dRtCLa4ENqEq5EPXUc3R098w+zfOOBU9PXANSF+
         JqI27IxUqfGkqVxMHrjKIF09XMOx8xuyzxoGBt5p2EPbN6A2PCDCOydOGlskE9PLEQqO
         pbURRRG3DWHKpBuLrTthF9RgAO3DQpF78PvUYNFi9nnFKWdqM3fCFxw0GNIFcjeQ4rg0
         4NUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yrkMIFTTF7Sx59P8sjJJQ3KD41MDwlg4vL7mJ7AwJ7I=;
        b=luJ0fkhremKChRvx70sBXhpsMujHs2qeUExaXuU75x2ArcRUm3r29JDcBKwYCTylkH
         7xwASu3rApazj/IrlRuzjYebEMTs8qSXJiyBZ8RLQNgwpp1hR0Of7At1t8agH9cR1c8L
         V0YoG/iXhJ3wrP6DR+jDFh+wkjSMN12eJcrM1af+qpX0zUBEBoUF7dF5dpit4p/O3yGs
         /U5rZ6cCiHI0TQSbKVDmvSOB5Kiujp9iwGcpVdYZPLRJzrgywX1b2/rjgGBktxhlplbr
         S8pytTdDzSLZQE96f99nRYS7q9pcMYgZHiSNhLA8dMqtz0LLDLgA7tTC9m8yHsXFro4C
         V2Lw==
X-Gm-Message-State: AOAM530EjLO8OBKg6cK/NjJX/Rp6AWHHIeV+90hFAHaI/p7jcdkrHWd+
        33zHJX6HVLrKGdmJVzknQK8=
X-Google-Smtp-Source: ABdhPJwg5pHGmpWvoQ0+m5HnXZQ0tNJvIQC+dfpO3lb2unRLnjFsdyH1xBBJ/2wS1iCDLflZFgl37A==
X-Received: by 2002:a05:600c:4896:: with SMTP id j22mr731011wmp.156.1619469092199;
        Mon, 26 Apr 2021 13:31:32 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id o27sm1715915wra.4.2021.04.26.13.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 13:31:31 -0700 (PDT)
Date:   Mon, 26 Apr 2021 21:31:29 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/20] 5.4.115-rc1 review
Message-ID: <YIcjIcdEJUNIQt1c@debian>
References: <20210426072816.686976183@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426072816.686976183@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 26, 2021 at 09:29:51AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.115 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 10.3.1 20210419): 65 configs -> no new failure
arm (gcc version 10.3.1 20210419): 107 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm: Booted on rpi3b. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
