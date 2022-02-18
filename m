Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5683F4BC2C6
	for <lists+stable@lfdr.de>; Sat, 19 Feb 2022 00:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiBRXMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 18:12:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbiBRXMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 18:12:15 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5459367361
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 15:11:57 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f17so17983638edd.2
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 15:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=vq2wqdheyxMmznSe99YXJygIKxvGHffu8io9pJ/N0Ys=;
        b=EYddoeDp2KiUG9SKsMrt81jcb5fy2AeTh6GXi4dXXcHM1mLtzOfq9kX1VtfHF8U/gr
         CW5dWTaqV5BlDmgkDybWxGYv1vczwQt3JGOnLnWYxNKEli4JMM7roYlPybP4+ZH2HAoF
         5heUpFz6t00wq/BrcGOR9Gu33v15yTBZCVx4+Lup1dkHwKXPncMpwNSkQBQ/bo4VfoP9
         xiZ8qAkL84WI3FRPukUxk/yqibhF98mDQHcyzDRel5fild8TnqVEddEdeAtTX51Gyu0r
         ytzq0rNVFCB/b1MwreqWtoctqpGOIXHUGI3srN30z9QNNXkiI3GfZ2hWZMG0l9JmFviP
         i5Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=vq2wqdheyxMmznSe99YXJygIKxvGHffu8io9pJ/N0Ys=;
        b=vf1qCe7mJnM1SN02bZ9ILrb0W2Ug/3qRkT0Oibx50zw5HlTCkloFQbl+R+WiN9QZEX
         nynRnypnTxIPzwi+lUBpG+NiOnTy0IpXqfOv7GMYy4rIOeHeTv0bPA0nXejeSG5jBnGa
         1tuDwzs8hnm7QVIlxO94sTTaGIDXzXCC2U1IQWVJPLGya+1JOlcX8gssUKoJMwfo6NP/
         y3rl3iDDGQ9M74b3OLM3VmNYZAd1sNOmJsmzvxFuiNXfhBw2Goth9a6Svi6K93SfRyZG
         7a/yhq1yrCnjWfm8mBBTTYqbI9d2ORaIErQrVKBiDx1WiTizOZ6S+hNBLw4rpgp4Kn9y
         fQLQ==
X-Gm-Message-State: AOAM531oCnBYUOgdlziR5p9JKl6GSooTunu+sH+OzStCc7PanzzG4JR9
        9jMd7a5eJR39+OJ+MNB+NPVRmEH1OPF4RoWli8E=
X-Google-Smtp-Source: ABdhPJzGn08ESmzIThS4Qy7+2GVr2Vwi55l3AWG9DisYk4RQhtpLFlcL+UnA411owVxhX5h4t7LRbWFgB0WM5GxIlfU=
X-Received: by 2002:a05:6402:5ca:b0:410:a59d:69e7 with SMTP id
 n10-20020a05640205ca00b00410a59d69e7mr10714058edx.337.1645225915954; Fri, 18
 Feb 2022 15:11:55 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:907:33c6:0:0:0:0 with HTTP; Fri, 18 Feb 2022 15:11:55
 -0800 (PST)
Reply-To: gregg@kenedyfunding.com
From:   Gregg Wolfer <skyfinanceinsurancecompany@gmail.com>
Date:   Sat, 19 Feb 2022 04:41:55 +0530
Message-ID: <CAEeWSk8x1SD4ocHTKb9jc0pnsgA=OR8SvjJqDe2CqYi05LN96A@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_50,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Sir/Madam,

Do you need a loan? If yes contact us today, we offer all kinds of
loan such as Personal Loan, Mortgage Loan, Real Estate Loan, Company
Loan, Investment Loan, Business Loan, Debt Consolidation loan and lot
more at 2% interest rate. If interested contact us for more info.


Gregg Wolfer
Chief Operating Officer

Kennedy Funding
267 South Dean Sreet
Englewood, NJ 07631
P: 979-773-8662
E: gregg@kenedyfunding.com
www.kennedyfunding.com
