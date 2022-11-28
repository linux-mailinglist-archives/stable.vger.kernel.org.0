Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B6763AAA6
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 15:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiK1OP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 09:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbiK1OP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 09:15:57 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02386659A
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 06:15:57 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id v81so11671247oie.5
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 06:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Yi1nwdZVcovrN/errUXXhZeN1eR0+sBJVw3FsjfBv6g=;
        b=ZAJO8EdVYffgKxiBh1HTJxs8NC5i/b68YI6kzILMhFFbMnCh1OlTjf53owVVx7S+yX
         teLgyaOdFMSTz3V9UUVyn8RfcbiiMUZmqDc7DYwPmptNJ3RhUSeRw6BqyGQrmyLO6+N5
         rOWRxU2YzGJtLf4BD6QZE0/9AkAFMJCuSn/ua3tz0nIfodnQo9tbh+CxUZu2lCs2RJSz
         jD2evPi1LSdUpKjJJRRwuo8y6RHkiZss0lUCUAAmMDOZCSJVSzWEMgciaLW8Od06cKgU
         DX4ADFfvkDRvBuPEBnQQx3O7AwaAMp3bkaC3s9N1XFlsc1SxDsYumHYs5/32Oe+aS9ZH
         b8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yi1nwdZVcovrN/errUXXhZeN1eR0+sBJVw3FsjfBv6g=;
        b=vl5SmoxmPx4Xt1Mv+Dj17GRACogRRuLX5wYdYXHUD8bQWynwo3wYRCQuoOqCRpBJuA
         NxNiWXVpCuRYV0ZPKjsWFc+IclWwoNgQBx4r9teFMGHEOo5In6+usg1xUfp6Sj64wTpl
         /HV9rWzsq/oW4ILVnyvBbYdZ8ltt4T9EYq+eUzMUpk3JT5OSJoEOtcQRDcxnyXnUCXoG
         HqRgfv/ZaVHJ0sqg0QkZeTTCmEOpJByVriAJZ/xlm/Nx84248fdwCOge7et54UNCzCv3
         RDd2G55hCyPt0hNTb/c7OekKvQ3idgDGSZWp+TVgT7OKl1VCsiS0l2wM+E4XiHid5mcu
         nxsw==
X-Gm-Message-State: ANoB5pnEmzR/Co4FVoyTmDnT4ise91iwsIiOcg/JZZP0sNznOO1rDqLu
        xX0ruo4UQWk8NAlOjebCHrOs9XdOSvfHEV81Ry0=
X-Google-Smtp-Source: AA0mqf6UV31EAQY+l4rJad7Cg6QuI1h7dRyR4wye++ZYO3MtpPCISN5sPZ53tNAJFfyW75lLd3OEumRmo1/VwHwQYrY=
X-Received: by 2002:a05:6808:1996:b0:35a:303a:6ddf with SMTP id
 bj22-20020a056808199600b0035a303a6ddfmr14806791oib.113.1669644956261; Mon, 28
 Nov 2022 06:15:56 -0800 (PST)
MIME-Version: 1.0
Reply-To: sgtkalamanthey@gmail.com
Sender: idrissouawali01@gmail.com
Received: by 2002:a05:6358:492:b0:df:4ab4:8a49 with HTTP; Mon, 28 Nov 2022
 06:15:55 -0800 (PST)
From:   kala manthey <sgtkalamanthey@gmail.com>
Date:   Mon, 28 Nov 2022 06:15:55 -0800
X-Google-Sender-Auth: f7c7rf3x5gcLj-CVAVDxmiNEZ8I
Message-ID: <CAHxH4frOCZZAeojx0KR-tPY_fFWyESp2HckxfjsP4Of7bAu9kg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

0JfQtNGA0LDQstC10LksINC/0L7Qu9GD0YfQuCDQu9C4INGB0YrQvtCx0YnQtdC90LjRj9GC0LAg
0LzQuD8g0LzQvtC70Y8sINC/0YDQvtCy0LXRgNC10YLQtSDQuCDQvNC4INC+0YLQs9C+0LLQvtGA
0LXRgtC1DQo=
