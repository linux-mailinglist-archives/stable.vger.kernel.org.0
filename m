Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1426A6C8E
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 13:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjCAMqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 07:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjCAMql (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 07:46:41 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7435B1C582
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 04:46:40 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id 2-20020a056e020ca200b003033a763270so7749217ilg.19
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 04:46:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V5gRBWvCrC4ivORDLYanYAKruxMNDrxF3nhXlCgZ6d4=;
        b=iEppxQb+G7sA7vm1w/WbxSlZxPjcrJ6tHn+FIHODS4ionG7Y+w6AYY54Zi4xdT4ggt
         vtUGdlawbjDBPiswlPSI07s4gmdW0H1VwMeo7fQHZQcyZStBu3rBUgj5FnuWkkjkCREE
         r7zbJPN2nKZheNiisREfzD6swVGciFcAdUVYaroNjuQip1CtGRc1QGTmNjl/s34vcg06
         GS/RqKzSoDI+dtsfo8Wb5B98UijurLE0rHU0NykeRILMax25csRUdHR+VqjInuPDuM1v
         bdto8vXxvWjQ8bErfo0ashJsGXrA567VkYxUT7yjjSb+kgCHwHDXUujcYVuLaiVT10gH
         z3vw==
X-Gm-Message-State: AO0yUKUbckI6h9etM4jJ8QIyEbypgCWj75gZixrXvDKQrwUBUSj2XNG9
        ZAqU4ouxZII2h5dYhDLsIuD6n+2PnoSvDbRmIFmaHvCBTX0C
X-Google-Smtp-Source: AK7set+jinAjUAWYrdG6kv0VrfxDnBTCXLpXXJuHSxiCG5jjotaU+gO2m6Gn4BjUeDtSSYYxYS1qjF7hYGwhrzXiIgt3sUFd+X2Y
MIME-Version: 1.0
X-Received: by 2002:a92:ae12:0:b0:310:d348:e59b with SMTP id
 s18-20020a92ae12000000b00310d348e59bmr2898095ilh.4.1677674799832; Wed, 01 Mar
 2023 04:46:39 -0800 (PST)
Date:   Wed, 01 Mar 2023 04:46:39 -0800
In-Reply-To: <0000000000006c411605e2f127e5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007e24fb05f5d61afb@google.com>
Subject: Re: [Android 5.10] kernel BUG in ext4_free_blocks (2)
From:   syzbot <syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, gregkh@linuxfoundation.org,
        joneslee@google.com, lczerner@redhat.com, lee@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        nogikh@google.com, sashal@kernel.org, stable@vger.kernel.org,
        syzkaller-android-bugs@googlegroups.com, tadeusz.struk@linaro.org,
        tudor.ambarus@linaro.org, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This bug is marked as fixed by commit:
ext4: block range must be validated before use in ext4_mb_clear_bb()

But I can't find it in the tested trees[1] for more than 90 days.
Is it a correct commit? Please update it by replying:

#syz fix: exact-commit-title

Until then the bug is still considered open and new crashes with
the same signature are ignored.

Kernel: Android 5.10
Dashboard link: https://syzkaller.appspot.com/bug?extid=15cd994e273307bf5cfa

---
[1] I expect the commit to be present in:

1. android12-5.10-lts branch of
https://android.googlesource.com/kernel/common
