Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC16460BC03
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 23:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiJXVXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 17:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbiJXVWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 17:22:49 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0949A2EF14
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 12:29:31 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id j6so2685023qvn.12
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 12:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2pgON97R24hsg9v+P5f5K+Qt84YiBNhcGQVV/O2i/SE=;
        b=VCri1Qjm2uiHsfTxpzAMNRfyZrxieszzLF1paCJ95X4nKKZOLfZm+vTSBpVNWa0ZnW
         T9pbnqZBLPxcQ2b1zojX/JbvfJ5EO5X4icAvPtQXAFr14gnQmZ+Op2JkGD0WAhiSh+lb
         smuY5kyPAbeqafTpDs4P7WcgM5soksrH331R+J4f4eN8yV9BIDUPTf5BFzhRqUVOodht
         Fi/thfZiZtdxBmRDN73QAA5GUzvUav6bXdoI/hj7HSfsj9NoF4PNXYptElLlX4W9tCt1
         +eumV1IETS8s+jPAF9Omk6QadCNPa1lgSZObJfzmN1jBYPwJZmbKXhzgteLSWRl57a+L
         EScQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2pgON97R24hsg9v+P5f5K+Qt84YiBNhcGQVV/O2i/SE=;
        b=b0lD0SGt/LRzUN5aQlxfNc0ovocuUlUDgfAlXTqVZHak/du9jNXOyTMUQPB0WypA14
         8ZO8yjmHof/a5wjjIVENlwQmiodFNoFmhUt27z582UwnTNJgfMML89ZvXbltqFEGpLAs
         3j2oNB6Zp/ibPUNBRU32HkARuLauOQgmk5oDjyGPcMVGIjq3ZM8gMSqYmjrTd1dG9HVC
         jxdXMOHvxCQSw2xhtg7S+EobGjr8fGVm6VpB+SMYi+F55d+lhEfu7DKiyaAjNL6BLyrz
         u3SbhZ95tVsYTod/mVFYr2AIHstEXAx0yBqWm5EDEol49rxvucaBI3eWVg6Rs07BHaQn
         s3Tw==
X-Gm-Message-State: ACrzQf0nxzz9yAqq1jltz8X6A517+HttoCzlxv4oHh8AaI1dkXmhnxiK
        IMzZkJ7TP9olamzzgAjdv+VcQVmgBeZ1gAADvAVeNsx3
X-Google-Smtp-Source: AMsMyM6rzRLPPd/Hd7s73jMKUwPqt6axYP2rqXagWouP/Raq6+nNzpp+6rJnavL0ysZFdstl4C3xwiMkK3CMcq9hFhY=
X-Received: by 2002:a05:6a00:301c:b0:567:6e2c:45f0 with SMTP id
 ay28-20020a056a00301c00b005676e2c45f0mr31343975pfb.84.1666639039913; Mon, 24
 Oct 2022 12:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAHfPjO-gtcdvzgjm1o5NdS0bRy8ukyROH24UhWUATn6ouj07yw@mail.gmail.com>
In-Reply-To: <CAHfPjO-gtcdvzgjm1o5NdS0bRy8ukyROH24UhWUATn6ouj07yw@mail.gmail.com>
From:   Tobias Powalowski <tobias.powalowski@googlemail.com>
Date:   Mon, 24 Oct 2022 21:17:08 +0200
Message-ID: <CAHfPjO8G1Tq2iJDhPry-dPj1vQZRh4NYuRmhHByHgu7_2rQkrQ@mail.gmail.com>
Subject: Fwd: 6.0.3 broke space_cache=v1 devices
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SHORT_SHORTNER
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
https://bugs.archlinux.org/task/76266
as talked to darkling on btrfs IRC here the report for the to stable ML too.
My servers got broken with kernel 6.0.3, downgrading to 6.0.2 solved my issue.

My btrfs was using version 1 of space_cache, after upgrading it to version 2
6.0.3 worked.
greetings
tpowa
--
Tobias Powalowski
Arch Linux Developer & Package Maintainer (tpowa)
https://www.archlinux.org
tpowa@archlinux.org
Archboot Developer
https://bit.ly/archboot
