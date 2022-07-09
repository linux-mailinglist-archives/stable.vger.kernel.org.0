Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9430C56C841
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 11:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiGIJRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 05:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGIJRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 05:17:15 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF38A5E32C
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 02:17:14 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g1so1017225edb.12
        for <stable@vger.kernel.org>; Sat, 09 Jul 2022 02:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=TKvyPiNZ+anjmYa10tWJwFVa+LgbgMa6tcU0LfkkBNI=;
        b=OQP3s9B5y9sJbg2f3bPBJoAY1QkuBHWKy5Nx1NcKTTXilSaZ4ZZknQMXJC0hknW6Yp
         LGF3uadmXpAV2iFRK4hWRQ29g0RllkO3Kl3nIMX08w/Oceby9uYiygeVULO1sd5Szp1m
         aJp9+fdfN8LvzvkLYSos2iwCF6xP86ZpyUGn4AtDTSP26QohAlE6TiYR+ZY4t6sqONQ9
         DHUTcnhGI4fRq9WS2pnX8BydxPo5zfjfAyXYX5MA96nUiPuhilbw7Ayxw8BtLWcr6vgS
         ZfbIJSTz3CgYBjThQwSTfMPYBlD8fcpJ+4U90ufTL4vkdjaWrHvkbUWGYo7f+LtRb2Ei
         g+gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=TKvyPiNZ+anjmYa10tWJwFVa+LgbgMa6tcU0LfkkBNI=;
        b=vbt8N/U1uICW+U08NZkhtY7JHw4OEix58yv+SAMpxey28/SXVfUr+2IMK4m0L01i1J
         CU0tWuKCrqAx02jpe7dzDT6vfS2R9fXTd4UKq/Zp4mAWBu6jUymo0hHGcta+da5E7JQJ
         Jg4taVP7tW3bAyM84vzgJUFJqDmAAZFAy5Ym0Tk4gf++grNrZz+3X/3nT18U72mdr10x
         mu+63sXpY1Fl+hbg8RtnmYzixWQd15pya+KjhyFjeNJjNPwFGoz3YwYiQoBxnSQKHghW
         p50wlT5mD91y6aPf95jsBSUeNOUdHsKGe4zdbEEeqWh9vIw5LdgMLIazILEU9kIcmp6Y
         24Yg==
X-Gm-Message-State: AJIora/lQZ5ZtZReBe3dGvD+6+q2xNx8ffSrLCMMuQ09iBzL5U0RnB/F
        l0COxKyUQ91NSWISBsFJ220/Iki2z45oRWeCaI4=
X-Google-Smtp-Source: AGRyM1s/CC1iEypYfYvc8jNXeqZHNZnX4PfdRMHQSadNSI8aM+bd/e9tE6ucoFw+20mINZtKneIC2RedS1TTCCDn/K8=
X-Received: by 2002:a05:6402:4252:b0:43a:9232:dafc with SMTP id
 g18-20020a056402425200b0043a9232dafcmr10043054edb.243.1657358233427; Sat, 09
 Jul 2022 02:17:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:907:a40c:0:0:0:0 with HTTP; Sat, 9 Jul 2022 02:17:13
 -0700 (PDT)
From:   John Jacob <jjacobvsusa@gmail.com>
Date:   Sat, 9 Jul 2022 12:17:13 +0300
Message-ID: <CAKZDKkCUKf6SGCyt4PoCUEJccFBhvE8ejps_tKQi1X9dPgCnHA@mail.gmail.com>
Subject: Confirm Receipt
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.3 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear,

I am Daniel Affum a retired civil servant i have a  business to
discuss with you from the Eastern part of Africa aimed at agreed
percentage upon your acceptance of my hand in business and friendship.
Kindly respond to me if you are interested to partner with me for an
update.Very important.

Yours Sincerely,
Jacob John.
For,
Daniel Affum.
Reply to: danielaffum005@yahoo.com
