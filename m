Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CACD5F6DF2
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 21:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJFTKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 15:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiJFTKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 15:10:47 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2FF13F45
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 12:10:45 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id bh13so2675741pgb.4
        for <stable@vger.kernel.org>; Thu, 06 Oct 2022 12:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bLOgEdsK17qTymlL/26p9+5hBN2KpAIbxV9NdGYWjcU=;
        b=c9wXBzLW4k8MpjVUZLnGuZjJhP+2Dh3k6FuMHnFv9hsCMwK4ij962D5y3m8+8SNvDs
         +Vs0wUh6xvIaxAJ22qgd1Hj3n8eIKmor9OGVgJwOLCO+M4+oBKW2P3wv2+m/eVVzt1SK
         3EEWTQUVRw12L35Huipjje+JaNXFnsoG1D/HQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bLOgEdsK17qTymlL/26p9+5hBN2KpAIbxV9NdGYWjcU=;
        b=Cc4PCHRsxOFBfibND4zNW8P6JQlVZAkLRO0H+uUm9C6Jh7ZwesRy5rUSXs+AvcWJ3F
         F+PXnnut9vtjseZ9/PXdG5fLFQhVgrAYVF3HCkaK7XMN1SWWf4I9kl37vMKnXM8zZINj
         JZWtSSJAAMCeyztw/Dbd7hEFnQB5WDY33N0kCic8zR6U3WtcNKNfhvh6tXGCW4sxgO/2
         Ri6pBwkNaZ6eJsNh0916VSzLUxftz87jZcqcZ1cSaYGkoXGZHICNucAsRcbjHNX2liem
         jSpabtVeoWfJtj86Pzo/eNPghIzRPgWQH0awg3Y3E2PwjzUcj+/BpNejkIMe6U4m5Mmw
         4U0w==
X-Gm-Message-State: ACrzQf3d6/94X1bsao9btvG5EN8HAtDnpOaRrxyK1wEJk3F1IxOae8fi
        RHWyeLYO18eQSPKBwoePrzEfyg==
X-Google-Smtp-Source: AMsMyM5p+WhORfK6zbaG8CSk6X4l7Hy/eZRnWoze0PTi9ZkSsWkvDi5fVbZpeSBtsHtG5rb6OtwnsA==
X-Received: by 2002:a63:2bd4:0:b0:451:5df1:4b15 with SMTP id r203-20020a632bd4000000b004515df14b15mr1142635pgr.518.1665083444726;
        Thu, 06 Oct 2022 12:10:44 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:420:a420:892e:2a22])
        by smtp.gmail.com with ESMTPSA id y10-20020aa78f2a000000b00562a71d719fsm371571pfr.155.2022.10.06.12.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 12:10:44 -0700 (PDT)
Date:   Thu, 6 Oct 2022 12:10:42 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     gregkh@linuxfoundation.org
Cc:     linux@roeck-us.net, stable@vger.kernel.org, ulf.hansson@linaro.org
Subject: Re: FAILED: patch "[PATCH] mmc: core: Terminate infinite loop in
 SD-UHS voltage switch" failed to apply to 5.19-stable tree
Message-ID: <Yz8oMnK1WHrUUvtf@google.com>
References: <16647043801297@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16647043801297@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 02, 2022 at 11:53:00AM +0200, Greg Kroah-Hartman wrote:
> 
> The patch below does not apply to the 5.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> e9233917a7e5 ("mmc: core: Terminate infinite loop in SD-UHS voltage switch")
> e42726646082 ("mmc: core: Replace with already defined values for readability")

I think it would be most readable and least error prone to just backport
commit e42726646082 (it's trivial) along with $subject. I've confirmed
that together, these two patches apply cleanly to 4.14.y..5.19.y, and
the appropriate definitions are available.

4.9.y has some other conflicts, due to missing this:

09247e110b2e mmc: core: Allow UHS-I voltage switch for SDSC cards if supported

I'd personaly just skip $subject for 4.9.y too, although I could be
convinced to rewrite and submit a backport if someone feels strongly.

I'll assume Greg can pick the quoted two commits up (that more or less
fits Documentation/stable_kernel_rules.txt option 2), but I can submit a
proper patchset if needed.

Brian
