Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E83D4D4FE1
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 18:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244119AbiCJRGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 12:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243847AbiCJRGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 12:06:45 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A0A1520D7
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 09:05:43 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id r22so8651657ljd.4
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 09:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=RdhdttfNLkLtZ03kR2j5poIKYaB3WsiZ1uKB3ECTa+I=;
        b=S5Q9iBzS6uwsyqELVBkKEn9PoAI8AkxFqXJraFCcPW2lXhJUm6uqHr1FVJoDbrWgda
         hR6K4uAOF2n3iiUJUCUgjE4gbZ6JboLaHQdJ8LIIfAtf08i+rJ6Nx/aXKdIqBL+lpP8/
         2R4JOywxvJTeD58n0Spgavb/wQUChZwiCFelB6+2qXnTYfxK7L8HUlzx+wDq+ulWZ/B+
         mGkiE5eC/a3/KW0ebA8UC+2dpsHVPpV2xf7r2yoJ6oaT9+kNEWKc08sbjLijXLHP9oGS
         I0KYXe9L6P5raavrSc4LVEcneX17kKHj8fVjhU7BvfoN4pKoo9qHNuPThx604EzEid+u
         kG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=RdhdttfNLkLtZ03kR2j5poIKYaB3WsiZ1uKB3ECTa+I=;
        b=B+OOTyObkRGi+QFmdcxb8cukoHJ3hoWU7s7oUpRKJhyZAjqpUHiA1zbjsPIH7dBLQk
         y8iocnI8BaSBQEYVV96wAw33RbZO9TYBMNYDx6IyO0FydkzvgQsa6duECg8hLb+lh8V8
         +Uzlasrz92/2ceFCPMIU+8zqrhMzLNTsDS8OOPa7edCsJ/4xXAjBk/UTfgPVb1CzuTBb
         M6zdiv5N61Fe/eQkIBwnVjPETtlVrorzesQMi5BycoG1ohpz9jJ530zuEc3sqSX+BXh+
         X9IM+iJNqieB5Va5AP+8XldDm5qCpQ4aV/ga+vpHzm+VzCRUSsPj3rqISVU1K0pRJySL
         cUrg==
X-Gm-Message-State: AOAM533s9g5yBJ17AO1MNOQmmX6z1x4cl4WzQ9IWaVWujnX6lXe+Rl2G
        IbvD6TXSg5DMMmFWkEKjkwx+Thx49jtdgFi70RY=
X-Google-Smtp-Source: ABdhPJxgh2ev1A8BZMTF2xtHQd/2voHq+mGmw99M9WTAWejG2uEs7RhhPufGCoTcJNdPhlknGygSE7qve1YJNwE8Z6M=
X-Received: by 2002:a2e:aa14:0:b0:245:fd1d:4eba with SMTP id
 bf20-20020a2eaa14000000b00245fd1d4ebamr3584207ljb.425.1646931941639; Thu, 10
 Mar 2022 09:05:41 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6512:39c6:0:0:0:0 with HTTP; Thu, 10 Mar 2022 09:05:41
 -0800 (PST)
Reply-To: gorharvey@gmail.com
From:   GORDON HARVEY <richardthalerr@gmail.com>
Date:   Thu, 10 Mar 2022 09:05:41 -0800
Message-ID: <CACQvd5W_uDLCsWmN=wRMMqoCgkw=_O5BmOjM-KRaLk7xTjvAkQ@mail.gmail.com>
Subject: UPDATE US
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.2 required=5.0 tests=BAYES_50,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:234 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4595]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [richardthalerr[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Sir or Madam,
We would be very grateful if you could take a moment to leave feedback
to us, if you received our email dated 4th March 2022 to you.
Best regards.
Gordon Harvey.
