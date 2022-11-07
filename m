Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA2A61F374
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 13:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiKGMhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 07:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiKGMhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 07:37:31 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DA51B9E1
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 04:37:29 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id x6-20020a056e021ca600b002ffe4b15419so8583783ill.4
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 04:37:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G4j4i1D9g/K0Cayton2okA3A9p6eYtwnuNOgUF/2ByQ=;
        b=BGGCjQ3OHTDRjelyfUL0NvjD7uLogsQ0bR+CluuEcfdceknL6hFrheLTAyd92xEKWC
         zZL/tflxjRAjLxX7QUEIBjj4z31cACImDN1FyzyhgyUwftZf5jACbiTqjj+97f2Yb/Es
         BpLoDoO5jQ63qjncQmHgbFFdHopvI/vA8ynD7zS2CVSoqP30LcTZ1IdSQnhljRb+CQ5D
         N/bC2+OhyDwyWKJiuAHuQ53GjkClLVwB50Vggs0vo2H+pZ+13Gwy8Zkj4YsEhSf5ZTUj
         pUpm9G2u3KAYZb6yJzxf8d7jPEI3QhKNYEUJTHi1p/o0io8pFM35R+fcr9+ypEY/mers
         FVUw==
X-Gm-Message-State: ACrzQf3/BlusJ222itpp+3TnkYsCG52nqyEAtWF4tuke4MIgcbYxJnP2
        0cKyxj731vt7Q0OhSVAFpctryhdmJ06JEWYbwF2GLcSNxyv4
X-Google-Smtp-Source: AMsMyM7hL2RBAgD8t+s2gyQ+GiR0UO0q3NHbLXrJlSmqrZh6R4WmKFa8dNIEZN8EXbW1Ib8B16CXhBZMKKoRRN9U5sAUb6W/TsYn
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1586:b0:6d8:22c5:102a with SMTP id
 e6-20020a056602158600b006d822c5102amr9042086iow.156.1667824648749; Mon, 07
 Nov 2022 04:37:28 -0800 (PST)
Date:   Mon, 07 Nov 2022 04:37:28 -0800
In-Reply-To: <000000000000c3a53d05de992007@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc92bf05ece0af6f@google.com>
Subject: Re: kernel BUG in ext4_writepages
From:   syzbot <syzbot+bd13648a53ed6933ca49@syzkaller.appspotmail.com>
To:     gregkh@linuxfoundation.org, jack@suse.cz, lczerner@redhat.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable-commits@vger.kernel.org,
        stable@kernel.org, stable@vger.kernel.org,
        syzkaller-android-bugs@googlegroups.com, tadeusz.struk@linaro.org,
        tytso@mit.edu
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
ext4: Avoid crash when inline data creation follows DIO write
But I can't find it in any tested tree for more than 90 days.
Is it a correct commit? Please update it by replying:
#syz fix: exact-commit-title
Until then the bug is still considered open and
new crashes with the same signature are ignored.
