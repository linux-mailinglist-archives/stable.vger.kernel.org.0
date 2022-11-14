Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6B66277D1
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 09:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbiKNIfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 03:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiKNIfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 03:35:03 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEAE1B1D9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 00:35:02 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id d185so10745860vsd.0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 00:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=AxNHH73jPbX6TT5np2q2KFvTHERuVXKorRlANgG6wOaqapG0LhgrzRAO5iuKyPWTOF
         u7KYcJ71/wvb8ezilBjuNbcMm5LgfGQEBkrt3CSMTVoVfQ8ZTEpWU1wyFX30z6MT7RMY
         SUy2Py4ChKN8hy/WZF27eu9/q3KD2Eyxk+UpI23By2dv/0Ikj9t87MbtVSU/8hMJGtCj
         EzPW7jPffBGdW7oKIHCed/wNrpLzSMaiNbZpxKg7ExDLx6L/4o+jDwJZ3SL9kC6cGRZK
         G1VXgwboHx98i/Td4/gxhl3pkWNSiJFnHXQ/buroyco2bFeaQYpU4sHaaOmAI0wr3cvd
         cfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=AzR8myf00cMtA3j1v4GeqB1jdxauR7k6QJk//XjcH9+dX4TUjfxHSzkDV9tWKDUmsm
         4v1rgXhwLr2X1+XFRNcMSBtZk4p/i63fS6fA2U3/YpAxqov+gbCQ6BRN83zyhfVM4ia6
         ETLXflNZNKW+gI2GA/l1JWbq2BA8DYiHKdaqoqE3P+O1rTZa+6wQ77Kpvp6zSlTZIV2a
         QVf58u0qxlOnhtXfYXHA2lQJ360EH2H/VsWCKp3DjWhakcbsgcuGZ0R0ysEMsyevOqcc
         DH/OnZeVR2bTvO4r1kJQTPzDCYmtB/3qTk/F2pyvv1ynfqd1N9cDklVLsxT/xKjeQTqM
         DquA==
X-Gm-Message-State: ANoB5png5j/nOH4gofFdsGaFGUzRPI3s5LImiErybT8+DNNoUafxJVwa
        cCccS9tMX64lCSk+ppllCG28s47dIlq2twIEwEw=
X-Google-Smtp-Source: AA0mqf7lGK/4qtr9D1NoCm2/ECq3llETf3ChtmMKpmYR/XIA8Jc7rEY9oL+psscArmMqA4gUM0ZzrsubxL9Qj+Nbgqc=
X-Received: by 2002:a67:ec03:0:b0:3ab:8a0a:a4ae with SMTP id
 d3-20020a67ec03000000b003ab8a0aa4aemr5943701vso.21.1668414901735; Mon, 14 Nov
 2022 00:35:01 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:612c:258e:b0:324:168c:a70e with HTTP; Mon, 14 Nov 2022
 00:35:01 -0800 (PST)
Reply-To: subik7633@gmail.com
From:   Susan Bikram <sb9174937@gmail.com>
Date:   Mon, 14 Nov 2022 00:35:01 -0800
Message-ID: <CACRXfQ8MHzgBMpOd925Z+2tCOfarwKwPjrukYpd-XyCc0HfSWg@mail.gmail.com>
Subject: Please can i have your attention
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e36 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [subik7633[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sb9174937[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [sb9174937[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear ,

Please can I have your attention and possibly help me for humanity's
sake please. I am writing this message with a heavy heart filled with
sorrows and sadness.
Please if you can respond, i have an issue that i will be most
grateful if you could help me deal with it please.

Susan
