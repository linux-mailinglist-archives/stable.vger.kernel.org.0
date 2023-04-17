Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B138D6E4E8B
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 18:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjDQQsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 12:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDQQsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 12:48:45 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5E8526A
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 09:48:44 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id k39so4789668ybj.8
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 09:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681750123; x=1684342123;
        h=cc:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0wQCASjv8KKOoU5L1HNK/ucgvfc9Dmw3t999ATUqHBw=;
        b=qahgp1DAdTUbJrhLL/EGZtfWQfJMkW1cAo5aFM8B9icm3+Q0EA7/WGlUf8o4NluQlg
         RfXbN3wgTM9PhOQHWMfXWG2lAbuYZot8OVimiPp4TPXXtO3BsMWr64V6FcZNqPwrJFu/
         /vLrki9aLggbAqPGeQYwwVCRmaePEeyC2qDqB3pzae2ngzFX0XM30OmY9ArBYooyfRuv
         OYuRqotrNMs1j/88bRX4tHTs+WTLWSENn4AIPJ9fkXAor7QCsjZsbnbCQdhb/e981ByS
         4Vhrm6UBqbf6jRjmyIOdpT+O984HS0U0YRP3cMG03Xq5VxaDrr037+FGHCv/yv2LBuoN
         EbRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681750123; x=1684342123;
        h=cc:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0wQCASjv8KKOoU5L1HNK/ucgvfc9Dmw3t999ATUqHBw=;
        b=YPmE8VtXl2X9ZNqyMZOFO9JiRMiGFCVnxr9PZY+HHuU3PG/IpjOd1AjJE5y05rGw2h
         v5JCYrAjQZJ0Atgz86sDb0moM28lIhqpvjd7/mkPIVxDUdMCQ1MOA/YeK5rYxtqxXu68
         SI0+NrI0gupfjMeYeJT6v6Bfwc38j0C1RhjyKogY+EYAuCATM/+7/V+DuRCSv337hLXb
         FNrjswAUjVftkXnhXOxuZDHu3imm6RDTSiqjt8KqOV6Sy841MRirI2otIUlelEfCu5fo
         0DHs+81n+3FXqwoCqNp2onvNHlP/NK+oXS5g0WsWZb1O4MbzfHuUOSPxR5HnAVvI+JHK
         +yQg==
X-Gm-Message-State: AAQBX9fJelix+drX0SQZVPzNPbq7J3EX/oLn9QkkJSDkkS7SeS2nFfi3
        VDAUDURXl6gtbp9AFE4xccxvwsT1K4atlFaoHyZDmvIb
X-Received: by 2002:a25:cad6:0:b0:b8f:6a10:7654 with SMTP id
 a205-20020a25cad6000000b00b8f6a107654mt7540119ybg.5.1681750123562; Mon, 17
 Apr 2023 09:48:43 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?0KDRg9GB0LXQsiDQn9GD0YLQuNC9?= 
        <rockeraliexpress@gmail.com>
Date:   Mon, 17 Apr 2023 22:18:32 +0530
Message-ID: <CAK4BXn0ngZRmzx1bodAF8nmYj0PWdUXzPGHofRrsyZj8MBpcVA@mail.gmail.com>
Subject: REGRESSION: ThinkPad W530 dim backlight with recent changes
 introduced in Linux 6.1.24
Cc:     linux-acpi@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HOSTED_IMG_MULTI_PUB_01,MISSING_HEADERS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Due to recent commit a5b2781dcab2c77979a4b8adda781d2543580901 , I'm
facing an issue where the backlight is dimmer than before
in comparison to the backlight pre-commit on my Thinkpad W530.

Downgrading to an older kernel version fixes the issue.

I also realise that this recent commit replaces the intel_backlight
folder in /sys/class/backlight with acpi_video0.
It is also worth mentioning that I'm using Nouveau on my W530. Below
are the screenshots highlighting the issue.

Kernel 6.1.22 with 10% brightness - https://i.imgur.com/7znm7xg.jpg
Kernel 6.1.22 with 35% brightness and grub parameter
acpi_backlight=video manually set - https://i.imgur.com/nD9O7pD.jpg
