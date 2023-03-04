Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43266AA90F
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 11:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjCDKGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 05:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjCDKGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 05:06:37 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3F613DEB
        for <stable@vger.kernel.org>; Sat,  4 Mar 2023 02:06:36 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id t15so4425887wrz.7
        for <stable@vger.kernel.org>; Sat, 04 Mar 2023 02:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677924395;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=lsFutfgmd25/x5WQnUNDh2cceaTJGxIl6liXmPvaxjo=;
        b=R2hOLorcWufR9SofkNn7/1vPIAVtBY087Md3u4RmRAyIp6/fpI9HQrCg1pEPx8bi6w
         CBBnZPRV7tiSPXcFVx+7zWjyI0vZJaWQdXqJPJxMreQ7xsV2df48FsZcN5ZTdm4aYHDf
         nPJO5LJ/MV3ZJSdzjvxZwQdviqPMFuDdS2Rueg9Xe9LHHN493R4reH1cfM/nnm6SsCix
         5bvty++m++HtpBFViF+tJgHeyX/MRQTRRB+kn2zSN6n5yKo8hA83hoLfR/sKE6Yq+WIz
         oCtxb1S6NZ8YNHfXCVcCozYxHb5ChZ/qcWXnQBcAMCAG7GBWAEHlCgju/GXFeRhN/Ubm
         6aUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677924395;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lsFutfgmd25/x5WQnUNDh2cceaTJGxIl6liXmPvaxjo=;
        b=B3xH5FCGl7S9UzGAUd0Rv+21kF29zy+ss+tJzAghCEBrJeWMM/D8ss8x9p53qSshoF
         hv/RiX7yLyLSGfSjq6EDFxGewZ4++6ro0Xb/mKm/sfHyY1L/hD/gF1c+7iRoME5UfrDU
         sTXHurJwZhoMsSs7e7QMGVxLsH1j6vHrVNON6i3g3G9S2IViGNj4xLyBMd+FnGJG1OHn
         0OtMXuXhBa4DzC/S0fdGgMPzt5yt0r+qdDod27QE75GmWidEhVq9TFJbrvtYrubHT48n
         MnpMKZ6xo4QGhHT2F1Hq4yxP7fE/eEZGAe09dMeIHgaK5fNewQhMk11fSW5yBg8NOg92
         BVWg==
X-Gm-Message-State: AO0yUKWasJ61fPWuFHYuumVWChq2wcXHLPjxmxMNX0tfTy0gLKnA3Nlv
        h9qvcEEe2I3pYwKCKaEljVM=
X-Google-Smtp-Source: AK7set/Jaw1lobDbzbRZVjFO9yog1hY0pO12cl53oQjCb1PPGqmxGoGqvI2w6wIydxFiniM0Gy8phw==
X-Received: by 2002:adf:de10:0:b0:2cb:c474:7597 with SMTP id b16-20020adfde10000000b002cbc4747597mr3245599wrm.66.1677924395099;
        Sat, 04 Mar 2023 02:06:35 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id a13-20020a5d508d000000b002c54536c662sm4669430wrt.34.2023.03.04.02.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 02:06:34 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 58AD7BE2DE0; Sat,  4 Mar 2023 11:06:33 +0100 (CET)
Date:   Sat, 4 Mar 2023 11:06:33 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Alper Nebi Yasak <alpernebiyasak@gmail.com>
Subject: Please backport e6acaf25cba1 ("firmware: coreboot: framebuffer:
 Ignore reserved pixel color bits") to stable series back in 6.1.y
Message-ID: <ZAMYKRtk89lBUk3b@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable maintainers,

The following bugfix was in meanwhile applied to mainline, and I would
like to request to backport it at lest back to 6.1.y. I do not know if
it is needed earlier as well, Alper, any input on this?

We will want to pick it as well to properly support ChromeOS boards,
cf. https://salsa.debian.org/kernel-team/linux/-/merge_requests/652

Regards,
Salvatore
