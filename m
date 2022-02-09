Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616734AFD49
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiBITZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:25:34 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbiBITZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:25:20 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DA0E015251
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 11:25:13 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id k6-20020a05600c1c8600b003524656034cso2380663wms.2
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 11:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=9X6kiHxpGEazzvkQHp8JnSwgUsJv8D0X/1igB1bJ0oM=;
        b=F+1sc9LG9Zusg8VEVpmo/a8vGlBpqMWse1p/RFAUMyYeq8iwZj3MRa7hjavr8KL9Wl
         jEdeEg8CSnXfgTg6u+0HhVo3iieUx/mqE2aRvLDuwyghlMBvJ6dj+riFgrqwt1R3411+
         LH/975H10YT9+feSLn8PkRoZMV8B0S/ORAWIQrR6t38RKCx/mNROV0o+pk/oLaF+ivxr
         shuEKu8D27Sd0379yjauUYuSJbvnPQZDc5rpwQapN1ScgY21I+TSz91lMvAXDtJlvOe4
         rxvKuPYZb4eivldj0ZoVreDkYl6QuJsstf7YlKapOeJ+mhh/P5E/lW1qfNaCgDAlQEBE
         +ybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9X6kiHxpGEazzvkQHp8JnSwgUsJv8D0X/1igB1bJ0oM=;
        b=xg8u2+3dI7SgwnIFstq0+0aocZxe07KTtrLOBGhszmQXaG+ZDTIT1O85o8uCYsAImB
         4IkWPS7KimM5R7BZYYuhpY1vFSBU5YOFz4HCiQGtcw9ylC4vIJV5UaPNqA/X7kVgkb9v
         rzcbmHZHFYKSOLWVxLxqM21sQxwEdWEiOLVI1QfjgNSE78PZoDTtOk5ur5VV1lR8io4l
         oIvO5ztffKqoY+b0+0nhXmqXrRPGdF/2J9rMqqkGI+3ZMhV7Tph1NBnUQiRG7wk0ZIak
         7apHkVaNQNt3f2A4HM3JUR0doaLNXOMJmcWMtrioD9XZrJpvW5k7/qZkdqIY/dJzLQRP
         aEyw==
X-Gm-Message-State: AOAM531+2l+QP5Ob2K7kQAYKY5Ta4pRz7UsdEATTgTnqN33ZbBBuoV9j
        CZ4UHvFoMtxpLVHfb3HYpTjMvHfxYgXp3cWd
X-Google-Smtp-Source: ABdhPJxCUh4sor/h3+HFTKlhR6E08fCeHYcKOJMGBMEAnXI+4nuwI1jwNHyvV7w8k63ICgSJT0jJAg==
X-Received: by 2002:a7b:c38b:: with SMTP id s11mr3995713wmj.8.1644434709820;
        Wed, 09 Feb 2022 11:25:09 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id z5sm6993811wmp.10.2022.02.09.11.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 11:25:09 -0800 (PST)
Date:   Wed, 9 Feb 2022 19:25:05 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        Stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com,
        syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] Revert "iomap: fall back to buffered writes for
 invalidation failures"
Message-ID: <YgQVEVVOfPH/f2jQ@google.com>
References: <20220209085243.3136536-1-lee.jones@linaro.org>
 <20220209150904.GA22025@lst.de>
 <YgPk9HhIeFM43b/a@google.com>
 <YgQSCoD5j9KbpHsA@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YgQSCoD5j9KbpHsA@casper.infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 09 Feb 2022, Matthew Wilcox wrote:

> On Wed, Feb 09, 2022 at 03:59:48PM +0000, Lee Jones wrote:
> > On Wed, 09 Feb 2022, Christoph Hellwig wrote:
> > 
> > > On Wed, Feb 09, 2022 at 08:52:43AM +0000, Lee Jones wrote:
> > > > This reverts commit 60263d5889e6dc5987dc51b801be4955ff2e4aa7.
> > > > 
> > > > Reverting since this commit opens a potential avenue for abuse.
> > > > 
> > > > The C-reproducer and more information can be found at the link below.
> > > > 
> > > > With this patch applied, I can no longer get the repro to trigger.
> > > 
> > > Well, maybe you should actually debug and try to understand what is
> > > going on before blindly reverting random commits.
> > 
> > That is not a reasonable suggestion.
> > 
> > Requesting that someone becomes an area expert on a huge and complex
> > subject such as file systems (various) in order to fix your broken
> > code is not rational.
> 
> Sending a patch to revert a change you don't understand is also
> not rational.  If you've bisected it to a single change -- great!
> If reverting the patch still fixes the bug -- also great!  But
> don't send a patch when you clearly don't understand what the
> patch did.

If reverting isn't the correct thing to do here, please consider this
as a bug report.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
