Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168886312DD
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 08:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiKTHkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 02:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiKTHj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 02:39:58 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2C39039A
        for <stable@vger.kernel.org>; Sat, 19 Nov 2022 23:39:58 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-142b72a728fso2900222fac.9
        for <stable@vger.kernel.org>; Sat, 19 Nov 2022 23:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RdE8w9lyiPob5kTdJ2Fc5IBxgiPNnee9THw/ZL11D0s=;
        b=FkWYZD8XMbf1NtCTb4ET+mG1r6veZORlPvznDQleXH2WTwI2eky7Ue27q0D2HTjW3p
         p3aaAoHRzs1VR0MKdBe6dQMNnBldBiPCORFZu5NHhHuo+0c6sCORGqCPSfIVOUnOE4Iy
         770UyM4ubjlqlzSVmlzAqtLGIl/0KsOmBf48xxmfSq3fhe+qiudatn96EUlzN9kd0iLb
         T5PHSQWNiE/ABPM+WTPiz0XnzpnK99b2aaid7WPXXd2qkwtEakggt/UEDgx3ILZnKBCM
         6BBkEZMv0606lo9YPMV0vt29SWfku8UzVZLjMNXyQDnGbdWmmQy/NJybG69UdgX4GjHP
         rstA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RdE8w9lyiPob5kTdJ2Fc5IBxgiPNnee9THw/ZL11D0s=;
        b=t8P6SPUB1ErSkXgRAHT7FsXf9TWrVhhnCuq4Q6VpOe/vfHEB49nm1LfF0ktcB3jGvQ
         dddBuh3OoFv6mfT45XsTZ2oGMpt8nAcOcEd0RKpZUvfqI8WO7g1eM3yEXYAnE1qInVBw
         6gT1mfDijL1q/CHCoNwkrzxyApUPnwj7f0Oa4wnJSdi8dvA5pfBH3G1hkAVgTPErByR5
         caMKJDc/KySagXPJMwMbBpnKr7qSd7yVXAgQoPIFJU8otWQ9iJ1p7PH/WsrNR/lHN+L2
         5C4XJxrSiZwcqJ7XVjOSmCfyPXQwGo5xrazuQ7iaVSf8dCMffzYUiFTS4jDwIvKTAK7c
         sj6A==
X-Gm-Message-State: ANoB5plZDEyHTs+r7PvK2c4npw7jOwWV2Q6EJdJ7MjwK53Wmah6eqPGE
        1SzdijTzqZKK2raMQnbxHFJ01VHdpyqF3sbVpzs=
X-Google-Smtp-Source: AA0mqf5uVkGfBEwoct7wxTqSz4xs7ooi/VQfbIcdA2kQKSKZD/grRL1E0a9aboLyp9RME1lOOF1//60HAl+wzJ7j+nE=
X-Received: by 2002:a05:6870:2b17:b0:13d:843c:76f with SMTP id
 ld23-20020a0568702b1700b0013d843c076fmr10734116oab.165.1668929996327; Sat, 19
 Nov 2022 23:39:56 -0800 (PST)
MIME-Version: 1.0
Sender: missglory.kipkalyakones24@gmail.com
Received: by 2002:a05:6358:538a:b0:dc:ac91:4f00 with HTTP; Sat, 19 Nov 2022
 23:39:55 -0800 (PST)
From:   Aisha Al-Qaddafi <aisha.gdaff21@gmail.com>
Date:   Sat, 19 Nov 2022 19:39:55 -1200
X-Google-Sender-Auth: w3Zoojy46PZIKZuMqDxNeWmOum4
Message-ID: <CAGTUnnrUjzKpPB+NFs3pbXQZXHQj5DYo_tjBMheBWmk__To0hg@mail.gmail.com>
Subject: My beloved friend
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:2d listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8703]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [missglory.kipkalyakones24[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [missglory.kipkalyakones24[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Assalamu alaikum,I came across your e-mail contact prior to a private
search while in need of a trusted person. My name is Mrs. Aisha
Gaddafi, a single Mother and a Widow with three Children. I am the
only biological Daughter of the late Libyan President (Late Colonel
Muammar Gaddafi)I have a business Proposal for you worth $27.5 Million
dollars and I need mutual respect, trust, honesty and transparency,
adequate support and assistance, Hope to hear from you for further
details.
Warmest regards
