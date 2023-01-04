Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22C165D3F6
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 14:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjADNRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 08:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239460AbjADNRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 08:17:11 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA688115
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 05:17:09 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 186so36430921ybe.8
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 05:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g2m/uNsCm/OsAUZxAnJOSdXXDa9Gh4wg88n4VPL2lMU=;
        b=Q2JMYE2NubaSNhtBdqAJ+qq3LVMB5K933ibDcHS1fl6kXa7elTC74ulV0cXxu6zsMk
         kPbW4doE+SvB63kWnATd0krnFxqzkmn8Cf6R06osXWP3qwtBvJQp/kHKEY5ECDSRI9lI
         qMNON9Rl96Ap3N4zlsh3u+jg5ughqyxYZ8mL9Z5RykLmp9PT8Jd0w7epqBA2+kByjo49
         Iixx9Kj0Q9hUE7jrk3EV1fq/4DJ2rEd/DThVuoBPt7pkasrSBEz7fXPhYaZntWefcrN1
         Z+hZWdMIvcWcGIHjzOKrfJ6zYS0bhLzRohL8BBJUVXD209EYuZvrqTu6BnL4e0bebAt+
         D/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g2m/uNsCm/OsAUZxAnJOSdXXDa9Gh4wg88n4VPL2lMU=;
        b=OIENQleEwjx3rqgiTtKcstqjxr0ZPwsEWXYOAQN1lAIRq3Ee9k6+5JbBfxTm7NxU7r
         st7CNqquwjaJ0MB/a6tyb96Kpm03KXMKwpLBtJaZA291VrdkS9EFRGFEhAGPbUjdKGcx
         EMlMk4BUf41dabFiSqSWJbouoLAPu/9cnhAMoIp9wmQ079knw51dVSskL2hIC+t2MDoY
         eYCeuh/8V8LtUVLWUQgWr6CSsijtdYOokgKFGiNEqoNiHUrSwFmswmplDcEoM6xjOUie
         aqHSzVkLwht8jP3c1QD2/kOrPLKvbMc3k9jTHTsaXrS4goOUMb3XiLA5U/wMrerxA+WM
         bpAA==
X-Gm-Message-State: AFqh2krO9CY4EAgaIlJa4W0GjT20bxxe25fhrxscE8534J/agH9zQQJY
        7+t91X/NOsIxRYR7XMIqReK+fVWh27Byc63KD5M=
X-Google-Smtp-Source: AMrXdXtExRw6hMpxuBkSMSMWzYelyCi2yM3XyQui4BuENM4vhVUdV2FSRd/QN79LdBEZ2jp5+mjauC4wHG05H0j+DF8=
X-Received: by 2002:a25:aa8a:0:b0:74d:e2b6:d5fa with SMTP id
 t10-20020a25aa8a000000b0074de2b6d5famr4493140ybi.226.1672838228714; Wed, 04
 Jan 2023 05:17:08 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:5926:b0:315:93b3:4bd0 with HTTP; Wed, 4 Jan 2023
 05:17:08 -0800 (PST)
Reply-To: Gregdenzell9@gmail.com
From:   Greg Denzell <wisdomaka881@gmail.com>
Date:   Wed, 4 Jan 2023 13:17:08 +0000
Message-ID: <CADxX=FNsco+p7gRsEGNMsgSYuwm3hp=zsv4LON5V3JfWVV+iqg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Seasons Greetings!

This will remind you again that I have not yet received your reply to
my last message to you.
