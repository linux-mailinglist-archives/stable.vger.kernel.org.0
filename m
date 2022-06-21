Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F9E552FDC
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiFUKgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347464AbiFUKgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:36:41 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7431F28E11
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:36:40 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id e40so6195731eda.2
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=X8u7Pwl8XdeOB0MA6I66SwjfgWSjlS7aSpJDG6h1QUw=;
        b=GRivq/wiLGywcMKoGTUb0j0kirM6HTHQ47U+iur/7ws9h78nMbMLnzhNcTNfNz5goI
         zGQvqnfWtCjuIhmVOdKVkJJG/KNiSJDbjmQMJBFq2rUZIx5Lg8GA6odq7l1suOmMIlCL
         PCPRf3bXKjeJWLMo+1nk1cV6oCy5tlrHf7wQPpvTTIPAJbgPeeuCG9+yv+sI7XemmaFi
         FGfKu4xCwwj5YBZ2Dsdv569lbdoKwwRziyrwj6MoyZ328U7cI4OAio8qOajDPva4c63i
         ciKve9YoGFvrMrLclw0cf1k/MzjdImqGlQrWe/nHlCjvJzzUxjS8WTHEarmqG2qbFbL9
         aeGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=X8u7Pwl8XdeOB0MA6I66SwjfgWSjlS7aSpJDG6h1QUw=;
        b=oolqdxuyO9nzsl+zyXlnPB84amFTdsYAFVo5cbeZLvp913Jbm6v5MOmsG6Z+jb3/K4
         RhxkL3U7nJpcNssicslhgBMVO/dSy2nQXVf6FhI5MMe6R2cSkarvdGplT6VWHMlz9ct8
         1NT8BZ08HO9xG8kEAhQ8oGLwg3d/j3WWhA52gNMHMXwb3JmAtJlf+o0700lBhiEx3TP4
         IIV62aXZdT6pbXyQzqou7NBXEH2PpZuTDqDYOaFAHjaoYEgrvDGjYOyjehWLUUBp0Oo3
         +8/nhpuqA4V5vINTqvcXuf9ACmGYJ0H4UVEvpcBOn137GgZCJ8QMNfTBcbslkebwj8N3
         a0ng==
X-Gm-Message-State: AJIora/3zssfQ1Eck8Qoxv4z5wWUNRzXxg/mwm8z3Ot9ZUgHZ5hlxB1w
        pZ5BSC6LFavzEE/ih3I7Px7F2QtIeQfblHTqiC0=
X-Google-Smtp-Source: AGRyM1u3esapmQg/22QvPZEXeOGelG+2AACzOZfnlcDSq1jaN2atc0WG8oEgd+y3GWmTR7wyYMWA+d0V8H4Xm8+g7do=
X-Received: by 2002:a05:6402:320f:b0:435:7236:e312 with SMTP id
 g15-20020a056402320f00b004357236e312mr18674582eda.115.1655807798763; Tue, 21
 Jun 2022 03:36:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab4:a566:0:0:0:0:0 with HTTP; Tue, 21 Jun 2022 03:36:38
 -0700 (PDT)
Reply-To: dewaleadeyemo448@gmail.com
From:   Dewale Adeyemo <badjajeanne@gmail.com>
Date:   Tue, 21 Jun 2022 11:36:38 +0100
Message-ID: <CAOTJS7uvq80icpQdMraB4PctTGFBYqFk8Dgp4Uw5MjZdmZUifw@mail.gmail.com>
Subject: hjy
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,HK_SCAM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good morning dear friend, Please have you received your compensation money?
