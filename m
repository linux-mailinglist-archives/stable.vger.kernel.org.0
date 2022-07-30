Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42ED585C82
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 00:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiG3WbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 18:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiG3WbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 18:31:13 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F05513D4F
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 15:31:11 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id r70so5976609iod.10
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 15:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=jqXOFQxV9H74VfljLrgSrcmI3wAqQeEEJFm+srEAUwROkxn5S9vp0yhcXDfb1Klv3N
         8EkIErBKClMdCodQ1E4BTMT6JWRT9t+FHM4Xbd37tVLLCmoLWaI9mWVYwvWWFBgyfhxd
         Q/FD7EC4U47Y39r3LRpkkWxtxjDLcXIRbaCUoWwc7CUBBOQ/shvm/nybgxzZoq/MqJuu
         Slhar/9kzbAOQadgX4Lf3yh/iphDAx0NakS3MSQATOXKnv6SHDAwYVdNYPpMvjbzlKaV
         X1hk+Lv/02+8hBZ5/q863vhQzIn13MzJUlAqjF7hVc9t/7w7BsY6F0G8ICC2pRO782rt
         vO9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=cOIhg7jvUORh2HZU7iZMDWe+R8btwx52ESqH+J96HVBqzN0V73cZD1LMQ/Yz0n0pTL
         YBGmjHy+/4MRJ3t5vaK1JJuvG1XhLExHcJ6BLqFUyVmcADV1mGDAFE/rt7s+K4dTYhCJ
         9AWC1JLoGQglJEBRtPFe9o+1ykQhKkD94wyyTgDVFvsxus88Nvj0qr7DsRl3nE0BQlQs
         9hnYdE9vO1YV16M2w526LsbomemeWEIZjhUNDffdcCGhMoScTmS2MKFMn0MUM/jo8Nl2
         pAql65cYnbtsyGWAx54mUVeu1iiGqSUAjse+2doc/AvDkOkw4INjB7AC1qoJzpmTRJXA
         mcxA==
X-Gm-Message-State: AJIora/SEDZbjSHmOFyqzRz9nZMS9C9L87oy+QOpXZszKLYTgwPNYbFB
        aecNoFCthrrKFvAaWkBkB79HrIaJHwUzCRWAu1Q=
X-Google-Smtp-Source: AGRyM1v3s3vbLJ2WPn+rm+d3jIH2GXL0Jb3KSY1ZH4ZOr9IPEd2CdOvbhTJzWUkUaUYbbu7l9K323EXiA6yPMOsDpRM=
X-Received: by 2002:a05:6602:1355:b0:63d:a9ab:7e30 with SMTP id
 i21-20020a056602135500b0063da9ab7e30mr3190209iov.119.1659220270440; Sat, 30
 Jul 2022 15:31:10 -0700 (PDT)
MIME-Version: 1.0
Reply-To: lisawilliams9656@gmail.com
Sender: nataliegeorge233@gmail.com
Received: by 2002:a92:c26b:0:0:0:0:0 with HTTP; Sat, 30 Jul 2022 15:31:10
 -0700 (PDT)
From:   Lisa Williams <lisawilliams9656@gmail.com>
Date:   Sat, 30 Jul 2022 22:31:10 +0000
X-Google-Sender-Auth: JBsvSC1JNgzEDvf93Nc_-IoP0oI
Message-ID: <CANK63C56da9HVhKKnZ55R+N0XUxOmL74FTqGqZPu0=2Qi+Pe7A@mail.gmail.com>
Subject: Good Day,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dear,

My name is Dr Lisa Williams from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks

With love
Lisa
