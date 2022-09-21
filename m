Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587465E56A0
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 01:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiIUXMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 19:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiIUXMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 19:12:51 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC28AA6C40
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 16:12:50 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id a129so8524183vsc.0
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 16:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=US+w0Gq+INOQrtAru6YjsXTHnvEG5Z6SscPUTt4BrLg=;
        b=ccQk6ctski/X7NPndeHupVPi+6zqN0cgXy1PPzzjUrgjvNxHHUcW1gpm1tGRwovqyN
         GsNsVPuiVIVduQ7oauyKIIZqtKngMfUeUARkNEJ/re+5heRO76ISBHzAYiJcG8UC2E2E
         E4cvNQQedKEpd5IcIaChHIcdxmqAAF3SQYUSqNg1STfBKMxbaf1vjpRWshBpk1JPpXd5
         iEBV/JJDK5iF2gxEF/Le98I3OOfn6fQc/GaI7GUNDyd3FlnIsgrghMzbcJ0kv64bN0Q3
         DBbiBpuXgWbftNrYXsBOS/E59ko8D9LfMIWtFMjTXcM9JSAO3w1+aQWnyNfZp+Ow+3YF
         I18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=US+w0Gq+INOQrtAru6YjsXTHnvEG5Z6SscPUTt4BrLg=;
        b=gJt2Myc4hz/WI6lJ+FfAu2mtdlIzZ0UVTRs8bcboQ4lFMXLjhwHN2Gz/eVFzA0NzoE
         P0qaSv2Q+mL+mXy+Y2+QxKGgjDKB6THCVo6vRaadMCd4gBW3zBvpXdfgS+k3othB33g7
         cniL4voUoWxgrjDgjmR/O4YnsIr0b6jSgoGpdkjqEnladZ2+bMKOc6RvSG+jOGOolQ3x
         4O5ErOG2GbljbE7HrW0y35JFYIyMprOstkIoJD6p+iHukcbKaTpINaddIPO+JM52cUO3
         8mioFOOO+/wQZO24XB1kLM6/n9KVHMKNK8Sn7B1C9mbwn8faknaSaSLV4DdT5aC+aaMy
         YuTA==
X-Gm-Message-State: ACrzQf0fr7XuCSNCobl36x5Uhi4GTHW3OT/FE3hvIPltG1T9sOdaWIDq
        +nT/PAY5ITY/fC9A9khCRI4FVvqE+tSr1loohHI=
X-Google-Smtp-Source: AMsMyM5mQpYFjA+XrxOlR70JPp41SFlxCWm8GhqzvitfLNUlAGxqoWZiQGh+GKzTzHOK1nIC8y84tQHevX/ck0ZCTYs=
X-Received: by 2002:a67:a20d:0:b0:39b:181d:bd35 with SMTP id
 l13-20020a67a20d000000b0039b181dbd35mr296124vse.39.1663801969706; Wed, 21 Sep
 2022 16:12:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:dc08:0:b0:2f5:ab27:9a96 with HTTP; Wed, 21 Sep 2022
 16:12:49 -0700 (PDT)
Reply-To: krp2014@live.fr
From:   "Mrs. Kish Patrick" <mrs.rubeccarosemary@gmail.com>
Date:   Wed, 21 Sep 2022 23:12:49 +0000
Message-ID: <CAPJ18zO-B+KiwhmfqUQNq3de3uccHvuCyFA39cjQuib7gZ6kwg@mail.gmail.com>
Subject: INFORMATION
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e34 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6621]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrs.rubeccarosemary[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [krp2014[at]live.fr]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Dear Friend,
It=E2=80=99s just my urgent need for foreign partner that made me to contac=
t
you via your email. The details will send to you as soon as i heard
from
you.
Mrs. Kish Patrick
