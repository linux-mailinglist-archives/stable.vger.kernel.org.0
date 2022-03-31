Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2924ED732
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 11:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbiCaJqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 05:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbiCaJqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 05:46:39 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE413DDF7
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 02:44:51 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id p10so34591564lfa.12
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 02:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=NM2286H2sEFmH0Lv8AT4bB+kXqSxceJ0iQg8oG0/2u4=;
        b=lr7Gri+Nths5PcFtA/02ewL+nLgXL6nGSTPU9WU064n3SVr6VYsMIWXDfYtJ61jsZ5
         X8MbCCTtL05tW7PtoXnDRdskyErO8xWxr9FXU566LPHqX1y6rB3fqUcJuJ9ISzr/Veq5
         93iWTw5PUiNXPW/6Pe7hhlhdcHLysEih7k6QIdcAh17M7QR2PS8XCPdzED7mIN63lMj4
         txVjxm7DIW5uhmGtEE1RLA+GNrxx8Tez225uqU5qY9i+KGO5dZaU+aUBonp43CFa/usR
         NuoYEOCLjd4cQi1FMlD7KRcA1XYTs/LHEs1mJAVgkXs0D6nLFeLg7kaauqaordSBJewt
         4puw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=NM2286H2sEFmH0Lv8AT4bB+kXqSxceJ0iQg8oG0/2u4=;
        b=ApqV1xPESr5x68KcGAcO2kXFvOBqZEJCREKn8VFRIvFWcMKoStRF3U9VDrFXErwA1y
         lrrqyz/xbn14gZe4GJ5pLwM/8Fuo9MctQ8fc0lD54QKSfU5plQko9aMXQn7RE9/i6iru
         kS8Q5TswplLskpdo5easB8rY8mKaWgCJNQ/b9arMrK7oGEyOMY9zybHISPHAt4DQytAV
         X/z3MycehSh7O76xXcek8JQkO89XOL4n51g0vCwlCpBjTEK+YwN0+Ehs8Q46hlKNf/NB
         00m4n/4IcXNVbYbP2DXXbergxpM5RSTnuKm/W/ZDYSWELorkE5ksvRitOZxPu+0mrfpy
         eMHA==
X-Gm-Message-State: AOAM5306b+8k2uC5MEVnZotyVWjEnG2Zh3nzRwpmuckIZAUylXINpUGl
        p4+R9bfHLbU8MSGRQRKqUS6FFm7tmZ8HdsGFa+E=
X-Google-Smtp-Source: ABdhPJxGc7LejNMjoq3FltfnJQdcqsmqRB935K7uRACf2Y6fiZ0l5rBqM2ATTExCGixFDU7xnUpZs3SqpR2HsE9ohL0=
X-Received: by 2002:a19:5e1c:0:b0:44a:143e:ba3b with SMTP id
 s28-20020a195e1c000000b0044a143eba3bmr10225777lfb.137.1648719889680; Thu, 31
 Mar 2022 02:44:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:6e0b:0:0:0:0:0 with HTTP; Thu, 31 Mar 2022 02:44:49
 -0700 (PDT)
Reply-To: worldbankinternational002@aol.com
In-Reply-To: <CAPP0n-s_rr7rxE1P5P=4EfW9bOv8ZOpXfW9k0=VFrLgXUvmVZQ@mail.gmail.com>
References: <CAPP0n-thRR5OpSRrwYkPbWK_9KWayMFs2oDHYJ0sgkUFcBPCHQ@mail.gmail.com>
 <CAPP0n-s_rr7rxE1P5P=4EfW9bOv8ZOpXfW9k0=VFrLgXUvmVZQ@mail.gmail.com>
From:   Ora bank <ericbarry946@gmail.com>
Date:   Thu, 31 Mar 2022 09:44:49 +0000
Message-ID: <CAPP0n-vjONFWf=n_s+tP+5Qh9G7i-5Pm7vNOSzjZEuHTdeBJ7A@mail.gmail.com>
Subject: evening
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_05,DKIM_SIGNED,
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

2KLbjNinINmG2KfZhdmHINm+24zYsdmI2LLbjCDYrtmI2K8g2LHYpyDYr9ix24zYp9mB2Kog2qnY
sdiv2Ycg2KfbjNivINqp2Ycg2LTZhdinINix2Kcg2KfYsiDYt9ix24zZgiDYotiv2LHYsyDYp9uM
2YXbjNmEDQo2LDUwMCDZhduM2YTbjNmI2YYg2K/ZhNin2LHbjCDYtNmF2Kcg2LHYp9mH2YbZhdin
24zbjCDZhduMINqp2YbYr9ifDQoNCjEpINin2YbYqtmC2KfZhCDYp9iyINio2KfZhtqpINio2Ycg
2KjYp9mG2qkuDQoyKSDYqtit2YjbjNmEINin2qnYs9m+2LHYsyBBVE0NCg==
