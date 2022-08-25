Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF1A5A0D96
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 12:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237108AbiHYKMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 06:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241136AbiHYKMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 06:12:21 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5825A894F
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 03:12:09 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id r124so7109658oig.11
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 03:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=NcQgfGWmNtGVcmYOkqhvmNWuEth66CXwSKmPdJfqqgM=;
        b=WVrT7yqPOntKnWuTcnp6ohm3aNDR6rm+M1fFy6pz7vT/eTpe6Bz04l/hwBHVsmFl9/
         2gMa3vpPv6kDgqus/73kHxePi2+SFjK7hGwLUQsON5UrXcsH51ZCUHJYKvubA7y0SE3B
         nV5qZ/GVFVSrCwmaLxcce8/5cieRMojRGpXBLloMsxLt6sFvRP89Qi53C1I2xAcrLzh5
         aFRAbeUP58g4/sC3jgOuHpHRHfNgaZCeKSZsioIFzCJLwMbU5ZktlSra12ftemzrORH/
         lpPjWLS6Ze6aGHHFLHdi9eAzh5l/1Fm6I2X27JtV4z6OxqFg6D0pXPkrLO8gSOdnzdN0
         6W4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=NcQgfGWmNtGVcmYOkqhvmNWuEth66CXwSKmPdJfqqgM=;
        b=hMZHwTza/+fgfxgdUEIUCUl01F1J/AGMNkJgulNpFBM9ZFy+WgHayyoEZ6AdI6vmS5
         4wmqYx+Rfunj/HIPv4RKdAMfeGtlwJFLaiK3NWJ9hIaMPWPYghB3Mbx8dXNYpOhNh3ky
         pKqBEy+ZEhgE2aDx8wewlD34BQr0rBh8jGpM21uRpRv3J84Rf9D58XC9ksX8nBITeIb6
         QKwK8ESMgU+wb+3rIr3mH3bl50ZQ5LpkKvZZKEA5TiDhEeB0UgcL4Vary26fck3P74fX
         ErxXzdMfy5AnuTY4nzbsTZZVUn6VN5EpjfkkB64fH2EZjgqdp63ICNJVi10TUjlXuzh3
         hzVQ==
X-Gm-Message-State: ACgBeo3fz/A2TRUxk+njDnhCljUAy0Gcr9bvfAJi1pf53fJmx6hNPGIA
        j7T+1ETNRU6kYDxgdND8mU7kEFeCR1ijyoRyan4=
X-Google-Smtp-Source: AA6agR7XaHizPFBcl5BKqSkBv3mcq9L64QPIwA41PYTssY+wl8mbHGGS6kNbkL7S0M9D/teAM3HO1Aiho/BQnQVc/0E=
X-Received: by 2002:aca:b01:0:b0:345:4295:e9b2 with SMTP id
 1-20020aca0b01000000b003454295e9b2mr1456901oil.28.1661422329139; Thu, 25 Aug
 2022 03:12:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5ec3:0:0:0:0:0 with HTTP; Thu, 25 Aug 2022 03:12:08
 -0700 (PDT)
Reply-To: sgtkaylla202@gmail.com
From:   kayla manthey <tadjokes@gmail.com>
Date:   Thu, 25 Aug 2022 10:12:08 +0000
Message-ID: <CAHi6=KY3-s6LUMt6WvNKm+pTNDSVzdCyjsTepPywmG=n6rT-Mw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:234 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4981]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [tadjokes[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [sgtkaylla202[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bok draga, mogu li razgovarati s tobom, molim te?
