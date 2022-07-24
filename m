Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C47057F49E
	for <lists+stable@lfdr.de>; Sun, 24 Jul 2022 12:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbiGXKC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jul 2022 06:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiGXKC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jul 2022 06:02:26 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5FA6549
        for <stable@vger.kernel.org>; Sun, 24 Jul 2022 03:02:24 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id by8so9958349ljb.13
        for <stable@vger.kernel.org>; Sun, 24 Jul 2022 03:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=wdOy83vp8XEh9ucVwqaid3YoyUF3SJx7vtMKOArNZ2s=;
        b=hQ9c1VFd4IiuUu4sZBucWpNMDuSOQYBKW/zeE/m2OXITLi/nWC6ekHojPlgs8Dn2jG
         PpnwmAaDTNa6loJrh4/PCZ8zpntRWnmF6oydX8aA3Bb5HAmKU8HPOo8CwvctTCcgftFC
         W/+MllzHgRl/HcZjWQv3qoafmgsHMXbd2dggIaywGZkdzM9cAMy1eOewrd2BQ5S1LEPi
         2XOFDnfjck3i7B29ZqrALuUwaRTQvjv0UckH83HtnZa6yqMO9uetsYpUGtNoJpuT0MuF
         U7Zg81BvwF6riyAMvG1gWT0tQJDe479FlPJclbCvGAVK2M2Xgz0kcQZ6AeFOmuM4TJqI
         lEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=wdOy83vp8XEh9ucVwqaid3YoyUF3SJx7vtMKOArNZ2s=;
        b=LTggHUcPel+Gz9BjaL2AWXZG4Muu8n+QexxnkZlZuTIBIkbYB2/cd5vx23bK05aLtN
         Mx9oexh/Fu7Gn9Q4oXmg8Cd+hQzps5j9ZkKpdtYgaTGSwCSWIk5UVUgV/IUt29XGH33Q
         GXHGGQpN/zSYsNjAoPuEKmtPLGae0CISQqvblekRdfRP2Nk2KWEOM6JivZEeHL2M3qwm
         U86ByWQJ70i0YY6g1Owf2vt72aTm3UNWMGUQa/XNIioBe5UPUR7wMw8GZuuAAKmK4lvv
         biZO9wY9dbpZ1OIDRV0GBxlWZ16eY1vnXQUl/wjttFQkHNGIL2aEQsfvB+XsUTx+34k6
         9gkw==
X-Gm-Message-State: AJIora9r5UNtwG+AoDqotNGI16iT138lfLBMBrVJpG21iWxsbsKcTfr4
        0Tktawg0Y/51qc7yzCw4VfG6+tI+U5sR9FU1US8=
X-Google-Smtp-Source: AGRyM1uW4uzg/vjAr+30LMfAR/zqEyLMUHNbv78klpADb87BYOPp7MhlnSNqh3MZOoBIygQcAAvq0oWdp0OsA/KgQvE=
X-Received: by 2002:a2e:b8cc:0:b0:25d:ac5c:734f with SMTP id
 s12-20020a2eb8cc000000b0025dac5c734fmr2543155ljp.317.1658656943164; Sun, 24
 Jul 2022 03:02:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:571b:0:0:0:0:0 with HTTP; Sun, 24 Jul 2022 03:02:22
 -0700 (PDT)
Reply-To: wen305147@gmail.com
From:   Tony Wen <ceciliakoenig77@gmail.com>
Date:   Sun, 24 Jul 2022 18:02:22 +0800
Message-ID: <CALXYRXF920-nEb0PQVn+-++P0G1QO+g1CDuhVF__2YAdXuM_sQ@mail.gmail.com>
Subject: business
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:22c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5099]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ceciliakoenig77[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ceciliakoenig77[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wen305147[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Can I trust you with a business deal?
