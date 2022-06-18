Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51158550461
	for <lists+stable@lfdr.de>; Sat, 18 Jun 2022 14:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbiFRMNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jun 2022 08:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbiFRMNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jun 2022 08:13:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F134140C9
        for <stable@vger.kernel.org>; Sat, 18 Jun 2022 05:13:29 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id h192so6220657pgc.4
        for <stable@vger.kernel.org>; Sat, 18 Jun 2022 05:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=m/SyI1p4NJYzpPMsKBP0cxFgB8yxm6H3Ocv4yjXObDY=;
        b=QqNME9A+WqNR6fsZ+dF0fXNlB32+GtkP2Caj/nPkz+KRJC5xm7mcLzMaHUfqkXk5H9
         atblqaRNNd/E0SxLVAbeOkamHuv0t3ujBYofCbWc0D/kl/51KlLNaDy1EjWwT8X9dVF2
         EW2yxHMMbP8doUxgJTlS+dl1AxEF4ih4a4ASHz/YCqcZNSl7qJ7xkYdRnnIM3dc22c4t
         /jDYVRlXnffhEcBGyJSL1egxAYAGAR+FRFs7YfscQcInXvAmJeZnlbrKaROINvtOjoZL
         Wzco15ftbSF1GE4UjA8lb7R5bEPgFo+6d3Kegk9Th/gDfvJaUM3cGAo0ALBo0PGNTKSi
         3KNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=m/SyI1p4NJYzpPMsKBP0cxFgB8yxm6H3Ocv4yjXObDY=;
        b=Bx8IWD0JZV6EuXjtEssrTk1wjTlr5LheWkcJQMwDV6OPNwU5dH3jjTiXAHSYgz2X6d
         IW48G8ZIkDMFXS7hlBtwFpIRhGCgwSg0/rNw0U9ow+c1vMx7UdBDMtdataYnmtzqSfMp
         LYHrkWrE7ySv0tL0xQ+w6Zgq63z1mOC+UtTdyfIeSZL/il27a/xW1IQ7iZwFTPrvYDBw
         4hfw3lBvV4W+D2MazuuvRy1om64TZG4uE1QTeHXNiHu1c9xSvkpf1ych2WqtlygyRWhX
         PwiFZbSOxCcrW4xg0eO+/EQIv0QcvqEGrMt03wuoHt7vCMUnfxqivjIXV8/9usXu4Iai
         VhdQ==
X-Gm-Message-State: AJIora9nHfEPyvtYUhCtxZ9/V+lMQAmkvYtiufTbMeIRtmQwDrIPzXar
        UYCBSJRolElyvE+1xP7zuLguWFjqYFI8Ah1m1vQ=
X-Google-Smtp-Source: AGRyM1snaQ9tC8oBhAm/454JfR8gx4xxxXddNFIpALKsjEbu8x7iTk3YQBqCdhxhrl99mB4rvcriDRqIcsnpGJh7RkM=
X-Received: by 2002:a63:7744:0:b0:408:a74f:ec4f with SMTP id
 s65-20020a637744000000b00408a74fec4fmr12908075pgc.551.1655554408987; Sat, 18
 Jun 2022 05:13:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7022:6621:b0:40:f299:6c42 with HTTP; Sat, 18 Jun 2022
 05:13:28 -0700 (PDT)
Reply-To: cosme.mossou@hotmail.com
From:   "Mr.Cosme" <onlinecustomerc@gmail.com>
Date:   Sat, 18 Jun 2022 05:13:28 -0700
Message-ID: <CAPsZxQEhQq+Bf03hy8=D0dmowi9Ho_KfLerxK70WPA8bM1FJKg@mail.gmail.com>
Subject: Re;
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=ADVANCE_FEE_4_NEW,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:544 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [onlinecustomerc[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.2 ADVANCE_FEE_4_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  0.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

My name is Mr.Cosme Amossou, I apologize for contacting you in this
manner but the situation at hand demands urgent attention from all
presumed beneficiaries. I have an important subject to share with you,
regarding my late client Mr. Peter fund's domicile in his bank. Write
back to me for more detailed information.

Best regards
Mr.Cosme
