Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A315224E3
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 21:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiEJTjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 15:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiEJTj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 15:39:29 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68AA21B160
        for <stable@vger.kernel.org>; Tue, 10 May 2022 12:39:28 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id 185so135867qke.7
        for <stable@vger.kernel.org>; Tue, 10 May 2022 12:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=EqQuaW4ldsNwQbNX/j4XAPJipRx6qa+pTBplUl7uQzY=;
        b=QRq5M0Mqb4oj0/7M9grQe2VjW9lx8HHXdJqahL+oPsOqwSpu0YnH+I2D477k+ysj3P
         YEuRvXGvemA3omYhdjOq2NUylSUldRV7ga5tHSqUmCDLP1HSHDwObrALGCvs1t3jw6Ue
         L4ljVTjoj9PXsBMsdQzwfZrhKMozUV2tt6L+j8bEn95avaP94dTK40s9Qb65ksIOHQAj
         5WHycEydQsjt+mx295wXk1/Z9Z7Uj4M2rlH9AONjt7AyTeZ532RR1+X+gwoAVLymOEmS
         U48VZRin4GeDC+4sU7ox1/TIn0ipWpkyC5RJ6eV2K1Md4CaC0E0Z4URgrH7W8LxxZwi+
         kpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=EqQuaW4ldsNwQbNX/j4XAPJipRx6qa+pTBplUl7uQzY=;
        b=aqZ/mEJ8IiEuuzYES5Y5VD8Gw77cmp//do21v7aPzx1bJ8bN9Z5kCE5uWf3nWqu358
         TgV+nXAL2tsH8Oi4ww8Lv7VdJEqljesLP3ccpu78v7hUR1+pMXH7f+mXmntA9O+9F84s
         +NXED81NNYDFXTjZlYEpjW5V50bP0fEdarNmxiH4T8T4KpIw8sA76Lz2vA5RK3Sv1Oyw
         eg9NRVDe7uOLeZEgZ0B4eWJW0pEMZbkAnWRnaPUiLYYerP62PVaYPuB1kkRxr7cbCbae
         WQZkTdU9IY9K8Z4gKuvOz1gJ7GdZy5kXXEKSLvTMUB9hpD3gd0t9q+71QNMY5oj9DKTk
         Y8SA==
X-Gm-Message-State: AOAM531JP8syGKXRV7DIHozvxYaoOFdgGWCzezPQs4uSyOurnGQWwHDw
        mOo3lpWHJloGmOoCtXaNgBjo5p+3zsBq5Ix4U5Q=
X-Google-Smtp-Source: ABdhPJybpoxe68z8omqgNdNWWP4HlTLqfQyq/sSH/IcGUXzrIUJHR9yabum8R4AnGay0/qCg0+/uHbEmW/gssKSk91k=
X-Received: by 2002:a37:4549:0:b0:69f:556c:4e38 with SMTP id
 s70-20020a374549000000b0069f556c4e38mr16492988qka.202.1652211567835; Tue, 10
 May 2022 12:39:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ad4:5cc1:0:0:0:0:0 with HTTP; Tue, 10 May 2022 12:39:27
 -0700 (PDT)
Reply-To: srelpaul.sarl@gmail.com
From:   Paul Isreal <isrelpaul.sarl@gmail.com>
Date:   Tue, 10 May 2022 19:39:27 +0000
Message-ID: <CACUauhqZS1mjAq2OxRrFdPrNoxQbWEhoy+FZ0JAk=Qj9TaK4cw@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:72c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5183]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [isrelpaul.sarl[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My name is Paul Isreal a broker from Republic of Togo, My client is
interested to invest in Transportation business, Tourism, Real Estate
business, Agriculture, Health  sector or any other business you have
or may propose in your country.

 Please  reply for more information only if you are interested.

  Mr Paul Isreal
