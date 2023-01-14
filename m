Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592A966ABF4
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 15:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjANOxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 09:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjANOxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 09:53:02 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6F75274
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 06:53:00 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id bk16so23509607wrb.11
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 06:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TNfS9hq3Jd9+y3no15GrHwb3oIxtxOEzkgxgD6diI+c=;
        b=H7GjTackpwpq5bsoAP3JDZ00CWELzIhssuFXhH7+tp8C+iZsGDGoWUJ3dTIjcKaS0K
         A9tUnWAFA+hON5CBBJILnJ+hBvqLMwG/4L7/sketgMLFmSY0iQt0W577V9B1dQ7QESHJ
         JcTi9mnC7GyWOybsUCuKEZILkwSfvv32laZV5iANUiQ75wI9asQgrhUS5vlvtR0XqOzU
         2ewkXKhlUtVCINlZBoMCU2X/xOnHXbt/W6S476WgnD945zuogIPCsqgaLoqr2InkuDFH
         YJQUwWXn8AYYqR4eJqUogk8+YnaND+jphRLW7vjwXbjs6Fh81PuE2oiI2N9uKRucp0t9
         SD8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TNfS9hq3Jd9+y3no15GrHwb3oIxtxOEzkgxgD6diI+c=;
        b=OdrvSR1MmFDDsySDPBAuoW8jWNirhSO2PuHJuDWXiSe2GFZnPM1ng3B7iAQRuepeFW
         t+ZkvvAXwdK89ODYbbi2sWIBEIGKq7kV/VM3TpNY3kk/PW4j5q/IPfqwvdi7pdsf//uU
         wLwNEr781+r+5b0WWlKP/93mZTRFrEbtGW+Oy6CDcm4TfdBS8Bj3Q1Yn2Fo/wUXlA96C
         6vBN6RFbM8Ujf4Vz8+9L0heRPDtob4mIUP4F5RV4P1Ab+uGb7PCN3qZQEsqgaPUnbSru
         QzeuAvWLUkbQxAB59zZlubzjtxl6gfvdhSxw4M/0lq3btZewh9ZhuxsmFuWP2Z/RoTCZ
         go8Q==
X-Gm-Message-State: AFqh2kplb+/isEHikLBFLkbvCOiDuw+OqJY7JtQdQzT3TSkN3ipnHMwK
        6jyCt5pq1cHdU1Kfm4uLo0I3WfDDjsG/ZQ==
X-Google-Smtp-Source: AMrXdXsAjsyC1Cj8qg8J8+fykF7Jkm828W2yIULpeTwffczuG9I6Lh88g/8lLArTQr2UaecUeRxmJw==
X-Received: by 2002:adf:ef84:0:b0:2bd:e220:6b9 with SMTP id d4-20020adfef84000000b002bde22006b9mr4544594wro.38.1673707978885;
        Sat, 14 Jan 2023 06:52:58 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id t10-20020a5d534a000000b00272c0767b4asm21849954wrv.109.2023.01.14.06.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 06:52:58 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 829E7BE2DE0; Sat, 14 Jan 2023 15:52:57 +0100 (CET)
Date:   Sat, 14 Jan 2023 15:52:57 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Matthew Fahner <mdfahner@gmail.com>, stable@vger.kernel.org,
        regressions@lists.linux.dev
Subject: Re: Second Monitor Issue on Kernel 6.1.5
Message-ID: <Y8LByXvibutD79au@eldamar.lan>
References: <CADsncqR2mTUArTv2HhRnsfmQx5iNgUZo=JVgkUcZT7MtjxEoYw@mail.gmail.com>
 <Y8JSMlMgnggwOYl0@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8JSMlMgnggwOYl0@kroah.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sat, Jan 14, 2023 at 07:56:50AM +0100, Greg KH wrote:
> On Fri, Jan 13, 2023 at 11:58:47PM -0500, Matthew Fahner wrote:
> > Hello,
> > 
> > I'm running Ubuntu 20.10 and experienced a regression when trying
> > kernel 6.1.5 that was not present in previous kernels such as 6.0.19
> > or 6.0.9
> > 
> > I have two monitors attached using DisplayPort MST (daisy chaining the
> > displays).
> > 
> > Normally, this works without issue and both monitors are detected and
> > display properly.
> > 
> > With kernel 6.1.5, the second monitor (the monitor that's not directly
> > connected to the computer) was detected but would not display.  I
> > didn't spend much time troubleshooting the issue and instead reverted
> > to 6.0.19 where it again worked without issue.  The first monitor
> > worked without issue.
> > 
> > Let me know what steps I can take to help identify the root cause.
> 
> Can you use 'git bisect' to track down the offending commit?

Not the reporter, but I suspect this is
https://gitlab.freedesktop.org/drm/amd/-/issues/2171 .

Matthew can you verify this matches? There is as well context on this
issue on this thread:

https://lore.kernel.org/stable/8502e5d8-8444-e256-54f3-0c488b54686a@amd.com/

FWIW, we had a similar bugreport downstream in Debian:
https://bugs.debian.org/1028451

Regards,
Salvatore
