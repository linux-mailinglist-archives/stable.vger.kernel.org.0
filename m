Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2F539BB2A
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 16:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhFDOwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 10:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhFDOwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 10:52:22 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04572C061766;
        Fri,  4 Jun 2021 07:50:24 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id dg27so11441476edb.12;
        Fri, 04 Jun 2021 07:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xuXiDAxhAZDGHBzn5BFz4xCVwXnNVv/swPLkGGY77mU=;
        b=uFa3UKYFOGj5009UV5wo9FWfXWffDwz+02fGOiPUvhY1yFZBIVXPjuNZ8z41ruWtWj
         i7skt9SV0yR9jMjN7+GIerfNedULwy0mMkvV+ISNNQYZx3FCnuxBBcx4wHym0wTFTZ2k
         7naZZjIvQBOjBexYb0MIjef9C4futlC3tWrUVyvMLgHq+oL+emrJIvCHA4+MeF1U6mjz
         R1tYWDHgAHVB4jGynA3GQc3TVE9dSyo2+oPONmsImsffXOVO5rGx9APuv8adtqjJGLsn
         CPnEIR/B9tR/UGNBF2mkXAx+JwC74C+faww+VMwh3au/yBdBdYnRfxVB+cThVSKcRbI+
         oj1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xuXiDAxhAZDGHBzn5BFz4xCVwXnNVv/swPLkGGY77mU=;
        b=Q96p660VSdNLTPAXfUacmnYawWXBYDsLhstD0Pn/sQYF0GaFZhdNx5cWO7/hurBXtX
         642Fww5Bil5wTvV8z8oR71V5Kx8r4VLVqk3ZfQgpRlMCNoHGQ7xgEOuV2ez5pihgretI
         lAkaBRbNJ7Uqp/trlXX/aiM3sUbgJh41Ed/DCu4+A5PmXYtMrHVYeRbXobKpHPSY4Zfp
         fOwh35fSc7sDzsRPOHTeyA33tvFSYOJ8W6oMYDDHXsWKY7WBqEkFdOnuB8biJduLpZf+
         O7ZlTx0ERUO8v9TmNcNQeQuXhvawMu4CnjSh/l9XGJNZzM88e9hC64Y1gZV0Gkzu7flU
         Njwg==
X-Gm-Message-State: AOAM531jgUY7KejemPqNDeoV6hGk95jaUJVvzf1jlPnYP0iEChgK3R5U
        /i1I3Bps+2kR3Ars51MlmB1FSRr3Zps=
X-Google-Smtp-Source: ABdhPJxof6EkPq0yVWQzf/8gqpaiZgHpxdSYB2zAUkso2RpOh0aBJW8C82ZET03mK1E1Mi4RP79chA==
X-Received: by 2002:aa7:c782:: with SMTP id n2mr5053351eds.77.1622818222268;
        Fri, 04 Jun 2021 07:50:22 -0700 (PDT)
Received: from [192.168.178.194] ([171.33.179.232])
        by smtp.gmail.com with ESMTPSA id q26sm2869954ejc.3.2021.06.04.07.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 07:50:21 -0700 (PDT)
Subject: Re: Backporting fix for #199981 to 4.19.y?
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <c75fcd12-e661-bc03-e077-077799ef1c44@gmail.com>
 <YLiNrCFFGEmltssD@kroah.com> <5399984e-0860-170e-377e-1f4bf3ccb3a0@gmail.com>
 <YLiel5ZEcq+mlshL@kroah.com>
From:   =?UTF-8?Q?Lauren=c8=9biu_P=c4=83ncescu?= <lpancescu@gmail.com>
Message-ID: <addc193a-5b19-f7f3-5f26-cdce643cd436@gmail.com>
Date:   Fri, 4 Jun 2021 16:50:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YLiel5ZEcq+mlshL@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 6/3/21 11:19 AM, Greg KH wrote:
> That commit does not apply cleanly and I need a backported version.  Can
> you do that and test it to verify it works and then send it to us to be
> applied?

I now have a patch against linux-4.19.y, tested on my EeePC just now: 
the battery status and discharge rate are shown correctly.

I've never submitted a patch before, should I put "commit <short-hash> 
upstream." as the first line of my commit message, followed by another 
line stating which branch I would like this to be merged to? Should I 
also include the original commit message of the backported commit? And 
then use git format-patch? I just read through [1] and [2], but they 
don't say anything specific about commit messages for backported patches.

Thanks,
Laurențiu


[1] https://www.kernel.org/doc/html/latest/process/submitting-patches.html
[2] https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
