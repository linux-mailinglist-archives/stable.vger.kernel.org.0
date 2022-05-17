Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C720952A195
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 14:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345562AbiEQMdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 08:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243528AbiEQMdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 08:33:07 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F80B4B873
        for <stable@vger.kernel.org>; Tue, 17 May 2022 05:33:04 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id y12so10683732ior.7
        for <stable@vger.kernel.org>; Tue, 17 May 2022 05:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=UAFXPytckzlM+2LiMZVO1yrsfNezVm7Fa7MwefWz+a0=;
        b=DsMjYqCsWrWFEfa39zePaQb9RvoN8sG03tJuqkUs6OIUtr243ItxA22h5+r3DyQVqF
         0KpubnLDrWc7CG7sfNHMqzjXurl7WafZgO4KcWGE+rKXaUbTuGngVR2xy+KOP45c6Se3
         ovgztQTKLCIdRL6KFdWihFUhSJoD74RjBbHD9oE8mca4yj0HIc4BNYW7j60yxTWyj3tO
         MTUBAQZGfMz7UEwcLWxz9ibPctbRZ/MkHJLYXJ5L31Dep5G+iD3gXIio7PULbjHkr6VO
         et3lfgO0neRUwl6VXtSjiA4rRMU4mrPmA+qOK5NOqGL2AWVP4PmaJIgxjA6ua+gTNXke
         /t+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=UAFXPytckzlM+2LiMZVO1yrsfNezVm7Fa7MwefWz+a0=;
        b=RkDrBF70qcWJDl4kbagSZWmeu5F+QSfvQ8ehC8ctF+tP9dISLW2pOsOFLtTvuiPPwy
         3SrBeWHM7xnr79QHIBWjthNg0lXNyNpQ1phmQNejlIsR15ojuOmhzMDsRGvil9dzTcqw
         6q9Lw4BYDjEPrD07YpnhnXW4xSWDey/82KiNueqCsiJco+1Ou8NQ8R+YBrD+odFcIEVK
         w4sxC2Nc7X72oNPXP3vhg4O3X8J99VDBTbok83e16HLwmLj4Wx8w+2AbsR5EdQD15Z1R
         bsABmBsXrhPODt3cb65E11890oIgeXe+rsGyj6sO2L5vFAX3hN1eCxBbcv5SWrkInDRs
         D0Cg==
X-Gm-Message-State: AOAM531MBJtcuOwqKgRV3BYDCnMD+Ju0VhRwQULSqzn7xGWJ87nIImpL
        l1qyeQWrxfS8/XSHOgmCmdxFX5I850L9TrUCG9E=
X-Google-Smtp-Source: ABdhPJyMNuEr9Ae4l9vTYC8SUjVzvBmZ7aqTvxL36qcAIMDuwe0UiG/uSVOmH2bn48ls8LRE5FrBs+CgMnk72zbSIak=
X-Received: by 2002:a05:6602:160e:b0:64f:8c93:6a40 with SMTP id
 x14-20020a056602160e00b0064f8c936a40mr10269734iow.8.1652790783669; Tue, 17
 May 2022 05:33:03 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a92:ce4b:0:0:0:0:0 with HTTP; Tue, 17 May 2022 05:33:03
 -0700 (PDT)
Reply-To: eq.collinsallen44@yahoo.com
From:   allen <chelsieherian4@gmail.com>
Date:   Tue, 17 May 2022 13:33:03 +0100
Message-ID: <CAOrqJRPMh64+W1Bcd0zDpp2VEZ=M+GPG5-tKjnM2JYM_DrrDuA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d2d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5077]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [chelsieherian4[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [chelsieherian4[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [eq.collinsallen44[at]yahoo.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A carta foi enviada para voc=C3=AA, por favor?
