Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726BF686630
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 13:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjBAMpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 07:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbjBAMpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 07:45:44 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70565367D4
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 04:45:40 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id g1-20020a92cda1000000b0030c45d93884so11440396ild.16
        for <stable@vger.kernel.org>; Wed, 01 Feb 2023 04:45:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V5gRBWvCrC4ivORDLYanYAKruxMNDrxF3nhXlCgZ6d4=;
        b=iQnNr0cAgPaq0aGUMVXzFUmeNEbBfEnqreGU99TcKlG/cS51PN+IxHNJjP/lPuCCrO
         B8wkoS9IV+Pj6M80fT+IvfZ1tvrAqQF9yf41ETAtqE/xRt8MM6cBFtuDnnAyM/3eYeyd
         DXFA3bm3rzFfjxV4puaDq2DytQBbcpcpHoHkbtDUIk9FKoJtj5bBN4VlxdJXlIBtVgCo
         x5PkIxIwgFoZh+QFTV43HFyobfmkhg+Wyhi2w+NJ53r8I9RDawXtctbdLRuOLiR0a/p1
         XjI+oeRtb2BUsxeXfUmvg2pBXkjnU+u4VKAXcDd18VL6JsyWqlyfNgHZCHEwtfMfrpHS
         JlKQ==
X-Gm-Message-State: AO0yUKX8HkPM4+eYv2QKKnassO/HZP5rw1PEzMh+7kCVQGazpo8dIJ7m
        lKx7gvTvCSNvUDEGRntsjEFh13iJ26/aUh/LkOg0ApJY3Pv+
X-Google-Smtp-Source: AK7set8i4uvYg6+GpTdMSIzx6vtF835rmgFlCdJGSpv7rq6MO3NDFTCc1cgEiGwQuSXfchipNn98YjYUH3i1f67LYl1nHTfNNSY5
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3a0f:b0:3a9:611a:928b with SMTP id
 cn15-20020a0566383a0f00b003a9611a928bmr461546jab.55.1675255539387; Wed, 01
 Feb 2023 04:45:39 -0800 (PST)
Date:   Wed, 01 Feb 2023 04:45:39 -0800
In-Reply-To: <0000000000006c411605e2f127e5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005555f005f3a2d3da@google.com>
Subject: Re: kernel BUG in ext4_free_blocks (2)
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
