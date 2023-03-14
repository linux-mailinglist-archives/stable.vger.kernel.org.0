Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D736B9DD8
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 19:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjCNSGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 14:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCNSGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 14:06:01 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2405AF2AC
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 11:05:59 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id a23-20020a4ad5d7000000b005250867d3d9so2436338oot.10
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 11:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678817158;
        h=content-disposition:mime-version:reply-to:message-id:subject:to
         :from:date:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=eaM0/aCsFK0EYrSF1Yk5K88ESExmasw+qhmdwBmYPk0=;
        b=qP/GA07jzRiUSbXhav5CaAQe2/Nobz3ffphlpbGCXgRixF6oTqPnk27EEEyhA0XMtE
         FYCx0RGPHksmhD8HMOabxfDQtabxu/JhdgmNDCe9NPnMYJeN3ZcjLrY9KJTLNZUYreR+
         TntkQ6qGWM2p0eCTWd43Nrd5Lzlc7mo38YqzZujhrYheiknkJqMni6MA/iJtKHhlIyMb
         62D43Aw+hrdwf3Jsa1b7aPk8NbKlaS82b29Y6WpQf86fVoehgymF+vqDi6EzI9QhNOzE
         bT152fgwHjEfPQQZv+fiC6hCWu6qjiwOGydsj8wS5sktzXbCaLDFHoha4OYtcBjZsmh4
         3raQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678817158;
        h=content-disposition:mime-version:reply-to:message-id:subject:to
         :from:date:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eaM0/aCsFK0EYrSF1Yk5K88ESExmasw+qhmdwBmYPk0=;
        b=Q7N4bBvYcu1CItDRYb3PA6omgxAN0YxIXNzBypIB3rr0dSs6Do7f+BvzliPKb/i5zj
         FnaxghTELzmc/DDleeBz1/ri8YOjCRRHl/cWG8OYey/bB5eV15gKk2pM4gZPWW3Rvudo
         2F7O0JCG+O7PhzOQ+t/VRSXJi7W4JF3hY2tXqg/JLj1apXUs392+z6kPL7+NV/QxZ8wk
         x/9UvFO1akH1hVLwmRRBBhYm+qR1TZBRyw7Y2Yu6C4YW1xqofDCphUgy62MFFX0hbN2p
         LWxiysqJOEC5sSHDvWBA8dA94XALplt+pPhS+sI3P02ZyZGQ0VFrV/7zZysOk6+RCIqm
         9Hpw==
X-Gm-Message-State: AO0yUKUc8HsEdDhQUuQ7RsjmuqHALhMKWFoCOSw6Ag6pqUsqCbzq6knm
        6N2keLYzcI2BRfRpyNtDF0hColVJug==
X-Google-Smtp-Source: AK7set+2AMku1FAYlKosqarY6kfkETOqDU2xH61H2hQrYq23ImMeFZebGaibs1f0vOI19zS4eV9KsQ==
X-Received: by 2002:a4a:b149:0:b0:525:4e79:8715 with SMTP id e9-20020a4ab149000000b005254e798715mr15406903ooo.8.1678817158630;
        Tue, 14 Mar 2023 11:05:58 -0700 (PDT)
Received: from serve.minyard.net (serve.minyard.net. [2001:470:b8f6:1b::1])
        by smtp.gmail.com with ESMTPSA id b25-20020a4ad899000000b0051763d6497fsm1256093oov.38.2023.03.14.11.05.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 11:05:58 -0700 (PDT)
Sender: Corey Minyard <tcminyard@gmail.com>
Received: from minyard.net (unknown [IPv6:2001:470:b8f6:1b:d290:38d8:4c6f:34f2])
        by serve.minyard.net (Postfix) with ESMTPSA id 5C577180044
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 18:05:57 +0000 (UTC)
Date:   Tue, 14 Mar 2023 13:05:56 -0500
From:   Corey Minyard <minyard@acm.org>
To:     stable@vger.kernel.org
Subject: Please apply db05ddf7f32 to 5.4.x and 5.10.x
Message-ID: <ZBC3hOAa/4vzTLTV@minyard.net>
Reply-To: minyard@acm.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply:

db05ddf7f32 ("ipmi:watchdog: Set panic count to proper value on a panic to stable kernel")

to the stable branches from 5.4.x to 5.10.x.

It requires as a pre-requisite:

a01a89b1db ("ipmi/watchdog: replace atomic_add() and atomic_sub()")

This change went in to 5.16 and a backport war requested and put into
5.15.  It was missed in the earlier kernels; it didn't apply because
the prerequisite was missed.  It fixes a lockup at panic time.  I think
distros have picked it up, but I had a user report this.

Thank you,

-corey
