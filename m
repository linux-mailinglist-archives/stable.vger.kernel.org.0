Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F136E99AD
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 18:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbjDTQiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 12:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjDTQiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 12:38:22 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA09106;
        Thu, 20 Apr 2023 09:38:21 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-54fbee98814so49745417b3.8;
        Thu, 20 Apr 2023 09:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682008700; x=1684600700;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ccpsSY3ERk1URSjttzJeLZAr0vtyarq8vGkCgMh7vJY=;
        b=U8VyXZT3Urf/8X3F/z5mG98Iz+q4i+kqOk4R4APRrwyGB7HGN1zBZxU9aFSA/aTvN/
         B0eVoN26FrP8tIjaRL8/DT2eRgEAuhT1Eu0UoZHbGTyRFa0n+wAmNBCsE5uc56U0fYkE
         +j307x0YYQMQuV1uxJ6hPRgu1uULZZz7l1VgtQ4tcDBMfqZAqzpr08p1+F4GmpRwdDYB
         TFWl1lGKt++kpdg56RGSzApgVDWmItey12mMO2CHOE2EVaYlyrm8nw1V1U650j0+tG81
         21cNNFWVCuYP7A6vpppN1JHZtf+O1BFq7kSxPt0BycgVwLRe/H7avfbU4/pIyd+vwZr4
         Mlbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682008700; x=1684600700;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ccpsSY3ERk1URSjttzJeLZAr0vtyarq8vGkCgMh7vJY=;
        b=lsJSbPSfHIQtgaHd+G5ioRMtJld3JCbvxz5A/xDKAVZCl6bDub54J/euYs+WMqu6Uf
         FpLA8axtHmH/lXH+oaiey09k0XIiFfkKVTu5Tr8GKPg4uLQ2Q3i62SiSIeOf6K3u5kHz
         eqePcxj4PY1RF/GXSgxA+hUjIsI5rKnGBERi0/sABVL9y4uIqfJC+SW21jNd1ogTgiE3
         2baht87/mbj90d8+ERTC9MPIXnk29vplRREjUjDPtzO4HxLyZuzxzLsa30VFnYf6bdvt
         baRc9hzH5pkyegoEGzmWMlKUHl1DvNRQoSq0UIYtsd3ytNOb9zw44UXCaGR+2jqMguRf
         XiKw==
X-Gm-Message-State: AAQBX9dYTuGoKI4rI6mledYIL595U1jekJwUrlv0f/a/y2OSmpE8c0KI
        86i6Q0p7zN7O3EQRamQIHq31JgMxSD9VMj3ikmA84tvL
X-Google-Smtp-Source: AKy350ZW06n8Nzw/xL/+2RhdtLXQJA+RXEwLeFZJPvdO/1WRzQTuUQ4hfo4Gz4ZhNgx+cNe4C8XwTi5UyV7m54AGX6U=
X-Received: by 2002:a81:6d81:0:b0:54f:8b2b:adec with SMTP id
 i123-20020a816d81000000b0054f8b2badecmr1335945ywc.33.1682008700162; Thu, 20
 Apr 2023 09:38:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAK4BXn0ngZRmzx1bodAF8nmYj0PWdUXzPGHofRrsyZj8MBpcVA@mail.gmail.com>
 <2023041711-overcoat-fantastic-c817@gregkh>
In-Reply-To: <2023041711-overcoat-fantastic-c817@gregkh>
From:   =?UTF-8?B?0KDRg9GB0LXQsiDQn9GD0YLQuNC9?= 
        <rockeraliexpress@gmail.com>
Date:   Thu, 20 Apr 2023 22:08:09 +0530
Message-ID: <CAK4BXn30dd3oCwcF2yVb5nNnjR21=8J2_po-gSUuArd5y=f9Ww@mail.gmail.com>
Subject: Re: REGRESSION: ThinkPad W530 dim backlight with recent changes
 introduced in Linux 6.1.24
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-acpi@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>Any reason why you didn't cc: the developers of that commit?
Sorry I did not realise I should have done that.

>Do you also have this issue on the latest 6.3-rc release?
Yes I have tested it recently by installing the latest 6.3-rc7 kernel
, and I do encounter the same issue there. I have linked the
screenshots below referring the same.
Kernel 6.3.0-rc7 with 43% brightness - https://i.imgur.com/5LqsEJb.jpg

> That's what this commit does, right?
According to the commit , it was pushed to fix backlight controls
which were broken on Lenovo Thinkpad W530 while using NVIDIA. It was
not intended to reduce the backlight intensity on W530. Backlight is
dimmer than before even when using the laptop in Intel iGPU mode.

Thanks
