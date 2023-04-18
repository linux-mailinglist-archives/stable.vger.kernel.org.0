Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48446E5D48
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 11:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjDRJZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 05:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjDRJZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 05:25:42 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F135BA7
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 02:25:39 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-187e176e5e2so270967fac.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 02:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681809939; x=1684401939;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qNVI/u+vlE2iSYnBudk/aivP1bgPbzvxDOvNGrnVEw8=;
        b=eJ+jSHQRQdFcwUducfurVGTaxs0dwiAQtqed4XLF8T6bXdhDgSKxPd9waoBHU7fqo0
         d+KXX9xpy8xJgkkcwJrqag0RraFJhPmG20rvVk5MOKfSS7vUkjOHxFngQ5pIX+po7GJ6
         0zZOn5RkoOcQQfU5Im0y98yztgCjS1TazfDQiTrrRX4jLXdu9rOC1n3spubbr13QRvVc
         OmQ/D5zq5bGrXyjlAqKDO6Y/MCQonogprQYOm3synH745TPgVOvB/U/U3I0HhCZ6xNdz
         N74GDymCOUchuXPui5Uyg3RhmBGeajbOXZRgLx/rWIErXMB/qkg+95QB3IHEtNhxoyLD
         7dyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681809939; x=1684401939;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qNVI/u+vlE2iSYnBudk/aivP1bgPbzvxDOvNGrnVEw8=;
        b=H10UuLhwGyB+VoVGm+EtkmE1E3ZNdsDs9sWI2v7NnmCo4UneOew5zkMhDJw4G7RCkc
         h72NAMIBciGKbvNrY9nxHShAVk73yY3+INFu+KsFrCzGryVrCH4ZYtGUnLH5E3vJ7Png
         sk0ly3iowohAKlCfwueZPlK9MlvPAqe9HpoUcpYj1TkaXIDEdxWJAYVaZDCZy3wBrYPt
         a0DA9gmoB7g1U3AIh54wG/NSe4VXcy9S7CMlos/1YsFOWF1+3cQHYCLFIsFVo8gNh+my
         ZVX2Oej7+/YzBoHRPZAXMdR3Hlx3JpCt8ht9qIGd7Ywv77jS/o/YMH62ED/IXjH+zTca
         cyTQ==
X-Gm-Message-State: AAQBX9fyuxKX7XY1cYs8bXsAm4Ah6ZU/8NX/N8ivksI92m2VGpoO5ZY2
        cNzEBR2ePU4UBGsP49XaJArn8JSz4bTGxBIzA9A=
X-Google-Smtp-Source: AKy350bDAH1NMkizzs5NpFMMTFkKfqRe97qFAOFrHQvE/zwYIVQlSzJ0l4259XMHZ5Spg5yjtJa6N+4bcK5WD7bh1P0=
X-Received: by 2002:a05:6870:11cf:b0:184:95f:c74e with SMTP id
 15-20020a05687011cf00b00184095fc74emr754244oav.3.1681809939046; Tue, 18 Apr
 2023 02:25:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:9223:b0:104:1d78:2dfb with HTTP; Tue, 18 Apr 2023
 02:25:38 -0700 (PDT)
Reply-To: ninacoulibaly03@hotmail.com
From:   nina coulibaly <ninacoulibaly.info@gmail.com>
Date:   Tue, 18 Apr 2023 02:25:38 -0700
Message-ID: <CABAHEt5KZ5VZxAyoTJsFS0eezugVP3ZrELgJdJ8=PTCTWvwMQw@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear,

I am interested to invest with you in your  country with total trust
and I hope you will give me total support, sincerity and commitment.
Please get back to me as soon as possible so that I can give you my
proposed details of funding and others.

Best Regards.

Mrs Nina Coulibaly
