Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08BB6184CE
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 17:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbiKCQgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 12:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbiKCQf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 12:35:59 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B7920364
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 09:33:35 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id f17-20020a5d8591000000b006bcbe59b6cdso1376928ioj.14
        for <stable@vger.kernel.org>; Thu, 03 Nov 2022 09:33:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UKNN3axs1y811QkhsVcYtMf113asLOYvCITq8yCsIOI=;
        b=oBXHngmuicM4PNWwhP4dk+QqBJAFA2fhKQfMhCVtsqmtFWltIjHsQhlA7nMv3aLElx
         df/+XUYYpmBQQW0Xnn3y78V/sbDrwq/JeYQ8wpereNxuum8SGQZlysWGOHbsOvpNoZXn
         mxx3GuZrECSmbuaG6qxolH+I83ab9jB6yMQFDwL0tkzd4YpohwH9DwmrQ0v+mdGay8bA
         EzNePwXn8kzrNLuYoSFAG1AhbdmYodoZOFihHC0db4doPHSXEwoJDaUAh4zoYG0kfJ1z
         J1RGOS00S+0PvvolLRWT2DN0bSICRx+g2NiQDqgFiCK/B/I5/PDwJGA0E2k7wwIF5l4r
         yXow==
X-Gm-Message-State: ACrzQf3W9g4l8hrinXGNwLSaDhMRQoYhRpRJwtgCRCGW6a3zY5lzBBL9
        sJuWMnHeNdFVcEwKWWs7IKuH99ZYUPgEPskD8o6yOjfuCYOz
X-Google-Smtp-Source: AMsMyM7KSJB6PWib48eKCxQUGgM9eEZ44KGU/yZr/h+0TvMEyV3kVSaOd9iNcRMOcT+ns/pNcS3sdCIrBgqGzgxiYveDSCHWMtL0
MIME-Version: 1.0
X-Received: by 2002:a02:c850:0:b0:375:4602:f1ac with SMTP id
 r16-20020a02c850000000b003754602f1acmr18201927jao.45.1667493214829; Thu, 03
 Nov 2022 09:33:34 -0700 (PDT)
Date:   Thu, 03 Nov 2022 09:33:34 -0700
In-Reply-To: <0000000000006c411605e2f127e5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc45cf05ec9384ab@google.com>
Subject: Re: kernel BUG in ext4_free_blocks (2)
From:   syzbot <syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, gregkh@linuxfoundation.org,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, syzkaller-android-bugs@googlegroups.com,
        tadeusz.struk@linaro.org, tytso@mit.edu
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
But I can't find it in any tested tree for more than 90 days.
Is it a correct commit? Please update it by replying:
#syz fix: exact-commit-title
Until then the bug is still considered open and
new crashes with the same signature are ignored.
