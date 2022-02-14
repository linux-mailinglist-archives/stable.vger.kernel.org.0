Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6325A4B4CF2
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 12:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242388AbiBNLFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 06:05:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350128AbiBNLFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 06:05:36 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8EC2BCC
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 02:33:42 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id k3-20020a1ca103000000b0037bdea84f9cso10522433wme.1
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 02:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Y2dQkZtEBm/fDqJ75Y4aAkTg3U+ZJI5VXSRDEIIFY/0=;
        b=jJ+OdxsyUYtXOF2bOUMhdzXGlmvvihgc5HolIejHGvoHZ4zG8+/ui8gXzwJwcDtplt
         Hu78Df+kUVUCnuzN3sBNlqLYOUEfoKbjDbxHVAWTdUZxeX9QO58peZrdx+jo+z4mmqee
         DAsHVXGBTyN79BLjNfRkgj5Okzu6Hz5K4p0/cAoXbLBm9bpeualDYoCutpGL1OBCXTBb
         O/9WsGLmXrnprKOLukEVfG8gVeIfHORKI4enIzVrcmtkeas4TpM+zGt4ZoUyW+gNt9r1
         hMsBgDlTeQS1iD+SSCoUZDub8fDK5mgrougrFwMOHFRbApurG5LmM3N4fzuiF4MhIct9
         QQHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Y2dQkZtEBm/fDqJ75Y4aAkTg3U+ZJI5VXSRDEIIFY/0=;
        b=uxXCgQGsJESsw47s9HdCpe7e7ZoRbcfQhU/jzg8UNjxyLphY2Z3cqlIkvKfrxw+xei
         DUvl0dT4O5NEYSJU3Sl6/WT5HGX78Nrpb6wrSGBOiYmSa/eXkdGfyNy/X1YQbmvNNWJI
         tsPdVdVXyNsu0cQ7zb05wyD+jfRAjP+3cTmLvnkKQGLJMFUwsYFIdekZe6eYF1kecobD
         8eHZLS8/KoKuMeK+kBnnImI+lgV3eeXm52FzEHRDi8A5FjlZr9FFDz0eqW/ZO34hdOQI
         60XWjOre4/fWU3SWkPmWiZAqMpA5vHAuMznLe66lul39rFrOuY6wCynuW9GQbqqPxtIh
         S/nA==
X-Gm-Message-State: AOAM532D/G1nUWxvv0jLBOAXmAeW786bfJCM1PQE9M9sKxMcxhn2ADo0
        Fg4VtZySjb7ERjviAX2hY5E4Dw==
X-Google-Smtp-Source: ABdhPJyQCmvkhGvcGJSPK0iuX2InSha335cVaRamyENYW1Z/K2WQPdYt8MDHDpiU9vBHs4mik5e1qA==
X-Received: by 2002:a05:600c:3552:: with SMTP id i18mr10585774wmq.90.1644834821019;
        Mon, 14 Feb 2022 02:33:41 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id h17sm9479387wrx.58.2022.02.14.02.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 02:33:40 -0800 (PST)
Date:   Mon, 14 Feb 2022 10:33:38 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
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
Message-ID: <YgowAl01rq5A8Sil@google.com>
References: <20220209085243.3136536-1-lee.jones@linaro.org>
 <20220210045911.GF8338@magnolia>
 <YgTl2Lm9Vk50WNSj@google.com>
 <YgZ0lyr91jw6JaHg@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YgZ0lyr91jw6JaHg@casper.infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Let's attempt to seek beyond the mud slinging, swearing and the whiny
amateur dramatics for just a brief moment and concentrate solely on
the technicals please.

On Fri, 11 Feb 2022, Matthew Wilcox wrote:
> On Thu, Feb 10, 2022 at 10:15:52AM +0000, Lee Jones wrote:
> > On Wed, 09 Feb 2022, Darrick J. Wong wrote:
> > 
> > > On Wed, Feb 09, 2022 at 08:52:43AM +0000, Lee Jones wrote:
> > > > This reverts commit 60263d5889e6dc5987dc51b801be4955ff2e4aa7.
> > > > 
> > > > Reverting since this commit opens a potential avenue for abuse.
> > > 
> > > What kind of abuse?  Did you conclude there's an avenue solely because
> > > some combination of userspace rigging produced a BUG warning?  Or is
> > > this a real problem that someone found?
> > 
> > Genuine question: Is the ability for userspace to crash the kernel
> > not enough to cause concern?  I would have thought that we'd want to
> > prevent this.
> 
> The kernel doesn't crash.  It's a BUG().  That means it kills the
> task which caused the BUG().  If you've specified that the kernel should
> crash on seeing a BUG(), well, you made that decision, and you get to
> live with the consequences.

BUG() calls are architecture specific.  If no override is provided,
the default appears to panic ("crash") the kernel:

 /*
  * Don't use BUG() or BUG_ON() unless there's really no way out; one
  * example might be detecting data structure corruption in the middle
  * of an operation that can't be backed out of.  If the (sub)system
  * can somehow continue operating, perhaps with reduced functionality,
  * it's probably not BUG-worthy.
  *
  * If you're tempted to BUG(), think again:  is completely giving up
  * really the *only* solution?  There are usually better options, where
  * users don't need to reboot ASAP and can mostly shut down cleanly.
  */
 #ifndef HAVE_ARCH_BUG
 #define BUG() do { \
         printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
         barrier_before_unreachable(); \
         panic("BUG!"); \
 } while (0)
 #endif

The kernel I tested with panics and reboots:

 Kernel panic - not syncing: Fatal exception

Here are the BUG related kernel configs I have set:

 CONFIG_BUG=y                          
 CONFIG_GENERIC_BUG=y                  
 CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
 # CONFIG_INPUT_EVBUG is not set       
 CONFIG_BUG_ON_DATA_CORRUPTION=y       

Not seeing a "CONFIG_PANIC_ON_BUG" equivalent.  What is missing?

Unless of course you mean disabling BUG support entirely.  In which
case, this is strongly advised against in the help section and I'm not
sure of many development or production kernels that do this.

 config BUG
        bool "BUG() support" if EXPERT
        default y
        help
          Disabling this option eliminates support for BUG and WARN, reducing
          the size of your kernel image and potentially quietly ignoring
          numerous fatal conditions. You should only consider disabling this
          option for embedded systems with no facilities for reporting errors.
          Just say Y.

I've always been under the impression that a BUG() call should never
be triggerable from userspace.  However, I'm always happy to be
incorrect and subsequently reeducated.

In other words ...

Is this a valid issue that you want me to report (in a different way):

> Start again, write a good bug report in a new thread.

Or is this expected behaviour and therefore not a concern:

> > > The BUG report came from page_buffers failing to find any buffer heads
> > > attached to the page.
> > 
> > > Yeah, don't care.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
