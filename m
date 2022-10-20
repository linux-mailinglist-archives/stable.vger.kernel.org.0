Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5235C6065D8
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 18:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiJTQcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 12:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiJTQcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 12:32:33 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2781AA267
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 09:32:32 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id u11-20020a6b490b000000b006bbcc07d893so16883639iob.9
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 09:32:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UKNN3axs1y811QkhsVcYtMf113asLOYvCITq8yCsIOI=;
        b=TKQJubfkR7dIgJLU/lb3sX07YHQnUSmBJC30lAoue9LGToRI+nTq+EaroohdHY6iB9
         9CnCIsAOUVcvD/10Y8ggHu1j9x2JYClxK9KZutAGKWep8kypXdtH6MShAcjnMh1e46l1
         HVfX7dYqGhr+6XzuYs6oTiRIBOzBoLorRiyn9Ck74wFppWW89MVojJiiJP5eSALNU6yI
         xwvEuQfPnxIIQ3ev3D6nM2MSfJ7d1CIzDtJvHnkjvPwjpskIVH+bpVngWKnJ39Wo0FQb
         stGpwh8X7unnk3TbkfOJq3QgDvjZNkSznGb5iCPQeITZsFKJx7BvopOOcbVo8Ivhqxe8
         X6BQ==
X-Gm-Message-State: ACrzQf1CZRrIy6kWX9wpoMWy07v5X/tv94Ec1yyg6FvJSFD8dYZdZdCd
        JxLQRrDUeHjKSmVHRgHrr3edZAg/f6WcK2nqvJvBgE5bA4N1
X-Google-Smtp-Source: AMsMyM4FPk0iRiokf85qWc1ZXECTEgMCQq+Q8VRal+EfXVpDu+LSoILYcUwg/tzPl125RD3+HZ/hveGyU+kyJ/AQ4rT8VBRuhcH/
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2164:b0:2fa:e426:dc5e with SMTP id
 s4-20020a056e02216400b002fae426dc5emr10321935ilv.213.1666283551925; Thu, 20
 Oct 2022 09:32:31 -0700 (PDT)
Date:   Thu, 20 Oct 2022 09:32:31 -0700
In-Reply-To: <0000000000006c411605e2f127e5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000352cf605eb79dfde@google.com>
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
