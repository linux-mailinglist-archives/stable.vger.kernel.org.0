Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916A954061C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbiFGRd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348265AbiFGRbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:44 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7B81203EE
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 10:29:50 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x17so25129367wrg.6
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 10:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=FiBrJHe4O7a1jVjDC6KDblj58lHTisWp/3XyOE41fEU=;
        b=M/9t51/UEgEg6LqaqR1SuwjcUXW8GgXLLeaQbPckgY/kxvcq5x23a92r9e5k2Nj4BW
         PLAieD9XMnVXHRGrPFT8vujFQHou9cro9/E6+qrm59oa6hOXe8h515p95TAW3gOHm0Rn
         5qFhxAkJqO+4Rsfs7fG51T1Ru+ZQtOMeSAfYqwLRy9NL++QgXkDQNshpjB+yYgAorD4J
         X2cvgEynRuU/v+JKynJG+KSNCjJqK2iLZv7wv5xSLDmvpBaedm9QRkL+maNCA6M5T+6n
         i2iBm9jSfZLrM/lihu5pMra7EeSYklHNID6CsCodRpP2PCkYJ3+Jxxe2+MCEAP0Irwa3
         TLng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=FiBrJHe4O7a1jVjDC6KDblj58lHTisWp/3XyOE41fEU=;
        b=2p9RNiqSQKUjB7K1mUPUeayWNZ3WUt7HicSWzAjxgGK9paAf4j/5BF6aNHPC3jpHOs
         1NTXN41rNoHsevKDKRwH8CRyBoYg5YIBV3Us+bTmeK4smZtsJf+cvIcNgRRSyRw0ttCr
         vj9VOHoXFjTBFgmCxncOB2+3qsGz0trThiIzeGZe/ZAczKIdfc4iIHFLG87shlBvb9nj
         jDuQmz03KwiU20TsY/v2JhmIhVYRzCfSEVC3LUpZFmOB+LbpZts48oAQRPTEp4daqkCf
         lpbyv3qcsXwAxK0wTGTnMD8z4ZSSlA8GXTEMg8p3y9oUMNQe9r9MlcFgof00h+S21Bn6
         HClw==
X-Gm-Message-State: AOAM5306YLysOrpk0pZyi4EmWhJK4vp//74qydmN+r7q+zGcsNi1FUow
        gEOrmiumGsCQUfY5gDqlC1FXol/EcphkCJGPmIE=
X-Google-Smtp-Source: ABdhPJxaZ425qzNQW5JJQsmDVkbvc+NxRaSDZVXNtChnI3RsbijYTAfM6ORtXZp95IUrRClKF5PRedKPnejybdT+GfQ=
X-Received: by 2002:adf:fb47:0:b0:20c:de00:a96a with SMTP id
 c7-20020adffb47000000b0020cde00a96amr28937118wrs.376.1654622988671; Tue, 07
 Jun 2022 10:29:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a7b:c44c:0:0:0:0:0 with HTTP; Tue, 7 Jun 2022 10:29:48 -0700 (PDT)
Reply-To: u022957@gmail.com
From:   Janeth Utuah <seynaboudiouf755@gmail.com>
Date:   Tue, 7 Jun 2022 18:29:48 +0100
Message-ID: <CAJLqW3MorOtooO_oCKM_uaLm4Q+uQZ6MdOSkbywmJ_tyVQXQrg@mail.gmail.com>
Subject: Greetings from Janeth !!!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings!!

I am Janeth Utuah.

I need your support to relocate and invest in your country.
I ask for your help because I don't have knowledge about business and
the rules that guide your country for a safe investment.

Will you promise to be sincere with me?

Please contact me for more details!

Kind regards,
Janeth
