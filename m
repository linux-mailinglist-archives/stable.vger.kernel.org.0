Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57F950B624
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 13:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447083AbiDVLbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 07:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447058AbiDVLbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 07:31:23 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CEB5522E
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 04:28:29 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bv19so15777096ejb.6
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 04:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=rDJ/zdSmIucIthkKmtXJ6U33mHRSC560+Ww4kYpDyCs=;
        b=D3Tpu+pzc0kIyPFLpFdcceJeJQB0AiuAdbygSMbr6q08PU1/NxBJovvMsllaWlw6lU
         rfdB53cP7aTB+JZSNicYfv7SfWOnXsgsmNojhBaY+/5JKR7HbGtgMuoBqeFOe2VUpx+e
         tbWZtAql0y0kV0s2y1kK1AUTskp9wXmYwyKDbdLQdeZRl4MaAn8dlTPKWj3pcKf6mJB9
         yLBC6dghOII6hSrYitY1ABImbpb7FHdRkatI0sVu4vlALcMjED+ScJ+1UNsEJGrgNiqZ
         qx+9elEfp7FfBrv854B9ShiKERMG8fncMEE4L9h4Cr+4Jm/hFiWLVS+TA5grCV9Puzkn
         0g2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=rDJ/zdSmIucIthkKmtXJ6U33mHRSC560+Ww4kYpDyCs=;
        b=qwpeUsKsQ48+gtITpm3f29bUqKShgNN8QpAn6C64IiWTJtlo4siC8JJZ00tapRcNyC
         D+Dto2dbVy7eh5Yn7+in5+KAwqRhF38L4sp4InZGAw6QczrMpnjlZSjMkz4iXd2Tre1x
         0uOpV45cWUAyCXfKB+kOizOCpEtDXF6k1s39k9tR19yXknG2fg/VxELrNSQS1EnZG4b3
         wdA04hKUN6nzS7bnt/sjK4qR71kM4mfAv/I3qMEWYBkRsnoAdlJ1yCmNizfxExWGCmsp
         UTeFkY4AZCNLLSlElwb2WkXQzx99xosyLdeks0I0+D7j3Dtb9tBrPE23ufiZxvo0FP8Z
         wH1A==
X-Gm-Message-State: AOAM531SKq+mm2rTFHi1ceiIWFhoEzuOyx7Q/wWVSveLJTsKQGjzE7Ut
        bs1fMsOt70yMP3z+/vOIgqLnatE/iIeHNn+sq/U=
X-Google-Smtp-Source: ABdhPJyNmaZ0PDwch9Njrili43js980VB/H0fHcAr3+/echKlrZiI6FBx+tdKQEl+5Vu5xyqwCdRoQxhdpmbxQfq888=
X-Received: by 2002:a17:906:5d10:b0:6f3:65e6:5fcb with SMTP id
 g16-20020a1709065d1000b006f365e65fcbmr522339ejt.212.1650626908324; Fri, 22
 Apr 2022 04:28:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:7e86:0:0:0:0:0 with HTTP; Fri, 22 Apr 2022 04:28:27
 -0700 (PDT)
Reply-To: robertsodjo63@gmail.com
From:   Roberts kodjo <robertsonkodjo01@gmail.com>
Date:   Fri, 22 Apr 2022 11:28:27 +0000
Message-ID: <CAOpP-mnk1pNzS_uEfTDZNr3vZYPGKrMng9nE__aBu1Z7Sd4cyQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:62d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4939]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [robertsonkodjo01[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [robertsodjo63[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [robertsonkodjo01[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I need to urgently discuss with you about a deceased client of mine
who died and left a large amount in the Bank here.
