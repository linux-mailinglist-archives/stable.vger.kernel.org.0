Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D171A654539
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 17:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiLVQgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 11:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiLVQgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 11:36:48 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8514628E2F
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 08:36:47 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id r126-20020a1c4484000000b003d6b8e8e07fso4089090wma.0
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 08:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vNaGhqjJmSUPd8ZnqNzNoTlSAb4imPdRX0FygqicTdE=;
        b=LCV3+OATXySth/v7RuhmUF0ygRn0/ISulGDBdDDgghWh5OJpSelIvH6t1BiqpBLqYY
         WFdtaCI2KY8BiAMnbTOznig16eefM9+59VV8GPbYNUqo2Q2KSCdTAjywjfyrgU3O+m4R
         Pos8vk7Ih01Bl4gLEfh/d/np2YgM5RUHpv3CGXgMuEwfirSGz0lrLNiEzNaFtk+lmcH7
         c7weFDqmlifAttqkz5eTKZ7bBOCAbOBzcThmWTi02zChddSIV3y3zuqHCpyVKt+iEFGF
         RYVDvfdbSNJ9FrVVpVPzwAGUtEHdtizNBW4OzsRHo/NluQaZt12c+bV63WiO8YDk8lWX
         yRbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vNaGhqjJmSUPd8ZnqNzNoTlSAb4imPdRX0FygqicTdE=;
        b=nI75yD5QBPJbyWGXNkccPx95MDI7k7NfDBther2d1xwm8gpYhWRsnvy+9iXxx8FGJ/
         fKFndFsiEDX0lyAGgtQA0B5cE/Ii08f5A0tbstmpZMAMrZW8jrTdj4dZAYN0HU6raYfT
         OETHsaSUv9QvSpHClwMUdyW0ZLs3XrA+b2M76Czida9MB6RdS/+uPb3lUd0BEGaL9rQ5
         JnvXlQKEFz7dUUid0RL2Kk9DQIIZoeXHNGB8nWeX+UzC1yPB2STsVL9AxMZOfejJ6sFi
         y1jUao/RyV6nlM9ekBt6PzcEaFFC/oNPzwYNZF1DHQ7lqUsOscXmXBDGpxoXW15tewzk
         wKQw==
X-Gm-Message-State: AFqh2kqWvAK0GUB+N7ibf52aZ5syNG0DA/FMG06+iuwN1JDVoHBfB6KW
        gLArsJA7AeRRAEb7QgI6y1OE5EfFp+dUk5PMKao=
X-Google-Smtp-Source: AMrXdXsiCrLkoVR3oj78JaTq3adEQ2GckFPdXYH+trcX3QESsNjc+JJ88uoOYDwJqVHZ7NlAJKjBzPDhEIeOyYmo1Ik=
X-Received: by 2002:a05:600c:430c:b0:3cf:7dc1:f432 with SMTP id
 p12-20020a05600c430c00b003cf7dc1f432mr370480wme.148.1671727005996; Thu, 22
 Dec 2022 08:36:45 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:adf:ff91:0:0:0:0:0 with HTTP; Thu, 22 Dec 2022 08:36:45
 -0800 (PST)
Reply-To: hustonkarim7712@gmail.com
From:   Huston Karim <hustonali2999@gmail.com>
Date:   Thu, 22 Dec 2022 17:36:45 +0100
Message-ID: <CALe2VC_ugEYCRVCdhd1CEvSA4BUtYMsbnWfQgGWDFBethGPo6Q@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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

Hello, did you receive my email on 21/12/2022?
Please answer .Regards thanks.
