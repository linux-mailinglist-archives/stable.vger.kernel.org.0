Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28E46D13E9
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 02:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjCaAO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 20:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjCaAOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 20:14:54 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDED12CE4
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 17:13:49 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-545e907790fso270002387b3.3
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 17:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680221522;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mE2z5KXeFL3H1WpC0al7EAIysfK8Gyrov8EG6hwjT2w=;
        b=MoPw3XISRQa0sGvO3JgEpaqRc+busMmDgNCecLvshmcSzm7m1XQOWB7OiXZ2g/2xjM
         OMiuB9yKmdKicPyLAbNlnFuVRfrpulh5nxHyHFd1lfgINCl1BFOrsnEZ6MgjmOnha7wX
         gYzPfEKXp29v7x9bL5ubTrpKGwd7wNhthPb3tLP8bA/5BRWjvkQCpvjTedb76f/jH1Pa
         kzN+V8rXR/1FcIJr2v2PjzYZcjTnPRAXffjlDfOieYApOcSAZSEAGLZPgM8uQ/WCL/3m
         ulspzihNWST29Sn5UG7e1pjv5H2mi1dSSF1zMNJSW71BMGuAqTZbsgUEbqCJp++zILPa
         77Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680221522;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mE2z5KXeFL3H1WpC0al7EAIysfK8Gyrov8EG6hwjT2w=;
        b=ebREVox/67Gj/y96dE7Y+ZGn96j9GRv3zidx4ZxVfMh1dBQJgofHR/P3F9kbVLFKT/
         3cuNdtdf78XPlhykdeHBraFiPG+/DJocRzbhuJqv37YJ8BI/UdmPYWT/ufm7t2M+bW5R
         jL0pko9O+3P6yWIGvDHQUprMN8FUCAyQuACht1YqzMc0Mi36ewTVga2DaJUh9ZHrxy6c
         15oLwEAp8Ag00qFHe4mrjLYJ3ZxqpQ3LqoO/cR3oBDcfeaft9SXeOoJlh4HpVDbxbc4k
         xNe/jgHAIzFSFsstR+tYz0pWRY742XYz3ff53iOpb+VqVuDB2B2ZRXgxePH3Xm3lNDVz
         l79Q==
X-Gm-Message-State: AAQBX9eV2QRa3CUkhRsXAatyi6KCLWh/WpxPpUonSfg5kdbz42Q8UUAR
        6o39YRdtyIH3IlP90MLhMvDM6t/xFEztVPFCbu9Vzs4BhAyp3vgAzSJUXf5H
X-Google-Smtp-Source: AKy350YFiw9LYi0Y9vCTisoqNlHHoTPWK5ec2OkXHs8HaMWHw1Ff2DAAuxe2jerSfml5d0vjfhLG4yIkSwYSPJVB8oI=
X-Received: by 2002:a81:b388:0:b0:545:8202:bbcf with SMTP id
 r130-20020a81b388000000b005458202bbcfmr11880863ywh.9.1680221521838; Thu, 30
 Mar 2023 17:12:01 -0700 (PDT)
MIME-Version: 1.0
References: <CANZXNgMFifsEAUjCOtQWwxbZRbSvEYZz_Bwc4zrU6esb3xYRLA@mail.gmail.com>
 <CANZXNgPgFwPSgz1-bE-CfTu1bgPgjKQVw8d8SqydVZe61J_41g@mail.gmail.com> <ZCYcLCfRwemynhS2@sashalap>
In-Reply-To: <ZCYcLCfRwemynhS2@sashalap>
From:   Nobel Barakat <nobelbarakat@google.com>
Date:   Thu, 30 Mar 2023 17:11:50 -0700
Message-ID: <CANZXNgNQGbP5Sd1+Eu55UfLWv_uwa=JdCvTDP=tchdmaVHT7+Q@mail.gmail.com>
Subject: Re: 5.10 Backport Request: ovl: fail on invalid uid/gid mapping at
 copy up
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here's a link to the config we use:
https://cos.googlesource.com/third_party/kernel/+/refs/heads/cos-6.1/arch/x86/configs/lakitu_defconfig

Also, no issue here in this thread. The buggy commit looks like this one here:
459c7c565ac3: ovl: unprivieged mounts

Since this landed on 5.11, 5.10 doesn't need a backport.
