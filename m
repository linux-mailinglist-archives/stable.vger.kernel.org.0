Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D816CCFE0
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 04:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjC2CSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 22:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2CSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 22:18:32 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD341FE8
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 19:18:31 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id z11so9325782pfh.4
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 19:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680056311;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QrW0Sz8GBPnu6OCGpvxmOnmlGOMzTNgDleQT9EalNAI=;
        b=D72gCuRP5NC6bGMxOir/jppWtpiClPwVbPbGJctFSn7NciK8mbmLLbi+JD27jOAh6W
         vIUgl7qhFdOdGBVzqBoUwjJOXHmYJ4xcS6GzMBxSjquWR9Rm6LdoIM+iGAH12Bn0e7wo
         tv6cOfbCReRK+GHwvZH02yZUR3KAzDaqoO54BjGLyigctTmRz3hkpGJcF0+MqWZC5peO
         gpVcHt5X3COtf/OaerfVoOrBumeau+cBMNQB28JOEA04IbzgVaRGWQSCOzdnu5ZXBN7y
         /E5isO76zHsJX9b6zpoKULKEoUOho6PFVPgKxqkiR0nxbBRk3qAjrrvbu8nmdXiCUh9j
         cG0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680056311;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QrW0Sz8GBPnu6OCGpvxmOnmlGOMzTNgDleQT9EalNAI=;
        b=Su50Ni++N22l7QToKAhAGTkYEZ++/r+tcoeBLAGJiasEMP/h4ADlXPVCIi/vV+hPwf
         3bvPsATx9PpqTbAqcEwaPAsQs5JJ5ZBuGu7BwdrdGFPs+GTfd7C1J1NdkBro3FA1oNUp
         FkSrba/vaWHjkC+KpXtDrGjM5nEpGfCr2kgymfHKM1NJsE2Rg0bXWR0b3RASK4GaLkq8
         ouAU97sJm9Cbi5LJ+GxtEfAqxPKiS7YY1vWulKDVFrT78c8nvbcQnmqtmhOV4BfC+sTy
         BwIEzLbODkn+fecFurss+8G6k1vBIVofPq4xYt60eRCDIoexUL1RwRYryfe2vWt5JvF9
         BC8A==
X-Gm-Message-State: AAQBX9f7pHsOgykeSRWkeykDJGQzTJZa5ZFrQMRTcjMGR7UTYw+tzjR9
        IpQBvGcF6sSRnIHd/jVqf12sAqupjRmi2dEl0ss=
X-Google-Smtp-Source: AKy350aSDgT1uL2jwTdsHElciWtF87Hacfk3xK4+1ZSd/3tl3QbpVOiZNkRgxHWI2Y9gmcMRCnMgk4N0NwaLCVEUuiQ=
X-Received: by 2002:a63:34c:0:b0:50f:a35d:9dd2 with SMTP id
 73-20020a63034c000000b0050fa35d9dd2mr4976084pgd.4.1680056310934; Tue, 28 Mar
 2023 19:18:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7300:ba90:b0:b2:67c:e1c7 with HTTP; Tue, 28 Mar 2023
 19:18:30 -0700 (PDT)
Reply-To: davidllawrence15@gmail.com
From:   "Mrs. Nelson Philip" <johnkimani3744@gmail.com>
Date:   Tue, 28 Mar 2023 19:18:30 -0700
Message-ID: <CANseNOy1QGvFWNnfMr74+XgjObfOxQqwJoSFyRRdb=JAoekEvQ@mail.gmail.com>
Subject: Your Bank Draft is ready for delivery!!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,
        MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_FREEM,UNDISC_MONEY,XFER_LOTSA_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:42f listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [johnkimani3744[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [johnkimani3744[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [davidllawrence15[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.1 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.5 XFER_LOTSA_MONEY Transfer a lot of money
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

How are you

I want to inform you that I have succeeded in transferring
the huge amount of funds under the cooperation of the new
partner from London and I have written a Bank Draft of $1.9M for
you.

Have you received it? In-case you have not, Contact Mr.
David Lawrence And Ask him for the Bank draft which I kept
for Compensation okay. His email address
(davidllawrence@consultant.com)Phone+:+1(945)212-0126

Mrs. Ester Nelson Philipsxxxxx
