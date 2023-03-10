Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF406B3FC2
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCJMyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjCJMym (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:54:42 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEEF7606B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:54:37 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 132so2946878pgh.13
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678452876;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=btO2PgELPxeu4g7GKPisTapV5oIPPjmXF1bimiQ62f4=;
        b=EvPCwvow+PkjQ3CVL5rx2ocdziXwT1ZM3Mvj0x9WOclfcUMZD6Zmy++Aw5KPO6ba5n
         6E31hcMZFbU5tRTr+1H7SkkUKue9TFwmpw8TfMHoiG1HH/bg9e3UIM26NGgkHXdpe9Qi
         J4PlgCFP0YJssDvYDKMkwYFcwBlLaCjbdv9so=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678452876;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=btO2PgELPxeu4g7GKPisTapV5oIPPjmXF1bimiQ62f4=;
        b=PaVkKK6XHuIANrj7c7QPP8NjtOhQSkMGS60kiwGg8ZTHOvnn6IdMQ2S4n2YG/10EP+
         hnym1uHDzpF+re8Bu3G2SfO/yz+41UC2ekbEmfroRifqyoKH1u4A/TC+wYcBr05x3Ghl
         4XnmjIvxe2GtNLglxCE04uQ6iyhJ+66S7DouQzQ49RUPUJxBThhVKH9IY1WSm6bItbO2
         ys0TnKZqXVRUojEFcTT0UqFN4cFORPo18kZfssWkR3QW2k81oSxgKFnK9aNmdsxcegbM
         RZC4ekcn4eUBfJRa5n68Q/9YNOt5Dr+oyBaJMdLefNCRR9/XiX+Y0HCL4oXSkKBbBQVl
         /dQg==
X-Gm-Message-State: AO0yUKVJBd0SR2iHiQtzhVgp/YRz2+ijnicmW1tm6m+U6Ec9QeTWjOET
        wgQb82JZveJjfVSuG5xh15j0q696wQsuPuvgiW1AuA==
X-Google-Smtp-Source: AK7set/kt+EKWYN1Y/omupRAjro1UFlePJ7vi76G+2eR60ecDlajt+peXS+UjbwbLSa3GQ00HwNmnw==
X-Received: by 2002:a62:1ad4:0:b0:5a8:d407:60f9 with SMTP id a203-20020a621ad4000000b005a8d40760f9mr20151853pfa.29.1678452876316;
        Fri, 10 Mar 2023 04:54:36 -0800 (PST)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com. [209.85.215.171])
        by smtp.gmail.com with ESMTPSA id u12-20020aa7848c000000b005d55225fc07sm1357974pfn.73.2023.03.10.04.54.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 04:54:35 -0800 (PST)
Received: by mail-pg1-f171.google.com with SMTP id 16so2949342pge.11
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:54:35 -0800 (PST)
X-Received: by 2002:a05:6a00:1151:b0:5a8:aaa1:6c05 with SMTP id
 b17-20020a056a00115100b005a8aaa16c05mr962432pfm.2.1678452874844; Fri, 10 Mar
 2023 04:54:34 -0800 (PST)
MIME-Version: 1.0
References: <1678450464220237@kroah.com>
In-Reply-To: <1678450464220237@kroah.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Fri, 10 Mar 2023 13:54:23 +0100
X-Gmail-Original-Message-ID: <CANiDSCs47_90_=S+n5rbUr4az_VZ_86CRCKeXm_zoqRpRDdG1Q@mail.gmail.com>
Message-ID: <CANiDSCs47_90_=S+n5rbUr4az_VZ_86CRCKeXm_zoqRpRDdG1Q@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] media: uvcvideo: Fix race condition with
 usb_kill_urb" failed to apply to 4.14-stable tree
To:     gregkh@linuxfoundation.org
Cc:     laurent.pinchart@ideasonboard.com, yunkec@chromium.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

On Fri, 10 Mar 2023 at 13:14, <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Kernel 4.14 does not handle the control changes on the status urb. I
believe that we are not affected by this race condition.

So we can ignore this patch on 4.14.

Thanks!
