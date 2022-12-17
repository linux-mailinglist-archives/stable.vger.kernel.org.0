Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4805A64F923
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 14:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiLQNx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 08:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiLQNx1 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sat, 17 Dec 2022 08:53:27 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA35E13F1D
        for <Stable@vger.kernel.org>; Sat, 17 Dec 2022 05:53:25 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id c7so4858661qtw.8
        for <Stable@vger.kernel.org>; Sat, 17 Dec 2022 05:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=CZU36O8CLfgby+5KfU0HIWiFT6/ES/nAFon6gK/6m//5pkHD5C2QqYhRt6RgR06Fp8
         xEZoWZGdssgCe0CeGQlS8N4la7zGcK8UcXd9Kclr3yz0S3+dBRhCYwTRhJnn2G/e1y/0
         dGKjFwZWMyTkgo36jm/cHD2bdU4bEQFVZVApjF2PfFhaiwwn+E6qz/DdDqE/zk9INy5S
         zNJG7/bRh59O/rGyV5Oawj3MeP3Rr3+lDO/630EHd2vaelBDA8Iv+E+Usui+UJ0/WFoa
         S9xG4SCOV/am0Av0aFeYV9BdpOGnIxoSmqmIqCvzVCBD/3bHOCqj0qGZlXe3TQumN44n
         mPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=A5ZtjIivPm1gpqtCcx93nLTUx8kw7CJFEsrVrNLIp+xmUTCuUcJ8shHsxEDPQGBYuF
         tn6/uH62WjsTIAVzuwdnmk+MsN5g9HNp6Uir2gEMOhJ7Cm8/zWnPOzgcTope0Yj/78Pc
         AyX2SHETMrKhMVKu0Wqy5KQarCrFxthbuV7ZGf8AZO8rhVY6Obb71WrkAbiBo9KyBacy
         kWGz/3nr+Dp/OWHYpgzeOwmPlKtC8hSjyI6Ak8wuylFRgYsjiZy6M3XxkbYKhAL6zLRX
         vWYdjkPU/FxROfJ0M9XD4A6ceBNNEmm4HRC9lDbpWg97cc5B1HBBRgrt7IVkjl/xTfRU
         uVVQ==
X-Gm-Message-State: ANoB5pnNzElO8h/m3zf1ROH6zFEF/L5dLKgqBNNyhxL1Kk9967y10vxy
        axZscikd2MfKOBXeV2QH5VmlCDqN/xTGw94E9kg=
X-Google-Smtp-Source: AA0mqf4XZPYuuDiEiE6MNsIBFfUgOno9/8TXEF61WREm5tAP07Bj/IH7AQ/EKqkYk5fotQ7dR0LdzPdWVF/4WPZ4WZA=
X-Received: by 2002:a05:622a:98b:b0:3a8:17bc:3c5 with SMTP id
 bw11-20020a05622a098b00b003a817bc03c5mr895559qtb.127.1671285204959; Sat, 17
 Dec 2022 05:53:24 -0800 (PST)
MIME-Version: 1.0
Sender: asfiss2018@gmail.com
Received: by 2002:a05:622a:38f:0:0:0:0 with HTTP; Sat, 17 Dec 2022 05:53:24
 -0800 (PST)
From:   John Kumor <a45476306@gmail.com>
Date:   Sat, 17 Dec 2022 13:53:24 +0000
X-Google-Sender-Auth: 99R6m2oYrjNxwuYY6gnQge8WqD8
Message-ID: <CAMhHx792FzSQWy_E_8ki17gDszJkaDchkuhC4HO4MuxA07yKwQ@mail.gmail.com>
Subject: Kindly reply back.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings!!
Did you receive my previous email?
Regards,
John Kumor,
