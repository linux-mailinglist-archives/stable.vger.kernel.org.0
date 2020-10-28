Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D4A29D2EA
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgJ1Vhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgJ1Vhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:37:36 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EE1C0613CF;
        Wed, 28 Oct 2020 14:37:36 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id m26so490689otk.11;
        Wed, 28 Oct 2020 14:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9It0THAPe5/TanNq/NozSRYdQ5TJnHIQFVuxJkq/Zos=;
        b=Ys2R+h7cddZqNaSHRFI8MfFJKpSf+09jPe1Tmj75aUQIvR8v2u5jjosfzpbq8gaD1l
         OxsMxlC5Vqv0v9ViLHaRxbermZ/zrDxpAH48y6wo/5qxwiZ0EiLAvhR88D7cfk5H+hp3
         RB32CeXFAARsF49UEjucdigq90UatWs7+QE69egwJWxiTHV7y3wAAB1P8oCS3Kcf3Uf0
         5VIz//cxLPrQVlpJ08K4QOdT2zPZ8xBHTUeru/fTAFgNE/5W+IT4VQ/kh/ZpcNMdVY26
         cjqwXAKBCNMhPIEHFnFkKZfC4h/si+QEnXDtV2wBZcU7T3dVI5r+CQzoe7wyKB+H0xqz
         J76Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=9It0THAPe5/TanNq/NozSRYdQ5TJnHIQFVuxJkq/Zos=;
        b=HIsGJB5QU+lf+M2L5w+XX45kfph7Pwm711zaTrS+d+dENbtn/ZWfRiW658eLIR7S7o
         T+q7QEPHgBiQNz2kk7GzDnLho1TyUmhPvgJPDvFjaX9C7OdJa2x5IQ/2/mGBU9Ncfz32
         bEFmBDvq2mOR9/jzCwuUlaChtKk1twehtdJg37H+UayaiWw6kd6aXHAd0Gg1Bjp2Tg2Z
         tDjGO+SfmptvdwnQuteeVe69AhixtMwranar+uvsEvYyXwANQ5J2KMfAAMgcPo4fW4/V
         6rf7za7hnOzU69jaYHZKI8gb/ZQNJ3ZfIpXom/+yR07xIGNgNwSZ0T/F0h0Vt1KjKtIT
         XntA==
X-Gm-Message-State: AOAM533K49h7vasvzIHWx49FfkMAMBMdvpUJ5/xO4VGSLRdWHYDK3xPd
        +I57pLewAp6XvdOSM3Ku9m21H2kzW2I=
X-Google-Smtp-Source: ABdhPJzmo/7ppoSgzAmduWC1h0ZcIWCP5uTIpWuS1ihserzf7cazeYRWqIbXwW+QZ94Htog2oJSoHA==
X-Received: by 2002:a05:6830:18cd:: with SMTP id v13mr708086ote.206.1603914409617;
        Wed, 28 Oct 2020 12:46:49 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e3sm83523ooq.0.2020.10.28.12.46.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Oct 2020 12:46:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 28 Oct 2020 12:46:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/112] 4.4.241-rc1 review
Message-ID: <20201028194647.GA124690@roeck-us.net>
References: <20201027134900.532249571@linuxfoundation.org>
 <20201028170621.GA118534@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028170621.GA118534@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 10:06:21AM -0700, Guenter Roeck wrote:
> On Tue, Oct 27, 2020 at 02:48:30PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.241 release.
> > There are 112 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 29 Oct 2020 13:48:36 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 165 pass: 165 fail: 0
> Qemu test results:
> 	total: 332 pass: 332 fail: 0
> 

Did anyone receive the original e-mail ? Looks like I have been tagged as
spammer, and I am having trouble sending e-mails.

Guenter
