Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A634A68A8CA
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 08:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjBDH17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 02:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjBDH16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 02:27:58 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A30D28857
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 23:27:58 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-4c24993965eso95652757b3.12
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 23:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=kMuaQpRsqXnW88S62M3iCZTuME7hCzKqSudwEFZ1jGx4sTvikSCORAJA5EmPxzbbwy
         FYhavCvlemIYizbL1d93BIeXfp3vlLrp42zpmVBKWyZeBcZExqj4lJOLlgHMq9RBogoV
         7RYdWUlAwMs/Ftl99EqyvZ+X0DzsQ3wj/sgLqMnpeKrqGTxvcDrLG98VnQDF4o+oAcc+
         TJmivd4TwvR1nM5yuqGffrISS6yG6lyEqjGGkwQpxK1+y5esIpx9riiAd//A+3vRsNJC
         f67DtdzdWHayQCOUw4M42u5qJorAXwUxCFgA+frBvl5V5UMbU8isUDUmyqS3ySMuBiDB
         tc2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=5piTRGo/ZItk2cG0mzsgAORFQHzB7kqtPotiXHuTu6hCWJ/MhdExb5b412naY9AaYD
         9kADs7qQZanDkcwLqUUQqvwKPhJqIN08bcnk2gMUn0ztbmM0Mq4gBdT+VSo12K17zGHC
         ZJbOo6CMSMq83/JsjfM7K71UT9neW/DMy9G/W1LQQKrb7/7ClJydziCe0rAVsE4WuaFe
         5fzo9R5rQ3Ku/ZgG4hIjO3GB56mY5k9c3nKl28MixdgQQ+9//z1KxGikwlVPIIvzOow+
         PiQRQWGtE1AzIHlz3rhcgtQbA/Qzi1Y1BAgmYfTBjmaPxfJcE2XyMjYfGidodJy+3dZE
         tHig==
X-Gm-Message-State: AO0yUKXmkf5JUnn6Ah0xWq07wwDK8b7aHkfbs9K9g5CJ1u6F1jwT5VVX
        GtGeCYcYuN6DmOdl9+UX6H6h+nk8CvSzbb+8GVc/smdhc0U=
X-Google-Smtp-Source: AK7set9MJYfQLRFkLwXLlVrCCaC7bvaMeIFhDagRfFP6ahYQxSC6AhPqFkB4nYthgIpdi9MWALjhQbP5An7gtA108I0=
X-Received: by 2002:a05:690c:f85:b0:4ff:e9c9:73ed with SMTP id
 df5-20020a05690c0f8500b004ffe9c973edmr1410185ywb.478.1675495677393; Fri, 03
 Feb 2023 23:27:57 -0800 (PST)
MIME-Version: 1.0
References: <20230203101009.946745030@linuxfoundation.org>
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Sat, 4 Feb 2023 12:57:45 +0530
Message-ID: <CAHokDB=k6_mJNzEoa-koca=VOhg7BMAO=-hRBX6Ai1ioyiTrbQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regressions found

Tested-by: Fenil Jain <fkjainco@gmail.com>
