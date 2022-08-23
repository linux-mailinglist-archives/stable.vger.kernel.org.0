Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8D259EA8E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 20:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbiHWSH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 14:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiHWSHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 14:07:43 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2EDF4904
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 09:16:48 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id i77so11274511ioa.7
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 09:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc;
        bh=FfGb2wigYjFI5ciFl9OH1jPsygAhh+SORQgeVQ9bFzo=;
        b=gnd+uSIEHxALxFyh8A3GGfp997Qazd+/W0jHV3iRaLnXtBS5dR3S1g/zhFVdtDtpid
         wyVthm35Yf8bGYUMv6e4UKU7/8TuGo/k8TXj4ztio2AbGDkusFZoWpmf5ACsiT8GSSYd
         b8kMuG4Mxq97q1wOoLzDa5IXtQT0Tnen2rw6JLsuMAKrrikw52b8fDvmORwi6IvePNp7
         IJQEUH/eqF04gDUnsWcrD+E7jKqhuNHPPvE6tNEZIn1yHdUZG6Htatnbx3N7PTRiOQh2
         Ov1LPHzZ5JTVbKjolZGE3Q0VgpvvsVsooiLdii+iyVckbgB3EYSWhhuhX9Mhc0wXGzN6
         4TIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc;
        bh=FfGb2wigYjFI5ciFl9OH1jPsygAhh+SORQgeVQ9bFzo=;
        b=4KiSelV87KwoEwIed/kl8z6dGCAD24STjXJSwnaj/lWQGkNxSEsIBpT2dMVYDG5LVb
         JgL1uuVompy7KMn2ze9g10Q4J8+5YI9zLblZnYG3QTkwCo+m7o+tFnOOXTpfNzWJ4Ubl
         5/7GAwJHzQnOxhSrr+auOQqDM1Em0Ni+jvK4Thw61TkbcIUgd4AtPu2aNAfEMEV+dh5Q
         I1EtbJagOh8CCWSIHf8cj3QnH5tdWgSw6qUGZQeqjeTxRi/mNfUIyPgToIgmaLbfavF1
         eRBQj43uOi/y1lXRsQsRRWdaQaEqeeDO3XZfTM/0Mln+o1M7btRZ/soZ5kU2OSamnImE
         zlzQ==
X-Gm-Message-State: ACgBeo290M28lPMmeivnJMpggC/cpY2WFQaqPj5uQ1XgKks3XXsvBkYP
        488es6CJqO7qInvK5QVo/oImEXpKqdArOw==
X-Google-Smtp-Source: AA6agR6uQip3RJlf9k2Cqr7uH0RT3UsbNmo6RMeNckSsbZdah2DIcYdO7CxQK5sE1I190+W0nLbuHA==
X-Received: by 2002:a05:6602:2f03:b0:678:9c7c:97a5 with SMTP id q3-20020a0566022f0300b006789c7c97a5mr11206025iow.32.1661271407112;
        Tue, 23 Aug 2022 09:16:47 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a4-20020a02a004000000b00349ba0d1137sm4588633jah.24.2022.08.23.09.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 09:16:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel-mentees@lists.linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com,
        hch@infradead.org
In-Reply-To: <20220823160810.181275-1-code@siddh.me>
References: <20220823160810.181275-1-code@siddh.me>
Subject: Re: [PATCH v2] loop: Check for overflow while configuring loop
Message-Id: <166127140632.124225.483036207879834754.b4-ty@kernel.dk>
Date:   Tue, 23 Aug 2022 10:16:46 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Aug 2022 21:38:10 +0530, Siddh Raman Pant via Linux-kernel-mentees wrote:
> The userspace can configure a loop using an ioctl call, wherein
> a configuration of type loop_config is passed (see lo_ioctl()'s
> case on line 1550 of drivers/block/loop.c). This proceeds to call
> loop_configure() which in turn calls loop_set_status_from_info()
> (see line 1050 of loop.c), passing &config->info which is of type
> loop_info64*. This function then sets the appropriate values, like
> the offset.
> 
> [...]

Applied, thanks!

[1/1] loop: Check for overflow while configuring loop
      commit: f11ebc7347340d291ba032a3872e40d3283fc351

Best regards,
-- 
Jens Axboe


