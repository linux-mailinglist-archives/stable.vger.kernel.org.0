Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1329C49C149
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 03:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbiAZC0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 21:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236341AbiAZC0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 21:26:05 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6D4C06161C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 18:26:05 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id k23-20020a4abd97000000b002ebc94445a0so602025oop.1
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 18:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l4BdSQcYkI7Tg6m9Z/JRw5Xx2nGZP7Dqic5XeVsukdg=;
        b=J1FFAFb7vBaVzRQ23VWBQWxT47F+6OcV2pTl6aUARYldxGriME6fiNscI5fFMa28IN
         pyxFvIIToDnYSS+s78DW11HZxDxhkFLhHjM2JMFikfPlA2b12yLRFoSKIxQFqvhZ0vuw
         d+7D8xE78U4f7M9t85Jbe7MQR86VHvEEF0wZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l4BdSQcYkI7Tg6m9Z/JRw5Xx2nGZP7Dqic5XeVsukdg=;
        b=mkufyOh6KkI/BEfegVb935w405ZfSv9sowfVALs7Rmq4DP06Eq6Q70+hJ44UH+l78C
         4rL4YzixzP4BE29iFfZ6iLxrRYHYV94706Cm9ZbeupnbcIWdAJMXKJRccn7IV3vRHF2O
         RF+nFf8usgutH1r8wYGr3F0oFMUsOKD+q9/o4ONMu4pyawQCizs5B1sCvALAJRLUMXYK
         4vkavXqir3YX9JpidY/7ATzOMiSUbtWCJ6BjA97iTRCxGJwBp3hwooHdq/12K91M0js4
         vTqXqzDygMW1eNuhnsVWZmNawq/fCGl9+wiHG83wKefnLhyFrSeD+h6kgDNmqCG0bGR7
         7ztQ==
X-Gm-Message-State: AOAM532AoNOa/LFlH7O/bY1Q6sefuiVJ5svZx9giVtRYTUSxo3Rqq4lb
        ga/7PMfNdDUCnbqxEmwznXh5pcva+6FDbEk1
X-Google-Smtp-Source: ABdhPJw+nrU/qkapwjf3gFM4N0QgVLATa/twB7tT6hkq5TfgdIPM2W6n+AGTrmA4cDAHBJ1mStiy/g==
X-Received: by 2002:a4a:dc16:: with SMTP id p22mr14546157oov.85.1643163964828;
        Tue, 25 Jan 2022 18:26:04 -0800 (PST)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id g4sm7544923otl.1.2022.01.25.18.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 18:26:04 -0800 (PST)
Date:   Tue, 25 Jan 2022 20:26:02 -0600
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.16 0000/1033] 5.16.3-rc2 review
Message-ID: <YfCxOpu4fTON5ded@fedora64.linuxtx.org>
References: <20220125155447.179130255@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125155447.179130255@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 05:33:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.3 release.
> There are 1033 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
