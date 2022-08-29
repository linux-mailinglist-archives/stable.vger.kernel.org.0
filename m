Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECDA45A51B6
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 18:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiH2Q3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 12:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiH2Q3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 12:29:39 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398E599B5E
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 09:29:38 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id n125so8857978vsc.5
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 09:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc;
        bh=Iv5nNGWCwNlNiJx3DoFKzKxN4CE9D+undPjRSuz6lA8=;
        b=iSIN3Vef/wS5AfIwEXNoh5b4YSyFLGNDQyvB9PGw7FLPqwYlacxfCllJ6V0tEe3nci
         43GsC34dJXaVd04XvEQJPnCjzIUb2nO2UHxVqs2OaSsdK0t2V1TCRo23PDHTwz88+z6n
         LSTch8y1RLFuISJZUrwf+UlHBWl6gh8QAOpO556haQEjuxRPUbodHqU83v+iNLOg58QO
         AywaZ1tdfVHE9r4XgKBgd1BJZtY0uNHxMd4D5byMtS1W57+6cY3w6Mw9yR5xfSkoU6vB
         B1vUYVNz4pDJjYr7GQXM59PR3CCYKlpWivhOaIthXw1PFsgSazP10B2yRjrx2ePIn6Zw
         w8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Iv5nNGWCwNlNiJx3DoFKzKxN4CE9D+undPjRSuz6lA8=;
        b=7ALcQN2n/XvVcm46g/IHE+JpLPUqOGDSzvrd8EhPa2i7/6y8RzU2eyeioqk80q0qGb
         KUfPnCkaPDSOrRLXbf310nlhiVaaUjMwJcsW6AOyxmnaWKoStotIVcd0xLf5ElofpPdY
         dYeRKmuJIw40mgBkxb/zCkFCfoWb0iNbJVd1e1n0LHSQV6Lpuzf2KmOpv2crQ+rXB+bJ
         NpGpgOIjmuGBQU0FTLSFzIsqjOBXK9mv25sO0BKI4Ab4II5GvbNj9S0+fiOJ5BH0PxW7
         Sy7BkBgXCgQMhXmbL3XOwzQyilgU91G3Kb3QaSOXb+Axcw7kgozYjqPpJSEBzsFw6QER
         G77g==
X-Gm-Message-State: ACgBeo19Su98jtPrYs5v5g1RBo/QbY1x2ik5e8bRFcP22rhnsu0kelbY
        hZ/MCuIqpKotS8QUvDx6r18mtzWz/Jouy8+NZP8=
X-Google-Smtp-Source: AA6agR60/I5SFTYkUE1Wrbqw0z2B3u4EmiJefIUyw48PLdpmnUB8nSCFvQRu4ZEKWeNpkEBa/nD/DVz8GdBE0HntL84=
X-Received: by 2002:a67:e110:0:b0:390:cf7b:2a1b with SMTP id
 d16-20020a67e110000000b00390cf7b2a1bmr2828157vsl.57.1661790577268; Mon, 29
 Aug 2022 09:29:37 -0700 (PDT)
MIME-Version: 1.0
Sender: lubaojuakaligroup@gmail.com
Received: by 2002:a05:6130:64c:0:0:0:0 with HTTP; Mon, 29 Aug 2022 09:29:36
 -0700 (PDT)
From:   RIchard wahl <richardwahll505@gmail.com>
Date:   Mon, 29 Aug 2022 09:29:36 -0700
X-Google-Sender-Auth: fe-fbJNLY3-G9h30eIsQ_QJ6i4g
Message-ID: <CACq4zpVgxcYf4XuSDSRKss5WE5z4EAAGHcffwo6VxMo++ZGdXw@mail.gmail.com>
Subject: =?UTF-8?Q?Ich_habe_dir_ungef=C3=A4hr_3_E=2DMails_geschickt?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20

Hallo guten Tag
Sie haben eine Spende in einer bestimmten H=C3=B6he erhalten. Ich warte auf
Ihre Antwort, um das Geld an Sie zu senden.
