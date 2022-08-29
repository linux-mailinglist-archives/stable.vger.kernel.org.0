Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB5F5A4FE4
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 17:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiH2PKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 11:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiH2PKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 11:10:30 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9625C1FCF7
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 08:10:28 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id 190so8614263vsz.7
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 08:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=K9e/+Bi/vvPDR+Rmtf7TW8R+0O/rOmfsDh0rHaOZIQ8=;
        b=FjZe/QCRb/LBbdEapqSc4I6mNjmswkQHyFXTO0aN9mr3VfutAtY8zCbnUJ+Xycs2kb
         9ZcWL58sIj9aul6qvQmrhwz8McaDbGqeTJlrSpN+41J+Dicd18piaojD5HuNrBViFTmd
         DeEbrAdQDuSS6ApYTUa1qZy9bKJiER4agA8MHoSC/vh+Hdcmcv7B1iH/7w+wKxCyZN8q
         1PBHny7DZwgTI6R683tIbIL7bNmAE/ut71AARC01bmi7BjZw2TO6HquKZ1Fvluu7kOXx
         ifF0uQyJ9RnZRN78d9qARoR/5lEjRYzSHye6KIKZcVz2v9T9WSVciRI7kAr4ZUBoLTJj
         YQeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=K9e/+Bi/vvPDR+Rmtf7TW8R+0O/rOmfsDh0rHaOZIQ8=;
        b=qCDa5rpMhmWasLjmzGxKsl8tDGx9BywWUk+SVJCG/IaIqHbfmaR+z+vHc0mSMJzz6G
         sDF6V4tfvuXOKoRqqC9oGetnHg2jXy1IrtqXQ6IiDuc7lYZgNBs9KoJFWXaJHGSDXeHL
         YHIUpHf+fhl7YAEJN0oG4RXJIL/AjF9NF+dDMhyr0cJdrVFYl5fL9z4MUjF4x3uLX/MP
         8UcbHmV1ZYrMG+XOuz6t6GtdL+wh8iqsnX2n8W0f4P9wNhTtDRaA9tjETP78Kalf2WbO
         wyP8Aex6RPPLtVeRbpmTaeCBC1oFtg4MJ7mO+jLpbEDLBwZA+h+xuC1ZqU5uuzs1i0bM
         Mdag==
X-Gm-Message-State: ACgBeo1PBlCNP8ngobRAmOOENKjIpaPIFfjbzeI2qxstMcfmjEX8Ok9e
        +JhLhRB1e5UeaAmLhjzgMgVcq4L5YD2QE1MqolU=
X-Google-Smtp-Source: AA6agR7rQmGMD/dxxlN7spVSx1dOGB5ZKhhPUBIANEIiQeP+6NADxGbP4Y5oQNHHW3bjBCliJRCWVxYcsP4ZGyd5udA=
X-Received: by 2002:a05:6102:214f:b0:390:e4f1:1a78 with SMTP id
 h15-20020a056102214f00b00390e4f11a78mr1105708vsg.45.1661785827636; Mon, 29
 Aug 2022 08:10:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6130:a12:0:0:0:0 with HTTP; Mon, 29 Aug 2022 08:10:27
 -0700 (PDT)
From:   Dennis Franklin <dfrank001usa@gmail.com>
Date:   Mon, 29 Aug 2022 18:10:27 +0300
Message-ID: <CAEBcpApdJ+bELMsWtogdEs2DUxcD-TeaWcSUqugu23rrnnkPWw@mail.gmail.com>
Subject: Respond Urgently.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear,

I am  Dennis Franklin  a retired civil servant i have a  business to
discuss with you from the Eastern part of Africa aimed at agreed
percentage upon your acceptance of my hand in business and friendship.
Kindly respond to me if you are interested to partner with me for an
update.Very important.

Yours Sincerely,
Dennis Franklin.
Reply to John Peters: jpeters@accountant.com
