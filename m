Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABCC4E8B06
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 01:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiC0XJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 19:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiC0XJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 19:09:01 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E365DEAF
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 16:07:22 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gb19so12395440pjb.1
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 16:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=VSEH8Q3Lr+Mcr/0lsL1VFPftJp7ALZ21MKYEz4sry74=;
        b=OO7tawrQZCDKjBcBcZ1HOj3uJk1FzImgFl0V+ENPzrjgPGQTGhsRVcvMr6F4D9R9RB
         MAnQ/ed9fa2Kp+PVAS6xI2HajA8f9WlU5RJXWCOSZguYhgrW/k0KNPShN/CfMxtHhZmc
         gx1sCI3y15tKdZXw9zaQGYU+PWIJBXx1OXjG4fX+q35GDxk7vqBrSzjQ/YYe3CpT42yp
         h919l73cwl7K9Hei/nTmbMc8jZRMzpfNYfPwcjF0EZ19Nje1oJxDLrRCW7BRX270uP6H
         +cpi6IAZ182skn/Vrc9+14PAk21+1I10OMsTm3SD8mT3FGtim/l9FASVXb0SbjYOVWti
         cQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=VSEH8Q3Lr+Mcr/0lsL1VFPftJp7ALZ21MKYEz4sry74=;
        b=fuDoSV9YYlK8djK9pfMsa6oLcLHYbcf7qjkA22R6tP50acIJ4hYZPrsfupOx/jPHpr
         SXOq5VV8lPgPH5eVLHM7gAwEq1dl0LzsBr+EMThxnghL8P834gyhP8RwoUOxoXYr7TEv
         BdodNyMLGd6AQQl2WCCk4+4aMCV37QjV71OQgq54Ugh142g2ocybflIGA9lvv3Q4k7lZ
         37ZbOcusDkcfT/DX1ShGERXEVCIyp3MDsw2Kv811prG+JcmVH5ZBg43iwX0jmV2m2F6U
         BiofB6Y29vAGyfgBD+aV3hN8BDzUX0qkcRoGDsZQfsc2PH8MFWZcYvbCXQ9s1Etkpwu/
         WJTA==
X-Gm-Message-State: AOAM530IxF8jgqcVyA+jrx9g8PVNa3j/bsYEQ2ZT64C8eQdOMb1sKbqo
        sJ6ao8TG4rMjDRJtxlz7hhFUNU2GhHulqjgQhQc=
X-Google-Smtp-Source: ABdhPJw0JiXtwnjociGeNm8D0rm6AGWjfxyBLFza3w4GbG2FgtIWd4GWOhRZZqxjreDaIYHb31fuWdvHmvCULhjstU4=
X-Received: by 2002:a17:90b:1bca:b0:1c9:b76f:8d76 with SMTP id
 oa10-20020a17090b1bca00b001c9b76f8d76mr490506pjb.46.1648422441732; Sun, 27
 Mar 2022 16:07:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:453:0:0:0:0 with HTTP; Sun, 27 Mar 2022 16:07:21
 -0700 (PDT)
Reply-To: christopherdaniel830@gmail.com
From:   Christopher Daniel <dc60112201@gmail.com>
Date:   Sun, 27 Mar 2022 23:07:21 +0000
Message-ID: <CAEqp4oQmD1sUDG++i+ScQsc8vLAqSq8_bvDyZPqFWrieFNrJmA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1043 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4950]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [christopherdaniel830[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dc60112201[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [dc60112201[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

.
I wish to invite you to participate in our Investment Funding Program,
get back to me for more details if interested please.

Regards.
Christopher Daniel.
