Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E9367D684
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 21:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbjAZUg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 15:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbjAZUgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 15:36:55 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A0A728C8
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 12:36:45 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id i17so1283055ila.9
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 12:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OWhJIofVr/6gu5NCTEzXWKxcS9eVTsCRck1bu1Cy2YY=;
        b=M5aRB+h8KN9Pr7mS7tbekuKn6RHCZgQLddIRmhovCWkUU6qkhkO/gY2bVhUySSksjk
         8sblRDcSWmzEy6mz3tYZFyJ3SP38N5qrf2epf1SzvNVCjwUieqvmaBedFg+vy3KSlrG2
         koB6CUWfTgHDzU+4AvC2o35/7WUZ9RjtV0frqoO+I7ZUqqZxgcb4PUfs7czn0Jiel4hd
         5EjY0qjzIGyatjDhx29o0AYixyLfigD3ndFZGmMYpDbQd93FcFlBwQDHp7JLZ96Vdo/Q
         zwWrxTdJjTDaUApoIF5i5kO0934/4bnl+qVGrPLEudeIp9EPvLR4cmuGLJmSTTE/GrLF
         vOkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OWhJIofVr/6gu5NCTEzXWKxcS9eVTsCRck1bu1Cy2YY=;
        b=PN2RD6Q8ErnT1L5wEkSLQRmjwO+kCMdoKpDdTkBMK5MUQ3RmaCBQaJQtqQBxHs62Rm
         Kn0L+xz2hLiTu6sGeMj3+fOTeC7rpX61NDg5uWDaPWZ9aFSDWjwXPH1r1BpuAvmm27tX
         r1y2IN3jF56NotOj6sGCqoZjhqcRKxvu8IRmmolFsewZhn4ag0GpP8zgxfTed0FAysVF
         0m0Gyc65fMZYOjQPxbq6BN18sThHcoZomKn5XetivVCNhShbtujoSJD1p+JqXk3LWNQ9
         zD75cQwx0LSz0aYmiAVRbI1aQxny7w4WZxIYpYhwy9EqjedIpwRxCO4BBmKzSMSB52Xa
         387g==
X-Gm-Message-State: AFqh2kqgthiqnY01KakbACionR4OrEu15SFfDuTSeAjqN9quXC5rIwiw
        keXXTuJflTsE+mcx6Y28xuPnqcuThVSi/uUqUkw=
X-Google-Smtp-Source: AMrXdXspEomOJLPVmYd73KXisUkAx8dhx6tkBzlsO+mYUAR3IKM+ZQ8QFeawIbnYj6ih5diKTmtUpZDmoP6PPP7DdjQ=
X-Received: by 2002:a05:6e02:ca4:b0:30d:899f:aecb with SMTP id
 4-20020a056e020ca400b0030d899faecbmr3564122ilg.168.1674765404810; Thu, 26 Jan
 2023 12:36:44 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6638:144e:b0:39e:7daa:a585 with HTTP; Thu, 26 Jan 2023
 12:36:44 -0800 (PST)
Reply-To: katiehiggins5554567@gmail.com
From:   Katie Higgins <rosecollin12346@gmail.com>
Date:   Thu, 26 Jan 2023 12:36:44 -0800
Message-ID: <CAOR2nU_eu3_9B0A69wdLbx7AQjdjppbQ9a4fzXf9Or-YNKSPrA@mail.gmail.com>
Subject: Dear friend
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_50,DEAR_FRIEND,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:131 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5025]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [katiehiggins5554567[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [rosecollin12346[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [rosecollin12346[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear,
Please kindly let me know if you received my previous message
