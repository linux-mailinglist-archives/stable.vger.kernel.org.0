Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F586542BF4
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 11:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbiFHJun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 05:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbiFHJuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 05:50:25 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767E5397BBE
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 02:19:18 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id h23so32259809lfe.4
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 02:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=Nfd6i5Qu34Jm0Ly3JgdO0G/oKBXfoWfuOR8e9uAw4Q8jy5895yZtnsQ8rWAHHezgdO
         yHuB02Vr3D2UWdwVgGHRSkuIY3cDoKOyn43zLzoHAvF3eUyrxyM1RrxnPtY1DBJzkqaP
         sehITaeoZ3hfbJpB9lTs8c8UdJP9MN7FDW1PqsGnPwWZVyl2I5Dbgns/CaVKow/8dYUL
         DPClzRpfNZ43fOZ5zdV3yFmh/o2BTvx8KNLQRbQA7kVemol0+sJoUyHZFHIOKDYxZOET
         5LBqQ6VkBYAIyye4TvmVKAx6DalMtb/7lT4Tk/bY2Z+VwMjR1SK/sYoLEIMQx7ygnGK+
         yBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=EzV2sPP2y1vsAFZa8U1nMXOz9G2ju2ULfRUEs6a9F6pW0hKy9HyucovgUVujWKBu3T
         SAxlQ1INRz/koMp5zcxPg6biA5cLDFjHZxW/wUklI2I2KhvUTPPlrmncaDTzGeldhZTp
         Xxa1VtDK5mFphnAJM+xiTGur2rLFLfg1ev0ITebsxY6pwXkrINYgdUaScLgRYvkuuw6i
         BeuVAMZdipHA5JlZvhdgXJG/EcnfDLHctuV2YuTVYga4tylCDbL5bi/tZbL5els4sNPU
         du/HQUGIX1ADP7EeJ5HVEb+kyEThK/x7IH9IBhkVGqX//4yhlg/a2uo448tAt2fC+Bzn
         5WSw==
X-Gm-Message-State: AOAM530myK9jbrkighidhCq+7X6FPKUuK5Eb9sMCfe41MUvUTVRu46mL
        BtdygrNPpoNavbMwbUMppPRcC1Yt2+pMdNUyC2L+EokR0OM=
X-Google-Smtp-Source: ABdhPJyyHOzGhB9PMTgd8IyJuyvxoIkhyVVFR/i/6r6d6x6RWmyPObae6CXsqApncwg0ipV/SkhgI1MT1uflgnt+M/g=
X-Received: by 2002:a05:6512:3d94:b0:479:560e:ce5c with SMTP id
 k20-20020a0565123d9400b00479560ece5cmr7166327lfv.506.1654679956576; Wed, 08
 Jun 2022 02:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220607165002.659942637@linuxfoundation.org>
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Wed, 8 Jun 2022 14:49:05 +0530
Message-ID: <CAHokDBmtyJeEWOH=kOghPjB1WG587kaouatc-gQwOoim6tC7Cg@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/879] 5.18.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regressions found

Tested-by: Fenil Jain <fkjainco@gmail.com>
