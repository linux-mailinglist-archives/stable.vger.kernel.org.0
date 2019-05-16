Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B04E5210B2
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 00:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfEPWr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 18:47:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37553 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbfEPWr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 18:47:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id g3so2603966pfi.4
        for <stable@vger.kernel.org>; Thu, 16 May 2019 15:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ClyRR3xF+6k+e4O73jcWzYdi+cDXlpCTB+70QdFxP5E=;
        b=nh/TXYLZxXR8swyGizL/Ubk9TntErZ/LuRKKRmi3y9Xlf5f9WyYiRPn7DNX82aXjPi
         dNLBdZJcHhZkCTol2lPAa2O41Vsu+ODryei4G+WmxolBrJAq3YZnGvuXlb9oLvQ8Xbsl
         dl4YhD+Kb1oX/kZVi0UZloj7wJR50qv+uQLOyZN8K4JATr2TJsqvy2LHP4qae3eFM+3L
         GhcMsanqX/Pqq1LMduxRz5buN0smq5NoQBmtpYCS9Moo8ZPCBFb/pXmxKBO5IgEWQjWT
         ZobaPC7J5BbDl+uR+jPEbVbXy/Ijq/gU3aOe7exQUIW7HZSg4ZkZ5mDa5oAwtjuS8KsE
         trjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ClyRR3xF+6k+e4O73jcWzYdi+cDXlpCTB+70QdFxP5E=;
        b=hYouyzb4J4sgchPled8g4OGit6xj7bhFMIeViWsqvxwHniDgkeL6NmsOy7/zGKmL5U
         /Zz88kxzCXCHhXQoXVVFGZoLu48bJaPiy/BARW69c5GVsKMnBArbbxkkWR+iYV1duu23
         UddBxFDxrXddj2Du9sTEBQsQZP/aO941NtEoIK/Vh4t0s18amLpCk0GTRrbNb4YBAo1y
         M5WqZp8CgbCZ2B5VNlmVohLVg6/vlZLFHA79rTG+bIz3AygMGurq5Gif3m5hOag2FMWX
         l1Tls0PJgrUDxuu/dlWP5RGJ+CBs+L8akJ729PQ9FmKg0g7qvHX1AnWaX4DN3t4WIy3m
         j3vQ==
X-Gm-Message-State: APjAAAXgdVKPJB5nxnds+dDENaQ/EvFEwMVVpZFzzuwL2vBplVBytoAP
        /K03aCR5IyRfoS2CAyaW0Y62BQ==
X-Google-Smtp-Source: APXvYqwsB54b3xfi7QnhOhG/Zxm3b28yU+b7dCUTMJNmc6Tx+8DkJ6jZn/TKl+2/5FxbAZrXcF8IXQ==
X-Received: by 2002:a63:903:: with SMTP id 3mr40813537pgj.400.1558046847139;
        Thu, 16 May 2019 15:47:27 -0700 (PDT)
Received: from localhost ([2601:602:9200:a1a5:20fc:89b:acbc:4e17])
        by smtp.googlemail.com with ESMTPSA id h26sm5863566pgh.26.2019.05.16.15.47.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 May 2019 15:47:26 -0700 (PDT)
From:   Kevin Hilman <khilman@baylibre.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kernelci.org bot" <bot@kernelci.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/266] 4.4.180-stable review
In-Reply-To: <20190515151307.GA23599@kroah.com>
References: <20190515090722.696531131@linuxfoundation.org> <5cdc2691.1c69fb81.bd8d8.7247@mx.google.com> <20190515151307.GA23599@kroah.com>
Date:   Thu, 16 May 2019 15:47:25 -0700
Message-ID: <7h1s0y9fuq.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Wed, May 15, 2019 at 07:47:45AM -0700, kernelci.org bot wrote:
>> stable-rc/linux-4.4.y boot: 98 boots: 1 failed, 92 passed with 3 offline, 1 untried/unknown, 1 conflict (v4.4.179-267-gbe756dada5b7)
>> 
>> Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux-4.4.y/kernel/v4.4.179-267-gbe756dada5b7/
>> Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y/kernel/v4.4.179-267-gbe756dada5b7/
>> 
>> Tree: stable-rc
>> Branch: linux-4.4.y
>> Git Describe: v4.4.179-267-gbe756dada5b7
>> Git Commit: be756dada5b771fe51be37a77ad0bdfba543fdae
>> Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>> Tested: 44 unique boards, 21 SoC families, 14 builds out of 190
>> 
>> Boot Regressions Detected:
>> 
>> arm:
>> 
>>     omap2plus_defconfig:
>>         gcc-8:
>>           omap4-panda:
>>               lab-baylibre: new failure (last pass: v4.4.179-254-gce69be0d452a)
>
> Odd, is this specific to this release?

No, looks like a lab-specific hiccup.

A little bit further down in the original report (I know, not a useful
place for it) was this:

> Conflicting Boot Failure Detected: (These likely are not failures as other labs are reporting PASS. Needs review.)
>  
> arm:
>     omap2plus_defconfig:
> 	omap4-panda:
> 	    lab-baylibre: FAIL (gcc-8)
>	    lab-baylibre-seattle: PASS (gcc-8)

which means the same board passed in one lab, but not the other,
suggesting something.

This is a bug in our email reports.  Regressions should not be reported
whene there are conflicting results from labs.

Kevin
