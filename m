Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB0F646E18
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 12:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiLHLJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 06:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiLHLJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 06:09:27 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D067594935
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 03:06:17 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id a14-20020a6b660e000000b006bd37975cdfso510351ioc.10
        for <stable@vger.kernel.org>; Thu, 08 Dec 2022 03:06:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MFNEjikdDKIGbIXcuAlk/+ki2ZmSz9fWBbGY16JNQhU=;
        b=HGP8QB8hWJw7lKAOZ0OfoHRYaupzjnmNfEbfzAa49rEMiE3x3Aw+ikYWniSHDh17wz
         iI92RtY2XXGhYBmfM9sOZnvM06OmQrX9ZsrGn79jWco7CqBtvb20HoqieietcuFk+BWM
         tU6jXbhzHvVmsuZCsgEPYQMLmfNM9OtfM0X6VF4HeBKfklRWDTHiXE2i/Or9bi3MT9c2
         Bq6FrTgNcNDyeRIzVrOPqCVADBob1+UvgY77ytvKnLi8cAkegzazPUi9RXwa0SaW2Rqu
         lWfL/6YoI8oL7qTPA74oRGmCbAvnUfo4sG38QUfO8E5/OkBtb21+QajmvdN6WgKl9LUJ
         Gh2g==
X-Gm-Message-State: ANoB5pkd/zJm02p+lglx3G9w874eBGTIJsqYPRJEpLfGp5f4D1UYap1r
        BsjkyqoNWxQgpwETvPNkXadD+abI6oBTXW3EZQnx7Ab7TzHf
X-Google-Smtp-Source: AA0mqf6ZFw+5uYrfGquMZC8eelXMMwS1iAYVUo6vrzG+2km6Vk/VPAS7q7w8GQZUQzcZID2VZkquqKsEGkaClJQJC7YhB5cRVXGC
MIME-Version: 1.0
X-Received: by 2002:a92:870f:0:b0:302:501a:a25d with SMTP id
 m15-20020a92870f000000b00302501aa25dmr34269679ild.311.1670497577197; Thu, 08
 Dec 2022 03:06:17 -0800 (PST)
Date:   Thu, 08 Dec 2022 03:06:17 -0800
In-Reply-To: <20221208032216.63513-1-chenzhongjin@huawei.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000afe93f05ef4f063a@google.com>
Subject: Re: [syzbot] memory leak in tcindex_set_parms (3)
From:   syzbot <syzbot+2f9183cb6f89b0e16586@syzkaller.appspotmail.com>
To:     chenzhongjin@huawei.com, davem@davemloft.net, edumazet@google.com,
        gregkh@linuxfoundation.org, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, stable@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
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

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+2f9183cb6f89b0e16586@syzkaller.appspotmail.com

Tested on:

commit:         355479c7 Merge tag 'efi-fixes-for-v6.1-4' of git://git..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=175b5b23880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=979161df0e247659
dashboard link: https://syzkaller.appspot.com/bug?extid=2f9183cb6f89b0e16586
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=142313f3880000

Note: testing is done by a robot and is best-effort only.
