Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A219A445971
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 19:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhKDSRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 14:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhKDSRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 14:17:46 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F262DC061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 11:15:07 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id s7-20020a056830148700b0055ad72acb7eso8434675otq.1
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 11:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8AOIhXSdLv6thHvtwlXhKwgDm+rZnFoY0p2dfhU7+IM=;
        b=i+a2HGmDf6aAiBNu/l1wLDs7EX9R96ptURJeVQ6CisZTJPUpJ05zIB0ntX+TZAvqAM
         aV2O014Xw4Ln2yUdD6JSCfA5qsANoSW0rOLObjSEbpyLFGQ+X2OEuAM3AmMb+TxIxIvX
         OZ7qRdRoVBpXn1rKsnMIbpgO1Y6qP8KxFWv/E6pq9zQRr94N3L6JZqCtvO0NLI4pP/jC
         fIB+Z2X6IeWuB3I3RXCKuzOBVKiPzSroN3h4gfu3/Qpeb880My9tn92Da0Rew1sGYH6H
         CeBF0XD+kph8m+kcEFbADXD590DOn2xZKjQoSGKQd76yMCtRLrEaPfBkiJLuiMXu1jYl
         osEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8AOIhXSdLv6thHvtwlXhKwgDm+rZnFoY0p2dfhU7+IM=;
        b=J5los31gQw3I7x2zWUxlUwIGRAvYZMmgfj3fwNW6nNwzxuI7NL+nB7BbSt1uieMCY3
         BxUVh50mBceSRaOmXFGbdAOPp6ycYbRxH6wLm4IWTaK6xPCN+H9kDpV4Klz8GgYlMYrJ
         vhnTMDoGOfWG0V0n90qyoTu7Hln9EqJVD3BYY+Eh61hhasukTQ2EBa+6x4GDS9QdM0fp
         mPXwD7ntSqJ3HAMURbMq84TyelC1Hd3OwEX5Vt/xSI3FexClepEEIfqFGkxb2Co/A13r
         alWwzt/6hn5P58lMkdZ2sxHJjdkIMSO3+eN92y0/8b2OkhyHdM6IH7ZJGhTi1/mXe/au
         P5XA==
X-Gm-Message-State: AOAM531t1jakvnvN2JUPsSymrqj5BL3JE3dcv603kmQbc8M6zPReADm0
        3FyA4gos4CV1Zw2FJlbWEGnd5OSUvi+t5uJIboEerVgFd0BAUA==
X-Google-Smtp-Source: ABdhPJwj1BXq5dUHIfgpo+b5HUr8fE/443B3Qv651E5TuJg554h1qYNTmcqLqokmlb/UTXvSeGeB5HbVqCi7+Zk2wew=
X-Received: by 2002:a05:6830:47:: with SMTP id d7mr4991755otp.319.1636049706725;
 Thu, 04 Nov 2021 11:15:06 -0700 (PDT)
MIME-Version: 1.0
References: <CA+DW03VfQpOJUWAM9CZMCM4Vkw8KVbNWAxgsq-g615QPz_3=YQ@mail.gmail.com>
In-Reply-To: <CA+DW03VfQpOJUWAM9CZMCM4Vkw8KVbNWAxgsq-g615QPz_3=YQ@mail.gmail.com>
From:   Yi Fan <yfa@google.com>
Date:   Thu, 4 Nov 2021 11:14:55 -0700
Message-ID: <CA+DW03WPM1b_01eNB3cE7kVsp+tRbzv-O-=TvX627ATOUSywBQ@mail.gmail.com>
Subject: Re: null console related kerne performance issue
To:     stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@google.com>,
        shreyas.joshi@biamp.com
Cc:     Joshua Levasseur <jlevasseur@google.com>, pmladek@suse.com,
        sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Resend the email using plain text.

I found some kernel performance regression issues that might be
related w/ 4.14.y LTS commit.

4.14.y commit: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.14.253&id=27d185697322f9547bfd381c71252ce0bc1c0ee4

The issue is observed when "console=" is used as a kernel parameter to
disable the kernel console.

I browsed android common kernel logs and the upstream stable kernel
tree, found some related changes.

printk: handle blank console arguments passed in. (link:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.14.15&id=3cffa06aeef7ece30f6b5ac0ea51f264e8fea4d0)
Revert "init/console: Use ttynull as a fallback when there is no
console" (link:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.14.15&id=a91bd6223ecd46addc71ee6fcd432206d39365d2)

It looks like upstream also noticed the regression introduced by the
commit, and the workaround is to use "ttynull" to handle "console="
case. But the "ttynull" was reverted due to some other reasons
mentioned in the commit message.

Any insight or recommendation will be appreciated.

Thanks,
Yi Fan
