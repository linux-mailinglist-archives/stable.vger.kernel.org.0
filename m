Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D097A4FDDF9
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 13:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351765AbiDLLob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 07:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349823AbiDLLli (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 07:41:38 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDED5047A
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 03:23:24 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id c7so27105208wrd.0
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 03:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PWMqY36PdhLmPkOzVF3q3fwHeKiOtTKe2AjxmCLE4AM=;
        b=rxPkFbXFz9aCNjSPQJCPwsRgNusOv6QOeU6kHeI7J2jLUpfCOO7NPqnM6zMHlWJPlf
         c1flepjryToeCDaC4JFADEtJTlrVPVeJkLG4Un7QDQFozlTM4ojPUd7Qy7AV7Nnmg7VR
         o6aMqa6PuHkNAywHEzkjenaw5mFQCqftxZVV7QphwAB4tIuB7lE+D/8nVP1xT8t/c2gE
         S+UWahfMmnDhXFy8IAYIU+k/SBFRn8N1iRznqKcBa3s/5mKo4812cUFjYTQdXHQWZpks
         t5jejttpdawk3BTjhZouX1n+M8NeHYQ2aaGiBC/i0pijXEDRINDJ3stJYWMU9svnI6xy
         mNEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PWMqY36PdhLmPkOzVF3q3fwHeKiOtTKe2AjxmCLE4AM=;
        b=54y/WLlSvxyBK312ICzw/GcuAhu/QwxyayHNadZXUB0PEMXpYlKHwaZA/3D1XT9/S7
         FvSwC97qs5jVCcmzZ7vEWQPI9D8a6lDz2AZvGXfH7COg1jVr5VqQOTtI8nPqJafw4Lv3
         N0XgY67ZP9vLbnudsdKqJmj/ks2K+EQizmZngwjz4ySGJaMmPldUu9qYx+DqS7JoSwOr
         +DpQ0+z0G3p84qbeVEYY8EKaFyCARgj5aiTNK7PUzMFoAUO9W1Y4flaLzccL0e0C2ky0
         4V7IsjleG50jXrIqsdYFuQJ8lARLhV4M62XJhg4Qwlitav/o+sWP2M7q6GztUmv56cLj
         jk/Q==
X-Gm-Message-State: AOAM531+nfTLMtJAT7Adg8wNwt+sxow8UnNTos6fYGS+MqHt5Mrzu09Y
        0kos4e27drAPmT1ijT8F7CnzOQ==
X-Google-Smtp-Source: ABdhPJyU87YmXxLZxW7oXhFtjM8IEwsiPrNqUd6sNpFKh9QYGd776pDXXzthW10OfB72M9oSz7/6cw==
X-Received: by 2002:adf:ff86:0:b0:207:a89b:f532 with SMTP id j6-20020adfff86000000b00207a89bf532mr6176553wrr.558.1649759002672;
        Tue, 12 Apr 2022 03:23:22 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id b1-20020a05600018a100b00207ab2305d5sm3803038wri.16.2022.04.12.03.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:23:22 -0700 (PDT)
Date:   Tue, 12 Apr 2022 11:23:20 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     kernel test robot <oliver.sang@intel.com>,
        0day robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [nl80211]  584f2e43bb: hwsim.ap_country.fail
Message-ID: <YlVTGIhTvzCsZhmO@google.com>
References: <20220401105046.1952815-1-lee.jones@linaro.org>
 <20220405091420.GD17553@xsang-OptiPlex-9020>
 <YlP0A+PurZl39sUG@google.com>
 <eb5873b4afeee8a7e183a9b1f2e6af461bf7f69f.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb5873b4afeee8a7e183a9b1f2e6af461bf7f69f.camel@sipsolutions.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Apr 2022, Johannes Berg wrote:

> On Mon, 2022-04-11 at 10:25 +0100, Lee Jones wrote:
> > So what exactly happened here?  What does this failure tell us?
> 
> Probably nothing.
> 
> > Is the LKP test broken or did I overlook something in the kernel
> > patch?
> 
> I think the test is just randomly fluking out.
> 
> > How does LKP make use of NL80211_ATTR_REG_ALPHA2?
> > 
> > I'm struggling to find any mention of 'hostapd.py' or 'ap_country' in
> > LKP [0].  Are these benchmarks bespoke add-ons? 
> > 
> 
> it's running the tests from hostap:
> https://w1.fi/cgit/hostap/tree/tests/hwsim
> 
> Anyway, I think we'd better fix the issue like this:
> 
> -       [NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
> +       /* allow 3 for NUL-termination, we used to declare this NLA_STRING */
> +       [NL80211_ATTR_REG_ALPHA2] = NLA_POLICY_RANGE(NLA_BINARY, 2, 3),
> 
> 
> What do you think?

I'm not entirely sure of the semantics, but so long as it ensures the
user declares enough space to hold both Bytes of data, I'd be happy.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
