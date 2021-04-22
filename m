Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A253680FA
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 14:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbhDVNAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 09:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236363AbhDVNAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 09:00:09 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7E1C06138B
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 05:59:34 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h4so35665387wrt.12
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 05:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8/KGFnryAMctn88NFbO1ivk8J+24Ebdlr0KrvWJNTF4=;
        b=LTsH5gXGyubkKcVYB8Ynk7SMn7nxBV4yszikxczHPdXwJz2bxhsfIHZN52OTMrfRg2
         bEKIiiJnx48IpL8ja52SlvcFs0ltkVhGGyB85N7P4RyjdCsQpL84V6u/h/aAiZkEnTZc
         R0SxmGFhg95qsW96dsZAOrvIyMGrHOBsNYh7sbV0RMeliifMd3nzpITHmZLrSzucSu3Q
         seBDkvYcPARRkZiwiLzbQlIGvlI743WT0GaOlIKQus4q9Yj997OznifHUATtMpyeTYWl
         gUz4CM3Ndl0M9joGzDeJkFPNklowzwJKAb7aV/pFhvBP5n+RdZZpQaXU3rHgII/2drcm
         wQCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8/KGFnryAMctn88NFbO1ivk8J+24Ebdlr0KrvWJNTF4=;
        b=hhyPjeNtCky7dGds59lIsNgHUdq8y0khoy91PJodQPniz2kSIcd3o7wVQdR5N+Zkr8
         YwnXVYP5WG4LlXksmdO9tzSlDkkJclnyHUSKAEspfiz8o3QZnVoVqSszw7s3CojtSKHz
         7yepuJ9d2XVW1+wvFKAir/pH+celDvxozq/dzEQfLboj2S5g2cpICVkUIoNoRCaQxlXH
         2dmAeYW+zkDXXt2uEvOWtrtq7XNKEiVwt62xkT3Xo//qcE/akx5zOe33u/N0D9Zo4CmY
         QAnvKD8UbXJWZ9+7GWQ47/N7iCaxn8dvlwY4UsG/rV1YAfMfZ4WMX29XIJRrG+J/otU3
         DHiQ==
X-Gm-Message-State: AOAM531hOSQB5fJCJaWpoYDlCR5MB6vtAxD529l4j7A+nCdvcT7znOk4
        qA5TG0aSm95a4qHAdFjQRQgIxxIRIaw1Vg==
X-Google-Smtp-Source: ABdhPJwga1KoquWBDh8puv2zY37IP/IsmTxlR9E3qbmX6e6wIHa7F35Xq2GPHqGBcuhHDmMnxBw8Eg==
X-Received: by 2002:adf:e50d:: with SMTP id j13mr3993488wrm.80.1619096373378;
        Thu, 22 Apr 2021 05:59:33 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id q7sm3518275wrr.62.2021.04.22.05.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 05:59:32 -0700 (PDT)
Date:   Thu, 22 Apr 2021 12:59:30 +0000
From:   Quentin Perret <qperret@google.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Android Kernel Team <kernel-team@android.com>,
        Architecture Mailman List <boot-architecture@lists.linaro.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [v5.4 stable] arm: stm32: Regression observed on "no-map"
 reserved memory region
Message-ID: <YIFzMkW+tXonTf0K@google.com>
References: <4a4734d6-49df-677b-71d3-b926c44d89a9@foss.st.com>
 <CAL_JsqKGG8E9Y53+az+5qAOOGiZRAA-aD-1tKB-hcOp+m3CJYw@mail.gmail.com>
 <001f8550-b625-17d2-85a6-98a483557c70@foss.st.com>
 <CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com>
 <CAMj1kXE2Mgr9CsAMnKXff+96xhDaE5OLeNhypHvpN815vZGZhQ@mail.gmail.com>
 <d7f9607a-9fcb-7ba2-6e39-03030da2deb0@gmail.com>
 <YH/ixPnHMxNo08mJ@google.com>
 <cc8f96a4-6c85-b869-d3cf-5dc543982054@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc8f96a4-6c85-b869-d3cf-5dc543982054@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday 21 Apr 2021 at 07:33:52 (-0700), Florian Fainelli wrote:
> It is not, otherwise I would have noticed earlier, can you try the same
> thing that happens on my platform with a reserved region (without
> no-map) adjacent to a reserved region with 'no-map'?

I just tried, but still no luck. FTR, I tried to reproduce your setup
with the following DT:

        memory@40000000 {
                reg = <0x00 0x40000000 0x01 0x00>;
                device_type = "memory";
        };

        reserved-memory {
                #address-cells = <2>;
                #size-cells = <2>;
                ranges;

                foo@fdfff000{
                        reg = <0x00 0xfdfff000 0x0 0x1000>;
                };
                bar@fe000000{
                        reg = <0x00 0xfe000000 0x0 0x2000000>;
                        no-map;
                };
        };

And with 5.4.102 and 5.10.31 I get the following in /proc/iomem

<...>
40000000-fdffffff : System RAM
  40080000-412cffff : Kernel code
  412d0000-417affff : reserved
  417b0000-419f8fff : Kernel data
  48000000-48008fff : reserved
  f7c00000-fdbfffff : reserved
  fdfff000-fdffffff : reserved
fe000000-ffffffff : reserved
100000000-13fffffff : System RAM
<...>

which looks about right. I'll keep trying a few other things.

Thanks,
Quentin
