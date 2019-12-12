Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E930211C6CA
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 09:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbfLLIF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 03:05:26 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:41927 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728153AbfLLIF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 03:05:26 -0500
Received: by mail-pj1-f67.google.com with SMTP id ca19so687695pjb.8
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 00:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fp5LYGJKEkfg5yRhHzvHzf1OfDrIgPebJ2E+jZMHJ24=;
        b=hTdYUuX/LFg7Pd3ilOvSYz4/ctywOUxqVSTtzhmLSq780UIf98CB3GtH7Uwu3bnbvh
         DITwUpWZIs0dn/iUvBgQBpCaL64gO92pHN0XqOeyR9dJsic2Rq8t9qMnPzHPWyX0Mxp+
         s/kD0cxw6ZazoIexIu/KZ9cozucV2BUUhG+01SqZrrpte46ijpJvLGK34Re47P9lQQzw
         QIHUNEVGMJ7/XO7ZlWvS9a4R2E6sCFylFiUV/HyCyyIni4Nb4edEXTqWdkslx7lxvdAT
         ZEjJI3iVhdmuAfbERpo3BvtwcBywWWHqI4qRDgan0odwXbfVYlSZWsFCDdH0vfxTj7r+
         EjAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fp5LYGJKEkfg5yRhHzvHzf1OfDrIgPebJ2E+jZMHJ24=;
        b=aETW8UMaXMYGHPKjUzHfCVWtUSeOyYhhu5jmgQRv1H73z5fLwVzD0ifCq/NOdBitKC
         dapI5+oGwnwjn+NQPUKo9JO6cIypk7SkOLFb++VkhbmyaQN9/ffCMIhjGAz1rVba+dr8
         0Hs1dvrr+ZJfW65x0jOO2M6Uz2QqPsjHdnQsIN5LVDroulEFdLz7TB2Lp8+5awsDS9VZ
         1g6xzXkZndmB1eIXE2VGV8t//eJsoPF8ANq9UItwng1OWMZ1pwo3MWzbaSn6NGPQZURl
         uvdWsXCyHA4UlM/MuneQ/+7C/0596VscQCXY+J5B13C21uPoRGSKu9t+SyIeCrU0EUS6
         5gvA==
X-Gm-Message-State: APjAAAUG8HzdtUV5iv8No0Lmy3bMUlqsZ0lbIj+8bC4u0qfk8EnWP2BH
        kjLPbP6/gUmXThQEX1eHJRsXIw==
X-Google-Smtp-Source: APXvYqzgtaUqbQwoRjMvL+XzEm1CG7mK1gKpaRv8+pqOZ54pcrwGWB4YlSELs5ekSKZbvnw0qJXgQw==
X-Received: by 2002:a17:902:7797:: with SMTP id o23mr8079385pll.149.1576137925667;
        Thu, 12 Dec 2019 00:05:25 -0800 (PST)
Received: from debian ([122.174.90.102])
        by smtp.gmail.com with ESMTPSA id 83sm5739611pgh.12.2019.12.12.00.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 00:05:24 -0800 (PST)
Date:   Thu, 12 Dec 2019 13:35:18 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.3 000/105] 5.3.16-stable review
Message-ID: <20191212080518.GA2657@debian>
References: <20191211150221.153659747@linuxfoundation.org>
 <20191212065214.GA3747@debian>
 <20191212074124.GA1368279@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212074124.GA1368279@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 08:41:24AM +0100, Greg Kroah-Hartman wrote:
> Are these things new to this release, or have they always been there?
Normally these are not new things. it has been there.

--
software engineer
rajagiri school of engineering and technology


