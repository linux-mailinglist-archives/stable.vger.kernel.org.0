Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 895EB4D2ED0
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 13:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiCIMOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 07:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiCIMOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 07:14:36 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD85C3EB93
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 04:13:35 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id mv5-20020a17090b198500b001bf2a039831so5029294pjb.5
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 04:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=gJ6YR21y5zTqbnNhoCZWhHIkgLSex9nXtpoAVCLXdI4=;
        b=OLcfwOBBbVbFC30gMt+FapPS2BJ/pf1ILg01CSKhqVa/xp7LhYQ7nW2ywlwFHVNf8I
         4Oey92WGizHZepXJakl53gORwsGeH7iDwo9icnDn53v7maSanoQJOaHM9bGRM6/XntcH
         +i6KSgas5W4hrRTdwOs7FgLHgLq5hPu5IRuLN4sdG9/x70OWaU7Zqt64EYKXQ9r1MwHu
         Q5aHrGQCVTxXOwI4aNAmKqUagDd4j77CTlTkIN+8sd6BePOxA2SDvLQibKuRj2pcF3MD
         V9hxkQGXd4rcEm2cy21OSCJidxTR6YJTAyNmVo9wNv+7ZU1xtEGBf6p8JKvVRpapv/Mx
         4IMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=gJ6YR21y5zTqbnNhoCZWhHIkgLSex9nXtpoAVCLXdI4=;
        b=Hl5cCasFPBkbpMBbSbAwaOR92VUhfsAE3Do+H05PydsBFjg8QbheBYtvTWLAwNYJIR
         rHpoUM4flnIlj36JC6pUMSXalQIJwKCHAb3VpmO7Hj6/VQRCVz4593dgep6+3dez4prb
         RtTXJ7cFdTJgN0IA4ifulr4cQHKQHhfLknIFR1dwckOLdBgwulYkp6zhVMNGoc9YNBoP
         oFwd4ZIaez3doaHiRaAd4nrS4h+DFg6+aoAEK2qmiDBKbhHQmjNS+KU15ZWYk7vI4D9y
         oUS+T+6XN6QcWuSFR+UPXaU9IZDUyFd9mj1qalVwSTbixXKZwdta0mTZEyro0hJ55rTI
         HBzQ==
X-Gm-Message-State: AOAM531kmpSz+JrWNXXqFc7TAMk8XbN4FAnJEeyyHU1+4W0VR8sDJNAj
        tPMBIUFnwNp5I4t/Y2t9+wvrLNtFvcbmcF8l2IU=
X-Google-Smtp-Source: ABdhPJxMpUpiUDM/o45LyA0I65xP4d36dOrl1tmiF0dWneooC5X1s9ukwcNdpHwB+vqPX+A4Yw4f7HzPGgcFBC0et/I=
X-Received: by 2002:a17:903:1246:b0:14f:e51e:baa7 with SMTP id
 u6-20020a170903124600b0014fe51ebaa7mr22616147plh.159.1646828014951; Wed, 09
 Mar 2022 04:13:34 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a20:840e:b0:77:bccd:2f81 with HTTP; Wed, 9 Mar 2022
 04:13:34 -0800 (PST)
Reply-To: howardnewell923@gmail.com
From:   Howard Newell <a9411454@gmail.com>
Date:   Wed, 9 Mar 2022 12:13:34 +0000
Message-ID: <CAMsMWDofScr09pFStmO6kRhk1nGupzjxTU5p3hRss-QqySprhw@mail.gmail.com>
Subject: re
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,HK_SCAM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1029 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4494]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [a9411454[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [howardnewell923[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [a9411454[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 HK_SCAM No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 

Hi

I want to know from you if you received my message concerning your
compensation file with United Nations Compensation Program. Please
confirm.

Kind regards!
Howard Newell
London WC2N 4JS, UK
